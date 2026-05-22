# Manufacturing — Industry Pack

Manufacturing covers discrete (automotive, industrial equipment, electronics, aerospace components), process (chemicals, food and beverage, building materials), and high-mix low-volume (medical devices, defense) makers, plus the channel and aftermarket businesses that wrap around them. The top pressures right now are supply-chain volatility and tariff exposure, the shift from pure product revenue to recurring service and aftermarket revenue, and the slow grind of connected-product and Industry 4.0 programs that have been promised for a decade and are finally being scoped against real telemetry. Salesforce engages most often through Manufacturing Cloud (Sales Agreements, Account-Based Forecasting, Rebate Management is now Revenue Cloud) paired with Service Cloud and Field Service for aftermarket, and increasingly Data Cloud and Agentforce for warranty, dealer, and channel use cases. The typical buyer shape is a VP of Sales or VP of Aftermarket as economic buyer, a Director of Commercial Operations or Channel Operations as champion, and an enterprise-architecture function that already runs SAP or Oracle ERP as the gating technical reviewer. Deals are slower than tech-vertical deals because the customer is balancing IT modernization against plant uptime — nothing ships unless the line keeps running.

## Grounding prompt (injected into every persona)

### Vocabulary

Manufacturing customers live in a world of sales agreements (multi-year volume and price commitments), forecasted vs actual volume reconciliation, rebate and incentive programs that pay out to dealers or distributors, warranty claims and recall events, install-base records that follow a serialized asset for its life, and field service that has to roll a truck with the right part and the right technician. They speak in terms of OEMs, Tier 1 / Tier 2 / Tier 3 suppliers, dealers, distributors, end customers, and aftermarket. They care about MES (manufacturing execution systems), PLM (product lifecycle), ERP (SAP S/4HANA, Oracle, Infor), and increasingly IIoT platforms (PTC ThingWorx, Siemens MindSphere / Insights Hub, AWS IoT, Azure IoT). They do not care about generic "sales productivity" pitches that ignore the channel.

### Honest objections — discrete / industrial OEM

The honest objections this industry raises against generic SaaS pitches are: (1) "Your demo assumes direct-to-customer revenue — most of our revenue moves through dealers and distributors and your data model has to handle that without custom objects everywhere"; (2) "We already have SAP — what is the integration story, who owns master data, and are you going to make my finance team reconcile two systems forever?"; (3) "Our plants run 24/7 and our field techs are in trucks — your mobile and offline story matters more than your AI story."

### Honest objections — process manufacturing (chemicals / food-bev / pharma raw)

The honest objections this sub-vertical raises are: (1) "Batch-record and cGMP signoffs gate every workflow — if your platform can't produce an auditable batch genealogy on demand, it sits outside the system of record and we don't care how slick the UI is"; (2) "Recipe IP cannot leave the platform of record — your Data Cloud story has to explain exactly where formulation data lives, who can see it, and how it's segregated from competitors who also run on your stack"; (3) "Regulatory-recall-readiness has to be a designed-in feature, not an afterthought — show us the lot-trace workflow on day one or assume we'll model the gap as a custom-build cost against your TCO."

### Honest objections — heavy-equipment OEM

The honest objections this sub-vertical raises are: (1) "Dealer-network politics gate every customer-touching workflow — if your rollout bypasses or threatens dealer margin, our dealer council will kill it before IT even scores the integration"; (2) "Connected-equipment-data-ownership is a contractual fight, not a feature — we are negotiating with our own dealers and our own customers over who owns telematics, and your platform has to support whichever way that fight lands"; (3) "Right-to-repair legislation is structurally changing the aftermarket model — your roadmap has to acknowledge that parts, diagnostics, and service revenue we used to control are becoming contested, and the platform has to be on the right side of that shift."

### Honest objections — contract manufacturer / CDMO / EMS

