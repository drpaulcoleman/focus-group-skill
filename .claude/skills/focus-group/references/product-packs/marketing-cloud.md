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
| **Marketing Cloud editions — SFMC vs. Marketing Cloud Growth/Advanced** | These are different products with different roadmaps, different data models, and different feature sets — confirm which one the customer's deal is for before any commitment. The salesforce.com/marketing/ marketing page is Akamai-blocked from automated retrieval; cite the customer's Order Form. Per the help docs, "Marketing Cloud Engagement" is the new name for the legacy SFMC/ExactTarget stack. | https://www.salesforce.com/marketing/ | TODO — public marketing page Akamai-blocked; cite customer Order Form for SKU comparison. Re-attempted with real Chrome 2026-05-22 — still blocked. |
| **Email Studio — capabilities and CAN-SPAM enforcement** | Verbatim from help: "With Email Studio, build and send personalized email from basic newsletters to the most complex campaigns. Deliver promotional, transactional, and triggered messages." Send Classifications enforce CAN-SPAM compliance: "Salesforce requires that all Engagement messages comply with CAN-SPAM, regardless of the sender or recipient destination country. Because Salesforce is headquartered in the United States, messages sent from Engagement must comply with US law." Send classifications also include "Delivery Profile, Sender Profile, CAN-SPAM (Controlling the Assault of Non-Solicited Pornography and Marketing) classification" components. The Send Classification CAN-SPAM dimension is "Commercial" or "Transactional" — for commercial messages "we check for the presence of an unsubscribe link"; for transactional sends "we don't check for the presence of an unsubscribe link." | https://help.salesforce.com/s/articleView?id=sf.mc_es_send_classifications.htm | verified 2026-05-22 |
| **Sending limits and reputation** | Send-volume limits are tied to edition + IP reputation + sender authentication (SPF/DKIM/DMARC) — never quote raw send caps without context. The previously-cited slug `sf.mc_es_send_email_overview.htm` 404s. Per the Send Classifications doc, deliverability is enforced via Delivery Profile + Sender Profile pairing, with List Detective maintaining "information on email addresses and domains that could cause deliverability problems for your email sends" including "email addresses that are known spam traps." Specific edition send caps require the customer's contract; deliverability scaling is handled via IP-warm program with Salesforce Deliverability team. | https://help.salesforce.com/s/articleView?id=sf.mc_es_email_studio.htm | verified 2026-05-22 (Email Studio capabilities verified; specific send caps remain edition/contract-specific) |
| **Compliance — CAN-SPAM / CASL / GDPR / TCPA** | Platform provides tools (preference centers, suppression lists, consent capture) but compliance is the customer's responsibility; per the Send Classifications doc: "Salesforce requires that all Engagement messages comply with CAN-SPAM, regardless of the sender or recipient destination country. Because Salesforce is headquartered in the United States, messages sent from Engagement must comply with US law. Also, US-based ISPs with a strong international presence, such as Yahoo and Hotmail, similarly require that messages received comply with the law. These guidelines comply with best practice standards applied by most ISPs and email receivers worldwide." Disclaimer: "This information isn't legal advice. Talk to your legal counsel for the proper application for your organization." The previously-cited slug `sf.mc_overview_data_protection.htm` 404s. | https://help.salesforce.com/s/articleView?id=sf.mc_es_send_classifications.htm | verified 2026-05-22 (CAN-SPAM coverage verified; CASL/GDPR/TCPA-specific help slugs not located in this pass) |
| **Journey Builder — entry sources and edition compatibility** | Verbatim from help: "Journey Builder is a campaign planning tool in Marketing Cloud Engagement that enables you to design and automate campaigns that guide customers through their journey with a brand." Edition-compatibility table from the page: "Core / Advanced — Compatibility: Yes; Required Version: Marketing Cloud Connect/V5"; "Enterprise 1.0 — Parent Account: No, On Your Behalf (OYB) Accounts: No, Lock & Publish Accounts: Yes" with the caveat "Sending from the top level of Enterprise 1.0 isn't supported"; "Enterprise 2.0 — Compatibility: Yes; Known Issues: Can't copy journeys from parent business units to child business units." Entry sources include Data Extensions, API events, schedule, and Salesforce data events. | https://help.salesforce.com/s/articleView?id=sf.mc_jb_journey_builder.htm | verified 2026-05-22 |
| **Mobile / SMS — MobilePush included; channel enablement** | Verbatim from help: "MobilePush is included in Corporate and Enterprise editions. These prerequisites are required before push notifications can be sent to devices from Marketing Cloud Engagement." MobilePush capabilities listed: "Manage segmented audiences of mobile contacts. Send targeted and personalized push notifications. Send inbox messages. Use geofence and beacon messaging for location-based campaigns." MobilePush integrates with Automation Studio and Journey Builder via separate enablement: "To use MobilePush with Journey Builder, complete these prerequisites and review the personalization considerations." SMS, WhatsApp, and other channels carry separate carrier relationships and compliance requirements (TCPA, CTIA short-code rules). | https://help.salesforce.com/s/articleView?id=sf.mc_mp_mobilepush.htm | verified 2026-05-22 |
| **Marketing Cloud Personalization (formerly Interaction Studio)** | Verbatim from help: "Marketing Cloud Personalization provides real-time, scalable, cross-channel personalization and AI to complement Marketing Cloud Engagement's robust customer data, audience segmentation, and engagement platform." Web tracking requirements: "For proper web tracking, the Marketing Cloud Personalization module of the Salesforce Interactions SDK requires native Promise support in the end user's browser. Most browsers support this functionality. However, Internet Explorer, which was retired in 2022, doesn't provide native Promise support." Ad-blocker caveat: "For web users who use ad blockers, an ad blocker set to highly restrictive settings can block personalized experiences." Separately licensed; web/mobile personalization requires SDK implementation by customer's web team. | https://help.salesforce.com/s/articleView?id=sf.mc_pers_intro.htm | verified 2026-05-22 |
| **Data Cloud (Data 360) + Marketing Cloud integration** | Data Cloud audiences can be activated in Marketing Cloud Growth/Advanced; legacy SFMC integration is via the Salesforce Audience connector with specific patterns and limits. The previously-cited slug `sf.c360_a_marketing_cloud_audiences.htm` 404s; from the Forecasting doc verified in this pass: "As of October 14, 2025, Data Cloud has been rebranded to Data 360. During this transition, you may see references to Data Cloud in our application and documentation. While the name is new, the functionality and content remains unchanged." Activation patterns/limits require deeper navigation in the Data Cloud help tree (canonical activation help slug not located in 4 URL guesses). | https://help.salesforce.com/s/articleView?id=sf.forecasts3_intro.htm | TODO — Data Cloud rebrand to Data 360 verified; canonical Marketing Cloud activation help slug not located, navigate from Data 360 root |
| **API limits — Marketing Cloud REST and SOAP** | The Marketing Cloud Engagement Developer Guide describes REST + SOAP APIs sharing "a common authentication mechanism based on OAuth 2." API rate limits are NOT enumerated on the public guide index page; specific rate-limit windows depend on edition and the customer's package configuration. Per the developer-guide root: "Packages... your starting point for all developer activity, used to connect to the API and extend functionality." Quote rate limits only against the customer's package configuration screen (Setup → Apps → Installed Packages) or Salesforce support. | https://developer.salesforce.com/docs/marketing/marketing-cloud/guide/index.html | TODO — public Developer Guide does not enumerate per-edition API rate limits; cite the customer's installed-package config or open a Salesforce case |
| **AMPscript / SSJS — execution context** | The Marketing Cloud Engagement developer guide describes AMPscript and SSJS as the "Programmatic Marketing Content" languages used "for personalizing landing pages, building applications, creating cross-channel templates/layouts, and handling messaging functions." Specific limits (compile time, payload size, function-call limits) are NOT enumerated on the guide index — the previously-linked `Personalization-Programming-Languages.html` returns 404, indicating the URL has been restructured. AMPscript runs server-side at send/render; SSJS executes server-side; both are sandboxed and cannot make arbitrary network calls except via documented HTTP functions. | https://developer.salesforce.com/docs/marketing/marketing-cloud/guide/index.html | TODO — programming-languages sub-page (`Personalization-Programming-Languages.html`) 404s; navigate from developer-guide TOC to current AMPscript/SSJS reference |

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
