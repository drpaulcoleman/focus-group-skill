# Commercial Real Estate — Industry Pack

Commercial real estate (CRE) covers institutional and private CRE owner-operators, equity and mortgage REITs (office, retail, industrial / logistics, multifamily, healthcare, hospitality-as-asset, data-center, net-lease, self-storage), property-management firms (third-party and in-house), facilities-management (FM) services firms, and the tenant-experience platform and workplace-services ecosystem that sits between landlord and occupier. Top pressures right now are the post-pandemic office reset (utilization, sublease overhang, valuation reset, and the slow-but-real flight-to-quality split), interest-rate-and-cap-rate volatility (refinancing maturities, debt-fund stress, and valuation marks), the building-performance-standards wave (NYC Local Law 97, Boston BERDO, Washington DC BEPS, Denver Energize, similar measures spreading), and the AI / data-center / industrial-logistics build-out that has shifted institutional capital allocation. Salesforce does not have a dedicated Industries Cloud SKU for CRE; engagement is Sales Cloud for leasing pipeline and broker-team management, Service Cloud for tenant / occupant service, Field Service for in-house dispatch and PM, Experience Cloud for tenant and resident portals, Marketing Cloud for tenant communications and resident lifecycle, and Data Cloud for unifying CRM with Yardi / MRI / RealPage / building-systems signal. The typical buyer shape is a Chief Operating Officer or Chief Investment Officer as economic buyer, a Head of Asset Management or VP of Operations as champion, and a Director of Property Management or Director of Workplace Technology as the load-bearing operational stakeholder.

## Grounding prompt (injected into every persona)

### Vocabulary

CRE customers speak in "GLA" (gross leasable area), "RSF" (rentable square feet) versus "USF" (usable square feet), "load factor", "NOI" (net operating income), "cap rate", "yield on cost", "stabilized yield", "DSCR" (debt-service coverage ratio), "LTV" (loan-to-value), "IRR" (internal rate of return), "TI" (tenant improvement allowance) and "LC" (leasing commission), "free rent" / "rent abatement", "step rent" / "escalations", "CAM" (common-area maintenance) and CAM reconciliation, "OpEx" pass-throughs, "lease abstract" and "rent roll", and "trade-out" (renewal vs new-lease rate delta). Lease structures vary: "full-service gross", "modified gross", "triple-net" / "NNN", "absolute net", "percentage rent" (retail). Asset-class shorthand: "office" (Class A / B / C, trophy, urban / suburban), "retail" (regional mall, lifestyle, power center, grocery-anchored, single-tenant net-lease / STNL), "industrial" (bulk distribution, last-mile, light industrial, IOS — industrial outdoor storage, cold storage), "multifamily" (garden, mid-rise, high-rise, Class A / B / C, BTR / build-to-rent), "data center" (hyperscale, colo, edge), "self-storage", "healthcare" (MOB — medical office building, life-sciences lab, senior housing — IL / AL / MC / SNF tiers). Property-management systems: Yardi (Voyager, Breeze, Elevate suite), MRI Software, RealPage, Entrata, AppFolio (smaller multifamily). FM tools: CMMS / EAM (IBM Maximo, eMaint, Accruent, Nuvolo, Planon, Archibus, FM:Systems), BMS (Honeywell, Siemens Desigo, Johnson Controls Metasys, Schneider EcoStruxure), IWMS (integrated workplace management), FDD (fault detection and diagnostics). Tenant-experience platforms: HqO, Equiem, VTS Activate, Bisnow Verse, Lane (acquired by VTS), Spaceflow. ESG / reporting: GRESB, CDP, EUI (energy use intensity, kBtu / sf / yr), LEED, WELL, Fitwel, BREEAM, ENERGY STAR Portfolio Manager.

### Honest objections

The honest objections this sub-vertical raises against generic SaaS pitches are: (1) "Our system of record is Yardi (or MRI / RealPage / Entrata) — leases, rent roll, CAM, GL, and AP all live there; show me what Salesforce does that doesn't duplicate or fight the PMS, because the asset-management team is not switching"; (2) "The FM / CMMS world (Maximo, Nuvolo, Planon, ServiceChannel) is the work-order system of record for buildings — your Field Service has to integrate with that, not pretend to replace it for the in-house engineer who has used Maximo for 12 years"; (3) "Tenant-experience apps are a crowded category (HqO, Equiem, VTS Activate) — what does Experience Cloud actually do that an HqO or Equiem deployment doesn't already do, and what is the integration story with access control, BMS, and amenity booking?"; (4) "We are operating under fee-management agreements that pass costs through to ownership at cost or with a small management fee — anything that adds property-level OpEx has to pencil at the asset level, not just at the portfolio HQ"; (5) "Building-performance standards (LL97, BERDO, BEPS) carry real penalties at the asset level; if your pitch is energy or sustainability, show me the EUI math and the path to compliance, not a dashboard".

