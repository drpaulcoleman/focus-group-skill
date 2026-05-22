# Media — Industry Pack

Media covers broadcasters, cable and streaming networks, publishers (newspaper, magazine, digital-native), music and audio (labels, streaming, podcasting), out-of-home, and the agencies and ad-tech vendors that sit between them and brands. The top pressures right now are the structural shift from linear advertising to digital and connected TV (with measurement still catching up), the consolidation and churn problem in subscription video and audio (acquiring cheaply is easy; retaining is the hard part), and the post-cookie identity transition forcing first-party-data and clean-room investment. Salesforce engages most often through Media Cloud (the rebranded and extended product covering advertising sales, subscriber lifecycle, and content/rights operations) paired with Marketing Cloud, Data Cloud, and increasingly Agentforce for customer service and ad operations. The typical buyer shape is a Chief Revenue Officer or SVP Ad Sales as economic buyer for the ad side, a Chief Subscription Officer or SVP D2C as economic buyer for the subscription side, and an SVP of Ad Operations or VP Subscriber Lifecycle as champion; CDO or Head of Audience is the data-side gatekeeper.

## Grounding prompt (injected into every persona)

### Ad-side vocabulary

Media customers speak in terms of advertisers, agencies, brand and direct deals, IOs (insertion orders), order management, ad servers (Google Ad Manager, FreeWheel, Magnite), DSPs and SSPs, programmatic vs guaranteed, linear vs digital vs CTV, makegoods, sell-through and fill rate, CPMs, viewability, IAB taxonomy, and increasingly clean rooms (LiveRamp, Snowflake, AWS Clean Rooms, Habu, InfoSum).

### Subscription-side vocabulary

On the subscription side they speak in terms of paywalls (hard, metered, freemium), ARPU, churn, win-back, bundling, household sharing, and content windowing.

### Rights-side vocabulary

On the content side they speak in terms of rights, windows, territories, holdbacks, residuals, and royalty accounting. Media Cloud's load-bearing capabilities are Advertising Sales Management (proposals, orders, revenue recognition tied to delivery), Subscriber Lifecycle Management, and content/rights workflows.

### Honest objections — broadcast / cable TV

The honest objections this industry raises against generic SaaS pitches are: (1) "Our ad-ops workflow is already shaped by Operative or Salesforce Advertising Sales Management — show me how this changes that without breaking month-end revenue recognition"; (2) "Subscription churn is a content and pricing problem, not a CRM problem — what do you actually do that Recurly, Zuora, or our in-house billing system doesn't?"; (3) "Our first-party-data story is in a clean room — how do you integrate without me having to move identity into your platform?"

### Honest objections — streaming SVOD/AVOD/FAST

Subscriber-acquisition-cost vs ARPU vs churn is the entire P&L; content-spend amortization is the CFO conversation; the bundle-vs-standalone-tier debate is permanent; AI personalization that surfaces low-engagement content is reversed within a sprint.

### Honest objections — publishing (digital news / magazines)

Editorial independence is a contractual firewall not a value statement; subscriber-churn-on-paywall-tighten is the existential balance; AI-summarization that touches news copy needs human-in-the-loop with audit trail; the trust-decay curve from a single botched correction is asymmetric.

### Honest objections — music & audio (label / streaming / podcasting)

Royalty splits + collection are the operational backbone; A&R judgment cannot be ML-replaced and any tool that implies it gets executive resistance; catalog rights are contractually fragmented and any unified-view promise must respect counterparty NDAs.

### Honest objections — gaming

Live-ops cadence governs everything (the weekly content drop is sacred); player community management requires native-tool fluency the vendor probably doesn't have; loot-box / monetization compliance varies by jurisdiction and any GTM tool must respect the per-country rule set.

### Honest objections — sports rights-holder / league

Broadcast-rights deals are the underlying revenue engine and govern every other commercial choice; team / franchise relationships are political not transactional; betting-data partnerships are the new monetization vector with their own regulatory overlay.

### Honest objections — ad tech / DSP-SSP

RTB latency-budget is the architectural constraint (any feature that breaks the latency budget is unshippable); identity-resolution post-cookie is the permanent ground-shift; clean-room interop is the trust pillar that determines partnership eligibility.

### Regulatory frame

Compliance and regulatory realities to keep in mind: the FCC governs broadcast licensing, EEO, and political advertising disclosure in the US; the FTC enforces endorsement and influencer-disclosure rules and has been increasingly active on dark-pattern subscription cancellation; the EU's Digital Services Act (DSA) imposes content-moderation, advertising-transparency, and recommender-system obligations on large platforms; GDPR, CPRA, and the rolling US state privacy laws shape every audience-data conversation; COPPA constrains data on under-13 audiences. The dominant Salesforce footprint is Media Cloud + Marketing Cloud + Data Cloud, with Service Cloud for subscriber care and MuleSoft to ad servers and billing systems. Decision-making splits cleanly between an ad-side committee (Ad Sales, Ad Ops, Finance) and a subscription-side committee (D2C, Marketing, Product, Customer Care); selling to one without acknowledging the other is a fast way to lose credibility with the CRO.

