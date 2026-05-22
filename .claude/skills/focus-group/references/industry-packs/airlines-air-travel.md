# Airlines & Air Travel — Industry Pack

Airlines and air travel covers passenger airlines (legacy / network carriers, ultra-low-cost carriers, low-cost carriers, regional and feeder operators), cargo airlines and integrators, car-rental firms in the airport ecosystem, and the rapidly consolidating cruise-line carriers that share much of the same operational and distribution DNA as the airlines. Top pressures right now are post-COVID demand normalization (with leisure peaks moderating and business travel returning unevenly), ancillary-revenue and dynamic-pricing sophistication (where the margin actually lives in a structurally thin-margin business), and the operational-resilience challenge driven by weather, ATC and labor disruption, and the public and DOT scrutiny that follows every operational meltdown. Salesforce engages through the core clouds rather than a dedicated Industries Cloud SKU — Sales Cloud (corporate accounts), Service Cloud, Marketing Cloud, Data Cloud, Loyalty Management, and Experience Cloud — with reference architectures rather than a single "Airline Cloud" SKU. The typical buyer shape is a Chief Commercial Officer or Chief Customer Officer as economic buyer, a VP of Loyalty as champion, and a Director of OCC (Operations Control Center) as the load-bearing operational stakeholder who decides whether the customer-experience promise survives a real IROPS event.

## Grounding prompt (injected into every persona)

### Vocabulary

Air-travel customers speak in PNRs (passenger name records), GDS (Sabre, Amadeus, Travelport), NDC (New Distribution Capability), PSS (passenger service systems — Amadeus Altea, Sabre, Navitaire), ATPCO filings, EMDs (electronic miscellaneous documents), interline and codeshare, IROPS, D0 / A14 / completion factor, ASM / RPM / CASM, load factor, RBD (reservations booking designators), bag fees and ancillary attach, FFP (frequent-flyer program), elite tiers, mileage redemption and dynamic award pricing, OCC / SOC / NOC, MEL deferrals, weight-and-balance, crew rest under FAR 117, ground stops, GDPs (ground delay programs), and FCAs (flow constrained areas). Car-rental adds fleet rotation, utilization, counter-bypass, LDW / CDW, and airport-concession economics. Cruise (smaller share of this pack) brings berths, lower berths, voyage, embarkation, shore excursions, beverage and wifi packages, and onboard revenue. Loyalty Management on Salesforce is real and load-bearing for several airline customers; it covers program design, member benefits, partner earn, and integration with the operational and revenue-management systems.

### Honest objections

The honest objections this sub-vertical raises against generic SaaS pitches are: (1) "Our system of record is a PSS that predates the cloud — show me the integration story, including the real-time messages we need during IROPS, before you show me a journey builder"; (2) "FFP is a P&L commitment; our CFO models the breakage and Treasury co-owns the liability — what is your migration story from our current loyalty platform without re-baselining the liability?"; (3) "Our front-line workforce is hourly, mobile, and high-turnover — your agent-facing experience has to be usable in 30 seconds at a gate, not on a laptop, and it has to keep working when the gate-agent network is degraded".

### Regulatory frame

Compliance and regulatory realities to keep in mind: PCI DSS v4.0 (card data is everywhere); GDPR and the EU's API/PNR directive for passenger-data sharing with authorities; the US DOT consumer-protection regime — the 2024 automatic-refund rule, the tarmac-delay rule, full-fare advertising, the DOT accessible-website rule for airlines now in effect, and ACAA accessibility for air travel; EU Regulation EC 261/2004 for delay and cancellation compensation; APIS / Secure Flight passenger-data sharing for international segments; FAA Part 121 / 135 / 145 for US air operations, EASA equivalents, and ICAO for international; FAR 117 crew-rest rules; FMCSA for ground / car-rental shuttle operations; flag-state and IMO obligations for cruise. Decision-making is committee-driven: Commercial / Loyalty owns the revenue narrative, OCC owns the IROPS reality, IT/Architecture owns the integration constraints, and Legal/Compliance is unusually involved because DOT enforcement risk is genuinely material.

## Customer-type classifier (which sub-industry — legacy carrier, ULCC, LCC, cargo, car rental, or cruise?)

This pack covers six sub-types that share enough vocabulary to live together. Detect from case-insensitive substring match on the customer name + the prompt body:

