# MuleSoft — Product Pack

MuleSoft is Salesforce's integration platform, anchored by Anypoint Platform — a runtime, design, and management environment for APIs and integrations. The primary buyer is usually a CIO, Chief Integration Officer, or Enterprise Architect; the daily users are integration developers, API product owners, and increasingly business technologists using MuleSoft Composer for lighter-weight automation. MuleSoft's differentiators against the broader iPaaS field (Boomi, Workato, Informatica, Azure Integration Services) are its API-led connectivity methodology, the breadth of pre-built connectors, and a strong enterprise-grade runtime with hybrid deployment options (CloudHub 2.0, customer-hosted Runtime Fabric, on-prem Mule runtimes). The typical Salesforce sales motion lands MuleSoft as the "any Salesforce, anywhere" integration story — frequently attached to a Service Cloud, Data Cloud, or industry-cloud deal where the customer needs to bring in data from legacy systems, ERPs, or SaaS apps. MuleSoft Composer is a lower-tier, Salesforce-platform-native automation tool aimed at admins and citizen integrators; it is not a replacement for full Anypoint.

## Grounding prompt (injected into every persona)

Anypoint Platform is licensed through a combination of cores/vCores (runtime capacity), API calls, and product-tier entitlements (Anypoint MQ, API Manager, API Community Manager, DataGraph, Anypoint Flex Gateway, Anypoint Code Builder, IDP, MuleSoft RPA, etc.). Sales conversations get sloppy when reps describe MuleSoft as "per connector" or "per integration" — it is not. The two most common deployment shapes are CloudHub 2.0 (fully Salesforce-managed) and Runtime Fabric on the customer's Kubernetes; on-prem standalone runtimes remain in use at large customers. API-led connectivity is MuleSoft's reference architecture (System / Process / Experience APIs) and it is a methodology, not a SKU — customers can adopt it without buying every Anypoint module. MuleSoft Composer is Salesforce-licensed (per flow per month), runs only against a curated set of connectors, and is positioned at the citizen-integrator persona; it cannot replace a developer-built Anypoint integration for complex orchestration, error handling, or high throughput.

The three most common honest objections: (1) "we already have an iPaaS" — many customers do, and a credible pitch acknowledges coexistence rather than rip-and-replace; (2) "MuleSoft is too expensive for what we need" — frequently true at the low end of the market, where Composer or a competitor may be the right answer; (3) "our developers prefer to write integrations themselves" — MuleSoft's value is governance, reuse, and a managed runtime, not raw code authorship, and the pitch has to land on platform value. The complexities that get glossed: vCore sizing and bursting cost is a real ongoing finance conversation; the IDP (Intelligent Document Processing), RPA, and AI add-ons each have separate enablement and limits; and the MuleSoft AI / Topic Center / Agentforce-integration story is evolving rapidly — sales should describe currently shipping capabilities, not future direction.

## Platform Facts

This section is the verification source for accuracy-rubric factor 6
(platform-fact verification). Each row is either **filled** or a **TODO
stub**; the rubric scores 0 for any panel claim that lands on a stub
row. See [salesforce-crm-agentforce.md](salesforce-crm-agentforce.md)
for the canonical maintainer note.

| Topic | Fact | Source / verified | Last verified |
|-------|------|-------------------|---------------|
| **vCore pricing model** | MuleSoft Anypoint is consumption-priced on vCores (CPU/memory units); bursting and reserved capacity have different cost behavior — sizing is a real ongoing finance conversation | https://www.mulesoft.com/platform/api/anypoint-pricing | TODO — verify URL |
| **CloudHub 2.0 vs. CloudHub 1.0** | Different runtime, different deployment model, different limits — confirm which one the customer will run on; CloudHub 2.0 is the modern path | https://docs.mulesoft.com/cloudhub-2/ch2-overview | TODO |
| **Composer — separate from Anypoint Studio** | Composer is the no-code/low-code surface; Anypoint Studio is the developer surface — they are different products with different limits and licensing | https://docs.mulesoft.com/composer/ | TODO |
| **iPaaS coexistence** | Many customers already run an iPaaS; a credible pitch acknowledges coexistence rather than rip-and-replace — confirm before promising platform consolidation | https://www.mulesoft.com/integration-solutions/ipaas | TODO |
| **IDP / RPA / AI add-ons** | Intelligent Document Processing, RPA, and AI add-ons each have separate enablement, licensing, and limits — do not assume they are bundled | https://www.mulesoft.com/platform/ai/ | TODO |
| **Anypoint API Manager — policies and rate limits** | API policies (rate-limit, OAuth, throttle) are configured per API; verify enforcement model before scoping a security-critical integration | https://docs.mulesoft.com/api-manager/ | TODO |
| **MuleSoft AI / Topic Center / Agentforce integration** | This story is evolving rapidly — sales should describe currently shipping capabilities, not future direction | https://www.mulesoft.com/platform/ai/ai-chain-agent | TODO — verify currently shipping |
| **DataWeave language** | Mule's transformation language; verify currently supported version and any deprecations before scoping | https://docs.mulesoft.com/dataweave/latest/ | TODO |
| **Hybrid deployment — RTF (Runtime Fabric) and on-prem** | Customers with on-prem requirements can run via Runtime Fabric or a self-managed Mule runtime; verify support tiers and patch model | https://docs.mulesoft.com/runtime-fabric/ | TODO |

## Recommended persona families

When this pack is active, the persona recommender leans toward:
- salesforce-sales/enterprise-architect
- salesforce-sales/solution-engineer
- salesforce-sales/technical-architect
- salesforce-customer/technical-decision-maker
- generic/technical/backend-engineer
- generic/technical/security-reviewer
- generic/executives/cio

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources, suggest these first:
- https://docs.mulesoft.com/
- https://developer.mulesoft.com/
- https://www.mulesoft.com/platform/enterprise-integration
- https://help.salesforce.com/s/articleView?id=sf.mc_composer_overview.htm (verify exact URL before use)
- https://trailhead.salesforce.com/content/learn/trails/build-integrations-using-mulesoft
- https://docs.mulesoft.com/runtime-fabric/
- https://www.mulesoft.com/legal/versioning-back-support-policy

## Common sales-conversation pitfalls

1. Quoting Anypoint without sizing vCore consumption against the customer's real throughput and peak patterns — under-sized deals turn into renewal fights.
2. Positioning MuleSoft Composer as a small-Anypoint when the customer's use case needs developer-grade error handling, polling, or transactionality.
3. Promising connector coverage by counting Exchange entries without confirming the specific connector version supports the customer's auth model and operations.
4. Describing API-led connectivity as a deliverable instead of a methodology; the customer still has to design and build the System/Process/Experience layers.
5. Glossing the run-the-platform cost (operations, monitoring, CI/CD, ownership of reusable assets) — MuleSoft's value depreciates fast without an internal API product owner.

## When to combine with an industry pack

Strongest fit with `financial-services` (legacy core-banking integration is the canonical MuleSoft story), `healthcare-life-sciences` (HL7 / FHIR / EHR integration with the Health Cloud accelerators), and `manufacturing` (ERP and shop-floor system integration where pre-built SAP and Oracle connectors materially shorten timelines).
