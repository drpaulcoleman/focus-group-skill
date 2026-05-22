# Persona Roster

Every persona file carries:
- `**Family:**` (Generic-Technical / Generic-Stakeholder / Generic-Customer / Generic-Investor / Generic-Executive / Salesforce-Sales / Salesforce-Customer / Industry-<slug>)
- `**Default mode:**` Stakeholder | Audience
- `**One-liner:**`
- `## Sub-profiles` (when applicable)
- `## Deliberative profile` — five inherited weights (Tolerance for ambiguity, Locus of control, Risk orientation, "What I bring the panel can't get elsewhere", "Where I refuse to go along") + two added (Tech adoption posture, Decision-making style)
- `## Generic lens` — fires under `--generic`
- `## Product-focus lens` — one block per product pack the persona is wired to
- `## Modes`
- `## Voice`

See [deliberation.md](deliberation.md) for what the deliberative profile drives.

## Generic families (always available)

### Technical (12) — reviews as Collaborator (default: Stakeholder)
- Backend Engineer · `personas/generic/technical/backend-engineer.md`
- Salesforce Platform Developer · `personas/generic/technical/salesforce-platform-developer.md` *(replaces the source Delphi/FMX Client Engineer)*
- Security Reviewer · `personas/generic/technical/security-reviewer.md`
- Schema/DB Reviewer · `personas/generic/technical/schema-db-reviewer.md`
- DevOps / SRE · `personas/generic/technical/devops-sre.md`
- QA / Test Engineer · `personas/generic/technical/qa-test-engineer.md`
- AI / Agent Architect · `personas/generic/technical/ai-agent-architect.md`
- iOS / Android / Windows / macOS Platform Innovation Experts · `personas/generic/technical/{ios,android,windows,macos}-platform-innovation-expert.md`
- Cloud Architect (multi-cloud) · `personas/generic/technical/cloud-architect.md` *(generalized from the source GCP Expert)*
- Frontier Agentic-Automation Expert · `personas/generic/technical/frontier-agentic-automation-expert.md`

### Internal Stakeholder (3) — reviews as Sign-off (default: Stakeholder)
- Compliance & Regulatory Officer · `personas/generic/stakeholder/compliance-officer.md`
- Product Owner · `personas/generic/stakeholder/product-owner.md`
- Cost & Budget Owner · `personas/generic/stakeholder/cost-budget-owner.md`

### Customer (5) — reacts as Audience (default: Audience)
- Enterprise Buyer · `personas/generic/customer/enterprise-buyer.md` *(replaces Sovereign-Wealth Client)*
- SMB / Mid-Market Buyer · `personas/generic/customer/smb-midmarket-buyer.md` *(replaces Crypto-Curious Retail)*
- Security-Anxious Skeptic · `personas/generic/customer/security-anxious-skeptic.md`
- Accessibility-Dependent User · `personas/generic/customer/accessibility-dependent-user.md`
- Beta Tester · `personas/generic/customer/beta-tester.md`

### Investor (4) — reacts as Capital (default: Audience)
- Enterprise SaaS VC · `personas/generic/investor/enterprise-saas-vc.md` *(replaces Fintech VC)*
- Strategic Acquirer · `personas/generic/investor/strategic-acquirer.md` *(replaces Crypto-Native Investor)*
- Diligence / Risk Analyst · `personas/generic/investor/diligence-risk-analyst.md`
- Pitch-Narrative Coach · `personas/generic/investor/pitch-narrative-coach.md`

### Executives (always available, generic, default: Stakeholder)
CEO · COO · CFO · CIO · CTO · CMO · CRO · Chief Customer Officer · Chief Data Officer · CISO · VP Sales · VP Marketing · VP IT · VP Engineering · VP Customer Success · Marketing Manager · IT Manager.

Files: `personas/generic/executives/<slug>.md`. Each shares a deliberately
similar structure; the differences live in the lens, voice, and concerns.

## Salesforce sales-team personas (always on when product pack = `salesforce-*`)

Reviewers the AE/SE can ask *"would this land with our SE? would it survive
the Industry Specialist's read?"*

- Account Executive (AE)
- Solution Engineer (SE)
- Industry Specialist
- Enterprise Architect
- Technical Architect
- Business Value Consultant
- Lead Engagement / SDR Coach
- Customer Success Manager
- Partner Account Manager

