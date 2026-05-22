# Communications — Industry Pack

The communications industry covers wireline and wireless carriers, cable/MSOs, satellite, MVNOs, wholesale/carrier interconnect, and increasingly B2B enterprise connectivity and managed services. Top pressures right now are revenue stagnation in consumer mobile and broadband (forcing carriers to monetize 5G, fiber, and B2B/edge services), the operational cost of legacy BSS/OSS stacks that block faster product launches, and intense churn pressure in saturated markets where switching cost is low. Salesforce typically engages here through Communications Cloud (sitting on Sales/Service Cloud with industry-specific CPQ, EPC, and order management — the former Vlocity assets), MuleSoft for BSS/OSS integration, Service Cloud for care, Data Cloud for subscriber and network event unification, and Agentforce for tier-1 care deflection. The buying center is usually a CIO/CTO plus a B2B sales or consumer-care SVP, with strong influence from network operations and a dedicated digital transformation office.

## Grounding prompt (injected into every persona)

### Vocabulary

Use the industry's actual vocabulary. Customers are "subscribers" (consumer) or "accounts" (B2B/wholesale); offers are built in an "EPC" (Enterprise Product Catalog) and quoted through "industry CPQ" with shared cart and decomposition logic; orders flow through "order management" (often Salesforce or a third party) into BSS and OSS. Network elements live in "OSS"; billing, rating, and customer records in "BSS". "Activation", "provisioning", "porting", "MACD" (move/add/change/disconnect), "MRC/NRC" (monthly recurring charge / non-recurring charge), and "ARPU" (average revenue per user) are core vocabulary. "Truck roll" is a real and expensive event.

### Honest objections

The honest objections this industry raises against generic SaaS pitches: (1) "Our product catalog has 50,000+ SKUs across legacy and new tech — your demo with three products doesn't scale"; (2) "BSS/OSS integration is the whole project, not an afterthought — we can't go live without provisioning, billing, and inventory talking" and MuleSoft alone does not solve it; (3) "We've already done a Vlocity/Communications Cloud project and it was hard" — many carriers have scar tissue from prior industry-cloud rollouts and expect honesty about implementation scope.

### Regulatory frame

The compliance and regulatory realities a persona should keep in mind: number portability (LNP/MNP), CPNI (Customer Proprietary Network Information in the US) and equivalent privacy regimes in other geos constrain how subscriber data can be used and shared; emergency services obligations (E911 in the US, 112 in EU) constrain provisioning and address validation; net-neutrality and universal-service rules vary by country and FCC/Ofcom/CRTC posture. The dominant Salesforce footprint is Communications Cloud + Service Cloud + MuleSoft, with Data Cloud increasingly central for churn modeling and care personalization. Decisions typically need alignment across the CIO/CTO, a transformation PMO, a network/operations leader, and either a consumer-care or B2B sales sponsor.

## Customer-type classifier (which sub-industry — wireless, cable, wholesale, regional, or satellite?)

This pack covers five structurally different sub-industries within communications. The skill should detect which one the customer belongs to and weight the panel accordingly — a tier-1 wireless panel ≠ a cable/MSO panel ≠ a wholesale carrier panel ≠ a regional ILEC/CLEC panel ≠ a satellite/NTN panel even though all sit under communications. Detection signals (case-insensitive substring match on the customer name + the prompt body):

**Wireless tier-1 (MNO)** — lead with `b2b-sales-director`, `cx-care-director`, `network-ops-lead`, `bss-oss-architect`.
- Customer-name patterns: `Verizon`, `AT&T Mobility`, `T-Mobile US`, `Vodafone`, `Telefónica`, `Orange`, `Deutsche Telekom`, `Telstra`, `NTT DOCOMO`, `China Mobile`; substrings: `Wireless`, `Mobility`, `Mobile` *(carrier context)*; plus `tier-1 wireless`, `MNO`.
- Prompt patterns: `5G`, `RAN`, `MEC`, `eSIM`, `CAMARA`, `private 5G`, `network slicing`, `O-RAN`, `spectrum`, `licensed band`.

**Cable / MSO** — lead with `service-provisioning-manager`, `cx-care-director`, `network-ops-lead`, `bss-oss-architect`.
- Customer-name patterns: `Comcast`, `Charter`, `Cox`, `Altice`, `Liberty Global`, `Rogers`, `Shaw`, `Videotron`; substrings: `Communications` *(cable context)*, `Cable`.
- Prompt patterns: `DOCSIS`, `MSO`, `headend`, `node split`, `cable plant`, `Xfinity`, `Spectrum`, `set-top box`.

**Wholesale carrier** — lead with `wholesale-carrier-relations`, `b2b-sales-director`.
- Customer-name patterns: `Zayo`, `Lumen Wholesale`, `Cogent`, `GTT`, `Hurricane Electric`, `Tata Communications`, `BICS`; substrings: `Wholesale`, `Carrier Services`.
- Prompt patterns: `interconnect`, `transit`, `peering`, `MVNO host`, `IRU`, `NANP`, `STIR/SHAKEN`, `wholesale rates`, `dark fiber`.

