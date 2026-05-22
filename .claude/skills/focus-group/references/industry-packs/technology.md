# Technology — Industry Pack

Technology (often called "high-tech" or "tech" in Salesforce vertical taxonomy) covers software companies (enterprise SaaS, devtools, security, infrastructure), hardware and semiconductors, cloud and platform providers, networking and telecom-adjacent vendors, and the marketplaces and channel ecosystems that surround them. The top pressures right now are the post-2022 return to disciplined growth (efficient ARR, net-revenue-retention defense, and "rule of 40" scrutiny), the GTM transformation driven by product-led growth and consumption-based pricing replacing seat-based SaaS, and the AI-platform shift (every tech buyer is simultaneously building AI features and buying AI infrastructure). Salesforce engages through the core clouds rather than a dedicated Industries Cloud SKU — Sales Cloud, Revenue Cloud (CPQ, Billing, Subscription Management), Service Cloud, Marketing Cloud Account Engagement (Pardot), Data Cloud, Slack, and increasingly Agentforce — with Industries patterns delivered through reference architectures rather than a "Tech Cloud" SKU. The typical buyer shape is a CRO or VP RevOps as economic buyer, a Director of RevOps or Director of Renewals as champion, and a Sales Engineering or Solutions Architecture lead as the technical reviewer who can be unusually opinionated because they sell similar products themselves.

## Grounding prompt (injected into every persona)

### Vocabulary

Technology customers speak in terms of CAC, payback, magic number, rule of 40, ACV, TCV, MRR, expansion, contraction, churn, logo retention, gross margin, consumption / usage-based pricing, seats, ramp deals, PLG (product-led growth), PLS (product-led sales), forecast call, commit, upside, best case, pipeline coverage, MEDDPICC / MEDDIC, ICP, design partners, lighthouse customers, and developer-led adoption. Depending on archetype, the buyer's primary metrics shift: SaaS = ARR/NRR; PLG = activation→PQL→expansion; IaaS = committed spend + burndown; AI-platform = tokens/inference cost/$ per outcome; hardware = bookings/backlog/attach rate. They distinguish sharply between new-logo sales, expansion (account-management), and renewals (often a separate org). They are themselves SaaS buyers and will judge a vendor by the vendor's own GTM craft — if the Salesforce rep's discovery, MEDDPICC, and follow-up look sloppy, the prospect will assume the product reflects that.

### Honest objections — enterprise SaaS (sales-led)

The honest objections this industry raises against generic SaaS pitches are: (1) "We sell what you sell — show me discovery quality, not slides; we will see through a generic pitch faster than your average prospect"; (2) "Our pricing is moving from seats to consumption — does your Revenue Cloud / billing stack actually handle that, including mid-cycle changes, overages, and ramp deals, without finance running shadow spreadsheets?"; (3) "We already run on Salesforce — what is your migration / coexistence story with our existing CPQ (often Salesforce CPQ, Conga, DealHub, or in-house) and our existing data model?"

### Honest objections — PLG / product-led SaaS

The free-to-paid funnel is sacred (any sales motion that disrupts it for a single account erodes the model); product-qualified-lead routing is the structural bet (handoff to AE happens on signal, not on quota); FOSS-vs-paid feature gating is a constant trust-erosion risk.

### Honest objections — developer tools / API-first / open-source-core

DevRel community-trust is the moat (a single tone-deaf interaction at a conference is a multi-quarter setback); documentation quality IS the product; pricing-page changes get screenshot and discussed publicly in 4 hours.

### Honest objections — cybersecurity

Channel-partner relationships are 60%+ of revenue and absolutely sacred (no DTC pivot will succeed without their consent); FedRAMP / FedRAMP-High / IL5 boundary is a permanent architectural commitment; the bug-bounty + responsible-disclosure posture is part of the brand.

### Honest objections — IaaS / hyperscaler

Co-sell economics with hyperscaler partner channels govern everything (their seller comp drives every meeting); marketplace listing is a strategic asset not a checkbox; the consumption-meter accuracy IS the trust contract.

### Honest objections — hardware / semiconductor / OEM

