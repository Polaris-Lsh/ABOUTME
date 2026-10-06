# 跨 Agent 接入手册（ADAPTERS）

> 核心档案只有一份：`~/.agent-profile/ABOUTME.md`。
> 各 Agent 的入口文件（AGENTS.md / CLAUDE.md / system prompt）**只放一行指针，
> 不复制内容**——复制 = 多处真相 = 永远不同步。

## 原则：按需加载，不自动注入

- **开场不读、不问、不注入。** 档案常驻磁盘，Agent 只在真正需要时读。
- 它解决的两件事：
  1. **让新 Agent 认识你**——你明确要求它读档（任意措辞即可，无需固定关键词），
     或 Agent 需要你的背景、协作偏好才能把事干好；
  2. **同步认知进度**——读时连 `delta.md` 一起读（其他 Agent 最近学到的），
     学到新东西随手写 delta，定期合并。
- **加载粒度按需**：全文（明确要求读档）／ 只读协作规则章节（只要协作方式）／
  不读（默认）。
- **空档案自动引导**：入口装好后档案还是种子（front-matter `updated: never`），
  你要求开始使用（任意措辞，opencode 可用 `/aboutme`），Agent 就按 `ONBOARDING.md`
  让你自由说（或指给它已有信息）、边听边归置写入、最后给出使用说明。
- 在项目空间干活时，默认不读也不写档案目录（你明确要求除外）。

## 通用入口模板（粘到任何 Agent 的启动指令里）

```
[AboutMe | 按需加载] 我的自我说明在 ~/.agent-profile/。
- 只在两种时机读它：① 我明确要求读档（任意措辞，无需固定关键词；opencode
  可用 `/aboutme read`）；② 你需要我的背景或协作偏好才能完成任务（只要
  协作方式 → 只读 ABOUTME.md 的"怎么和我协作"章节）。读时连同目录
  delta.md 全文一起读。
- 按同目录 WORKFLOW.md 维护档案：碎片变化随手写 delta；我要求立即合并时
  （任意措辞，opencode 可用 `/aboutme merge`）合并，平时 agent 攒够条件自行
  合并，不用我催。开关：`/aboutme off|lite|on`（opencode）或对我说关/开（任意措辞）。
- 档案还是种子（front-matter updated: never）而我要求开始使用 → 按同目录
  ONBOARDING.md 让我自由说（或指给你已有信息）、边听边归置写入，完成后给出使用说明。
- 平时不要读、开场不要问问题、不要自动注入。
- 秘密（密码/token/证件号）永不写入档案，也绝不进外发内容（搜索词 /
  公开仓库 / commit / API prompt）；听到我给出秘密只提醒我别进档案。
```

## 通用接口（核心）

任何 agent、任何平台——包括还没出现的——接入只需满足两条：

1. **有地方放静态指令**（启动指令 / AGENTS.md / CLAUDE.md / 自定义 instructions / 规则）→ 粘上面的"通用入口模板"；
2. **能读本地文件** → 直接读 `~/.agent-profile/`；不能读（纯 Web 端）→ 降级为按需手动粘贴档案内容（档案本身只有 🟡 级），秘密永不粘贴。

两条满足即接入，不因平台而异。下面的表格只是**已验证的落点示例，不是白名单**——未列出的 agent 照样粘同一个模板。

## 已验证落点（示例）

| 平台 | 入口文件 | 做法 |
|---|---|---|
| **opencode** | `~/.config/opencode/AGENTS.md` | 追加通用模板；可选装 `commands/aboutme.md` → `~/.config/opencode/command/aboutme.md` 获得 `/aboutme on|off|lite|read|merge` 命令 |
| **Claude Code** | `~/.claude/CLAUDE.md`（全局） | 追加通用模板；可选装 `commands/claude-code/aboutme.md` → `~/.claude/commands/aboutme.md` 获得 `/aboutme` |
| **Codex CLI / ChatGPT Codex 桌面端** | `~/.codex/AGENTS.md`（全局）；或仓库根 `AGENTS.md` | `install.ps1 -Agents codex` 或追加通用模板；可选装 `commands/codex/aboutme.md` → `~/.codex/prompts/aboutme.md`，调用 `/prompts:aboutme` |
| **Qoder** | 项目根 `AGENTS.md`（原生兼容）；或 `.qoder/rules/` | 项目根放 AGENTS.md 粘通用模板；`.qoder/rules` 优先级更高 |
| **WorkBuddy（腾讯）** | 设置 → 自定义指令 / 规则 | 粘通用模板（它有本地文件读权限，可读档案） |
| **Cursor / Windsurf 等** | 各自全局 memory / instructions | 追加通用模板 |
| **无 memory 系统的 Agent** | system prompt / 自定义 instructions | 粘贴通用模板 |
| **Web 类 Agent（无本地文件访问）** | — | 降级：按需手动粘贴档案内容，秘密永不粘贴 |
| **任何未列出 / 未来的 agent** | 其启动指令 / 自定义 instructions / 规则 | 粘同一个通用模板 |

现成片段见仓库 `adapters/` 目录；`adapters/generic.md` 就是通用接口片段本身，其他文件只是按特定平台换好了缩进和措辞。

## 移植到新机器 / 新环境

1. 整个 `~/.agent-profile/` 目录拷走即可——自包含。
2. 新环境各 Agent 入口文件加通用模板。
3. 路径变了就改入口里的路径。

## 注意

- 合并写入时单会话独占编辑 `ABOUTME.md`，不要多个 Agent 同时改。
- 秘密永不进入任何 Agent 的入口文件、也永不进入档案——入口只说"去读本地文件"。
