# Contributing

Thanks for your interest! This project is deliberately tiny — plain Markdown plus
two shell scripts, **zero runtime dependencies**. Please keep it that way.

## Design principles (read before opening a PR)

Changes that break these are likely to be declined:

1. **Zero dependencies** — no server, no database, no MCP host, no daemon, no build
   step. If a feature needs one, it belongs in an optional integration, not the core.
2. **One profile, no user-facing classification** — never make the user sort facts
   into categories or pick which profile to load. Scope is handled by the per-project
   `AboutMe: off / lite` switch, not by taxonomies.
3. **On-demand, never auto-inject** — the profile is read only when asked, or when an
   agent needs it to do the job. No session-start injection, no background listeners.
4. **Secrets never enter the profile** — 🟡-tier content only; 🔴 data stays in the
   user's own local private file that no pointer or protocol references.

## Always welcome

- New **adapters** / verified landing spots for other agents (`adapters/`,
  `templates/*/ADAPTERS.md`) — as long as they reuse the same generic snippet.
- Installer bug fixes, doc typos, clearer wording.
- Keeping `templates/en/` and `templates/zh/` in sync.

## Before you submit

- **Test both installers against a throwaway home**, never your real one:
  - `bash install.sh --home /tmp/amtest --lang en`
  - `powershell -File install.ps1 -TargetHome "$env:TEMP\amtest" -Lang en`

  Check: the profile dir is created, the pointer is written with an **absolute** path,
  re-running is idempotent, and `--uninstall` removes the pointer cleanly.
- **Line endings**: `.gitattributes` enforces LF for `*.sh` and the pre-commit hook —
  never commit CRLF into a shell script (it breaks macOS / Linux with `bad interpreter`).
- **Enable the guard**: `git config core.hooksPath .githooks` so accidental profile
  files can't be committed.
- Never commit a filled-in `ABOUTME.md` / `delta.md` / `PRIVATE.md`.

## Issues

Bug reports and adapter requests are welcome. For anything that changes the protocol
(`WORKFLOW.md`) or the profile structure, please open an issue to discuss **before**
writing code.
