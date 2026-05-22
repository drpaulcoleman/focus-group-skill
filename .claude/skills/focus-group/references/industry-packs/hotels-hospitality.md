# Hotels & Hospitality — Industry Pack

Hotels and hospitality covers branded chains (Marriott, Hilton, Hyatt, IHG, Wyndham, Accor, Choice), independent and boutique hotels, resorts and integrated resort-and-casino operators (MGM, Wynn, Caesars), cruise lines (where the on-property guest experience and loyalty mechanics map closely to lodging), and the vacation-rental / short-term-rental platforms (Airbnb on the host side, Vrbo, Sonder, Vacasa, Evolve) that compete with and increasingly resemble hotel operators. Top pressures right now are post-COVID demand normalization (leisure peaks moderating, group and business travel returning unevenly), the franchise-versus-managed-versus-owned property-model fragmentation that complicates every "single guest view" conversation, and a loyalty-economy arms race where elite-recognition operations across brand portfolios increasingly define direct-channel share against the OTAs. Salesforce engages through core clouds rather than a dedicated Industries Cloud SKU — Sales Cloud (group and corporate), Service Cloud, Marketing Cloud, Data Cloud, Loyalty Management, Commerce Cloud, and Experience Cloud. The typical buyer shape is a Chief Commercial Officer or Chief Marketing Officer as economic buyer, a VP of Loyalty or VP of Guest Experience as champion, and a Director of CRM / Guest Platform as the load-bearing technical stakeholder.

## Grounding prompt (injected into every persona)

### Vocabulary

Hospitality customers speak in ADR (average daily rate), RevPAR (revenue per available room), occupancy, RevPAR index versus comp set (with STR Global as the data canon), CRS / PMS (central reservation system / property management system — Opera by Oracle, Cendyn, Amadeus Hospitality, OnQ for Hilton, Marsha for Marriott), BAR (best available rate), rate parity, OTA commission and merchant-vs-agency models, channel manager, RM (revenue management) systems like IDeaS and Duetto, group block and cut-off date, folio, F&B (food and beverage) and outlet operations, housekeeping, brand standards and brand-standard audits, the franchise-managed-owned trichotomy, flag (the brand under which the property operates), and the perennial guest-recognition problem ("I'm Diamond / Globalist / Platinum — why doesn't the front desk know?"). Cruise (a meaningful share of this pack) adds berths, lower berths, voyage, embarkation, shore excursion, beverage and wifi packages, onboard revenue (OBR), and Vessel Sanitation Program (VSP). Vacation-rental adds host, superhost, listing, channel manager (Hostaway, Guesty, OwnerRez), transient occupancy tax (TOT), and the local-STR-regulation patchwork.

### Honest objections

The honest objections this sub-vertical raises against generic SaaS pitches are: (1) "Our PMS is Opera (or Cendyn, or OnQ) and predates the cloud — the integration story for real-time check-in and folio is what I need to see, not a journey builder"; (2) "Loyalty is a P&L commitment with material breakage assumptions; Treasury co-owns the liability and a migration baseline change is a board-level event — what is your migration story?"; (3) "Our portfolio is 60% franchised — your single-guest-view pitch has to survive the property-data-sharing reality where franchisees are independent businesses, not subsidiaries". Cruise adds: "Our shipboard systems run on a constrained ship-to-shore link; what works at HQ has to degrade gracefully at sea". Vacation-rental adds: "Hosts are SMB customers we cannot mandate; you have to make the host workflow better, not just the platform's".

### Regulatory frame

