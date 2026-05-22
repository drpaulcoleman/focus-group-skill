# Financial Services — Industry Pack

Financial services spans retail and commercial banking, credit unions, wealth and asset management, capital markets, mortgage, consumer and commercial lending, and property/casualty and life/annuity insurance. Top pressures right now are interest-rate-driven margin and deposit-mix volatility, sustained compliance and supervisory intensity (AML/BSA, fair-lending, consumer-protection), and a real shift in customer expectations toward digital, advice-led, and increasingly AI-mediated experiences. Salesforce engages here primarily through Financial Services Cloud (FSC) — used across banking, wealth, and insurance with industry-specific data models, financial accounts, households, action plans, and ACM (Actionable Relationship Center) — plus Service Cloud, Marketing Cloud, Data Cloud, MuleSoft, and Agentforce for advisor and service workflows. The buying center varies: in retail banking, a Chief Digital/Distribution Officer and head of branch/contact center; in wealth, a head of advisory and a COO; in insurance, distribution, underwriting, and claims leaders, each often with their own systems.

## Grounding prompt (injected into every persona)

Use the industry's actual vocabulary. In banking and wealth, the "household" is often the primary unit (with related "members", "financial accounts", "goals"); "KYC/CIP" is customer identification at onboarding; "AML" is anti-money-laundering and "BSA" the underlying US act; "SAR" is a suspicious activity report. In wealth, "AUM" is assets under management, "RIA" is registered investment advisor, "broker-dealer" is a different regulatory animal; "fiduciary" and "suitability" have specific legal meanings (Reg BI in the US). In insurance, "policy", "endorsement", "FNOL" (first notice of loss), "subrogation", and "loss ratio" are core; "underwriting", "binding", and "renewal" structure the lifecycle. In lending, "origination → servicing → default" is the lifecycle and "LOS" (loan origination system) and "servicer" are often separate.

The honest objections this industry raises against generic SaaS pitches: (1) "Our core banking / policy admin / portfolio system is the system of record and we cannot replace it" — FSC sits alongside cores like FIS, Fiserv, Jack Henry, Guidewire, Duck Creek, and SS&C, not on top of them; (2) "Compliance owns a veto on customer-facing AI" — Agentforce and generative AI pitches must address model-risk management (SR 11-7 in the US), explainability, and fair-lending exposure honestly; (3) "Advisor adoption is the whole game in wealth" — if FSC is slower than the legacy book-of-business tool, advisors will not use it regardless of CIO mandate.

The compliance and regulatory realities a persona should keep in mind: in the US, the BSA/AML regime (FinCEN), consumer-protection rules (CFPB, UDAAP), fair-lending (ECOA, HMDA), GLBA privacy, Reg BI (advice), and a layered supervisor map (OCC, FDIC, Fed, NCUA for credit unions, state banking and insurance departments, SEC and FINRA for securities, state insurance commissioners for insurance); in the EU/UK, MiFID II, IDD, GDPR, PSD2, and the EU AI Act increasingly shape practice. The dominant Salesforce footprint is FSC + Service Cloud + Marketing Cloud + MuleSoft, with Data Cloud central to next-best-action and advisor productivity stories. Decisions typically need alignment across business line leadership, IT, compliance, and risk.

## Recommended industry-specific persona files

Each industry pack contributes 3-5 industry-specific personas at `personas/industries/financial-services/<role-slug>.md` (these get created in a separate Phase). For this pack, the personas are:

- retail-banking-head.md — Owns branch, contact center, and digital deposit/lending experience for consumers and small business.
- wealth-advisor.md — Owns client relationships, financial planning, and book-of-business growth at an RIA or wirehouse.
- underwriting-officer.md — Owns risk selection and pricing for insurance or commercial credit.
- compliance-aml-officer.md — Owns BSA/AML program, sanctions screening, and SAR workflow.
- insurance-claims-lead.md — Owns claims operations from FNOL through settlement and subrogation.

## Recommended product-pack pairings

When this industry is active, these product packs are most commonly relevant — the recommender should prefer them unless the user has explicitly set `--product`:
- sales-cloud — Underlies FSC for relationship management, pipeline, and household/account planning.
- service-cloud — Servicing case management, claims intake, and contact-center workflows.
- data-cloud — Householding, financial-account unification, next-best-action signal aggregation.
- mulesoft — Integration to cores, policy admin, custodians, and aggregators is rarely optional.

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources for this industry, suggest:
- https://www.salesforce.com/industries/financial-services/
- https://www.fdic.gov/  (US bank regulator and deposit insurance)
- https://www.fincen.gov/  (US BSA/AML)
- https://www.consumerfinance.gov/  (CFPB — consumer-protection rule-making)
- https://www.naic.org/  (US state insurance regulator coordinating body)
- https://www.finra.org/  (US broker-dealer SRO)

## Common sales-conversation pitfalls in this industry

1. Treating banking, wealth, and insurance as interchangeable — they have different regulators, systems, sales motions, and language.
2. Pitching generative AI to the front office without addressing model-risk management, explainability, and fair-lending — compliance will block what they cannot evidence.
3. Promising "single customer view" without acknowledging core/policy-admin realities — the system of record stays put for years.
4. Ignoring advisor and producer compensation — in wealth and insurance, comp design drives behavior more than UX.
5. Treating households as just "accounts with relationships" — householding in FSC has specific semantics (primary group, related contacts, financial accounts) that demos should respect.

## Regulatory landscape (one paragraph)

Persona should keep in mind: in the US, the BSA/AML regime (FinCEN) requires KYC/CIP at onboarding, sanctions screening, and SAR filing; the CFPB enforces UDAAP and consumer-protection rules across many products; ECOA and HMDA constrain fair-lending and reporting; GLBA governs privacy and safeguards for consumer financial information; Reg BI applies to broker-dealer advice; bank examiners (OCC, FDIC, Fed, NCUA, state) bring SR 11-7-style model-risk expectations to AI deployments; insurance is state-regulated through the NAIC framework; securities through SEC and FINRA. In the EU/UK, MiFID II, IDD, PSD2, GDPR, and increasingly the EU AI Act apply. None of this constitutes legal advice — the persona should flag regulatory questions for counsel and compliance rather than over-promise.
