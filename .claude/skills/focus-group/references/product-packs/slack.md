# Slack — Product Pack

Slack is a channel-based messaging platform that Salesforce acquired in 2021 and now positions as the "work operating system" and conversational front end for Customer 360. The primary buyer is usually a CIO, VP of IT, or a digital-workplace leader; the daily users are everyone in the company, with power-user pockets in sales, support, and engineering. Slack's main differentiators against Microsoft Teams are its third-party app ecosystem (thousands of apps with deep integrations), Slack Connect for shared channels with customers and partners, and a developer platform suited to building lightweight workflow apps. The typical Salesforce sales motion bundles Slack with a Sales Cloud, Service Cloud, or Data Cloud deal as the collaboration layer where Salesforce records, alerts, and AI summaries surface in the flow of work. Slack AI (search, channel recaps, thread summaries) is sold as an add-on SKU on top of paid Slack tiers, not as a free capability. Slack Enterprise Grid is the SKU for large multi-workspace customers and is required for most serious compliance, DLP, and EKM stories.

## Grounding prompt (injected into every persona)

Slack is a paid SaaS messaging product with Free, Pro, Business+, and Enterprise Grid tiers. Most enterprise features customers ask about — SSO via SAML, audit logs, DLP integrations, Enterprise Key Management, HIPAA support, cross-workspace channels, and admin APIs — require Enterprise Grid, not the lower paid tiers. Slack Connect lets two organizations share a channel without leaving their own Slack; it requires both sides to be on a paid plan and admin approval, and it is the most common "land" pattern when a Salesforce customer wants to collaborate with vendors or partners. The Slack developer platform supports modal-based apps, slash commands, Block Kit UI, Workflow Builder (no-code), and the newer next-generation platform built around Deno-hosted functions and Workflow Builder steps. Slack AI is a paid add-on; customers should not assume "Slack has AI" means it is included in their seat price.

The three most common honest objections sales conversations hit: (1) "we already pay for Teams as part of Microsoft 365, why pay again" — the answer is integration depth and Slack Connect, not feature parity; (2) "our InfoSec team is nervous about external channels and data leakage" — legitimate concern that Enterprise Grid, DLP partners, and channel-posting policies address but do not eliminate; (3) "users will not adopt yet another tool" — real, and the answer is usually a phased rollout starting with one or two high-pain workflows, not a big-bang migration. The three complexities that get glossed: per-message cost models for high-volume bot postings can surprise customers on usage-based downstream services; Slack's retention policy is per-workspace and gets messy on Enterprise Grid with multiple workspaces; and the Salesforce-Slack integration ("Sales Elevate", Sales Cloud for Slack, Service Cloud for Slack) is genuinely useful but each app has its own setup, license requirements, and learning curve — it is not one switch.

## Recommended persona families

When this pack is active, the persona recommender leans toward:
- salesforce-sales/solution-engineer
- salesforce-sales/account-executive
- salesforce-customer/champion
- salesforce-customer/infosec-privacy-officer
- salesforce-customer/end-user-power-user
- generic/stakeholder/compliance-officer
- generic/executives/cio

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources, suggest these first:
- https://slack.com/help
- https://api.slack.com/docs
- https://slack.com/pricing
- https://slack.com/help/articles/115004151203-Slack-Connect-guide (verify exact URL before use)
- https://trailhead.salesforce.com/content/learn/modules/slack-basics
- https://slack.com/trust/compliance
- https://api.slack.com/automation (next-gen platform docs; verify before use)

## Common sales-conversation pitfalls

1. Promising Enterprise Grid features (DLP, EKM, audit logs, HIPAA) to a prospect who is only being quoted Business+ — the feature lives behind a SKU step-up the AE has not priced in.
2. Pitching Slack AI as included; it is a paid add-on and not available on every region or tier at parity.
3. Conflating Slack Connect with guest channels — Connect requires both orgs on a paid plan, while multi-channel guests are a different licensing model with different InfoSec implications.
4. Demoing the Salesforce-Slack integration without confirming the prospect has the right Sales Cloud or Service Cloud edition and the Slack admin permissions to install the app.
5. Skipping the change-management conversation when the prospect is a heavy Microsoft 365 shop; users default back to Teams unless workflows are deliberately moved.

## When to combine with an industry pack

Strongest fit with `technology` (engineering-led orgs already lean Slack-native and the developer platform story resonates), `professional-services` (Slack Connect with clients is a wedge), and `financial-services` (Enterprise Grid plus compliance partners is the only credible pitch — combine carefully and lead with the InfoSec story).