Design wins are 18-36 month cycles (any tool that doesn't model the long sales cycle is unusable); BOM cost-down is permanent (margin compression is the structural reality); supply-chain disruption planning is operationally first-class.

### Honest objections — AI platform / AI product vendor

Model-update breaks the customer-meter (cannot ship without explicit guardrails); training-data provenance is the legal-exposure pillar (lawsuits in flight); the safety-vs-capability tradeoff has board-level visibility; per-token pricing volatility is a permanent customer education burden.

### Regulatory frame

Compliance and regulatory realities to keep in mind: SOC 2 Type II is table-stakes (most tech vendors maintain it themselves and expect it from suppliers); ISO 27001 and ISO 27701 increasingly required by enterprise customers; revenue-recognition under ASC 606 / IFRS 15 (especially the SSP allocation and the contract-modification rules that bite hardest in usage-based and ramp deals); SOX for public companies; GDPR, UK DPA, and the rolling US state privacy laws; the EU AI Act and the patchwork of US state AI governance for any AI-feature vendor; export controls (EAR) for security and AI products. The dominant Salesforce footprint is Sales Cloud + Revenue Cloud + Service Cloud + MCAE (Pardot) + Slack + Data Cloud, with Agentforce frequently in evaluation. Decision-making is fast for net-new tools (CRO + RevOps can decide), slow for anything that touches the system of record for billing or revenue recognition (CFO and Controller must approve).

## Customer-type classifier (which sub-type — SaaS, PLG, devtools, security, IaaS, hardware, or AI platform?)

Technology spans several structurally different sub-types. The skill should detect which one the customer belongs to and weight the panel accordingly — a PLG panel ≠ an enterprise-SaaS panel ≠ a hyperscaler panel ≠ a fab-driven semiconductor panel, even though all sit under "Tech". Detection signals (case-insensitive substring match on the customer name + the prompt body):

**Enterprise SaaS (sales-led)** — leads with `recurring-revenue-revops-lead`, `renewals-manager`, `customer-success-director`. High-priority add: `security-trust-officer` (trust as a sales-velocity multiplier on enterprise deals). Skip: `developer-advocate-devrel-lead` (sales-led, not community-led).
- Customer-name patterns: `Salesforce`, `Workday`, `ServiceNow`, `Adobe` *(enterprise)*, `Oracle`, `SAP`, `Microsoft` *(enterprise SKUs)*, `Atlassian`, `Splunk`, `Veeva`, `Workiva`, `Coupa`, `Anaplan`, `Smartsheet`; substrings: `Software`, `Systems` *(software)*, `Enterprise`.
- Prompt patterns: `ARR`, `NRR`, `GRR`, `enterprise sales`, `MEDDPICC`, `co-sell`, `procurement-led`, `multi-year`, `committed`.

**PLG / product-led SaaS** — leads with `product-led-growth-lead`, `recurring-revenue-revops-lead`. High-priority add: `security-trust-officer` (trust accelerates self-serve-to-enterprise conversion). Nice-to-have: `developer-advocate-devrel-lead` (when the PLG motion has a developer-tools edge).
- Customer-name patterns: `Slack` *(historical PLG)*, `Notion`, `Figma`, `Canva`, `Calendly`, `Loom`, `Linear`, `Airtable`, `Monday.com`, `ClickUp`, `Asana`, `Zoom` *(PLG era)*, `Dropbox`, `Box`; substrings: `.io`, `.so` *(modern SaaS)*.
- Prompt patterns: `PLG`, `freemium`, `free tier`, `trial-to-paid`, `self-serve`, `bottoms-up`, `viral coefficient`, `K-factor`, `activation`, `PQL`, `product-qualified lead`.

**Developer tools / API-first / open-source-core** — leads with `developer-advocate-devrel-lead` (must-include), `product-led-growth-lead`, `partner-sales-manager` *(ecosystem sub-profile)*. Must-include also: `platform-marketplace-lead` when the customer runs its own marketplace (Snowflake, MongoDB Atlas integrations, Stripe Apps, Atlassian Marketplace, etc.).
- Customer-name patterns: `Vercel`, `Supabase`, `Netlify`, `Cloudflare`, `MongoDB`, `Snowflake` *(data developer)*, `Databricks`, `HashiCorp`, `GitLab`, `GitHub` *(Microsoft)*, `Postman`, `Stripe` *(API)*, `Twilio`, `SendGrid`, `Auth0` *(Okta)*, `Fastly`; substrings: `Labs`, `.dev`, `Tech` *(dev tools)*.
- Prompt patterns: `DevRel`, `developer advocate`, `developer experience`, `DX`, `community`, `GitHub stars`, `RFC`, `SDK`, `API`, `CLI`, `open source`, `core open source`, `BSL`, `business source license`.

**Cybersecurity** — leads with `security-trust-officer` (must-include — obviously), `partner-sales-manager` *(channel sub-profile)*, `recurring-revenue-revops-lead`.
- Customer-name patterns: `CrowdStrike`, `Palo Alto Networks`, `Zscaler`, `Okta`, `Fortinet`, `Splunk` *(security context)*, `SentinelOne`, `Cloudflare` *(security context)*, `Cisco` *(security divisions)*, `Check Point`, `Trend Micro`, `Rapid7`, `Tenable`, `Qualys`, `Wiz`, `Snyk`, `Lacework`; substrings: `Security`, `Cyber`, `Defense` *(cyber context)*.
- Prompt patterns: `SOC`, `EDR`, `XDR`, `SIEM`, `SOAR`, `SASE`, `ZTNA`, `zero trust`, `CTI`, `threat intel`, `MDR`, `MSSP`, `compliance` *(security)*, `pen test`, `red team`, `purple team`.

**IaaS / hyperscaler / infrastructure** — leads with `partner-sales-manager`, `recurring-revenue-revops-lead`, `platform-marketplace-lead` (must-include — every hyperscaler runs a marketplace and ISV economics drive the GTM motion). Nice-to-have: `developer-advocate-devrel-lead` (hyperscalers have large DevRel orgs).
- Customer-name patterns: `AWS`, `Amazon Web Services`, `Azure`, `GCP`, `Google Cloud`, `Oracle Cloud Infrastructure`, `OCI`, `IBM Cloud`, `DigitalOcean`, `Linode` *(Akamai)*, `Vultr`, `Hetzner`, `Equinix` *(colocation/edge)*; substrings: `Cloud` *(IaaS)*, `Infrastructure`.
- Prompt patterns: `IaaS`, `committed spend`, `EDP`, `enterprise discount program`, `PPA` *(hyperscaler)*, `region`, `availability zone`, `AZ`, `Compute`, `Object Storage`, `egress`, `co-sell` *(hyperscaler context)*, `ISV partner`, `Marketplace private offer`, `MPO`.

**Hardware / semiconductor / OEM** — leads with `partner-sales-manager`, `customer-success-director` *(hardware sub-profile when added)*.
- Customer-name patterns: `NVIDIA`, `AMD`, `Intel`, `Qualcomm`, `Broadcom`, `Marvell`, `TSMC`, `ASML`, `Applied Materials`, `KLA`, `Lam Research`, `Texas Instruments`, `Analog Devices`, `ARM`, `Dell` *(hardware)*, `HPE`, `Lenovo`, `Apple` *(hardware context)*; substrings: `Semiconductor`, `Silicon`, `Microelectronics`, `Optics`.
- Prompt patterns: `fab`, `wafer`, `node` *(process node)*, `ASIC`, `FPGA`, `tape-out`, `attach rate`, `backlog`, `bookings`, `bookings-to-billings`, `book-to-bill`, `supply allocation`, `OEM`, `ODM`.

**AI platform / AI-product vendor** — leads with `developer-advocate-devrel-lead` (must-include — AI-platform adoption is community-and-credibility-led), `security-trust-officer` (must-include — Anthropic/OpenAI-class trust posture is load-bearing for enterprise adoption), `product-led-growth-lead`, `recurring-revenue-revops-lead` *(consumption-pricing sub-profile)*.
- Customer-name patterns: `Anthropic`, `OpenAI`, `Cohere`, `Mistral`, `Stability AI`, `Hugging Face`, `Replicate`, `Together AI`, `Groq`, `Cerebras`, `Lambda Labs`, `Together Compute`, `Modal`, `Perplexity`, `Character.AI`, `Inflection AI`; substrings: `.ai`, `Labs` *(AI context)*, `Intelligence` *(AI context)*.
- Prompt patterns: `LLM`, `foundation model`, `inference`, `token`, `per-token`, `context window`, `fine-tuning`, `RAG`, `retrieval-augmented generation`, `vector database`, `RLHF`, `safety alignment`, `EU AI Act`, `Responsible AI`, `model card`, `eval`, `red teaming`.

**Ambiguous signals** (e.g., a name matches multiple groups like `Microsoft` straddling enterprise SaaS, IaaS, and devtools; or `Snowflake` straddling devtools and enterprise SaaS; or no name was given) — ask one clarifying question rather than guess: *"Is this customer primarily enterprise SaaS, PLG / product-led, developer-tools / API-first, cybersecurity, IaaS / hyperscaler, hardware / semiconductor, or an AI platform vendor?"* Then load only that sub-group's personas.

**Meta-irony note.** The customer's own Salesforce admin/architect is in the room — they will read your deck as a peer review. Treat the Salesforce footprint conversation as code review, not as discovery.

## Recommended industry-specific persona files

Each industry pack contributes 3-5 industry-specific personas at `personas/industries/<slug>/<role-slug>.md`. For this pack, the personas are:

- recurring-revenue-revops-lead.md — Owns the ARR/NRR/GRR motion, forecast hygiene, and the CRM-to-billing data flow.
- partner-sales-manager.md — Manages the indirect channel (resellers, MSPs, GSIs); cares about deal registration, MDF, and partner enablement.
- customer-success-director.md — Owns the post-sale relationship, health scoring, and the renewal forecast; the early-warning system for churn.
- product-led-growth-lead.md — Owns the PLG/PLS motion, product-qualified leads, and the self-serve-to-sales-assisted handoff.
- renewals-manager.md — Owns the renewal P&L; the unsung gatekeeper on multi-year, ramp, and consumption deal structure.
- developer-advocate-devrel-lead.md — Owns the developer-experience relationship; carries the "will real developers actually use this?" filter no marketing persona can fake.
- platform-marketplace-lead.md — Runs the customer's own marketplace/platform-extensibility surface; owns ISV economics, take-rate, and ecosystem-flywheel decisions.
- security-trust-officer.md — Hybrid CISO and public-facing trust marketer; owns Trust Center, SOC 2 / FedRAMP / VSQ motion as a sales-velocity multiplier.

**Pack composition note.** This pack now ships 8 personas — the panel-composer should bias by archetype rather than load all 8 every time. For any given customer, expect 4-5 of the 8 to fire as leads (e.g., a cybersecurity vendor draws `security-trust-officer` + `partner-sales-manager` + `recurring-revenue-revops-lead` + `renewals-manager`; a dev-tools vendor draws `developer-advocate-devrel-lead` + `product-led-growth-lead` + `platform-marketplace-lead` + `recurring-revenue-revops-lead`). Use the customer-type classifier above to drive selection.

## Recommended product-pack pairings

When this industry is active, these product packs are most commonly relevant. The right pairing varies sharply by sub-vertical — load only the pairing for the detected customer type.

### For enterprise SaaS (sales-led)

- sales-cloud — Pipeline, forecasting, and account planning; the foundation for any tech-vendor GTM.
- revenue-cloud — CPQ, Billing, and Subscription Management for ramp, consumption, and usage-based deals; load-bearing for any modern SaaS pricing model.
- service-cloud — Customer support, technical case management, and the entitlement model behind paid-support tiers.
- slack — Deal rooms, customer-success channels, and partner collaboration; pairs naturally with tech-vendor workflows.
- data-cloud — Product-usage telemetry unified with CRM for PLG/PLS scoring and renewal risk; the post-cookie identity story for marketing.

### For PLG / product-led SaaS

Marketing Cloud (lifecycle + activation), Data Cloud (product-usage signals), Service Cloud (self-serve + escalation), Sales Cloud (PQL handoff workflow). Revenue Cloud OPTIONAL — many PLG companies bypass CPQ entirely.

### For dev tools / API-first / open-source-core

Marketing Cloud (DevRel + community programs), Service Cloud (support + community moderation), Data Cloud (usage + repo-star + community-engagement signals), Sales Cloud (enterprise tier). LIGHT on Revenue Cloud — most monetization is self-serve.

### For cybersecurity

Sales Cloud + Experience Cloud (PRM for channel), Revenue Cloud (multi-tier SKUs + government contracts), Service Cloud (incident-response + customer-success), Slack (incident-collab), Data Cloud (threat-intelligence aggregation).

### For IaaS / hyperscaler

Sales Cloud (co-sell tracking), Revenue Cloud (committed-spend + consumption complexity), Experience Cloud (developer + partner portal), Data Cloud (consumption telemetry), MuleSoft.

### For hardware / semiconductor / OEM

Sales Cloud (design-win pipeline + long-cycle opportunities), Revenue Cloud (complex global-pricing + channel rebates), Service Cloud (RMA + support), Manufacturing Cloud (Sales Agreements), Data Cloud.

### For AI platform / AI product vendor

Sales Cloud (enterprise sales-led), Revenue Cloud (consumption-pricing + per-token + per-outcome), Data Cloud (model-usage signals), Service Cloud (developer support + incident response), Experience Cloud (developer portal + Trust Center).

## URL seed-list (for /download grounding)

- https://www.salesforce.com/solutions/industries/technology/
- https://www.saastr.com/ (community resource for SaaS GTM benchmarks)
- https://www.bessemervp.com/cloud-index (Bessemer Cloud Index; valuation and operating metrics)
- https://www.bvp.com/atlas/state-of-the-cloud-2024 (Bessemer State of the Cloud)
- https://www.chartmogul.com/blog/ (ChartMogul SaaS metrics — benchmarks for ARR, NRR, churn, expansion)
- https://www.sec.gov/structureddata/announcement (SEC; relevant for public-company SaaS XBRL and revenue disclosure)
- https://www.ftc.gov/legal-library/browse/rules/negative-option-rule (FTC click-to-cancel rule — direct relevance to PLG / self-serve cancellation flows)
- https://eur-lex.europa.eu/eli/reg/2024/1689/oj (official EU AI Act on Eur-Lex — Regulation (EU) 2024/1689)
- https://artificialintelligenceact.eu/ (independent tracker of EU AI Act; verify against the official Eur-Lex text)

## Common sales-conversation pitfalls in this industry

1. Pitching with a generic SaaS narrative to a tech buyer who runs the same playbook — the buyer evaluates the rep's craft as part of the product evaluation, and a weak discovery loses the deal.
2. Demoing CPQ without honestly addressing usage-based, ramp, and mid-cycle changes — the RevOps lead will probe these and a vague answer ends the conversation.
3. Treating Salesforce CPQ vs Revenue Cloud Advanced as a footnote — the product transition matters for any customer on legacy CPQ, and the migration story has to be precise.
4. Selling Agentforce as a productivity feature to a tech buyer who is themselves building AI agents — the conversation has to be peer-to-peer about platform trade-offs, not feature-list bingo.
5. Ignoring the renewals motion and the renewal-manager persona — most expansion deals are won or lost at renewal, and a pitch that treats renewals as automatic loses the CRO.
6. Pitching a consumption-pricing customer with a CPQ migration story that doesn't explicitly handle mid-period meter resets, overage true-ups, and credit-burndown — the RevOps lead will probe; a hand-wave ends it.

### The AI-vendor lens (when the customer is an AI platform or AI-product vendor)

AI vendors evaluate every pitch through a sharper compliance and pricing lens than other tech sub-types. The **EU AI Act** phases in obligations through 2025-27 (prohibited-AI list since Feb 2025; general-purpose AI / GPAI obligations from Aug 2025; high-risk system obligations from Aug 2026; legacy GPAI compliance deadline Aug 2027) and any Salesforce AI-integration story has to map to where the customer's own products sit in that risk tier. Pricing is **per-token vs per-outcome**: per-token aligns vendor and customer on raw consumption but creates the "model-update-breaks-the-meter" problem where a new model version changes token efficiency overnight and the renewal forecast craters; per-outcome shifts the risk to the vendor but is much harder to price in CPQ. Expect explicit questions about whether customer-submitted data ever enters training sets, opt-out defaults, retention windows, and contractual indemnification for training-data IP claims — Sales Cloud / Revenue Cloud demos that don't surface these terms upfront read as evasive to an AI-vendor buyer.

## Regulatory landscape (one paragraph)

Technology vendors face a layered compliance environment shaped more by customer expectations than by direct regulation. SOC 2 Type II is the de facto baseline; ISO 27001 and ISO 27701 are increasingly demanded by enterprise and EU customers. Revenue recognition under ASC 606 / IFRS 15 is the operationally hardest area, especially for usage-based pricing, ramp deals, and contract modifications; SOX adds internal-controls obligations for public companies. Privacy is governed by GDPR, the UK DPA, and the rolling US state privacy laws (CPRA, Virginia, Colorado, Connecticut, Utah, and the 2024-25 enactments), with sector-specific overlays (HIPAA, GLBA, FERPA) when the vendor sells into regulated verticals. AI-feature vendors face the EU AI Act (with risk-tier obligations phasing in through 2025-27), the NIST AI RMF as a de facto US framework, and a growing list of state AI governance laws (Colorado's SB 24-205, the New York City AEDT rule, and others). Export controls (EAR) apply to security, cryptography, and certain AI products. Personas should treat SOC 2, ASC 606, and the AI-act phase-in as practical design constraints, not as legal-team boilerplate.