Compliance and regulatory realities to keep in mind: PCI DSS v4.0 (card data is captured at booking, check-in, on-property, F&B, and post-stay); GDPR for EU guests; CCPA / CPRA and the growing US state-privacy patchwork (Washington's My Health My Data Act for spa / wellness data, Colorado, Virginia, Texas); ADA Title III for physical and digital accessibility; state and local lodging-tax obligations and the resort-fee disclosure regimes from state AGs and the FTC's drip-pricing scrutiny; food-safety rules in F&B; for cruise, IMO conventions, flag-state regulation, the CDC Vessel Sanitation Program, and ADA accessibility at sea; for vacation rental, a patchwork of municipal short-term-rental rules (occupancy caps, registration, primary-residence requirements, TOT remittance). Decision-making is committee-driven: Commercial / Loyalty owns the revenue narrative, Brand owns the franchise / standards reality, IT / Architecture owns the PMS / CRS integration, Finance owns the loyalty liability, and Legal / Compliance is involved on resort-fee disclosure, ADA digital accessibility, and the franchise-data-sharing constraints.

## Customer-type classifier (which sub-industry — chain, independent, resort, cruise, or vacation-rental?)

This pack covers five sub-types that share enough vocabulary to live together. Detect from case-insensitive substring match on the customer name + the prompt body:

**Branded chain (franchise-heavy or managed-heavy)** — lead with `guest-loyalty-lead`, `guest-experience-director`, `revenue-management-pricing-scientist`, `reservations-booking-director` *(loaded from `airlines-air-travel` until a hotel-reservations-manager exists in Phase 3)*.
- Customer-name patterns: Marriott International, Hilton, Hyatt, IHG, Wyndham, Accor, Choice Hotels, Best Western, Radisson, Four Seasons, Ritz-Carlton *(Marriott)*, Banyan Tree, Mandarin Oriental; substrings: "Hotels", "Hospitality", "Suites", "Inns", "Lodging".
- Prompt patterns: `ADR`, `RevPAR`, `occupancy`, `PMS`, `Opera` *(Oracle PMS)*, `OnQ`, `Marsha`, `Cendyn`, `franchise vs managed`, `flag`, `brand standards`, `comp set`, `STR Global`, `RevPAR index`, `BAR`, `best available rate`, `group block`, `cut-off date`.

**Independent / boutique hotel or hotel group** — lead with `guest-experience-director`, `guest-loyalty-lead` *(coalition-program sub-profile)*, `revenue-management-pricing-scientist`.
- Customer-name patterns: Small Luxury Hotels of the World / SLH, Leading Hotels of the World / LHW, Design Hotels, Relais & Châteaux, named single-property luxury brands; substrings: "Boutique Hotels", "Hotel Group" *(small)*.
- Prompt patterns: `independent`, `boutique`, `coalition loyalty`, `direct-booking share`, `OTA dependence`, `commission burn`.

**Resort / integrated resort / casino-resort** — lead with `guest-experience-director`, `guest-loyalty-lead` *(host-program sub-profile)*, `revenue-management-pricing-scientist`.
- Customer-name patterns: Sandals, Club Med, Atlantis, MGM Resorts, Wynn, Caesars, Las Vegas Sands, Hard Rock Hotels & Casinos, Disney Resorts.
- Prompt patterns: `F&B outlets`, `spa`, `casino`, `gaming`, `host program`, `comp`, `length of stay` *(resort context)*, `all-inclusive`.

**Cruise** — lead with `guest-loyalty-lead`, `guest-experience-director`, plus pull `ancillary-revenue-manager` from `airlines-air-travel` when the conversation is OBR / shore-excursion / beverage-package shaped.
- Customer-name patterns: Carnival Corporation, Royal Caribbean Group, Norwegian Cruise Line Holdings / NCLH, MSC Cruises, Disney Cruise Line, Viking Cruises, Princess Cruises *(Carnival)*, Holland America *(Carnival)*, Celebrity Cruises *(Royal)*, Oceania, Regent Seven Seas; substrings: "Cruise", "Cruises", "Cruise Lines", "Voyages".
- Prompt patterns: `berths`, `lower berths`, `voyage`, `embarkation`, `Vessel Sanitation Program`, `VSP`, `flag state`, `IMO`, `shore excursion`, `beverage package`, `wifi package`, `onboard revenue`, `OBR`, `gratuity policy`.

**Vacation rental / STR / hosting platforms** — lead with `guest-experience-director` *(host-platform sub-profile)*, `guest-loyalty-lead` *(host-tier sub-profile)*.
- Customer-name patterns: Airbnb, Vrbo *(Expedia)*, Sonder, Vacasa, Evolve, Casago, Whimstay, Plum Guide; substrings: "Vacation Rentals", "Short-Term Rentals", "STR", "Holiday Lets".
- Prompt patterns: `STR`, `short-term rental`, `host`, `superhost`, `OTA listing`, `channel manager`, `Hostaway`, `Guesty`, `OwnerRez`, `local STR regulation`, `transient occupancy tax`, `TOT`, `tax remittance`.

**Ambiguous signals** — when a name spans multiple sub-types (e.g., a Disney property name could be hotel or cruise; "Airbnb" is both OTA-adjacent and vacation-rental), ask one clarifying question: *"Which hospitality sub-type — branded chain, independent, resort, cruise, or vacation-rental — is the primary frame?"* Load only that sub-group's lead personas.

## Recommended industry-specific persona files

For this pack, the personas are:

- guest-loyalty-lead.md — Owns the loyalty program — points economy, elite tiers, partner co-brand, and member experience. Works across hotels, cruise, and vacation-rental loyalty; cross-loaded by `airlines-air-travel` for FFP conversations.
- guest-experience-director.md — Owns the end-to-end guest journey across pre-stay, on-property, and post-stay; the cross-functional convener; pulls in operations, F&B, housekeeping, and brand.
- revenue-management-pricing-scientist.md — Owns rate strategy — RevPAR / ADR / occupancy, BAR discipline, transient-vs-group-vs-OTA mix, and comp-set index vs STR Global — the voice that catches dynamic-award-pricing pitches that haven't been re-baselined with Treasury, and rate moves that ignore franchise-vs-managed-vs-owned governance.

*(Planned in Phase 3: `hotel-reservations-manager.md`, `hotel-ancillary-revenue-manager.md`, and a hospitality-specific `revenue-management-director.md`. Until then, the airline-leaning `reservations-booking-director.md` and `ancillary-revenue-manager.md` are cross-loaded from `airlines-air-travel/` when a hospitality conversation needs their archetype, with the persona maintainer note acknowledging the sub-profile gap.)*

## Recommended product-pack pairings

When this industry is active, these product packs are most commonly relevant:
- marketing-cloud — Pre-stay, in-stay, and post-stay journeys; the workhorse for guest communication and ancillary upsell across hotels, cruise, and vacation rental.
- service-cloud — Contact-center, guest-recovery workflows, and in-stay request handling; load-bearing during service-recovery moments of truth.
- data-cloud — Identity unification across PMS, CRS, loyalty, web, F&B / POS, and on-property signals; effectively required for any serious guest-360 work, with the franchise data-sharing reality as the technical wrinkle.
- loyalty-management — Member / Tier / Points / Voucher / Partner data model with rule engines for earn and burn; the surface for elite-recognition operations.
- experience-cloud — Member self-service portals, group portals (for planners), and partner / host portals.
- commerce-cloud — Award-redemption shopping, on-property merchandising for spa / F&B / excursions, and host-side booking surfaces.
- mulesoft — PMS / CRS / RM integration is the gating technical conversation, especially across a fragmented property portfolio.

## URL seed-list (for /download grounding)

- https://www.ahla.com/ (American Hotel & Lodging Association)
- https://str.com/ (STR Global; the canonical RevPAR / comp-set data source)
- https://sha.cornell.edu/ (Cornell School of Hotel Administration; the academic and research canon)
- https://www.alisconference.com/ (ALIS — Americas Lodging Investment Summit)
- https://www.hsmai.org/ (HSMAI — Hospitality Sales and Marketing Association International)
- https://www.ustravel.org/ (US Travel Association; travel-industry advocacy and economic data)

## Common sales-conversation pitfalls in this industry

1. Pitching a "single guest view" without addressing the franchise / managed / owned property-data-sharing reality — at a 60%-franchised flag, "guest data" is not one dataset and the franchisee is not a subsidiary.
2. Treating Loyalty Management as a marketing feature without engaging Treasury and FP&A on the breakage and migration-baseline implications — Finance will pause the deal.
3. Ignoring the PMS / CRS integration burden — Opera, Marsha, OnQ, Cendyn, and the long tail of independent PMSes are different integration shapes, and MuleSoft scope balloons when underestimated.
4. Pitching aggressive resort-fee or ancillary mechanics without addressing the FTC drip-pricing regime and the state-AG resort-fee enforcement — Legal will block.
5. Underestimating front-line usability — a great front-desk experience that requires three clicks to recognize an elite guest at check-in will not be adopted during a 7am check-out rush.

## Common prompt patterns

Pack-specific quick wins — when a prompt names one of these themes, prefer the listed persona blend over the generic full panel:

- **Loyalty migration / re-platform** — Guest Loyalty Lead + Treasury voice + Loyalty Management SE. Points-liability re-baselining is the real conversation.
- **Guest-360 across a franchise portfolio** — Guest Experience Director + Data Cloud SE + Architect + Brand-Standards voice. Franchise data-sharing is the gating conversation, not the journey-builder demo.
- **Resort-fee / drip-pricing review** — Ancillary Revenue Manager *(loaded from `airlines-air-travel`)* + Marketing Cloud SE + Legal. FTC and state-AG enforcement is real and recent.
- **On-property service recovery** — Guest Experience Director + Service Cloud SE + front-line voice. Recovery moments of truth define repeat intent more than blue-sky service.
- **Cruise voyage cancellation / OBR** — Guest Loyalty Lead + Guest Experience Director + Marketing Cloud SE. Voyage-level rebooking interacts with FCC (future cruise credit) economics.
- **Vacation-rental host enablement** — Guest Experience Director *(host-platform sub-profile)* + Commerce Cloud SE. Hosts are SMB customers, not employees — you must improve their workflow, not just the platform's.

## Regulatory landscape (one paragraph)

Hospitality faces a layered regulatory landscape that varies sharply by sub-type. PCI DSS v4.0 applies pervasively because card data is captured across booking, check-in, F&B, on-property, and post-stay touch points. GDPR governs EU guest data; CCPA / CPRA and a growing US state patchwork (Washington's My Health My Data Act for spa / wellness, Colorado, Virginia, Texas, etc.) constrain personalization and loyalty mechanics. ADA Title III governs physical and digital accessibility for US properties; resort-fee disclosure is under active enforcement by state AGs and the FTC's drip-pricing regime. State and local lodging taxes (TOT, occupancy tax) are pervasive. Food-safety rules govern F&B operations. Cruise operators face IMO conventions and flag-state regulation, the CDC Vessel Sanitation Program for US-port voyages, and the increasingly aggressive consumer-protection scrutiny that follows any norovirus or mechanical-failure event. Vacation-rental platforms face a municipal-by-municipal patchwork of registration, occupancy-cap, primary-residence, and TOT-remittance rules that no single product configuration solves. Personas should treat FTC drip-pricing enforcement, ADA digital accessibility, and franchise data-sharing constraints as real design constraints with material financial consequence.
