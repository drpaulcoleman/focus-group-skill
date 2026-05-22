# Sales Cloud — Product Pack

Sales Cloud is the seller-facing core of Salesforce: accounts, contacts, leads,
opportunities, forecasting, activity capture, and the pipeline workflow sales teams run
on. The primary buyer is the CRO or VP Sales; the primary users are AEs, SDRs, sales
managers, and RevOps. Sales teams selling Sales Cloud should lean on three honest
differentiators: the breadth and maturity of the data model (decades of customer-tested
objects and reporting), the surrounding ecosystem (CPQ / Revenue Cloud, partner apps on
AppExchange, Slack integration), and the depth of native forecasting and territory
management compared with most CRM challengers. The typical sales motion is discovery
into the customer's current sales process and pipeline hygiene, a fit assessment against
existing Salesforce footprint or competing CRM, and ROI sized on rep productivity,
forecast accuracy, and pipeline velocity.

## Grounding prompt (injected into every persona)

Sales Cloud sits on the Salesforce Platform and shares the same multi-tenant
architecture, sharing model, governor limits, and Lightning UI as every other cloud.
Editions step from Starter / Pro Suite through Professional, Enterprise, and Unlimited
— the meaningful breakpoints for an enterprise conversation are usually Enterprise (full
automation, advanced reporting) and Unlimited / Einstein 1 Sales (bundled Sandboxes,
premier support, Einstein features). Common deployment shapes are: a greenfield Sales
Cloud rollout replacing a legacy CRM or spreadsheets; a migration from a competing CRM
(HubSpot, Microsoft Dynamics, Pipedrive) where pipeline-stage definitions and reporting
parity drive most of the work; an expansion within an existing Salesforce customer
adding CPQ, Sales Engagement, or Revenue Intelligence; and a Sales Cloud + Agentforce
SDR / Sales Coach motion where the agent handles drafting and summarization.

The honest objections customers raise are: total cost of ownership relative to
challengers (Sales Cloud Enterprise plus the add-ons a real sales team needs — CPQ,
Sales Engagement, Maps, Inbox — adds up quickly, and the customer's finance team will
benchmark); adoption risk (Salesforce only works if reps actually update it, and a
poorly designed page layout or required-field policy will tank adoption inside a
quarter); and complexity / time-to-value (a serious Sales Cloud implementation is
months, not weeks, and the customer has heard horror stories). The hidden complexities
sales conversations gloss are: the sharing model (role hierarchy, sharing rules, manual
shares, territory management) becomes load-bearing as soon as the customer has more
than one sales team or a partner channel; forecast types and quota objects have
specific limitations that the customer's RevOps lead will discover during configuration;
CPQ (now Revenue Cloud) is functionally a separate product with its own implementation
rhythm and frequently doubles the project's complexity; and reporting on historical
pipeline (snapshots, trending) requires either Reporting Snapshots or Tableau / CRM
Analytics, which is a separate skill set and often a separate license.

## Platform Facts

This section is the verification source for accuracy-rubric factor 6
(platform-fact verification). Each row is either **filled** (a verified
fact a panel may quote with citation) or a **TODO stub** (not yet
verified — the rubric scores 0 for any panel claim that lands on a stub
row). See [salesforce-crm-agentforce.md](salesforce-crm-agentforce.md)
for the canonical maintainer note.