## Customer-type classifier (which sub-industry — broadcast, streaming, publishing, music, gaming, sports, or ad tech?)

Media is unusually multi-axis: a broadcaster, a streamer, a publisher, a music label, a games studio, a sports league, and an ad-tech vendor share vocabulary but have structurally different P&Ls, regulators, and buying committees. The skill should detect which sub-type the customer belongs to and weight the panel accordingly. Detection signals (case-insensitive substring match on the customer name + the prompt body; first hit wins; ties resolved by asking one clarifying question).

**Broadcast / cable TV** — leads with `ad-sales-director`, `audience-analytics-lead`, `content-acquisition-lead`; must-include `editorial-newsroom-lead` when a news division is in scope (network news, local news, cable news, sports-news desks).
- Customer-name patterns: networks: NBC, NBCUniversal, ABC, CBS, Fox, Paramount Global, Warner Bros. Discovery, Disney *(TV side)*; cable: Comcast NBCUniversal, Charter, Cox Media; local: Sinclair Broadcast Group, Tegna, Gray Television, Hearst Television, Scripps; substrings: "Broadcasting", "Television Group", "Networks" *(broadcaster)*, "Studios" *(broadcast)*.
- Prompt patterns: `upfront`, `scatter`, `linear`, `addressable TV`, `Nielsen`, `currency`, `OTT/CTV split`, `Operative`, `Wide Orbit`, `traffic system`, `make-good`.

**Streaming SVOD / AVOD / FAST** — leads with `subscriber-experience-lead`, `ad-sales-director` *(when ad tier)*, `audience-analytics-lead`.
- Customer-name patterns: pure streamers: Netflix, Hulu, Disney+, Max *(Warner)*, Peacock, Paramount+, Apple TV+, Prime Video, Tubi, Pluto TV, The Roku Channel, Crackle, freevee; substrings: "+", "Streaming" *(corporate context)*.
- Prompt patterns: `SVOD`, `AVOD`, `FAST`, `subs`, `churn`, `subscriber lifecycle`, `paid tier`, `ad-supported tier`, `click-to-cancel`, `California ARL`, `binge`, `windowing`.

**Publishing (digital news / magazines)** — leads with `subscriber-experience-lead`, `rights-licensing-manager`, `audience-analytics-lead`; must-include `editorial-newsroom-lead` (the editorial-independence firewall is non-negotiable here).
- Customer-name patterns: news: New York Times, NYT, Wall Street Journal, WSJ, Washington Post, Bloomberg, Reuters *(media side)*, Dow Jones, Financial Times, FT, The Atlantic, The Guardian; magazines: Condé Nast, Hearst, Meredith *(Dotdash Meredith)*, Time Inc., News Corp *(publishing arm)*; substrings: "Publishing", "Publications", "Media Group" *(publishing context)*, "News", "Press" *(publisher)*.
- Prompt patterns: `paywall`, `metering`, `subscription paywall`, `dynamic paywall`, `Piano`, `Tinypass`, `Zephr`, `NYT model`, `WSJ model`, `digital subscriptions`, `newsletter`, `commenting platform`, `editorial`.

**Music & audio (label / streaming / podcasting)** — leads with `rights-licensing-manager`, `audience-analytics-lead`, `content-acquisition-lead`.
- Customer-name patterns: labels: Universal Music Group, UMG, Sony Music Entertainment, Warner Music Group, WMG, Concord, BMG, Live Nation, Spotify, Apple Music *(distribution context)*, Pandora, SiriusXM, iHeartMedia, Audible, Wondery, SoundCloud; substrings: "Music", "Records", "Sound" *(label)*, "Audio" *(label/podcast)*.
- Prompt patterns: `PRO`, `ASCAP`, `BMI`, `SESAC`, `SoundExchange`, `mechanical royalties`, `master rights`, `publishing rights`, `sync`, `A&R`, `catalog`, `MLC`, `streaming royalties`, `podcast network`.

