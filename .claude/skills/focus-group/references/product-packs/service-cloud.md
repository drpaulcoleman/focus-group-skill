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
| **Omni-Channel routing** | Omni-Channel routing supports skill-based, queue-based, and external routing patterns; available in Enterprise edition and above | help.salesforce.com Omni-Channel | TODO — verify current help slug |
| **Service Cloud Voice — pricing model** | Consumption-priced on top of Service Cloud licensing; voice minutes are billed separately from CRM seats; confirm current pricing/contract before quoting | salesforce.com Service Cloud Voice | TODO |
| **Knowledge — article publishing & permissions** | Salesforce Knowledge requires explicit user permissions and a publishing workflow; data-category visibility rules govern what each agent sees | help.salesforce.com Knowledge | TODO |
| **Field Service overlap** | Field Service is a separately licensed product, not included in Service Cloud; confirm before scoping technician/dispatch features | salesforce.com Field Service | TODO |
| **Agentforce Service Agent — deployment surfaces** | Embeddable in Experience Cloud, messaging channels, and the Service Console; sharing/FLS inheritance follows the agent user — see Trust Layer | help.salesforce.com Agentforce | TODO |
| **Apex governor — SOQL queries per transaction** | TODO — verify against current Apex Developer Guide before any panel quotes a number | developer.salesforce.com Apex Limits | TODO |
| **Case assignment & escalation rules** | TODO — document current behavior, including what triggers re-evaluation and how this interacts with Omni-Channel | help.salesforce.com Case rules | TODO |
| **CTI / partner phone integration** | TODO — confirm currently certified CTI partners and the OpenCTI vs. Service Cloud Voice tradeoffs | salesforce.com partners | TODO |
| **Workforce Management (WFM) native vs. partner** | Native Service Cloud has limited WFM (AHT, schedule adherence, occupancy not first-class); CRM Analytics or a partner WFM product is typically required for serious contact-center ops | salesforce.com partners | TODO |

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
