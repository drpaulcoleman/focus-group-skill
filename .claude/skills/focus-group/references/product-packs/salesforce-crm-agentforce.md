# Salesforce CRM + Agentforce — Product Pack

This is the default pack: the Salesforce Customer 360 core (Sales Cloud, Service Cloud,
and the underlying Platform) paired with Agentforce, Salesforce's framework for building,
deploying, and governing AI agents that act inside the CRM. The primary buyers are CROs,
CIOs, CCOs, and increasingly Chief Customer Officers; the primary users are sellers,
service agents, marketers, and operations staff who already live in Salesforce. The
differentiators sales teams should lean on are the depth of the CRM data model the agent
reasons over (no separate "AI database" to populate), the trust layer (zero data retention
with model providers, masking, auditability) built into the platform rather than bolted on,
and Flow-based actions that let agents do real work in the system of record rather than
just chat. The typical sales motion is consultative: discovery into the customer's current
Salesforce footprint and data maturity, a use-case workshop to pick the first one or two
agents, a Business Value Consultant pass to size benefit, and a phased rollout that usually
starts with an internal-facing agent before customer-facing.

## Grounding prompt (injected into every persona)

Salesforce CRM is the Customer 360 — Sales, Service, and the underlying Platform (objects,
sharing model, Flow, Apex, Lightning, permission sets) — running on a multi-tenant
architecture with hard governor limits. Agentforce is Salesforce's agent framework: it
lets an admin or developer compose an agent from a topic (the job the agent does),
instructions, and actions (Flows, Apex invocables, prompt templates, or external APIs via
MuleSoft or HTTP callouts). Agents run in the Einstein Trust Layer, which provides prompt
masking, zero data retention with model providers, toxicity scoring, and audit. Common
deployment shapes are: an internal Service Agent that drafts case responses and summarizes
cases; a Sales Coach / SDR agent that drafts outbound, summarizes calls, and updates
opportunities; a customer-facing Agentforce Service Agent embedded in an Experience Cloud
site or messaging channel; and a custom agent built around a few Flow actions for a niche
workflow.

The honest objections customers raise are: cost (Agentforce is consumption-priced on
conversations, and a high-volume customer-facing deployment can be more expensive than the
SKU price suggests once the conversation envelope is sized realistically); trust and
accuracy (will the agent hallucinate, escalate badly, or take a destructive action — the
customer will want a clear handoff and a guardrail story); and "we already have Copilot /
OpenAI / a competitor's agent" (the answer is the depth of the CRM context the agent
already has, not raw model quality). The hidden complexities sales conversations gloss
are: agent actions inherit the running user's sharing and FLS — a poorly chosen agent user
can over-share or under-share records and the symptom looks like a bad answer; Data Cloud
is often required, not optional, once the customer wants the agent to reason over
unstructured data or cross-cloud data, and that pulls a separate (substantial) line item
into the deal; consumption pricing on conversations needs a realistic volume estimate up
front or the customer will be surprised at renewal; and the Trust Layer's zero-retention
guarantee applies to the supported model providers via Salesforce — if the customer brings
their own model, the guarantees change. Persona reactions should keep these realities
visible rather than papered over.

## Platform Facts

This section is the verification source for accuracy-rubric factor 6
(platform-fact verification). Each row is either **filled** (a verified
fact a panel may quote with citation) or a **TODO stub** (not yet
verified — the rubric scores 0 for any panel claim that lands on a stub
row, which is intentional pressure to keep this table fresh). When in
doubt, prefer a citation to current Salesforce help / release notes
over a value pasted here — Salesforce ships ~3 releases a year and
governor limits, GA status, and pricing model details move.

