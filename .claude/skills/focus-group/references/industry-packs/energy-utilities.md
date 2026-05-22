# Energy & Utilities — Industry Pack

The energy and utilities industry covers regulated electric, gas, and water utilities (IOUs, munis, co-ops), independent power producers, retail energy providers in deregulated markets, and increasingly renewables developers, EV-charging operators, and DER (distributed energy resource) aggregators. Top pressures right now are the energy transition (renewables interconnection, grid modernization, electrification of transport and heat), aging infrastructure and workforce, and a regulatory environment in flux — climate disclosure, resource adequacy, and customer-affordability scrutiny all in motion at the same time. Salesforce typically engages here through Energy & Utilities Cloud (sitting on Sales/Service Cloud with industry-specific data models, contracts, and rebate/program management — the former Vlocity assets), Service Cloud for outage and care, Field Service for crews, Marketing Cloud for program and DSM engagement, and Data Cloud for meter and customer event unification. The buying center is split across customer operations (care, billing, programs), grid/operations, and a regulatory affairs office, with the CIO often coordinating.

## Grounding prompt (injected into every persona)

### Vocabulary

Use the industry's actual vocabulary. Customers are "ratepayers" or "premises"; an account is usually tied to a "service point" or "service address", not just a person. The "CIS" (Customer Information System — Oracle CC&B, SAP IS-U, Itineris, Gentrack, Hansen) is the system of record for billing and meter-to-cash; "AMI" is the smart-meter infrastructure; "MDM" here is "meter data management" (not master data management); "DSM/DR" are demand-side management and demand response programs. "Rate cases" are how regulated utilities change prices. "Interconnection queue" is where rooftop solar and large generators wait. "T&D" is transmission and distribution. "Outage" workflows touch OMS (outage management system) and SCADA.

### Honest objections — regulated utility (IOU, muni, co-op)

The honest objections this industry raises against generic SaaS pitches: (1) "Our CIS is the system of record and we cannot rip it out" — Salesforce sits alongside, not on top of, billing/meter-to-cash; (2) "Anything customer-facing has to survive a major storm" — outage spikes drive 10-50x normal volume and call-center/IVR/web load expectations are not casual SLAs; (3) "We are regulated and every customer-program change is a filing" — speed-to-launch claims that ignore PUC/PSC approval cycles lose credibility.

### Honest objections — non-utility energy customers

The honest objections these adjacent sub-verticals raise — the IOU framing above does not transfer:

**Upstream O&G / midstream / downstream:** (1) "Your SaaS commit lands in the wrong half of the capex cycle" — a multi-year subscription floated during a downturn quarter (sub-$60 WTI, refining margin compression, or a midstream tariff dispute) gets benched regardless of merit; sequence the ask to the capital-program calendar, not the seller's quarter. (2) "If the workflow touches an offshore platform, a compressor station, or a refinery unit, EHS sign-off is non-negotiable" — every process change rides an HSE overlay (PSM, MOC, JSA, permit-to-work); a demo that hand-waves the safety-management-system integration loses the room. (3) "We think in $/bbl, $/Mcf, or $/MMBtu — not in transformation" — cost-discipline is the cultural frame; "transformational" pricing and 7-figure platform fees without unit-economic grounding read as oilfield-naive and get redlined by procurement.
**Renewables developer / IPP:** (1) "The IRA bonus-credit timeline gates the whole project" — prevailing-wage + apprenticeship + domestic-content + energy-community rule sign-off is a deal precondition, not a nice-to-have; any tool that cannot trace credit-qualification evidence to the project record is a tax-equity blocker. (2) "Tax-equity vs. transferability is a counterparty-risk question, not just a financing question" — the choice between a traditional tax-equity partnership and a §6418 transfer (and which buyer / which insurance wrap) drives different data, different covenants, and different reporting; SaaS sellers who conflate the two lose credibility with the CFO. (3) "The interconnection-queue calendar drives every commitment we can make" — LGIA execution, network-upgrade cost allocation, and ISO cluster-study cycles are the binding constraint; commitments to ship features or contracts that ignore queue position are non-credible.
**Retail energy supplier (deregulated):** (1) "CAC-payback-per-cohort governs everything" — if customer-acquisition-cost payback isn't under ~18 months for the channel-cohort being pitched, the deal dies in the next board review regardless of platform elegance; lead with cohort economics or don't pitch. (2) "The ERCOT-style weather event is our existential risk" — Uri-class scarcity pricing, ancillary-services cost spikes, and the resulting bill-shock + PUC backlash can end a REP in a single billing cycle; any tool that touches pricing, hedging signals, or customer communications must hold up under that scenario. (3) "The state PUC's complaint queue is our customer-care KPI" — regulator-of-last-resort complaints (PUC complaint codes, AG referrals, slamming/cramming allegations) drive license risk and renewal eligibility; resolution-time and first-touch-resolution against the PUC queue matter more than CSAT in deregulated markets.

