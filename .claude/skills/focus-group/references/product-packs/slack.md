# Slack — Product Pack

Slack is a channel-based messaging platform that Salesforce acquired in 2021 and now positions as the "work operating system" and conversational front end for Customer 360. The primary buyer is usually a CIO, VP of IT, or a digital-workplace leader; the daily users are everyone in the company, with power-user pockets in sales, support, and engineering. Slack's main differentiators against Microsoft Teams are its third-party app ecosystem (thousands of apps with deep integrations), Slack Connect for shared channels with customers and partners, and a developer platform suited to building lightweight workflow apps. The typical Salesforce sales motion bundles Slack with a Sales Cloud, Service Cloud, or Data Cloud deal as the collaboration layer where Salesforce records, alerts, and AI summaries surface in the flow of work. Slack AI (search, channel recaps, thread summaries) is sold as an add-on SKU on top of paid Slack tiers, not as a free capability. Slack Enterprise Grid is the SKU for large multi-workspace customers and is required for most serious compliance, DLP, and EKM stories.

## Grounding prompt (injected into every persona)

Slack is a paid SaaS messaging product with Free, Pro, Business+, and Enterprise Grid tiers. Most enterprise features customers ask about — SSO via SAML, audit logs, DLP integrations, Enterprise Key Management, HIPAA support, cross-workspace channels, and admin APIs — require Enterprise Grid, not the lower paid tiers. Slack Connect lets two organizations share a channel without leaving their own Slack; it requires both sides to be on a paid plan and admin approval, and it is the most common "land" pattern when a Salesforce customer wants to collaborate with vendors or partners. The Slack developer platform supports modal-based apps, slash commands, Block Kit UI, Workflow Builder (no-code), and the newer next-generation platform built around Deno-hosted functions and Workflow Builder steps. Slack AI is a paid add-on; customers should not assume "Slack has AI" means it is included in their seat price.

The three most common honest objections sales conversations hit: (1) "we already pay for Teams as part of Microsoft 365, why pay again" — the answer is integration depth and Slack Connect, not feature parity; (2) "our InfoSec team is nervous about external channels and data leakage" — legitimate concern that Enterprise Grid, DLP partners, and channel-posting policies address but do not eliminate; (3) "users will not adopt yet another tool" — real, and the answer is usually a phased rollout starting with one or two high-pain workflows, not a big-bang migration. The three complexities that get glossed: per-message cost models for high-volume bot postings can surprise customers on usage-based downstream services; Slack's retention policy is per-workspace and gets messy on Enterprise Grid with multiple workspaces; and the Salesforce-Slack integration ("Sales Elevate", Sales Cloud for Slack, Service Cloud for Slack) is genuinely useful but each app has its own setup, license requirements, and learning curve — it is not one switch.

## Platform Facts

This section is the verification source for accuracy-rubric factor 6
(platform-fact verification). Each row is either **filled** or a **TODO
stub**; the rubric scores 0 for any panel claim that lands on a stub
row. See [salesforce-crm-agentforce.md](salesforce-crm-agentforce.md)
for the canonical maintainer note.