| Topic | Fact | Source / verified | Last verified |
|-------|------|-------------------|---------------|
| **Trust Layer — model providers** | Salesforce describes a "strict policy where the prompts and generated responses are never stored or used to train the underlying third-party large language models" reached via the Trust Layer; bring-your-own-model arrangements fall outside this guarantee and follow the customer's own contract with the provider | https://www.salesforce.com/artificial-intelligence/trusted-ai/ | verified 2026-05-22 |
| **Agentforce — pricing model** | Multiple buying motions, not just per-conversation: Conversations at $2 USD per conversation (pre-purchase, optimized for customer-facing agents), Flex Credits at $500 per 100k credits (each agent action = 20 Flex Credits, each Voice action = 30 Flex Credits), Agentforce add-ons at $125/user/month (Industries add-on $150), Agentforce 1 editions from $550/user/month. Flex Credits and Conversations cannot be mixed in the same org. | https://www.salesforce.com/agentforce/pricing/ | verified 2026-05-22 |
| **Agentforce — what counts as a conversation** | Salesforce's public pricing page does not formally define a conversation unit; the rate-card detail lives in the Agentforce Conversation rate-card PDF and the per-edition contract — TODO: pull the current rate-card PDF from https://www.salesforce.com/agentforce/rates/ and quote the conversation definition verbatim before any panel claim about session length, turns, or unresolved-handoff billing | https://www.salesforce.com/agentforce/rates/ | TODO — fetch current rate-card PDF |
| **Agentforce — sharing model** | Agent actions inherit the running agent user's sharing rules and FLS — the agent user's permission set determines what the agent can see and do; this is a load-bearing fact for InfoSec but the canonical help slug for "agent user permissions" was not retrievable in this verification pass — TODO: re-verify the help-article slug and the precise phrasing before quoting | https://help.salesforce.com/s/articleView?id=sf.agentforce_agent_user_permissions.htm | TODO — re-verify slug (page is JS-rendered, not retrievable via static fetch) |
| **Data Cloud dependency** | Required when the agent must reason over unstructured data, cross-cloud data, or data outside the Salesforce object model; not required for in-CRM-only agents — confirm against the current Agentforce decision guide before quoting | https://architect.salesforce.com/decision-guides | TODO — pick current decision guide (architect.salesforce.com/decision-guides/agentforce returned 404 in this pass) |
| **Apex governor — SOQL queries per transaction** | TODO — verify against current Apex Developer Guide before any panel quotes a number | https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_gov_limits.htm | TODO |
| **Apex governor — DML rows per transaction** | TODO — verify against current Apex Developer Guide before any panel quotes a number | https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_gov_limits.htm | TODO |
| **Bulk API 2.0 — daily request limit** | TODO — verify against current API Limits doc before any panel quotes a number | https://developer.salesforce.com/docs/atlas.en-us.salesforce_app_limits_cheatsheet.meta/salesforce_app_limits_cheatsheet/ | TODO |
| **Agentforce — GA status (Service & Sales agents)** | Agentforce for Service and Agentforce for Sales reached general availability on October 25, 2024; subsequent components of the Atlas Reasoning Engine were slated for February 2025 release per Salesforce's launch announcement. Per-feature GA must still be re-verified each release because individual sub-features (Voice, Intelligent Context, etc.) ship on different cadences. | https://www.salesforce.com/news/press-releases/2024/09/12/agentforce-announcement/ | verified 2026-05-22 |
| **Atlas Reasoning Engine vs. Agent Builder vs. Prompt Builder** | Atlas Reasoning Engine is the runtime that breaks a prompt into smaller tasks, evaluates at each step, and proposes/refines an execution plan — it is the agent's planner, not an authoring tool. Agent Builder (also marketed as Agentforce Builder) is the low-code authoring workspace where admins compose subagents, instructions, and actions; it is included with the purchase of Agentforce. Prompt Builder is the separate prompt-template authoring tool used for non-agent generative features. Atlas and Agent Builder are GA per the launch coverage; per-sub-feature GA must still be checked per release. | https://www.salesforce.com/agentforce/ | verified 2026-05-22 |
| **Government Cloud Plus — feature parity** | TODO — confirm which Agentforce features are available in Government Cloud Plus (the set is materially smaller than commercial cloud and changes per release); compliance.salesforce.com pages were not retrievable in this verification pass | https://compliance.salesforce.com/en/services/government-cloud-plus | TODO — re-verify against current GovCloud feature matrix |
| **Trust Layer — masking surface** | The Trust Layer's data masking replaces sensitive content with non-identifiable tokens before prompts reach the LLM; Salesforce's public framing covers PII and proprietary business data without enumerating each masked entity type on the public page — TODO: verify the current default vs. opt-in masked-entity list (typically includes name, email, phone, address, government IDs, financial identifiers) against the configurable masking-policy help article before any panel quotes a specific entity list | https://www.salesforce.com/artificial-intelligence/trusted-ai/ | TODO — verify default-vs-opt-in entity list |

