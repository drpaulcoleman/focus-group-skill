# Professional Services — Industry Pack

Professional services covers consulting firms (strategy, management, technology, Big 4), systems integrators and digital agencies, accounting and tax practices, law firms, architecture and engineering firms, and the long tail of specialized advisory practices. The top pressures right now are utilization and pipeline volatility (especially in tech-adjacent consulting after the 2023-24 contraction), talent retention as senior consultants leave for boutique or in-house roles, and the rising client expectation that AI will compress hours-based engagements into fixed-fee outcomes. Salesforce engages through the core clouds — Sales Cloud, Service Cloud, and Experience Cloud — typically paired with a Professional Services Automation (PSA) tool like Salesforce PSA (the native SKU, formerly known as Salesforce PSA / FinancialForce-acquired lineage), Certinia (formerly FinancialForce; runs on the Salesforce platform but is a partner product, not the native SKU), Kantata (formerly Mavenlink/Kimble; also a platform partner, not the native SKU), Projector PSA, Replicon, OpenAir, or Workday PSA, since Salesforce's dedicated coverage for this vertical is the native PSA SKU rather than a full Industries Cloud. The typical buyer shape is a Managing Partner or Practice Lead as economic buyer for a single practice, a CIO or COO for a firmwide deal, a Resource Manager or Director of Operations as champion, and an Engagement Partner who must believe the rollout will help — not hurt — billable utilization.

## Grounding prompt (injected into every persona)

### Vocabulary

Professional services customers speak in terms of engagements (not projects, usually), statements of work (SOWs), master services agreements (MSAs), time and materials vs fixed fee vs retainer, utilization (billable hours / available hours), realization (billed / standard rate), leverage (junior-to-senior ratio), bench, pursuit, win rate, backlog, work-in-progress (WIP), unbilled receivables, revenue recognition under ASC 606 / IFRS 15 (percentage of completion is common), and chargeable expenses. They distinguish sharply between business development (selling new logos), account management (growing existing clients), and delivery (running the engagement). A consulting firm's CRM problem is rarely "track more leads"; it is "stop competing internally for the same client" and "give the engagement partner a clean view of relationship history before the renewal conversation."

### Honest objections — management consulting (strategy / advisory / Big 4)

The honest objections this industry raises against generic SaaS pitches are: (1) "Our partners hate CRM hygiene — what makes you think they'll update this when they ignored the last three systems we bought?"; (2) "We already have a PSA — show me how Salesforce coexists with Certinia or Kantata without making consultants enter time in two places"; (3) "Our clients expect confidentiality — how do you handle conflicts of interest, ethical walls, and client data segregation at the firm level?"; (4) "AI is going to commoditize our deliverables — what's your story on protecting our methodology IP?"; (5) "Your demo orgs all show software companies — show me a firm at our scale where partners actually use it."

### Honest objections — IT services / SI / GSI / MSP

The honest objections this sub-vertical raises are: (1) "Utilization is the lifeblood KPI — any feature that pulls billable hours off the line, even for 'productivity,' is a structural threat to our P&L and our managers will route around it"; (2) "Cross-tower revenue recognition under fixed-fee is non-trivial — show me how your system handles a single SOW that spans an offshore dev pod, an onshore architect, and a managed-services tail without breaking ASC 606 percentage-of-completion"; (3) "Offshore-onshore ratio is the deal margin — if your resource-management view doesn't surface the blended-rate impact of every staffing change in real time, our delivery leads will ignore it"; (4) "We already run ServiceNow or Jira for delivery — don't try to replace them; tell me the integration story honestly"; (5) "Our deals are won by named-account hunters with twenty-year relationships at the CIO — your AI-assisted prospecting story is mostly noise at our size of opportunity."

### Honest objections — law firm