### Regulatory frame

Compliance and regulatory realities to keep in mind: ADA Titles II and III (accessibility in public-accommodation portions of commercial properties); fair-housing (FHA, HUD enforcement — multifamily; source-of-income protection laws in growing list of jurisdictions); state-and-local landlord-tenant law (rent control, just-cause eviction, security-deposit handling, notice requirements — wildly varied by jurisdiction); state-and-local rent-stabilization regimes (NYC, California AB 1482, Oregon SB 608, St. Paul, others); building-performance ordinances and emissions standards (NYC Local Law 97 with 2024-2029 escalating caps, Boston BERDO, Washington DC BEPS, Denver Energize, Seattle Building Tune-Ups, Chicago Energy Benchmarking, and similar measures in 25+ US jurisdictions plus EPBD in the EU); ENERGY STAR Portfolio Manager benchmarking disclosure (mandatory in many cities); LL84 (NYC energy benchmarking) and analogs; building codes (IBC / IFC / IPC / IMC / NEC) as locally adopted; ASHRAE 62.1 / 90.1 / 189.1 (ventilation, energy, green-building); ANSI / IES (lighting); NFPA codes (life-safety, fire-alarm, sprinkler, elevator); ADA-required elevator and accessibility maintenance; OSHA for building-engineering staff; EPA refrigerant rules (Section 608, AIM Act phase-down of HFCs); state-and-local water-and-electrical code; tenant-data and visitor-data privacy under state privacy laws (CCPA / CPRA, etc.); and a growing set of CRE-specific ESG disclosure expectations (GRESB, EU CSRD, SEC climate disclosure as it evolves). Decision-making is asset-and-portfolio-split: Asset Management owns the NOI / valuation narrative, Property Management owns the day-to-day P&L, FM / engineering owns operations and code compliance, Leasing owns deals, and Workplace / Tenant Experience owns the occupant relationship.

## Customer-type classifier (which sub-industry — office-REIT, retail-REIT, industrial-REIT, multifamily-REIT, healthcare-REIT, FM-services, or net-lease?)

This pack covers seven sub-types that share the asset-and-portfolio vocabulary but have meaningfully different operating models, tenant relationships, and competitive sets. Detect from case-insensitive substring match on the customer name + the prompt body:

**Office REIT / office owner-operator** — lead with `property-manager`, `tenant-experience-lead`, `facilities-operations-lead`, `capital-markets-acquisitions-director` *(must-include — owner-side economic buyer)*.
- Customer-name patterns: Boston Properties / BXP, Vornado Realty, SL Green Realty, Kilroy Realty, Cousins Properties, Highwoods Properties, JBG SMITH, Hudson Pacific, Empire State Realty Trust; substrings: "Properties" *(office-REIT context)*, "Realty Trust" *(office context)*, "Office Trust".
- Prompt patterns: `office`, `Class A office`, `trophy`, `sublease`, `utilization` *(office context)*, `return to office`, `RTO`, `flight to quality`, `tenant improvement allowance`, `TI`, `LC`, `leasing commission`, `co-working` *(office context)*, `flex office`, `workplace strategy`.

**Retail REIT / retail owner-operator** — lead with `property-manager`, `tenant-experience-lead`, `capital-markets-acquisitions-director` *(must-include — owner-side economic buyer)*.
- Customer-name patterns: Simon Property Group / SPG, Brookfield Properties Retail, Macerich, Tanger, Regency Centers, Kimco Realty, Federal Realty, Phillips Edison, Acadia Realty, Site Centers, Brixmor; substrings: "Realty" *(retail-REIT context)*, "Centers" *(retail context)*, "Mall" *(retail context)*.
- Prompt patterns: `mall`, `lifestyle center`, `power center`, `grocery-anchored`, `anchor tenant`, `percentage rent`, `sales per square foot`, `foot traffic`, `co-tenancy`, `kickout clause`, `radius restriction`, `pop-up`, `experiential retail`.