**Gaming** — leads with `subscriber-experience-lead` *(games-as-service sub-profile)*, `audience-analytics-lead`.
- Customer-name patterns: publishers: Activision Blizzard, EA, Electronic Arts, Take-Two Interactive, Ubisoft, Bandai Namco, Sega, Square Enix, Capcom, Konami; developers: Riot Games, Epic Games, Valve, Bungie, FromSoftware; mobile: Supercell, King, Niantic, Scopely, AppLovin; substrings: "Games", "Interactive", "Entertainment" *(games context)*, "Studios" *(games context)*.
- Prompt patterns: `live ops`, `LiveOps`, `monetization`, `IAP`, `battle pass`, `gacha`, `DAU`, `MAU`, `ARPPU`, `engagement`, `seasonal content`, `ESRB`, `loot box`.

**Sports rights-holder / league** — leads with `content-acquisition-lead`, `rights-licensing-manager`, `ad-sales-director`.
- Customer-name patterns: leagues: NFL, NBA, MLB, NHL, MLS, NCAA, PGA Tour, LIV Golf, F1, FIFA, UEFA, IOC, USOPC; teams: any sports franchise; networks: ESPN, NFL Network, NBA TV, MLB Network, Tennis Channel, Golf Channel; substrings: "League", "Conference" *(sports)*, "Sports" *(rights holder)*, "Athletic".
- Prompt patterns: `rights deal`, `local rights`, `national rights`, `RSN`, `over-the-top rights`, `media rights`, `revenue sharing`, `salary cap`, `season ticket`, `sponsorship`, `naming rights`, `NIL` *(college)*.

**Ad tech / DSP / SSP** — leads with `ad-sales-director`, `audience-analytics-lead`.
- Customer-name patterns: DSPs: The Trade Desk, MediaMath, DV360 *(Google)*, Yahoo DSP, Amazon DSP; SSPs: Magnite, PubMatic, OpenX, Sharethrough; ad servers: Google Ad Manager, FreeWheel *(Comcast)*; identity: LiveRamp, ID5; verification: DoubleVerify, Integral Ad Science, IAS; substrings: "Ad Tech", "Programmatic", "Ad Platform".
- Prompt patterns: `RTB`, `header bidding`, `open bidding`, `programmatic-guaranteed`, `OMSDK`, `MRC`, `viewability`, `cookieless`, `Privacy Sandbox`, `IDFA`, `Topics API`, `clean room`.

**Ambiguous signals** (a name matches multiple groups — e.g., Disney spans broadcast, streaming, and sports rights; or no name was given) — ask one clarifying question rather than guess: *"Is the customer primarily a broadcaster / cable network, a streaming service, a publisher, a music/audio company, a games studio, a sports rights-holder, or an ad-tech vendor?"* Pick the closest fit and load only that sub-group's leading personas.

## Recommended industry-specific persona files

Each industry pack contributes 3-5 industry-specific personas at `personas/industries/<slug>/<role-slug>.md`. For this pack, the personas are:

- ad-sales-director.md — Owns the advertising revenue number; cares about pipeline, proposal speed, and the ad-ops handoff.
- rights-licensing-manager.md — Manages content rights, windows, territories, and avoidance of accidental over-licensing.
- subscriber-experience-lead.md — Owns the D2C subscriber lifecycle from acquisition through retention and win-back.
- content-acquisition-lead.md — Negotiates and tracks content deals, talent agreements, and renewals.
- audience-analytics-lead.md — Owns first-party data, segmentation, clean-room operations, and measurement.
- editorial-newsroom-lead.md — Owns the journalism and the editorial-independence firewall between newsroom and commercial; carries the veto that blocks AI-summarization, recommender, and content-tagging proposals that conflate editorial judgment with commercial signals.

Pack now ships 6 personas. For 5-cap panels, swap based on engagement type: drop Editorial when the engagement is ad-side (ad sales, ad ops, programmatic, ad-tech integration); keep Editorial when it's sub-side (paywall, subscriber lifecycle, D2C retention) or content-recommendation (recommender systems, personalization, AI-on-content).

## Recommended product-pack pairings

### For broadcast / cable TV

When this industry is active, these product packs are most commonly relevant:
- marketing-cloud — Subscriber lifecycle journeys, win-back, paywall offers, and audience activation; load-bearing for D2C.
- data-cloud — First-party identity unification and clean-room interop; the post-cookie story depends on it.
- service-cloud — Subscriber care, billing dispute handling, and ad-client service desks.
- sales-cloud — Advertising Sales Management rides on Sales Cloud; deal management for direct and programmatic-guaranteed.
- revenue-cloud — Multi-platform deal construction for ad sales and direct deals; explicitly named as load-bearing by the Ad Sales Director persona.
- commerce-cloud — D2C subscription checkout for publishing and music.
- mulesoft — Integration to ad servers, billing/subscription platforms, and content management systems is almost always in scope.

### For streaming SVOD/AVOD/FAST

- marketing-cloud — Sub-acquisition + lifecycle.
- data-cloud — Viewer-360 + recommender feeds.
- commerce-cloud — Sub checkout + payment.
- service-cloud — Sub-care + cancellation.
- revenue-cloud — Multi-tier sub mgmt.

