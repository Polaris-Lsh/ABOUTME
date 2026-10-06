# ONBOARDING — first run (empty profile)

> **Trigger (all three must hold):**
> 1. the entry pointer is installed;
> 2. I ask to get started (any wording — e.g. "let's set up my profile"; on opencode `/aboutme` works);
> 3. `ABOUTME.md` is still the seed — front-matter says `updated: never`.
>
> Profile already has real content → skip this file, follow `WORKFLOW.md` §C.

## Principles — no form, no interrogation

- **There is no questionnaire.** Let me talk, or point you at existing info (an old profile, your own memory of me, a repo's `AGENTS.md`) — you organize what you hear into the profile. Don't run me down a fixed list.
- **Start from the anchor.** The one thing worth getting first is `## How to work with me` — role, tone, what to ask before doing, pet peeves. Everything else (who I am, skills, current work, environment) grows only if I offer it.
- **Structure emerges from content.** Create a section when a real fact needs a home; never pre-print empty headings; delete what doesn't fit me.
- **Ask only for gaps in the anchor**, a couple at a time. "Skip / later" → leave it and move on. Interrupted → resume from what's still missing, never re-ask.
- **Secrets**: if I volunteer a password / token / ID number, remind me it never enters the profile (I keep it in my own local private file) — never write it down or repeat it.

## Closing

When the anchor has something real (or I say stop):

1. Write it into `ABOUTME.md` and set front-matter `updated:` to today.
2. Clear any temporary `delta.md` entries created during setup.
3. Report what was written (**titles only**), then show this usage note:

> **Usage (three things):**
> 1. **Read** — ask me to read the profile (any wording; on opencode `/aboutme read`) and I start from it;
> 2. **Work** — nothing to do day to day; I follow the collaboration rules in the profile;
> 3. **Update** — fragments collect in `delta.md` and merge on their own; `/aboutme merge` (or just ask) to force one now.
> Switches anytime: `/aboutme off | lite | on`.
