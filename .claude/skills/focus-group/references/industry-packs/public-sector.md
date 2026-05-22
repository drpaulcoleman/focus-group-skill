# Public Sector — Industry Pack

Public sector covers US federal civilian and defense agencies, state and local government (cities, counties, states), K-12 and higher education (often treated as a sibling vertical), and the international equivalents (UK government, EU institutions, Canadian federal and provincial, Australian Commonwealth and state). The top pressures right now are constituent-experience modernization (the post-COVID expectation that government services feel like consumer apps), the AI policy and governance scramble (OMB M-24-10 on federal AI use, state-level AI governance frameworks, and the EU AI Act for European agencies), and persistent legacy-modernization backlog where systems running on mainframe or pre-cloud architecture must be replaced without service interruption. Salesforce engages through Public Sector Solutions (the dedicated Industries Cloud SKU built on the platform, covering licensing, permitting, inspections, case management, grants, and constituent service), paired with Government Cloud or Government Cloud Plus for FedRAMP-bound workloads, Service Cloud for constituent contact centers, and increasingly Data Cloud and Agentforce within FedRAMP boundaries. The typical buyer shape is an agency CIO or Chief Digital Officer as economic buyer, a program director (e.g., Director of Licensing, Director of Constituent Services) as champion, and a contracting officer plus an authorizing official (AO) who own the security and procurement gates.

## Grounding prompt (injected into every persona)

Public sector customers speak in terms of constituents, citizens, residents, customers (depending on jurisdiction preference), case management, intake, eligibility, adjudication, benefits, licenses, permits, inspections, fee schedules, FOIA / records requests, grants management (both as grantor and grantee), interoperability, Section 508 accessibility, FedRAMP authorization (Moderate, High, and the rare LI-SaaS), StateRAMP, IL2/IL4/IL5/IL6 (DoD impact levels), CJIS for criminal-justice data, HIPAA for health agencies, FERPA for education agencies, IRS Publication 1075 for tax data, and ATO (Authority to Operate). They distinguish sharply between programs (the policy mission) and operations (the contact center, the inspector, the case worker). Public Sector Solutions provides pre-built data models and processes for licensing, permitting, inspections, grants, employee experience, and constituent case management. Government Cloud (FedRAMP Moderate) and Government Cloud Plus (FedRAMP High and DoD IL2/IL4/IL5) are isolated environments with a subset of features available — feature parity with commercial cloud is not guaranteed and the gap matters during scoping.

### Honest objections — federal civilian / DoD

The honest objections this sub-vertical raises against generic SaaS pitches are: (1) "What is your FedRAMP / StateRAMP / IL status today, and which features I just saw in your demo are not yet authorized in that environment?"; (2) "We are bound by procurement rules — show me the contract vehicle (GSA, SEWP, NASPO ValuePoint, state master contract) and the data-rights and termination-for-convenience language"; (3) "Our legacy system is the system of record for a statutory program — what is the migration path that doesn't break the audit trail or the federal reporting?"

### Honest objections — state / local government

The honest objections this sub-vertical raises are: (1) "Our cooperative-purchasing vehicles (Sourcewell, NASPO ValuePoint, OMNIA, state-specific masters) are not optional — show me you're on at least one, or we can't write the PO without competitive procurement that adds 6-18 months."; (2) "StateRAMP-or-equivalent and state-specific data-residency (CJIS, IRS Pub 1075, state tax codes) gate the deal — and 'we've started the process' is not the same as 'we're authorized.'"; (3) "Legislative-session cadence drives our fiscal-year procurement window — the governor's State of the State or the city/county budget mark-up is the real deal-clock, not your quarter."

### Honest objections — international (UN / EU / MDB / non-US national)

The honest objections this sub-vertical raises are: (1) "We don't procure on US-vehicle terms. UN agencies use UNGM with country-of-origin and beneficial-ownership rules; the EU uses TED and PIN-CN-CFT cascade; MDBs use their own Articles-of-Agreement-derived procurement frameworks with sanctions-screening + Beneficial Ownership Rule — a Salesforce response has to live in those frameworks."; (2) "Sovereign-cloud / trusted-cloud classification is binding — GAIA-X for Germany/France, SecNumCloud for France, IT-Grundschutz / C5 for Germany, ISMAP for Japan, IRAP for Australia. 'FedRAMP-High equivalent' is not a thing here; the framework name has to be the right one."; (3) "GDPR, the EU AI Act phase-in, NIS2, DORA (for financial-supervised public bodies), and Cyber Resilience Act each impose their own answers that don't map to US frameworks. Your DPIA, your transfer impact assessment, and your Article-9 risk register need to actually exist, not be roadmap items."