### For publishing

- marketing-cloud — Newsletter as primary acquisition vector.
- commerce-cloud — Paywall + sub checkout.
- data-cloud — Reader-360.
- service-cloud — Sub-care.
- experience-cloud — Commenter community + premium tier portal.

### For music / audio

- sales-cloud — Label A&R + artist mgmt.
- revenue-cloud — Royalty complexity.
- data-cloud — Catalog rights aggregation.
- marketing-cloud — Artist + label-side marketing.

### For gaming

- marketing-cloud — Live-ops player engagement.
- service-cloud — Player support + safety.
- data-cloud — Player-360.
- commerce-cloud — In-game store + tiered subs.

### For sports rights-holder / league

- sales-cloud — Sponsorship + rights deals.
- experience-cloud — Team/franchise portal.
- marketing-cloud — Fan engagement.
- loyalty-management — Fan-loyalty program.

### For ad tech / DSP-SSP

- sales-cloud — Publisher + advertiser account mgmt.
- revenue-cloud — Complex media contracts.
- data-cloud — Clean-room interop.
- experience-cloud — Partner-API documentation portal.

## URL seed-list (for /download grounding)

- https://www.salesforce.com/industries/media-entertainment/
- https://www.iab.com/ (IAB; ad taxonomy, identity, and post-cookie standards)
- https://www.fcc.gov/media (FCC media bureau; broadcast licensing and political advertising)
- https://www.ftc.gov/business-guidance/advertising-marketing (FTC endorsement and subscription-cancellation guidance)
- https://digital-strategy.ec.europa.eu/en/policies/digital-services-act-package (DSA)
- https://www.nab.org/ (National Association of Broadcasters)
- https://www.motionpictures.org/ (MPA; Motion Picture Association)
- https://www.riaa.com/ (RIAA; Recording Industry Association of America)
- https://www.ifpi.org/ (IFPI; international recorded-music industry body)
- https://www.theesa.com/ (ESA; Entertainment Software Association — gaming)
- https://digitalcontentnext.org/ (DCN; Digital Content Next — premium publishers)
- https://www.mediaratingcouncil.org/ (MRC; Media Rating Council — measurement accreditation)
- https://www.ana.net/ (ANA; Association of National Advertisers)

## Common sales-conversation pitfalls in this industry

1. Pitching subscription lifecycle features to an ad-side buyer (or vice versa) — the two sides have different P&Ls, different tooling, and different champions; conflating them signals you haven't done discovery.
2. Treating the post-cookie identity story as a Data Cloud feature talk rather than a clean-room interop conversation — the CDO will know the difference within two minutes.
3. Demoing ad sales without showing the ad-ops handoff and revenue-recognition tie-out — Finance will surface this in the next call and the demo will need to be redone.
4. Promising AI-generated content without addressing rights and talent agreements — guild contracts (SAG-AFTRA, WGA, DGA), name-and-likeness clauses, and underlying-rights warranties shape what can be auto-generated; the General Counsel will block the program if these aren't accounted for.
5. Pitching recommender features without addressing DSA recommender-system audit obligations — large platforms operating in the EU owe transparency about main parameters, must offer a non-profiling option, and must allow vetted-researcher data access; "we use AI to recommend content" without that scaffolding fails the next compliance review.
6. Glossing over FTC endorsement-disclosure updates — the 2023 Endorsement Guides revisions tightened rules for influencer disclosures, AI-generated reviews, and incentivized testimonials; brand-side and creator-side workflows must capture and surface disclosures or the FTC posture becomes a liability.
7. Ignoring the legacy ad-sales platform (Operative, FreeWheel sales, in-house) the customer already runs — replacement vs coexistence has to be addressed explicitly or the deal stalls in architecture review.

## Regulatory landscape (one paragraph)

US broadcasters operate under FCC rules covering licensing, ownership caps, EEO, children's programming, and political advertising disclosure (with sponsorship-identification rules tightened in recent years). The FTC has been active on endorsement disclosure (the 2023 update to the Endorsement Guides) and on subscription-cancellation friction under the proposed and partially-finalized "click-to-cancel" rule. In the EU, the Digital Services Act imposes content-moderation transparency, advertising-transparency, and recommender-system obligations on large platforms, with stiff penalties for non-compliance; the Digital Markets Act adds gatekeeper obligations relevant to the largest platforms. Privacy law (GDPR, CPRA, and a growing list of US state laws) shapes every audience-data, consent, and cross-context advertising conversation, with COPPA adding an additional layer for under-13 audiences. Personas should treat these as practical constraints on data flows, consent capture, and ad-targeting design.