The honest objections this sub-vertical raises are: (1) "Our customer's tech transfer is the entire deal — if we lose the data-integrity story, we lose the deal, so your platform has to demonstrate granular audit trail, change control, and customer-segregated visibility before we'll even score it"; (2) "MSA and take-rate economics governs every concession — your pricing model assumes a normal commercial deal, but ours is governed by a master service agreement with a customer who is also a competitor of our other customers, and that shapes every workflow"; (3) "Capacity-allocation transparency to multiple customers is the trust pillar — we have to show Customer A what we're doing for Customer A without leaking that Customer B is also on the same line, and your data model has to make that easy, not a custom build."

### Honest objections — distributor / channel

The honest objections this sub-vertical raises are: (1) "POS-data-back-to-OEM is the wedge issue — every OEM we carry wants our sell-through data, and the platform's stance on who owns and monetizes that data is the first question our merchandising team will ask"; (2) "Contract-tier-management is the operational reality — we run dozens of pricing tiers across customer segments and OEM rebate programs, and if your CPQ can't model tier eligibility and waterfall accurately, sales ops will reject the rollout"; (3) "Secondary-distribution visibility is the analytics ask that doesn't have an off-the-shelf answer — when our customers resell into Tier 2 and Tier 3 we lose the trail, and no vendor has solved this cleanly, so be honest about what your platform actually delivers vs. what it just enables us to build."

### Regulatory frame

Compliance and regulatory realities to keep in mind: ITAR and EAR for aerospace/defense customers, FDA 21 CFR Part 820 and Part 11 for medical-device makers, FSMA and HACCP for food and beverage, REACH and RoHS for chemicals and electronics sold into the EU, and a growing patchwork of right-to-repair and product-passport rules in the EU. Buyer-side: recall execution is a load-bearing concern (CPSC / NHTSA / FDA depending on product class) — personas should treat recall workflow as a first-class topic, not an afterthought. The dominant Salesforce footprint pattern is Sales Cloud + Manufacturing Cloud + Service Cloud + Field Service, with MuleSoft as the integration backbone to SAP/Oracle and Data Cloud increasingly required for connected-asset telemetry. Decision-making is usually a committee: commercial leadership owns the revenue case, IT/enterprise architecture owns the integration and master-data case, and a plant or aftermarket operations leader has effective veto if the rollout threatens uptime.

## Customer-type classifier (which sub-industry — discrete, process, heavy-equipment, contract manufacturer, or distributor?)

Manufacturing spans five structurally different sub-industries. The skill should detect which one the customer belongs to and weight the panel accordingly — a process-chemicals panel ≠ a heavy-equipment OEM panel ≠ a contract-manufacturer panel even though all sit under "manufacturing". Detection signals (case-insensitive substring match on the customer name + the prompt body; first hit wins; ties resolved by asking one clarifying question).

**Discrete industrial / industrial equipment** — lead with `channel-partner-manager`, `aftermarket-service-director`, `plant-operations-lead`, `warranty-operations-lead`, `supply-chain-sop-lead` *(must-include when Sales Agreements / Account Forecasts / Advanced Account Forecasts are in scope)*.
- Customer-name patterns: named: `Honeywell`, `Emerson Electric`, `Eaton`, `Parker Hannifin`, `Rockwell Automation`, `Schneider Electric`, `ABB`, `Siemens` *(industrial divisions)*, `Cummins`, `Illinois Tool Works`, `ITW`, `Dover`, `Roper Technologies`, `Fortive`, `Stanley Black & Decker`; substrings: `Industries`, `Industrial`, `Technologies` *(industrial context)*, `Equipment`, `Controls`, `Instruments`.
- Prompt patterns: `OEE`, `FPY`, `first-pass yield`, `MES`, `SCADA`, `PLC`, `IIoT`, `digital thread`, `predictive maintenance`, `IATF 16949`, `AS9100`, `serial number`, `BOM`, `engineering change order`, `ECO`.

