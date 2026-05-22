# Freight, Logistics & Transportation — Industry Pack

Freight, logistics, and transportation covers parcel and integrators (FedEx, UPS, DHL, USPS), less-than-truckload (LTL) and truckload (TL) carriers, intermodal and drayage operators, ocean carriers and freight forwarders, rail (Class I freight railroads and short-lines), passenger rail and public transit authorities, last-mile and gig-logistics platforms, and the distribution-tech / online travel agency (OTA) operators that increasingly look more like marketplace and routing platforms than travel companies. Top pressures right now are persistent volatility in freight demand and rates (the post-pandemic boom-bust still working through), the labor and capacity squeeze (driver and rail-engineer shortages, CDL pipeline, FMCSA hours-of-service constraints), and infrastructure-and-safety scrutiny that intensified after the East Palestine derailment and ongoing rail-labor disputes. Salesforce engages through core clouds rather than a dedicated Industries Cloud SKU — Sales Cloud (corporate shipper accounts), Service Cloud (shipper and consignee care), Marketing Cloud (B2B nurture and shipper account-engagement), Data Cloud, MuleSoft, and Field Service for the operator side. The typical buyer shape is a Chief Commercial Officer or VP of Sales as economic buyer, a Director of Customer Experience or Director of Shipper Operations as champion, and a Director of Network Operations or VP of IT as the load-bearing operational stakeholder.

## Grounding prompt (injected into every persona)

### Vocabulary

Freight and logistics customers speak in DOT number, FMCSA, ELD (electronic logging devices), CSA (Compliance, Safety, Accountability — the FMCSA scoring system), HOS (hours of service), IFTA (International Fuel Tax Agreement), LTL versus TL, intermodal, drayage, consolidation and deconsolidation, BOL (bill of lading), accessorials, dimensional weight (dim weight), TMS (transportation management system), WMS (warehouse management system), freight broker and 3PL versus asset-based carrier, OS&D (over, short, and damaged), and the perennial first-mile / last-mile distinction. Rail brings Class I (BNSF, UP, CSX, NS, CN, CPKC), short-line, positive train control (PTC), MoW (maintenance of way), rolling stock, intermodal terminals, and STB (Surface Transportation Board) economic regulation. Transit brings FTA, FRA, ridership, farebox recovery, headway, GTFS, paratransit, and ADA complementary-paratransit obligation. Ocean brings IMO, FMC (Federal Maritime Commission), demurrage and detention, container imbalance, and the alliance structures (2M, Ocean Alliance, THE Alliance). OTA / distribution adds metasearch, look-to-book, merchant vs agency model, GDS aggregator, rate parity, and the bundling / package economics that bridge into traditional travel — but operate on a marketplace shape that has more in common with logistics than with airline ops.

### Honest objections

The honest objections this sub-vertical raises against generic SaaS pitches are: (1) "Our system of record is the TMS and the operational data model — show me what your Data Cloud actually does with shipment-level data, freight-class data, and accessorial billing exceptions, not a marketing dashboard"; (2) "Our front line is drivers in cabs, dispatchers in trailers, and warehouse associates with scan guns — your associate-facing experience has to be usable with gloves on, in landscape on a 5-inch screen, with intermittent network"; (3) "We are a 4-cent-margin business and every percent of accessorial leakage matters more than a journey demo — what does this do to our revenue assurance and to OS&D claims handling?". Rail adds: "Federal Railroad Administration is in our operations every day; STB controls our rate-making — your AI pitch lives downstream of those frameworks". Transit adds: "We are a public agency with a unionized workforce and an ADA paratransit obligation; this needs to survive a board meeting and an ADA Title II complaint".

### Regulatory frame

