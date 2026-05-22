# Marketing Cloud — Product Pack

Marketing Cloud is Salesforce's family of marketing products: Marketing Cloud Engagement
(the former ExactTarget — email, mobile, journeys, automation studio), Marketing Cloud
Account Engagement (the former Pardot — B2B marketing automation), Marketing Cloud
Personalization (the former Interaction Studio — real-time web personalization),
Marketing Cloud Intelligence (the former Datorama — cross-channel reporting), and the
newer Marketing Cloud Growth / Advanced editions that sit on the core Salesforce
Platform with Data Cloud underneath. The primary buyer is the CMO or VP Marketing; the
primary users are campaign managers, marketing operations, email developers, and
increasingly analytics. Sales teams should lean on three honest differentiators: the
scale and deliverability of the email infrastructure for high-volume B2C senders; the
depth of journey orchestration across channels; and the Data Cloud + Agentforce path for
marketers who want unified audiences and AI-drafted content. The typical sales motion
starts with a campaign or audience problem, runs a current-state audit (often across
multiple legacy stacks), and lands on either Engagement (B2C), Account Engagement (B2B),
or the newer Growth edition for SMB / mid-market.

## Grounding prompt (injected into every persona)

Marketing Cloud is not one product. Engagement (ExactTarget lineage) is the high-volume
B2C platform with Email Studio, Mobile Studio, Journey Builder, Automation Studio,
Content Builder, and Contact Builder, plus the SFMC scripting languages (AMPscript,
SSJS) and the data extension model — it is intentionally separate from the core
Salesforce Platform and has its own data layer, business units, and APIs. Account
Engagement (Pardot lineage) is the B2B automation product, runs on the Salesforce
Platform, and shares Sales Cloud's data model. Personalization (Interaction Studio
lineage) is the real-time web and in-app personalization product. Intelligence
(Datorama) is the cross-channel marketing-analytics product. The newer Marketing Cloud
Growth and Advanced editions are built natively on the core Platform and Data Cloud,
and behave more like Salesforce-native products than the legacy Engagement stack does.
Common deployment shapes are: a high-volume B2C Engagement rollout (often replacing
Responsys, Bronto, or a legacy ESP); an Account Engagement rollout for a B2B customer
with Sales Cloud already in place; a Personalization deployment for an e-commerce or
media site; a multi-product Marketing Cloud + Data Cloud + Sales Cloud unified-audience
project; and the newer Growth edition for SMB / mid-market.

The honest objections customers raise are: confusion over which Marketing Cloud is which
(and the renaming has not helped); deliverability and IP-warming complexity at scale (a
serious B2C sender needs a real deliverability conversation, not a feature demo); and
the gap between demoed journeys and what marketing-ops can actually build and maintain.
The hidden complexities sales conversations gloss are: Engagement uses Data Extensions,
not standard Salesforce objects — integrating it with Sales / Service Cloud requires
Marketing Cloud Connect or Data Cloud activation, and the customer's admin will discover
the seams; AMPscript and SSJS are platform-specific skills the customer often does not
have in-house and will need a partner for; Account Engagement's "Engagement History" and
B2B Marketing Analytics live in CRM Analytics and require their own licensing and skill;
sending-frequency, list health, and CAN-SPAM / CASL / GDPR compliance live with the
customer's marketing-ops team and the platform will not fix bad practice; and the legacy
SFMC and the newer native Marketing Cloud Growth / Advanced are different products with
different roadmaps — picking the wrong one is a multi-year decision.

## Platform Facts

This section is the verification source for accuracy-rubric factor 6
(platform-fact verification). Each row is either **filled** or a **TODO
stub**; the rubric scores 0 for any panel claim that lands on a stub
row. See [salesforce-crm-agentforce.md](salesforce-crm-agentforce.md)
for the canonical maintainer note.