| Topic | Fact | Source / verified | Last verified |
|-------|------|-------------------|---------------|
| **Slack editions — Free / Pro / Business+ / Enterprise Grid / Enterprise+** | Each edition has different message-history retention defaults, different security/compliance features, and different admin capabilities. Most enterprise features customers ask about — SSO via SAML, SCIM, audit logs, DLP, Enterprise Key Management, HIPAA support — require Enterprise Grid (and EKM specifically requires the Enterprise+ tier as an add-on). Verify customer's edition before promising features. | https://slack.com/enterprise | verified 2026-05-22 |
| **Enterprise Grid — org-level admin scope** | Grid runs multiple workspaces under one organization with two distinct administrative layers: org-level (Org Primary Owner, Org Owners, Org Admins) for org-wide policies, and workspace-level (Workspace Primary Owner, Workspace Owners, Workspace Admins) scoped to a single workspace. Enterprise plans also offer granular system roles (Security Admin, Analytics Admin, Users Admin) and custom roles for delegated permissions. Retention policy is per-workspace and gets messy on Grid with multiple workspaces. | https://slack.com/help/articles/360018112273-Types-of-roles-in-Slack | verified 2026-05-22 |
| **Enterprise Grid — multi-workspace channels and org-wide channels** | Grid supports both org-wide multi-workspace channels (one channel accessible from many workspaces in the org) and channels tied to a specific workspace. Channels can be connected to IDP groups so org admins can automatically add or remove members from workspaces using IDP group membership; SCIM API is the fallback when an IDP doesn't sync groups. | https://slack.com/help/articles/115001435788-Slack-Enterprise-Grid | verified 2026-05-22 |
| **Slack Connect — external collaboration governance** | For channels, both organizations must be on a paid Slack plan; for DMs, any Slack plan works. The creating organization owns the channel and is the only org that can invite/remove other orgs, manage posting permissions, or continue using the channel after externals are removed. Apps and shortcuts are restricted to the org that added them. Profile detail visibility to external orgs is admin-controlled. Manage centrally via Home → Directories → External. | https://slack.com/help/articles/115004151203-Slack-Connect-guide | verified 2026-05-22 |
| **Retention policy — paid teams** | Owners of paid Slack teams can configure custom message retention policies team-wide and per-channel; messages and files older than the configured duration are deleted from production servers on a nightly basis. Defaults differ by edition; verify before quoting. On Enterprise Grid, retention is per-workspace and must be coordinated across workspaces. | https://www.salesforce.com/content/dam/web/en_us/www/documents/legal/misc/slack-security-privacy-and-architecture.pdf | verified 2026-05-22 |
| **Slack FedRAMP authorization** | Standard Slack: FedRAMP Moderate authorized — requires the Enterprise or Enterprise+ Slack plan and configuration per Slack's Secure Configuration Guide. GovSlack: FedRAMP JAB High authorized and pursuing DoD CC SRG IL4. If Slackbot web search is enabled, it may send Customer Data outside the FedRAMP authorization boundary — disable for federal workloads. | https://slack.com/trust/compliance | verified 2026-05-22 |
| **Enterprise Key Management (EKM)** | EKM is an add-on to the Enterprise+ plan. Customer-managed keys are stored in AWS KMS (AWS KMS dependency is mandatory — there is no on-prem or alternate-KMS option). EKM encrypts messages and files within Slack. Admins can revoke key access at organization, workspace, channel, time-frame, and file levels; key usage events are logged in AWS CloudWatch and CloudTrail. Collaboration continues for users even when access to specific data is revoked. | https://slack.com/enterprise-key-management | verified 2026-05-22 |
| **DLP / compliance partners** | Slack supports both native DLP and third-party DLP/e-discovery providers, with FINRA 17a-4 configurability. Slack publicly markets "support for third party DLP providers" but does not enumerate named partners on the public security or compliance pages — customer InfoSec teams should ask Slack directly which DLP/e-discovery partners are currently integrated (commonly cited in enterprise deployments include Smarsh, Theta Lake, Nightfall, and Netskope, but partner status changes; do not quote a partner list without confirming with the Slack account team). DLP does not eliminate the data-leakage concern; it scopes it. | https://slack.com/security | verified 2026-05-22 |
| **Salesforce + Slack apps — Sales Elevate, Sales Cloud for Slack, Service Cloud for Slack** | Each app is a separate install with its own license requirements and learning curve; not one switch — sellers should set this expectation honestly | https://www.salesforce.com/sales/slack/ | TODO — pinpoint specific app pages |
| **Per-message / bot cost models** | High-volume bot postings can surprise customers on usage-based downstream services (e.g., usage-priced Slack-driven workflows or downstream APIs the bot calls) | https://slack.com/pricing | TODO |
| **Slack AI / Agentforce-on-Slack capabilities** | The Slack AI / agent integration story is evolving — describe currently shipping capabilities, not roadmap; verify against current Slack release notes | https://slack.com/features/ai | TODO — verify URL |
| **Workflow Builder — limits and trigger types** | TODO — verify current Workflow Builder trigger types, limits, and what requires the developer platform | https://api.slack.com/automation | TODO |

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
