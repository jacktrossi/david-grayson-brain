import { createClient } from '@supabase/supabase-js'

// Only these two come from the environment — everything else lives in Supabase Vault
const supabase = createClient(
  process.env.SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!,
)

type Secrets = {
  ANTHROPIC_API_KEY: string
  GMAIL_CLIENT_ID: string
  GMAIL_CLIENT_SECRET: string
  GMAIL_ACCOUNT_1_REFRESH_TOKEN: string
  GMAIL_ACCOUNT_2_REFRESH_TOKEN: string
  GMAIL_ACCOUNT_3_REFRESH_TOKEN: string
  GMAIL_ACCOUNT_4_REFRESH_TOKEN: string
  GMAIL_ACCOUNT_5_REFRESH_TOKEN: string
  GMAIL_ACCOUNT_6_REFRESH_TOKEN: string
  GMAIL_ACCOUNT_7_REFRESH_TOKEN: string
  GMAIL_ACCOUNT_8_REFRESH_TOKEN: string
  GCAL_CLIENT_ID: string
  GCAL_CLIENT_SECRET: string
  GCAL_REFRESH_TOKEN: string
  ALERT_TO_EMAIL: string
}

let loaded = false

export async function loadSecrets(): Promise<void> {
  if (loaded) return

  const { data, error } = await supabase
    .from('vault.decrypted_secrets')
    .select('name, decrypted_secret')

  if (error) {
    throw new Error(`Failed to load secrets from Vault: ${error.message}`)
  }

  if (!data || data.length === 0) {
    throw new Error(
      'No secrets found in Supabase Vault. Run the setup script first:\n' +
      '  pnpm --filter @graysonos/nervous-system setup'
    )
  }

  for (const row of data) {
    if (row.name && row.decrypted_secret) {
      process.env[row.name.toUpperCase()] = row.decrypted_secret
    }
  }

  // Verify all required secrets are present
  const required: Array<keyof Secrets> = [
    'ANTHROPIC_API_KEY',
    'GMAIL_CLIENT_ID',
    'GMAIL_CLIENT_SECRET',
    'GCAL_REFRESH_TOKEN',
    'ALERT_TO_EMAIL',
  ]
  const missing = required.filter(k => !process.env[k])
  if (missing.length > 0) {
    console.warn(`Warning: missing secrets in Vault: ${missing.join(', ')}`)
  }

  loaded = true
}