**Maintainer note:** when a panel confidently quotes a TODO row, the
accuracy rubric scores that claim 0/20 and flags it in the report.
Filling stubs is the cheapest accuracy lever this pack has.

## Recommended persona families

When this pack is active, the persona recommender (Step 4a) leans toward:
- salesforce-sales/solution-engineer
- salesforce-sales/business-value-consultant
- salesforce-sales/enterprise-architect
- salesforce-customer/economic-buyer
- salesforce-customer/champion
- salesforce-customer/infosec-privacy-officer
- generic/technical/ai-agent-architect

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources, suggest these first:
- https://help.salesforce.com/s/articleView?id=sf.agentforce_overview.htm
  (verify before use — Agentforce help-page slugs have changed at least once)
- https://www.salesforce.com/agentforce/
- https://architect.salesforce.com/decision-guides
  (general decision-guide hub; pick the agent/AI guide currently published)
- https://trailhead.salesforce.com/content/learn/modules/agentforce-quick-look
  (verify exact module slug)
- https://developer.salesforce.com/docs/einstein/genai/guide/agent-builder.html
  (verify before use — developer docs path for agent-builder moves)
- https://help.salesforce.com/s/articleView?id=sf.einstein_trust_layer.htm
- https://www.salesforce.com/platform/data/

## Common sales-conversation pitfalls

1. Quoting Agentforce on SKU price only and ignoring the consumption envelope — the
   customer's CFO will model it and come back with the real number, and the deal will
   stall on a credibility hit.
2. Promising the agent will "just read all your data" without walking the customer
   through sharing, FLS, and the agent user's permission set — when the demo over-shares
   or under-shares, trust collapses fast.
3. Treating Data Cloud as a footnote when the use case clearly needs cross-cloud or
   unstructured-data grounding — better to surface it as a required ingredient early
   than to discover it during scoping.
4. Demoing a customer-facing agent without a credible escalation / human-handoff story
   — the buyer's Service VP will ask, and "we're working on it" is a deal-slower.
5. Confusing Agentforce, Einstein Copilot (the prior name), prompt-builder, and
   model-builder when talking to a technical buyer — the platform team will read
   imprecision as a knowledge gap and ask for an SE swap.

## When to combine with an industry pack

Pair with `financial-services` when the buyer is a bank, wealth manager, or insurer —
the Compliance / AML and Wealth Advisor personas become load-bearing because agent
actions on regulated records need a defensible audit story. Pair with
`healthcare-life-sciences` when the use case touches PHI — the HIPAA Privacy Officer
will dominate the InfoSec conversation and the Trust Layer story has to be told
precisely. Pair with `public-sector` when the buyer is government — FedRAMP boundaries,
data-residency, and the limited set of Agentforce features in Government Cloud Plus
shape what is actually sellable.

## Competitive Triggers

Injected into AE, SE, and Industry Specialist personas when competitive
positioning is relevant to the content under review. Each entry gives the
persona enough context to surface competitive risk and arm the AE/SE with
a response.

### vs. Microsoft Dynamics 365 + Copilot for Sales
- **Their pitch:** "You already have M365 — Copilot for Sales is included in your EA. Why pay for a separate CRM?"
- **Our counter:** Platform depth. Dynamics CRM is adequate for pipeline tracking but lacks the platform-level extensibility (Flow, Apex, LWC, AppExchange ecosystem) and the industry-specific data models (Health Cloud, Financial Services Cloud, etc.) that let customers build differentiated processes — not just track them. Copilot for Sales summarizes emails; Agentforce executes multi-step business processes autonomously with guardrails.
- **Demo trap:** They'll demo Copilot generating a meeting summary inside Outlook/Teams. Looks impressive. The catch: it's a summarization layer, not an action layer — it can't execute a multi-step workflow, can't enforce business logic, can't operate within a governed trust boundary with topic/action/guardrail architecture.
- **Customer signal:** "We're already paying for M365 E5 so the CRM is basically free." / "Our IT team prefers to standardize on Microsoft."
- **AE response:** "The CRM is free the way a hotel's free breakfast is free — it's included, but it's not why you chose the hotel. The question is whether your sales process is a differentiator or a commodity. If it's a differentiator, you need a platform that lets you build differentiated process, not just track activity."

