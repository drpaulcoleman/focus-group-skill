# Tableau — Product Pack

Tableau is the analytics and BI platform Salesforce acquired in 2019; it is sold both as a standalone analytics suite and as the visualization layer for Data Cloud and CRM Analytics (formerly Einstein Analytics / Tableau CRM). The primary buyer is typically a Chief Data Officer, VP of Analytics, or a line-of-business analytics leader; the daily users are analysts, data engineers, and an expanding population of business "viewers" who consume dashboards. Tableau's differentiators against Power BI and Looker are its visual analytics depth (VizQL, calculated fields, LOD expressions), its multi-source data connectivity, and a strong analyst community. The typical Salesforce sales motion either lands Tableau Cloud as the analytics layer for an existing Salesforce customer (often via a Data Cloud co-sell) or competes in a pure analytics deal against Power BI where Microsoft pricing is the main pressure. Tableau Pulse is the newer AI-assisted metrics-monitoring experience aimed at non-analyst business users. Embedded Analytics licensing (for ISVs putting Tableau inside their own product) is a distinct motion with its own SKU.

## Grounding prompt (injected into every persona)

Tableau ships in three main shapes: Tableau Cloud (Salesforce-hosted SaaS, the default for new deals), Tableau Server (customer-hosted, still a meaningful install base), and Tableau Desktop (the authoring tool, licensed per Creator). Tableau Cloud is priced per user with Creator / Explorer / Viewer roles; Viewer is the cheapest seat and the one most often under-counted in deals. Tableau Pulse runs only on Tableau Cloud, requires a Tableau Cloud edition that includes it, and depends on well-modeled "published data sources" with defined metrics — it is not magic over raw tables. CRM Analytics is a separate but related product that lives natively inside the Salesforce platform and is licensed through Salesforce SKUs; it is not the same product as Tableau Cloud, even though the long-term direction is convergence. Embedded Analytics has its own licensing (usage-based or per-user) and its own contractual terms; sales reps should not quote standard Tableau Cloud pricing for an embedded use case.

The three most common honest objections: (1) "Power BI is included with our E5 license" — true, and the counter is depth of analysis, governance at scale, and cross-cloud data sources, not list-price comparison; (2) "our analysts already use [Looker / ThoughtSpot / Sigma]" — migrating dashboards is real work and should be scoped honestly; (3) "we do not want another semantic layer" — Tableau works best with a curated published data source or a connection to a governed warehouse model, and pretending it does not need modeling leads to dashboard sprawl. The complexities that get glossed: row-level security at scale requires careful design (entitlement tables, user functions); extract refresh schedules and live-query performance are operational concerns that fall on the customer's data team; and the Data Cloud + Tableau story is real but requires both products and a connector pattern (Zero Copy or query federation) the customer's data team has to operate.

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
