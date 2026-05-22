# Consumer Goods — Industry Pack

The consumer packaged goods (CPG) industry covers food and beverage, household and personal care, apparel/footwear, and durable consumer goods makers selling through retailers, wholesalers, distributors, and direct-to-consumer channels. Top pressures right now are margin compression from input-cost volatility and retailer power (private label, slotting fees), the shift of demand and data to digital and D2C channels (without abandoning the retailer relationship), and trade-promotion ROI under real scrutiny as analytics matures. Salesforce typically engages here through Consumer Goods Cloud (retail execution, trade promotion management, sales planning), Commerce Cloud for D2C and B2B portals, Data Cloud for consumer 360, Marketing Cloud for loyalty and lifecycle, and Service Cloud for consumer care. The buying center is usually a Chief Commercial Officer or VP of Sales (for trade and retail execution), a Chief Digital/D2C Officer (for ecommerce), and a CMO (for brand and loyalty), with IT in an enabling role.

## Grounding prompt (injected into every persona)

### Vocabulary

Use the industry's actual vocabulary. The "trade" is the retail channel (grocery, drug, mass, club, convenience); "TPM" is trade promotion management; "perfect store" / "retail execution" describes in-store compliance (planograms, share of shelf, OSA — on-shelf availability); "field sales reps" or "merchandisers" visit stores; "sell-in" is to the retailer, "sell-through" is to the shopper; "syndicated data" comes from Nielsen/Circana/IRI; "lift" measures promotion incremental volume. D2C brands talk in "AOV", "repeat rate", "CAC/LTV", and "subscription churn". B2B distributor portals talk in "MSL" (must-stock list), "MOQ", and "EDI".

### Honest objections

The honest objections this industry raises against generic SaaS pitches: (1) "We don't own the shopper data — the retailer does" — for non-D2C CPG, household-level data is structurally hard, and pretending Data Cloud magically fixes this loses credibility; (2) "Our trade spend is 15-25% of revenue and we already have a TPM" — generic CPQ or planning tools don't replace deductions, accruals, and post-event analytics; (3) "Field rep adoption is the whole game" — if the mobile retail-execution app is slow or offline-fragile, reps revert to pen and paper.

### Regulatory frame

The dominant Salesforce footprint is Consumer Goods Cloud + Commerce Cloud + Marketing Cloud, with Data Cloud increasingly central for D2C-driven consumer 360. Decisions typically need alignment across commercial leadership, digital/D2C, brand marketing, and supply chain.

## Customer-type classifier (which sub-type — large CPG, D2C challenger, private-label, or foodservice?)

The consumer-goods industry spans structurally different business models with different channels, data realities, and buying centers. The skill should detect which sub-type the customer belongs to and weight the panel accordingly. Detection signals (case-insensitive substring match on the customer name + the prompt body):

**Large CPG manufacturer (retailer-channel-dominant)** — lead with `trade-promotion-manager`, `field-sales-director`, `supply-chain-lead`, and `retailer-buyer-category-manager` *(must-include — the Walmart/Kroger buyer is the existential gate)*; demote `d2c-ecommerce-lead`.
- Customer-name patterns: named CPG: `P&G`, `Procter & Gamble`, `Unilever`, `Nestlé`, `General Mills`, `Kellogg's`, `Kraft Heinz`, `PepsiCo`, `Coca-Cola`, `Mondelez`, `Mars`, `Hershey`, `Colgate-Palmolive`, `Reckitt`, `Clorox`, `Church & Dwight`, `Conagra`, `Tyson`, `Smucker's`, `Campbell Soup`; substrings: `Foods`, `Brands`, `Beverages`, `Consumer Products`.
- Prompt patterns: `TPM`, `trade promotion`, `retail execution`, `perfect store`, `OSA`, `MCB`, `bill-back`, `deduction`, `JBP`, `Nielsen`, `Circana`, `IRI`, `field reps`, `syndicated data`.

**D2C-native challenger brand** — lead with `d2c-ecommerce-lead`, `brand-manager`; demote `trade-promotion-manager`.
- Customer-name patterns: well-known DTC brands: `Warby Parker`, `Allbirds`, `Glossier`, `Casper`, `Away`, `Harry's`, `Dollar Shave Club`, `Bombas`, `Olipop`, `Liquid Death`; plus substrings: `Goods` *(small)*, `.com`, brand names with no retail-channel signal.
- Prompt patterns: `D2C`, `DTC`, `subscription`, `CAC`, `LTV`, `ATT`, `Shopify`, `Klaviyo`, `zero-party`, `creator partnerships`.

**Private-label / store-brand supplier** — lead with `supply-chain-lead`, `field-sales-director`, and `retailer-buyer-category-manager` *(the retailer perspective is essential when the retailer is also the brand owner)*.
- Customer-name patterns: `Private Label`, `Store Brand` *(supplier context)*; named: `TreeHouse Foods`, `Cott`, `Ralcorp`, `B&G Foods` *(parts of portfolio)*, plus generic substrings indicating contract-pack relationships.
- Prompt patterns: `private label`, `store brand`, `contract pack`, `co-man`, `cost-plus`, `Kroger SimpleTruth`, `Walmart Great Value`, `Costco Kirkland`, `Target Up&Up`.

