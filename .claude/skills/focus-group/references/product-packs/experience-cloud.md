# Experience Cloud — Product Pack

Experience Cloud is Salesforce's platform for building customer, partner, and
employee-facing digital experiences — portals, communities, help centers, partner
portals, public websites, and headless front-ends — backed by Salesforce data, sharing,
and identity. The primary buyer is the CIO, Chief Digital Officer, or the business
owner of the channel (head of channel sales for a partner portal, head of customer
service for a help center, head of HR for an employee site); the primary users are site
admins, developers (LWR / Aura), and the business teams that own content and
engagement. Sales teams should lean on three honest differentiators: tight integration
with the underlying CRM data and sharing model so that a partner or customer sees
exactly the records they should; the LWR (Lightning Web Runtime) stack for
performance-sensitive customer-facing sites; and the option to go headless against
Salesforce APIs for teams that want full control of the front-end. The typical sales
motion is a partner-portal or help-center conversation tied to an existing Sales Cloud
or Service Cloud deployment, a public-site / authenticated-site project for a regulated
industry, or an internal-employee experience replacing SharePoint-era portals.

## Grounding prompt (injected into every persona)

Experience Cloud sits on the Salesforce Platform and inherits its sharing model,
identity, governor limits, and Lightning runtime. Sites can be built on the older
Aura-based template stack, the newer LWR (Lightning Web Runtime) stack which is
significantly faster and uses Lightning Web Components, or a fully headless /
Composable pattern where a custom front-end consumes Salesforce APIs. Identity options
include internal users, partner and customer community licenses (with their own
sharing-set and share-group model), and external identity via SAML, OIDC, or social
sign-on. Common deployment shapes are: a partner portal with leads, opportunities, and
deal registration; a customer help center with cases, knowledge, and live chat; a
public-facing site (anonymous + authenticated) with self-service workflows; a headless
/ hybrid app for a customer who wants a non-Lightning UI; and an employee or volunteer
portal for nonprofit or public-sector customers.

The honest objections customers raise are: licensing model and cost (Experience Cloud
licenses come in several flavors — Customer Community, Customer Community Plus,
Partner Community, External Apps — with very different sharing capabilities and prices,
and the wrong choice locks the customer in); performance and SEO for a customer-facing
site (Aura sites are heavy and not great for SEO; LWR is much better but still not
parity with a hand-built Next.js / Nuxt site); and security posture for an externally
facing surface (every Experience Cloud site widens the attack surface and the
customer's InfoSec will want a clear story on guest access, sharing-set behavior, and
CSP). The hidden complexities sales conversations gloss are: the Experience Cloud
sharing model — sharing sets, share groups, account-relationship sharing, guest-user
access — is a meaningful body of knowledge and is the root cause of most Experience
Cloud security incidents (the historical Experience Cloud guest-user data exposures all
came from misconfigured sharing, not platform bugs); LWR has feature gaps versus Aura
that surface late in build and can force a template rework; license-type changes after
launch are painful and sometimes infeasible without a re-implementation; SEO requires
meta-tag and structured-data work the customer's marketing team often does not budget;
and Experience Cloud + Agentforce for a customer-facing agent inherits all of the above
plus the Agentforce conversation envelope and grounding considerations.

## Platform Facts

This section is the verification source for accuracy-rubric factor 6
(platform-fact verification). Each row is either **filled** or a **TODO
stub**; the rubric scores 0 for any panel claim that lands on a stub
row. See [salesforce-crm-agentforce.md](salesforce-crm-agentforce.md)
for the canonical maintainer note.

