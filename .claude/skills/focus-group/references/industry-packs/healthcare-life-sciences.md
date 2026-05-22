# Healthcare & Life Sciences — Industry Pack

Healthcare and life sciences (HLS) covers providers (health systems, hospitals, physician groups, post-acute, behavioral health), payers (commercial health plans, Medicare Advantage, Medicaid managed care), pharmaceutical and biotech manufacturers, medical-device makers, and the connective tissue of HIEs, clearinghouses, and specialty pharmacies. Top pressures right now are persistent margin compression at providers (labor cost, payer-mix shifts, denial rates), the value-based-care and price-transparency push from CMS and employers, and an acceleration of digital-front-door, virtual-care, and AI-enabled clinical and operational workflows. Salesforce engages here through Health Cloud (for providers and payers, with patient/member, care plans, utilization management, and provider network data models) and Life Sciences Cloud (for pharma/medtech commercial and clinical operations), plus Service Cloud, Marketing Cloud, Data Cloud, MuleSoft, and Agentforce. The buying center is fragmented: Chief Medical / Chief Clinical Officers, COOs, CIOs, CMIOs, patient experience, revenue cycle, and (in pharma) commercial and medical-affairs leaders all matter.

## Grounding prompt (injected into every persona)

Use the industry's actual vocabulary. In provider settings, people are "patients", a clinical encounter is an "encounter" or "visit", "case" is used for care management and service work; the EHR (Epic, Oracle Health/Cerner, MEDITECH, Athenahealth) is the clinical system of record; "HIE" is health information exchange; FHIR and HL7 v2 are the dominant interop standards. In payer settings, people are "members", "claims" and "authorizations" structure the work, and "UM" (utilization management), "CM" (care management), and "DM" (disease management) are programs. In pharma, the field is "reps" calling on "HCPs" and "HCOs", with Veeva CRM as the entrenched competitor; "MSL" is medical science liaison; "PV" is pharmacovigilance; clinical trials run through "CTMS", "EDC", and "eTMF" systems.

The honest objections this industry raises against generic SaaS pitches: (1) "The EHR is the source of truth and clinicians live in it" — selling a parallel clinical workflow rather than an EHR-adjacent engagement layer loses credibility immediately; (2) "We are HIPAA-covered and your standard contract is not enough" — BAAs (business associate agreements), de-identification, and minimum-necessary access are table stakes, not afterthoughts; (3) in pharma, "Veeva owns the rep" — displacing Veeva CRM is a strategic, multi-year story and pretending otherwise will end the meeting.

