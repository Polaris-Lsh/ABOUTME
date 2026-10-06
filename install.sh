#!/usr/bin/env bash
# aboutme-connector installer — copies the profile template and adds the one-line pointer.
# Usage: bash install.sh [--lang auto|zh|en] [--agents opencode,claude,codex]
#                        [--home DIR] [--force] [--uninstall]
set -euo pipefail

MARKER_START='<!-- aboutme-connector:start -->'
MARKER_END='<!-- aboutme-connector:end -->'

LANG_OPT=auto
AGENTS_OPT=""
HOME_OPT="$HOME"
FORCE=0
UNINSTALL=0

usage() {
  cat <<'EOF'
aboutme-connector installer

  bash install.sh [--lang auto|zh|en] [--agents opencode,claude,codex]
                  [--home DIR] [--force] [--uninstall]
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --lang)      LANG_OPT="$2"; shift 2 ;;
    --agents)    AGENTS_OPT="$2"; shift 2 ;;
    --home)      HOME_OPT="$2"; shift 2 ;;
    --force)     FORCE=1; shift ;;
    --uninstall) UNINSTALL=1; shift ;;
    -h|--help)   usage; exit 0 ;;
    *) echo "unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
PROFILE_DIR="$HOME_OPT/.agent-profile"

if [ "$LANG_OPT" = auto ]; then
  case "${LC_ALL:-}${LC_MESSAGES:-}${LANG:-}" in
    zh*) LANG_OPT=zh ;;
    *)   LANG_OPT=en ;;
  esac
fi
TEMPLATE_DIR="$REPO_ROOT/templates/$LANG_OPT"
[ -d "$TEMPLATE_DIR" ] || { echo "template directory not found: $TEMPLATE_DIR" >&2; exit 1; }

if [ "$LANG_OPT" = zh ]; then
  SNIPPET=$(cat <<'EOF'
<!-- aboutme-connector:start -->
## AboutMe(按需加载,一行指针)

- **我的自我说明在 `~/.agent-profile/`。平时不要读、开场不要问、不要自动注入。**
- 开关:`AboutMe: off`(出现在当前项目指令,或我明确要求,任意措辞)→本会话完全不读不写;`lite`→只读"怎么和我协作"章节。默认 on。opencode 可用 `/aboutme off|lite|on`。
- 只在两种时机读:① 我明确要求读档(任意措辞,无需固定关键词;opencode `/aboutme read` 亦可)→读 `ABOUTME.md` + `delta.md` 全文;② 你需要我的背景或协作偏好才能完成任务→只读 `ABOUTME.md` 的"怎么和我协作"章节。
- 按 `WORKFLOW.md` 维护档案:会话中觉察到我的新项目/能力/日程/偏好变化→随手写 delta(项目空间默认不写);我要求立即合并时(任意措辞;opencode `/aboutme merge`)合并,平时攒够条件 agent 自行合并,不用我催。
- 档案仍是种子(front-matter `updated: never`)而我要求开始使用→按 `ONBOARDING.md` 让我自由说(或指给你已有信息)、边听边归置写入,完成后给出使用说明。
- 秘密(密码/token/证件号)永不写入档案,也绝不进外发 prompt(web 搜索词、public repo、commit message);听到我给出秘密只提醒我别进档案。
<!-- aboutme-connector:end -->
EOF
)
  MSG_USAGE=$(cat <<'EOF'

== 安装完成 ==
使用说明(三件事):
  1. 读档 — 明确要求 agent 读档(任意措辞,无需固定关键词;opencode 用 /aboutme read)。
  2. 干活 — 平时无需任何操作,agent 按档案里的协作规则来。
  3. 更新 — 碎片自动进 delta、攒够条件自动合并;立即合并用 /aboutme merge(或任意措辞要求)。
开关: /aboutme off|lite|on(opencode),或对 agent 说关/开(任意措辞)。
档案还是空的? 下次要求开始时,agent 会按 ONBOARDING.md 让你自由说、边听边归置写入,随后给出使用说明。
安全: 秘密永不进档案;仓库带 pre-commit 钩子拦截误提交。
卸载指针: bash install.sh --uninstall (个人档案不会被删)
EOF
)
else
  SNIPPET=$(cat <<'EOF'
<!-- aboutme-connector:start -->
## AboutMe (on-demand load, one-line pointer)

- **My self-description lives in `~/.agent-profile/`. Never read it by default, never ask about it at session start, never auto-inject it.**
- Switch: `AboutMe: off` (in current project instructions or my explicit request in any wording) → no reads or writes this session; `lite` → read only the "How to work with me" section. Default: on. On opencode use `/aboutme off|lite|on`.
- Read it in only two cases: ① I explicitly ask to read the profile (any wording, no fixed keyword; `/aboutme read` also works) → read `ABOUTME.md` + `delta.md` in full; ② you need my background or collaboration preferences to complete the task → read only the "How to work with me" section of `ABOUTME.md`.
- Maintain the profile per `WORKFLOW.md`: noticed a change in my projects / skills / schedule / preferences → append to delta (not in project spaces by default); when I ask for an immediate merge (any wording; `/aboutme merge`) → merge, and the agent merges on its own when WORKFLOW conditions are met — no prompting.
- If the profile is still the seed (front-matter `updated: never`) and I ask to get started, run `ONBOARDING.md`: let me talk (or point you at existing info), organize it into the profile, then show the usage instructions.
- Secrets (passwords / tokens / ID numbers) never go into the profile and never into outbound prompts (web search queries / public repos / commit messages); if I volunteer one, only remind me to keep it out of the profile.
<!-- aboutme-connector:end -->
EOF
)
  MSG_USAGE=$(cat <<'EOF'

== Install complete ==
Usage (three things):
  1. Read — explicitly ask the agent to read the profile (any wording, no fixed keyword; on opencode: /aboutme read).
  2. Work — no action needed day to day; the agent follows the rules in the profile.
  3. Update — fragments go to delta.md and merge automatically once enough is collected; for an immediate merge use /aboutme merge (or just ask).
Switches: /aboutme off|lite|on (opencode), or tell the agent on/off in any wording.
Profile still empty? Next time you ask to get started, the agent runs ONBOARDING.md (you talk, it organizes that into the profile), then shows these instructions.
Security: secrets never enter the profile; the repo ships a pre-commit hook that blocks accidental commits.
Remove pointers: bash install.sh --uninstall (your profile is never deleted)
EOF
)
fi

