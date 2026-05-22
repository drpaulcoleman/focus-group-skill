# Education — Industry Pack

The education industry covers K-12 districts, community colleges, four-year public and private universities, graduate and professional schools, and increasingly online program managers (OPMs) and credentialing/continuing-education providers. Top pressures right now are the demographic enrollment cliff in the US (a structural decline in traditional-aged college students), affordability and outcomes scrutiny (tuition discounting, ROI questions, federal Gainful Employment and reporting rules), and the AI moment in teaching, learning, and student support. Salesforce typically engages here through Education Cloud (the successor to EDA + Student Success Hub + advancement assets), Marketing Cloud for recruitment and engagement, Service Cloud for student case management, Data Cloud for student 360, and Experience Cloud for student/alumni portals. The buying center is fragmented: enrollment management, student success, advancement, and IT all have legitimate stakes, and decisions often need cabinet- or provost-level alignment.

## Grounding prompt (injected into every persona)

### Vocabulary

Use the industry's actual vocabulary. People are "students", "applicants", "prospects", "alumni", "donors", "faculty", "staff", and (collectively) "constituents" in advancement contexts. The funnel is "inquiry → applicant → admit → deposit → enroll → retain → graduate". "Student success" covers advising, early-alert, and retention work. "Advancement" covers fundraising and alumni relations. The "SIS" (Student Information System — Banner, PeopleSoft, Workday Student, Colleague) is the system of record for enrollment, registration, grades, and aid; the "LMS" (Canvas, Blackboard, Brightspace, Moodle) is the learning platform. "Sections", "courses", "terms", "cohorts", "FAFSA", "Title IV", and "1098-T" are core vocabulary.

### Honest objections

The honest objections this industry raises against generic SaaS pitches: (1) "We already have an SIS and an LMS, and they own the data — what does Salesforce do that they don't?" — institutions need a clear engagement-layer narrative, not a system-of-record collision; (2) "Education runs on cycles and committees, not quarters" — procurement, faculty governance, and academic-calendar windows make timelines longer than commercial pipelines; (3) "We are not Amazon and our students are not customers" — language matters; over-commercializing the pitch alienates academic and student-affairs stakeholders.

### Regulatory frame

The compliance and regulatory realities a persona should keep in mind: FERPA *(all sub-verticals)* governs student education records and constrains who can see what and under what circumstances; Title IX *(all post-secondary plus K-12)* shapes how complaints, case management, and reporting are handled; the GLBA Safeguards Rule *(higher-ed and for-profit handling financial-aid data)* applies to institutions handling student financial aid data; Title IV *(higher-ed and for-profit)* governs federal student aid eligibility and compliance; in the EU, GDPR and member-state education laws apply; in the UK, the Data Protection Act and OfS reporting; for K-12 in the US, COPPA *(K-12)* and state student-data-privacy laws (e.g., SOPIPA in California) add constraints. The dominant Salesforce footprint is Education Cloud + Marketing Cloud + Service Cloud, with Experience Cloud commonly used for portals. Decisions typically need alignment across enrollment, student affairs, advancement, IT, and often a provost or VPSA. Persona should ask which academic-calendar window the implementation lands in and flag start-of-term collisions.

## Customer-type classifier (which sub-vertical — R1/R2, small private, community college, K-12 district, or for-profit/OPM?)

This pack covers five structurally different sub-verticals. The skill should detect which one the customer belongs to and weight the panel accordingly — a K-12 district panel ≠ a research-university panel ≠ a small private liberal-arts panel even though all sit under "education". This addresses pitfall #1 (confusing K-12 and higher ed) with explicit routing rules. Detection signals (case-insensitive substring match on the customer name + the prompt body):

**R1 / R2 public research university** — lead with `provost-vp-academic`, `faculty-senate-chair`, `cio-it-director`, `director-of-enrollment`, `student-success-advisor`, `advancement-alumni-officer`.
- Customer-name patterns: "University of <state>", "State University", named R1s: `Ohio State`, `Michigan`, `Wisconsin`, `Texas`, `UCLA`, `Berkeley`, `Penn State`, `Purdue`, `Illinois`, `NC State`; substrings: `AAU`, `Big Ten`, `Pac-12`, `SEC`; `Research University`, `Carnegie R1`, `Carnegie R2`.
- Prompt patterns: `Banner`, `PeopleSoft` *(SIS context)*, `faculty senate`, `research IT`, `grant overhead`, `NIH`, `NSF`, `system office`, `multi-campus`.

**Small private (liberal arts / regional)** — lead with `provost-vp-academic`, `faculty-senate-chair`, `director-of-enrollment`, `advancement-alumni-officer`.
- Customer-name patterns: "<Name> College", "<Name> University" *(small, named)*; `Liberal Arts`; named: `Williams`, `Amherst`, `Swarthmore`, `Pomona`, `Bowdoin`, `Middlebury`, `Wesleyan`, `Carleton`, `Grinnell`, `Reed`.
- Prompt patterns: `endowment`, `tuition-dependent`, `enrollment cliff`, `Colleague`, `Jenzabar`, `comprehensive fee`, `merit aid`, `yield`.

**Community college / two-year** — lead with `student-success-advisor`, `cio-it-director`, `director-of-enrollment`.
- Customer-name patterns: `Community College`, `Technical College`, "City College of <city>", "<state> Community College System"; substrings: `Two-year`, `Junior College`.
- Prompt patterns: `workforce development`, `transfer pathway`, `dual enrollment`, `Perkins`, `WIOA`, `apprenticeship`, `state funding formula`, `FTE`.

