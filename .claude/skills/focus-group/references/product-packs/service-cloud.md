# Service Cloud — Product Pack

Service Cloud is Salesforce's service and support platform: cases, omni-channel routing,
knowledge, service console, telephony (Service Cloud Voice), digital channels (chat,
messaging, WhatsApp, Apple Messages for Business), field service, and the AI layer that
summarizes and drafts on top of it. The primary buyer is the CCO or VP Customer Service;
the primary users are contact-center agents, field technicians, service managers, and the
workforce-management team. Sales teams should lean on three honest differentiators: a
single agent desktop unifying voice, digital, case, and knowledge (most challengers still
bolt these together); the depth of Field Service for any customer with technicians,
assets, or work orders; and the tight loop with Sales Cloud / Data Cloud / Agentforce that
lets a service interaction inform a sales play and vice versa. The typical sales motion
starts with a CSAT, AHT, or first-contact-resolution problem, moves through an
agent-experience audit, and lands on a phased plan that often starts with case +
knowledge before adding voice, digital, or field.

## Grounding prompt (injected into every persona)

Service Cloud is built on the Salesforce Platform and inherits the same data model,
sharing model, governor limits, and Lightning runtime. The Service Console is the agent
desktop; Omni-Channel routes work items (cases, chats, voice calls, messaging
conversations) to agents based on skills, capacity, and presence; Knowledge stores
articles with translation, versioning, and data categories; Service Cloud Voice
integrates a telephony provider (Amazon Connect by default, with partner options for
Genesys and others) into the console with real-time transcription and post-call
summaries. Common deployment shapes are: a case + knowledge rollout for an existing
Sales Cloud customer; a contact-center modernization replacing a legacy ACD with Service
Cloud Voice + digital channels; a Field Service deployment for utilities, telco, or
industrial customers with technicians; and a Service Cloud + Agentforce Service Agent
deployment where the agent deflects tier-1 cases and drafts responses for tier-2.

The honest objections customers raise are: telephony cost and complexity (Service Cloud
Voice with Amazon Connect adds a real per-minute spend and a real integration project,
and customers with deep Genesys / NICE / Five9 footprints will push back); console
performance with heavy customization (a console with many Lightning components and
real-time signals can feel slow on lower-end hardware — the customer's agents notice
immediately); and the Knowledge migration story (importing legacy knowledge with quality
intact is consistently underestimated). The hidden complexities sales conversations gloss
are: Omni-Channel routing logic is configurable but constrained — non-standard routing
(skills-based with overflow, with shift-aware capacity, with bilingual preferences) often
requires Flow and sometimes Apex; case assignment + queues + entitlements + milestones
interact in ways that surprise an admin who hasn't built it before; Field Service has its
own scheduling engine, dispatcher console, and mobile app with their own learning curve
and licensing; Agentforce Service Agent inherits the running user's sharing — a poorly
scoped agent user can either over-share PII to a deflection bot or under-share and look
broken; and reporting on contact-center KPIs (AHT, FCR, occupancy, schedule adherence)
usually requires CRM Analytics / Tableau or a workforce-management partner, not native
reports.

## Platform Facts

This section is the verification source for accuracy-rubric factor 6
(platform-fact verification). Each row is either **filled** or a **TODO
stub**; the rubric scores 0 for any panel claim that lands on a stub
row. See [salesforce-crm-agentforce.md](salesforce-crm-agentforce.md)
for the canonical maintainer note.

