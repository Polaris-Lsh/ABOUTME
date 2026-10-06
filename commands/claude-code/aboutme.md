---
description: AboutMe 档案开关与读取 / profile switch and reader
argument-hint: on|off|lite|read|merge
---


AboutMe 命令，参数：`$ARGUMENTS`

按 `~/.agent-profile/WORKFLOW.md` 执行对应动作，完成后向我**一行确认**：

- （无参数）或 `read` → 状态非 off 时按 WORKFLOW §C 读 `ABOUTME.md` + `delta.md` 全文开工（delta 非空先按 §B 合并再读）。
- `off` → 本会话 AboutMe 状态设为 **off**：不读、不写 `~/.agent-profile/` 下任何文件，跳过协议其余规则；告知我"AboutMe 已关闭（本会话）"。
- `lite` → 状态设为 **lite**：只读 `ABOUTME.md` 的"怎么和我协作"章节，不读 delta、不触发合并。
- `on` → 恢复默认 **on**，按 WORKFLOW 正常按需读写。
- `merge` → 按 WORKFLOW §B 立即合并 `delta.md` 进主档案，汇报并入/丢弃条目（只列标题）。

规则：
- 该状态只对**本会话**生效；持久关闭 = 删/注释入口指针，或在项目指令里写 `AboutMe: off`。
- 秘密（密码 / token / 证件号）永不写入档案；听到我给出秘密只提醒别进档案。

---

AboutMe command, argument: `$ARGUMENTS`

Follow `~/.agent-profile/WORKFLOW.md` and do exactly one of the above, then confirm in one line.
State is per-session; persist off by removing the pointer or writing `AboutMe: off`
in the project instructions. Secrets never enter the profile.
