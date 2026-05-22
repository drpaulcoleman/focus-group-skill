# Nonprofit — Industry Pack

Nonprofit covers a wide range of 501(c)(3) and equivalent organizations: human services, education, healthcare, arts and culture, conservation, faith-based, advocacy, associations, and the foundations and grantmakers that fund them. The top pressures right now are donor-acquisition cost rising while small-dollar giving softens, the operational burden of grant reporting and outcome measurement (especially for federal grant recipients), and the persistent technology-debt problem caused by years of donated or deeply discounted software stitched together by volunteers. Salesforce engages through Nonprofit Cloud — the current, supported product that replaced the older Nonprofit Success Pack (NPSP) — paired with Marketing Cloud (or Marketing Cloud Account Engagement / Pardot for smaller orgs), Experience Cloud for donor and volunteer portals, and increasingly Data Cloud for the larger health-system foundations and universities. The typical buyer shape is an Executive Director or CEO as economic buyer in small and mid-sized orgs, a CIO or COO in large orgs, a Director of Development or Chief Advancement Officer as champion, and a Board Treasurer or Finance Committee chair as the unexpected gatekeeper because they sign off on multi-year software commitments.

## Grounding prompt (injected into every persona)

Nonprofit customers speak in terms of constituents (not customers), donors, prospects, major gifts vs annual fund vs planned giving, soft credits, matching gifts, donor-advised funds (DAFs), pledges, recurring giving, gifts-in-kind, restricted vs unrestricted funds, fiscal year (often non-calendar), 990 reporting, grant proposals and reports, program outcomes and logic models, volunteers and volunteer hours, case management (for human-services orgs), and impact. They distinguish between FASB (US accounting standards for nonprofits) and government accounting. Nonprofit Cloud's load-bearing capabilities are the Person Account and household data model, the Gift Entry experience, Outcome Management, Program Management, and Grantmaking (for funders). Many existing customers are still on NPSP and the migration path matters — pretending NPSP doesn't exist will burn credibility immediately.

The honest objections this industry raises against generic SaaS pitches are: (1) "Our budget is constrained and our board scrutinizes overhead — what does this actually cost after the Power of Us discount, and how does it compare to staying on NPSP or moving to Bloomerang/Virtuous/Blackbaud?"; (2) "Our staff are mission-driven generalists, not Salesforce admins — who maintains this after the implementation partner leaves?"; (3) "We tried a CRM migration five years ago and it failed — how is this different?" Compliance and regulatory realities to keep in mind: IRS 501(c)(3) status and the Form 990 transparency regime; state-by-state charitable-solicitation registration requirements (which catch nonprofits off guard when they fundraise across state lines); donor privacy expectations driven by AFP's Donor Bill of Rights and increasingly by GDPR for international donors; FERPA for university-affiliated foundations; HIPAA for healthcare-affiliated foundations; OMB Uniform Guidance (2 CFR 200) for federal grant recipients, which dictates allowable costs, indirect-cost rates, and audit thresholds. The dominant Salesforce footprint is Nonprofit Cloud + Marketing Cloud (or MCAE for smaller orgs) + Experience Cloud, with the Power of Us program providing 10 free Sales/Service licenses that often shapes the deal economics. Decision-making depends heavily on size: under $10M in revenue, the ED decides with board input; $10M–$100M, a small leadership team decides with finance committee approval; over $100M, a full enterprise procurement process applies.

## Recommended industry-specific persona files

Each industry pack contributes 3-5 industry-specific personas at `personas/industries/<slug>/<role-slug>.md`. For this pack, the personas are:

- executive-director.md — CEO of a small-to-mid nonprofit; mission-first, budget-anxious, wears five hats.
- director-of-development.md — Owns fundraising revenue across annual, major, planned, and corporate giving.
- program-manager.md — Delivers the mission program; cares about case management and outcome measurement, not CRM features.
- grants-officer.md — Manages grant lifecycle from prospecting through reporting; lives in deadline-driven workflows.
- board-treasurer.md — Volunteer board member with finance background; gatekeeper on multi-year software commitments.

## Recommended product-pack pairings

When this industry is active, these product packs are most commonly relevant:
- marketing-cloud — Donor journeys, year-end appeals, and event communications; many mid-market nonprofits use Marketing Cloud Account Engagement (formerly Pardot) instead.
- experience-cloud — Donor portals, volunteer portals, grantee portals, and program-participant self-service.
- sales-cloud — Underlies Nonprofit Cloud; the Power of Us 10-license grant typically applies here.
- data-cloud — Relevant for large health-system foundations, R1 universities, and federated nonprofit networks; usually overkill for small orgs.

## URL seed-list (for /download grounding)

- https://www.salesforce.org/nonprofit/
- https://candid.org/ (the merger of GuideStar and Foundation Center; the canonical source for nonprofit financial data and grant data)
- https://www.councilonfoundations.org/ (Council on Foundations; grantmaker community)
- https://www.afpglobal.org/ (Association of Fundraising Professionals; Donor Bill of Rights and ethics)
- https://www.irs.gov/charities-non-profits (IRS exempt-organizations guidance)
- https://www.grants.gov/ (US federal grants portal; relevant when Uniform Guidance comes up)

## Common sales-conversation pitfalls in this industry

1. Assuming a 10-person nonprofit needs the same MEDDPICC rigor as an enterprise — they don't, and pretending otherwise lengthens their sales cycle from weeks to months for no value.
2. Pitching Nonprofit Cloud without acknowledging NPSP — most existing customers are on NPSP, the migration is real work, and "you'll just upgrade" is not a credible answer.
3. Quoting standard list price and forgetting the Power of Us program — the customer will know about it before the second call and will lose trust if the rep didn't surface it first.
4. Demoing major-gift workflows to a customer whose revenue is 80% small-dollar online — the demo lands flat and the Director of Development tunes out.
5. Promising AI-powered donor scoring without addressing the data-quality reality (households, soft credits, deceased flags, DAFs) — nonprofit data hygiene is famously rough and the AI story has to acknowledge that.

## Regulatory landscape (one paragraph)

US nonprofits operate under IRS 501(c)(3) (or related) tax-exempt status with annual Form 990 disclosure, and most states require separate charitable-solicitation registration before soliciting donations from residents (the Unified Registration Statement helps but does not replace state-specific filings). Federal grant recipients are bound by OMB Uniform Guidance (2 CFR 200), which governs allowable costs, indirect cost rates, procurement, and audit thresholds (the Single Audit applies above $750,000 in federal awards, with the threshold rising to $1M for fiscal years starting on or after Oct 1, 2024 — verify current threshold). University-affiliated foundations inherit FERPA obligations on student data; healthcare-affiliated foundations inherit HIPAA obligations on patient and donor data that overlaps with patient records. International fundraising pulls in GDPR and similar regimes. Donor-privacy norms (AFP's Donor Bill of Rights) are not law but are treated as ethical baselines and will be cited by sophisticated donors. Personas should treat these as real constraints on data handling, segmentation, and reporting design.
