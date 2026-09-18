# Flight Options Brief

**Category:** Travel
**Slug:** `flight-options-brief`

## Description
Structure a flight search brief based on David's travel preferences.

## Prompt Template
You are generating a flight search brief for David Grayson, Principal at Grayson Financial to hand to a travel agent or use directly in a booking tool.

Collect or use the following inputs:
- Origin city/airport
- Destination city/airport
- Travel date (outbound)
- Return date (if round trip)
- Any meeting times or schedule constraints at destination

Generate the brief using David's confirmed travel preferences:

---
# FLIGHT SEARCH BRIEF
Route: [Origin] → [Destination]
Travel Date: [Outbound date]
Return Date: [Return date or "One-way"]

## Search Parameters

### Preferred Airline
- First choice: Delta Air Lines
- Loyalty: SkyMiles — apply number when booking (stored in Vault)
- If Delta not available or significantly worse option: [Note alternative]

### Cabin Class
- [Determine based on flight duration:]
  - Flights under 3 hours: Economy (or Comfort+)
  - Flights 3 hours or longer: Business class
- [Estimated flight time: X hours based on route — confirm at booking]

### Seat Preference
- Aisle seat — mandatory preference
- Preferred: Aisle in first few rows of cabin

### TSA PreCheck
- David is enrolled — always select TSA PreCheck lane
- Ensure Known Traveler Number (KTN) is applied to reservation (stored in Vault)

### Departure Window
- Preferred: [If schedule constraints provided — e.g., "must arrive by 2pm for 3pm meeting" — suggest latest viable departure]
- Avoid red-eye if possible unless necessary for schedule

### Connection Preference
- Direct flight preferred
- Minimum connection time if connecting: 60 minutes domestic, 90 minutes international
- Avoid connections through high-delay hubs if direct is available

### Return Window
- [Based on any provided schedule constraints or default: afternoon departure on return date]

## Schedule Notes
[If meeting times were provided — note what arrival time is needed and what departure times are viable]

## Booking Instructions
- Apply SkyMiles number to reservation
- Apply KTN (TSA PreCheck) to reservation
- Select aisle seat at booking
- Add trip to Travel calendar (account6) after booking
---

## Tags
travel, flights, booking, delta, logistics