**Legacy / network carrier (US3 + international flag carriers)** — lead with `reservations-booking-director`, `airline-ops-control-center-lead`, `guest-loyalty-lead`, `ancillary-revenue-manager`, `revenue-management-pricing-scientist`.
- Customer-name patterns: Delta Air Lines, American Airlines, United Airlines, Air Canada, British Airways, Lufthansa, Air France, KLM, Emirates, Qatar Airways, Etihad, Singapore Airlines, Cathay Pacific, ANA, Japan Airlines / JAL, Qantas; substrings: "Airlines", "Airways", IATA 2-letter codes when standalone.
- Prompt patterns: `PSS`, `PNR`, `NDC`, `GDS`, `Sabre`, `Amadeus`, `Travelport`, `Altea`, `OCC`, `D0`, `A14`, `MEL`, `interline`, `codeshare`, `EU 261`, `ATPCO`, `EMD`, `FFP`, `dynamic award`, `Star Alliance`, `oneworld`, `SkyTeam`.

**Ultra-low-cost carrier (ULCC) / low-cost carrier (LCC)** — lead with `ancillary-revenue-manager`, `reservations-booking-director`, `airline-ops-control-center-lead`, `revenue-management-pricing-scientist`.
- Customer-name patterns: ULCC: Spirit, Frontier, Allegiant, Sun Country, Avelo, Breeze; LCC: Southwest, JetBlue, Alaska, Hawaiian; international LCC: Ryanair, easyJet, Wizz Air, IndiGo, AirAsia.
- Prompt patterns: `unbundled fare`, `bare fare`, `ancillary attach`, `aggressive ancillary`, `Navitaire`, `single-fleet`, `point-to-point` *(vs hub-and-spoke)*, `seat selection fee`, `bag fee`.

**Cargo / integrator / freight airline** — lead with `airline-ops-control-center-lead`, `reservations-booking-director` *(cargo capacity sub-profile)*.
- Customer-name patterns: FedEx Express, UPS Airlines, Atlas Air, Cargolux, ANA Cargo, Lufthansa Cargo, Korean Air Cargo, Cathay Cargo, DHL Aviation.
- Prompt patterns: `air waybill`, `AWB`, `e-AWB`, `capacity`, `freighter`, `belly cargo`, `IATA CASS`, `IATA dangerous goods`, `DGR`.

**Car rental** — lead with `guest-loyalty-lead`, `reservations-booking-director` *(car-rental sub-profile)*, `ancillary-revenue-manager`.
- Customer-name patterns: Enterprise Holdings *(Enterprise, National, Alamo)*, Hertz Global *(Hertz, Dollar, Thrifty)*, Avis Budget Group *(Avis, Budget)*, Sixt, Europcar, Turo *(P2P)*; substrings: "Rent-A-Car", "Rental Car", "Car Rentals".
- Prompt patterns: `fleet rotation`, `utilization` *(rental fleet)*, `loyalty days`, `counter-bypass`, `Gold`, `Skip the Counter`, `airport concession`, `off-airport`, `corporate negotiated rate`, `LDW`, `CDW`, `damage recovery`.

**Cruise (smaller share — primary home is `hotels-hospitality`)** — when the customer is cruise-led, prefer the hotels pack; load this pack only if the prompt is distribution / loyalty / IROPS-shaped (e.g., voyage cancellation rebooking).
- Customer-name patterns: Carnival Corporation, Royal Caribbean Group, Norwegian Cruise Line Holdings / NCLH, MSC Cruises, Disney Cruise Line, Viking Cruises.
- Prompt patterns: `voyage`, `cancellation`, `rebooking`, `loyalty tier` *(cruise context)*.

**Ambiguous signals** — when a name matches multiple sub-types (e.g., "FedEx" hits cargo airline + freight; "Southwest" reads as LCC but the prompt is loyalty-shaped), ask one clarifying question rather than guess: *"Which air-travel sub-type is the customer in — legacy / network carrier, ULCC / LCC, cargo / integrator, car-rental, or cruise?"* Then load only that sub-group's lead personas.

## Recommended industry-specific persona files

For this pack, the personas are:

- airline-ops-control-center-lead.md — Runs the OCC / NOC for an airline; decides whether a CX promise survives an IROPS event. Reads safety, crew rest, and FAA/regulator procedure as non-negotiable.
- reservations-booking-director.md — Owns the booking funnel across direct, OTA, and GDS/NDC channels at an airline; cares about conversion, abandonment, channel cost, and PSS/PNR record integrity. *(Currently airline-distribution-leaning; a `hotel-reservations-manager.md` is planned in Phase 3.)*
- ancillary-revenue-manager.md — Owns upsell, bundle, and merchandising across the booking and pre-trip journey; where margin actually moves on a thin-margin airline. *(Currently airline-leaning; a hotel-ancillary variant is planned in Phase 3.)*
- revenue-management-pricing-scientist.md — Owns base-fare revenue strategy — yield management, fare-class / RBD control, bid-price engines, and O&D revenue modeling — sitting between Network Planning and Sales; the dollars-per-ASM voice that catches dynamic-pricing demos that ignore ATPCO and fare-rule grammar.
- guest-loyalty-lead.md — Owns FFP design, partner earn, elite benefits, and the recognition-at-the-front-line problem. *(Hosted in `hotels-hospitality` since the persona works across hotels, cruise, and vacation-rental loyalty; load from there when an air-loyalty conversation is in scope.)*