The honest objections this sub-vertical raises are: (1) "Confidentiality under Rule 1.6 trumps every other consideration — if you cannot produce a SOC 2 Type II report, a clean data-residency story, and proof that Einstein won't ingest matter content for model training, the conversation ends"; (2) "Ethical-wall implementation is non-negotiable — show me row-level and record-level segregation across matters, lateral-hire walls that survive re-org, and an auditable conflicts-check log, or we cannot deploy"; (3) "Billable-hour realization is finely-tuned and any AI that drafts unbillably is a strategic existential threat — partners will not adopt a tool that compresses the hours they bill against"; (4) "We run Aderant or Elite for matter financials and iManage for documents — Salesforce is a front-office bolt-on for us, not a system of record; price and scope accordingly"; (5) "The General Counsel and the Ethics Partner will both sign off before IT — your demo has to address conflicts and confidentiality in the first ten minutes, not the appendix."

### Honest objections — creative agency

The honest objections this sub-vertical raises are: (1) "Talent is the asset, not the platform — our creative directors won't touch a CRM and any rollout that demands their data entry will be quietly sabotaged"; (2) "Project-margins are razor-thin and tooling-change must show ROI within one engagement cycle — we can't afford a 12-month value-realization curve"; (3) "Client-team relationships are personal and any 'centralized account intelligence' feels like surveillance — our account leads will withhold the real context from any shared system"; (4) "We bill on retainer, project rate, and media commission in the same agreement — your revenue model has to handle all three or finance will keep using spreadsheets"; (5) "Our pitch process is creative-led, not pipeline-led — generic Sales Cloud opportunity stages map poorly to 'chemistry meeting → creds → tissue session → final pitch.'"

### Honest objections — accounting / tax / audit

The honest objections this sub-vertical raises are: (1) "Independence rules (Reg S-X 2-01 for SEC audit clients) constrain every cross-sell — your account-team-based selling motion has to respect a hard wall between audit and non-audit services or we cannot deploy it for the audit practice"; (2) "Peer review is real and PCAOB inspection findings flow back to the persona's own performance review — any workflow change that touches audit documentation has to survive an inspection"; (3) "AICPA independence and the SEC's auditor-independence rules require us to track every prohibited service offering by client — your CRM has to enforce, not just record, the restriction list"; (4) "Tax-season seasonality means a Q1 rollout is a non-starter for the tax practice — your implementation plan has to respect engagement-cycle reality"; (5) "We use CCH Axcess, Thomson Reuters, or Wolters Kluwer for the actual work — Salesforce is the front office; tell me the integration story to the engagement-management tools or this is just expensive contact management."

### Honest objections — A&E firm

The honest objections this sub-vertical raises are: (1) "Professional-liability (E&O) drives every documentation decision — if your system encourages quick informal communication that ends up as discoverable design intent, our risk manager will block it"; (2) "Deliverable-IP retention is contractually negotiated per engagement — your data model has to handle 'owner retains IP,' 'firm retains IP,' and 'joint IP with prime' on the same project without forcing one default"; (3) "CAD/BIM tool integration matters more than CRM polish — if you don't integrate cleanly with Revit, AutoCAD, Bentley, Procore, and Newforma, principals will see this as overhead"; (4) "Our work is won by sealed-and-stamped principals with personal reputation in their geography — generic 'account planning' content lands flat against twenty-year client relationships in a small market"; (5) "We bill on percentage-of-construction-cost, lump-sum, hourly-not-to-exceed, and reimbursable expenses in the same contract — PSA configuration is harder here than in consulting and your demo has to prove it."

### Honest objections — staffing / recruiting / RPO

The honest objections this sub-vertical raises are: (1) "Bill-rate / pay-rate spread is the entire business — if your reporting can't show real-time gross-margin per placement by recruiter, account manager, and VMS, our operators will keep using their own spreadsheets"; (2) "Candidate-rediscovery costs are the operational obsession — show me how you surface previously-placed and previously-interviewed candidates against a new req in under 30 seconds, or we'll keep buying point ATS tools"; (3) "ATS integration weight is the buy-vs-build conversation — Bullhorn, Avionté, JobDiva, and iCIMS are the real systems of record; tell me where Salesforce sits relative to them honestly"; (4) "VMS-driven requisitions (Fieldglass, Beeline, SAP Fieldglass) arrive through one-way feeds and dictate our submission process — your workflow has to absorb that, not fight it"; (5) "Margin compression from MSPs and pay-transparency laws is squeezing us — your AI-prospecting story has to translate into measurable spread improvement, not just 'more leads.'"