**Industrial / logistics REIT** — lead with `property-manager`, `facilities-operations-lead`, `capital-markets-acquisitions-director` *(must-include — owner-side economic buyer)*.
- Customer-name patterns: Prologis, Duke Realty *(legacy — now part of Prologis)*, Rexford Industrial, EastGroup Properties, First Industrial, STAG Industrial, Terreno Realty, Americold *(cold storage)*, Lineage Logistics *(cold storage)*, Public Storage *(self-storage as industrial-adjacent)*; substrings: "Industrial", "Logistics" *(REIT context)*, "Distribution Centers".
- Prompt patterns: `bulk distribution`, `last mile` *(industrial context)*, `IOS` *(industrial outdoor storage)*, `cold storage`, `cross-dock`, `truck court`, `clear height`, `dock-high doors`, `e-commerce`, `3PL tenant`, `data center` *(if applicable)*.

**Multifamily REIT / multifamily owner-operator** — lead with `property-manager`, `tenant-experience-lead`, `capital-markets-acquisitions-director` *(must-include — owner-side economic buyer)*.
- Customer-name patterns: AvalonBay Communities, Equity Residential, Camden Property Trust, Essex Property Trust, UDR, Mid-America Apartment Communities / MAA, Independence Realty Trust / IRT, Greystar *(operator)*, Cortland *(operator)*, Bozzuto *(operator)*, Lincoln Property Company; substrings: "Communities", "Apartment", "Residential" *(REIT context)*, "Multifamily".
- Prompt patterns: `multifamily`, `apartment`, `resident`, `lease-up`, `leasing velocity`, `occupancy`, `economic occupancy`, `rent growth`, `RUBS` *(ratio utility billing)*, `renewal`, `concessions`, `fair housing`, `source of income`, `rent control`, `rent stabilization`, `BTR` *(build to rent)*, `SFR` *(single-family rental)*.

**Healthcare REIT / MOB / senior housing / life-science lab** — lead with `property-manager`, `facilities-operations-lead`, `capital-markets-acquisitions-director` *(must-include — owner-side economic buyer)*.
- Customer-name patterns: Welltower, Ventas, Healthpeak Properties, Healthcare Realty, Sabra Health Care REIT, Omega Healthcare, Alexandria Real Estate Equities *(life-science labs)*, BioMed Realty *(legacy — Blackstone-owned)*; substrings: "Healthcare Realty", "Health Properties", "Medical Properties" *(REIT context)*.
- Prompt patterns: `MOB`, `medical office building`, `on-campus`, `off-campus`, `health-system tenant`, `life science`, `wet lab`, `BSL-2` *(lab context)*, `vivarium`, `senior housing`, `IL`, `AL`, `MC`, `SNF`, `RIDEA`, `triple-net healthcare`, `CON` *(certificate of need)*.

**Facilities-management services firm** — lead with `facilities-operations-lead`, `field-service-coordinator`.
- Customer-name patterns: JLL, CBRE, Cushman & Wakefield, Colliers, Newmark, Savills *(US)*, Avison Young *(FM divisions of these brokerage / services giants)*; pure-play FM: ABM Industries, ISS Facility Services, Sodexo Workplace, Aramark Workplace, Compass Group Workplace, EMCOR Facilities, BGIS, C&W Services; substrings: "Workplace Services", "Facility Management", "FM Services", "Facilities Solutions".
- Prompt patterns: `CMMS`, `BMS`, `IWMS`, `space management`, `workplace experience`, `corporate occupier`, `account-based FM`, `integrated facilities management`, `IFM`, `EnergyStar`, `EUI`, `LEED`, `WELL`, `ENERGY STAR Portfolio Manager`, `Maximo`, `Nuvolo`, `Planon`, `ServiceChannel`, `OSHA 30`, `lockout / tagout`.

**Net-lease REIT** — lead with `property-manager`, `capital-markets-acquisitions-director` *(must-include — owner-side economic buyer; especially load-bearing here given 1031 / sale-leaseback / WALT / credit-tenant dynamics)*.
- Customer-name patterns: Realty Income / O, NNN REIT *(formerly National Retail Properties)*, Agree Realty, W. P. Carey, STORE Capital *(legacy — Blue Owl-owned)*, Spirit Realty, EPR Properties, Four Corners Property Trust; substrings: "Net Lease", "Net-Lease".
- Prompt patterns: `net lease`, `NNN`, `triple-net`, `single-tenant`, `STNL`, `credit tenant`, `investment-grade tenant`, `1031`, `sale-leaseback`, `long-duration lease`, `escalator`, `WALT` *(weighted average lease term)*, `cap rate spread`.