## Recommended product-pack pairings

When this industry is active, these product packs are most commonly relevant:
- marketing-cloud — Pre-trip, in-trip, and post-trip journeys; the workhorse for passenger communication and ancillary upsell.
- service-cloud — Contact-center, IROPS rebooking workflows, and passenger-recovery; load-bearing during disruption.
- data-cloud — Identity unification across PSS, loyalty, web, and operational systems; effectively required for any serious passenger-360 work.
- experience-cloud — FFP member self-service portals and corporate-travel portals.
- mulesoft — PSS/RM integration is the gating technical conversation; underestimated integration scope is the most common deal-stall.

## URL seed-list (for /download grounding)

- https://www.iata.org/ (IATA; airline industry body, NDC standard, operational and economic data)
- https://www.icao.int/ (ICAO; international civil-aviation standards)
- https://www.airlines.org/ (A4A — Airlines for America; US industry data)
- https://www.transportation.gov/airconsumer (US DOT consumer aviation including the 2024 automatic-refund rule and the accessible-website rule)
- https://transport.ec.europa.eu/transport-themes/passenger-rights_en (EU passenger rights including EU 261)
- https://www.boeing.com/commercial/market/ (Boeing Commercial Market Outlook)
- https://www.airbus.com/en/products-services/commercial-aircraft/market/global-market-forecast (Airbus Global Market Forecast)

## Common sales-conversation pitfalls in this industry

1. Showing a beautiful pre-trip booking demo without addressing IROPS — the OCC persona will note that 80% of the CX investment value is realized (or destroyed) during disruption, not happy-path booking.
2. Treating Loyalty Management as a marketing feature without engaging Treasury and FP&A on the points-liability and FFP-migration baseline — Finance will pause the deal.
3. Ignoring the PSS integration burden in initial sizing — MuleSoft scope balloons in scoping and the customer feels misled.
4. Pitching aggressive ancillary mechanics without addressing the 2024 DOT ancillary-fee disclosure rules and the EU unfair-commercial-practices regime — Legal will block.
5. Underestimating front-line usability — a beautiful agent desktop that requires three clicks to recognize an elite passenger at the gate will not be adopted in the 90 seconds available.

## Common prompt patterns

Pack-specific quick wins — when a prompt names one of these themes, prefer the listed persona blend over the generic full panel:

- **FFP migration / loyalty re-platform** — Guest Loyalty Lead + Treasury voice + Loyalty Management SE. Points-liability re-baselining is the real conversation; Treasury must be in the room or the deal stalls in Finance.
- **IROPS / service recovery** — Airline OCC Lead + Service Cloud SE + Legal (DOT exposure). Disruption is where 80% of CX investment value is realized or destroyed; the demo has to survive a ground-stop scenario.
- **Ancillary / merchandising** — Ancillary Revenue Manager + Marketing Cloud SE + Legal. Margin lives here, but DOT ancillary-fee disclosure and the EU regime are real design constraints.
- **NDC / distribution modernization** — Reservations & Booking Director + Architect + MuleSoft SE. PSS integration depth and GDS/OTA contract economics gate the conversation.
- **Passenger-360** — Guest Experience Director *(loaded from hotels-hospitality)* + Data Cloud SE + Architect. Identity unification across PSS, loyalty, web, and operational systems is the gating technical conversation.

## Regulatory landscape (one paragraph)

Air travel faces one of the most consumer-protection-active regulatory environments outside financial services. In the US, the DOT's 2024 rule mandates automatic refunds for cancelled and significantly-changed flights and tightens disclosure on ancillary fees; the tarmac-delay rule, full-fare advertising rule, ACAA accessibility, and the accessible-website rule for airlines are also in effect. In the EU, Regulation EC 261/2004 governs compensation for delays and cancellations; the API/PNR directive governs passenger-data sharing with authorities; GDPR shapes loyalty and marketing data flows. PCI DSS v4.0 applies pervasively because card data is captured at booking, check-in, on-board, and post-trip. APIS and Secure Flight require passenger data to be shared with US authorities for international segments. FAA Part 121/135/145 and FAR 117 crew-rest govern operations; EASA and ICAO apply internationally. Car-rental adds FMCSA, state insurance-product oversight on LDW/CDW, and the airport-concession contractual frame. Personas should treat DOT enforcement risk, EU 261 exposure, and PCI scope as real design constraints with material financial consequence.