### Regulatory frame

Compliance and regulatory realities to keep in mind: FedRAMP (the federal cloud authorization regime managed by GSA, OMB, and the FedRAMP PMO, with Rev 5 controls now in effect), FISMA, NIST SP 800-53, NIST AI RMF, OMB M-24-10 (federal AI use and risk management), Section 508 accessibility (WCAG 2.1 AA equivalent), the Privacy Act of 1974, state public-records laws, CJIS Security Policy, IRS Publication 1075, the EU AI Act for European public bodies, and the UK government's Service Standard for digital services. The dominant Salesforce footprint is Public Sector Solutions + Service Cloud + Experience Cloud (constituent portals) + MuleSoft (legacy integration), running in Government Cloud or Government Cloud Plus depending on data sensitivity. Decision-making is slow and committee-driven: the CIO sponsors, the program owner champions, the AO grants the ATO, the contracting officer owns the procurement vehicle, and a Congressional or legislative liaison watches the political optics.

**Non-US flex.** When the customer is a UN agency, an EU institution, a multilateral development bank, or a non-US national government (UK, Canada, Australia, Singapore, Germany, France, Brazil, Japan, etc.), the binding framework changes substantially: FedRAMP becomes irrelevant; sovereign-cloud / trusted-cloud classifications take its place; GDPR, the **EU AI Act**, the OECD AI Principles, UNESCO's AI Ethics Recommendation, and national AI strategies apply instead of (or alongside) NIST AI RMF and OMB M-24-10; procurement runs through the EU's eTendering portal, UNGM (UN Global Marketplace), each MDB's tendering platform, or each country's national procurement portal — not GSA or SEWP. Multi-language is non-optional (EU has 24 official languages; UN has six). Currency reporting frequently isn't USD. The international-public-sector-officer persona in this pack covers these contexts with four sub-profiles; the existing federal / state-CIO / AO / KO / mission-owner personas should switch to their international-aware mode when the customer profile signals non-US (the persona file's `## Sub-profiles` and `## Lens` sections name the relevant overlay).

## Customer-type classifier (which sub-context — state/local, federal/DoD, or international?)

Public sector spans three structurally different governance contexts. Pick the sub-group based on signals in the customer name and the prompt body. Case-insensitive substring match; first hit wins; ties resolved by asking one clarifying question.

**State / local government (default when state-name signals are present)** — load `state-cio`, `city-county-manager`, plus the operational personas (`constituent-services-director`, `licensing-permits-manager`, `case-worker`, `emergency-response-coordinator`, `it-modernization-director`) as appropriate to the topic.
- Customer-name patterns: `state of`, `commonwealth of`, `state government`, `county of`, `city of`, `town of`, `township of`, any US state abbreviation followed by "DHS"/"DMV"/"DOT" etc., `department of` *(when preceded by a state or city name)*, `municipality of`, `borough of`, `school district`, `unified school district`, `regional transit`, `water district`.
- Prompt patterns: `state legislature`, `state CIO`, `NASCIO`, `state procurement`, `StateRAMP`, `state master contract`, `Sourcewell`, `NASPO ValuePoint`, `OMNIA`, `cooperative purchasing`, `Texas DIR`, `California CMAS`, `TX-RAMP`, `county commission`, `city council`, `mayor`.

