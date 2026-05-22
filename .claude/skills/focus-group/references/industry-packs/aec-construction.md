# AEC & Construction — Industry Pack

AEC and construction covers architecture and engineering (AE) firms, general contractors (GCs), construction managers (CM-at-risk and CM-agency), specialty trade contractors (MEP, civil, structural, glazing, fire-protection), design-build firms, and capital-project owners — both private (industrial, energy, technology campus, healthcare-system owner-developer) and public (state DOTs, port and transit authorities, federal construction agencies, public-works departments). Top pressures right now are persistent skilled-trade and field-supervisor shortages, sustained input-cost and interest-rate volatility (capital-project feasibility math is fragile), supply-chain bumpiness on long-lead equipment (switchgear, chillers, elevators, transformers), and a slow-but-real digital shift through BIM, common data environments (CDEs), 4D / 5D project controls, reality-capture, and increasingly digital-twin handover expectations from sophisticated owners. Salesforce does not have a dedicated Industries Cloud SKU for AEC; engagement is Sales Cloud for pursuit-and-bid, Service Cloud for warranty and post-construction owner-relationship management, Experience Cloud for owner / subcontractor / JV portals, Data Cloud where project-controls signal needs to unify with CRM, and MuleSoft as the integration backbone to Procore / Autodesk Construction Cloud / Primavera P6. The typical buyer shape is a Chief Operating Officer or Chief Project Officer as economic buyer, a VP of Operations or Project Executive as champion, and a Director of VDC / BIM or Director of IT as the load-bearing operational stakeholder.

## Grounding prompt (injected into every persona)

### Vocabulary

