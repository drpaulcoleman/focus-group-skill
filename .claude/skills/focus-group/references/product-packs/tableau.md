# Tableau — Product Pack

Tableau is the analytics and BI platform Salesforce acquired in 2019; it is sold both as a standalone analytics suite and as the visualization layer for Data Cloud and CRM Analytics (formerly Einstein Analytics / Tableau CRM). The primary buyer is typically a Chief Data Officer, VP of Analytics, or a line-of-business analytics leader; the daily users are analysts, data engineers, and an expanding population of business "viewers" who consume dashboards. Tableau's differentiators against Power BI and Looker are its visual analytics depth (VizQL, calculated fields, LOD expressions), its multi-source data connectivity, and a strong analyst community. The typical Salesforce sales motion either lands Tableau Cloud as the analytics layer for an existing Salesforce customer (often via a Data Cloud co-sell) or competes in a pure analytics deal against Power BI where Microsoft pricing is the main pressure. Tableau Pulse is the newer AI-assisted metrics-monitoring experience aimed at non-analyst business users. Embedded Analytics licensing (for ISVs putting Tableau inside their own product) is a distinct motion with its own SKU.

## Grounding prompt (injected into every persona)

Tableau ships in three main shapes: Tableau Cloud (Salesforce-hosted SaaS, the default for new deals), Tableau Server (customer-hosted, still a meaningful install base), and Tableau Desktop (the authoring tool, licensed per Creator). Tableau Cloud is priced per user with Creator / Explorer / Viewer roles; Viewer is the cheapest seat and the one most often under-counted in deals. Tableau Pulse runs only on Tableau Cloud, requires a Tableau Cloud edition that includes it, and depends on well-modeled "published data sources" with defined metrics — it is not magic over raw tables. CRM Analytics is a separate but related product that lives natively inside the Salesforce platform and is licensed through Salesforce SKUs; it is not the same product as Tableau Cloud, even though the long-term direction is convergence. Embedded Analytics has its own licensing (usage-based or per-user) and its own contractual terms; sales reps should not quote standard Tableau Cloud pricing for an embedded use case.

The three most common honest objections: (1) "Power BI is included with our E5 license" — true, and the counter is depth of analysis, governance at scale, and cross-cloud data sources, not list-price comparison; (2) "our analysts already use [Looker / ThoughtSpot / Sigma]" — migrating dashboards is real work and should be scoped honestly; (3) "we do not want another semantic layer" — Tableau works best with a curated published data source or a connection to a governed warehouse model, and pretending it does not need modeling leads to dashboard sprawl. The complexities that get glossed: row-level security at scale requires careful design (entitlement tables, user functions); extract refresh schedules and live-query performance are operational concerns that fall on the customer's data team; and the Data Cloud + Tableau story is real but requires both products and a connector pattern (Zero Copy or query federation) the customer's data team has to operate.

## Platform Facts

This section is the verification source for accuracy-rubric factor 6
(platform-fact verification). Each row is either **filled** or a **TODO
stub**; the rubric scores 0 for any panel claim that lands on a stub
row. See [salesforce-crm-agentforce.md](salesforce-crm-agentforce.md)
for the canonical maintainer note.

