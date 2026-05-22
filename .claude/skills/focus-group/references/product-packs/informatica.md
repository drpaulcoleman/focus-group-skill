# Informatica — Product Pack

Informatica is an enterprise data-management vendor whose flagship product is the Intelligent Data Management Cloud (IDMC) — a cloud platform covering data integration, data quality, master data management (MDM), data governance and catalog, application integration, and customer 360. Salesforce announced its intent to acquire Informatica in 2025; as of the current shipping reality, the acquisition is in flight, Informatica remains independently branded, and product unification with Data Cloud / MuleSoft has not yet materialized. The primary buyer is typically a Chief Data Officer, VP of Data Engineering, or an Enterprise Data Architect; the daily users are data engineers, MDM stewards, data quality analysts, and governance officers. Informatica's differentiators against modern ELT-native vendors (Fivetran, dbt, Matillion) and against MuleSoft itself are depth in MDM, mature data-quality tooling, broad legacy-source coverage, and a long enterprise track record. The typical sales motion today is still Informatica-led for IDMC, with Salesforce sellers learning to position complementarity rather than overlap.

## Grounding prompt (injected into every persona)

IDMC is a multi-service cloud platform; customers do not buy "Informatica" as one SKU but rather a combination of IDMC services (Cloud Data Integration, Cloud Data Quality, Cloud MDM, Cloud Application Integration, Cloud Data Governance and Catalog, etc.), priced largely on IPU (Informatica Processing Units) consumption. Legacy PowerCenter remains in production at many large customers and is the source of most "modernization to IDMC" conversations. MDM is Informatica's strongest differentiator in the field — multidomain MDM (customer, product, supplier, reference) is mature and often the entry point for an enterprise data program. The acquisition by Salesforce is announced intent only; the deal must close, regulatory approvals must complete, and any product unification with Salesforce Data Cloud or MuleSoft will take time. Sales conversations should treat IDMC and the Salesforce data stack as complementary today, not unified.

The three most common honest objections: (1) "we are moving to a lakehouse-native stack (Snowflake / Databricks / dbt) and do not need a legacy data integration vendor" — sometimes correct for greenfield analytics, but MDM and data quality remain weak spots in those stacks; (2) "IDMC is expensive and the IPU model is hard to predict" — legitimate; sizing requires real workload analysis; (3) "what happens to our investment after the Salesforce acquisition closes" — fair question that sellers should answer honestly: contracts continue, the product roadmap continues, and any unification will be a multi-year journey. The complexities that get glossed: IPU consumption can vary widely by job design and source complexity; MDM implementations are organizational change projects that frequently take 9-18 months to first value; and the overlap with MuleSoft (application integration), with Data Cloud (customer 360 and data unification), and potentially with Tableau Prep is real and creates buyer confusion that sales has to address with a clear "who does what" story.

## Recommended persona families

When this pack is active, the persona recommender leans toward:
- salesforce-sales/enterprise-architect
- salesforce-sales/industry-specialist
- salesforce-customer/technical-decision-maker
- generic/executives/chief-data-officer
- generic/technical/schema-db-reviewer
- generic/stakeholder/compliance-officer
- salesforce-customer/procurement-vendor-management

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources, suggest these first:
- https://docs.informatica.com/
- https://www.informatica.com/products/cloud-data-management.html
- https://www.informatica.com/learn-support/training.html
- https://network.informatica.com/community/informatica-network/cloud (verify exact URL before use)
- https://www.informatica.com/products/master-data-management.html
- https://www.informatica.com/trust-center.html
- https://www.salesforce.com/news/press-releases/ (verify the acquisition announcement URL before use)

## Common sales-conversation pitfalls

1. Assuming or implying that Informatica is already a Salesforce product — the acquisition is announced intent, not closed and unified; misrepresenting status is a credibility risk.
2. Positioning IDMC against MuleSoft as a head-to-head replacement — they overlap in application integration but differ materially in data integration and MDM; the panel should expect a "complementary" answer.
3. Skipping IPU sizing in a deal; customers consistently get surprised at renewal when consumption outruns the initial estimate.
4. Promising MDM "time to value" in weeks; multidomain MDM is a program, not a project, and the change-management cost is the larger risk.
5. Overpromising integration with Salesforce Data Cloud — the connectors exist and improve over time, but a unified product experience is a future state, not today's reality.

## When to combine with an industry pack

Strongest fit with `financial-services` (customer and counterparty MDM, regulatory data lineage), `healthcare-life-sciences` (patient / provider MDM and clinical data integration), and `manufacturing` (product, supplier, and materials MDM tied to ERP modernization).