AEC and construction customers speak in the capital-project lifecycle — "plan → design → bid → build → commission → operate / handover" — with role labels "owner", "owner's rep", "AE" (architect / engineer), "GC" (general contractor), "CM" (construction manager, agency or at-risk), "trade contractor" / "sub" / "subcontractor", "JV partner" (joint-venture partner on the project), and "AHJ" (authority having jurisdiction; the local code official). Documents flow as "RFI" (request for information), "submittal", "shop drawing", "change order" / "CO" / "PCO" (potential change order), "ASI" (architect's supplemental instruction), "pay app" (payment application, AIA G702 / G703), "lien waiver" (conditional / unconditional, progress / final), "COI" (certificate of insurance), and "punch list" at close-out. Project controls runs on Primavera P6 or MS Project for schedule and an EVMS (earned-value management system) for cost. BIM (Building Information Modeling) lives in Revit / Tekla / Bentley OpenBuildings; coordination in Navisworks / BIM 360; the CDE (common data environment) is increasingly Autodesk Construction Cloud or Procore. Delivery methods include "design-bid-build" (DBB), "design-build" (DB), "progressive design-build" (PDB), "CM-at-risk" (CMAR), "IPD" (integrated project delivery), and "P3" (public-private partnership) on the owner side. Safety lives in "OSHA 30" for supervisors, "OSHA 10" for craft, "lockout / tagout" (LOTO), "confined space", "fall protection", "EM 385" on USACE federal jobs, and "EMR" (experience modification rate) on insurance. Procurement on public work uses "Davis-Bacon" prevailing wage (federal) and "little Davis-Bacon" state analogs, "DBE / MWBE" disadvantaged / minority / women business enterprise participation, and "Buy America(n)" requirements.

### Honest objections

The honest objections this sub-vertical raises against generic SaaS pitches are: (1) "Every project is a one-off joint venture with its own owner, AE, subs, lender, and AHJ — your CRM has to model project teams, JV partners, and per-project security without me writing custom Apex on every job"; (2) "Our system of record is Procore (or Autodesk Construction Cloud), and our project-controls system of record is P6 — what does Salesforce do that doesn't duplicate or fight Procore's existing module, and how do you keep BOL / RFI / submittal / pay-app workflows from getting forked?"; (3) "Our front line is in gloves, hard hats, safety glasses, and high-vis, in basements with no signal and rooftops with no shade — your mobile experience has to work offline and survive a dropped phone, not just look good in the demo"; (4) "The pay-app and lien-waiver chain is how we get paid and how we don't get sued — don't ask us to re-route that through a half-built workflow to make CRM-side reporting easier"; (5) on the owner side: "Lender draw requests, AHJ approvals, and FAR / Davis-Bacon paperwork are the binding constraints on the schedule — adoption that doesn't respect them is dead on arrival".

### Regulatory frame

Compliance and regulatory realities to keep in mind: OSHA (US occupational safety, recordkeeping, 300 / 300A / 301 logs, fatality and severe-injury reporting, OSHA 10 / 30 training); state-plan OSHA jurisdictions (Cal/OSHA and others) with stricter standards; USACE EM 385-1-1 on federal construction; IBC / IRC / IFC / IPC / IMC / NEC model codes as locally adopted; AHJ inspection and permit regimes that vary by municipality; NEPA for federal environmental review; Phase I / II ESA (environmental site assessment) for site acquisition; SWPPP (stormwater pollution prevention plan) under EPA NPDES for construction sites; Davis-Bacon Act prevailing-wage on federal-funded work and "little Davis-Bacon" state analogs; DBE / MWBE / SBE participation goals on public projects; Buy America(n) provisions on federal-funded infrastructure (IIJA / IRA); ADA accessibility in design and construction; FAR (Federal Acquisition Regulation) and agency supplements (DFARS, FHWA, FTA) on federal construction contracts; CMMC and FedRAMP where federal data is in scope; state contractor-licensing and bonding requirements; lien-law regimes (vary widely by state); insurance and surety (P&P bonds, builder's risk, CCIP / OCIP wrap-up programs). Decision-making is operations-and-legal-heavy: Operations / project executives own delivery, VDC / BIM owns the digital workflow, IT owns Procore / ACC / P6 integration, Legal / Contracts owns subcontract structure and lien-waiver workflow, and Safety owns OSHA posture.

## Customer-type classifier (which sub-industry — GC, engineer, capital-projects owner, design-build, or specialty contractor?)

This pack covers five sub-types that share the project lifecycle but have different P&Ls, bid mechanics, and buyer shapes. Detect from case-insensitive substring match on the customer name + the prompt body:

**General contractor / construction manager** — lead with `capital-projects-director`, `field-service-coordinator`. Must-include `preconstruction-estimating-director` whenever pursuit / bid-management is in scope; must-include `vdc-bim-lead` whenever any BIM / model-coordination conversation comes up.
- Customer-name patterns: Turner Construction, Hensel Phelps, Skanska USA, Suffolk, Whiting-Turner, Mortenson, Clark Construction, DPR Construction, Hoffman, Walsh Group, Brasfield & Gorrie, McCarthy Building, Gilbane, Webcor, JE Dunn, Swinerton, Holder, Balfour Beatty US, Kiewit; substrings: "Construction", "Constructors", "Builders", "Building Company", "Building Group".
- Prompt patterns: `RFI`, `submittal`, `pay app`, `lien waiver`, `change order`, `PCO`, `ASI`, `OAC meeting`, `precon`, `pursuit`, `bid`, `Procore`, `Autodesk Construction Cloud`, `ACC`, `Bluebeam`, `subcontract`, `JV partner`, `bonding capacity`, `surety`, `EMR`, `CCIP`, `OCIP`.

**Architecture / engineering / design firm (AE)** — lead with `capital-projects-director` *(design-side sub-profile)*. Must-include `vdc-bim-lead` whenever any BIM / model-coordination conversation comes up.
- Customer-name patterns: AECOM, Jacobs, Stantec, WSP, Arcadis, HDR, Burns & McDonnell, Black & Veatch, Gensler, HOK, Perkins&Will, SOM (Skidmore, Owings & Merrill), CRB, Walter P Moore, Thornton Tomasetti; substrings: "Engineers" *(firm)*, "Engineering Group", "Architects" *(firm)*, "Architecture", "Consulting Engineers".
- Prompt patterns: `BIM`, `Revit`, `Tekla`, `Navisworks`, `VDC`, `clash detection`, `design intent`, `specification`, `CSI MasterFormat`, `LOD` *(level of development)*, `IFC` *(industry foundation classes)*, `AIA`, `ACEC`, `commissioning agent`, `CxA`, `RFP response`.

**Capital-projects owner (public + private)** — lead with `capital-projects-director` *(owner-side sub-profile)*.
- Customer-name patterns: "Authority", "Port Authority", "Transit Authority", "DOT" *(state DOTs)*, "Public Works", "Infrastructure", "Capital Projects"; named: Port Authority of NY / NJ, MTA Construction & Development, LA Metro, BART, MARTA, WMATA, Sound Transit, USACE, GSA, VA construction, large industrial owners (Intel, TSMC US fabs, Micron, hyperscaler campus builds), healthcare-system owner-developers.
- Prompt patterns: `capital plan`, `owner's rep`, `CM at risk`, `IDIQ` *(construction context)*, `design-bid-build`, `progressive design-build`, `P3`, `program management`, `PMIS` *(program management information system)*, `Aconex`, `Asite`, `lender draw`, `requisition`, `commissioning`, `handover`, `digital twin handover`.

**Design-build / IPD firm (integrated delivery)** — lead with `capital-projects-director`. Must-include `preconstruction-estimating-director` whenever pursuit / bid-management is in scope; must-include `vdc-bim-lead` whenever any BIM / model-coordination conversation comes up (design-build collapses design and construction, so the BIM seat is doubly load-bearing here).
- Customer-name patterns: design-build firms (DPR + design-build group, Hensel Phelps design-build, Mortenson design-build, Kiewit design-build), DBIA member firms; substrings: "Design-Build", "DB".
- Prompt patterns: `design-build`, `progressive design-build`, `IPD`, `integrated project delivery`, `single point of accountability`, `target value design`, `TVD`, `big room`, `last planner`, `lean construction`.

**Specialty trade contractor (MEP, civil, structural, glazing, fire-protection)** — lead with `field-service-coordinator`, `capital-projects-director` *(trade-sub sub-profile)*.
- Customer-name patterns: large MEP / electrical / mechanical: Rosendin Electric, MMC Contractors, Limbach, EMCOR, Comfort Systems USA, Cupertino Electric, ACCO Engineered Systems, Murphy Company, Southland Industries; structural / steel: Schuff Steel, SteelFab; glazing: Permasteelisa, Enclos; substrings: "Electric", "Mechanical", "Plumbing", "Glazing", "Steel" *(specialty trade context)*, "MEP".
- Prompt patterns: `trade contractor`, `subcontractor`, `MEP`, `coordination drawings`, `shop drawing`, `prefab`, `modular`, `BIM coordination`, `clash`, `fabrication`, `installation crew`, `commissioning` *(MEP)*, `start-up`.

**Residential brokerage** — *out of scope for this pack.* The Phase 2b ECR split deferred residential brokerage to a planned `residential-real-estate-brokerage.md` pack (Phase 3+). If a customer needs that lens (MLS, agent productivity, dotloop / kvCORE / BoldTrail, commission split, transaction sides), file a Phase 3+ pack request and use generic stakeholder personas in the interim.

**Ambiguous signals** — when a name spans sub-types (e.g., "Jacobs" reads as engineer but the prompt is owner-side program management; a design-build firm reads as GC but the prompt is design-led), ask one clarifying question: *"Is the customer a general contractor / CM, an AE firm, a capital-projects owner (public or private), a design-build firm, or a specialty trade contractor?"* Load only that sub-group's lead personas. If the conversation is CRE-portfolio-operations-shaped (NOI, leasing, FM, tenant experience), the customer probably belongs in `commercial-real-estate.md` rather than this pack.

## Recommended industry-specific persona files

For this pack, the personas are:

- capital-projects-director.md — Owns delivery of major capital projects from preconstruction through commissioning; managing cost, schedule, and risk against owner, lender, and AHJ expectations. Reads pursuits and delivery changes against the schedule, the change-order chain, and the lien-waiver / pay-app workflow that protects the project. *(Stretches across packs: also occasionally loaded from `commercial-real-estate` when a CRE owner-operator is running a major capital project on a portfolio asset.)*
- field-service-coordinator.md — Coordinates trade technicians and subcontractors on the build side — commissioning, punch-list, MEP start-up, warranty service calls on newly-occupied buildings. Reads building-trade certs (EPA 608 refrigerant, lockout / tagout, confined space) as gating constraints on who can be dispatched.
- vdc-bim-lead.md — Owns the model-coordination veto on any project — BIM authoring (Revit, ArchiCAD, Tekla), federation and clash detection (Navisworks, Solibri, ACC Model Coordination), CDE strategy (ACC, Procore, ProjectWise, Quadri), the BEP, LOD tables, 4D / 5D / 6D, IFC / ISO 19650 interoperability, COBie handover, and the design-handover-to-construction transition. Carries the model-integrity seat no other persona in this pack holds.
- preconstruction-estimating-director.md — The actual GC pursuit-buyer for any Sales Cloud pursuit / bid-management deal. Owns pursuit pipeline, bid / no-bid governance, conceptual-through-GMP estimating (Sage Estimating, OST, Bluebeam, Building Connected, ProEst), bid-leveling, design-assist, value engineering, bond mechanics, and the pursuit-pipeline-to-backlog conversion math the CFO cares about.

*Pack now ships 4 personas; this is still under the default 5-cap, so all 4 may load together when the prompt warrants it.*

## Recommended product-pack pairings

When this industry is active, these product packs are most commonly relevant — the recommender should prefer them unless the user has explicitly set `--product`:
- sales-cloud — Pursuit, bid, proposal, and account management for GCs, AE firms, and design-build pursuits.
- field-service — Punch-list, commissioning, MEP start-up, and warranty service-call dispatch on newly-completed work.
- experience-cloud — Owner project portals, subcontractor portals, and JV-partner project workspaces.
- data-cloud — Unifying CRM with Procore / ACC / P6 project-controls signal for portfolio-level pursuit and delivery insight.
- mulesoft — Procore, ACC, P6, ERP (Viewpoint / Sage 300 CRE / CMiC), and BIM-coordination tool integration is rarely optional.

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources for this industry, suggest:
- https://www.salesforce.com/solutions/industries/construction/
- https://www.osha.gov/construction  (US construction safety)
- https://www.agc.org/  (Associated General Contractors of America)
- https://www.aia.org/  (American Institute of Architects — AE-side body, AIA contract documents)
- https://www.acec.org/  (American Council of Engineering Companies — engineering-firm trade group)
- https://www.enr.com/  (Engineering News-Record — industry data, top-firm rankings, project news)
- https://www.cmaanet.org/  (Construction Management Association of America)
- https://dbia.org/  (Design-Build Institute of America)
- https://www.construction.com/  (Dodge Construction Network / McGraw-Hill Dodge — construction data and pipeline forecasting)
- https://www.aisc.org/  (American Institute of Steel Construction — structural-steel standards)
- https://www.buildingsmart.org/  (industry-wide BIM / openBIM standards body)
- https://support.procore.com/  (Procore reference docs)
- https://construction.autodesk.com/  (Autodesk Construction Cloud / ACC reference)

## Common sales-conversation pitfalls in this industry

1. Treating the sector as one — capital-project owners, GCs, AE firms, specialty trades, and design-build firms have different revenue models, buyers, and competitive sets, even though they all sit under "construction".
2. Assuming Procore (or ACC) is replaceable — for most GCs, project management lives in Procore or Autodesk Construction Cloud and CRM is the front-end, not the system of record; pitching CRM as the project hub will lose the room.
3. Ignoring jobsite reality — work happens on jobsites with limited connectivity, full PPE, and rotating crews; mobile UX must reflect this or it will not be adopted in the field.
4. Overlooking joint ventures and project-level security — sharing project data with the right JV partner but not with competitors who are partners on a different project is non-trivial in standard CRM and requires deliberate sharing-model design.
5. Disrupting the pay-app and lien-waiver chain — these workflows are how the firm gets paid and how it manages legal exposure; CRM-side workflow changes that fork or duplicate them will be rejected.
6. Pitching "AI-generated submittals" or "AI RFI responses" without addressing professional-liability and engineer-of-record sign-off — AE firms and engineers-of-record carry personal professional liability and will not accept AI-authored content into the design record without controls.

## Common prompt patterns

Pack-specific quick wins — when a prompt names one of these themes, prefer the listed persona blend over the generic full panel:

- **Pursuit / bid pipeline modernization** — Capital Projects Director (owner / GC sub-profile) + Sales Cloud SE + Industry Specialist. Pre-construction and bid pursuit is where CRM lands most cleanly; reads against win-rate and pursuit-cost-per-dollar-won.
- **Project portal / owner experience** — Capital Projects Director (owner sub-profile) + Experience Cloud SE + Security Reviewer. Per-project security and JV partitioning is the architecture conversation that gates this.
- **Punch list / warranty service** — Field Service Coordinator + Field Service SE + Customer Success Manager. Punch-list and 12-month-warranty service is the most defensible Field Service use case in this pack.
- **VDC / BIM data integration** — Capital Projects Director (AE sub-profile) + Data Cloud SE + Architect. Unifying CDE / BIM / project-controls signal with CRM is the data conversation; underestimated integration scope is the common deal-stall.
- **Subcontractor onboarding / COI / prequalification** — Capital Projects Director + Experience Cloud SE + Compliance Officer. Subcontractor prequalification, COI tracking, and safety-record gating is a recurring portal use case.

## Regulatory landscape (one paragraph)

AEC and construction sits in a layered regulatory environment with serious safety, contract, and procurement consequence. OSHA (federal, plus state-plan jurisdictions like Cal/OSHA) governs jobsite safety, recordkeeping (300 / 300A / 301 logs), and fatality / severe-injury reporting; USACE EM 385-1-1 governs federal-construction safety. Building codes (IBC / IRC / IFC / IPC / IMC / NEC) are model codes adopted and modified by state and local AHJs; permitting and inspection regimes are highly local. NEPA governs federal environmental review; Phase I / II ESAs govern site acquisition; SWPPP under EPA NPDES governs construction-site stormwater. Federal-funded work brings Davis-Bacon prevailing wage, DBE / MWBE participation goals, Buy America(n) requirements (intensified by IIJA and IRA), and the Federal Acquisition Regulation (FAR) with agency supplements (DFARS for DoD, FHWA for highway, FTA for transit). State contractor-licensing and bonding requirements vary widely. Lien-law regimes vary widely by state and shape the pay-app and lien-waiver workflow that is central to how the industry gets paid. ADA accessibility constrains design and construction. Insurance and surety (performance and payment bonds, builder's risk, CCIP / OCIP wrap-ups) are commercial-but-regulatory in effect. AE-firm output carries personal professional liability for the engineer-of-record / architect-of-record, which constrains how AI-generated design content can be incorporated. None of this constitutes legal advice — the persona should flag regulatory questions for counsel, the safety officer, and the engineer-of-record rather than over-promise.
