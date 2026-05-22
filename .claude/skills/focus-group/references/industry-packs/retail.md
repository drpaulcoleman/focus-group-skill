# Retail — Industry Pack

Retail covers specialty and apparel, big-box and mass, grocery and convenience, luxury, pure-play digital, marketplaces, and the consumer-goods brands operating their own D2C channels. The top pressures right now are margin compression from rising fulfillment and return costs, the unified-commerce expectation (customers treating online, store, app, and call center as one channel even when the retailer's systems aren't), and the loyalty-program reset as third-party-cookie deprecation pushes retailers to invest in first-party data and richer membership programs. Salesforce engages through the core clouds rather than a dedicated Industries Cloud SKU — Commerce Cloud (B2C and B2B), Service Cloud, Marketing Cloud, Data Cloud, and Order Management together cover most retail use cases — with Industries-style accelerators delivered through reference architectures and partner solutions rather than a "Retail Cloud" SKU. The typical buyer shape is a Chief Digital Officer or Chief Customer Officer as economic buyer, a VP of E-commerce or VP of Loyalty as champion, and a Store Operations Director as the often-overlooked stakeholder who decides whether the unified-commerce promise actually reaches the store associate.

## Grounding prompt (injected into every persona)

### Vocabulary

Retail customers speak in terms of channels (online, store, app, call center, marketplaces, wholesale), SKU and UPC, assortment, planogram, allocation, replenishment, markdown, sell-through, GMROI, comparable-store sales (comps), basket size, AOV, conversion rate, return rate, BOPIS / BORIS / curbside / ship-from-store, endless aisle, OMS (order management), POS, ERP (often Oracle Retail or SAP), PIM, DAM, loyalty tiers and benefits, RFM segmentation, and lifetime value. They distinguish between merchants (who buy and plan the assortment), planners (who allocate it), store ops (who run the store), and digital (who run the site and app). A retailer's unified-commerce problem is rarely a CRM problem in isolation — it is an inventory-visibility, OMS, and identity problem that surfaces as a customer-experience symptom.

### Honest objections

The honest objections this industry raises against generic SaaS pitches are: (1) "Our store associates use a hand scanner and have 90 seconds with a customer — show me your store-clienteling story on the device they actually carry, not on a laptop"; (2) "We already have an OMS (Manhattan, IBM Sterling, Salesforce Order Management, or in-house) and a POS — what is the integration story, and which system owns the order of truth?"; (3) "Loyalty is a P&L commitment — our CFO will model the breakage and liability before signing."

### Regulatory frame

Compliance and regulatory realities to keep in mind: PCI DSS v4.0 (with the March 2025 mandatory-requirement cutoff now past — current concern is enforcement maturity and v4 audits in flight; verify against pcisecuritystandards.org at run-time); state privacy laws (CPRA, plus Virginia, Colorado, Connecticut, Utah, and the growing list of 2024-25 enactments) with most including sensitive-data and targeted-advertising provisions relevant to retail; the FTC's enforcement on negative-option marketing and the "click-to-cancel" rule for subscription commerce; ADA web-accessibility expectations (still court-driven in the US, with Title III lawsuits common); EU GDPR and the UK Data Protection Act for international retailers; CPSC and FDA product-safety rules for the relevant categories. The dominant Salesforce footprint is Commerce Cloud + Service Cloud + Marketing Cloud + Data Cloud + Order Management, with Experience Cloud for partner/wholesale portals and MuleSoft to OMS/POS/ERP. Decision-making is fast on digital initiatives (CDO can move quickly) and slow on anything touching the store fleet, where operations and finance jointly gate.

## Customer-type classifier (which sub-type — mass, specialty, grocery, luxury, DTC, department, or convenience?)

Retail spans several structurally different sub-types. The skill should detect which one the customer belongs to and weight the panel accordingly — a grocery panel ≠ a luxury panel ≠ a DTC panel even though all sit under "Retail". Detection signals (case-insensitive substring match on the customer name + the prompt body); first hit wins; ties resolved by asking one clarifying question.