Files: `personas/salesforce-sales/<slug>.md`.

## Salesforce customer-side personas (always on when product pack = `salesforce-*`)

The customer's seat at the table.

- Economic Buyer (CIO / CFO / CRO / CCO — picked per cloud)
- Champion (the user who'll bring it in)
- Champion's Manager (the Champion's direct boss; reads everything for political cover)
- Technical Decision-Maker (CTO / VP Engineering / Salesforce admin)
- End-User / Power-User
- Procurement / Vendor Management
- InfoSec / Privacy Officer (data residency, FedRAMP, HIPAA, GxP, PCI as relevant)
- Legal / Contracts
- Change-Management Sponsor

Files: `personas/salesforce-customer/<slug>.md`.

## Salesforce partner-ecosystem personas (suggest when an SI or ISV is in the deal)

The seat across the table that isn't the customer — the implementation
firm building the work, or the AppExchange ISV whose product is in the
solution. The recommender suggests these when the prompt or the org
profile mentions an SI partner, a GSI, an AppExchange app, or a
multi-vendor delivery shape.

- Implementation Partner (SI) — generic SI delivery view (scope,
  feasibility, change-order risk, staffing)
- Global SI Partner Lead (GSI) — Accenture / Deloitte / IBM / Cognizant
  / Wipro / Capgemini / Slalom-class; multi-year account / co-sell view
- Boutique SI / Specialist Partner — small firm or specialist; thesis-
  anchored, candid about fit
- AppExchange ISV — product leader at an ISV with a managed-package or
  connector on AppExchange; product fit + channel economics + Salesforce-
  roadmap-risk view

Files: `personas/salesforce-partner/<slug>.md`.

Note on the difference from `salesforce-sales/partner-account-manager.md`:
that persona is the *Salesforce-side* PAM (the AE-equivalent for partner
deals). The four personas above are the *partner-side* seats — the
people on the SI or ISV side of the table.

## Industry-specific personas (loaded only when an industry pack is active)

Each industry pack contributes 3–8 personas (most ship 5; some have grown to 6-8 to cover load-bearing seats). See [industry-packs/](industry-packs/) for the full lists; canonical examples (newly added personas in **bold**):

| Industry pack | Industry-specific personas |
|---------------|----------------------------|
| `nonprofit` | Executive Director · Director of Development (Fundraising) · Program Manager · Grants Officer · Board Treasurer · **Nonprofit Controller** |
| `education` | Provost / VP Academic Affairs · Director of Enrollment · Student Success Advisor · CIO/Director of IT · Advancement/Alumni Officer · **K-12 Superintendent** · **Faculty Senate Chair** |
| `aec-construction` | Capital Projects Director · Field Service Coordinator · **VDC / BIM Lead** · **Preconstruction & Estimating Director** · **Cost Engineer / Change-Order Lead** · **Owner-Side Procurement Officer** |
| `airlines-air-travel` | Airline Ops Control Center Lead · Reservations & Booking Director · Ancillary Revenue Manager · **Revenue Management & Pricing Scientist** |
| `healthcare-life-sciences` | Chief Medical Officer · Director of Patient Experience · Clinical Trial Operations Lead · Payer Network Director · HIPAA Privacy Officer |
| `financial-services` | Retail Banking Head · Wealth Advisor · Underwriting Officer · **Compliance/AML Officer** *(deepened: retail-bank, broker-dealer, insurance sub-profiles)* · Insurance Claims Lead |
| `automotive` | Dealer Network Director · Fleet Operations Manager · Connected-Vehicle Product Lead · Aftersales/Service Director · Brand/Loyalty Lead · **OEM Digital & CX VP** · **Recall / TREAD Compliance Officer** |
| `commercial-real-estate` | Facilities Operations Lead · Property Manager · Tenant Experience Lead · **Capital Markets & Acquisitions Director** · **Lease Administration / ASC 842 Specialist** · **Property Controller** |
| `communications` | Network Ops Lead · Service Provisioning Manager · B2B Sales Director · CX/Care Director · Wholesale/Carrier Relations · **BSS/OSS Architect** |
| `consumer-goods` | Trade Promotion Manager · D2C/E-commerce Lead · Field Sales Director · Brand Manager · Supply Chain Lead · **Retailer Buyer / Category Manager** |
| `energy-utilities` | Customer Care Director · Billing/Metering Lead · Renewables Transition PM · Field Operations Manager · Regulatory Affairs · **NERC/CIP Cybersecurity Lead** · **Grid Ops / ISO-RTO Coordinator** · **Renewables Developer VP** |
| `freight-logistics-transportation` | **Network Operations Director** · **Revenue Assurance & Pricing Lead** · **Compliance & Safety Officer** · **Shipper Experience Director** · **Driver & Dispatcher Front-Line** |
| `hotels-hospitality` | Guest Loyalty Lead · Guest Experience Director · **Revenue Management & Pricing Scientist** · **PMS Integration Specialist** · **Hotel Reservations Manager** |
| `manufacturing` | Channel Partner Manager · Warranty Operations Lead · Dealer Network Director · Plant Operations Lead · Aftermarket Service Director · **Supply Chain / S&OP Lead** |
| `media` | Ad Sales Director · Rights & Licensing Manager · Subscriber Experience Lead · Content Acquisition Lead · Audience Analytics Lead · **Editorial / Newsroom Lead** · **DRM / Content Protection Lead** |
| `professional-services` | Resource Manager · Engagement Partner · Billing/Project Accounting Lead · Client Relationship Director · Practice Lead · **Independence & Risk Management Lead** |
| `public-sector` | Constituent Services Director · Licensing & Permits Manager · Emergency Response Coordinator · Case Worker · IT Modernization Director |
| `retail` | Store Operations Director · Loyalty Program Manager · Merchandising Lead · Unified Commerce/OMS Lead · Customer Care Director · **Buying / Planning Lead** · **Loss Prevention Director** |
| `technology` | Recurring Revenue/RevOps Lead · Partner Sales Manager · Customer Success Director · Product-Led Growth Lead · Renewals Manager · **Developer Advocate / DevRel Lead** · **Platform / Marketplace Lead** · **Security / Trust Officer** · **API Platform Architect** |

