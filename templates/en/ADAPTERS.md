# Cross-agent setup manual (ADAPTERS)

> One core profile only: `~/.agent-profile/ABOUTME.md`.
> Each agent's entry file (AGENTS.md / CLAUDE.md / system prompt) holds
> **a one-line pointer, never a copy** — copies = multiple sources of truth = permanent drift.

## Principle: load on demand, never auto-inject

- **Nothing is read, asked, or injected at session start.** The profile stays on disk; agents read it only when truly needed.
- It solves exactly two things:
  1. **Let a new agent meet you** — you explicitly ask it to read the profile (any wording, no fixed keyword), or the agent needs your background / collaboration preferences to do the job well;
  2. **Sync cognition across agents** — readers also read `delta.md` (what other agents recently learned), append new findings to delta, and merge regularly.
- **Granularity on demand**: full text (explicit read request) / only the collaboration section (just need working style) / nothing (default).
- **Automatic guided setup for an empty profile**: once the pointer is installed but the profile is still the seed (front-matter `updated: never`), one request from me to get started (any wording; on opencode `/aboutme`) makes the agent run `ONBOARDING.md` — I talk (or point it at existing info), it organizes that into the profile, followed by the usage instructions.
- While working in a project space, neither read nor write the profile directory by default (unless I explicitly ask).

## Generic entry snippet (paste into any agent's startup instructions)

```
[AboutMe | on-demand load] My self-description lives in ~/.agent-profile/.
- Read it in only two cases: ① I explicitly ask to read the profile (any
  wording, no fixed keyword; on opencode `/aboutme read` works too); ② you
  need my background or collaboration preferences to complete the task
  (working style only → read just the "How to work with me" section of
  ABOUTME.md). When reading, read delta.md in the same directory in full
  as well.
- Maintain the profile per WORKFLOW.md in the same directory: append
  fragments to delta as they appear; when I ask for an immediate merge
  (any wording; opencode `/aboutme merge`) merge, and the agent merges on
  its own once WORKFLOW conditions are met — no prompting. Switches:
  `/aboutme off|lite|on` (opencode) or just tell me off/on in any wording.
- If the profile is still the seed (front-matter updated: never) and I ask
  to get started, run ONBOARDING.md in the same directory: let me talk (or
  point you at existing info), organize it into the profile, then show the
  usage instructions.
- Otherwise never read it, never ask about it at session start, never
  auto-inject.
- Switch: `AboutMe: off` (in current project instructions or my explicit
  request in any wording) → no reads or writes this session; `lite` →
  read only the collaboration section. Default: on.
- Secrets (passwords / tokens / ID numbers) never go into the profile and
  never into outbound content (search queries / public repos / commit
  messages / API prompts); if I volunteer one, only remind me to keep it
  out of the profile.
```

## The generic interface (core)

Any agent, any platform — including ones that don't exist yet — needs exactly two things to connect:

1. **A place for static instructions** (startup instructions / AGENTS.md / CLAUDE.md / custom instructions / rules) → paste the "generic entry snippet" above;
2. **Ability to read local files** → it reads `~/.agent-profile/` directly; if it can't (pure web) → degrade to pasting the profile's content manually on demand (the profile holds only 🟡-tier content); secrets are never pasted.

Both satisfied = connected, regardless of platform. The table below is a list of **verified landing spots as examples, not a whitelist** — an unlisted agent pastes the very same snippet.

## Verified landing spots (examples)

| Platform | Entry file | What to do |
|---|---|---|
| **opencode** | `~/.config/opencode/AGENTS.md` | append the generic snippet; optionally install `commands/aboutme.md` → `~/.config/opencode/command/aboutme.md` for `/aboutme on|off|lite|read|merge` |
| **Claude Code** | `~/.claude/CLAUDE.md` (global) | append the generic snippet; optionally install `commands/claude-code/aboutme.md` → `~/.claude/commands/aboutme.md` for `/aboutme` |
| **Codex CLI / ChatGPT Codex desktop** | `~/.codex/AGENTS.md` (global); or repo-root `AGENTS.md` | `install.ps1 -Agents codex` or append the generic snippet; optionally install `commands/codex/aboutme.md` → `~/.codex/prompts/aboutme.md`, invoked as `/prompts:aboutme` |
| **Qoder** | repo-root `AGENTS.md` (native); or `.qoder/rules/` | put the generic snippet in repo-root AGENTS.md; `.qoder/rules` takes precedence |
| **WorkBuddy (Tencent)** | Settings → custom instructions / rules | paste the generic snippet (it can read local files, so the profile works) |
| **Cursor / Windsurf etc.** | their global memory / instructions | append the generic snippet |
| **Agents with no memory system** | system prompt / custom instructions | paste the generic snippet |
| **Web agents (no local file access)** | — | degrade: paste the profile's content manually on demand; secrets are never pasted |
| **Any unlisted / future agent** | its startup instructions / custom instructions / rules | paste the same generic snippet |

Ready-made snippets: the repo's `adapters/` directory; `adapters/generic.md` is the generic interface itself, the rest only adjust indentation and wording per platform.

## Moving to a new machine / environment

1. Copy the whole `~/.agent-profile/` directory — self-contained.
2. Add the generic snippet to each agent's entry file in the new environment.
3. If the path changed, update the path in the entry snippet.

## Notes

- During a merge, a single session owns `ABOUTME.md` — don't have multiple agents editing it concurrently.
- Secrets never enter any agent's entry file, and never enter the profile — the entry only says "go read the local file".