| Topic | Fact | Source / verified | Last verified |
|-------|------|-------------------|---------------|
| **Tableau Cloud — Standard Edition pricing (per user / month, USD, billed annually)** | Creator $75, Explorer $42, Viewer $15. Same prices apply to Tableau Server Standard. Every deployment requires at least one Creator license. Pricing changes — re-verify before quoting. | https://www.tableau.com/pricing/teams-orgs | verified 2026-05-22 |
| **Tableau Cloud — Enterprise Edition pricing (per user / month, USD, billed annually)** | Creator $115, Explorer $70, Viewer $35. Same prices apply to Tableau Server Enterprise. Enterprise adds Advanced Management, Data Management, eLearning, and up to 10 sites vs. Standard's 3. | https://www.tableau.com/pricing/teams-orgs | verified 2026-05-22 |
| **Tableau Cloud+ and Tableau+ Bundle** | Cloud+ adds Tableau Agent in Tableau Cloud and Pulse, Premier Success, 50 sites, and Release Preview access on top of Enterprise. Tableau+ Bundle adds Tableau Next agentic-analytics access and 250K Data Cloud Credits on top of Cloud+. Both are "Contact Sales" — no published list price. | https://www.tableau.com/pricing/teams-orgs | verified 2026-05-22 |
| **License role definitions — Creator / Explorer / Viewer** | Viewer: view and interact with dashboards, download summary data, get data-driven alerts. Explorer: explore and edit existing workbooks, download full data, manage users and content. Creator: create new workbooks and data flows, export data, curate and share data sources, get Dashboard Starters, monitor flow performance. | https://www.tableau.com/pricing/teams-orgs | verified 2026-05-22 |
| **Tableau Cloud vs. Tableau Server vs. Tableau Public** | Different deployment models, different security postures, different pricing — confirm which one the deal is for before any commitment. Tableau Cloud is the Salesforce-hosted SaaS default; Tableau Server is customer-hosted (with Standard/Enterprise editions matching Cloud); Tableau Public is the free public-share platform and is not for confidential data. | https://www.tableau.com/pricing/teams-orgs | verified 2026-05-22 |
| **Tableau Pulse — license and availability** | Pulse is included in all Tableau Cloud editions (Standard, Enterprise, Cloud+, Tableau+ Bundle) per the published comparison table; not listed under Tableau Server. Tableau Agent inside Pulse is gated to Cloud+ and Tableau+ Bundle only. Pulse depends on well-modeled published data sources with defined metrics — it is not magic over raw tables. | https://www.tableau.com/pricing/teams-orgs | verified 2026-05-22 |
| **Tableau Agent / AI feature availability by edition** | Tableau Agent in Desktop, Web Authoring, Catalog, and Prep: Cloud+, Tableau+ Bundle, and Tableau Server Enterprise (Server customers must provide their own LLM; currently OpenAI is supported). Tableau Agent in Pulse: Cloud+ and Tableau+ Bundle only. Tableau Agent in Tableau Next / Tableau Next in Slack / Q&A: Tableau+ Bundle (via Tableau Next). Agentforce Tableau (including Concierge): Tableau Next. Tableau Semantics: Tableau+ Bundle, or via Salesforce Foundations in Cloud+. | https://www.tableau.com/pricing/teams-orgs | verified 2026-05-22 |
| **CRM Analytics (formerly Tableau CRM / Einstein Analytics)** | A separate product from Tableau / Tableau Cloud, with a different data model (datasets, dashboards, lenses, SAQL) — do not conflate | https://help.salesforce.com/s/articleView?id=sf.bi_overview.htm | TODO — verify slug |
| **Row-level security at scale** | RLS requires careful design (entitlement tables, user functions, data-source filters); pretending it works "out of the box" leads to leak risk | https://help.tableau.com/current/server/en-us/rls_options_overview.htm | TODO — verify slug |
| **Extract refresh schedules and live-query performance** | Extract refresh has specific scheduling/concurrency limits; live queries push performance into the source database — operational concerns the customer's data team owns | https://help.tableau.com/current/online/en-us/schedule_add.htm | TODO — verify slug |
| **Tableau + Data Cloud (Zero Copy or query federation)** | Real but requires both products and a connector pattern the customer's data team has to operate; do not position as "free" or "automatic" | https://help.tableau.com/current/pro/desktop/en-us/examples_salesforce_datacloud.htm | TODO — verify slug |
| **Embedded analytics — licensing model** | Embedded usage has a separate license model (per-page-view or capacity-based) that differs from internal user licenses | https://www.tableau.com/embedded-analytics | TODO |
| **Migration from Power BI / Looker / ThoughtSpot / Sigma** | Migrating dashboards is real work and should be scoped honestly; semantic-model translation rarely round-trips cleanly | https://www.tableau.com/partners | TODO — pick relevant partner pages |
| **Governance — published data sources and content certification** | Best-practice deployment uses published data sources and content certification; without governance, dashboard sprawl is the typical outcome | https://help.tableau.com/current/server/en-us/governance_overview.htm | TODO — verify slug |

## Recommended persona families

When this pack is active, the persona recommender leans toward:
- salesforce-sales/solution-engineer
- salesforce-sales/technical-architect
- salesforce-customer/technical-decision-maker
- salesforce-customer/end-user-power-user
- generic/executives/chief-data-officer
- generic/technical/schema-db-reviewer
- salesforce-sales/business-value-consultant

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources, suggest these first:
- https://help.tableau.com/current/online/en-us/default.htm
- https://www.tableau.com/learn
- https://www.tableau.com/products/pricing
- https://help.tableau.com/current/pulse/en-us/pulse_intro.htm (verify exact URL before use)
- https://trailhead.salesforce.com/content/learn/trails/tableau-foundations
- https://help.tableau.com/current/api/embedding_api/en-us/index.html
- https://www.tableau.com/trust

## Common sales-conversation pitfalls

1. Conflating Tableau Cloud with CRM Analytics in a discovery call — they are different products with different licensing, and the SE will get caught.
2. Promising Tableau Pulse before confirming the customer has the right Tableau Cloud edition and is willing to invest in published data sources.
3. Under-quoting Viewer seats; most deals balloon when the real population of dashboard consumers gets surfaced.
4. Demoing on a clean sample extract and not addressing the customer's actual data volumes, refresh windows, or governance model.
5. Treating an embedded analytics opportunity as a standard Tableau Cloud deal — the contract, pricing, and security review are materially different.

## When to combine with an industry pack

Strongest fit with `financial-services` (regulatory reporting and wealth-management dashboards), `healthcare-life-sciences` (clinical and operational analytics, with HIPAA-aware deployment), and `retail` (merchandising and store-level analytics where dashboard-consumer volume is high and Viewer-seat math matters).