| Topic | Fact | Source / verified | Last verified |
|-------|------|-------------------|---------------|
| **Omni-Channel routing** | Verbatim from help: "Omni-Channel is available with the Agentforce Service (formerly Service Cloud) product license or any of these add-on licenses: Digital Engagement, Enhanced Chat, Salesforce Voice with Amazon Connect or Partner Telephony, or Workforce Management." Note: "Standard Omni-Channel is retired with the Summer '26 release. To make sure that your users maintain their routing workflows and gain access to the latest features, Salesforce automatically upgrades your org to Enhanced Omni-Channel during the Summer '26 release rollout." | https://help.salesforce.com/s/articleView?id=sf.service_presence_intro.htm | verified 2026-05-22 |
| **Service Cloud Voice — pricing model** | Consumption-priced on top of Service Cloud licensing; voice minutes are billed separately from CRM seats; confirm current pricing/contract before quoting. The marketing page `salesforce.com/service/cloud-voice/` is Akamai-blocked from automated retrieval, and the help slug `sf.service_cloud_voice.htm` 404s; cite the customer's Order Form for actual rates. Per the related Omni-Channel article, Voice is sold as either "Salesforce Voice with Amazon Connect" or "Partner Telephony." | https://www.salesforce.com/service/cloud-voice/ | TODO — public marketing page Akamai-blocked; help slug not located in 7 guesses (sf.scv_*, sf.salesforce_voice*, sf.contact_center*); cite Order Form. Re-attempted with real Chrome 2026-05-22 — still blocked. |
| **Knowledge — article publishing & permissions** | Verbatim from help: "Your Salesforce Knowledge base is built from knowledge articles, which are documents of information." "You can publish articles in customer and partner sites and public websites or share articles in social posts and emails. Control where and what information is published or shared based on the article page layouts, user profiles, actions, and other settings." "Orgs new to Knowledge use Lightning Knowledge, which is generally available." Important note: "To maintain access to Knowledge, you or your admin must run the Lightning Knowledge Migration Tool before June 1, 2025. All orgs are required to migrate from Classic Knowledge to Lightning Knowledge." | https://help.salesforce.com/s/articleView?id=sf.knowledge_whatis.htm | verified 2026-05-22 |
| **Field Service overlap** | Verbatim from help: "Agentforce Field Service and Operations (formerly known as Field Service) gives you a powerful, highly customizable, mobile-friendly field service hub in Salesforce." "The Agentforce Field Service and Operations core features, managed package, and mobile app are available in Enterprise, Unlimited, and Developer Editions." Note rebrand: "Field Service is now Agentforce Field Service and Operations. In some cases, we still use Field Service to refer to this product area." It is a separately licensed product (not included in base Service Cloud) — confirm entitlement before scoping. | https://help.salesforce.com/s/articleView?id=sf.fs_overview.htm | verified 2026-05-22 |
| **Agentforce Service Agent — deployment surfaces** | Verbatim from help: "Agentforce Service agents intelligently support your customers by processing incoming cases and autonomously resolving common inquiries. These agents connect to customer channels, such as enhanced messaging channels, and use Omni-Channel Flow to escalate complex or sensitive support requests to service reps or other destinations." Help content has consolidated under the "Design and Implement Agentforce Agents" tree. Sharing/FLS inheritance follows the agent user — see Trust Layer. | https://help.salesforce.com/s/articleView?id=sf.service_agent.htm | verified 2026-05-22 |
| **Apex governor — SOQL queries per transaction** | "Total number of SOQL queries issued: 100 (synchronous limit) / 200 (asynchronous limit)." Cumulative cross-namespace limit: 1,100 SOQL queries per transaction. Same governor limits apply across Service, Sales, and all Salesforce-Platform clouds. | https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_gov_limits.htm | verified 2026-05-22 |
| **Apex governor — DML statements & records per transaction** | "Total number of DML statements issued: 150 / 150 (sync / async)." "Total number of records processed as a result of DML statements, Approval.process, or database.emptyRecycleBin: 10,000 / 10,000." Cumulative cross-namespace DML statement limit: 1,650. | https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_gov_limits.htm | verified 2026-05-22 |
| **Case assignment rules** | Verbatim from help on assignment-rule entries: "Sets the order in which the entry is processed in the rule, for example, 1, 2, 3. Salesforce evaluates each entry in order and tries to match the criteria for the entry. When a match is found, Salesforce assigns the item and stops evaluating the rule entries for that item. If no match is found, the item is reassigned to either the default Web-to-Lead owner, the administrator doing a lead import, or the default case owner." Rule entries can specify Criteria (filter) or formula evaluating to true; can assign to user or queue; can attach predefined case teams; "Do Not Reassign Owner" prevents reassignment on update. The previously-cited slug `sf.customize_caserules.htm` 404s; canonical is `sf.creating_assignment_rules.htm`. | https://help.salesforce.com/s/articleView?id=sf.creating_assignment_rules.htm | verified 2026-05-22 |
| **CTI / partner phone integration** | Verbatim from help: "Open CTI is in maintenance mode and is scheduled for retirement on February 28, 2028. No new features or enhancements are being added to Open CTI. Effective immediately, Open CTI is deprecated and unavailable for newly created Agentforce Service orgs. To ensure long-term compatibility and access to the latest innovations, we recommend migrating to Salesforce Voice." "Salesforce Voice offers many of the Open CTI features that you love and more. Unlike Open CTI, Salesforce Voice is natively integrated with Omni-Channel and Command Center for Service, providing a seamless experience for contact center reps and supervisors across all digital channels." | https://help.salesforce.com/s/articleView?id=sf.cti_overview.htm | verified 2026-05-22 |
| **Workforce Management (WFM) native vs. partner** | Native Service Cloud has limited WFM (AHT, schedule adherence, occupancy not first-class). Per the Omni-Channel intro, Salesforce sells "Workforce Management" as a separate add-on license alongside Digital Engagement and Voice. CRM Analytics or a partner WFM product is typically required for serious contact-center ops — verify the customer's specific WFM SKU/entitlement before promising native coverage. | https://help.salesforce.com/s/articleView?id=sf.service_presence_intro.htm | verified 2026-05-22 (WFM as add-on license confirmed; deeper feature comparison still requires partner product evaluation) |

