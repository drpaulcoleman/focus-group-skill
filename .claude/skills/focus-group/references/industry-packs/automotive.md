# Automotive — Industry Pack

The automotive industry covers OEMs (vehicle manufacturers), captive finance arms, franchised and independent dealer networks, fleet operators, and aftersales/service ecosystems. The top pressures right now are the transition to electric and software-defined vehicles (which compresses traditional aftersales revenue and forces new data and connectivity models), dealer-channel disintermediation as OEMs experiment with agency and direct-to-consumer models, and tariff/supply-chain volatility on batteries and semiconductors. Salesforce typically engages here through Automotive Cloud (sitting on Sales/Service Cloud), Data Cloud for connected-vehicle telemetry, Marketing Cloud for owner lifecycle, and increasingly Agentforce for service triage and dealer enablement. The buying center is split: OEM corporate (CRM, digital, connected-vehicle product) buys the platform, while dealers and dealer councils heavily influence rollout and adoption. Captive finance and fleet are often separate buying motions.

## Grounding prompt (injected into every persona)

### Vocabulary

Use the industry's actual vocabulary. Vehicles are "VINs" once individualized; a customer relationship spans "household garage" (multiple VINs); the dealer-OEM relationship is governed by state franchise laws in the US. "Aftersales" covers parts, service, warranty, and recalls — it is a major margin pool that EVs partially disrupt. "Connected vehicle" data flows from the telematics control unit (TCU) and is governed by privacy regulations and consent. Use "service appointment", "RO" (repair order), "loaner", "campaign" (for recalls/service campaigns), and "lead-to-test-drive-to-delivery" as the canonical funnel.

### Honest objections

The honest objections this industry raises against generic SaaS pitches: (1) "Our dealers won't adopt it" — dealer DMS systems (CDK, Reynolds & Reynolds, Tekion, Dealertrack) are deeply entrenched and dealer staff resist parallel systems; (2) "Connected vehicle data is huge and messy" — TCU telemetry volume, consent management, and OEM-region data residency make naive Data Cloud pitches collapse; (3) "We already have a customer database, but it's at the dealer, not at us" — OEMs frequently do not own the end-customer relationship and pretending otherwise loses credibility fast.

### Regulatory frame

The compliance and regulatory realities a persona should keep in mind: state franchise laws in the US constrain how OEMs can engage end customers directly; consumer privacy regimes (CCPA/CPRA in California, GDPR in Europe, emerging state laws) constrain telemetry and marketing use; NHTSA recall and TREAD Act reporting obligations require auditable service-campaign workflows. The dominant Salesforce footprint is Automotive Cloud + Service Cloud + Marketing Cloud, with Data Cloud increasingly central for VIN-360 and connected-vehicle use cases. Decisions usually need alignment across OEM corporate IT, digital/CX, and a dealer advisory council — selling only to corporate without dealer buy-in is a known failure pattern.

## Customer-type classifier (which sub-industry — OEM corporate, dealer group, captive finance, or commercial fleet?)

This pack covers four structurally different sub-industries within automotive. The skill should detect which one the customer belongs to and weight the panel accordingly — an OEM corporate panel ≠ a dealer-group panel ≠ a captive-finance panel ≠ a commercial-fleet panel even though all sit under "automotive". Detection signals (case-insensitive substring match on the customer name + the prompt body):

**OEM corporate** — `oem-digital-cx-vp` is must-include (the actual economic buyer for the platform decision); lead with `connected-vehicle-product-lead`, `brand-loyalty-lead`, `dealer-network-director`. For 5-cap panels at dealer-group or fleet-operator customers, swap out `oem-digital-cx-vp` first — their OEM-corporate lens doesn't apply there.
- Customer-name patterns: substrings like `Motors`, `Motor Company`, `Automotive`, `Auto Group` *(when paired with a named OEM)*; named OEMs: `Ford`, `GM`, `General Motors`, `Toyota`, `Stellantis`, `Chrysler`, `Honda`, `BMW`, `Hyundai`, `Kia`, `Nissan`, `Volkswagen`, `Audi`, `Mercedes-Benz`, `Tesla`, `Rivian`, `Lucid`; plus `OEM`, `manufacturer`, `vehicle program`, `model year`, `homologation`.
- Prompt patterns: `OEM`, `model year`, `vehicle program`, `homologation`, `connected vehicle`, `OTA`, `R155`, `R156`, `EV-mix`, `agency model`.

**Dealer group / mega-dealer** — lead with `aftersales-service-director`, `dealer-network-director` *(flipped to dealer-side framing)*.
- Customer-name patterns: `dealership`, `Dealer Group`, `Auto Group` *(without OEM-corporate signal)*, `Motors` *(small/regional)*; named groups: `AutoNation`, `Lithia`, `Group 1`, `Asbury`, `Sonic`, `Penske Automotive` *(retail side)*, `Berkshire Hathaway Automotive`.
- Prompt patterns: `dealership`, `dealer group`, `rooftop`, `store count`, `DMS` *(without OEM context)*, `CDK`, `Reynolds`, `Tekion`, `Dealertrack`, `fixed ops`, `service drive`.