**Federal civilian / DoD (when federal signals dominate)** — load `federal-cio`, `federal-authorizing-official`, `federal-contracting-officer`, `dod-mission-owner` *(DoD context)* or `federal-cio` *(civilian context)*, plus `inspector-general-auditor` when oversight matters.
- Customer-name patterns: `federal`, `department of` *(without a state preceding — DOJ, DOD, USDA, HHS, VA, etc.)*, `agency` *(when preceded by Federal/US)*, `US Air Force`, `US Army`, `US Navy`, `US Marines`, `US Space Force`, `USAF`, `USA`, `USMC`, `USN`, `USCG`, `Defense Logistics Agency`, `DLA`, `DHA`, `DTRA`, `DCSA`, `NRO`, `NGA`, `CIA`, `FBI`, `IRS`, `SSA`, `NASA`, `EPA`, `GSA`, `SBA`, `Treasury`, `State Department`, `White House`, `Office of Management and Budget`, `OMB`, named Combatant Commands (`USINDOPACOM`, `USEUCOM`, `USAFRICOM`, `USCENTCOM`, etc.).
- Prompt patterns: `FedRAMP`, `IL2`, `IL4`, `IL5`, `IL6`, `ATO`, `Authority to Operate`, `Authorizing Official`, `Contracting Officer`, `KO`, `GSA Schedule`, `MAS`, `SEWP`, `CIO-SP3`, `EAGLE`, `NETCENTS`, `ITES-SW`, `BPA` *(in federal context)*, `IDIQ`, `J&A`, `FAR Part 12`, `DFARS`, `252.204-7012`, `CMMC`, `FISMA`, `OMB M-24-10`, `M-22-09`, `FITARA`, `Government Cloud Plus`, `DISA STIG`, `eMASS`, `Xacta`, `RMF`, `JCIDS`, `software pathway`, `Joint Staff`.

**International — UN / EU / MDB / non-US national** — load `international-public-sector-officer` and pick the matching sub-profile (UN agency / EU institutional / MDB / non-US national CIO).
- Customer-name patterns: `UN`, `UNHCR`, `UNDP`, `UNICEF`, `WFP`, `UN Women`, `UN-Habitat`, `IOM`, `ILO`, `FAO`, `WHO`, `UNESCO`, `European Commission`, `DG-` *(EU DG name)*, `European Parliament`, `Council of the EU`, `European External Action Service`, `EEAS`, `ENISA`, `EUIPO`, `EMA`, `EFSA`, `World Bank`, `IBRD`, `IDA`, `IFC`, `MIGA`, `IMF`, `International Monetary Fund`, `Asian Development Bank`, `ADB`, `Inter-American Development Bank`, `IDB`, `African Development Bank`, `AfDB`, `European Bank for Reconstruction and Development`, `EBRD`, `Islamic Development Bank`, `UK Government`, `HM Government`, `Government Digital Service`, `GDS` *(UK context)*, `Central Digital and Data Office`, `CDDO`, `Government of Canada`, `Shared Services Canada`, `SSC` *(Canada context)*, `Canadian Digital Service`, `CDS`, `Australian Government`, `Digital Transformation Agency`, `DTA` *(Australia)*, `Singapore Government`, `GovTech`, `Estonia State Information System`, `RIA`, `German Federal`, `FITKO`, `French Government`, `DINUM`, `Brazil Government`, `Japan Digital Agency`.
- Prompt patterns: `GDPR`, `EU AI Act`, `NIS2`, `Cyber Resilience Act`, `eTendering`, `UNGM`, `multilateral`, `sovereign cloud`, `trusted cloud`, `GAIA-X`, `OECD AI Principles`, `UNESCO AI Ethics`, `UK GDPR`, `PIPEDA`, `LGPD`, `APP`, `EU Cloud Sovereignty Framework`, `Article 9 risk management system`, `EU Web Accessibility Directive`, `Section 508 equivalent`, `host-country agreement`, `Article 100`, `Privileges and Immunities`, `OFAC` *(in MDB context)*, multi-currency reporting cues (`EUR`, `GBP`, `CAD` *(non-incidental)*).

**Ambiguous signals** (e.g., `Department of Defense, NSW` — both DoD and Australian context; or `Smith County Health Department` where state/local is implicit) — ask one clarifying question: *"Is this customer at the state/local level (US), the federal/DoD level (US), or non-US (UN agency, EU institution, MDB, or non-US national government)?"* Pick the closest fit; load only that sub-group's personas.

## Recommended industry-specific persona files