### vs. ServiceNow (Customer Service Management / Workflow)
- **Their pitch:** "We're a workflow platform — CRM is just one workflow. Why not unify service, IT, and operations on one platform?"
- **Our counter:** ServiceNow is excellent for internal IT service management and operational workflows. For customer-facing service (omnichannel, case management, knowledge, field service, self-service), Salesforce Service Cloud has 20+ years of customer-facing service depth — Einstein case routing, Omni-Channel, Knowledge, Field Service with mobile offline, and now Agentforce service agents. ServiceNow's CSM module is a bolt-on to their ITSM heritage, not their center of gravity.
- **Demo trap:** They'll demo a unified portal where IT tickets, customer cases, and operational requests all flow through one system. Looks clean. The catch: it optimizes for the AGENT's experience (one queue), not the CUSTOMER's experience (channel of choice, personalized, proactive).
- **Customer signal:** "We already use ServiceNow for IT — why not extend it to customer service?" / "Our ops team wants one platform for all workflows."
- **AE response:** "ServiceNow is outstanding for internal workflows — ITSM, change management, asset management. The question is: do your CUSTOMERS care about your internal workflow platform, or do they care about getting their issue resolved in the channel they chose, by an agent (human or AI) that knows their history? That's what Service Cloud is purpose-built for."

### vs. HubSpot (Commercial / Mid-Market)
- **Their pitch:** "All-in-one marketing + sales + service for a fraction of the price. Easy to set up, free tier to start."
- **Our counter:** HubSpot is excellent for companies where marketing owns the funnel and sales is order-taking. For companies where sales is a strategic, consultative motion — multi-stakeholder deals, complex pricing (CPQ), territory management, partner channels, enterprise-grade security — HubSpot hits a ceiling. The ceiling comes at ~$50M ARR or ~200 reps or the first time the CRO asks for forecasting that actually works.
- **Demo trap:** They'll demo the all-in-one simplicity — marketing automation, CRM, and service desk in one UI with one bill. Looks frictionless. The catch: it's frictionless because it's simple, and simple means it lacks CPQ, advanced forecasting, territory management, role hierarchy/sharing, approval workflows, and the AppExchange ecosystem for industry-specific needs.
- **Customer signal:** "We started on HubSpot and it's fine for what we need." / "The price difference is hard to justify." / "Our marketing team chose HubSpot and now sales is on it too."
- **AE response:** "HubSpot is outstanding for the first stage of growth — when marketing drives leads and sales closes them in a simple cycle. The question is: has your sales motion outgrown that? If you need CPQ, territory management, multi-currency, or enterprise security — those aren't HubSpot problems to solve, they're Salesforce problems to solve. And switching later costs more than starting right."

### vs. In-House Build (CTO/Engineering-Driven)
- **Their pitch:** "We have engineers. We know our business better than any vendor. We'll build exactly what we need."
- **Our counter:** You absolutely can build a CRM. The question is: should your engineers spend 18 months building pipeline management, forecasting, and activity capture — or should they spend that time building the things that differentiate YOUR business? Salesforce is infrastructure so your engineers can focus on your product, not your sales tooling. Also: the CTO leaves. The engineers who built it leave. Custom CRM becomes legacy CRM in 3 years.
- **Demo trap:** There is no vendor demo to trap. The trap is the CTO's confidence: "We'll build it in a quarter." The counter is time-to-value: "How long until your homegrown CRM has mobile, offline, AI-powered forecasting, an AppExchange ecosystem, and SOC 2 compliance?" The answer is: never, because those aren't priorities for a product engineering team.
- **Customer signal:** "We've been thinking about building this ourselves." / "Our CTO thinks we can do better in-house." / "We have a homegrown system that works okay."
- **AE response:** "I respect that — your engineers are brilliant at building YOUR product. The question is opportunity cost: every sprint they spend on CRM is a sprint they DON'T spend on the product your customers pay for. Salesforce is the infrastructure layer so your team can focus where they add unique value."