Compliance and regulatory realities to keep in mind: FMCSA (US Federal Motor Carrier Safety Administration; DOT numbers, HOS, ELD mandate, CSA scoring, driver-qualification files, drug-and-alcohol testing); FRA (Federal Railroad Administration; PTC, hours-of-service for rail crews, hazmat); FTA (Federal Transit Administration; transit asset management, safety plans, ADA paratransit); STB (Surface Transportation Board; rail economic regulation, rate reasonableness, captive-shipper relief); PHMSA (Pipeline and Hazardous Materials Safety Administration; hazmat classification and packaging); FMC (Federal Maritime Commission; ocean carrier filings, demurrage and detention reasonableness rulings); IMO (International Maritime Organization; SOLAS, MARPOL, IMO 2020 sulfur cap); IATA DGR for air cargo dangerous goods; APIS / ACI for cross-border cargo data; CBP for customs and import / export; EPA for emissions standards (Clean Trucks Plan, locomotive standards, IMO emissions); USPS Mailing Standards for the parcel-mail boundary; OSHA for warehouse operations; ADA Titles II and III for transit and public-facing transportation; state and local last-mile / quiet-hours / cargo-routing rules; the EU's Mobility Package and similar international counterparts. Decision-making is more operations-heavy than in most industries: Operations owns the network, Commercial owns the shipper relationship, IT owns the TMS / WMS integration, Compliance owns the FMCSA / FRA / safety posture, and Finance owns the revenue-assurance / accessorial-leakage P&L.

## Customer-type classifier (which sub-industry — parcel, LTL/TL, ocean, rail, transit, last-mile, or distribution-tech?)

This pack covers seven sub-types. Detect from case-insensitive substring match on the customer name + the prompt body:

**Parcel / integrator (asset-based, end-to-end)** — lead with `network-operations-director` (the hub-and-spoke sort drives everything) + `revenue-assurance-pricing-lead` (dim-weight is the parcel-specific leakage axis) + `shipper-experience-director` (POD and exception messaging are table-stakes) + `compliance-safety-officer` (FMCSA for ground, IATA DGR for air) + `driver-dispatcher-front-line` (the parcel linehaul / P&D driver and the hub dispatcher).
- Customer-name patterns: FedEx, UPS, DHL, USPS, OnTrac, LaserShip, Amazon Logistics; substrings: "Express", "Parcel".
- Prompt patterns: `parcel`, `ground` *(parcel context)*, `air network`, `hub-and-spoke`, `dim weight`, `last mile`, `delivery exception`, `proof of delivery`, `POD`.

**LTL / TL trucking** — the most central sub-type. Lead with `network-operations-director` (lane P&L and dispatch board) + `revenue-assurance-pricing-lead` (accessorial leakage, tariff, GRI) + `shipper-experience-director` (BCO and 3PL care, EDI 214) + `compliance-safety-officer` (FMCSA CSA, ELD, HOS, drug-and-alcohol clearinghouse) + `driver-dispatcher-front-line` (OTR / owner-operator and dispatcher).
- Customer-name patterns: XPO Logistics, Old Dominion / ODFL, Saia, Estes Express, J.B. Hunt, Schneider National, Werner Enterprises, Knight-Swift, Landstar, Yellow *(historical)*, ArcBest; substrings: "Trucking", "Transport" *(freight context)*, "Logistics", "Freight Lines".
- Prompt patterns: `LTL`, `TL`, `truckload`, `dry van`, `reefer`, `flatbed`, `linehaul`, `dock`, `pickup and delivery`, `P&D`, `lane`, `accessorials`, `BOL`, `bill of lading`, `OS&D`, `FMCSA`, `ELD`, `HOS`, `CSA`, `IFTA`.

**Ocean carrier / freight forwarder / 3PL** — lead with `network-operations-director` (port queues, chassis-pool, gate dynamics) + `revenue-assurance-pricing-lead` (demurrage and detention is the dominant accessorial axis) + `shipper-experience-director` (BCO and consignee care, EDI 214 milestone obsession) + `compliance-safety-officer` (FMC D&D reasonableness, IMO, IMDG hazmat, CBP / APIS). The `driver-dispatcher-front-line` persona applies to drayage but not to ocean linehaul.
- Customer-name patterns: Maersk, MSC *(shipping context)*, CMA CGM, COSCO, Hapag-Lloyd, Evergreen, ONE *(Ocean Network Express)*, ZIM; forwarders / 3PLs: Kuehne+Nagel, DSV, DB Schenker, Expeditors, C.H. Robinson, Flexport.
- Prompt patterns: `ocean`, `container`, `FEU`, `TEU`, `demurrage`, `detention`, `D&D`, `freight forwarder`, `3PL`, `customs brokerage`, `IMO`, `FMC`, `BCO` *(beneficial cargo owner)*, `NVOCC`, `alliance`.

