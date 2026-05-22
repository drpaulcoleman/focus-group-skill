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