### Regulatory frame

Compliance and regulatory realities to keep in mind: client confidentiality and conflict-of-interest rules (codified in law-firm rules of professional conduct, AICPA standards for CPA firms, and contractual confidentiality clauses elsewhere); SOC 2 and ISO 27001 expectations from enterprise clients in their vendor-risk reviews; data-residency requirements from EU and UK clients; for law firms, the ABA Model Rules and state-bar equivalents (including Rule 1.6 on confidentiality and the 2012 update making technology competence an explicit duty); for accounting firms, AICPA's SSARS and PCAOB rules for public-company auditors. The dominant Salesforce footprint is Sales Cloud + Experience Cloud (for client portals) + a third-party PSA integrated via API, with Service Cloud appearing when the firm has a managed-services or help-desk practice. Decision-making is partnership-driven: even with a CIO sponsor, the deal typically needs sign-off from a practice leadership committee, and a single influential partner can stall a rollout indefinitely.

## Customer-type classifier (which sub-type — consulting, IT services, accounting, law, agency, A&E, or staffing?)

This pack covers seven structurally different sub-types of professional-services firm. The skill should detect which one the customer belongs to and weight the panel accordingly — a law-firm panel ≠ a Big 4 consulting panel ≠ a creative-agency panel even though all sit under "professional services". Detection signals (case-insensitive substring match on the customer name + the prompt body):

**Management consulting (strategy / advisory / Big 4)** — lead with `engagement-partner`, `practice-lead`, `billing-project-accounting-lead`, `independence-risk-management-lead` *(hard must-include, especially Big 4)*.
- Customer-name patterns: Big 4: `Deloitte`, `Deloitte Consulting`, `EY`, `Ernst & Young`, `PwC`, `PricewaterhouseCoopers`, `KPMG`; MBB: `McKinsey & Company`, `Boston Consulting Group`, `BCG`, `Bain & Company`; strategy/advisory: `Oliver Wyman`, `AlixPartners`, `Alvarez & Marsal`, `A.T. Kearney` *(Kearney)*, `Roland Berger`, `Strategy&`, `FTI Consulting`, `L.E.K. Consulting`, `ZS Associates`; substrings: `Consulting`, `Advisory`, `Strategy`.
- Prompt patterns: `Big 4`, `MBB`, `partner-track`, `up-or-out`, `pyramid`, `leverage`, `manager`, `principal`, `partner`, `engagement letter`, `letter of engagement`, `independence` *(Big 4 context)*.

**IT services / SI / GSI / MSP** — lead with `practice-lead`, `engagement-partner` *(GSI sub-profile)*, `client-relationship-director`.
- Customer-name patterns: GSI: `Accenture`, `IBM Consulting`, `IBM`, `Capgemini`, `Cognizant`, `Infosys`, `TCS`, `Tata Consultancy Services`, `Wipro`, `HCL`, `Tech Mahindra`, `NTT Data`, `DXC`, `Atos`; mid-tier SI: `Slalom`, `West Monroe`, `Booz Allen Hamilton` *(commercial)*, `BCG Platinion`; substrings: `Tech Services`, `Digital Solutions`, `Systems Integrator`, `Integration Services`.
- Prompt patterns: `fixed-fee`, `T&M`, `time and materials`, `offshore ratio`, `delivery center`, `pyramid`, `BTC`, `bill rate`, `realization`, `utilization`, `bench`, `MSA`, `SOW`, `staff augmentation`.

**Accounting / tax / audit** — lead with `billing-project-accounting-lead`, `engagement-partner` *(audit sub-profile)*, `client-relationship-director`, `independence-risk-management-lead` *(hard must-include)*.
- Customer-name patterns: Big 4 audit arms; mid-tier: `Grant Thornton`, `BDO`, `RSM`, `Crowe`, `Baker Tilly`, `Moss Adams`, `CohnReznick`, `CliftonLarsonAllen`, `CLA`, `Forvis Mazars`, `Eide Bailly`; substrings: `CPA`, `Tax`, `Audit` *(firm context)*.
- Prompt patterns: `CPA`, `audit cycle`, `engagement`, `independence` *(audit independence)*, `peer review`, `PCAOB`, `SOC 1`, `SOC 2`, `attest`, `non-attest`, `R&D credit`, `M&A tax`, `transfer pricing`.