**Process manufacturing (chemicals / food-bev / pharma raw / pulp-paper)** — lead with `plant-operations-lead`, `warranty-operations-lead` *(quality sub-profile)*, `supply-chain-sop-lead` *(must-include when Sales Agreements / Account Forecasts / Advanced Account Forecasts are in scope; tariff and country-of-origin exposure is acute in this sub-vertical)*.
- Customer-name patterns: chemicals: `Dow`, `DuPont`, `BASF`, `LyondellBasell`, `Eastman`, `Celanese`, `Westlake`, `Ashland`, `Albemarle`, `FMC`; food-bev: `Tyson`, `Smithfield`, `JBS`, `ADM`, `Cargill`, `Bunge`, `Conagra`, `Kraft Heinz` *(process side)*, `AB InBev` *(brewing)*; pharma raw: `Lonza`, `Catalent`, `Recipharm`; substrings: `Chemicals`, `Sciences`, `Materials`, `Foods` *(process side)*, `Brewing`, `Beverages`.
- Prompt patterns: `recipe`, `batch`, `continuous process`, `cGMP`, `21 CFR 211`, `FSMA`, `HACCP`, `REACH`, `OSHA PSM`, `RMP`, `process safety`, `kosher`, `halal`, `organic certification`.

**Heavy-equipment OEM** — lead with `dealer-network-director`, `aftermarket-service-director`, `warranty-operations-lead`, `supply-chain-sop-lead` *(must-include when Sales Agreements / Account Forecasts / Advanced Account Forecasts are in scope; LTA and allocation-rule conversations are routine here)*.
- Customer-name patterns: named: `Caterpillar`, `John Deere` *(equipment side)*, `AGCO`, `CNH Industrial`, `Komatsu`, `Volvo Construction Equipment`, `Hitachi Construction`, `JCB`, `Doosan Bobcat`, `Terex`, `Manitowoc`, `Oshkosh`; substrings: `Earthmover`, `Construction Equipment`, `Ag Equipment`, `Off-Highway`.
- Prompt patterns: `dealer`, `equipment dealer protection act`, `floorplan`, `fleet utilization`, `connected equipment`, `JD Link`, `Cat VisionLink`, `right to repair` *(ag/heavy-equip)*.

**Contract manufacturer / CDMO / CMO / EMS** — lead with `channel-partner-manager` *(customer-as-partner sub-profile)*, `plant-operations-lead`, `warranty-operations-lead`, `supply-chain-sop-lead` *(must-include when Sales Agreements / Account Forecasts / Advanced Account Forecasts are in scope; committed-capacity and min-volume-commit math is the heart of this sub-vertical)*.
- Customer-name patterns: named: `Foxconn`, `Pegatron`, `Wistron`, `Quanta`, `Flex`, `Jabil`, `Sanmina`, `Celestica`, `Benchmark` *(EMS)*; CDMO: `Lonza`, `Catalent`, `Patheon`, `Recipharm`, `Samsung Biologics`; substrings: `Contract Manufacturing`, `Solutions` *(EMS context)*, `Bio Services` *(CDMO)*.
- Prompt patterns: `CDMO`, `CMO`, `EMS`, `contract manufacturer`, `tech transfer`, `master service agreement`, `MSA`, `take rate`, `cost per unit`, `yield bonus`, `committed capacity`, `last-time-buy`.

**Distributor / channel** — lead with `channel-partner-manager`, `aftermarket-service-director`.
- Customer-name patterns: named: `Grainger`, `Fastenal`, `MSC Industrial`, `HD Supply`, `Wesco`, `Anixter` *(now Wesco)*, `Applied Industrial Technologies`, `Motion Industries`, `Hisco`; substrings: `Industrial Supply`, `Distribution` *(industrial)*, `Distributors`, `Wholesale` *(industrial)*.
- Prompt patterns: `distributor`, `value-added reseller`, `Tier 2`, `Tier 3`, `secondary distribution`, `master distributor`, `franchise dealer` *(industrial)*, `MDF`, `co-op funds`, `POS data`, `sell-through`.