The compliance and regulatory realities a persona should keep in mind: in the US, HIPAA Privacy, Security, and Breach Notification rules govern PHI handling and require BAAs with vendors; 42 CFR Part 2 adds protection for substance-use-disorder records; CMS Interoperability and Price Transparency rules push FHIR APIs and standardized data sharing; in pharma, FDA regulates promotion (OPDP), adverse-event reporting (PV), and clinical-trial conduct (GCP); 21 CFR Part 11 governs electronic records and signatures in regulated environments; the Sunshine Act / Open Payments requires tracking of payments to HCPs; state privacy laws (CCPA/CPRA, Washington's My Health My Data Act, others) add layers. The dominant Salesforce footprint is Health Cloud / Life Sciences Cloud + Service Cloud + Marketing Cloud (with HIPAA-compliant configuration) + MuleSoft + Data Cloud. Decisions typically need alignment across clinical, IT, compliance/privacy, and the relevant business sponsor.

## Recommended industry-specific persona files

Each industry pack contributes 3-5 industry-specific personas at `personas/industries/healthcare-life-sciences/<role-slug>.md` (these get created in a separate Phase). For this pack, the personas are:

- chief-medical-officer.md — Owns clinical strategy, quality, and clinician adoption of any patient-facing or clinical workflow.
- director-patient-experience.md — Owns digital front door, access, contact center, and patient satisfaction metrics.
- clinical-trial-ops-lead.md — Owns site management, patient recruitment/retention, and trial operations in pharma/biotech.
- payer-network-director.md — Owns provider network strategy, contracting, and provider-data accuracy at a health plan.
- hipaa-privacy-officer.md — Owns HIPAA compliance, BAAs, breach response, and PHI access governance.

## Customer-type classifier (which sub-industry — provider, payer, or pharma?)

This pack covers three structurally different sub-industries. The skill should detect which one the customer belongs to and weight the panel accordingly — a payer panel ≠ a provider panel ≠ a pharma panel even though all sit under HLS. Detection signals (case-insensitive substring match on the customer name + the prompt body):

**Provider / Health System / Hospital** — lead with `chief-medical-officer`, `director-patient-experience`, `hipaa-privacy-officer`.
- Customer-name patterns: `health system`, `hospital`, `medical center`, `clinic`, `physician group`, `health network`, `regional health`, `kaiser`, `mayo`, `cleveland clinic`, `providence health` *(without "plan")*, `intermountain`, `ascension`, `hca`, `chs`, `tenet`, `dignity`, `sutter`.
- Prompt patterns: `EHR`, `Epic`, `Cerner`, `Oracle Health`, `MEDITECH`, `Athenahealth`, `clinician`, `patient encounter`, `care plan`, `bedside`.

**Payer / Health Plan / Insurer** — lead with `payer-network-director`, `hipaa-privacy-officer`, `chief-medical-officer` *(Medical Director sub-profile if available)*.
- Customer-name patterns: `health plan`, `insurance`, `payer`, `BCBS`, `blue cross`, `blue shield`, `aetna`, `cigna`, `humana`, `united healthcare`, `unitedhealthcare`, `anthem`, `elevance`, `centene`, `molina`, `wellcare`, `medicaid managed`, `medicare advantage`.
- Prompt patterns: `member`, `claim`, `authorization`, `UM`, `CM`, `DM`, `network adequacy`, `risk adjustment`, `STAR ratings`, `HEDIS`.

**Pharma / Biotech / Medical Device** — lead with `clinical-trial-ops-lead`, plus the buyer-side Champion and a Veeva-aware Solution Engineer.
- Customer-name patterns: `pharma`, `biotech`, `biosciences`, `therapeutics`, `pharmaceuticals`, `medtech`, `medical device`, `Pfizer`, `Merck`, `J&J`, `Johnson & Johnson`, `Roche`, `Novartis`, `AstraZeneca`, `Lilly`, `GSK`, `Sanofi`, `Bristol Myers`, `Amgen`, `Gilead`, `Moderna`, `Regeneron`, `Vertex`, `Medtronic`, `Stryker`, `BD`, `Abbott Laboratories`.
- Prompt patterns: `MSL`, `rep`, `HCP`, `HCO`, `clinical trial`, `CTMS`, `EDC`, `eTMF`, `pharmacovigilance`, `PV`, `adverse event`, `Veeva`, `21 CFR Part 11`, `GCP`, `OPDP`, `Sunshine Act`.

**When ambiguous** (a name matches multiple groups, or no name was given) the skill should ask one clarifying question rather than guess: *"Is the customer a provider (hospital / health system), a payer (health plan / insurer), or a pharma / med-device company?"* Then load only that sub-group's personas, plus the always-on `hipaa-privacy-officer` (which is relevant in all three).

## Recommended product-pack pairings

When this industry is active, these product packs are most commonly relevant — the recommender should prefer them unless the user has explicitly set `--product`:
- service-cloud — Patient/member service, contact center, care-management casework, and Agentforce-driven intake.
- marketing-cloud — Patient/member engagement journeys under HIPAA-compliant configuration; HCP engagement for pharma.
- data-cloud — Patient/member 360, FHIR-aware ingestion, and unification across EHR/claims/CRM.
- mulesoft — FHIR/HL7, EHR, payer-core, and clinical-system integration is rarely optional in this industry.

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources for this industry, suggest:
- https://www.salesforce.com/industries/healthcare/
- https://www.salesforce.com/industries/life-sciences/
- https://www.hhs.gov/hipaa/  (US HHS HIPAA hub)
- https://www.hl7.org/fhir/  (FHIR specification — interop standard)
- https://www.cms.gov/  (US CMS — Medicare/Medicaid, interoperability and price transparency rules)
- https://www.fda.gov/  (US FDA — drug/device regulation, including promotion and PV)

## Common sales-conversation pitfalls in this industry

1. Assuming a hospital's "EHR integration" is a single conversation when it is usually Epic (or Cerner/Oracle Health) plus 2-3 ancillaries plus an HIE.
2. Pitching marketing automation to providers without a clear HIPAA-compliant configuration story and an executed BAA path.
3. Conflating provider, payer, and pharma — they are different industries with different regulators, systems, and buyers, even though they all sit under "HLS".
4. Underestimating Veeva in pharma commercial — Veeva CRM is the incumbent for reps and replacing it requires a strategic, multi-year story.
5. Promising Agentforce in clinical workflows without addressing clinical-decision-support regulation, liability, and clinician trust — "AI that touches care" carries different scrutiny than "AI that schedules an appointment".

## Regulatory landscape (one paragraph)

Persona should keep in mind: in the US, HIPAA Privacy, Security, and Breach Notification rules govern protected health information and require BAAs with vendors processing PHI; 42 CFR Part 2 adds protection for substance-use-disorder records; CMS interoperability and price-transparency rules increasingly require FHIR API exposure and standardized data sharing by payers and providers; in pharma and devices, FDA regulates promotion (OPDP), adverse-event reporting / pharmacovigilance, and clinical-trial conduct (GCP); 21 CFR Part 11 applies to electronic records and signatures in regulated environments; the Sunshine Act requires tracking and reporting of transfers of value to HCPs; state privacy laws (CCPA/CPRA, Washington's My Health My Data Act, others) and consumer-health-data laws add further constraints; in the EU/UK, GDPR plus EMA/MHRA rules apply, and the EU AI Act will increasingly shape healthcare AI. None of this constitutes legal advice — the persona should flag regulatory questions for counsel, the privacy office, and (where relevant) the IRB rather than over-promise.