**Regional ILEC / CLEC / rural broadband** — lead with `service-provisioning-manager`, `b2b-sales-director`, `bss-oss-architect`.
- Customer-name patterns: `Frontier`, `Consolidated Communications`, `CenturyLink` *(legacy)*, `Windstream`, `TDS Telecom`, `Cincinnati Bell`, `Hawaiian Telcom`; substrings: `Telephone`, `Telecom` *(regional)*.
- Prompt patterns: `ILEC`, `CLEC`, `RDOF`, `BEAD`, `E-Rate`, `Universal Service Fund`, `USF`, `rural broadband`, `state PUC`.

**Satellite / NTN** — lead with `network-ops-lead`, `wholesale-carrier-relations`.
- Customer-name patterns: `Starlink`, `Iridium`, `Viasat`, `Hughes`, `SES`, `Intelsat`, `OneWeb`, `Inmarsat`; substrings: `Satellite`, `Space`.
- Prompt patterns: `LEO`, `MEO`, `GEO`, `NTN`, `satellite backhaul`, `direct-to-cell`, `gateway earth station`.

**When ambiguous** (a name matches multiple groups, or no name was given) the skill should ask one clarifying question rather than guess: *"Is the customer a wireless tier-1 (MNO), a cable / MSO, a wholesale carrier, a regional ILEC/CLEC or rural broadband provider, or a satellite / NTN operator?"* Then load only that sub-group's personas.

## Recommended industry-specific persona files

Each industry pack contributes 3-5 industry-specific personas at `personas/industries/communications/<role-slug>.md` (these get created in a separate Phase). For this pack, the personas are:

- network-ops-lead.md — Owns network inventory, capacity, and operational readiness for new services.
- service-provisioning-manager.md — Owns the order-to-activation chain across BSS/OSS.
- b2b-sales-director.md — Owns enterprise/SMB connectivity sales and complex multi-site quoting.
- cx-care-director.md — Owns consumer care, contact center, and tier-1 deflection economics.
- wholesale-carrier-relations.md — Owns carrier interconnect, wholesale deals, and settlement.
- bss-oss-architect.md — Owns the BSS/OSS architectural blueprint and the wrap-vs-replace sequencing decision (TM Forum eTOM/SID/TAM/ODA lens).

*This pack now ships 6 personas. For 5-cap panels where Communications Cloud / Vlocity, BSS modernization, catalog-driven order management, or wrap-vs-replace strategy is in scope, the BSS/OSS Architect is a must-include and the Wholesale Carrier Relations persona is the right swap-out — unless wholesale signals fire (interconnect, peering, MVNO host, settlement, STIR/SHAKEN, IRU, dark-fiber wholesale), in which case keep Wholesale and swap a different seat.*

## Recommended product-pack pairings

When this industry is active, these product packs are most commonly relevant — the recommender should prefer them unless the user has explicitly set `--product`:
- revenue-cloud — Industry CPQ, EPC, and order management are the heart of comms transformation.
- service-cloud — Care, case, and Agentforce-driven deflection for consumer and B2B support.
- mulesoft — BSS/OSS integration is non-negotiable; MuleSoft is the typical fabric.
- data-cloud — Churn signals, subscriber unification, and network-event-driven personalization.

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources for this industry, suggest:
- https://www.salesforce.com/industries/communications/
- https://www.tmforum.org/  (TM Forum — Open APIs, eTOM, SID; the de facto reference architecture)
- https://www.fcc.gov/  (US regulator; CPNI, E911, spectrum)
- https://www.itu.int/  (ITU — global standards, numbering)
- https://www.ofcom.org.uk/  (UK regulator — useful EU/UK perspective)

## Common sales-conversation pitfalls in this industry

1. Demoing a generic CPQ flow without showing shared cart, decomposition, and EPC — comms buyers immediately see this is not their world.
2. Promising "rip and replace BSS/OSS" — carriers replace these systems over years, not quarters; the realistic story is wrap-and-extend.
3. Ignoring MACD complexity — a single B2B enterprise customer change can touch dozens of services, sites, and downstream systems.
4. Underestimating provisioning latency — real activation involves network elements, dispatch, and sometimes physical truck rolls; this constrains UX claims.
5. Pitching Agentforce care deflection without acknowledging that comms care queues are dominated by billing disputes and outage events, which need authoritative system-of-record access.

## Regulatory landscape (one paragraph)

Persona should keep in mind: in the US, CPNI rules constrain how a carrier can use and share subscriber call/usage data, and E911 obligations constrain provisioning and address accuracy; number portability rules (LNP for wireline, WLNP for wireless) shape onboarding/offboarding flows; FCC rules and state PUCs govern many consumer protections; in the EU, GDPR plus ePrivacy plus national telecoms regulators (Ofcom, BNetzA, ARCEP, etc.) layer on similar constraints; many countries impose lawful-intercept and data-retention obligations. None of this constitutes legal advice — the persona should flag regulatory questions for counsel rather than over-promise.
