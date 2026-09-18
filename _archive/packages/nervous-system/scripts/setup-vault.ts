/**
 * One-time vault setup. Run this when sitting with David:
 *   pnpm --filter @graysonos/nervous-system tsx scripts/setup-vault.ts
 *
 * Only SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY need to be in .env.
 * Everything else gets stored encrypted in Supabase Vault.
 */

import { createClient } from '@supabase/supabase-js'
import * as readline from 'node:readline/promises'
import { stdin as input, stdout as output } from 'node:process'

const supabase = createClient(
  process.env.SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!,
)

const rl = readline.createInterface({ input, output })

async function prompt(question: string, sensitive = false): Promise<string> {
  if (sensitive) {
    // Hide input for sensitive values
    output.write(question)
    return new Promise(resolve => {
      let value = ''
      input.setRawMode(true)
      input.resume()
      input.on('data', function handler(char) {
        const c = char.toString()
        if (c === '\r' || c === '\n') {
          input.setRawMode(false)
          input.removeListener('data', handler)
          output.write('\n')
          resolve(value)
        } else if (c === '') {
          process.exit()
        } else if (c === '') {
          value = value.slice(0, -1)
        } else {
          value += c
        }
      })
    })
  }
  return rl.question(question)
}

async function storeSecret(name: string, value: string) {
  if (!value.trim()) {
    console.log(`  ⏭  Skipped (left blank)`)
    return
  }

  // Upsert: delete existing then insert
  await supabase.rpc('vault.delete_secret', { secret_name: name }).maybeSingle()

  const { error } = await supabase.rpc('vault.create_secret', {
    secret: value.trim(),
    name,
  })

  if (error) {
    // Try direct insert as fallback
    const { error: insertError } = await supabase
      .schema('vault')
      .from('secrets')
      .upsert({ name, secret: value.trim() }, { onConflict: 'name' })

    if (insertError) {
      console.error(`  ✗  Failed to store ${name}: ${insertError.message}`)
      return
    }
  }

  console.log(`  ✓  Stored`)
}

async function main() {
  console.log('\nGraysonOS — Vault Setup')
  console.log('═══════════════════════════════════════')
  console.log('This stores all secrets encrypted in Supabase.')
  console.log('Only SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY stay in .env\n')

  // Anthropic
  console.log('── Anthropic ──────────────────────────')
  console.log('Get your key at: console.anthropic.com → API Keys')
  const anthropicKey = await prompt('Anthropic API Key: ', true)
  await storeSecret('anthropic_api_key', anthropicKey)

  // Gmail OAuth client
  console.log('\n── Gmail OAuth Client ─────────────────')
  console.log('One OAuth client works for all 8 accounts.')
  console.log('Get these at: console.cloud.google.com → APIs → Credentials')
  const gmailClientId = await prompt('Gmail OAuth Client ID: ', true)
  await storeSecret('gmail_client_id', gmailClientId)
  const gmailClientSecret = await prompt('Gmail OAuth Client Secret: ', true)
  await storeSecret('gmail_client_secret', gmailClientSecret)

  // Gmail refresh tokens (8 accounts)
  console.log('\n── Gmail Refresh Tokens (8 accounts) ──')
  console.log("Run `tsx scripts/gmail-auth.ts` to get each token.")
  console.log("Leave blank for accounts you're not ready to connect yet.\n")

  const accountLabels = [
    'personal',
    'client-facing',
    'legal',
    'investments',
    'admin',
    'travel',
    'domains',
    'finance-pro',
  ]

  for (let i = 1; i <= 8; i++) {
    const token = await prompt(`Account ${i} (${accountLabels[i - 1]}) refresh token: `, true)
    await storeSecret(`gmail_account_${i}_refresh_token`, token)
  }

  // Google Calendar
  console.log('\n── Google Calendar ────────────────────')
  console.log('Can reuse the same OAuth client as Gmail.')
  console.log('Run `tsx scripts/gcal-auth.ts` to get a Calendar refresh token.')
  const gcalToken = await prompt('Google Calendar refresh token: ', true)
  await storeSecret('gcal_refresh_token', gcalToken)
  await storeSecret('gcal_client_id', gmailClientId)     // reuse Gmail client
  await storeSecret('gcal_client_secret', gmailClientSecret)

  // Alert email
  console.log('\n── Alert Destination ──────────────────')
  console.log("Where GraysonOS emails David when something needs attention.")
  const alertEmail = await prompt("David's primary email address: ")
  await storeSecret('alert_to_email', alertEmail)

  rl.close()

  console.log('\n═══════════════════════════════════════')
  console.log('✓ Vault setup complete.')
  console.log("Run `pnpm dev` to start the nervous system.\n")
}

main().catch(err => {
  console.error('Setup failed:', err.message)
  process.exit(1)
})