Files: `personas/industries/<industry-slug>/<role-slug>.md`.

## Default modes — and when to flip

- Generic-Technical + Generic-Stakeholder + Salesforce-Sales + Salesforce-Customer-Technical default to **Stakeholder** (sign-off lens).
- Generic-Customer + Generic-Investor + Salesforce-Customer-Business + Industry-Customer-facing default to **Audience** (reception lens).
- Flip when the purpose differs — e.g., review a marketing page with the Compliance Officer in Stakeholder mode (would she approve the claims?), but a phase plan with the Product Owner in Stakeholder mode and a customer in Audience mode.

## Quick-pick panels — recommend by content type

Use these as the **recommended default** when the user has not named a panel. Always offer to adjust.

| Content under review | Recommended panel (4–5) |
|----------------------|-------------------------|
| **Discovery questions / call prep** | Solution Engineer · Industry Specialist · Champion · Economic Buyer · Business Value Consultant |
| **Pitch deck / executive briefing** | AE · Industry Specialist · Economic Buyer · Champion · Pitch-Narrative Coach |
| **Demo script / walkthrough** | Solution Engineer · Technical Architect · Beta Tester · Accessibility-Dependent User · Business Value Consultant |
| **QBR / customer review (existing customer)** | Customer Success Manager · Champion · Economic Buyer · Industry Specialist · Solution Engineer |
| **Architecture spec / integration plan** | Enterprise Architect · Technical Architect · Security Reviewer · Schema/DB Reviewer · DevOps/SRE |
| **Compliance / InfoSec response** | Compliance & Regulatory Officer · Security Reviewer · InfoSec / Privacy Officer (buyer-side) · Legal / Contracts · CIO |
| **Marketing page / landing** | SMB Buyer · Enterprise Buyer · Security-Anxious Skeptic · Accessibility-Dependent User · Compliance Officer |
| **Industry-specific value prop** | Industry Specialist · 2–3 industry-pack personas · Champion · Business Value Consultant |
| **Vibe-coding / spec-driven build** | Solution Engineer · Technical Architect · AI/Agent Architect · Beta Tester · Customer Success Manager |
| **Everyone** | All available for the active pack(s) — slow, broader-but-shallower; warn the user. |

When the content does not match a row, compose a panel by asking: *who
decides on this? who receives it? what could go wrong with it?* — and
pick one or two personas per answer. The recommender at `/focus-group` Step
4a does this automatically using the active product/industry pack and the
org profile.