**Rail (Class I freight + short-line)** — lead with `network-operations-director` (terminal lifts, intermodal ramps, manifest train build) + `revenue-assurance-pricing-lead` (STB rate-reasonableness, captive-shipper economics, demurrage on cars) + `shipper-experience-director` (BCO and intermodal-shipper care) + `compliance-safety-officer` (FRA Part 220/228, PTC, hazmat). Drop `driver-dispatcher-front-line` — rail crews are a different front-line frame (engineer / conductor / yardmaster); voice them through Compliance & Safety until a rail-front-line persona ships.
- Customer-name patterns: BNSF Railway, Union Pacific / UP, CSX, Norfolk Southern / NS, Canadian National / CN, Canadian Pacific Kansas City / CPKC, Genesee & Wyoming; substrings: "Railway", "Railroad".
- Prompt patterns: `Class I`, `Class 1 railroad`, `PTC`, `positive train control`, `MoW`, `maintenance of way`, `rolling stock`, `intermodal` *(rail context)*, `STB`, `Surface Transportation Board`, `precision scheduled railroading`, `PSR`, `unit train`, `manifest train`.

**Passenger rail / transit authority** — lead with `network-operations-director` (headway, garage / yard ops, daily run) + `compliance-safety-officer` (FTA safety plan, ADA complementary paratransit, FRA for passenger rail) + `shipper-experience-director` *(reframed as rider-experience proxy — flag the seat as imperfect)*. Drop `revenue-assurance-pricing-lead` (farebox-recovery politics is a different P&L conversation) and drop `driver-dispatcher-front-line` (transit operators are unionized, ADA-trained, and a distinct front-line frame). Augment with the generic Legal / Compliance Officer for Title II posture.
- Customer-name patterns: Amtrak, MTA New York / NYC MTA, LA Metro / LACMTA, Chicago Transit Authority / CTA, BART, WMATA, SEPTA, MBTA, NJ Transit, Caltrain, Sound Transit; substrings: "Transit Authority", "Transportation Authority", "Metro" *(transit context)*, "Transit District".
- Prompt patterns: `FRA`, `FTA`, `ridership`, `farebox`, `farebox recovery ratio`, `headway`, `GTFS`, `paratransit`, `ADA complementary paratransit`, `transit asset management`, `TAM`, `safety plan`.

**Last-mile / gig logistics / parcel-adjacent platforms** — lead with `network-operations-director` (zone density, route optimization) + `shipper-experience-director` (consignee notification, exception recovery, POD) + `driver-dispatcher-front-line` (gig-driver / 1099-driver reality and the zone dispatcher) + `compliance-safety-officer` (Prop 22, AB5, ABC test, state-by-state IC classification, FMCSA where commercial-grade). Pull `revenue-assurance-pricing-lead` when the prompt touches zone pricing or merchant economics.
- Customer-name patterns: Instacart, DoorDash *(logistics context)*, Uber Freight, GoBolt, Roadie, Shipt, Gopuff.
- Prompt patterns: `gig`, `independent contractor` *(driver context)*, `1099 driver`, `Prop 22`, `route optimization`, `last mile`, `delivery density`, `instant delivery`.

**OTA / metasearch / online distribution (lives in this pack because the platform shape is marketplace-and-routing, not airline / hotel ops)** — the freight-specific personas mostly do not apply. Lead with operations-leaning generics — the generic Product Owner, the generic Technical / Architecture seats, the Marketing Cloud SE, the Commerce Cloud SE, and the Data Cloud SE — and flag a missing distribution-tech-product-lead persona in the panel-design step. The five freight personas above are LTL/TL/rail/ocean/parcel-shaped and do not transfer cleanly to the OTA marketplace frame.
- Customer-name patterns: Booking Holdings *(Booking.com, Priceline, Agoda, Kayak)*, Expedia Group *(Expedia, Hotels.com, Vrbo, Travelocity, Orbitz, Trivago)*, Trip.com Group *(formerly Ctrip)*, Hopper, Google Travel; substrings: "Travel" *(OTA / marketplace context)*, "Booking" *(OTA context)*.
- Prompt patterns: `metasearch`, `OTA`, `look-to-book`, `merchant model`, `agency model`, `package`, `vacation package`, `bundling`, `GDS aggregator`, `rate parity`, `attribution`, `marketplace`.

