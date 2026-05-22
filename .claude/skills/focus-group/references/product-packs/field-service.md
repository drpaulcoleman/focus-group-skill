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
| **Field Service licensing — base seats (Enterprise Edition)** | Per-user pricing on the public page: Dispatcher $175/user/month, Technician $175/user/month, Contractor $55/user/month (or $22/login), Contractor Plus $80/user/month (or $32/login). Field Service requires at least one Service Cloud user license; Technicians and Contractors require at least one Dispatcher license to use the scheduling tool (or the Field Service Plus bundle which includes one). Unlimited Edition pricing is higher (Dispatcher/Technician $330). | https://www.salesforce.com/products/field-service/pricing/ | verified 2026-05-22 |
| **Field Service Plus vs. base license** | Field Service Plus ($230/user/month Enterprise, $380 Unlimited) bundles Dispatcher + Technician + Service Cloud + Sales Cloud into a single license and may be used for contact center, call center, or case management — base Dispatcher and Technician licenses cannot. Agentforce 1 Field Service ($650/user/month) is the AI-loaded tier that adds full Agentforce usage, Appointment Assistant, Visual Remote Assistant, Digital Channels, Slack, Tableau Next, plus 1M Flex Credits and 2.5M Data Cloud Credits per org per year. | https://www.salesforce.com/products/field-service/pricing/ | verified 2026-05-22 |
| **Mobile app — supported platforms** | The Field Service mobile app is available for Android and iOS (no Windows mobile app). Salesforce describes it as "designed as an offline-first application" with delta-sync updates, offline-capable Lightning Web Components, dynamic forms that work offline, and the ability to view and update work orders offline (offline functionality is included in the Technician license). | https://www.salesforce.com/products/field-service/features/ | verified 2026-05-22 |
| **Mobile app — offline cache duration & sync conflict resolution** | The app supports offline work with delta-sync, but specific cache-duration values, per-technician offline record ceilings, and the conflict-resolution policy (last-write-wins vs. server-wins vs. user-prompted) are documented in the Field Service Mobile App admin guide which is JS-rendered and was not retrievable via static fetch in this pass. TODO: re-verify the offline record-cap and conflict-resolution behavior against the current admin guide before any panel quotes a number or a resolution policy. | https://help.salesforce.com/s/articleView?id=sf.fs_mobile_app.htm | TODO — re-verify against current admin guide (JS-rendered help page, not retrievable via static fetch) |
| **Mobile app — crew offline limits** | The dispatcher console "coordinate[s] crews across territories" and supports employee, contractor, and "even robotic" workforce per the public features page, but the per-crew or per-technician offline record cap is not stated on the public page. TODO: verify crew-mode offline scope (briefcase priming rules, crew-leader vs. crew-member device behavior) against the Field Service Mobile App admin guide before any panel quotes a crew limit. | https://www.salesforce.com/products/field-service/features/ | TODO — verify crew-specific offline behavior |
| **Scheduling — optimization engine** | Optimization (multi-day, in-day, optimization service) requires clean work-rule and skill data; the engine produces poor schedules on dirty data — customers must invest in data hygiene first | https://help.salesforce.com/s/articleView?id=sf.fs_scheduling_optimization.htm | TODO — verify slug (JS-rendered help page) |
| **Contractor / third-party crew model** | Contractor and Contractor Plus seats use distinct entitlements from employee Technician seats: Contractor ($55/user/month or $22/login) is read-and-update-only on assigned work; Contractor Plus ($80/user/month or $32/login) adds revenue-generation tools (cross-sell, upsell, performance tracking). Login-based licensing is the toggle that frequently breaks contractor-cost models if the AE quotes per-user without checking how often the contractor will actually log in. | https://www.salesforce.com/products/field-service/pricing/ | verified 2026-05-22 |
| **Parts & inventory** | Native parts/inventory tracking is usable but often needs a real WMS or ERP integration for serious operations | https://help.salesforce.com/s/articleView?id=sf.fs_inventory_management.htm | TODO — verify slug (JS-rendered help page) |
| **Maps and routing** | Built-in mapping/routing has specific limits and coverage; complex multi-stop optimization may require additional licenses or partners | https://help.salesforce.com/s/articleView?id=sf.fs_maps.htm | TODO — verify slug (JS-rendered help page) |
| **Service Appointment object — sharing behavior** | Sharing on Service Appointments interacts with the Account, Service Resource, and Work Order in non-obvious ways — verify before scoping access | https://help.salesforce.com/s/articleView?id=sf.fs_sharing_security.htm | TODO — verify slug (JS-rendered help page) |
| **API limits — assignment and bulk schedule operations** | TODO — verify current limits for assignment/optimization API calls before scoping integrations | https://developer.salesforce.com/docs/atlas.en-us.field_service_dev.meta/field_service_dev/ | TODO |
| **Add-on SKUs that affect deal sizing** | Field Service add-ons priced separately on the public page: Agentforce for Field Service $125/user/month, Asset Service Lifecycle Management $75/user/month, Visual Remote Assistant $50/user/month, Connected Assets $15,000/org/month. AEs scoping a multi-tier service operation should price these into the envelope before the customer's procurement team does the math. | https://www.salesforce.com/products/field-service/pricing/ | verified 2026-05-22 |
| **Migration from ServiceMax / IFS / Oracle** | Migration is a phased project, not a forklift; phased migration tied to a Service Cloud consolidation is the realistic answer | https://appexchange.salesforce.com/ | TODO — pick relevant partner page |

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
