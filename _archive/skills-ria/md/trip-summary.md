# Trip Summary

**Category:** Travel
**Slug:** `trip-summary`

## Description
Compile all details for an upcoming trip into one clean briefing.

## Prompt Template
You are generating a complete trip briefing for David Grayson, Principal at Grayson Financial.

Collect or use the following inputs:
- Destination (city, country if international)
- Travel dates (departure and return)
- Purpose of the trip (client meetings, conference, personal, etc.)
- Any specific meetings or events scheduled during the trip (optional)

Generate the trip brief using David's known travel preferences:
- Preferred airline: Delta (SkyMiles loyalty — # in Vault)
- Seat preference: Aisle seat always
- Cabin: Business class for flights >3 hours; Economy for short-haul
- TSA PreCheck: Always select — enrolled
- Preferred hotel: Marriott (Bonvoy loyalty — # in Vault)
- Car rental: National Car Rental (Emerald Club)
- Meal preference: No dietary restrictions

---
# TRIP BRIEF: [Destination]
Dates: [Departure] → [Return]
Purpose: [Business / Personal / Mixed]

## Flight Summary
- Preferred carrier: Delta Air Lines (SkyMiles)
- Cabin: [Business if >3hrs / Economy if short-haul — based on destination]
- Seat: Aisle seat
- TSA PreCheck: Yes — select PreCheck lane
- Loyalty: Apply SkyMiles number (stored in Vault)
- Departure window preference: [Note if provided, otherwise "flexible"]

## Hotel
- Preferred chain: Marriott (Bonvoy loyalty — apply number from Vault)
- Check-in: [Departure date]
- Check-out: [Return date]
- Room type: Standard King (unless meeting venue requires proximity)
- [Note any proximity requirements if meetings are known]

## Ground Transportation
- Car rental: National Car Rental — Emerald Club preferred
- [Or note if airport transfer / rideshare is more appropriate for the destination]

## Trip Details
- Local time zone: [Destination timezone vs. David's home timezone]
- Weather: [General seasonal expectation — note to check forecast closer to travel]

## Meeting / Event Schedule
[If meetings are provided — list with date, time, location, and who they're with]

## Pre-Travel Checklist
- [ ] Flights confirmed — seat selected (aisle), loyalty number applied
- [ ] Hotel confirmed — Bonvoy number applied
- [ ] Car rental confirmed — Emerald Club applied
- [ ] Travel confirmed on Travel calendar (account6)
- [ ] Any client meetings added to Client Meetings calendar (account2)
- [ ] Passport current (if international)
- [ ] Global Entry / TSA PreCheck — confirm enrollment active
- [ ] Out-of-office set if needed

## Packing Reminders
[Business trip: Business attire for client days + casual for travel days / Conference: Bring business cards / International: Adapter, currency]
---

## Tags
travel, trip, brief, planning, logistics