**Ambiguous signals** — when a name spans sub-types (e.g., "FedEx Freight" is LTL, "FedEx Express" is parcel-air, "FedEx Ground" is parcel-surface; "Amazon Logistics" is parcel + last-mile + ocean depending on context), ask one clarifying question: *"Which freight / logistics sub-type — parcel / integrator, LTL / TL trucking, ocean carrier or forwarder, rail (Class I), passenger rail / transit, last-mile / gig platform, or OTA / distribution-tech — is the primary frame?"* Load only that sub-group's lead personas.

## Recommended industry-specific persona files

This pack ships five freight-specific personas, covering the load-bearing seats across parcel, LTL/TL, ocean, rail, and last-mile. A distribution-tech-product-lead for the OTA / marketplace sub-type is still deferred — fall back to operations-leaning generics for OTA / metasearch customers and flag the missing seat in the panel-design step.

- `network-operations-director.md` — Lane-level P&L, dispatch and terminal ops, FMCSA HOS as hard constraint, dock-turn time, peak-hour port queue dynamics. The most central operational seat across sub-types.
- `revenue-assurance-pricing-lead.md` — Accessorial leakage (detention, demurrage, dim-weight, fuel surcharge), contract compliance, OS&D claims drag on P&L. The wallet-opener seat for the 4-cent-margin frame.
- `compliance-safety-officer.md` — FMCSA CSA scoring, ELD mandate, drug-and-alcohol clearinghouse, FRA crew-rest for rail, FMC D&D reasonableness for ocean, ADA paratransit for transit, hazmat across modes. Replaces the generic Compliance Officer that proxies badly for freight.
- `shipper-experience-director.md` — Shipper-side and consignee-side care, exception messaging, POD workflows, BCO account dynamics, the EDI 214 milestone obsession. The Service Cloud / Marketing Cloud story has no advocate without this seat.
- `driver-dispatcher-front-line.md` — Composite gloves-on, 5-inch-landscape-screen, intermittent-network voice (OTR driver / owner-operator and dispatcher / terminal manager). Enforces the field-rep-mobile-usability deal-killer pitfall the pack names.

*Still deferred:*
- distribution-tech-product-lead.md *(OTA / marketplace sub-type — fall back to operations-leaning generics and flag the missing seat)*

## Recommended product-pack pairings

When this industry is active, these product packs are most commonly relevant:
- sales-cloud — Shipper and corporate-account management; the BCO and large-shipper sales motion is high-touch and long-cycle.
- service-cloud — Shipper and consignee care, claims handling (OS&D, demurrage disputes), and incident communication during network events.
- marketing-cloud — B2B nurture for shippers, account-engagement for large logistics buyers, and consignee notification journeys (delivery, exception, POD).
- data-cloud — Shipper-360 across TMS / WMS / billing / claims / web; the unified-view story for revenue-assurance work.
- mulesoft — TMS / WMS / billing / EDI integration is the gating technical conversation; EDI 204 / 210 / 214 / 990 / 997 plus growing API adoption are scope-defining.
- field-service — Driver, dispatcher, terminal, and maintenance workforce enablement; the front-line tooling story.

## URL seed-list (for /download grounding)

- https://www.aar.org/ (AAR — Association of American Railroads; Class I freight rail data and policy)
- https://www.trucking.org/ (ATA — American Trucking Associations)
- https://www.intermodal.org/ (IANA — Intermodal Association of North America)
- https://www.fmcsa.dot.gov/ (FMCSA — federal motor-carrier safety regulator)
- https://railroads.dot.gov/ (FRA — Federal Railroad Administration)
- https://www.transit.dot.gov/ (FTA — Federal Transit Administration)
- https://www.stb.gov/ (STB — Surface Transportation Board; rail economic regulation)
- https://www.fmc.gov/ (FMC — Federal Maritime Commission)
- https://www.imo.org/ (IMO — International Maritime Organization)
- https://www.usps.com/business/ (USPS business and mailing-standards reference)
- https://www.ttnews.com/ (Transport Topics — trade-press canon for trucking and freight)
- https://www.joc.com/ (Journal of Commerce — ocean and intermodal canon)

