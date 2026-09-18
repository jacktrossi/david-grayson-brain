# Itinerary Review

**Category:** Travel
**Slug:** `itinerary-review`

## Description
Review a travel itinerary and flag any issues or gaps.

## Prompt Template
You are reviewing a travel itinerary for David Grayson, Principal at Grayson Financial. Flag any issues, gaps, or risks before travel.

The user will paste a travel itinerary. Review it against the following checklist:

---
# ITINERARY REVIEW
Review Date: [Today's date]
Trip: [Destination — extract from itinerary]
Travel Dates: [Extract from itinerary]

## Connection Time Check
[Review all flights with connections]
- Flag: Any domestic connection under 60 minutes → TIGHT CONNECTION
- Flag: Any international connection under 90 minutes → TIGHT CONNECTION
- Flag: Any connection through known high-delay airports (JFK, ORD, LAX, EWR in bad weather) → NOTE

## Hotel Confirmation Check
- [ ] Hotel confirmed for each night of travel? Flag any nights without accommodation.
- [ ] Bonvoy loyalty number applied?
- [ ] Check-in time vs. arrival time — will David arrive before or after standard check-in?

## Meeting vs. Travel Time Conflicts
[If meetings are listed in the itinerary:]
- Flag: Any meeting scheduled on the same day as arrival without adequate buffer
- Flag: Any departure on the same day as a meeting that could be cut short
- Flag: Any overseas time zone adjustments that haven't been accounted for in meeting times

## Car Rental Check
- [ ] Car rental confirmed if needed for destination?
- [ ] National Emerald Club applied?
- [ ] Pick-up and drop-off times aligned with flights?

## Loyalty Numbers Applied
- [ ] SkyMiles number on all Delta flights?
- [ ] KTN (TSA PreCheck) on all flights?
- [ ] Bonvoy number on hotel?
- [ ] Emerald Club on car rental?

## Calendar Check
- [ ] All flights on Travel calendar (account6)?
- [ ] All client meetings on Client Meetings calendar (account2)?
- [ ] Hotel check-in/check-out on Travel calendar?

## Gaps Identified
[Any dates or nights where David appears to have no accommodation, no transport, or an unaccounted-for block of time]

## Overall Assessment
[CLEAR — no issues / FLAGS — see items above / ISSUES — specific problems to fix]

## Priority Actions
[Bulleted list of what needs to be fixed or confirmed before travel]
---

Paste itinerary below:
[PASTE ITINERARY HERE]

## Tags
travel, itinerary, review, logistics, audit