**Law firm** — lead with `engagement-partner` *(law-partner sub-profile)*, `billing-project-accounting-lead`, `client-relationship-director` *(rainmaker sub-profile)*, `independence-risk-management-lead` *(hard must-include; ethical-wall and conflicts owner)*.
- Customer-name patterns: AmLaw 100: `Kirkland & Ellis`, `Latham & Watkins`, `Baker McKenzie`, `DLA Piper`, `Skadden`, `White & Case`, `Jones Day`, `Sidley Austin`, `Hogan Lovells`, `Norton Rose Fulbright`, `Greenberg Traurig`, `Morgan Lewis`, `Reed Smith`, `Mayer Brown`, `K&L Gates`; substrings: `LLP`, `Attorneys at Law`, `Law Firm`, `Counselors`.
- Prompt patterns: `Am Law`, `Am Law 100`, `Am Law 200`, `chargeable hour`, `billable hour`, `realization rate`, `WIP`, `work in process`, `trust account`, `IOLTA`, `conflicts check`, `ethical wall`, `lateral`, `equity partner`, `non-equity partner`, `LPM`, `legal project management`.

**Creative / ad / brand agency** — lead with `engagement-partner` *(creative-lead sub-profile)*, `client-relationship-director`.
- Customer-name patterns: holding cos: `WPP`, `Omnicom`, `Publicis Groupe`, `Interpublic Group`, `IPG`, `Dentsu`, `Havas`, `Stagwell`; agencies: `BBDO`, `DDB`, `Ogilvy`, `McCann`, `TBWA`, `R/GA`, `Wieden+Kennedy`, `Droga5`, `Edelman` *(PR)*; substrings: `Agency`, `Creative`, `& Co` *(agency context)*, `Brand Studio`.
- Prompt patterns: `creative brief`, `pitch`, `account team`, `creative director`, `production company`, `retainer`, `project rate`, `media commission`, `awards`, `craft`, `freelance bench`.

**Architecture & engineering (A&E)** — lead with `engagement-partner` *(principal sub-profile)*, `practice-lead`, `billing-project-accounting-lead`.
- Customer-name patterns: A&E: `AECOM`, `Jacobs`, `Stantec`, `WSP`, `HDR`, `Burns & McDonnell`, `Gensler`, `HOK`, `Skidmore Owings & Merrill`, `SOM`, `Perkins Eastman`, `KPF`, `Foster + Partners`; substrings: `Architects`, `Engineering Group`, `Designers`, `& Associates` *(A&E)*.
- Prompt patterns: `principal`, `senior associate`, `RFP`, `RFQ` *(A&E)*, `studio`, `practice area`, `professional liability`, `errors & omissions`, `E&O`, `CDs`, `construction documents`, `IFC` *(issued for construction)*.

**Staffing / recruiting / RPO** — lead with `billing-project-accounting-lead` *(staffing margin sub-profile)*, `resource-manager`.
- Customer-name patterns: `ManpowerGroup`, `Adecco`, `Randstad`, `Robert Half`, `Kelly Services`, `Allegis Group`, `Aerotek`, `Insight Global`, `Kforce`, `ASGN`, `TEKsystems`; substrings: `Staffing`, `Recruiting`, `Talent`, `Personnel`, `Workforce Solutions`.
- Prompt patterns: `bill rate`, `pay rate`, `markup`, `temp-to-perm`, `contingent`, `RPO`, `MSP` *(staffing managed service program)*, `VMS`, `Fieldglass`, `SAP Fieldglass`, `Beeline`, `co-employment`, `worker classification`.

