# Claude Code adapter / Claude Code 接入片段

Paste into `~/.claude/CLAUDE.md` (global memory).
粘到 `~/.claude/CLAUDE.md`（全局记忆）。

### English

```markdown
## AboutMe connector (on-demand load)

- **My self-description lives in `~/.agent-profile/`. Never read it by default, never ask about it at session start, never auto-inject it.**
- Switch: `AboutMe: off` (in current project instructions or my explicit
  request in any wording) → no reads or writes this session; `lite` →
  read only the "How to work with me" section. Default: on.
- Read it in only two cases: ① I explicitly ask to read the profile (any
  wording, no fixed keyword) → read `ABOUTME.md` + `delta.md` in full;
  ② you need my background or collaboration preferences to complete the
  task → read only the "How to work with me" section.
- Maintain the profile per `WORKFLOW.md`: noticed a change in my projects /
  skills / schedule / preferences → append to delta (not in project spaces by
  default); when I ask for an immediate merge (any wording) → merge, and the
  agent merges on its own when WORKFLOW conditions are met — no prompting.
- If the profile is still the seed (front-matter `updated: never`) and I ask to get started, run `ONBOARDING.md`: let me talk (or point you at existing info), organize it into the profile, then show the usage instructions.
- Secrets (passwords / tokens / ID numbers) never go into the profile and
  never into outbound content (web search queries / public repos / commit
  messages / any outbound prompt); if I volunteer one, only remind me to
  keep it out of the profile.
```

### 中文

```markdown
## AboutMe 连接器（按需加载）

- **我的自我说明在 `~/.agent-profile/`。平时不要读、开场不要问、不要自动注入。**
- 开关：`AboutMe: off`（出现在当前项目指令，或我明确要求，任意措辞）→ 本会话完全
  不读不写；`lite` → 只读"怎么和我协作"章节。默认 on。
- 只在两种时机读：① 我明确要求读档（任意措辞，无需固定关键词）→ 读
  `ABOUTME.md` + `delta.md` 全文；② 你需要我的背景或协作偏好才能完成
  任务 → 只读其中"怎么和我协作"章节。
- 按 `WORKFLOW.md` 维护档案：会话中觉察到我的新项目 / 能力 / 日程 / 偏好变化
  → 追加写 delta（项目空间默认不写）；我要求立即合并时（任意措辞）合并，
  平时攒够条件 agent 自行合并，不用我催。
- 档案仍是种子（front-matter `updated: never`）而我要求开始使用 → 按
  `ONBOARDING.md` 让我自由说（或指给你已有信息）、边听边归置写入，完成后给出使用说明。
- 秘密（密码 / token / 证件号）永不写入档案，也绝不进外发内容（web 搜索词、
  公开仓库、commit message、任何外发 prompt）；听到我给出秘密只提醒我别进档案。
```