### Regulatory frame

The compliance and regulatory realities a persona should keep in mind: in the US, state public utility commissions (PUC/PSC) regulate rates, programs, and many customer practices for IOUs; NERC CIP critical-infrastructure standards govern grid cybersecurity; CCPA/CPRA and state privacy laws apply to customer data; in regulated water and gas, EPA and PHMSA rules add layers; in the EU, national regulators plus Network Codes and GDPR apply. The dominant Salesforce footprint is Energy & Utilities Cloud + Service Cloud + Field Service, with Marketing Cloud for energy-efficiency and DR program engagement and Data Cloud for meter/customer unification. Decisions typically need alignment across customer operations, IT, regulatory affairs, and grid operations.

## Customer-type classifier (which sub-industry — regulated utility, muni/co-op, O&G, renewables, or retail supplier?)

"Energy & Utilities" is a basket label that hides at least seven structurally different businesses. A regulated electric IOU panel is not the same panel as a Permian E&P operator, a midstream MLP, a community solar developer, or a Texas retail electric provider — different system landscape, different regulators, different buyers, different objections. The skill should detect which sub-type the customer belongs to and weight the panel accordingly. Detection signals (case-insensitive substring match on the customer name + the prompt body; first hit wins; ties resolved by asking one clarifying question).

**Regulated IOU (electric, gas, water)** — lead with `regulatory-affairs`, `customer-care-director`, `billing-metering-lead`, `field-operations-manager`. Must-include `nerc-cip-cybersecurity-lead` (BES cyber compliance is non-negotiable for any electric IOU) and `grid-ops-iso-rto-coordinator` (for any transmission-touching deal — EMS/SCADA, ISO market, interconnection-queue, or real-time-grid topic).
- Customer-name patterns: named IOUs: `PG&E`, `Pacific Gas & Electric`, `Southern California Edison`, `SCE`, `Duke Energy`, `Xcel Energy`, `Dominion Energy`, `Consolidated Edison`, `Con Ed`, `Exelon`, `ComEd`, `PSEG`, `National Grid`, `NextEra`, `FPL`, `Florida Power & Light`, `Southern Company`, `Georgia Power`, `Alabama Power`; substrings: `Power`, `Electric`, `Gas Company`, `Water Company`; `IOU`.
- Prompt patterns: `rate case`, `PUC`, `PSC`, `prudency review`, `intervenor`, `ALJ`, `state commission`, `CIS`, `Oracle CC&B`, `SAP IS-U`, `WMP`, `wildfire mitigation`.

**Municipal utility / co-op / public power** — lead with `customer-care-director`, `field-operations-manager`. Must-include `nerc-cip-cybersecurity-lead` (CIP applies to any BES-registered entity regardless of ownership model) and `grid-ops-iso-rto-coordinator` (for any transmission-touching muni/co-op or G&T cooperative).
- Customer-name patterns: `Municipal Utilities`, `Public Utility District`, `PUD`, `Electric Cooperative`, `Co-op`, `Co-operative`, `Rural Electric`; named: `LADWP`, `SMUD`, `Seattle City Light`, `Austin Energy`, `CPS Energy`, `JEA`, `Nebraska Public Power`, `Tennessee Valley Authority`, `TVA`, `Salt River Project`, `SRP`, NRECA member co-ops.
- Prompt patterns: `muni`, `PUD`, `co-op`, `RUS`, `APPA`, `NRECA`, `member-driven`, `municipal board`, `co-op board`, `Touchstone Energy`.