Each industry pack contributes industry-specific personas at `personas/industries/<slug>/<role-slug>.md`. Public sector spans state/local, federal civilian, DoD, and intelligence-community contexts with sharply different cultures, compliance frameworks, and decision tempos. This pack ships **two groups** — state/local and federal/DoD — and the skill picks from the right group based on the customer profile (named org, prompt cues like "FedRAMP", "IL5", "DoD", "ATO", "Combatant Command", "GSA Schedule", "SEWP", "CMMC").

**State / local government (default for state-level customers):**

- constituent-services-director.md — Runs the citizen-facing contact center or service center; cares about wait times, deflection, and equity of access.
- licensing-permits-manager.md — Owns a regulatory licensing or permitting program; lives in statutory timelines and fee reconciliation.
- emergency-response-coordinator.md — Stands up incident command for disasters, public-health events, or major outages; cares about surge capacity and interoperability.
- case-worker.md — Front-line eligibility or social-services worker; the actual end user whose adoption determines success.
- it-modernization-director.md — Owns the agency's modernization roadmap and the ATO process; the technical gatekeeper.

**State / local executive leadership (loaded when state-CIO, county/city-management, or legislative-engagement signals are present):**

- state-cio.md — State, large-county, or large-city CIO / Chief Digital Officer; enterprise IT portfolio lens; StateRAMP and state-specific data law; NASCIO peer dynamics; legislative-session-aware buying cadence.
- city-county-manager.md — City Manager / County Administrator / County Executive; reads every purchase through the lens of council/board defensibility, staff capacity, cooperative-purchasing vehicles (Sourcewell, OMNIA, NASPO ValuePoint), and constituent equity / accessibility.

**Federal civilian / DoD (loaded when FedRAMP / IL / DoD / federal-procurement signals are present):**

- federal-cio.md — Cabinet-department or independent-agency CIO / Chief Digital Officer; OMB-aligned portfolio lens; FITARA-graded; reads against M-24-10 (AI), M-22-09 (zero-trust), and the agency's IT investment plan.
- federal-authorizing-official.md — The Authorizing Official who personally accepts residual risk and signs the ATO. Reads every pitch for FedRAMP / IL boundary, inheritance map, continuous-monitoring posture. For DoD AOs, IL4/5/6 and DoD-specific overlays apply.
- federal-contracting-officer.md — The warranted KO with sole legal authority to bind the government. Reads for contract vehicle (GSA Schedule, SEWP, NASPO, agency IDIQs, BPAs), price reasonableness, data rights, T4C clauses, FAR/DFARS compliance (252.204 series, CMMC).
- dod-mission-owner.md — Military or civilian-DoD program manager; reads for mission tempo, OPSEC, degraded-network behavior, DISA STIGs, IL5/IL6 feature parity; treats vendor claims through the warfighter-survives-contact lens.
- inspector-general-auditor.md — IG / GAO / state auditor lens; not in the deal, but the future reader of every artifact the deal produces; finds promise-vs-delivery gaps, procurement-process irregularities, unmeasured outcomes, security/compliance lapses. Include when the customer's procurement is high-visibility, when the agency has had recent audit findings, or when the user's role is itself an oversight-adjacent function.

**International — UN agencies, EU institutions, MDBs, non-US national governments (loaded when UN/UNHCR/UNDP/WFP, EU/Commission/DG, World Bank/ADB/IDB/AfDB, UK GDS, Canada SSC, Australia DTA, or similar signals are present):**

- international-public-sector-officer.md — One consolidated persona with four sub-profiles covering (1) UN agency program owner (UN Financial Regulations, UNGM, UN Charter / privileges & immunities), (2) EU institutional officer (Treaty competences, EU public procurement directives, GDPR, NIS2, **EU AI Act**, Cyber Resilience Act, 24-language regime), (3) Multilateral development bank program owner (World Bank / IMF / ADB / IDB / AfDB / EBRD; Articles of Agreement; bank-specific procurement frameworks with sanctions screening and beneficial-ownership disclosure), and (4) non-US national-government CIO / digital-service lead (UK GDS, Canada SSC, Australia DTA, Singapore GovTech, Estonia RIA, French DINUM, etc.; national procurement law; sovereign-cloud classifications; national AI strategy).

## Recommended product-pack pairings