**Mass merchant / big-box** — leads with `store-operations-director`, `unified-commerce-oms-lead`, `merchandising-lead`. Must-include: `buying-planning-lead` (multi-store allocation), `loss-prevention-director` (shrink + ORC exposure).
- Customer-name patterns: Walmart, Target, Costco, Sam's Club, BJ's Wholesale, Meijer, Big Lots, Five Below, Dollar Tree, Dollar General, Family Dollar; substrings: "Supercenter", "Wholesale Club", "Stores Inc".
- Prompt patterns: `big-box`, `mass`, `supercenter`, `club`, `treasure hunt`, `private brand` *(mass context)*, `endcap`, `Black Friday`, `Open to Buy`, `OTB`, `chain-store`.

**Specialty retailer** — leads with `merchandising-lead`, `loyalty-program-manager`, `store-operations-director`. Must-include: `buying-planning-lead` (multi-store allocation), `loss-prevention-director` (especially soft goods + electronics).
- Customer-name patterns: specialty: Best Buy, Home Depot, Lowe's, Bed Bath & Beyond *(historical)*, Container Store, Petco, PetSmart, GameStop, Williams-Sonoma, Crate & Barrel, Pottery Barn, Anthropologie, Urban Outfitters, Sephora, Ulta Beauty, Foot Locker, Dick's Sporting Goods, REI; substrings: "Outfitters", "Outdoor", "Specialty".
- Prompt patterns: `concept store`, `category vertical`, `specialty`, `assortment depth`, `private label`, `experience retail`, `clienteling` *(specialty context)*, `appointment-based`.

**Grocery** — leads with `merchandising-lead` *(fresh sub-profile)*, `loyalty-program-manager`, `unified-commerce-oms-lead`. Must-include: `buying-planning-lead` (multi-store allocation + perishables WOS), `loss-prevention-director` (shrink + EBT fraud).
- Customer-name patterns: Kroger, Albertsons, Ahold Delhaize *(Stop & Shop, Food Lion, Giant)*, Publix, H-E-B, Wegmans, Sprouts, Whole Foods *(Amazon)*, Trader Joe's, Aldi, Lidl, Save-A-Lot, Save Mart, Hannaford, ShopRite *(Wakefern)*; substrings: "Supermarket", "Markets", "Grocery", "Food Stores".
- Prompt patterns: `grocery`, `supermarket`, `perishables`, `fresh`, `produce`, `meat`, `seafood`, `deli`, `bakery`, `floral`, `fuel rewards`, `gas reward`, `weekly circular`, `digital coupon`, `SNAP`, `EBT`.

**Luxury / premium** — leads with `customer-care-director` *(clienteling sub-profile)*, `loyalty-program-manager`, `merchandising-lead`. (Loss Prevention typically lower-priority for luxury unless specifically scoped — high-touch service model dominates.)
- Customer-name patterns: luxury: LVMH brands, Louis Vuitton, Dior, Tiffany, Chanel, Hermès, Gucci, Prada, Burberry, Cartier, Rolex, Coach, Tapestry, Capri Holdings *(Michael Kors, Versace, Jimmy Choo)*, Estée Lauder; substrings: "Luxury", "Couture", "Maison", "Atelier".
- Prompt patterns: `clienteling`, `VIC`, `very important client`, `appointment-based`, `private salon`, `made-to-measure`, `bespoke`, `high jewelry`, `archive`, `consignment`.

**DTC / pure-play digital** — leads with `unified-commerce-oms-lead`, `loyalty-program-manager`, `customer-care-director`. Boundary with consumer-goods pack — see callout below. (Loss Prevention typically lower-priority for DTC unless specifically scoped — single-DC or 3PL model, returns-fraud surfaces via Customer Care.)
- Customer-name patterns: see boundary note below; named DTC: Warby Parker, Allbirds, Glossier, Casper, Away, Wayfair *(some context)*, Stitch Fix, Bombas, Olipop.
- Prompt patterns: `DTC`, `D2C`, `direct-to-consumer`, `pure-play`, `Shopify Plus`, `BigCommerce`, `subscription box`, `replenishment`, `CAC`, `LTV`, `cohort retention`.