## Recommended persona families

When this pack is active, the persona recommender (Step 4a) leans toward:
- salesforce-sales/solution-engineer
- salesforce-sales/business-value-consultant
- salesforce-sales/customer-success-manager
- salesforce-customer/economic-buyer
- salesforce-customer/end-user-power-user
- salesforce-customer/change-management-sponsor
- generic/executives/chief-customer-officer

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources, suggest these first:
- https://help.salesforce.com/s/articleView?id=sf.service_cloud_overview.htm
  (verify before use)
- https://www.salesforce.com/service/
- https://architect.salesforce.com/decision-guides
  (pick the service / omni-channel guide currently published)
- https://trailhead.salesforce.com/content/learn/trails/service_cloud_trail
  (verify exact trail slug)
- https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_case.htm
- https://help.salesforce.com/s/articleView?id=sf.service_cloud_voice.htm
  (verify before use)
- https://help.salesforce.com/s/articleView?id=sf.fs_field_service.htm
  (verify before use)

## Common sales-conversation pitfalls

1. Quoting Service Cloud Voice on per-user license only and burying the Amazon Connect
   per-minute and telephony-carrier costs in a footnote — the CFO will reconstruct the
   real number.
2. Demoing case deflection with Agentforce without a credible escalation path and
   without showing how PII masking actually behaves on the transcript the agent sees.
3. Promising a clean Knowledge migration from a legacy KCS or Confluence-based
   knowledge base without scoping the article-cleanup work the customer's team has to
   do.
4. Pitching Field Service as a feature instead of a project — scheduling policy,
   work-type design, mobile-app configuration, and dispatcher training are each
   meaningful workstreams.
5. Conflating Service Cloud reporting with contact-center reporting — the customer's
   WFM lead will want occupancy, shrinkage, and schedule adherence, none of which
   Salesforce reports natively.

## When to combine with an industry pack

Pair with `healthcare-life-sciences` for patient-360 / care-coordination conversations
— the HIPAA Privacy Officer becomes load-bearing because case data, transcripts, and
agent prompts all touch PHI. Pair with `energy-utilities` or `communications` when
Field Service is in scope — outage workflows, work-order volume, and connected-asset
telemetry shape the design. Pair with `financial-services` for servicing-heavy lines
(cards, claims, complaints) where regulatory record-keeping on every interaction is
mandatory.