**Ambiguous signals** (e.g., `Honeywell` could be discrete industrial or aerospace; `Lonza` straddles process manufacturing and CDMO; or no name was given) — the skill should ask one clarifying question rather than guess: *"Is the customer a discrete industrial / equipment maker, a process manufacturer (chemicals / food-bev / pharma raw), a heavy-equipment OEM, a contract manufacturer (CDMO / CMO / EMS), or an industrial distributor?"* Then load only that sub-group's lead personas.

## Recommended industry-specific persona files

Each industry pack contributes 3-5 industry-specific personas at `personas/industries/<slug>/<role-slug>.md`. For this pack, the personas are:

- channel-partner-manager.md — Runs the indirect channel; cares about dealer enablement, deal registration, MDF, and rebate fairness.
- warranty-operations-lead.md — Owns warranty policy, claim adjudication, recovery from suppliers, and recall execution.
- dealer-network-director.md — Manages dealer/distributor relationships, territory rights, performance scorecards, and dealer portals.
- plant-operations-lead.md — Production and uptime owner; will veto any rollout that risks line stoppage or MES integration friction.
- aftermarket-service-director.md — Owns parts, service contracts, field service, and the shift from product to recurring service revenue.
- supply-chain-sop-lead.md — Owns the S&OP cycle, demand-supply reconciliation, supplier-risk and tariff exposure; the seat that says whether Sales Agreements are constrained-plan-valid.

The pack now ships six personas. For a 5-cap panel, swap based on engagement shape: drop `supply-chain-sop-lead` if it's channel-led with no allocation conversation; drop `plant-operations-lead` if it's aftermarket-pivot-led; drop `channel-partner-manager` or `dealer-network-director` if it's production-floor-led. Keep `supply-chain-sop-lead` any time Sales Agreements, Account Forecasts, or Advanced Account Forecasts are in scope — that's the conversation it exists to anchor.

## Recommended product-pack pairings

When this industry is active, these product packs are most commonly relevant. Stack composition varies by sub-vertical — pick the section that matches the customer-type classifier above.

### For discrete / industrial OEM

- sales-cloud — Manufacturing Cloud rides on Sales Cloud; Sales Agreements and Account-Based Forecasting are the load-bearing features.
- service-cloud — Warranty, recall, and aftermarket case management; pairs with Field Service for truck-roll work.
- field-service — Install-base, scheduling, mobile/offline for technicians; non-negotiable for aftermarket-heavy customers.
- mulesoft — SAP/Oracle ERP integration is almost always in scope; without an integration answer the deal stalls in technical review.
- data-cloud — Connected-asset telemetry, dealer DMS data, and warranty signal unification all push toward Data Cloud once use cases get specific.

### For process manufacturing

- sales-cloud — B2B account and opportunity backbone; Sales Agreements still apply for multi-year volume commitments with key customers.
- service-cloud — Regulatory complaint handling is the load-bearing use case here (FDA, FSMA, REACH adverse-event intake), not consumer service.
- data-cloud — Batch-genealogy aggregation across MES, LIMS, and ERP is the unique-to-process ask; recall trace depends on it.
- mulesoft — SAP / MES integration is the integration backbone; without it batch and lot data sits stranded.
- LESS Marketing Cloud emphasis — this is B2B-only with no consumer channel, so marketing-automation spend is hard to justify unless there's a downstream consumer brand.

### For heavy-equipment OEM

- sales-cloud — Account and opportunity backbone for the direct-sales motion that wraps around the dealer channel.
- manufacturing-cloud — Sales Agreements + Advanced Account Forecasts are uniquely fit here; LTAs with dealers and large fleet customers are the commercial reality.
- service-cloud + field-service — Connected-equipment aftermarket is where the recurring-revenue story lives; service contracts, parts, and truck-roll all run through this pairing.
- experience-cloud — Dealer portal is non-negotiable; the dealer network is the customer-of-the-customer and needs first-class self-service.
- data-cloud — Telematics from connected equipment (JD Link, Cat VisionLink, equivalents) plus dealer DMS data unification is the analytics ask.

