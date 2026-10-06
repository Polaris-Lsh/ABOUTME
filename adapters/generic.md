# Generic adapter / 通用接入片段

**This file IS the universal interface**: paste it into any agent — past,
present, or future — that has a place for static instructions. The only
capability it assumes is reading local files (degradation options below).
**本文件就是通用接口**：任何有"放静态指令的地方"的 agent（过去的、现在的、
未来的）直接粘贴即可，唯一的能力假设是能读本地文件（不能读的降级方案在下方）。
Pre-formatted variants for specific platforms live next to this file in
`adapters/` — same content, wording adjusted per platform.
其他文件只是按平台调整措辞的现成版本，内容同源。

### English

```text
[AboutMe | on-demand load] My self-description lives in ~/.agent-profile/.

- Read it in only two cases: ① I explicitly ask to read the profile (any wording, no fixed keyword); ② you need my background or collaboration preferences to complete the task (working style only → read just the "How to work with me" section of ABOUTME.md). When reading, read delta.md in the same directory in full as well.
- Switch: `AboutMe: off` (in current project instructions or my explicit request in any wording) → no reads or writes this session; `lite` → read only the collaboration section. Default: on.
- Maintain the profile per WORKFLOW.md in the same directory: append fragments to delta as they appear; when I ask for an immediate merge (any wording) merge, and the agent merges on its own once WORKFLOW conditions are met — no prompting.
- If the profile is still the seed (front-matter updated: never) and I ask to get started, run ONBOARDING.md in the same directory: let me talk (or point you at existing info), organize it into the profile, then show the usage instructions.
- Otherwise never read it, never ask about it at session start, never auto-inject.
- Secrets (passwords / tokens / ID numbers) never go into the profile and never into outbound content (search queries / public repos / commit messages / API prompts); if I volunteer one, only remind me to keep it out of the profile.
```

### 中文

```text
[AboutMe | 按需加载] 我的自我说明在 ~/.agent-profile/。

- 只在两种时机读它：① 我明确要求读档（任意措辞，无需固定关键词）；② 你需要我的
  背景或协作偏好才能完成任务（只要协作方式 → 只读 ABOUTME.md 的
  "怎么和我协作"章节）。读时连同目录 delta.md 全文一起读。
- 开关：`AboutMe: off`（当前项目指令，或我明确要求，任意措辞）→ 本会话不读不写；`lite` → 只读协作章节。默认 on。
- 按同目录 WORKFLOW.md 维护档案：碎片变化随手写 delta；我要求立即合并时（任意措辞）合并，平时 agent 攒够条件自行合并，不用我催。
- 档案还是种子（front-matter updated: never）而我要求开始使用 → 按同目录
  ONBOARDING.md 让我自由说（或指给你已有信息）、边听边归置写入，完成后给出使用说明。
- 平时不要读、开场不要问问题、不要自动注入。
- 秘密（密码/token/证件号）永不写入档案，也绝不进外发内容（搜索词 /
  公开仓库 / commit / API prompt）；听到我给出秘密只提醒我别进档案。
```

## Agents without local file access (web apps etc.) / 没有本地文件能力的 Agent（网页版等）

They cannot read `~/.agent-profile/`. Two options:
无法读 `~/.agent-profile/`。两种用法：

1. **Manual paste**: when needed, paste the profile's content into the conversation — the profile holds only 🟡-tier content; secrets are never pasted.
   **手动粘贴**：需要时把档案内容贴进对话——档案本身只有 🟡 级内容；秘密永不粘贴。
2. **Project work only**: let it work purely from the project rules you paste, with no personal profile injected.
   **只干项目活**：让它只按你粘贴的项目规则工作，不注入个人档案。
