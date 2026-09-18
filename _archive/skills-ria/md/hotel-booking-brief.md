# Hotel Booking Brief

**Category:** Travel
**Slug:** `hotel-booking-brief`

## Description
Structure a hotel booking brief for an upcoming trip.

## Prompt Template
You are generating a hotel booking brief for David Grayson, Principal at Grayson Financial.

Collect or use the following inputs:
- Destination city
- Check-in date
- Check-out date
- Purpose of trip (to help identify proximity requirements)
- Any specific meeting venue or conference location (for proximity planning)

Generate the brief using David's confirmed travel preferences:

---
# HOTEL BOOKING BRIEF
Destination: [City]
Check-In: [Date]
Check-Out: [Date]
Nights: [Number]
Purpose: [Business / Conference / Personal]

## Preferred Hotel Chain
- First choice: Marriott (Bonvoy loyalty program)
  - Loyalty number: Stored in Vault — apply at booking
  - Preferred tier properties: Marriott, Sheraton, Westin, W Hotels, Renaissance, or JW Marriott
- If Marriott not available or practical: Hilton Honors, Hyatt, or independent luxury hotel

## Room Preferences
- Room type: King room (standard or deluxe)
- Floor: Higher floor preferred if available
- Away from: elevators, ice machines, street noise if possible
- Early check-in: Request if arriving before 3pm
- Late check-out: Request if departing after noon

## Location Requirements
[Based on purpose provided:]
- Business / client meetings: [As close as practical to meeting venue or city CBD]
- Conference: [On-site at conference hotel if available; walking distance as fallback]
- Personal: [Based on preferences or itinerary details]

## Business Amenities Required
- [ ] Reliable high-speed WiFi (confirm business-grade, not fee-based)
- [ ] Business center or workspace in room
- [ ] 24-hour fitness center preferred
- [ ] Restaurant on-site or nearby

## Booking Instructions
- Apply Bonvoy loyalty number at booking (stored in Vault)
- Request Bonvoy member rate or Best Available Rate — compare against booking portal
- Request elite benefits if status applies (late check-out, room upgrade, welcome amenity)
- Confirm cancellation policy — flexible cancellation preferred
- Add hotel confirmation to Travel calendar (account6) after booking
- Update trips table in Supabase with confirmation number and details
---

## Tags
travel, hotel, booking, marriott, logistics