### For contract manufacturer / CDMO / EMS

- sales-cloud — Multi-customer account hierarchy is genuinely hard here; the same legal entity may be a customer, competitor, and partner across different programs.
- revenue-cloud — MSA + statement-of-work complexity is the commercial reality; tiered pricing, take rates, yield bonuses, and capacity commitments need a real CPQ engine.
- service-cloud — Customer-incident response (quality escapes, tech-transfer issues, capacity disruption) is the load-bearing service motion.
- data-cloud — Customer-segregated visibility across shared lines and shared data assets is the trust pillar.
- mulesoft — Customer-tech-transfer integrations (their PLM / MES / ERP to yours) are bespoke per customer and integration patterns repeat.

### For distributor / channel

- sales-cloud + experience-cloud — PRM-style partner portal is the wedge; deal registration, MDF requests, and OEM-program enrollment all live here.
- revenue-cloud — Tiered pricing and rebate program management is the operational core; tier eligibility and waterfall accuracy is what sales-ops will judge the rollout on.
- service-cloud — Customer service across thousands of SKUs and dozens of OEM warranty programs is the daily reality.
- data-cloud — POS aggregation across stores and channels, plus sell-through data back to OEMs, is the analytics asset that defines the distributor's leverage with suppliers.

## URL seed-list (for /download grounding)

- https://www.salesforce.com/manufacturing/
- https://www.nam.org/ (National Association of Manufacturers; US policy and economic indicators)
- https://www.themanufacturinginstitute.org/ (workforce and skills data)
- https://www.fda.gov/medical-devices/quality-system-qs-regulationmedical-device-current-good-manufacturing-practices-cgmp (for medical-device makers)
- https://www.cisa.gov/topics/industrial-control-systems (OT/ICS security guidance — relevant when connected-asset topics come up)
- https://environment.ec.europa.eu/strategy/circular-economy/ecodesign-sustainable-products-regulation_en (EU Digital Product Passport)

## Common sales-conversation pitfalls in this industry

1. Treating the customer as direct-to-end-customer when 60-90% of revenue actually moves through a multi-tier channel — the demo lands flat the moment a Channel Director joins the call.
2. Pitching AI or Agentforce before answering the SAP integration and master-data question — the enterprise architect will assume you don't understand their reality and disengage.
3. Promising rebate management without acknowledging that the SKU moved into Revenue Cloud and the data model and pricing changed — credibility hit if the buyer's procurement team already knows.
4. Showing a service demo with a desk agent when the actual user is a field technician in a basement with no signal — mobile and offline have to be in the demo, not an appendix.
5. Underestimating the plant operations veto — if a rollout sounds like it could disturb MES or the line, the program will be deferred regardless of how clean the commercial case is.

## Regulatory landscape (one paragraph)

Manufacturing compliance varies sharply by sub-vertical. Aerospace and defense makers face ITAR (US State Department) and EAR (US Commerce Department) export controls that constrain who can access design and configuration data and from where; medical-device makers face FDA 21 CFR Part 820 (Quality System Regulation) and the EU MDR, both of which demand traceable design history and complaint handling; food and beverage operates under FSMA and HACCP in the US and similar regimes elsewhere; chemical and electronics manufacturers selling into the EU navigate REACH, RoHS, WEEE, and the emerging Digital Product Passport requirements under the Ecodesign for Sustainable Products Regulation. Cyber-physical risk is rising on the agenda — CISA guidance on industrial control systems, and the NIS2 directive in the EU, are reshaping how OT and IT teams cooperate. Personas should treat these as real constraints on data residency, audit, and integration design, not as boilerplate to be waved past.