**Foodservice / B2B-distributor-channel CPG** — lead with `supply-chain-lead`, `field-sales-director` *(broker sub-profile)*.
- Customer-name patterns: substrings: `Foodservice`, `Solutions` *(B2B CPG)*; manufacturers selling primarily through broker networks; named: `Sysco`, `US Foods`, `Performance Food Group`, `Gordon Food Service` *(as channel partners; the customer is the CPG selling through them)*.
- Prompt patterns: `foodservice`, `K-12 school district` *(as CPG customer)*, `MSL`, `MOQ`, `EDI`, `broker`, `distributor portal`, `case-pack`, `cut sheet`.

**Ambiguous signals** (a name matches multiple groups, or no name was given) — ask one clarifying question rather than guess: *"Is the customer a large retailer-channel CPG manufacturer, a D2C-native challenger brand, a private-label / store-brand supplier, or a foodservice / B2B-distributor-channel CPG?"* Then load only that sub-group's persona weighting.

## Recommended industry-specific persona files

Each industry pack contributes 3-5 industry-specific personas at `personas/industries/consumer-goods/<role-slug>.md` (these get created in a separate Phase). For this pack, the personas are:

- trade-promotion-manager.md — Owns retailer promotions, accruals, deductions, and post-event ROI.
- d2c-ecommerce-lead.md — Owns the brand's direct online store, subscription, and digital P&L.
- field-sales-director.md — Owns the field-rep force, retail execution, and perfect-store programs.
- brand-manager.md — Owns brand P&L, innovation pipeline, and marketing investment by brand.
- supply-chain-lead.md — Owns S&OP, fulfillment, and the link between demand signal and production.
- retailer-buyer-category-manager.md — *(Inversion persona)* Reviews from the *retailer's* side as the receiver of every CPG go-to-market decision — the Walmart/Kroger/Target buyer who controls whether your product earns shelf.

> **Pack sizing note:** This pack now ships 6 personas. For default 5-cap panels, the `supply-chain-lead` is typically the right swap-out unless S&OP, fulfillment, or DC-allocation topics come up in the prompt — in which case keep Supply Chain Lead and drop a different role appropriate to the customer sub-type.

## Recommended product-pack pairings

When this industry is active, these product packs are most commonly relevant — the recommender should prefer them unless the user has explicitly set `--product`:
- consumer-goods-cloud — Trade promotion management, retail execution, and perfect-store programs; the industry-specific backbone.
- sales-cloud — Account hierarchy and opportunity backbone underneath CG Cloud.
- commerce-cloud — D2C brand sites and B2B distributor/foodservice portals.
- marketing-cloud — Loyalty programs, lifecycle journeys, and brand-led consumer marketing.
- data-cloud — Consumer 360 for D2C and unified view across retailer and first-party data.

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources for this industry, suggest:
- https://www.salesforce.com/industries/consumer-goods/
- https://www.consumerbrandsassociation.org/  (US CPG industry association)
- https://www.fda.gov/food  (US food labeling and safety)
- https://gs1.org/  (GS1 standards — GTINs, barcodes, GDSN; foundational to CPG data)
- https://www.ftc.gov/business-guidance/advertising-marketing  (US advertising rules)

## Common sales-conversation pitfalls in this industry

1. Pitching "consumer 360" to a brand that sells 95% through retailers without acknowledging that household-level data ownership sits with the retailer.
2. Treating trade promotion as just CPQ or just analytics — real TPM spans planning, execution, deductions, and post-event measurement with accounting integration.
3. Demoing a slick D2C journey but ignoring that D2C is often a small percentage of revenue and a politically sensitive channel relative to retail partners.
4. Underestimating syndicated data integration (Nielsen/Circana/IRI) — these feeds are central to brand decision-making and not trivially modeled in Data Cloud.
5. Ignoring field-rep mobile reality — offline mode, low-end Android devices, and quick store visits dictate UX more than the headquarters demo room.
6. Pitching a direct-store-delivery story to a brand that sells through brokers, distributors, or foodservice channels — the rep never touches the shelf, the broker owns the relationship, and EDI / case-pack economics dominate the conversation rather than perfect-store execution.

## Regulatory landscape (one paragraph)

Persona should keep in mind: food safety and labeling regulations (FDA in the US under FSMA, EFSA in the EU, plus local equivalents) constrain product master data, allergen handling, and recall workflows; FTC and equivalent regulators police advertising, endorsement disclosures, and loyalty/sweepstakes claims; category-specific regimes apply to alcohol (TTB in the US), tobacco/vape, dietary supplements, and infant nutrition; consumer privacy regimes (CCPA/CPRA, GDPR, and an expanding patchwork of US state laws) constrain D2C data collection, marketing consent, and data sharing with retailers. None of this constitutes legal advice — the persona should flag regulatory questions for counsel rather than over-promise.