**Upstream O&G (E&P)** — load this pack additively with `sales-cloud` and `manufacturing` packs; lead with NEW persona to be added later (see Phase 3); for now load generic-technical Enterprise Architect.
- Customer-name patterns: `Exploration`, `E&P`, `Petroleum`; named: `ExxonMobil`, `Chevron`, `ConocoPhillips`, `Occidental Petroleum`, `EOG Resources`, `Pioneer Natural Resources`, `Devon Energy`, `Marathon Oil`, `Hess`, `Diamondback Energy`.
- Prompt patterns: `upstream`, `E&P`, `shale`, `Permian`, `Bakken`, `Eagle Ford`, `completions`, `drilling`, `frac`, `working interest`, `royalty`, `acreage`, `bbl/d`.

**Midstream / pipeline** — load NEW persona for pipeline integrity (Phase 3). Must-include `nerc-cip-cybersecurity-lead` (the post-Colonial-Pipeline TSA Security Directive parallel regime applies to pipeline OT — same audit-defense and ICS-segmentation lens carries over).
- Customer-name patterns: `Pipeline`, `Midstream`, `Partners` *(MLP context)*; named: `Enterprise Products Partners`, `Kinder Morgan`, `Energy Transfer`, `Williams Companies`, `ONEOK`, `Magellan Midstream`, `Plains All American`, `MPLX`, `Targa Resources`, `Cheniere Energy`.
- Prompt patterns: `midstream`, `pipeline`, `LNG`, `FERC certificate`, `PHMSA`, `integrity management`, `compressor station`, `terminal`, `pipeline expansion`, `Section 7 certificate`, `TSA pipeline directive`, `Colonial Pipeline`.

**Downstream / refiner / petrochemical** — load `manufacturing` pack additively.
- Customer-name patterns: `Refining`, `Petrochemical`, `Chemicals` *(petrochem)*; named: `Marathon Petroleum`, `Phillips 66`, `Valero`, `HF Sinclair`, `Delek`, `PBF Energy`, `Dow`, `LyondellBasell`, `Westlake`.
- Prompt patterns: `refinery`, `petrochem`, `BTU`, `crack spread`, `turnaround`, `catalyst`, `OSHA PSM`, `RMP`.

**Renewables developer / IPP** — lead with `renewables-developer-vp` (project-sponsor seat — the developer-side lens on PPAs, queue, and tax-equity stack); also include `grid-ops-iso-rto-coordinator` (the queue and ancillary-services counterparty view) and `nerc-cip-cybersecurity-lead` (BES-registered generation falls under CIP at the applicable impact rating). Note `renewables-transition-pm` is the *utility-side* DER/EV/electrification PM and should not lead here — it is a complement, not a substitute, for the developer-VP seat.
- Customer-name patterns: `Renewables`, `Renewable Energy`, `Solar`, `Wind`; named: `NextEra Energy Resources`, `AES`, `Brookfield Renewable`, `Ørsted`, `Pattern Energy`, `Invenergy`, `EDP Renewables`, `RWE Renewables`, `Avangrid Renewables`, `Clearway Energy`.
- Prompt patterns: `IPP`, `PPA`, `VPPA`, `ITC`, `PTC`, `IRA bonus credits`, `domestic content`, `energy community`, `transferability`, `ISO interconnection queue`, `queue position`, `LGIA`, `LMP`, `merchant tail`, `tax equity`, `EPC contractor`, `BESS`, `battery storage`, `Megapack`, `NTP`, `COD`.

