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
| **Forecasting — Salesforce Forecasting (Collaborative Forecasts)** | "Available in: Lightning Experience" and "Available in: Professional, Enterprise, Unlimited, and Developer Editions"; "In Winter '25, Salesforce Forecasting is also referred to as Collaborative Forecasts in some places." Territory-based forecasting and the additional features (forecast adjustments, custom forecast types) layer on top — confirm the customer's edition before quoting territory-forecast availability. | https://help.salesforce.com/s/articleView?id=sf.forecasts3_intro.htm | verified 2026-05-22 |
| **CPQ — included or add-on?** | Salesforce CPQ (formerly Steelbrick / now in the Revenue Cloud family) is separately licensed; do not assume any Sales Cloud edition includes it without checking the customer's specific entitlement. The salesforce.com/sales/cpq/ marketing page is Akamai-blocked from automated retrieval — verify CPQ entitlement against the customer's Order Form / MSA, not a public page. | https://www.salesforce.com/sales/cpq/ | TODO — public marketing page is Akamai-blocked; cite customer's contract or AppExchange CPQ listing instead. Re-attempted with real Chrome 2026-05-22 — still blocked. |
| **Pipeline Inspection — edition availability** | The Pipeline Inspection help page lists "View supported editions" rather than enumerating editions in the body; the public help article confirms Pipeline Inspection is a Sales Cloud feature with a "Supported Editions for Pipeline Inspection" sub-article. As of May 2026, the page also notes: "Starting in Summer '25, data from Activity Metrics and Activity 360 Reporting isn't available in Pipeline Inspection unless previously set up." Pull the supported-editions sub-article from the help TOC before quoting a specific edition list. | https://help.salesforce.com/s/articleView?id=sf.pipeline_inspection.htm | verified 2026-05-22 (parent page; supported-editions sub-article requires deeper navigation) |
| **Einstein Activity Capture — packaging** | Verbatim from help: "Available with Einstein Activity Capture Standard in Sales in Starter, Pro Suite, Professional, and Enterprise Editions"; "Available with Unlimited Edition, Einstein 1 Sales Edition, and Agentforce 1 Edition"; "Available with Einstein for Sales, which is included in Einstein 1 Sales Edition and available for an extra cost in Enterprise and Unlimited Editions"; "Available with Sales Engagement, which is included with Sales in Performance and Unlimited Editions, and available for an extra cost in Professional and Enterprise Editions." Standard EAC is included; advanced features (Einstein for Sales, Sales Engagement, Revenue Intelligence) carry separate cost in Enterprise/Professional. | https://help.salesforce.com/s/articleView?id=sf.einstein_sales_aac.htm | verified 2026-05-22 |
| **Apex governor — SOQL queries per transaction** | "Total number of SOQL queries issued: 100 (synchronous limit) / 200 (asynchronous limit)." Cumulative cross-namespace limit: 1,100 SOQL queries per transaction. | https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_gov_limits.htm | verified 2026-05-22 |
| **Apex governor — DML statements & records per transaction** | "Total number of DML statements issued: 150 / 150 (sync / async)." "Total number of records processed as a result of DML statements, Approval.process, or database.emptyRecycleBin: 10,000 / 10,000." Cumulative cross-namespace DML statement limit: 1,650. | https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_gov_limits.htm | verified 2026-05-22 |
| **API daily request limit** | Formula from the public limits cheatsheet: "100,000 + (number of licenses x calls per license type) + purchased API Call Add-Ons" for Enterprise / Professional (with API access) / Unlimited / Performance. Per-license rates: Enterprise/Professional: Salesforce 1,000; Salesforce Platform 1,000; Customer Community Plus 200; Partner Community 200. Unlimited/Performance: Salesforce 5,000; Salesforce Platform 5,000. Developer Edition is a flat 15,000. Full Sandbox (non-template): 5,000,000. | https://developer.salesforce.com/docs/atlas.en-us.salesforce_app_limits_cheatsheet.meta/salesforce_app_limits_cheatsheet/salesforce_app_limits_platform_api.htm | verified 2026-05-22 |
| **Bulk API 2.0 — daily ingest limit** | "Maximum number of records uploaded per 24-hour rolling period: 150,000,000" (Bulk API 1.0 and Bulk API 2.0 share the same 150M record cap). Bulk API 2.0 ingest job max file size: 150 MB per job (vs. 10 MB per batch in Bulk API 1.0). Bulk API 2.0 daily query jobs limit: 10,000 per 24-hour rolling window. | https://developer.salesforce.com/docs/atlas.en-us.salesforce_app_limits_cheatsheet.meta/salesforce_app_limits_cheatsheet/salesforce_app_limits_platform_bulkapi.htm | verified 2026-05-22 |
| **Reporting Snapshots vs. Tableau / CRM Analytics** | Historical pipeline / trending in Sales Cloud requires either Reporting Snapshots (configured) or a separate analytics product — confirm before promising trended pipeline reporting. Re-attempted `sf.data_concepts_reporting_snapshots.htm` with real Chrome 2026-05-22; URL returns 461KB SPA shell (generic title) but article body not injected during headless capture, so 200-vs-404 cannot be distinguished from output. | https://help.salesforce.com/s/articleView?id=sf.data_concepts_reporting_snapshots.htm | TODO — slug status indeterminate from harvest; navigate from analytics root in help TOC in a real browser |
| **Lead conversion — what happens to the Lead record** | Verbatim from help: "When you convert leads to contacts or accounts, the process sometimes creates duplicate records." "You can't reverse a lead conversion. After the conversion, the lead record is no longer searchable, unless your admin assigned you the View and Edit Converted Leads permission." "How these duplicate records are handled depends on how your Salesforce admin has set up Apex Lead Convert and Duplicate Management." Custom fields require explicit mapping per the companion help article: "If you set up custom lead fields, you specify how that custom information converts to custom fields in accounts, contacts, and opportunities." | https://help.salesforce.com/s/articleView?id=sf.leads_convert.htm | verified 2026-05-22 |
| **Lead conversion — custom field mapping** | "When sales reps convert qualified leads, the information from the standard lead fields appears in standard fields for contact, account, and opportunity records. If you set up custom lead fields, you specify how that custom information converts to custom fields in accounts, contacts, and opportunities." Mapping is configured under Object Manager → Leads → Map Lead Fields. Note: "custom field mapping for lead conversion is available in orgs that use Apex Lead Convert. Custom field mapping for lead convert isn't available in orgs that use the older PLSQL (Procedural Language for SQL) Lead Convert." | https://help.salesforce.com/s/articleView?id=sf.customize_mapleads.htm | verified 2026-05-22 |

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
