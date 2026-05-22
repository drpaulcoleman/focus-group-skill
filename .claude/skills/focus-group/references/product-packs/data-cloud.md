# Data Cloud — Product Pack

Data Cloud (the former Customer Data Platform, before that Genie) is Salesforce's
customer-data platform: it ingests data from Salesforce clouds and external sources,
harmonizes it into a canonical model, resolves identities into unified profiles, and
exposes those profiles as segments, calculated insights, and zero-copy data shares that
other Salesforce products and Agentforce can consume. The primary buyer is the Chief
Data Officer, CMO, or CIO; the primary users are data engineers, marketing operations,
analytics, and increasingly anyone building Agentforce agents that need cross-cloud
context. Sales teams should lean on three honest differentiators: native integration
with every Salesforce cloud and Agentforce (no separate activation layer to build);
zero-copy connectors to Snowflake, Databricks, BigQuery, and Redshift that let the
customer leave their warehouse data in place; and identity resolution and segmentation
built for marketing and service activation in the same platform. The typical sales
motion is either a CDP replacement (Segment, Tealium, Adobe AEP, Lytics), a
unified-audience play across Marketing Cloud and Service Cloud, or — increasingly — the
unblocking move for an Agentforce use case that needs cross-cloud or unstructured
grounding.

## Grounding prompt (injected into every persona)

Data Cloud is a separate Salesforce product with its own data lake (lakehouse-style,
parquet-based), its own object model (Data Lake Objects / DLOs, Data Model Objects /
DMOs, Unified Individual / Unified Account), its own ingestion connectors
(Salesforce-native, ingestion API, batch SFTP, streaming, zero-copy to Snowflake /
Databricks / BigQuery / Redshift), its own identity-resolution ruleset, and its own
consumption-priced metering (credits for ingestion, processing, segmentation,
activation). Common deployment shapes are: ingest from Sales / Service / Marketing
Cloud, build a unified profile, activate to Marketing Cloud Engagement and
Personalization; ingest from a warehouse via zero-copy, build calculated insights for
service or sales; ground an Agentforce agent on Data Cloud objects via the retrieval
and search APIs; and the newer Salesforce-native Marketing Cloud Growth / Advanced
editions that rely on Data Cloud as their data layer rather than a separate Engagement
instance.

The honest objections customers raise are: cost (Data Cloud is consumption-priced on
credits, and the customer's data team will model the credit burn — ingestion volume,
segment refresh frequency, activation volume — and push back if the numbers grow); the
"do we even need a CDP" question from customers who already have a Snowflake /
Databricks investment and a strong data team; and timeline (a real Data Cloud
implementation — connectors, modeling, identity resolution, segments, activation — is
months, and the customer has heard that some Salesforce-CDP projects stall in the
modeling phase). The hidden complexities sales conversations gloss are: the data model
is genuinely different from core Salesforce — DLOs, DMOs, and the bring-your-own-lake
patterns require data-engineering skill, not admin skill; identity resolution rulesets
are easy to misconfigure and the customer's data lead will want to see the actual match
rules, not a slide; consumption credits are not always intuitively allocated across
ingestion, processing, segmentation, and activation, and a surprise credit-burn at
renewal is the most common Data Cloud post-sale friction; zero-copy is genuine but
query performance depends on warehouse setup and how the customer governs their lake —
it is not magic; and grounding an Agentforce agent on Data Cloud requires careful
retrieval design (chunking, embeddings, search-index configuration) that an unprepared
SE will hand-wave.

## Platform Facts

This section is the verification source for accuracy-rubric factor 6
(platform-fact verification). Each row is either **filled** or a **TODO
stub**; the rubric scores 0 for any panel claim that lands on a stub
row. See [salesforce-crm-agentforce.md](salesforce-crm-agentforce.md)
for the canonical maintainer note.