When this industry is active, these product packs are most commonly relevant. The pairings differ materially by sub-vertical — Salesforce's footprint at a federal civilian / DoD agency is not the same shape as at a state / local government or at a UN agency / EU institution, and demoing the wrong stack is a quick way to lose credibility. Route by the classifier above.

### For federal civilian / DoD

- service-cloud — Constituent contact-center and case management; the workhorse for any public-facing agency.
- experience-cloud — Constituent self-service portals; mandatory for any modernization program that promises digital-first service.
- mulesoft — Legacy mainframe and statutory-system integration; almost always in scope for state and federal modernization.
- data-cloud — Unified constituent view across programs; relevant for larger agencies, but FedRAMP feature availability needs verification at scoping.

### For state / local government

- service-cloud — constituent contact-center is the workhorse; deflection + benefits/UI/MV/permit case management.
- experience-cloud — constituent self-service portal; the digital-front-door investment thesis.
- mulesoft — integration with legacy statutory systems (mainframe Banner, in-house tax systems, vendor CIS).
- data-cloud — constituent 360 across programs; cross-program eligibility checks. **Verify StateRAMP / state-DPA pre-acquisition.**
- public-sector-solutions — licensing/permitting/inspections/grants reference architectures.

### For international (UN / EU / MDB / non-US national)

- service-cloud + experience-cloud (multi-language as first-class) — constituent / beneficiary / member-state service portal.
- mulesoft — integration with legacy national systems + multi-currency reporting.
- data-cloud — **only after** sovereign-cloud-classification + GDPR/local data-protection compliance is signed off.
- Salesforce Hyperforce regional (EU sovereign-cloud variants where available) — confirm GDPR + local data-residency constraints before scoping.

## URL seed-list (for /download grounding)

- https://www.salesforce.com/government/
- https://www.fedramp.gov/ (FedRAMP PMO; authorization status and Rev 5 controls)
- https://www.whitehouse.gov/omb/ (OMB; circulars, memoranda including M-24-10 on AI use)
- https://www.nist.gov/itl/ai-risk-management-framework (NIST AI RMF)
- https://www.section508.gov/ (federal accessibility guidance)
- https://stateramp.org/ (StateRAMP; state and local cloud authorization)

## Common sales-conversation pitfalls in this industry

1. Demoing a feature in commercial cloud that is not yet available in Government Cloud or Government Cloud Plus — the CIO will catch it, and the rep loses credibility on the spot.
2. Skipping the contract-vehicle conversation and proposing a direct purchase — most agencies cannot procure outside a vehicle (GSA, SEWP, NASPO ValuePoint, state master contracts) and the deal stalls in procurement.
3. Pitching AI or Agentforce without addressing OMB M-24-10, NIST AI RMF, and the agency's own AI governance posture — the AO will require an AI impact assessment that the rep didn't budget time for.
4. Treating ATO as a paperwork exercise — the authorizing official's risk acceptance is a real decision that can take 6–18 months and shapes the deployment timeline.
5. Ignoring Section 508 in the demo and the portal mockups — accessibility is not negotiable in federal procurement and a non-conformant demo signals a non-conformant product.

## Regulatory landscape (one paragraph)

US federal agencies operate under FISMA, with cloud services authorized through FedRAMP (Rev 5 baseline now in effect) at Low, Moderate, or High impact, and DoD workloads layered on top via the DoD Cloud Computing SRG impact levels (IL2, IL4, IL5, IL6). State and local governments increasingly rely on StateRAMP for cloud authorization, with major states maintaining their own programs (e.g., California, Texas, Florida). Cross-cutting obligations include the Privacy Act of 1974, the Paperwork Reduction Act, Section 508 accessibility, the E-Government Act, and the Federal Records Act. Program-specific regimes apply: CJIS for criminal-justice data, IRS Publication 1075 for federal tax information, HIPAA for health agencies, FERPA for education agencies, and 42 CFR Part 2 for substance-use treatment records. AI use is now governed by OMB M-24-10 (federal civilian) and the corresponding DoD policy, with NIST AI RMF as the de facto framework. European public bodies face the EU AI Act, eIDAS 2.0, and the NIS2 directive. Personas should treat ATO timelines, contract vehicles, and accessibility as hard constraints, not as items to address post-sale.
