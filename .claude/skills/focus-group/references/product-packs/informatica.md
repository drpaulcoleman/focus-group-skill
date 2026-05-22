# Informatica — Product Pack

Informatica is an enterprise data-management vendor whose flagship product is the Intelligent Data Management Cloud (IDMC) — a cloud platform covering data integration, data quality, master data management (MDM), data governance and catalog, application integration, and customer 360. Salesforce signed a definitive agreement to acquire Informatica on May 27, 2025 (~$8B equity value) and completed the acquisition on November 18, 2025; Informatica's public properties are now branded "Informatica from Salesforce." Existing IDMC contracts continue and the product is still sold under the Informatica name, but product unification with Data Cloud / MuleSoft is a multi-year roadmap, not today's reality. The primary buyer is typically a Chief Data Officer, VP of Data Engineering, or an Enterprise Data Architect; the daily users are data engineers, MDM stewards, data quality analysts, and governance officers. Informatica's differentiators against modern ELT-native vendors (Fivetran, dbt, Matillion) and against MuleSoft itself are depth in MDM, mature data-quality tooling, broad legacy-source coverage, and a long enterprise track record. The typical sales motion today is still Informatica-led for IDMC, with Salesforce sellers learning to position complementarity rather than overlap.

## Grounding prompt (injected into every persona)

IDMC is a multi-service cloud platform; customers do not buy "Informatica" as one SKU but rather a combination of IDMC services (Cloud Data Integration, Cloud Data Quality, Cloud MDM, Cloud Application Integration, Cloud Data Governance and Catalog, etc.), priced largely on IPU (Informatica Processing Units) consumption. Legacy PowerCenter remains in production at many large customers and is the source of most "modernization to IDMC" conversations. MDM is Informatica's strongest differentiator in the field — multidomain MDM (customer, product, supplier, reference) is mature and often the entry point for an enterprise data program. The acquisition by Salesforce closed on November 18, 2025 — Informatica is now part of Salesforce, but product unification with Salesforce Data Cloud or MuleSoft is a multi-year roadmap. Sales conversations should treat IDMC and the Salesforce data stack as complementary today, not unified.

The three most common honest objections: (1) "we are moving to a lakehouse-native stack (Snowflake / Databricks / dbt) and do not need a legacy data integration vendor" — sometimes correct for greenfield analytics, but MDM and data quality remain weak spots in those stacks; (2) "IDMC is expensive and the IPU model is hard to predict" — legitimate; sizing requires real workload analysis; (3) "what happens to our investment now that the Salesforce acquisition has closed" — fair question that sellers should answer honestly: contracts continue, the product roadmap continues, and any unification will be a multi-year journey. The complexities that get glossed: IPU consumption can vary widely by job design and source complexity; MDM implementations are organizational change projects that frequently take 9-18 months to first value; and the overlap with MuleSoft (application integration), with Data Cloud (customer 360 and data unification), and potentially with Tableau Prep is real and creates buyer confusion that sales has to address with a clear "who does what" story.

## Platform Facts

This section is the verification source for accuracy-rubric factor 6
(platform-fact verification). Each row is either **filled** or a **TODO
stub**; the rubric scores 0 for any panel claim that lands on a stub
row. See [salesforce-crm-agentforce.md](salesforce-crm-agentforce.md)
for the canonical maintainer note.