**Residential brokerage** — *out of scope for this pack.* The Phase 2b ECR split deferred residential brokerage to a planned `residential-real-estate-brokerage.md` pack (Phase 3+). If a customer needs that lens (MLS, agent productivity, dotloop / kvCORE / BoldTrail, commission split, transaction sides, brokerage recruiting / retention), file a Phase 3+ pack request and use generic stakeholder personas in the interim.

**Ambiguous signals** — when a name spans sub-types (e.g., a diversified REIT with office + retail + industrial; a brokerage giant whose FM-services arm is the target; a "Properties" name that could be REIT or small private operator; a healthcare REIT whose tenant relationship is more like a credit-tenant net-lease than a traditional landlord), ask one clarifying question: *"Is the customer an office, retail, industrial, multifamily, or healthcare CRE owner-operator; a facilities-management services firm; or a net-lease REIT?"* Load only that sub-group's lead personas. If the conversation is build-side (RFI, submittal, pay-app, lien-waiver, BIM, project pursuit), the customer probably belongs in `aec-construction.md` rather than this pack.

## Recommended industry-specific persona files

For this pack, the personas are:

- capital-markets-acquisitions-director.md — Owns acquisitions, dispositions, and portfolio strategy across asset classes; the owner-side economic buyer who vetoes deals that don't pencil and gates any platform spend on whether it amortizes across the portfolio. Reads pitches against cap rate, NOI, IRR, equity multiple, spread to debt cost, and LP / GRESB-reporting implications.
- facilities-operations-lead.md — Runs day-to-day operations of an owned or managed building portfolio — HVAC, life safety, security, custodial, energy. Reads smart-building and workplace-experience pitches against PM compliance, MTTR, EUI, and the LL97 / BERDO / BEPS compliance path.
- property-manager.md — Manages leasing, tenant relationships, and operating P&L of a multi-tenant property; translates ownership goals into tenant experience and NOI. Reads tenant programs against retention, occupancy, NOI, and fair-housing / ADA / source-of-income exposure.
- tenant-experience-lead.md — Designs the day-in-the-life experience for occupants — amenities, programming, app, communications, service requests. Reads pitches against actual engagement and time-in-building, accessibility (WCAG), and occupant-data consent.

*Pack now ships 4 personas; under the default 5-cap, all 4 may load when an owner-operator conversation is in scope.*

## Recommended product-pack pairings

When this industry is active, these product packs are most commonly relevant — the recommender should prefer them unless the user has explicitly set `--product`:
- service-cloud — Tenant / resident service cases, work-order intake, and Agentforce-driven service triage.
- field-service — In-house engineer dispatch, PM scheduling, and vendor work-order management when Salesforce is the chosen platform alongside the CMMS.
- experience-cloud — Tenant, resident, and corporate-occupier portals; the front door for service requests and amenity booking.
- marketing-cloud — Resident lifecycle (lease-up, renewal, retention), tenant communications, and event programming.
- data-cloud — Unifying CRM with Yardi / MRI / RealPage, CMMS, BMS, access-control, and ESG-reporting data for portfolio-level insight.

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources for this industry, suggest:
- https://www.salesforce.com/solutions/industries/real-estate/
- https://uli.org/  (Urban Land Institute — CRE strategy, capital flows, market reports)
- https://www.nmhc.org/  (National Multifamily Housing Council — multifamily policy, data, operations)
- https://www.corenetglobal.org/  (CoreNet Global — corporate occupier / workplace strategy)
- https://www.ifma.org/  (International Facility Management Association)
- https://www.naiop.org/  (NAIOP — Commercial Real Estate Development Association)
- https://www.boma.org/  (Building Owners and Managers Association — CRE operations)
- https://www.gresb.com/  (GRESB — ESG benchmarking for real estate)
- https://www.ncreif.org/  (NCREIF — institutional real estate investment performance)
- https://www.str.com/  (STR — hospitality-CRE performance data; load when hotels-as-asset is in scope)
- https://www.energystar.gov/buildings  (ENERGY STAR Portfolio Manager — benchmarking and disclosure)
- https://www.nareit.com/  (Nareit — US REIT industry association)