| Topic | Fact | Source / verified | Last verified |
|-------|------|-------------------|---------------|
| **Data Cloud (Data 360) — pricing model** | Three buying options on the public page: Flex Credits at $500 per 100k credits (pay-per-use across all action categories); Profiles at $240 per 1k profiles/year (includes 1 Flex Credit per profile, 25 calculated insights, 25 transforms, 100 segments); Enterprise Profiles at $420 per 1k profiles/year (includes 2 Flex Credits per profile, 100 calculated insights, 100 transforms, 500 segments, plus Data Masking and Ad Audience add-ons). Salesforce explicitly states ingestion is free across all tiers — billing is on action categories: Process Unstructured Data, Prep/Harmonize/Unify, Segment & Activate, Query & Share, Streaming & Real-Time. | https://www.salesforce.com/data/pricing/ | verified 2026-05-22 |
| **Events-per-day ingest ceilings by edition** | The public pricing page does not publish per-edition events-per-day ingest ceilings; the per-action credit consumption rates and any volumetric caps live in the Data 360 Flex Credits rate-card PDF (linked from https://www.salesforce.com/agentforce/rates/) and in the Data Cloud Limits and Allocations help article (which is JS-rendered and not retrievable via static fetch in this pass). TODO: pull the current rate-card PDF and the limits article before any panel quotes a daily event-ingest ceiling. | https://www.salesforce.com/agentforce/rates/ | TODO — fetch current rate-card PDF and limits article. Re-attempted with real Chrome 2026-05-22 — still blocked. |
| **Zero Copy — supported sources (current GA scope)** | Per the Data Cloud Connectors Directory, bidirectional Zero Copy is GA with Amazon Redshift, Google BigQuery, and Snowflake (Structured, Zero Copy, both directions). Data-in-only Zero Copy is GA with Apache Iceberg, AWS Glue Data Catalog, and IBM watsonx.data. Databricks supports Zero Copy alongside batch ingestion. The directory also lists Zero Copy support for many transactional databases (AWS Aurora/RDS variants, Azure Cosmos/MySQL/PostgreSQL, Google Spanner) under "Batch, Zero Copy" — i.e., dual-mode connectors. NetSuite is currently flagged Beta in the directory. | https://developer.salesforce.com/docs/data/data-cloud-int/guide/c360-a-thirdparty-connectors.html | verified 2026-05-22 |
| **Identity resolution — real-time vs. batch & scale** | Salesforce's public Data 360 framing positions identity resolution as part of "Harmonize" — building unified profiles by matching and reconciling identities across sources — and the product page emphasizes a "real-time data engine," but per-rule throughput, the precise scheduling cadence for batch vs. streaming reconciliation, and the maximum match-rule complexity are not stated on the public pages. TODO: verify the current real-time vs. scheduled identity-resolution split, max match rules per ruleset, and per-edition profile ceilings against the Data Cloud Identity Resolution help article and the limits article before any panel quotes a real-time UID resolution promise. | https://www.salesforce.com/data/ | TODO — verify scheduling cadence, max match rules, per-edition profile ceilings |
| **Calculated insights — execution model** | Calculated insights run on a schedule (not real-time by default); streaming insights have a different execution model and limits | https://help.salesforce.com/s/articleView?id=sf.c360_a_calculated_insights.htm | TODO — re-attempted with real Chrome 2026-05-22; URL returns 461KB SPA shell (HTTP 200, generic "Salesforce Help \| Article" title) but article body is not injected during headless capture — cannot verify slug validity or extract execution-model facts from this URL pattern |
| **Data Cloud — query API** | Data Cloud SQL / query API has rate limits and result-size limits — confirm current numbers before scoping a customer integration | https://developer.salesforce.com/docs/atlas.en-us.c360a_api.meta/c360a_api/ | TODO |
| **CRM connector / standard data model** | Standard Salesforce objects map to Data Cloud's standard data model; custom objects require explicit mapping; bidirectional sync has specific patterns | https://help.salesforce.com/s/articleView?id=sf.c360_a_salesforce_crm_data_bundles.htm | TODO — re-attempted with real Chrome 2026-05-22; URL returns 461KB SPA shell but article body not injected during capture; slug cannot be confirmed valid/404 from output. Note: post-rebrand, c360_a_* slugs have largely moved under data360-* / data-cloud help trees — try `data360_*` or `data_cloud_*` namespaces |
| **Data ingestion — connectors and limits** | Data Stream connectors (batch, streaming, CDC) each have separate enablement and limits; Salesforce explicitly states "ingestion is free across all tiers" on the public pricing page, but per-stream throughput caps and per-edition row/event ceilings are not on the public page — TODO: verify against the Data Cloud Limits and Allocations help article. | https://www.salesforce.com/data/pricing/ | TODO — verify per-stream throughput caps |
| **Trust Layer / Data Cloud / Agentforce interplay** | When Agentforce grounds on Data Cloud, the retrieval pattern is configured per topic — chunking, embeddings, search-index choice all materially affect agent quality | https://architect.salesforce.com/decision-guides | TODO — re-attempted with real Chrome 2026-05-22; architect.salesforce.com is LWR-rendered and returns SPA shell (209KB) without decision-guide list body; cannot enumerate available guides from capture |
| **Data retention windows (default + extended)** | Default and extended retention windows for Data Lake Objects, Data Model Objects, Unified Individual graph, and Engagement events are not published on the public pricing or product pages; they are configured per object class and are documented in the Data Cloud Limits and Allocations help article. TODO: verify current default retention windows (DLO/DMO/event-store), extended-retention SKU costs, and the right-to-delete propagation behavior before any panel quotes a number. | https://www.salesforce.com/data/pricing/ | TODO — verify default and extended retention by object class |
| **Data residency and regulatory boundaries** | Verify which regions support Data Cloud and any current GovCloud / EU residency limitations before promising a regulated deployment; compliance.salesforce.com pages were not retrievable via static fetch in this pass | https://compliance.salesforce.com/en/data-residency | TODO — re-verify current region & GovCloud availability |

## Recommended persona families

When this pack is active, the persona recommender (Step 4a) leans toward:
- salesforce-sales/enterprise-architect
- salesforce-sales/technical-architect
- salesforce-sales/business-value-consultant
- salesforce-customer/economic-buyer
- salesforce-customer/technical-decision-maker
- salesforce-customer/infosec-privacy-officer
- generic/executives/chief-data-officer

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources, suggest these first:
- https://help.salesforce.com/s/articleView?id=sf.c360_a_data_cloud.htm
  (verify before use — Data Cloud help slugs have moved as the product was renamed)
- https://www.salesforce.com/data/
- https://architect.salesforce.com/decision-guides
  (pick the data-cloud / identity-resolution guide currently published)
- https://trailhead.salesforce.com/content/learn/trails/data-cloud
  (verify exact trail slug)
- https://developer.salesforce.com/docs/atlas.en-us.c360a_api.meta/c360a_api/c360_a_api_intro.htm
  (verify before use)
- https://help.salesforce.com/s/articleView?id=sf.c360_a_zero_copy_overview.htm
  (verify before use)

## Common sales-conversation pitfalls

1. Quoting Data Cloud on the SKU base price without sizing credit consumption against
   the customer's actual ingestion and segmentation volume — the customer's data team
   will run their own numbers.
2. Pitching zero-copy as if it removes the need for governance or data-modeling work
   on the customer's warehouse side — it does not.
3. Demoing identity resolution with clean sample data and never showing what happens
   with messy real-world records (missing emails, multiple accounts, household
   conflicts).
4. Promising an Agentforce agent will "just retrieve the right context" without
   scoping the retrieval design, chunking strategy, and search-index tuning that real
   grounding requires.
5. Selling Data Cloud as a replacement for the customer's warehouse rather than as a
   complement to it — a confident data team will hear the pitch and disengage.

## When to combine with an industry pack

Pair with `financial-services` for KYC / household-360 / advisor-360 conversations
where identity resolution against regulated records is load-bearing. Pair with
`retail` or `consumer-goods` for unified-audience activation across e-commerce, store,
and loyalty. Pair with `healthcare-life-sciences` for patient-360 — but the HIPAA
Privacy Officer needs to be in the room from day one because of how Data Cloud handles
PHI ingestion, masking, and activation.
