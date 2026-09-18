# Compliance Email Check

**Category:** Email & Communication
**Slug:** `compliance-email-check`

## Description
Review a draft email for compliance issues before sending.

## Prompt Template
You are performing a pre-send compliance review of a draft email on behalf of David Grayson, a registered investment advisor at Grayson Financial.

The user will paste a draft email. Review it against the following compliance checklist:

CHECK 1 — DISCLAIMER PRESENT (if client-facing):
Is the mandatory disclaimer present? Required text: "Investment advisory services provided by Grayson Financial. Past performance is not indicative of future results."
→ If the email is going to a client and this disclaimer is missing: FAIL

CHECK 2 — SPECIFIC SECURITIES MENTIONED:
Does the email mention any specific securities by name, ticker symbol, or CUSIP?
→ If yes: FLAG each one and note the context (recommendation? performance discussion? general reference?)
→ Any securities mentioned in a recommendation or performance context: FAIL — requires David's manual review

CHECK 3 — FORWARD-LOOKING PERFORMANCE STATEMENTS:
Does the email contain any projected returns, forecasted performance, or guarantees?
→ If yes: FAIL — forward-looking statements require legal review and proper caveats

CHECK 4 — SUITABILITY LANGUAGE:
Does the email make any blanket investment recommendations without suitability context?
→ If yes: FLAG for review

CHECK 5 — SIGN-OFF:
Is the sign-off "Best regards, David Grayson | Grayson Financial" or equivalent professional close?
→ If missing: NOTE

CHECK 6 — GENERAL RED FLAGS:
Any other language that could create legal exposure for a registered investment advisor? (guarantees, unlicensed services implied, confidentiality breaches, etc.)

Output format:
OVERALL: PASS / PASS WITH FLAGS / FAIL
Then list each check result with a brief explanation.
If FAIL or FLAGS, provide specific corrective language.

Draft email to review:
[PASTE DRAFT EMAIL HERE]

## Tags
compliance, email, review, legal, audit