## Common sales-conversation pitfalls in this industry

1. Treating CRE as one — office, retail, industrial, multifamily, healthcare, FM-services, and net-lease have meaningfully different operating models, tenant relationships, and competitive sets.
2. Pitching tenant-experience apps without engaging the tenant-experience platform incumbent (HqO, Equiem, VTS Activate) — Experience Cloud has to differentiate or integrate, not pretend the category doesn't exist.
3. Pitching "Yardi / MRI replacement" — these are the financial-and-leasing system of record, not a CRM front-end; positioning Salesforce as an integration-and-engagement layer lands; positioning it as a PMS replacement does not.
4. Ignoring fair-housing in multifamily — marketing-automation, prospect-scoring, and AI-assisted leasing all carry FHA / source-of-income exposure that has produced enforcement actions; Legal will pause the deal.
5. Underestimating LL97 / BERDO / BEPS — building-performance penalties are real, asset-level, and escalating; sustainability pitches that lack EUI math and a compliance path will not move past asset management.
6. Conflating institutional CRE with small / private operators — operating-budget sensitivity, tech-adoption posture, and procurement shape are different; a Yardi Voyager / MRI deployment story does not translate to a 30-property private operator on Yardi Breeze or AppFolio.

## Common prompt patterns

Pack-specific quick wins — when a prompt names one of these themes, prefer the listed persona blend over the generic full panel:

- **Tenant-experience app / portal** — Tenant Experience Lead + Experience Cloud SE + Property Manager. Differentiation against HqO / Equiem / VTS Activate is the conversation; integration with access control, BMS, and amenity booking is the gating technical question.
- **CMMS / Field Service for in-house engineers** — Facilities Operations Lead + Field Service SE + Architect. Maximo / Nuvolo / Planon integration is the deal-shaper; "replacement vs integration" framing has to be explicit.
- **Building-performance / EUI / LL97 compliance** — Facilities Operations Lead + Data Cloud SE + Compliance Officer. EUI math, ENERGY STAR Portfolio Manager integration, and the per-asset compliance path are required; dashboards alone don't close.
- **Multifamily resident lifecycle (lease-up to renewal)** — Property Manager + Marketing Cloud SE + Tenant Experience Lead. Fair-housing exposure (audience targeting, content, source-of-income protection) is a Legal-required design constraint.
- **Leasing pipeline / broker-team management** — Property Manager + Sales Cloud SE + Industry Specialist. Yardi / MRI integration on lease abstract and rent-roll data is the data conversation that gates pipeline-to-PMS handoff.

## Regulatory landscape (one paragraph)

CRE operates in a layered regulatory environment that intersects accessibility, fair-housing, building-performance, and life-safety. ADA Titles II and III govern accessibility in public-accommodation portions of commercial properties; FHA / HUD enforcement plus state-and-local source-of-income protections govern multifamily marketing, screening, and operations. State-and-local landlord-tenant law (rent control, just-cause eviction, security-deposit handling, notice requirements) varies wildly by jurisdiction. Building-performance ordinances are spreading — NYC Local Law 97 with escalating 2024-2029 caps, Boston BERDO, Washington DC BEPS, Denver Energize, Seattle Building Tune-Ups, Chicago Energy Benchmarking, and similar measures in 25+ US jurisdictions and analogs under the EU EPBD — carry real per-asset financial penalties. ENERGY STAR Portfolio Manager benchmarking disclosure is mandatory in many cities. Building codes (IBC / IFC / IPC / IMC / NEC), ASHRAE standards (62.1 ventilation, 90.1 / 189.1 energy, indoor-air-quality guidance), NFPA codes (life-safety, fire-alarm, sprinkler), and elevator / ADA-related maintenance requirements drive operational compliance. EPA refrigerant rules (Section 608 plus the AIM Act HFC phase-down) constrain mechanical equipment replacement. State privacy laws (CCPA / CPRA, etc.) apply to tenant, resident, employee, and visitor data; building-data privacy (occupancy sensors, badge logs) is a growing area of attention. ESG-disclosure expectations are intensifying through GRESB participation, EU CSRD, and the evolving SEC climate-disclosure rule. None of this constitutes legal advice — the persona should flag regulatory questions for counsel, the privacy office, the building-engineer-of-record, and the compliance function rather than over-promise.
