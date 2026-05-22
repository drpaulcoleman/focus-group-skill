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
| **CloudHub 2.0 vCore replica sizing** | CloudHub 2.0 sizes replicas on a vCore scale ranging from 0.1 vCore (1.2 GB total memory, 480 MB heap, 8 GB storage) up to 4 vCores (15 GB total memory, 7.5 GB heap, 20 GB storage); replicas below 1 vCore can burst to higher CPU but bursting is not guaranteed, so consistent throughput requires 1+ vCore | https://docs.mulesoft.com/cloudhub-2/ch2-architecture | verified 2026-05-22 |
| **CloudHub 2.0 vs. CloudHub 1.0** | Different runtime and deployment model: CloudHub 1.0 runs Mule "workers" while CloudHub 2.0 runs containerized "replicas" with per-application Mule runtime isolation across 12 global regions; URL formats and feature availability vary by control plane (US, EU, Canada, Japan), so confirm which CloudHub the customer will run on before scoping | https://docs.mulesoft.com/cloudhub-2/ch2-architecture | verified 2026-05-22 |
| **vCore pricing model** | Anypoint is consumption-priced on vCores; CloudHub 2.0 publicly documents the vCore replica-size matrix but the dollar-per-vCore rate-card is not on a public page (CloudHub 2.0 docs say "For CloudHub 2.0 pricing information, contact either your account executive or your account development representative") — TODO: confirm current price-per-vCore and bursting cost behavior from the internal rate card before any panel quotes a number | https://docs.mulesoft.com/cloudhub-2/ | TODO — public page does not list dollar pricing; pull from internal rate card |
| **Composer — separate from Anypoint Studio** | Composer is the no-code/low-code surface for business teams (marketed as "MuleSoft for Flow: Integration") and is licensed separately from the developer-grade Anypoint Platform tooling (Anypoint Code Builder, Studio); both products are surfaced together in MuleSoft's For Business Teams vs. For IT Teams navigation, but Composer cannot replace developer-grade integrations for complex orchestration, error handling, or high-throughput workloads | https://docs.mulesoft.com/ | verified 2026-05-22 (docs.mulesoft.com global navigation explicitly lists the two as distinct product surfaces; canonical Composer overview URL has moved repeatedly — re-verify slug before linking) |
| **iPaaS coexistence** | MuleSoft positions Anypoint as the "World's #1 integration and API platform" but markets iPaaS as one of multiple integration solution categories — the message is connect across systems, not necessarily rip-and-replace an existing platform; the marketing page www.mulesoft.com/integration-solutions/ipaas is currently Akamai-blocked from automated fetch, so confirm the published positioning directly with the customer before promising platform consolidation | https://docs.mulesoft.com/ | TODO — re-verify when www.mulesoft.com is reachable |
| **IDP / RPA / AI add-ons — separate enablement** | MuleSoft Intelligent Document Processing (IDP) is a distinct product with its own enablement; document processing consumes Automation Credits and Einstein-backed models (GPT-4o, GPT-4o Mini, GPT-5.1, GPT-5.2, Gemini 2.0 Flash, Gemini 2.5 Flash) are routed through the Salesforce Einstein Trust Layer; RPA and AI Chain Agent are separately positioned in MuleSoft's "For AI" navigation, so do not assume bundling — confirm what's in the customer's contract | https://docs.mulesoft.com/idp/ | verified 2026-05-22 |
| **Anypoint API Manager — policy categories** | API Manager 2.x lets you "Apply a Policy" to an API instance to enforce capabilities such as authentication, access, allotted consumption (rate limiting / SLA tiers), and service-level access; policies are applied per API instance and enforced at the API gateway (Mule runtime or Flex Gateway). API Manager 2.x manages Mule 4.x APIs only — accounts created before November 2017 use API Manager 1.x | https://docs.mulesoft.com/api-manager/2.x/getting-started-proxy | verified 2026-05-22 |
| **MuleSoft AI / Topic Center / Agentforce integration** | MuleSoft for Agentforce ("Power Agentforce with APIs and actions") and Einstein for MuleSoft ("Build integrations and automations faster using natural language") are listed in the "For AI" product family on docs.mulesoft.com; MuleSoft MCP Support is marketed as available; specific GA / availability for AI Chain Agent and Topic Center is not documented on a single canonical page — TODO: confirm currently shipping vs. preview status against the latest release notes before any panel quotes feature availability | https://docs.mulesoft.com/ | TODO — confirm per-feature GA each release; www.mulesoft.com AI pages are Akamai-blocked from automated fetch |
| **DataWeave language — version compatibility** | DataWeave is bundled with the Mule runtime; current latest pairing is Mule 4.11 with DataWeave 2.11. Compatibility table maps each Mule release to a single DataWeave version (e.g., Mule 4.10 → DW 2.10, 4.9 → 2.9, 4.4 → 2.4, 3.9 → 1.2) — confirm the customer's Mule runtime version before scoping DataWeave-specific scripts or migrations | https://docs.mulesoft.com/dataweave/latest/ | verified 2026-05-22 |
| **Hybrid deployment — Runtime Fabric and on-prem** | Anypoint Runtime Fabric (3.0) deploys Mule applications and API proxies to a Kubernetes cluster the customer creates and manages; supported managed Kubernetes services include EKS, AKS, GKE, Red Hat OpenShift (ROSA, ARO, Dedicated on GCP, on IBM Cloud, Container Platform, Platform Plus, Kubernetes Engine), Alibaba ACK, EKS-Anywhere, RKE2, and VMware Tanzu. Helm-based RTF management is the supported runtime-plane path on VMware Tanzu, Alibaba ACK, and Rancher | https://docs.mulesoft.com/runtime-fabric/ | verified 2026-05-22 |

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