**Retail energy supplier (deregulated markets)** — lead with `customer-care-director` *(retail-supplier sub-profile when populated)*, `billing-metering-lead`.
- Customer-name patterns: `Energy`, `Power` *(retail supplier suffix in deregulated markets like Texas)*; named: `Constellation`, `Direct Energy`, `Reliant`, `TXU Energy`, `NRG`, `Vistra`, `Calpine` *(retail arm)*, `Engie Resources`.
- Prompt patterns: `REP`, `retail electric provider`, `ERCOT`, `retail choice`, `CCA`, `community choice aggregation`, `churn`, `switching campaign`, `acquisition cost`, `serve-and-bill`.

**Ambiguous signals** (e.g., `NextEra` could be the regulated IOU FPL parent or the NextEra Energy Resources renewables IPP arm; `Marathon` could be upstream `Marathon Oil` or downstream `Marathon Petroleum`; a generic name like `Apex Energy` matches multiple groups; or no name was given) — ask one clarifying question rather than guess: *"Is the customer a regulated utility (electric/gas/water IOU), a municipal utility or co-op, an upstream oil & gas (E&P) operator, a midstream/pipeline company, a downstream refiner or petrochemical maker, a renewables developer / IPP, or a retail energy supplier in a deregulated market?"* Then load only that sub-group's personas.

## Recommended industry-specific persona files

Each industry pack contributes 3-5 industry-specific personas at `personas/industries/energy-utilities/<role-slug>.md` (these get created in a separate Phase). For this pack, the personas are:

- customer-care-director.md — Owns contact center, digital self-service, and outage communications.
- billing-metering-lead.md — Owns the CIS/MDM landscape and meter-to-cash integrity.
- renewables-transition-pm.md — Owns *utility-side* DER programs, EV-charging, electrification, and interconnection workflow.
- field-operations-manager.md — Owns crew dispatch, work and asset management, and storm response.
- regulatory-affairs.md — Owns rate cases, program filings, and PUC/PSC relationships.
- nerc-cip-cybersecurity-lead.md — Owns BES cyber compliance (CIP-002 through CIP-014), ESP/PSP boundaries, ICS/SCADA security, and the TSA pipeline directive for gas/midstream customers.
- grid-ops-iso-rto-coordinator.md — Owns real-time transmission operations, EMS/SCADA console work, ISO/RTO market participation, and interconnection-queue coordination.
- renewables-developer-vp.md — Owns *developer-side* IPP project origination, PPA structuring, tax-equity and IRA bonus credits, and the financial-close-to-COD project lifecycle.

The pack now ships 8 personas, but no single customer needs all 8. The panel-composer should bias by sub-vertical (see the classifier above) — for any given customer only 4-5 of the 8 personas fire as leads, with the rest available as on-call complements. Loading all 8 by default produces a noisy panel; let the classifier do the routing.

## Recommended product-pack pairings

When this industry is active, these product packs are most commonly relevant — the recommender should prefer them unless the user has explicitly set `--product`. The pairings split by sub-vertical: the default Field-Service + Marketing-Cloud-as-loyalty stack is right for regulated utilities, mostly wrong for retail suppliers, and meaningfully wrong for IPPs and O&G operators. Route by the classifier above.

### For regulated utility (IOU, muni, co-op)

- service-cloud — Customer care, outage handling, and program enrollment case management.
- field-service — Crew dispatch, work orders, and integration with WAM/OMS for storm and routine work.
- marketing-cloud — Program enrollment, energy-efficiency and DR engagement, outage notifications.
- data-cloud — Customer 360 spanning CIS, MDM, OMS, and digital — central to modernization narratives.

### For upstream / midstream / downstream O&G

The buying motion is account-team-led, contract-structure-heavy, and SAP-S/4HANA-anchored on the back end. NO Field Service (crew-dispatch model does not match operator/contractor split on a platform or refinery), NO Marketing-Cloud-as-loyalty (no retail-consumer relationship to nurture):
- sales-cloud — Account team, opportunity management, and joint-venture / working-interest partner coordination.
- revenue-cloud — Complex contract structures (JOAs, gathering and processing agreements, tolling, take-or-pay, MSA + work-order hierarchies).
- manufacturing — Asset-tracking, equipment-as-a-service, and the run-rate / planned-turnaround lens that mirrors process-manufacturing cadence.
- data-cloud — Unification across SAP S/4HANA Energy, SCADA/historian, EHS, and partner / counterparty systems.
- mulesoft — SAP S/4HANA Energy integration is the load-bearing connection; treat it as a first-class workstream, not an afterthought.

