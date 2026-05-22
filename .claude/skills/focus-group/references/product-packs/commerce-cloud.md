# Commerce Cloud — Product Pack

Commerce Cloud is Salesforce's commerce platform, available as Commerce Cloud B2C (the
former Demandware — storefronts, cart, checkout, OCAPI / SCAPI APIs, Page Designer,
Einstein product recommendations), Commerce Cloud B2B (built on the Salesforce Platform
— buyer accounts, contract pricing, complex catalogs, reorder), and Commerce Cloud D2C /
unified-commerce configurations including the newer Salesforce Composable Storefront and
headless patterns. The primary buyer is the Chief Digital Officer, Head of E-commerce,
or CIO; the primary users are merchandisers, site operations, e-commerce developers, and
customer service. Sales teams should lean on three honest differentiators: a hosted,
PCI-scoped storefront platform that has run Black-Friday-scale traffic for years (B2C);
a B2B commerce model that natively understands accounts, contract pricing, and
quote-to-order against Sales Cloud; and the Order Management System (OMS) that ties
storefront orders to fulfillment, returns, and Service Cloud. The typical sales motion
is a storefront replatform conversation (away from Magento / Adobe Commerce, SAP Hybris,
or a custom stack), an OMS modernization, or a unified-commerce play across B2C, B2B,
and store.

## Grounding prompt (injected into every persona)

Commerce Cloud B2C runs on its own multi-tenant SaaS infrastructure (the former
Demandware platform), separate from the core Salesforce Platform — it has its own object
model (catalogs, products, variations, price books, promotions, customers, baskets,
orders), its own developer model (B2C Commerce Cloud Storefront Reference Architecture /
SFRA, ISML templates, scripts, jobs, OCAPI and the newer SCAPI), and its own admin UI
(Business Manager). Commerce Cloud B2B (and D2C) sit on the core Salesforce Platform,
share its data model, sharing model, and governor limits, and behave like other
Salesforce clouds. Order Management is a separate product on the Salesforce Platform
that orchestrates order fulfillment, invoicing, returns, and exchanges across
storefront, store, and call center. Common deployment shapes are: a B2C SFRA storefront
with OMS and Service Cloud; a Composable Storefront (headless, React-based PWA Kit) for
customers who want full control of the front-end; a B2B Commerce site for a manufacturer
or distributor with complex pricing; and a unified-commerce build combining B2C, OMS,
Service Cloud, Data Cloud, and Marketing Cloud.

The honest objections customers raise are: total cost (B2C Commerce is typically priced
as a percentage of Gross Merchandise Value or a comparable consumption metric, and a
high-revenue customer will model the run-rate and push back); platform extensibility
ceilings (B2C Commerce is opinionated, and customers coming from a fully custom stack
will discover constraints on the data model, the request pipeline, and the customization
model); and the OMS integration story (every storefront connects to a real OMS, WMS,
ERP, and tax engine, and that integration is the long pole). The hidden complexities
sales conversations gloss are: B2C Commerce skills (ISML, SFRA, OCAPI, SCAPI, jobs) are
scarce in the labor market and partner work is the norm, not the exception; Composable
Storefront shifts complexity to the customer's front-end team and adds a hosting /
CI/CD conversation; B2B and B2C Commerce have meaningfully different data models and
capabilities — picking the wrong one is a costly mistake; promotions, price books, and
tax behave differently in B2B and B2C and the customer's merchandising lead will want
demos that match their actual scenarios; and PCI scope reduction is a real benefit but
only if the integration genuinely keeps the customer out of scope — a custom
hosted-payment-page implementation can put scope back.

## Recommended persona families

When this pack is active, the persona recommender (Step 4a) leans toward:
- salesforce-sales/solution-engineer
- salesforce-sales/enterprise-architect
- salesforce-sales/industry-specialist
- salesforce-customer/economic-buyer
- salesforce-customer/technical-decision-maker
- salesforce-customer/end-user-power-user
- generic/technical/cloud-architect

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources, suggest these first:
- https://help.salesforce.com/s/articleView?id=cc.b2c_commerce_overview.htm
  (verify before use — B2C Commerce help lives on a separate article tree)
- https://www.salesforce.com/commerce/
- https://architect.salesforce.com/decision-guides
  (pick the commerce / OMS guide currently published)
- https://trailhead.salesforce.com/content/learn/trails/b2c-commerce-developer
  (verify exact trail slug)
- https://developer.salesforce.com/docs/commerce/b2c-commerce/guide/b2c-overview.html
  (verify before use)
- https://developer.salesforce.com/docs/commerce/pwa-kit-managed-runtime/guide/overview.html
  (verify before use — Composable Storefront / PWA Kit)

## Common sales-conversation pitfalls

1. Demoing SFRA without clarifying whether the customer would actually adopt SFRA or
   go Composable — the architecture decision drives staffing, hosting, and roadmap.
2. Quoting on a GMV metric without sizing the realistic GMV growth curve the
   customer's CFO will model — renewal surprises here are deal-killing.
3. Treating OMS as "yes, we have one" without scoping the WMS, ERP, tax-engine, and
   payment-gateway integrations that always come with it.
4. Pitching B2B Commerce against a complex contract-pricing scenario without
   confirming the price-book / entitlement model actually supports it — a wrong answer
   surfaces fast in technical scoping.
5. Glossing the PCI scope conversation — the customer's InfoSec will ask exactly
   where card data flows, and the answer needs to be precise.

## When to combine with an industry pack

Pair with `retail` for any unified-commerce conversation (storefront, store, OMS,
service, loyalty) — Store Operations, Loyalty, and Merchandising personas all weigh in.
Pair with `consumer-goods` for D2C builds where a brand-owned channel sits alongside a
wholesale channel and the brand-protection conversation matters. Pair with
`manufacturing` for B2B Commerce where dealer / distributor accounts, contract pricing,
and reorder workflows dominate.