**Captive finance** — pull from `financial-services` pack additively (Compliance, Credit Risk personas) plus `brand-loyalty-lead`.
- Customer-name patterns: `Financial Services` *(as suffix to OEM brand)*, `Captive`, `Motor Credit`, `Auto Finance`, `Acceptance Corporation`; named: `Ford Motor Credit`, `GM Financial`, `Toyota Financial Services`, `Honda Financial Services`, `BMW Financial Services`, `Mercedes-Benz Financial Services`, `Stellantis Financial Services`.
- Prompt patterns: `lease portfolio`, `floorplan financing`, `residual value`, `credit underwriting`, `loss reserves`.

**Commercial fleet operator** — `fleet-operations-manager` is must-include; `dealer-network-director` skipped.
- Customer-name patterns: `fleet`, `Logistics` *(operating own fleet)*, `Rental`, `Leasing`; named: `Ryder`, `Penske` *(truck leasing side)*, `Enterprise Fleet Management`, `Element Fleet`, `ARI`, `LeasePlan`; plus `for-hire`, `private fleet`, DOT/FMCSA mentions.
- Prompt patterns: `fleet`, `commercial vehicles`, `TCO`, `CPM`, `ELD`, `CSA`, `DOT number`, `FMCSA`, `IFTA`, `telematics`, `Geotab`, `Samsara`.

**Ambiguous signals** (a name matches multiple groups — e.g., `Ford Motor Company` vs `Ford Motor Credit`; or no name was given) the skill should ask one clarifying question rather than guess: *"Is the customer an OEM corporate entity, a dealer group / mega-dealer, a captive finance arm, or a commercial fleet operator?"* Then load only that sub-group's personas.

## Recommended industry-specific persona files

Each industry pack contributes 3-5 industry-specific personas at `personas/industries/automotive/<role-slug>.md` (these get created in a separate Phase). For this pack, the personas are:

- dealer-network-director.md — Manages OEM-to-dealer relationship, dealer scorecards, and rollout politics.
- fleet-operations-manager.md — Runs commercial fleet sales and ongoing service for B2B fleet customers.
- connected-vehicle-product-lead.md — Owns telematics data products, in-car services, and OTA-enabled features.
- aftersales-service-director.md — Owns parts, service, warranty, recall, and dealer service revenue.
- brand-loyalty-lead.md — Owns owner lifecycle marketing, repeat-purchase rate, and brand affinity programs.
- oem-digital-cx-vp.md — OEM-corporate executive sponsor and economic buyer for the digital + CX platform; owns the owner lifecycle and carries the platform decision to the CMO, CDO, or COO.

## Recommended product-pack pairings

When this industry is active, these product packs are most commonly relevant — the recommender should prefer them unless the user has explicitly set `--product`:
- sales-cloud — Core lead, test-drive, and order pipeline at OEM and dealer levels.
- service-cloud — Service appointments, recall campaigns, roadside, and case management.
- data-cloud — VIN-360, connected-vehicle telemetry unification, household garage view.
- marketing-cloud — Owner lifecycle journeys, service reminders, retention and trade-cycle marketing.

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources for this industry, suggest:
- https://www.salesforce.com/industries/automotive/
- https://www.nada.org/  (National Automobile Dealers Association — US dealer perspective)
- https://www.nhtsa.gov/  (US recall and safety regulator)
- https://www.iso.org/standard/79384.html  (ISO/SAE 21434 vehicle cybersecurity)
- https://www.acea.auto/  (European automobile manufacturers association)
- https://www.cdkglobal.com/  (DMS vendor named in pitfall #2)
- https://www.tekion.com/  (DMS vendor)
- https://www.autonews.com/  (industry trade press)

## Common sales-conversation pitfalls in this industry

1. Pitching direct-to-consumer journeys without acknowledging US state franchise laws — OEMs cannot simply bypass dealers in most states.
2. Underestimating the DMS integration burden — dealer DMS systems are often the source of truth for inventory, RO, and customer records, and they don't expose modern APIs cleanly.
3. Treating connected-vehicle data as "just another data source" — telemetry volumes, consent regimes, and regional data residency rules require explicit architectural planning.
4. Forgetting captive finance — many OEMs have a captive finance arm with its own systems, regulators, and buying center.
5. Assuming one global rollout — automotive is heavily regional (NAR, EU, China, APAC) and each region has different regulators, dealers, and digital maturity.

## Regulatory landscape (one paragraph)

Persona should keep in mind: state franchise laws in the US constrain OEM-to-consumer direct engagement and service; NHTSA recall and TREAD Act reporting require auditable service-campaign and defect-tracking workflows; consumer privacy regulations (CCPA/CPRA, GDPR, and an expanding patchwork of US state laws) constrain how connected-vehicle telemetry and marketing data can be collected, retained, and used. ISO/SAE 21434 and UN R155 increasingly shape vehicle cybersecurity expectations for new vehicle programs. None of this constitutes legal advice — the persona should flag regulatory questions for counsel rather than over-promise.