**Department store** — leads with `merchandising-lead`, `store-operations-director`, `loyalty-program-manager`. Must-include: `buying-planning-lead` (multi-store allocation), `loss-prevention-director` (shrink + ORC + soft-goods returns fraud).
- Customer-name patterns: Macy's, Bloomingdale's *(Macy's)*, Nordstrom, Saks Fifth Avenue, Neiman Marcus, Bergdorf Goodman *(Neiman Marcus)*, Kohl's, JCPenney, Dillard's, Boscov's; substrings: "& Co" *(department store context)*, "Department Stores".
- Prompt patterns: `department store`, `concession`, `consignment` *(dept store)*, `comp store sales`, `markdown`, `clearance ladder`, `merchandise vendor`, `coop ad`.

**Convenience / QSR-adjacent** — leads with `store-operations-director` *(c-store sub-profile)*, `loyalty-program-manager`. Must-include: `loss-prevention-director` (forecourt + inside-sales shrink, fuel fraud).
- Customer-name patterns: 7-Eleven, Wawa, Sheetz, Casey's, Circle K, Speedway *(7-Eleven)*, Cumberland Farms, Couche-Tard, RaceTrac, QuikTrip, Pilot Flying J, Love's Travel Stops; substrings: "Convenience Stores", "C-Store", "Travel Stops", "Quick Stop".
- Prompt patterns: `c-store`, `convenience`, `forecourt`, `fuel`, `pump`, `inside sales`, `food service` *(c-store context)*, `grab-and-go`, `loyalty fuel discount`.

**Ambiguous signals** (a name matches multiple groups, the customer spans formats, or no name was given) — ask one clarifying question rather than guess: *"Which retail sub-type best fits — mass / big-box, specialty, grocery, luxury / premium, DTC / pure-play digital, department store, or convenience / c-store?"* Then load only that sub-group's lead personas.

**Boundary with consumer-goods pack.** Brand-led companies that make the product and sell through third parties = consumer-goods (Patagonia is the edge case; load both packs with retail primary if vertically integrated). Channel-led companies that curate an assortment from many brands and own the shopper relationship = retail.

## Recommended industry-specific persona files

Each industry pack contributes 3-5 industry-specific personas at `personas/industries/<slug>/<role-slug>.md`. For this pack, the personas are:

- store-operations-director.md — Owns the store fleet, associate workflows, and the in-store technology stack; gatekeeper on any store-touching rollout.
- loyalty-program-manager.md — Owns program design, breakage liability, and tier-benefit economics; partners with Marketing and Finance.
- merchandising-lead.md — Buys and plans the assortment; cares about sell-through, markdown risk, and the merchant view of the customer.
- unified-commerce-oms-lead.md — Owns inventory visibility and order orchestration across channels; the unsung hero of any unified-commerce program.
- customer-care-director.md — Runs the contact center, returns, and post-purchase service; first to feel the pain when OMS or fulfillment breaks.
- buying-planning-lead.md — Allocates and replenishes what the merchants buy; owns store clusters, size curves, WOS, in-stock %, and the ship-from-store dilution problem.
- loss-prevention-director.md — Owns shrink, ORC, internal theft, returns fraud, and store safety; carries the veto on in-store rollouts that create new shrink vectors.

The pack now ships 7 personas. The 5-cap default for panel composition should bias by sub-vertical: mass / big-box, specialty, grocery, and department store should pull `buying-planning-lead` and `loss-prevention-director` into the cap (often dropping `customer-care-director` or `loyalty-program-manager` depending on prompt); luxury and DTC sub-types keep the original five unless shrink or allocation is explicitly scoped.

## Recommended product-pack pairings

When this industry is active, these product packs are most commonly relevant:
- commerce-cloud — B2C and B2B storefronts, including the SFRA / PWA Kit / Composable Storefront paths; load-bearing for most digital programs.
- marketing-cloud — Personalization, journeys, loyalty communications, and post-purchase lifecycle; pairs with Data Cloud for segmentation.
- service-cloud — Contact-center, returns, and clienteling; the post-purchase backbone.
- data-cloud — Identity unification across channels, loyalty data, and the post-cookie story; effectively required for serious unified-commerce work.
- mulesoft — OMS, POS, ERP, and PIM integration; almost always in scope and frequently underestimated in initial sizing.

## URL seed-list (for /download grounding)

- https://www.salesforce.com/products/industries/retail/
- https://nrf.com/ (National Retail Federation; the canonical US retail trade body)
- https://www.pcisecuritystandards.org/ (PCI SSC; PCI DSS v4.0 standards and timelines)
- https://www.ftc.gov/business-guidance/blog (FTC business guidance; subscription, endorsement, and negative-option enforcement)
- https://www.ada.gov/ (DOJ ADA guidance; relevant for web-accessibility expectations)
- https://www.cpsc.gov/Business--Manufacturing (CPSC business guidance for product-safety obligations)

## Common sales-conversation pitfalls in this industry

1. Demoing a beautiful storefront without addressing inventory visibility and order orchestration — the unified-commerce buyer knows the pretty PDP is the easy part.
2. Pitching loyalty as a marketing feature without acknowledging the breakage liability and the CFO conversation — Finance will block a program that doesn't include them in design.
3. Ignoring the store associate — most retail rollouts that look great in the digital demo collapse at the store because the associate has no device, no time, and no incentive.
4. Treating PCI DSS v4.0 as the prior version's checklist — the 2025 requirements are materially different, especially around scripts on payment pages, and the customer's QSA will know.
5. Quoting Commerce Cloud on order-volume tiers without sizing peak (Black Friday, holiday) — the customer's CFO will model peak and the deal will be re-papered.
6. Ignoring **holiday / peak readiness** as the #1 retail recurring conversation September through December — Black Friday, Cyber Week, the gift-card-activation surge, and the post-Christmas holiday returns avalanche shape the operating calendar; a pitch that lands in October and doesn't address peak code-freeze windows, peak contact-center staffing, and BORIS returns capacity will be deferred to Q1 every time. Prompt patterns to watch: `peak`, `holiday`, `Black Friday`, `BFCM`, `Cyber Week`, `Cyber Monday`, `code freeze`, `peak readiness`, `holiday returns`, `returns avalanche`, `January returns`.
7. Treating **returns and reverse logistics** as a service-cost line item rather than an existential margin issue — apparel ecom return rates run 20-30% (industry-reported, verify against current NRF data), and the unit economics of "free returns" are now openly under reset across the industry. Any unified-commerce or loyalty pitch that doesn't address BORIS, returnless-refund policy, fraud-aware return-authorization, and the merchant view of return-driven markdown will lose to a competitor that does. Prompt patterns: `returns`, `reverse logistics`, `BORIS`, `return rate`, `returnless refund`, `return policy`, `return abuse`, `serial returner`, `restocking fee`, `re-commerce`, `resale`.

## Regulatory landscape (one paragraph)

US retailers operate under PCI DSS v4.0 (with the March 2025 mandatory-requirement cutoff now past — current concern is enforcement maturity and v4 audits in flight; verify against pcisecuritystandards.org at run-time), a growing patchwork of state privacy laws (CPRA in California plus enactments in Virginia, Colorado, Connecticut, Utah, and a rolling 2024-25 set), the FTC's enforcement of Section 5 on unfair or deceptive practices (including subscription cancellation and made-in-USA claims), and ADA Title III web-accessibility expectations that remain court-driven in the absence of formal federal regulations. Product-safety obligations sit with the CPSC for general merchandise, the FDA for food, cosmetics, and OTC drugs, and the FTC for advertising claims. International retailers face GDPR, the UK Data Protection Act, the EU Digital Services Act for marketplace operators, and the Omnibus Directive's pricing-transparency rules. Loyalty programs sit at the intersection of consumer-protection, accounting (ASC 606 deferred revenue for points liability), and increasingly privacy law where program data feeds targeted advertising. Personas should treat PCI, accessibility, and state-privacy compliance as non-negotiable design inputs.