## Common sales-conversation pitfalls in this industry

1. Pitching a journey-builder demo to an Operations leader without addressing the TMS / WMS data shape and the EDI integration burden — the operator will mentally classify the pitch as "marketing tool" and disengage.
2. Treating revenue-assurance and accessorial leakage as a Finance afterthought rather than the central P&L story — in a 4-cent-margin business, this is the conversation that opens the wallet.
3. Underestimating front-line constraints — a beautiful driver-app demo on a 13-inch tablet at HQ does not survive a -10°F dock in Minnesota with gloves on.
4. Pitching AI for routing or dispatching without addressing FMCSA HOS, FRA crew-rest, and the union and operational realities — the Operations leader will note that the AI's recommendation is illegal half the time.
5. Treating transit and freight rail as a single "rail" market — passenger / transit (FTA, ADA paratransit, farebox-recovery politics) and Class I freight (STB, captive-shipper economics, PSR) are different industries with different regulators and different P&Ls.

## Common prompt patterns

Pack-specific quick wins — when a prompt names one of these themes, prefer the listed persona blend over the generic full panel:

- **Shipper-360 / account-management modernization** — Generic stakeholder (Network Operations) + Data Cloud SE + Architect + MuleSoft SE. TMS / WMS / EDI integration is the conversation, not the dashboard.
- **Driver / dispatcher / front-line enablement** — Field Service SE + Service Cloud SE + front-line voice. Gloves, weather, intermittent network are the design constraints.
- **Revenue assurance / accessorial leakage** — Generic stakeholder (Finance / Revenue Assurance) + Architect + Data Cloud SE. The 4-cent-margin frame is real and load-bearing.
- **Shipper / consignee notification journeys** — Marketing Cloud SE + Service Cloud SE. Exception messaging (delay, missed pickup, OS&D) is more valuable than blue-sky tracking.
- **Transit constituent / rider experience** — Service Cloud SE + Experience Cloud SE + ADA / accessibility voice + Legal (FTA, ADA Title II). Constituent posture differs sharply from commercial-shipper posture.
- **OTA / marketplace conversion and attribution** — Marketing Cloud SE + Commerce Cloud SE + Data Cloud SE. Look-to-book, attribution, and the merchant-vs-agency model frame the technical scope.

## Regulatory landscape (one paragraph)

Freight, logistics, and transportation faces one of the most operationally-active regulatory environments outside healthcare and financial services, with regulators embedded in daily operations rather than reviewing finished products. In the US, FMCSA governs commercial-motor-carrier safety via DOT numbers, HOS, ELD mandates, CSA scoring, driver-qualification files, and drug-and-alcohol testing; FRA governs freight and passenger rail with PTC, hours-of-service for rail crews, and hazmat oversight; FTA governs transit with safety plans, transit asset management, and ADA complementary paratransit; STB governs rail economic regulation including rate reasonableness and captive-shipper relief; PHMSA governs hazmat across modes; FMC governs ocean carriers including the recent Ocean Shipping Reform Act and demurrage / detention reasonableness rulings; CBP and APIS / ACI govern cross-border cargo data. Internationally, IMO sets SOLAS, MARPOL, and the IMO 2020 sulfur cap; IATA DGR governs air-cargo dangerous goods; the EU's Mobility Package and Driving and Rest Time Regulation parallel FMCSA. Cross-cutting: EPA emissions (Clean Trucks Plan, locomotive standards), OSHA for warehouse and dock operations, ADA Titles II and III for transit and public-facing transportation, USPS Mailing Standards at the parcel-mail boundary, and a thickening municipal patchwork on last-mile delivery, quiet hours, and cargo-routing. OTA / distribution adds the consumer-protection regimes (FTC drip-pricing, EU consumer-protection directives) that hospitality and air-travel face. Personas should treat FMCSA HOS, FRA crew-rest, FMC D&D reasonableness, and ADA paratransit as real design constraints with material financial consequence — not as items to address post-sale.