| Topic | Fact | Source / verified | Last verified |
|-------|------|-------------------|---------------|
| **Forecasting — Collaborative Forecasts** | Available in Enterprise edition and above; territory-based forecasts require Enterprise Territory Management to be enabled | https://help.salesforce.com/s/articleView?id=sf.forecasts3_overview.htm | TODO — verify slug |
| **CPQ — included or add-on?** | Salesforce CPQ (formerly Steelbrick / now in the Revenue Cloud family) is separately licensed; do not assume any Sales Cloud edition includes it without checking the customer's specific entitlement | https://www.salesforce.com/sales/cpq/ | TODO |
| **Pipeline Inspection — edition availability** | TODO — confirm which editions include Pipeline Inspection (was added in a specific release) | https://help.salesforce.com/s/articleView?id=sf.pipeline_inspection_setup.htm | TODO — verify slug |
| **Sales Engagement / Einstein Activity Capture** | TODO — confirm current packaging (separate add-on vs. included) and capture limits | https://help.salesforce.com/s/articleView?id=sf.einstein_activity_capture.htm | TODO — verify slug |
| **Apex governor — SOQL queries per transaction** | TODO — verify against current Apex Developer Guide before any panel quotes a number | https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_gov_limits.htm | TODO |
| **Apex governor — DML rows per transaction** | TODO — verify before any panel quotes a number | https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_gov_limits.htm | TODO |
| **API daily request limit** | Tied to edition + active user license count; verify the customer's specific entitlement before quoting a number | https://developer.salesforce.com/docs/atlas.en-us.salesforce_app_limits_cheatsheet.meta/salesforce_app_limits_cheatsheet/ | TODO |
| **Reporting Snapshots vs. Tableau / CRM Analytics** | Historical pipeline / trending in Sales Cloud requires either Reporting Snapshots (configured) or a separate analytics product — confirm before promising trended pipeline reporting | https://help.salesforce.com/s/articleView?id=sf.data_concepts_reporting_snapshots.htm | TODO — verify slug |
| **Lead conversion — what happens to the Lead record** | Confirm current behavior on conversion (Lead becomes inactive; Account/Contact/Opportunity created; standard fields mapped, custom fields require explicit field mapping) | https://help.salesforce.com/s/articleView?id=sf.leads_convert.htm | TODO — verify slug |

## Recommended persona families

When this pack is active, the persona recommender (Step 4a) leans toward:
- salesforce-sales/account-executive
- salesforce-sales/business-value-consultant
- salesforce-sales/solution-engineer
- salesforce-customer/economic-buyer
- salesforce-customer/champion
- salesforce-customer/end-user-power-user
- generic/executives/vp-sales

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources, suggest these first:
- https://help.salesforce.com/s/articleView?id=sf.sales_core_overview.htm
  (verify before use)
- https://www.salesforce.com/sales/
- https://architect.salesforce.com/decision-guides
  (pick the sales / forecasting guide currently published)
- https://trailhead.salesforce.com/content/learn/trails/sales_admin
  (verify exact trail slug)
- https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_opportunity.htm
- https://help.salesforce.com/s/articleView?id=sf.forecasts3_overview.htm
  (verify before use)

## Common sales-conversation pitfalls

1. Demoing a clean, well-designed pipeline view without acknowledging that the
   customer's current pipeline is messy — the buyer knows their data is the problem
   and wants to hear how the rollout handles it.
2. Quoting Sales Cloud Enterprise as the deal price and then surprising the customer
   at scoping with CPQ, Sales Engagement, Inbox, Maps, and Sandboxes as separate line
   items.
3. Glossing the sharing-model conversation with multi-team or partner-channel
   customers — the technical decision-maker will ask, and a vague answer is a
   deal-slower.
4. Promising adoption lift without naming the change-management work (page-layout
   discipline, manager rituals, leaderboards) the customer's team has to do.
5. Treating forecast accuracy as a feature toggle instead of a process change —
   forecast categories, methodology, and rep behavior all have to align before the
   number gets better.

## When to combine with an industry pack

Pair with `manufacturing` or `consumer-goods` when the customer sells through a partner
or distributor channel — Partner Relationship Management and Channel Sales
conversations become central. Pair with `professional-services` when the customer's
"sale" is a billable engagement — Sales Cloud + PSA-style workflows (often Certinia or
Kantata on top) shape the integration story. Pair with `financial-services` for wealth
or insurance distribution where Financial Services Cloud's pre-built data model usually
wins over plain Sales Cloud.
