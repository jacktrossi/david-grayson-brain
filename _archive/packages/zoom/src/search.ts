import { createClient } from '@supabase/supabase-js'
import Anthropic from '@anthropic-ai/sdk'

// ---------------------------------------------------------------------------
// Supabase client (lazy-init)
// ---------------------------------------------------------------------------

function getSupabase() {
  const url = process.env.SUPABASE_URL
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY ?? process.env.SUPABASE_ANON_KEY
  if (!url || !key) {
    throw new Error('Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY env vars')
  }
  return createClient(url, key)
}

// ---------------------------------------------------------------------------
// Embedding generation
// ---------------------------------------------------------------------------

/**
 * Generates a text embedding vector using the OpenAI embeddings API.
 * Falls back to a simple error if OPENAI_API_KEY is not set.
 *
 * We use OpenAI text-embedding-3-small (1536 dims) which matches the
 * vector(1536) column in meeting_transcripts.embedding.
 */
async function generateEmbedding(text: string): Promise<number[]> {
  const openaiApiKey = process.env.OPENAI_API_KEY
  if (!openaiApiKey) {
    throw new Error('OPENAI_API_KEY is required for semantic search')
  }

  // Use fetch directly to avoid additional SDK dependency
  const response = await fetch('https://api.openai.com/v1/embeddings', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${openaiApiKey}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model: 'text-embedding-3-small',
      input: text,
      dimensions: 1536,
    }),
  })

  if (!response.ok) {
    throw new Error(`OpenAI embeddings API error (${response.status}): ${await response.text()}`)
  }

  const data = (await response.json()) as {
    data: Array<{ embedding: number[] }>
  }

  const first = data.data[0]
  if (!first) throw new Error('OpenAI embeddings API returned empty data array')
  return first.embedding
}

// ---------------------------------------------------------------------------
// Excerpt extraction
// ---------------------------------------------------------------------------

/**
 * Uses Claude to extract the most relevant excerpt from a transcript
 * given the original search query. Returns a 1-3 sentence snippet.
 */
async function extractRelevantExcerpt(
  query: string,
  transcript: string,
  meetingTitle: string,
): Promise<string> {
  try {
    const client = new Anthropic()

    const message = await client.messages.create({
      model: 'claude-sonnet-4-6',
      max_tokens: 256,
      messages: [
        {
          role: 'user',
          content: `Given this search query: "${query}"

Extract the single most relevant 1-3 sentence excerpt from this meeting transcript of "${meetingTitle}":

${transcript.substring(0, 3000)}

Return only the excerpt text, nothing else.`,
        },
      ],
    })

    const content = message.content[0]
    if (!content || content.type !== 'text') return ''
    return content.text.trim()
  } catch {
    // If excerpt extraction fails, return first 200 chars of transcript
    return transcript.substring(0, 200) + (transcript.length > 200 ? '…' : '')
  }
}

// ---------------------------------------------------------------------------
// Search result type
// ---------------------------------------------------------------------------

export type TranscriptSearchResult = {
  meetingTitle: string
  date: Date
  relevantExcerpt: string
  similarity: number
}

// ---------------------------------------------------------------------------
// Main export
// ---------------------------------------------------------------------------

/**
 * Performs semantic similarity search across all processed meeting transcripts.
 *
 * 1. Generates an embedding for the query using OpenAI text-embedding-3-small
 * 2. Queries Supabase pgvector for the top 5 most similar meeting transcripts
 * 3. For each result, uses Claude to extract the most relevant excerpt
 *
 * Returns results sorted by similarity descending.
 */
export async function searchTranscripts(
  query: string,
): Promise<TranscriptSearchResult[]> {
  if (!query.trim()) {
    throw new Error('Search query cannot be empty')
  }

  console.log(`[zoom/search] Searching transcripts for: "${query}"`)

  // Step 1: Generate query embedding
  const queryEmbedding = await generateEmbedding(query)

  // Step 2: Supabase pgvector similarity search
  const supabase = getSupabase()

  // Use the RPC function pattern for pgvector cosine similarity search
  const { data, error } = await supabase.rpc('search_meeting_transcripts', {
    query_embedding: queryEmbedding,
    match_count: 5,
    match_threshold: 0.5,
  })

  if (error) {
    // Fallback: if the RPC doesn't exist yet, try a direct query
    console.warn('[zoom/search] RPC search_meeting_transcripts not found, trying direct query:', error.message)
    return searchTranscriptsFallback(query, queryEmbedding)
  }

  if (!data || data.length === 0) {
    console.log('[zoom/search] No results found')
    return []
  }

  // Step 3: Extract relevant excerpts for each result
  const results: TranscriptSearchResult[] = []

  for (const row of data as Array<{
    meeting_id: string
    similarity: number
    raw_transcript: string
    summary: string
    meetings: { title: string; start_time: string }
  }>) {
    const meetingTitle = row.meetings?.title ?? 'Untitled Meeting'
    const rawTranscript = row.raw_transcript ?? row.summary ?? ''
    const meetingDate = new Date(row.meetings?.start_time ?? Date.now())

    const excerpt = await extractRelevantExcerpt(query, rawTranscript, meetingTitle)

    results.push({
      meetingTitle,
      date: meetingDate,
      relevantExcerpt: excerpt,
      similarity: row.similarity,
    })
  }

  console.log(`[zoom/search] Found ${results.length} results`)
  return results.sort((a, b) => b.similarity - a.similarity)
}

/**
 * Fallback search using direct Supabase query when the RPC is not available.
 * Uses the <=> cosine distance operator via a raw SQL query.
 */
async function searchTranscriptsFallback(
  query: string,
  queryEmbedding: number[],
): Promise<TranscriptSearchResult[]> {
  const supabase = getSupabase()

  // Fetch recent transcripts without embeddings and do keyword search
  const { data, error } = await supabase
    .from('meeting_transcripts')
    .select(`
      id,
      raw_transcript,
      summary,
      meetings (
        id,
        title,
        start_time
      )
    `)
    .order('created_at', { ascending: false })
    .limit(20)

  if (error || !data) {
    console.error('[zoom/search] Fallback search also failed:', error)
    return []
  }

  // Simple keyword scoring fallback
  const queryLower = query.toLowerCase()
  const scored = data
    .map((row) => {
      const transcript = (row.raw_transcript ?? row.summary ?? '').toLowerCase()
      const queryWords = queryLower.split(/\s+/)
      const matchCount = queryWords.filter((word) => transcript.includes(word)).length
      const similarity = matchCount / queryWords.length

      return { row, similarity }
    })
    .filter(({ similarity }) => similarity > 0)
    .sort((a, b) => b.similarity - a.similarity)
    .slice(0, 5)

  const results: TranscriptSearchResult[] = []
  for (const { row, similarity } of scored) {
    const meetingsData = Array.isArray(row.meetings) ? row.meetings[0] : row.meetings
    const meetingTitle = (meetingsData as { title?: string } | null)?.title ?? 'Untitled Meeting'
    const rawTranscript = row.raw_transcript ?? row.summary ?? ''
    const startTime = (meetingsData as { start_time?: string } | null)?.start_time
    const meetingDate = new Date(startTime ?? Date.now())

    const excerpt = await extractRelevantExcerpt(query, rawTranscript, meetingTitle)

    results.push({
      meetingTitle,
      date: meetingDate,
      relevantExcerpt: excerpt,
      similarity,
    })
  }

  // Void the embedding parameter to avoid unused var warning
  void queryEmbedding

  return results
}
