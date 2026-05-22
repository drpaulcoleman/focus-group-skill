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
| **Site templates — LWR vs. Aura** | LWR (Lightning Web Runtime) is the modern template; Aura templates exist for legacy sites but are not the recommended path for new builds | help.salesforce.com Experience Cloud templates | TODO |
| **License types — Customer Community / Partner Community / Customer Community Plus** | License type determines what a community user can see and do, including sharing-set behavior and object access; verify customer's license entitlement before scoping | help.salesforce.com community licenses | TODO |
| **Sharing — sharing sets vs. account-based sharing rules** | Community-user sharing has its own model (sharing sets, account-based sharing); sharing inheritance from internal users does not apply directly | help.salesforce.com sharing for communities | TODO |
| **Accessibility / WCAG conformance** | Out-of-the-box components are designed for WCAG 2.1 AA in most cases; custom components and HTML overrides can break conformance; the customer's accessibility audit is required, not the vendor's word | help.salesforce.com accessibility | TODO |
| **Custom domain / SEO** | Custom domains are supported via Salesforce's Custom Domain feature; SEO requires meta-tag and structured-data work the customer's marketing team typically does not budget | help.salesforce.com Experience Cloud SEO | TODO |
| **Experience Cloud + Agentforce embedded agent** | Embedded customer-facing agents inherit Experience Cloud's authentication and sharing model plus the Agentforce conversation envelope and grounding considerations | help.salesforce.com Agentforce | TODO |
| **Page-load performance / caching** | LWR sites have specific caching behavior; verify before promising sub-second load times in the customer's geography | help.salesforce.com Experience Cloud performance | TODO |
| **Migration — Aura → LWR** | Migration is a re-implementation, not an upgrade; verify scope honestly before promising a "migration" timeline | help.salesforce.com migration | TODO |
| **Guest user access** | Guest user permissions have specific defaults and security implications; over-permissive guest profiles are a frequent audit finding — verify before scoping unauthenticated access | help.salesforce.com guest user | TODO |

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