| Topic | Fact | Source / verified | Last verified |
|-------|------|-------------------|---------------|
| **Site templates — LWR vs. Aura** | LWR (Lightning Web Runtime) is the modern template stack; Enhanced LWR Sites and Content Platform is "Available in: Enterprise, Performance, Unlimited, Developer" editions and "Applies to: LWR sites" — Aura templates remain available for legacy sites | https://help.salesforce.com/s/articleView?id=experience.exp_cloud_enhanced.htm&type=5 | verified 2026-05-22 |
| **License types — Customer Community / Partner Community / Customer Community Plus** | The Experience Cloud license families documented are: Customer Community, Customer Community Plus, Partner Community, External Apps, External Identity, and Channel Account; "In Enterprise, Performance, and Unlimited orgs, you can create up to 100 Experience Cloud sites without buying communities licenses"; "You can have up to 100 Experience Cloud sites in your Salesforce org" | https://help.salesforce.com/s/articleView?id=platform.users_license_types_communities.htm&type=5 | verified 2026-05-22 |
| **Sharing — sharing sets vs. account-based sharing rules** | Sharing sets "Apply to: LWR, Aura, and Visualforce sites"; "A sharing set grants site users access to any record associated with an account or contact that matches the user's account or contact"; the access "applies across all sites" and "Record access granted to users via a sharing set isn't extended to their superiors in the role hierarchy" | https://help.salesforce.com/s/articleView?id=platform.networks_setting_light_users.htm&type=5 | verified 2026-05-22 |
| **Accessibility / WCAG conformance** | "Lightning Experience follows the internationally recognized best practices in Section 508 of the Rehabilitation Act and the Web Content Accessibility Guidelines (WCAG) 2.2 Level AA to the extent possible" — custom components and HTML overrides can break conformance; the customer's accessibility audit is required, not the vendor's word | https://help.salesforce.com/s/articleView?id=xcloud.accessibility_overview.htm&type=5 | verified 2026-05-22 |
| **Custom domain / SEO** | Custom Domains in Salesforce: "each domain can serve up to 200 sites, and each site can be associated with up to 500 domains. An Experience Cloud site counts as two sites, so if you use only Experience Cloud sites, each domain can serve 100 sites" | https://help.salesforce.com/s/articleView?id=platform.domain_mgmt_overview.htm&type=5 | verified 2026-05-22 |
| **Experience Cloud + Agentforce embedded agent** | Re-attempted with real Chrome 2026-05-22 against `sf.agentforce_experience_cloud.htm` (and adjacent slug variants); help.salesforce.com SPA returns 461KB shell with generic title but article body not injected during headless capture, so slug-vs-404 cannot be distinguished from output. Canonical slug for "Agentforce embedded on Experience Cloud" remains unconfirmed via this harvester. | https://help.salesforce.com/s/articleView?id=sf.agentforce_experience_cloud.htm | TODO — help SPA body not rendered in capture; verify embedded-agent capability via in-browser navigation or current release-notes |
| **Page-load performance / caching** | "Scale of Experience Cloud Sites" page documents performance levers including the Salesforce CDN, Progressive Rendering, Page Optimizer, and micro-batching for LWR sites; verify per-customer geography and traffic before promising sub-second loads | https://help.salesforce.com/s/articleView?id=experience.exp_cloud_perf_considerations.htm&type=5 | verified 2026-05-22 |
| **Migration — Aura → LWR** | Per Salesforce help: "Sites that run on Lightning Web Runtime (LWR) boast increased speed, scalability, security, and design flexibility over Aura sites. Migrating your Aura site to an LWR site requires considerable planning." Template changes also note: "Salesforce object data carries over, but branding and component customizations don't" — treat the migration as a re-implementation | https://help.salesforce.com/s/articleView?id=experience.exp_cloud_migrate_lwr_considerations.htm&type=5 | verified 2026-05-22 |
| **Guest user access** | "The Secure guest user record access setting is enabled in all Salesforce orgs with Experience Cloud sites and can't be disabled"; "Guest user sharing rules count toward the limit of 50 criteria-based sharing rules per object" — over-permissive guest profiles are a frequent audit finding | https://help.salesforce.com/s/articleView?id=platform.networks_secure_guest_user_sharing.htm&type=5 | verified 2026-05-22 |

## Recommended persona families

When this pack is active, the persona recommender (Step 4a) leans toward:
- salesforce-sales/solution-engineer
- salesforce-sales/technical-architect
- salesforce-sales/enterprise-architect
- salesforce-customer/champion
- salesforce-customer/end-user-power-user
- salesforce-customer/infosec-privacy-officer
- generic/customer/accessibility-dependent-user

## URL seed-list (for /download grounding)

When `/focus-group` Step 6 offers to download grounding sources, suggest these first:
- https://help.salesforce.com/s/articleView?id=sf.networks_overview.htm
  (verify before use — Experience Cloud help still uses the legacy "networks"
  article root in places)
- https://www.salesforce.com/products/experience-cloud/
- https://architect.salesforce.com/decision-guides
  (pick the Experience Cloud / LWR guide currently published)
- https://trailhead.salesforce.com/content/learn/trails/build-experience-cloud-sites
  (verify exact trail slug)
- https://developer.salesforce.com/docs/atlas.en-us.exp_cloud_lwr.meta/exp_cloud_lwr/intro.htm
  (verify before use)
- https://help.salesforce.com/s/articleView?id=sf.networks_security_overview.htm
  (verify before use)

## Common sales-conversation pitfalls

1. Demoing a slick Aura-template site without disclosing the performance and SEO
   realities the customer will hit in production.
2. Quoting Customer Community licenses for a partner-portal scenario that actually
   needs Partner Community or External Apps licenses — the customer's procurement team
   will catch the mismatch and trust will dip.
3. Glossing the guest-user / sharing-set conversation — given Experience Cloud's
   incident history, the InfoSec persona will press, and a vague answer is a
   deal-slower.
4. Pitching LWR without verifying that the components the customer needs (search,
   knowledge, case, chat, custom Aura components from their existing build) are
   LWR-ready.
5. Promising accessibility (WCAG 2.1 AA) without scoping the component-level audit
   and remediation work that any real public-facing site requires.

## When to combine with an industry pack

Pair with `manufacturing` or `automotive` for dealer / distributor partner portals
where deal registration, lead distribution, and partner enablement are core. Pair with
`public-sector` or `nonprofit` for constituent / member / donor portals where
accessibility and identity (multiple sign-on methods, household relationships) drive
the design. Pair with `financial-services` for client portals where the InfoSec,
regulatory record-keeping, and end-user-experience personas all matter equally.
