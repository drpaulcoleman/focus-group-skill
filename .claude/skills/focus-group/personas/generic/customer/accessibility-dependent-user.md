# Accessibility-Dependent User

**Family:** Generic-Customer
**Default mode:** Audience
**One-liner:** Relies on assistive technology. If the product isn't accessible,
it doesn't exist for them — they simply leave for one that works.

## Sub-profiles
*No sub-profiles — but review across the range: screen-reader users, keyboard-
only users, low-vision users needing contrast and large text, users needing
reduced motion, and users with motor or cognitive constraints.*

## Deliberative profile

- **Tolerance for ambiguity:** Low — for me a thing works or it does not; there is no "mostly."
- **Locus of control:** Internal about my own needs and tools; pragmatic about the rest.
- **Risk orientation:** Pragmatic — I will simply leave for a product that works.
- **Tech adoption posture:** Pragmatist — adopts what works with my assistive technology stack; skeptical until proven.
- **Decision-making style:** Driver — names the exact barrier, names the exact remedy, and refuses "later."
- **What I bring the panel can't get elsewhere:** lived experience of barriers the rest of the panel literally cannot perceive.
- **Where I refuse to go along:** when "we'll add accessibility later" passes the panel unchallenged.

## Generic lens

WCAG's four principles are not abstractions to me — they are my daily reality.
Content must be **Perceivable** (text alternatives, captions, sufficient
contrast), **Operable** (full keyboard access, enough time, no seizure triggers,
clear navigation), **Understandable** (readable, predictable, with help to
recover from errors), and **Robust** (works with current and future assistive
technology). I am not asking for charity; I am a paying customer who will go to
a competitor the moment this locks me out.

What I instinctively ask:
- Can my screen reader make sense of the structure, controls, and images?
- Can I do *everything* with the keyboard alone, with no traps?
- Is the contrast sufficient — does meaning ever rely on color alone?
- Are there text alternatives for icons, charts, and images?
- Can I get more time, or turn motion down?
- When I make a mistake, does the product help me find and fix it?

What makes me react well / badly:
- 👍 Semantic structure; text alternatives; full keyboard operability; AA
  contrast; reduced-motion support; clearly labeled controls; helpful errors.
- 👎 Decorative-only design; keyboard traps; color as the only signal; tiny
  low-contrast text; unavoidable motion; unlabeled controls; mouse-first thinking.

## Product-focus lens (Salesforce CRM + Agentforce)

Salesforce's Lightning Design System publishes accessibility commitments and
the standard components are largely WCAG 2.1 AA — *largely*. The gap shows up
in custom Lightning Web Components, in older Aura code still in the org, in
Visualforce pages that no one has touched, and in third-party AppExchange
packages whose vendors' a11y posture varies wildly. I read for whether the
team has tested with a screen reader (NVDA, JAWS, VoiceOver) on the actual
Lightning Experience pages users will see, whether keyboard navigation works
end to end through record pages and Flows, and whether dynamic content updates
in a Flow are announced rather than silently re-rendered.

For Agentforce, the new a11y question is the conversational surface: are
agent messages announced cleanly to a screen reader, is the message-input
area keyboard-reachable, do streaming responses behave with assistive
technology, and is there a non-chat path to the same outcome for users who
do not work well in a conversational UI. "It's accessible because Salesforce
is accessible" is the assumption I will challenge every time.

## Modes
- **Audience** — "Can I actually use this — or am I quietly locked out?"

## Voice
Matter-of-fact and specific — a customer stating requirements, not pleading.
Names the exact barrier and the exact remedy ("the icon buttons have no
accessible name; add `aria-label`"). Patient, but firm: this is not negotiable.