### For renewables developer / IPP

The buying motion is project-finance-led — PPA structuring, tax-equity / transferability decisions, and interconnection-queue tracking drive the data model. NO Field Service (O&M is typically outsourced to the OEM or an asset-manager), NO Marketing Cloud (no retail customer):
- sales-cloud — Project pipeline, offtaker / corporate-PPA buyer relationships, and EPC / OEM partner coordination.
- revenue-cloud — PPA, VPPA, hedge, and tax-equity / §6418-transfer contract complexity, plus the IRA bonus-credit qualification record.
- data-cloud — Queue-position telemetry, ISO LMP / ancillary-services price signals, offtaker-pricing curves, and the project-finance data room.
- mulesoft — Integration to project-finance models, GIS / queue trackers, and OEM equipment-data feeds.

### For retail energy supplier (deregulated)

The buying motion is CAC-and-cohort-LTV-led; Field Service is mostly irrelevant (no wires-and-poles crews — the wires utility owns those):
- marketing-cloud — Acquisition campaigns, retention / win-back, renewal nudges, and price-plan migration journeys.
- service-cloud — PUC-complaint workflow, billing-dispute resolution, and the regulator-of-last-resort queue.
- commerce-cloud — Sign-up flow, plan comparison and selection, and the digital enrollment funnel.
- data-cloud — Cohort LTV, channel-attributed CAC, churn-risk scoring, and the load / weather / hedge signal fabric.
- mulesoft — Integration to the ISO settlement systems (ERCOT, PJM, ISO-NE), the wires-utility EDI feeds, and the billing engine.

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources for this industry, suggest:
- https://www.salesforce.com/industries/energy-utilities/
- https://www.eei.org/  (Edison Electric Institute — US IOU industry association)
- https://www.nerc.com/  (NERC — bulk-power-system reliability and CIP cybersecurity standards)
- https://www.ferc.gov/  (US wholesale market and interstate transmission regulator)
- https://www.iea.org/  (International Energy Agency — global energy data and policy)
- https://www.api.org/  (API — American Petroleum Institute, upstream/downstream O&G)
- https://www.ingaa.org/  (INGAA — Interstate Natural Gas Association of America, midstream pipelines)
- https://www.seia.org/  (SEIA — Solar Energy Industries Association)
- https://cleanpower.org/  (ACP — American Clean Power Association, wind; formerly AWEA)
- https://www.naruc.org/  (NARUC — National Association of Regulatory Utility Commissioners, state regulators)
- https://www.aga.org/  (AGA — American Gas Association)

## Common sales-conversation pitfalls in this industry

1. Confusing regulated utilities with deregulated retailers — they have very different competitive postures, customer-acquisition motions, and regulatory exposure.
2. Pitching customer-experience modernization without an outage-day plan — storms and major events are the moments that define customer trust.
3. Underestimating the CIS — billing and meter-to-cash are decade-long replacements and the political center of gravity in many utilities.
4. Treating field crews like office workers — connectivity, ruggedized devices, and union work rules constrain Field Service rollout.
5. Ignoring rate-case cadence — a new customer-facing program can require a regulatory filing and months of approval before launch.

## Regulatory landscape (one paragraph)

Persona should keep in mind: in the US, state PUCs/PSCs regulate rates, customer programs, disconnection rules, and many service practices for investor-owned utilities; FERC regulates wholesale and interstate transmission; NERC CIP standards constrain operational technology and customer-data systems that touch the bulk power system; EPA rules and (for gas) PHMSA add environmental and safety layers; CCPA/CPRA and state privacy laws cover customer data, with smart-meter data getting heightened attention in some states; in the EU, national regulators, ACER, and GDPR apply. None of this constitutes legal advice — the persona should flag regulatory questions for counsel and regulatory affairs rather than over-promise.
