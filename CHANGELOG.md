# Changelog

All notable changes to this project. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning follows [SemVer](https://semver.org/).

## [0.1.0] - 2026-10-07

First public release.

### Added
- **Portable profile** — a single `~/.agent-profile/ABOUTME.md` any agent reads on demand; each agent's entry file holds only a one-line pointer, never a copy.
- **Organic structure** — the profile ships as a minimal seed (front-matter `updated: never` + one anchor section "How to work with me"); everything else grows from conversation. No forms, no user-facing classification.
- **Cross-agent feed** — `delta.md` collects fragments tagged with `@agent` provenance; `WORKFLOW.md` defines the read / write / merge protocol (auto-merge on read, dedup, conflict resolution, expiry).
- **Three-layer routing** — session-only context stays in the session, tool know-how routes back to each agent's own memory, only durable/dated facts about you reach the profile.
- **Secret isolation** — 🟡-tier content only; 🔴 data lives in a hand-maintained `PRIVATE.md` that no pointer or protocol references.
- **Installers** — one-command `install.ps1` (Windows) and `install.sh` (macOS/Linux): idempotent, absolute-path pointers, backups before editing, `--uninstall` keeps your data.
- **Commands** — `/aboutme off|lite|on|read|merge` for opencode, Claude Code, Codex; plain-language control everywhere else.
- **Adapters** — a generic interface snippet plus pre-formatted variants; works with any agent that can hold static instructions and read local files.
- **Safety & portability** — `.gitattributes` (LF for shell scripts), `.githooks/pre-commit` guard against committing profile files.
- **Bilingual docs** — English and 中文.
