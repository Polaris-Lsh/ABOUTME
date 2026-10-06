# AboutMe update workflow

> Any agent reads and writes this file. One sentence: **fragments settle on their own, the full picture grows over time, merging never waits for you.**

## A. During sessions (automatic) — route first, then write

Any fragment that reveals **me as a person** (projects, schedule, habits, preferences, skills mentioned in passing) is captured automatically — **no "remember this" needed**; missing sections of the profile fill up from these fragments. Before writing anything, run the observation through this three-way routing rule. **One piece of information goes to exactly one layer**; when unsure, leave it in the session (nothing is recorded by default):

| Test | Layer | Action |
|---|---|---|
| Useful only for this conversation / task (one-off decisions, bug details, temp context) | **Session layer** | Don't persist it — keep it in the session |
| Globally useful to this agent itself (tool usage, environment know-how, platform habits) | **Agent memory layer** | Write to that agent's own memory system (platform memory, project space) — not this directory |
| A **durable fact / long-term preference** about me, or a **dated, time-bound item** (exam, deadline, milestone) | **AboutMe layer** | Append to `delta.md` (never edit `ABOUTME.md` directly) |

**AboutMe-layer categories**:

- **Project**: new project started / ended, major milestone change (record existence and level only — never project details)
- **Skill**: newly mastered / newly exposed knowledge gap
- **Schedule**: exams, deadlines, important dates added or removed (**must carry a date**)
- **Preference**: corrections to collaboration style, pet peeves, tone requirements
- **Environment**: new device, new tooling
- **Correction**: `ABOUTME.md` turned out wrong / outdated

One entry per line: `- [date] @agent category: content`; time-bound items: `- [date] @agent category (until YYYY-MM-DD): content`. `@agent` = your own name/platform (e.g. `@claude` / `@cursor` / `@opencode`); if unsure, any short self-id — it makes delta a cross-agent timeline and helps resolve conflicts at merge. **When in doubt, write it** — filter at merge time; a missed entry is harder to recover than an extra one.

> In project spaces, don't write to this directory by default unless I explicitly ask.

## B. Merge (the agent acts on its own — never waits for your command)

**Run the flow below as soon as any condition holds**, with a one-line notice ("merged N, dropped M").
When I **ask for an immediate merge** (opencode: `/aboutme merge`; anywhere else any wording works — no fixed keywords), run it with a full report:

1. You just wrote to delta and it has reached **≥3 entries**;
2. You're about to read the profile and delta is non-empty (merge first, so what you read is the full picture);
3. A dated entry in delta has reached its deadline.

Flow:

1. Read `ABOUTME.md` in full and all pending entries in `delta.md`.
2. Judge each entry through three gates (keeps the profile limited to **durable + unexpired time-bound** information):
   - **Layer gate**: only useful to that past session → drop; belongs to an agent/tool itself → send it to its home (platform memory, project space), not the profile;
   - **Durable gate**: one-off decisions, project-local details → never in the main profile; write them to the project space if needed;
   - **Time gate**: a dated entry has expired → delete it and list it in the report; still valid → fold it in **keeping the date label**.
   Entries that pass: duplicate → drop; conflict → **rewrite with the newer one winning** (use each entry's `[date]` and `@agent` to judge recency and source) and say what changed; new → fold into the right section.
3. Set `ABOUTME.md`'s front-matter `updated:` to today.
4. Clear the pending-entries section of `delta.md` (keep the header).
5. Report: N folded, M dropped, K corrected — **entry titles only, don't restate the full text**.

> Merging is **editing**, not appending: the main profile stays compact, contradiction-free, readable top to bottom.

## C. On-demand read (a new agent gets to know you)

**Check the switch first**: `AboutMe: off` in the current project instructions or said by me → **no reads or writes at all** this session (skip ABOUTME, delta, and the rest of this file; no delta writes, no merges); `AboutMe: lite` → read only the "How to work with me" section of `ABOUTME.md`, skip delta and merges. Neither present → default on, proceed below.

**No opening action, never read automatically.** Only two triggers:

1. I **explicitly ask to read the profile** (any wording — no fixed keyword; on opencode `/aboutme read` also works) → read `ABOUTME.md` + `delta.md` **in full** (an unmerged delta is what other agents recently learned — treat it as fact).
2. The agent needs your background / collaboration preferences to do the job → read only the "How to work with me" section of `ABOUTME.md`.

Exception: `ABOUTME.md` **is still the seed** (front-matter `updated: never`; trigger conditions in `ONBOARDING.md`) → don't read the empty profile; run the guided setup in `ONBOARDING.md` instead, then show the usage instructions.

While reading (triggers 1/2), if delta is non-empty → **merge per §B first, then read**, folding "merged N, dropped M" into your report.

## Boundaries

- `delta.md` is a draft area — rough is fine; `ABOUTME.md` is the live profile and only changes through the merge flow.
- Secrets (passwords / tokens / ID numbers) **never go into** `ABOUTME.md` / `delta.md`: if I volunteer one, only remind me "keep that out of the profile" — never write it down or repeat it (my private file is maintained by hand, by me).
- If this workflow itself needs changing, discuss with me first.
