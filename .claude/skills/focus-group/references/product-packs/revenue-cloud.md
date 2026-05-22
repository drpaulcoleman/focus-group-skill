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
| **Legacy CPQ vs. Revenue Cloud Advanced (now "Agentforce Revenue Management")** | The current generation Revenue Cloud, branded "Agentforce Revenue Management" in current Salesforce help, is positioned as: "Manage your entire revenue lifecycle, from initial sales to recurring subscriptions, on one trusted platform"; "Available in: Enterprise, Unlimited, and Developer editions" — different generation from Steelbrick-derived legacy CPQ; treat migration as a project, not an upgrade | https://help.salesforce.com/s/articleView?id=ind.revenue_lifecycle_management.htm&type=5 | verified 2026-05-22 |
| **CPQ — bundle, configuration, and price-rule engine** | Re-attempted with real Chrome 2026-05-22 against `sf.cpq_overview.htm`, `sf.cpq_intro.htm`, `sales.cpq_overview.htm`, `sales.cpq_amendments.htm`. Help.salesforce.com returns either a 461KB SPA shell (generic title, body not rendered in headless capture) or static-fetch stubs of ~200 bytes — slug-validity cannot be distinguished from output. Canonical CPQ-overview slug remains unconfirmed; verify in a real browser. | (slug not confirmed via headless harvest) | TODO — help.salesforce.com SPA does not render article body in capture; resolve slug via in-browser navigation |
| **Amendments, co-terming, ramps, renewals** | Re-attempted with real Chrome 2026-05-22 against `sales.cpq_amendments.htm` and adjacent slugs; help.salesforce.com SPA shell returned (body not rendered) or static-fallback stub. Canonical help slug remains unconfirmed via headless harvest. This is the topic where CPQ projects most often slip — any panel claim should be sourced from current CPQ release notes or the Revenue Cloud Advanced lifecycle docs opened in a real browser. | (slug not confirmed via headless harvest) | TODO — help SPA does not render body in capture; resolve slug via in-browser navigation |
| **Revenue recognition — ASC 606 / IFRS 15** | Re-attempted with real Chrome 2026-05-22; help.salesforce.com SPA shell does not render article body in headless capture, so slug-vs-404 cannot be distinguished from output. Salesforce Billing overview (`sales.blng_overview.htm`) and "Bookings, Billings, Cash, and Revenue" review (`sales.blng_revenue_process_review_intro.htm`) confirm Billing has a Revenue Recognition Reporting concept; a single canonical "ASC 606 / IFRS 15" slug remains unconfirmed via headless harvest. | (slug not confirmed via headless harvest) | TODO — leave standard-naming claim unsourced until article is opened in a real browser |
| **Billing — built-in vs. ERP integration** | Salesforce Billing (the legacy Salesforce Billing managed package on the Salesforce Platform) has documented sub-topics including "Revenue Recognition Reporting" and "ERP Integration"; the "Bookings, Billings, Cash, and Revenue" review confirms Billing tracks each of these as distinct stages — coexistence with a customer's existing ERP-based billing is a real architecture conversation, not a default replace | https://help.salesforce.com/s/articleView?id=sales.blng_overview.htm&type=5 | verified 2026-05-22 |
| **Subscription Management** | Per Salesforce help: "Subscription Management continues to be available for existing customers, however, there is no longer any new feature development. For a more comprehensive and robust solution, we recommend exploring Revenue Cloud." — do not position Subscription Management as the strategic path for new customers | https://help.salesforce.com/s/articleView?id=sales.subscription_management.htm&type=5 | verified 2026-05-22 |
| **Partner ecosystem** | Implementation quality varies sharply by partner and is the single largest predictor of deal success — surface this honestly. Partner directory live at AppExchange consultant search; specific partner-tier pages depend on the customer's region and segment | https://appexchange.salesforce.com/consulting | TODO — pick region- and segment-specific partner pages per opportunity |
| **API limits — quote and order operations** | Re-attempted with real Chrome 2026-05-22; legacy CPQ developer-guide URLs continue to return LWR doc shells without article body. Quote/order API limits and bulk-operation patterns must still be verified against the current `developer.salesforce.com` Revenue Cloud / CPQ developer guides opened in a real browser before any panel claim about throttles or bulk patterns. | (canonical limits page not confirmed via headless harvest) | TODO — limits-page body not rendered in capture; resolve via in-browser navigation |
| **Data model — Order, OrderItem, Asset, Subscription** | Re-attempted with real Chrome 2026-05-22; help.salesforce.com SPA shell does not render body, so candidate slugs (`sf.order_management.htm`, `sales.order_management.htm`, `commerce.order_management.htm`) cannot be tested via headless harvest. Salesforce Order Management is a distinct product per the marketing page; canonical help-doc slug for the Order/OrderItem/Asset/Subscription lifecycle data model remains unconfirmed via this harvester — verify against the current Salesforce help / object reference in a real browser. | (slug not confirmed via headless harvest) | TODO — body not rendered in capture; resolve via in-browser navigation |

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