**K-12 district** — lead with `k-12-superintendent`.
- Customer-name patterns: `School District`, `Unified School District`, `Independent School District`, `ISD`, `Public Schools`, `Charter Network`, `Catholic Schools` *(district)*, "<City> Schools"; named: `LAUSD`, `NYCDOE`, `Chicago Public Schools`, `Houston ISD`, `Miami-Dade`.
- Prompt patterns: `superintendent`, `school board`, `principal`, `Title I`, `IDEA`, `ESSER`, `ESSA`, `state DOE`, `state report card`, `chronic absenteeism`, `MTSS`, `COPPA`, `SOPIPA`.

**For-profit / OPM / continuing ed** — lead with `director-of-enrollment`, `advancement-alumni-officer` *(scoped down)*, plus generic compliance personas.
- Customer-name patterns: `University of Phoenix`, `Capella`, `Walden`, `Strayer`, `DeVry`, `Grand Canyon`; OPMs: `2U`, `Coursera` *(degree partnerships)*, `edX` *(2U-owned)*, `Wiley Education Services`, `Pearson Online Learning Services`.
- Prompt patterns: `gainful employment`, `90/10 rule`, `borrower defense`, `Title IV` *(with for-profit context)*, `incentive compensation`, `bootcamp`, `OPM revenue share`.

**Ambiguous signals** (a name matches multiple groups, the customer crosses sub-verticals — e.g., a multi-system community-college-to-university transfer compact — or no name was given) the skill should ask one clarifying question rather than guess: *"Is the customer an R1/R2 research university, a small private (liberal arts / regional), a community / two-year college, a K-12 district, or a for-profit / OPM / continuing-ed provider?"* Then load only that sub-group's leads.

## Recommended industry-specific persona files

Each industry pack contributes 3-5 industry-specific personas at `personas/industries/education/<role-slug>.md` (these get created in a separate Phase). For this pack, the personas are:

- provost-vp-academic.md — Owns academic affairs, faculty governance, and curricular decisions.
- director-of-enrollment.md — Owns recruitment, admissions, and yield.
- student-success-advisor.md — Owns advising, early-alert intervention, and retention work.
- cio-it-director.md — Owns the SIS/LMS landscape, integration architecture, and data governance.
- advancement-alumni-officer.md — Owns fundraising, alumni engagement, and donor lifecycle.
- k-12-superintendent.md — District CEO accountable to the school board, state DOE, and parent-voters; carries the K-12 regulatory, ESSER-cliff, and SIS/parent-portal lens.
- faculty-senate-chair.md — Elected faculty governance voice carrying the shared-governance veto on AI, student-data, and surveillance-adjacent proposals.

## Recommended product-pack pairings

When this industry is active, these product packs are most commonly relevant — the recommender should prefer them unless the user has explicitly set `--product`:
- marketing-cloud — Inquiry-to-enroll journeys, yield campaigns, and alumni engagement.
- service-cloud — Student case management, advising queues, and tier-1 support.
- experience-cloud — Student, applicant, faculty, and alumni portals.
- data-cloud — Student 360, early-alert signals, and unification across SIS/LMS/CRM.

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources for this industry, suggest:
- https://www.salesforce.org/higher-ed/  (or https://www.salesforce.com/education/)
- https://www.educause.edu/  (the dominant higher-ed IT association — research, conferences, vendor evals)
- https://www.cosn.org/  (K-12 IT — the EDUCAUSE counterpart for K-12 school-district CTOs)
- https://www.nacubo.org/  (CFO / higher-ed business officers — finance lens)
- https://www.aacrao.org/  (registrars and admissions — load-bearing for any SIS-adjacent work)
- https://www.case.org/  (advancement / alumni-engagement reporting standards)
- https://studentaid.gov/  (US federal student aid — FAFSA, Title IV context)
- https://www2.ed.gov/policy/gen/guid/fpco/ferpa/  (US Department of Education FERPA guidance)
- https://www.ftc.gov/business-guidance/privacy-security/childrens-privacy  (US FTC official COPPA business-guidance page — canonical source for K-12)

## Common sales-conversation pitfalls in this industry

1. Confusing K-12 and higher ed — they have different regulators (COPPA/state laws vs. FERPA-centric), different buyers (district vs. campus), and different sales cycles.
2. Pitching CRM as the system of record for student data — the SIS is, and IT will push back hard if the narrative blurs this.
3. Ignoring faculty governance — academic systems often require faculty senate or curriculum-committee buy-in that procurement alone cannot deliver.
4. Treating advancement as just another marketing motion — fundraising has its own data model (gifts, pledges, soft credits, planned giving) and its own constituent-trust expectations.
5. Forgetting summer — academic calendars create implementation windows; ignoring them yields launch dates that collide with start-of-term.

## Regulatory landscape (one paragraph)

Persona should keep in mind: in the US, FERPA constrains disclosure of student education records and shapes consent, parent/student rights, and directory-information policies; Title IX requires specific case-management and reporting practices for sex-based discrimination and harassment; the GLBA Safeguards Rule applies to financial-aid data handling; for K-12, COPPA and state student-data-privacy laws constrain edtech vendors and data sharing. In other geographies, GDPR (EU/EEA), the UK Data Protection Act, and country-specific education laws apply. None of this constitutes legal advice — the persona should flag regulatory questions for counsel and the campus privacy/compliance office rather than over-promise.
