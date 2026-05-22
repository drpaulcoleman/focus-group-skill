# Salesforce Field Service — Product Pack

Salesforce Field Service (formerly Field Service Lightning) is the mobile-first dispatch, scheduling, and asset-management product built on top of Service Cloud. The primary buyer is usually a VP of Service, Director of Field Operations, or a Chief Customer Officer; the daily users are dispatchers, field technicians on the mobile app, service managers, and contractor-management leads. Field Service's differentiators against ServiceMax, IFS, Oracle Field Service, and Microsoft Dynamics 365 Field Service are its tight integration with Service Cloud (cases, work orders, entitlements), the strength of its scheduling and optimization engine, and the offline-capable mobile app for technicians. The typical Salesforce sales motion attaches Field Service to an existing Service Cloud customer who is moving from manual or third-party dispatch into a unified service operation, or lands it as part of a broader industry-cloud play (Manufacturing Cloud, Energy & Utilities Cloud, Health Cloud, Communications Cloud).

## Grounding prompt (injected into every persona)

Field Service is licensed per Dispatcher, per Technician, and per Contractor seat, with separate SKUs and entitlements; the mobile app is included with the technician license. Scheduling is split between the basic scheduler (rules-based) and the optimization engine (jobs are scheduled against constraints, skills, SLAs, travel time, and shift windows); optimization is a paid add-on that requires careful data hygiene to deliver value. The mobile app is genuinely offline-capable but the offline data set has to be scoped (briefcase / priming) and tested per role — pretending offline "just works" leads to field failures. Asset management in Field Service supports asset hierarchies, maintenance plans, and preventive-maintenance work-order generation; for IoT-triggered or telematics-driven work, integration with Data Cloud, MuleSoft, or industry-cloud accelerators is usually required. Visual Remote Assistant (video assistance) and Appointment Assistant (customer-facing appointment tracking) are companion products with their own licensing.

The three most common honest objections: (1) "we already run on ServiceMax / IFS / Oracle and migration is too painful" — legitimate; the realistic answer is a phased migration tied to a Service Cloud consolidation, not a forklift; (2) "our technicians will not use the mobile app" — adoption is the largest risk and is mostly a UI configuration, training, and field-leader buy-in problem, not a product problem; (3) "scheduling optimization is a black box" — optimization works only when work-rule and skill data is clean, and customers must invest in data hygiene before they see the lift. The complexities that get glossed: contractor management (third-party crews) has different licensing and a different security model than employee technicians; offline conflict resolution is a real engineering concern that needs design attention up front; and parts management / inventory tracking is usable but often needs a real WMS or ERP integration for serious operations.

## Platform Facts

This section is the verification source for accuracy-rubric factor 6
(platform-fact verification). Each row is either **filled** or a **TODO
stub**; the rubric scores 0 for any panel claim that lands on a stub
row. See [salesforce-crm-agentforce.md](salesforce-crm-agentforce.md)
for the canonical maintainer note.

| Topic | Fact | Source / verified | Last verified |
|-------|------|-------------------|---------------|
| **Field Service license** | Separately licensed from Service Cloud; technician licenses, dispatcher licenses, and contractor licenses each have distinct entitlements and pricing | salesforce.com field service | TODO |
| **Mobile app — offline support** | The Field Service mobile app supports offline work with a defined sync model; offline conflict resolution is a real engineering concern that needs design attention up front | help.salesforce.com Field Service mobile | TODO |
| **Scheduling — optimization engine** | Optimization (multi-day, in-day, optimization service) requires clean work-rule and skill data; the engine produces poor schedules on dirty data — customers must invest in data hygiene first | help.salesforce.com Field Service scheduling | TODO |
| **Contractor / third-party crew model** | Contractor management uses a different security/license model than employee technicians; verify before scoping multi-tier crew patterns | help.salesforce.com Field Service contractors | TODO |
| **Parts & inventory** | Native parts/inventory tracking is usable but often needs a real WMS or ERP integration for serious operations | help.salesforce.com Field Service inventory | TODO |
| **Maps and routing** | Built-in mapping/routing has specific limits and coverage; complex multi-stop optimization may require additional licenses or partners | help.salesforce.com Field Service maps | TODO |
| **Service Appointment object — sharing behavior** | Sharing on Service Appointments interacts with the Account, Service Resource, and Work Order in non-obvious ways — verify before scoping access | help.salesforce.com Field Service sharing | TODO |
| **API limits — assignment and bulk schedule operations** | TODO — verify current limits for assignment/optimization API calls before scoping integrations | developer.salesforce.com Field Service APIs | TODO |
| **Migration from ServiceMax / IFS / Oracle** | Migration is a phased project, not a forklift; phased migration tied to a Service Cloud consolidation is the realistic answer | salesforce.com partners | TODO |

## Recommended persona families

When this pack is active, the persona recommender leans toward:
- salesforce-sales/solution-engineer
- salesforce-sales/industry-specialist
- salesforce-customer/champion
- salesforce-customer/end-user-power-user
- generic/customer/accessibility-dependent-user
- generic/executives/vp-customer-success
- salesforce-sales/business-value-consultant

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources, suggest these first:
- https://help.salesforce.com/s/articleView?id=sf.fs_overview.htm (verify exact URL before use)
- https://www.salesforce.com/products/field-service/
- https://trailhead.salesforce.com/content/learn/trails/transform-the-field-service-experience
- https://developer.salesforce.com/docs/atlas.en-us.field_service_dev.meta/field_service_dev/
- https://help.salesforce.com/s/articleView?id=sf.pfs_mobile_app.htm (verify exact URL before use)
- https://www.salesforce.com/products/field-service/pricing/

## Common sales-conversation pitfalls

1. Demoing optimization on a curated sample without addressing the customer's real work-rule, skill, and territory data — the demo lift will not reproduce.
2. Pitching the mobile app's offline mode without scoping which records the technician actually needs offline and how conflicts will be resolved.
3. Under-counting contractor seats and the different licensing implications when third-party crews are part of the operation.
4. Treating asset management as a turnkey replacement for a CMMS or EAM; large industrial customers usually keep the system of record elsewhere and integrate.
5. Skipping the field-leader change-management conversation — dispatcher and technician adoption is the deal's largest single risk and it is rarely a product risk.

## When to combine with an industry pack

Strongest fit with `energy-utilities` (meter, line-crew, and restoration work tied to outage and regulatory pressure), `manufacturing` (warranty and aftermarket service tied to installed-base assets), `commercial-real-estate` (facilities operations and on-site service coordination across distributed properties), and `aec-construction` (punch-list, commissioning, MEP start-up, and 12-month-warranty service on newly-completed work).