**Ambiguous signals** (a name matches multiple groups, or no name was given) — ask one clarifying question rather than guess: *"Is this customer a management-consulting firm, an IT-services / systems-integrator, an accounting/tax/audit firm, a law firm, a creative or advertising agency, an architecture & engineering firm, or a staffing / recruiting business?"* Then load only that sub-group's lead personas. Note on billing models: these sub-types use materially different default billing models — law is hour-billing-default, creative agencies are project/retainer-default, IT services is fixed-fee-default; the Billing Lead persona reads each differently.

## Recommended industry-specific persona files

Each industry pack contributes 3-5 industry-specific personas at `personas/industries/<slug>/<role-slug>.md`. For this pack, the personas are:

- resource-manager.md — Allocates consultants to engagements; lives in the utilization vs bench tension every week.
- engagement-partner.md — Owns the client relationship and the engagement P&L; will adopt a tool only if it visibly helps win and renew work.
- billing-project-accounting-lead.md — Owns WIP, revenue recognition, and client invoicing; the unsung gatekeeper on PSA integration.
- client-relationship-director.md — Owns the firmwide view of a strategic account across multiple practices; cares about cross-sell and conflict avoidance.
- practice-lead.md — Runs a practice or service line P&L; balances pipeline, delivery quality, and consultant development.
- independence-risk-management-lead.md — Owns whether an engagement can exist at all under independence, conflicts, and professional-conduct rules; hard veto authority for Big 4 advisory, audit, and law-firm scenarios.

*Pack ships 6 personas; for default 5-cap panels, drop the least-aligned for the specific scenario (e.g., drop `resource-manager` for a Big 4 audit-independence pitch; drop `independence-risk-management-lead` for a creative-agency or staffing-firm panel).*

## Recommended product-pack pairings

When this industry is active, these product packs are most commonly relevant. The pairings differ materially by sub-vertical — Salesforce's footprint at a Big 4 consulting firm is not the same shape as at a law firm or a staffing agency, and demoing the wrong stack is a quick way to lose credibility.

### For management consulting / Big 4

- sales-cloud — Pipeline, pursuit management, and account planning across practices; the foundation.
- experience-cloud — Client portals for deliverables, status, and self-service; increasingly expected by enterprise clients.
- slack — Engagement-team collaboration, especially for distributed delivery teams; pairs naturally with channel-per-engagement workflows.
- tableau — Utilization, realization, and pipeline analytics; partners want a dashboard they can read in 30 seconds.

### For IT services / SI / GSI

- sales-cloud — Named-account pursuit, large-deal pipeline, and partner-attached opportunity management.
- revenue-cloud — Critical for the complex SOW / T&M / fixed-fee mix typical of GSI deals, including milestone billing and ASC 606 percentage-of-completion handoff.
- salesforce-psa — Or platform-PSA (Certinia, Kantata); engagement P&L, blended-rate resource planning, and offshore-onshore ratio visibility.
- service-cloud — Managed-services and AMS practice support; ticket-to-billing tie-back for run-the-business contracts.
- slack — Delivery-team collaboration across distributed onshore / nearshore / offshore pods; channel-per-engagement is near-universal here.

### For law firm

- sales-cloud — Pursuit and lateral-hire pipeline; relationship intelligence across the partnership without surfacing matter content.
- experience-cloud — Deal-room and matter-status client portal; the modern replacement for ad-hoc extranets.
- slack — Matter-collaboration with conflict-walling enforced at channel level; ethical-wall implementation is the gating design constraint.
- mulesoft — Aderant / Intapp / iManage integration; the front office can only succeed if it can reach the matter-financial and document systems of record.

*Note: Salesforce PSA is NOT the default for law firms — most run Aderant or Elite for matter financials, and replacing that is a separate, much larger conversation.*

### For creative agency

- sales-cloud — New-business pipeline, with stages mapped to the creative-led pitch process (chemistry / creds / tissue / final pitch) rather than generic B2B stages.
- salesforce-psa — Project profitability and per-engagement margin tracking; the single most impactful win for agency CFOs.
- slack — Creative collaboration; pairs naturally with file-sharing and review cycles in the agency workflow.
- marketing-cloud — For the agency's own marketing (thought leadership, awards, new-business nurture), not client-side delivery.

