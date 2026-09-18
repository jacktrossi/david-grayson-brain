import Anthropic from '@anthropic-ai/sdk'
import type { ClassifiedEmail, EmailClassification } from './types.js'

const client = new Anthropic()

const SYSTEM_PROMPT = `You are the nervous system of David Grayson, a financial advisor.
Classify each email and extract structured data. Reply with JSON only, no prose.

Classification rules:
- "meeting": contains a meeting invite, calendar invite, "let's meet", "call scheduled", time + date + attendees, .ics attachment reference
- "deadline": contains a hard deadline ("due by", "must respond by", "expires", "action required by [date]")
- "urgent": from a known client (Smith Capital, Harris Group, Mercer), subject contains URGENT/ASAP/time-sensitive, legal notice, IRS/regulatory
- "routine": everything else

For meetings, extract title, date, time, zoom link if present.
For deadlines, extract the date.`

type ClassifierResult = {
  classification: EmailClassification
  isHighPriority: boolean
  extractedTitle?: string
  extractedDateTime?: string // ISO string
  summary: string
}

export async function classifyEmail(
  subject: string,
  from: string,
  body: string,
): Promise<ClassifierResult> {
  const msg = await client.messages.create({
    model: 'claude-sonnet-4-6',
    max_tokens: 512,
    system: SYSTEM_PROMPT,
    messages: [
      {
        role: 'user',
        content: `Subject: ${subject}\nFrom: ${from}\n\nBody:\n${body.slice(0, 3000)}`,
      },
    ],
  })

  const text = msg.content[0].type === 'text' ? msg.content[0].text : '{}'
  try {
    const jsonMatch = text.match(/\{[\s\S]*\}/)
    if (!jsonMatch) throw new Error('no json')
    return JSON.parse(jsonMatch[0]) as ClassifierResult
  } catch {
    return {
      classification: 'routine',
      isHighPriority: false,
      summary: subject,
    }
  }
}

export async function classifyBatch(emails: ClassifiedEmail[]): Promise<ClassifiedEmail[]> {
  return Promise.all(
    emails.map(async (email) => {
      const result = await classifyEmail(email.subject, email.fromAddress, email.body)
      return {
        ...email,
        classification: result.classification,
        isHighPriority: result.isHighPriority,
        extractedTitle: result.extractedTitle,
        extractedDateTime: result.extractedDateTime ? new Date(result.extractedDateTime) : undefined,
      }
    })
  )
}
