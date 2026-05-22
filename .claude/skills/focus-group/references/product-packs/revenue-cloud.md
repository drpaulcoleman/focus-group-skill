# Salesforce Revenue Cloud — Product Pack

Salesforce Revenue Cloud is the consolidated suite that brings configure-price-quote (CPQ), billing, and subscription management together as the system that runs the quote-to-cash process on the Salesforce platform. The current generation is built around a platform-native data model and is often called "Revenue Cloud Advanced" in customer conversations to distinguish it from the legacy CPQ (formerly Steelbrick) and legacy Billing products that remain in production. The primary buyer is usually a CRO, CFO, or VP of RevOps; the daily users are sales reps quoting deals, deal-desk reviewers, revenue operations, billing operations, and finance. Revenue Cloud's differentiators against Conga CPQ, DealHub, PROS, and Zuora are its native Salesforce platform integration, the unified data model across quoting and billing, and the depth of configuration for complex B2B commerce. The typical Salesforce sales motion attaches Revenue Cloud to a Sales Cloud customer whose quote-to-cash process is fragmented across CPQ, ERP billing, and spreadsheets.

## Grounding prompt (injected into every persona)

Revenue Cloud today is in a multi-product reality: the legacy CPQ product (originally Steelbrick) and legacy Billing product are in maintenance and still widely deployed; the newer Revenue Cloud Advanced (platform-native quoting, pricing, contracts, and billing on a unified data model) is the strategic direction. New deals are increasingly steered to the new platform, but existing customers on legacy CPQ have a real migration path conversation rather than an upgrade. Pricing is per user and per usage component depending on the SKU mix; billing volume typically affects pricing. Common deployment shapes: CPQ-only (the most common land), CPQ plus contract lifecycle (often with a partner CLM), and the full quote-to-cash including billing and revenue recognition where finance is the sponsor. Integrations with ERP (NetSuite, SAP, Oracle, Workday) for general ledger, tax, and revenue recognition are nearly always in scope and nearly always under-estimated.

The three most common honest objections: (1) "our CPQ implementation will be a multi-quarter project" — almost always true for complex B2B pricing, and the realistic answer is a phased rollout starting with the highest-volume product line, not a big-bang go-live; (2) "we already have a billing system / ERP that handles billing" — common, and Revenue Cloud Billing is not always the right call when a working ERP billing system exists; (3) "the partner ecosystem is uneven" — implementation quality varies sharply by partner and is the single largest predictor of deal success. The complexities that get glossed: amendments, co-terming, ramps, and renewals are where CPQ projects actually live or die; revenue recognition under ASC 606 / IFRS 15 is a finance-led design conversation that the AE cannot wing; and the legacy-CPQ-to-Revenue-Cloud-Advanced migration is a meaningful project for existing customers that should be scoped honestly rather than positioned as an upgrade.

## Platform Facts

This section is the verification source for accuracy-rubric factor 6
(platform-fact verification). Each row is either **filled** or a **TODO
stub**; the rubric scores 0 for any panel claim that lands on a stub
row. See [salesforce-crm-agentforce.md](salesforce-crm-agentforce.md)
for the canonical maintainer note.

| Topic | Fact | Source / verified | Last verified |
|-------|------|-------------------|---------------|
| **Legacy CPQ vs. Revenue Cloud Advanced** | These are different product generations with different data models, different APIs, and different customization patterns; treat the migration as a project, not an upgrade | salesforce.com revenue cloud | TODO |
| **CPQ — bundle, configuration, and price-rule engine** | Pricing logic lives in CPQ-specific objects (Quote, QuoteLine, ProductOption, PriceRule, ProductRule); Apex extension is supported but most logic should be declarative | help.salesforce.com CPQ | TODO |
| **Amendments, co-terming, ramps, renewals** | These are where CPQ projects actually live or die; verify the customer's specific scenarios before scoping a phased rollout | help.salesforce.com CPQ amendments | TODO |
| **Revenue recognition — ASC 606 / IFRS 15** | Revenue Cloud Billing supports ASC 606 / IFRS 15 patterns but configuration is finance-led; the AE cannot wing this — bring a finance-savvy SE or partner | help.salesforce.com Revenue Cloud Billing | TODO |
| **Billing — built-in vs. ERP integration** | Revenue Cloud Billing is not always the right call when a working ERP billing system exists; coexistence is common | salesforce.com revenue cloud | TODO |
| **Subscription Management** | Self-service subscription management has specific patterns; verify currently shipping capabilities before promising consumer-grade self-service | salesforce.com subscription management | TODO |
| **Partner ecosystem** | Implementation quality varies sharply by partner and is the single largest predictor of deal success — surface this honestly | salesforce.com partners | TODO |
| **API limits — quote and order operations** | TODO — verify current limits for quote/order API calls; bulk quote operations have specific patterns | developer.salesforce.com revenue cloud APIs | TODO |
| **Data model — Order, OrderItem, Asset, Subscription** | The standard order/asset/subscription data model has specific lifecycle states and trigger behavior — verify before scoping custom automation | help.salesforce.com order | TODO |

## Recommended persona families

When this pack is active, the persona recommender leans toward:
- salesforce-sales/solution-engineer
- salesforce-sales/business-value-consultant
- salesforce-sales/enterprise-architect
- salesforce-customer/economic-buyer
- generic/executives/cfo
- generic/executives/cro
- salesforce-customer/legal-contracts

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources, suggest these first:
- https://help.salesforce.com/s/articleView?id=sf.revenue_cloud.htm (verify exact URL before use)
- https://www.salesforce.com/products/revenue-cloud/
- https://trailhead.salesforce.com/content/learn/trails/revenue-cloud
- https://developer.salesforce.com/docs/atlas.en-us.cpq_api_dev.meta/cpq_api_dev/ (legacy CPQ; verify before use)
- https://help.salesforce.com/s/articleView?id=sf.cpq_intro.htm (verify exact URL before use)
- https://www.salesforce.com/products/revenue-cloud/pricing/

## Common sales-conversation pitfalls

1. Selling Revenue Cloud Advanced without making clear which capabilities are on the new platform-native model versus the legacy CPQ/Billing products — the SE and a sharp procurement reviewer will both catch this.
2. Demoing pristine new-deal quoting and skipping amendments, ramps, co-terms, and renewals — the actual lifecycle is where customers live.
3. Promising tight ERP integration without scoping the tax engine, GL mapping, revenue-recognition rules, and dunning workflows.
4. Under-scoping partner implementation effort; complex CPQ rollouts routinely run 2-4 quarters and the partner choice drives outcomes.
5. Glossing the legacy-to-Advanced migration for existing CPQ customers as a "platform refresh" rather than a real re-implementation conversation.

## When to combine with an industry pack

Strongest fit with `technology` (subscription, usage-based, and recurring-revenue motions are the canonical Revenue Cloud story), `manufacturing` (complex configure-to-order quoting tied to dealer networks and channel pricing), and `communications` (multi-product bundles, term ramps, and high-volume billing where the full quote-to-cash story matters).