*Note: Service Cloud is typically light or absent for agencies — there is no help-desk persona in the agency org.*

### For accounting / tax / audit

- sales-cloud — Independence-aware client tracking, with hard enforcement of prohibited-service rules for SEC audit clients.
- experience-cloud — Client portal for tax workpapers, document exchange, and engagement-letter signature.
- service-cloud — Year-end engagement workflow, especially for tax-season case management and client-request tracking.
- data-cloud — Cross-practice client view that respects independence walls; underpins the "one firm" account intelligence story without breaching Reg S-X 2-01.

*Note: Salesforce PSA is optional — many accounting firms run engagement management inside CCH Axcess or Thomson Reuters and treat Salesforce as front office only.*

### For A&E firm

- sales-cloud — Pursuit pipeline organized by geography and practice area; RFQ / RFP tracking against owner and GC accounts.
- salesforce-psa — Project profitability with handling for percentage-of-construction-cost, lump-sum, and reimbursable-expense billing in the same engagement.
- experience-cloud — Owner / GC collaboration portal for design submittals, RFIs, and status reporting.
- mulesoft — CAD / BIM / Procore integration; the front office is only credible if it can reach Revit, AutoCAD, Bentley, Procore, and Newforma.

### For staffing / recruiting / RPO

- sales-cloud — Req-to-fill pipeline, account-manager-and-recruiter dual ownership, and VMS-fed req absorption.
- salesforce-psa — Engagement billing for managed-service and RPO contracts where the firm owns delivery accountability beyond placement.
- marketing-cloud — Candidate engagement, re-engagement of silver-medalists, and nurture of passive talent pools.
- data-cloud — ATS unification across Bullhorn, Avionté, JobDiva, and iCIMS; the foundation for credible candidate-rediscovery against a new req.

## URL seed-list (for /download grounding)

- https://www.salesforce.com/solutions/industries/professional-services/
- https://www.aicpa-cima.com/ (AICPA / CIMA; professional standards for accounting and finance professionals)
- https://www.americanbar.org/groups/professional_responsibility/publications/model_rules_of_professional_conduct/ (ABA Model Rules; relevant for law firms)
- https://www.consultancy.org/ (industry trade publication; market sizing and trends)

## Common sales-conversation pitfalls in this industry

1. Selling "AI productivity" hours-savings to a firm whose entire revenue model is billable hours — without an honest conversation about pricing-model evolution, the partners hear "you want me to bill less."
2. Ignoring the existing PSA and assuming Salesforce will replace it — most firms have a multi-year PSA investment and integration, not replacement, is the only viable path.
3. Demoing pipeline features to partners without showing the engagement-partner view of a renewal — partners care about their accounts, not the firm's pipeline.
4. Underestimating the partner-veto risk — a CIO-led deal can be killed by one senior partner who doesn't trust the rollout; champion-building has to extend into the partnership.
5. Skipping the conflict-of-interest and ethical-walls conversation with law and Big 4 prospects — the General Counsel will surface it and the deal will pause for an architecture review.

## Regulatory landscape (one paragraph)

Professional services firms do not have a single regulator, but they live inside a dense set of professional-conduct rules that function regulator-like. Law firms operate under state-bar rules of professional conduct (largely tracking the ABA Model Rules), with Rule 1.6 on confidentiality, Rule 1.7 on conflicts, and Rule 1.1 Comment 8 on technology competence shaping every CRM and AI conversation. Accounting firms operate under AICPA Code of Professional Conduct, SSARS for non-audit work, and PCAOB rules for firms auditing public companies, plus SEC independence rules. All firms face client-driven SOC 2 and ISO 27001 expectations, data-residency clauses (especially from EU and UK clients), and contractual confidentiality obligations that often exceed any statutory baseline. Cross-border engagements pull in GDPR, the UK Data Protection Act, and a growing list of US state privacy laws. Personas should treat client confidentiality and conflict management as load-bearing design constraints, not as legal-team boilerplate.
