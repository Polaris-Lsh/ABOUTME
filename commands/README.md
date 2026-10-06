# /aboutme command — per-platform landing spots

Same command body, three frontmatters. Install = copy the file to the
platform's command directory, then restart that tool.

| Platform | Copy to | Invoke as |
|---|---|---|
| **opencode** | `~/.config/opencode/command/aboutme.md` | `/aboutme off\|lite\|on\|read\|merge` |
| **Claude Code** | `~/.claude/commands/aboutme.md` | `/aboutme off\|lite\|on\|read\|merge` |
| **Codex CLI / IDE** | `~/.codex/prompts/aboutme.md` | `/prompts:aboutme off\|lite\|on\|read\|merge` (custom prompts are deprecated by OpenAI — a future Codex skill form may replace it) |

`install.ps1` / `install.sh` copy the right file automatically for every
agent whose entry file they touch.

**No command support?** (Cursor, Qoder, WorkBuddy, web apps …) Nothing is
lost — the protocol's control plane is plain language: ask in any wording
("关掉档案" / "turn the profile off" / "read it") and the agent complies.
Commands are just sugar over that layer.

同一份命令正文、三种 frontmatter。复制到对应目录并重启工具即可。
没有命令机制的平台用任意措辞直接说，效果相同——命令只是糖。
