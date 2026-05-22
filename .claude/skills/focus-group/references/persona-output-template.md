# Persona Output Template

Every persona responding in a `/focus-group` panel MUST structure their feedback
using this template. The template ensures output is directly usable by AEs and
SEs in customer interactions — not just analytically correct.

## Required Output Structure

Each persona's response must include ALL of the following sections, in order:

### 1. My Reaction (2-3 sentences)

Your authentic professional reaction in your own vocabulary. Use your industry
jargon, your role-specific framing, your real concerns. This is where your
expertise lives.

### 2. In Customer-Meeting Language (1 sentence)

Restate the core concern in words a non-specialist business executive would use
in a 60-minute meeting. No jargon. No acronyms. One sentence that the AE will
actually hear from the customer's mouth.

### 3. What I'd Say in the Room (1-2 sentences, verbatim)

The exact words you would speak if you were the customer stakeholder in the
meeting reacting to the content under review. Write it as direct speech — the
way a real person talks in a conference room, not the way a document reads.

Examples:
- "I can't approve this until I see how it handles our existing [X] — we got
  burned last time by a vendor who glossed over migration."
- "Show me this works with 500 concurrent users. The last demo I saw fell apart
  at scale."
- "What happens to my data if we cancel in year two? That's my board's first
  question."

### 4. What Would Change My Mind (1 sentence)

The one thing the AE/SE could say, show, or prove that would flip your concern
into a green light. Be specific — name the demo, the reference, the data point,
or the contractual guarantee that would resolve it.

### 5. Risk Level

Tag your concern:
- **RED** — Deal-blocker. This will stop the deal if unaddressed. The AE must
  handle this before the meeting or during it.
- **YELLOW** — Needs addressing. Won't kill the deal alone but will slow it or
  erode confidence. Handle within the current stage.
- **GREEN** — Good to go. This aspect of the content works. Brief note on why.

### 6. Deal-Stage Calibration

Your output emphasis shifts based on the active deal stage. If `--stage` is set,
follow the appropriate frame below. If not set, the skill infers stage from the
content type.

#### Discovery / Early Stage
- Your role: **Question generator**
- Output emphasis: Questions the AE should ask. Gaps in qualification. Signals to listen for. Unknowns to probe.
- Do NOT: Give answers or recommendations. Surface what's unknown, not what you'd recommend.
- "What I'd Say" becomes: "What I'd Ask" — the question this stakeholder would pose in a discovery call.

#### Demo / POV / Mid Stage
- Your role: **Demo validator**
- Output emphasis: What won't survive a live org. Sharing-model gotchas. Data dependencies. Governor-limit math. Integration failure modes.
- Do NOT: Give strategic advice. Focus on what breaks technically.
- "What Would Change My Mind" becomes: "What to demo live" — the specific feature/config that resolves it.

#### Negotiation / Paper / Late Stage
- Your role: **Deal-risk scanner**
- Output emphasis: What procurement will object to. Contract language risks. Pricing model vulnerabilities. Legal/InfoSec blockers.
- Do NOT: Raise technical concerns already addressed in POV. Focus on commercial and political risk.
- "What I'd Say" becomes: What this stakeholder says to their procurement/legal team.

#### Post-Sale / QBR
- Your role: **Adoption validator**
- Output emphasis: What will cause churn. Value-realization gaps. Renewal risk. Training needs. Feature underuse.
- Do NOT: Revisit the buying decision. Focus on whether the value story is landing.
- "What Would Change My Mind" becomes: "What proves value is being realized."

## Anti-Patterns (Never Do These)

- **Don't write an essay.** Each section is 1-3 sentences max. Brevity is a feature.
- **Don't hedge everything.** Pick a risk level. Commit.
- **Don't repeat other personas.** If your concern is the same as another's,
  add your unique angle or skip it and flag what's different about your view.
- **Don't speak as an AI.** You are the persona. Write "I" and mean it.
- **Don't abstract.** Name the specific feature, limit, regulation, or
  stakeholder. "There might be compliance concerns" is useless. "HIPAA §164.312
  requires encryption at rest — show me the field-level encryption config" is useful.

## How the Aggregation Step Uses This

Stage A (Step 9) reads all persona responses structured per this template and:
1. Extracts all "What I'd Say" lines → builds the Objection Table
2. Extracts all "What Would Change My Mind" lines → builds the Action Items
3. Groups by Risk Level → Red items go to "Red Flags" section; Green items to "Strengths"
4. Applies Deal-Stage Calibration → shapes the Meeting Prep / Demo Prep framing
5. Uses "In Customer-Meeting Language" → populates the AE's talk-track responses
