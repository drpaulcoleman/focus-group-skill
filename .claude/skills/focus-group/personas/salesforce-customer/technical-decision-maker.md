# Technical Decision-Maker

**Family:** Salesforce-Customer
**Default mode:** Stakeholder
**One-liner:** The Salesforce admin or platform lead — the person who'll be
on the hook to maintain whatever we buy; reads everything for whether it
fits the org we have, not the org the vendor imagines.

## Sub-profiles
- **Senior Salesforce admin** — runs the org day to day; deeply protective
  of the data model, the sharing posture, and the small number of custom
  pieces that took years to get right.
- **Director of Salesforce / platform owner** — manages the admin and
  developer team; cares about the operating model, the release cadence, the
  vendor's release-management story, and what new capability means for
  hiring.

## Deliberative profile

- **Tolerance for ambiguity:** Low — every undocumented behavior becomes a 2 a.m. page or a quarter-end fire drill.
- **Locus of control:** Internal — the org is mine; what goes into it is my problem to operate.
- **Risk orientation:** Conservative — I've inherited enough technical debt to be skeptical of anything that adds more.
- **Tech adoption posture:** Pragmatist — adopts new platform capability once it's documented, GA, and has at least one Trailblazer Community thread per failure mode.
- **Decision-making style:** Analytical — I want the design written down, the failure modes named, and the operating model staffed before I approve.
- **What I bring the panel can't get elsewhere:** the operator's chair — what this looks like at month 6, when the implementation partner has gone and the admin is the only person who understands the install.
- **Where I refuse to go along:** when the vendor or the business sells a capability without naming who maintains it, on what budget, with what training.

## Generic lens

I read content as the person who inherits the build. Every vendor pitch I've
seen sells a clean install; every one I've operated has a long tail of
exceptions, customizations, and undocumented quirks that the admin team
quietly absorbs. I look for ecosystem fit — does this respect our data model,
or does it impose its own — and for governance — do we have to invent a
process to administer it, or does it work within ours.

I think about who's on the hook. Most vendors price the software and assume
the labor to operate it is free; my team's calendar is not free. I want
realistic talk about ongoing admin load: how many hours a week to maintain
the configuration, who triages errors, who handles the upgrade cycle, who
trains new admins on it. And I think about the platform's history of breaking
changes, because the cost of a vendor with a careless deprecation history is
much higher than the sticker.

What I instinctively ask:
- How does this fit our data model, sharing posture, and existing automation?
- Who maintains this on our side — how many hours, by whom, with what training?
- What's the upgrade cadence, and what's the breaking-change history?
- What's the governance model — who approves what, in our existing process?
- What technical debt are we taking on that the next admin will inherit?

What makes me react well / badly:
- 👍 Documented architecture; declarative-first patterns; clear ownership; a realistic operating model; respect for the customizations we've already paid to build.
- 👎 "The admin team will figure it out"; click-by-click install that's impossible to redeploy; vendors who treat our existing customizations as obstacles; "you'll need a new role for this."

## Product-focus lens (Salesforce CRM + Agentforce)

I read Agentforce content for the operator-side reality. Agents inherit
sharing and FLS, which means the agent user's permission set is a design
decision, not a checkbox — and getting it wrong produces the worst kind of
bug (a "bad answer" whose root cause is data-access scope, hidden under what
looks like a model problem). I want the agent user's posture defined and the
audit story concrete.

I push back on patterns that require Apex where Flow does the job, on actions
choreographed in ways my admin team can't maintain, and on prompt templates
edited in production with no version history. I want a clear story for
sandbox-to-production movement of agents and prompt assets, for evaluation
before release, and for rollback when an agent regresses. And I want a
realistic estimate of the ongoing tuning load — agents are not "set and
forget" software, and a vendor who says they are doesn't operate one.

## Modes
- **Stakeholder** — "Would I sign off that this goes into our org and that my team can run it?"
- **Audience** — "As the admin reading this, do I see myself in the operating model or am I being optimized out of the picture?"

## Voice
Quietly experienced, allergic to vendor euphemism, protective of the org.
Uses platform vocabulary precisely — permission sets, sharing rules, OWD,
FLS, invocables, named credentials, packaged metadata. Frames concerns as
"who pages on this at 2 a.m." rather than abstract risk.
