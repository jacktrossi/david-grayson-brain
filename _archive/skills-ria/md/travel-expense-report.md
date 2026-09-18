# Travel Expense Report

**Category:** Travel
**Slug:** `travel-expense-report`

## Description
Compile and categorize travel expenses from a completed trip.

## Prompt Template
You are compiling a travel expense report for David Grayson, Principal at Grayson Financial.

The user will provide a list of expenses, receipts, or raw notes from a completed trip. Organize them into a structured expense report.

---
# TRAVEL EXPENSE REPORT
Trip: [Destination]
Travel Dates: [From] → [To]
Purpose: [Business / Personal / Mixed]
Report Date: [Today's date]

## Expense Detail

### Transportation
| Date | Description | Vendor | Amount | Business? | Notes |
[List all: flights, taxis, rideshares, car rentals, parking, tolls, trains]
Subtotal: $[X]

### Lodging
| Date | Description | Vendor | Amount | Business? | Notes |
[List all hotel nights, Airbnb, etc.]
Subtotal: $[X]

### Meals & Entertainment
| Date | Description | Vendor | Amount | Business? | Attendees | Notes |
[List all meals — note if client entertainment (who attended?)]
Subtotal: $[X]

### Business Incidentals
| Date | Description | Vendor | Amount | Business? | Notes |
[Conference fees, printing, office supplies, business gifts, etc.]
Subtotal: $[X]

### Personal Expenses (Non-Reimbursable)
| Date | Description | Amount |
[Any clearly personal items — for transparency in reporting]
Subtotal: $[X]

## Summary
| Category | Amount |
|---|---|
| Transportation | $[X] |
| Lodging | $[X] |
| Meals & Entertainment | $[X] |
| Business Incidentals | $[X] |
| Total Business Expenses | $[X] |
| Personal (non-reimbursable) | $[X] |

## Potential Tax Deductions
[Note any expenses that are likely 100% business deductible: flights, hotel, client meals (50% meals rule applies), conference fees]

## Missing Receipts
[Flag any expense items where no receipt was provided — these will need documentation for tax purposes]

## Notes for Accounting
[Any special categorization notes, split business/personal items, or items requiring clarification]
---

Paste expense list or receipts below:
[PASTE EXPENSES HERE]

## Tags
travel, expenses, accounting, finance, reporting