| Topic | Fact | Source / verified | Last verified |
|-------|------|-------------------|---------------|
| **Marketing Cloud editions — SFMC vs. Marketing Cloud Growth/Advanced** | These are different products with different roadmaps, different data models, and different feature sets — confirm which one the customer's deal is for before any commitment | salesforce.com marketing cloud product page | TODO — verify naming, current as of release |
| **Sending limits and reputation** | Send-volume limits are tied to edition + IP reputation + sender authentication (SPF/DKIM/DMARC) — never quote raw send caps without context | help.salesforce.com sending best practices | TODO |
| **Compliance — CAN-SPAM / CASL / GDPR / TCPA** | Platform provides tools (preference centers, suppression lists, consent capture) but compliance is the customer's responsibility; the platform does not guarantee compliance | help.salesforce.com compliance | TODO |
| **Journey Builder — entry sources and event triggers** | Journey Builder supports multiple entry sources (Data Extension, API event, schedule, Salesforce Audience); event-triggered journeys have specific latency characteristics — confirm before promising real-time | help.salesforce.com Journey Builder | TODO |
| **Mobile / SMS — separate enablement** | SMS, MobilePush, WhatsApp, and other channels each have separate enablement, separate carrier relationships (for SMS), and separate compliance requirements | help.salesforce.com Mobile Studio | TODO |
| **Marketing Cloud Personalization (formerly Interaction Studio)** | Separately licensed; personalization on web/mobile requires SDK implementation by the customer's web team | help.salesforce.com MC Personalization | TODO |
| **Data Cloud + Marketing Cloud integration** | Data Cloud audiences can be activated in Marketing Cloud Growth/Advanced; legacy SFMC integration is via the Salesforce Audience connector with specific patterns and limits | help.salesforce.com integration | TODO |
| **API limits — REST and SOAP** | TODO — confirm current API call limits and rate-limit windows for the specific edition | developer.salesforce.com Marketing Cloud APIs | TODO |
| **AMPscript / SSJS — execution context and limits** | TODO — document current limits and security boundaries | help.salesforce.com AMPscript | TODO |

## Recommended persona families

When this pack is active, the persona recommender (Step 4a) leans toward:
- salesforce-sales/solution-engineer
- salesforce-sales/business-value-consultant
- salesforce-sales/industry-specialist
- salesforce-customer/economic-buyer
- salesforce-customer/champion
- salesforce-customer/infosec-privacy-officer
- generic/executives/cmo

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources, suggest these first:
- https://help.salesforce.com/s/articleView?id=sf.mc_overview.htm
  (verify before use — Marketing Cloud help has multiple article roots)
- https://www.salesforce.com/marketing/
- https://architect.salesforce.com/decision-guides
  (pick the marketing / data-activation guide currently published)
- https://trailhead.salesforce.com/content/learn/trails/marketing_cloud
  (verify exact trail slug)
- https://developer.salesforce.com/docs/marketing/marketing-cloud/guide/index.html
  (verify before use)
- https://help.salesforce.com/s/articleView?id=sf.pardot_basics.htm
  (verify before use — Account Engagement docs)

## Common sales-conversation pitfalls

1. Demoing Journey Builder without clarifying which Marketing Cloud edition the
   customer would buy — Engagement, Account Engagement, and Growth all have journey
   tooling and they are not interchangeable.
2. Treating Marketing Cloud Connect as a check-box integration — Data Extension
   design, sync direction, and field mapping are real implementation work and a
   frequent source of post-sale friction.
3. Quoting on contact volume without modeling sends, SMS / MMS messages, push
   notifications, and API calls — Engagement priced honestly is a multi-axis
   calculation.
4. Pitching AI content generation without addressing brand-voice guardrails and
   approval workflows the customer's brand team will require.
5. Conflating B2C personalization (Personalization, real-time, anonymous-to-known)
   with B2B nurture (Account Engagement, score and grade) — the buyer can tell when
   the rep does not know which world they are in.

## When to combine with an industry pack

Pair with `retail` or `consumer-goods` for high-volume B2C journeys, loyalty, and
trade-promotion-adjacent campaigns where Engagement and Personalization dominate. Pair
with `financial-services` for regulated marketing where consent, suitability, and
disclosure requirements force a tighter governance conversation. Pair with `media`,
`hotels-hospitality`, or `airlines-air-travel` for subscriber and guest journeys
where lifecycle marketing is the product, not a support function.
