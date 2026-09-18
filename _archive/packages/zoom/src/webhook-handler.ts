import { Router, Request, Response } from 'express'
import crypto from 'crypto'
import { processMeetingRecording } from './pipeline.js'
import type { ZoomWebhookEvent } from './types.js'

/**
 * Validates the Zoom webhook signature using HMAC-SHA256.
 * Zoom sends: v=0,ts=<timestamp>,v0=<hash>
 * We recompute HMAC-SHA256("v0:<timestamp>:<body>", secret) and compare.
 */
export function validateZoomSignature(req: Request): boolean {
  const secret = process.env.ZOOM_WEBHOOK_SECRET
  if (!secret) {
    console.error('[zoom/webhook] ZOOM_WEBHOOK_SECRET is not set')
    return false
  }

  const signature = req.headers['x-zm-signature'] as string | undefined
  const requestTimestamp = req.headers['x-zm-request-timestamp'] as string | undefined

  if (!signature || !requestTimestamp) {
    console.warn('[zoom/webhook] Missing signature or timestamp headers')
    return false
  }

  // Reject requests older than 5 minutes to prevent replay attacks
  const tsMs = parseInt(requestTimestamp, 10) * 1000
  if (Date.now() - tsMs > 5 * 60 * 1000) {
    console.warn('[zoom/webhook] Request timestamp too old — possible replay attack')
    return false
  }

  const rawBody: string =
    typeof req.body === 'string'
      ? req.body
      : JSON.stringify(req.body)

  const message = `v0:${requestTimestamp}:${rawBody}`
  const expected = `v0=${crypto
    .createHmac('sha256', secret)
    .update(message)
    .digest('hex')}`

  // Constant-time comparison to prevent timing attacks
  try {
    return crypto.timingSafeEqual(
      Buffer.from(signature),
      Buffer.from(expected),
    )
  } catch {
    return false
  }
}

/**
 * Creates and returns an Express router handling Zoom webhook events.
 *
 * POST /zoom/webhook:
 *   - Validates HMAC-SHA256 signature immediately
 *   - Responds 200 right away (Zoom requires fast ACK)
 *   - Queues heavy processing asynchronously
 */
export function createWebhookRouter(): Router {
  const router = Router()

  // Zoom sends JSON; we need the raw body for signature validation.
  // Callers must mount express.json() before this router, or use the
  // rawBody trick. We support both: if req.body is already parsed we
  // re-stringify it above.
  router.post('/zoom/webhook', (req: Request, res: Response) => {
    // --- Security: validate signature FIRST, before any processing ---
    if (!validateZoomSignature(req)) {
      console.warn('[zoom/webhook] Invalid signature — rejecting request')
      res.status(401).json({ error: 'Invalid signature' })
      return
    }

    const event = req.body as ZoomWebhookEvent

    // Zoom URL-validation challenge (required when first registering webhook)
    if (event.event === 'endpoint.url_validation') {
      const plainToken =
        ((event.payload as unknown as Record<string, string>)['plainToken']) ?? ''
      const secret = process.env.ZOOM_WEBHOOK_SECRET ?? ''
      const encryptedToken = crypto
        .createHmac('sha256', secret)
        .update(plainToken)
        .digest('hex')
      res.status(200).json({ plainToken, encryptedToken })
      return
    }

    // ACK immediately — Zoom requires a response within a few seconds
    res.status(200).json({ received: true })

    // Queue async processing (fire-and-forget; errors logged internally)
    setImmediate(() => {
      handleWebhookEvent(event).catch((err: unknown) => {
        console.error('[zoom/webhook] Unhandled error in async handler:', err)
      })
    })
  })

  return router
}

async function handleWebhookEvent(event: ZoomWebhookEvent): Promise<void> {
  const { event: eventType, payload } = event

  switch (eventType) {
    case 'recording.completed': {
      const meeting = payload.object
      console.log(
        `[zoom/webhook] recording.completed — meetingId=${meeting.id} uuid=${meeting.uuid} topic="${meeting.topic}"`,
      )
      await processMeetingRecording(event)
      break
    }

    case 'meeting.ended': {
      const meeting = payload.object
      console.log(
        `[zoom/webhook] meeting.ended — meetingId=${meeting.id} topic="${meeting.topic}" startTime=${meeting.start_time}`,
      )
      // Recording processing will come separately via recording.completed
      break
    }

    default:
      console.log(`[zoom/webhook] Unhandled event type: ${eventType}`)
  }
}