# Point the pointer at the real absolute profile dir — `~` is not expanded by
# every agent/tool (esp. on Windows), which would break on-demand reads.
SNIPPET="${SNIPPET//~\/.agent-profile/$PROFILE_DIR}"

echo "== aboutme-connector installer (lang=$LANG_OPT) =="

remove_block() {
  # $1 = file; strips the marker block (portable sed range delete, no -i)
  sed '/aboutme-connector:start/,/aboutme-connector:end/d' "$1" > "$1.tmp"
  mv "$1.tmp" "$1"
}

entry_path() {
  # $1 = agent name
  case "$1" in
    opencode) echo "$HOME_OPT/.config/opencode/AGENTS.md" ;;
    claude)   echo "$HOME_OPT/.claude/CLAUDE.md" ;;
    codex)    echo "$HOME_OPT/.codex/AGENTS.md" ;;
    *) return 1 ;;
  esac
}

if [ "$UNINSTALL" = 1 ]; then
  count=0
  for name in opencode claude codex; do
    path="$(entry_path "$name")"
    if [ -f "$path" ] && grep -q 'aboutme-connector:start' "$path" 2>/dev/null; then
      remove_block "$path"
      echo "pointer removed: $path"
      count=$((count + 1))
    fi
  done
  echo "Uninstalled pointer from $count file(s)."
  echo "Profile kept at $PROFILE_DIR (personal data) — delete that directory manually if you want."
  exit 0
fi

# 1) profile directory
mkdir -p "$PROFILE_DIR"
copied=0
skipped=""
for f in "$TEMPLATE_DIR"/*; do
  [ -f "$f" ] || continue
  base="$(basename "$f")"
  if [ -f "$PROFILE_DIR/$base" ] && [ "$FORCE" = 0 ]; then
    skipped="$skipped $base"
    continue
  fi
  cp "$f" "$PROFILE_DIR/$base"
  copied=$((copied + 1))
done
echo "profile: copied $copied file(s) -> $PROFILE_DIR"
if [ -n "$skipped" ]; then
  echo "profile: kept existing$skipped (use --force to overwrite)"
fi

# 2) entry files
targets=""
if [ -n "$AGENTS_OPT" ]; then
  IFS=',' read -r -a requested <<< "$AGENTS_OPT"
  for name in "${requested[@]}"; do
    path="$(entry_path "$name")" || { echo "unknown agent '$name'. valid: opencode, claude, codex" >&2; exit 1; }
    targets="$targets $name"
  done
else
  for name in opencode claude codex; do
    path="$(entry_path "$name")"
    [ -f "$path" ] && targets="$targets $name"
  done
fi

if [ -z "${targets// }" ]; then
  echo "entry: no agent entry file found (looked for opencode / claude / codex)."
  echo "entry: re-run with e.g. --agents opencode to create one."
else
  for name in $targets; do
    path="$(entry_path "$name")"
    if [ -f "$path" ]; then
      if grep -q 'aboutme-connector:start' "$path" 2>/dev/null && [ "$FORCE" = 0 ]; then
        echo "entry [$name]: already installed, skipped ($path)"
        continue
      fi
      bak="$path.bak.$(date +%Y%m%d-%H%M%S)"
      cp "$path" "$bak"
      remove_block "$path"
      if [ -n "$(tail -c 1 "$path" 2>/dev/null)" ]; then printf '\n' >> "$path"; fi
      printf '\n%s\n' "$SNIPPET" >> "$path"
      echo "entry [$name]: pointer added (backup: $(basename "$bak")) ($path)"
    else
      mkdir -p "$(dirname "$path")"
      printf '%s\n' "$SNIPPET" > "$path"
      echo "entry [$name]: created with pointer ($path)"
    fi
  done
fi

# 3) /aboutme command, one file per targeted agent
cmd_src_for() {
  case "$1" in
    opencode) echo "$REPO_ROOT/commands/opencode/aboutme.md" ;;
    claude)   echo "$REPO_ROOT/commands/claude-code/aboutme.md" ;;
    codex)    echo "$REPO_ROOT/commands/codex/aboutme.md" ;;
  esac
}
cmd_dest_for() {
  case "$1" in
    opencode) echo "$HOME_OPT/.config/opencode/command/aboutme.md" ;;
    claude)   echo "$HOME_OPT/.claude/commands/aboutme.md" ;;
    codex)    echo "$HOME_OPT/.codex/prompts/aboutme.md" ;;
  esac
}
for name in $targets; do
  src="$(cmd_src_for "$name")"; dest="$(cmd_dest_for "$name")"
  [ -n "$src" ] && [ -f "$src" ] || continue
  if [ -f "$dest" ] && [ "$FORCE" = 0 ]; then
    echo "command [$name]: already present, skipped ($dest)"
    continue
  fi
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  echo "command [$name]: /aboutme installed ($dest) — restart that tool to load"
done

# 4) usage instructions
printf '%s\n' "$MSG_USAGE"
