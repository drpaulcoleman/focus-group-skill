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