| Topic | Fact | Source / verified | Last verified |
|-------|------|-------------------|---------------|
| **Salesforce acquisition — status** | Salesforce announced the definitive agreement to acquire Informatica on May 27, 2025 (~$8B equity value, $25/share cash for Class A and Class B-1 stockholders), and completed the acquisition on November 18, 2025; Informatica properties (informatica.com, docs.informatica.com) are now branded "Informatica from Salesforce" with footer copyright "© Salesforce, Inc." Existing IDMC contracts continue and any product unification with Data Cloud / MuleSoft is a multi-year roadmap | https://www.salesforce.com/news/press-releases/2025/05/27/salesforce-and-informatica-to-create-the-most-complete-platform-for-modern-ai-architecture/ | verified 2026-05-22 |
| **IDMC — what's in the platform** | Informatica Intelligent Data Management Cloud (IDMC) bundles eight services: Data Catalog, Data Integration & Engineering, API & App Integration, AI Agent Engineering, Data Quality & Observability, MDM & 360 Applications, Governance Access & Privacy, and Data Marketplace. Customers buy a combination of services, not a single SKU | https://www.informatica.com/platform.html | verified 2026-05-22 |
| **IDMC — IPU pricing** | Consumption-priced on Informatica Processing Units (IPUs); IPUs "give customers access to all eligible cloud services" with consumption calculated per scaler (Secure Agent, CDI-Elastic, Data Mass Ingestion volume, etc.). Master data management is priced separately on a per-domain-records basis. Public pricing page does not publish dollar-per-IPU rates — quotes are use-case-specific. Sizing requires real workload analysis, not a back-of-envelope estimate | https://www.informatica.com/products/cloud-integration/pricing.html | verified 2026-05-22 |
| **Connector library — order of magnitude** | Informatica's platform page advertises "50,000+ metadata-aware connections"; the public connector catalog page does not publish a single connector count or full source/target list — confirm specific connector availability and version constraints before promising a specific source or target | https://www.informatica.com/platform.html | verified 2026-05-22 |
| **PowerCenter vs. IDMC migration** | PowerCenter remains a supported, on-prem ETL product but is not the strategic platform; Informatica markets a PowerCenter→IDMC modernization path (claimed up to 8x faster move to cloud, up to 100% asset reuse, up to 50% cost reduction) and a transitional PowerCenter Cloud Edition. Migration is a real program, not a switch — but Informatica is investing in the cloud platform (IDMC), not new PowerCenter features | https://www.informatica.com/products/data-integration/powercenter.html | verified 2026-05-22 |
| **Data Quality and Observability — separate IDMC service** | Data Quality & Observability is a distinct service in IDMC, listed separately from Data Integration & Engineering, MDM & 360, Governance Access & Privacy, etc. Native data quality and governance modules are not bundled into the integration runtime — confirm what's in the customer's contract before scoping a data-quality program | https://www.informatica.com/products/data-quality.html | verified 2026-05-22 |
| **MDM — implementation reality** | Informatica MDM (Customer 360, Product 360 / PIM, Supplier 360 / SRM, Finance 360, Reference 360 / RDM) is positioned around "speed deployment" via prebuilt 360 applications and CLAIRE GPT match/merge, but the public page does not publish a typical implementation duration; multidomain MDM in practice remains a multi-quarter program where change-management cost dominates the technical cost — TODO: pull a Salesforce/Informatica public reference deployment timeline before any panel quotes a months-to-value number | https://www.informatica.com/products/master-data-management.html | TODO — public page does not publish typical timelines |
| **Overlap with MuleSoft / Data Cloud / Tableau Prep** | IDMC's API & App Integration overlaps with MuleSoft Anypoint at the application-integration layer; IDMC's MDM and Customer 360 overlap with Data Cloud's customer-data-unification story; IDMC's Data Integration & Engineering overlaps with Tableau Prep at the prep/transformation layer. Post-close, Salesforce has not yet published a single canonical "who does what" mapping — TODO: pull the official positioning matrix when published before any panel quotes a definitive boundary | https://www.salesforce.com/news/press-releases/2025/05/27/salesforce-and-informatica-to-create-the-most-complete-platform-for-modern-ai-architecture/ | TODO — official positioning matrix not yet published |
| **Lakehouse coexistence (Snowflake / Databricks / dbt)** | IDMC supports lakehouse / data fabric / data mesh architectures and feeds cloud data warehouses and lakes via ETL, ELT, Spark, and serverless paths; Informatica's positioning is complementary rather than displacement of the lakehouse — sometimes the right answer is "use both" — TODO: pinpoint a current Snowflake/Databricks-specific partnership URL (snowflake.html slug 404s) before any panel quotes the partnership story | https://www.informatica.com/products/cloud-data-integration.html | TODO — partner-specific landing pages have moved |
| **CDC (Change Data Capture)** | IDMC's Data Integration & Engineering includes CDC capability via the Cloud Mass Ingestion service, alongside ETL, ELT, Spark, and serverless integration paths; CDC has specific source-system requirements and licensing that vary by source — verify the customer's specific source compatibility before scoping real-time replication | https://www.informatica.com/products/cloud-data-integration.html | verified 2026-05-22 |

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

1. Assuming or implying that Informatica is already a unified Salesforce product — the acquisition closed November 18, 2025, but Informatica still ships and is sold as Informatica (now branded "Informatica from Salesforce"); product unification with Data Cloud / MuleSoft is a multi-year roadmap, and misrepresenting the integration status is a credibility risk.
2. Positioning IDMC against MuleSoft as a head-to-head replacement — they overlap in application integration but differ materially in data integration and MDM; the panel should expect a "complementary" answer.
3. Skipping IPU sizing in a deal; customers consistently get surprised at renewal when consumption outruns the initial estimate.
4. Promising MDM "time to value" in weeks; multidomain MDM is a program, not a project, and the change-management cost is the larger risk.
5. Overpromising integration with Salesforce Data Cloud — the connectors exist and improve over time, but a unified product experience is a future state, not today's reality.

## When to combine with an industry pack

Strongest fit with `financial-services` (customer and counterparty MDM, regulatory data lineage), `healthcare-life-sciences` (patient / provider MDM and clinical data integration), and `manufacturing` (product, supplier, and materials MDM tied to ERP modernization).
