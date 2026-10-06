#requires -Version 5.0
<#
.SYNOPSIS
  aboutme-connector installer — copies the profile template and adds the one-line pointer.
.PARAMETER Lang       auto (default) | zh | en
.PARAMETER Agents     opencode, claude, codex — default: only entry files that already exist
.PARAMETER TargetHome override home directory (testing)
.PARAMETER Force      overwrite existing profile / refresh installed pointers
.PARAMETER Uninstall  remove pointers from entry files (profile is kept)
.EXAMPLE
  powershell -ExecutionPolicy Bypass -File install.ps1 -Lang zh
#>
[CmdletBinding()]
param(
    [ValidateSet('auto','zh','en')][string]$Lang = 'auto',
    [string[]]$Agents = @(),
    [string]$TargetHome = '',
    [switch]$Force,
    [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'
# -File passes "a,b,c" as one string; flatten commas so -Agents a,b,c works.
$Agents = @($Agents | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim() } | Where-Object { $_ })
# Emit UTF-8 to the console so CJK output renders correctly in captured / modern terminals.
try { [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false) } catch { }
$MarkerStart = '<!-- aboutme-connector:start -->'
$MarkerEnd   = '<!-- aboutme-connector:end -->'
$RepoRoot    = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $TargetHome) { $TargetHome = $HOME }
$ProfileDir = "$TargetHome/.agent-profile"

if ($Lang -eq 'auto') {
    $Lang = if ((Get-Culture).TwoLetterISOLanguageName -eq 'zh') { 'zh' } else { 'en' }
}
$TemplateDir = Join-Path $RepoRoot "templates\$Lang"
if (-not (Test-Path -LiteralPath $TemplateDir)) { throw "Template directory not found: $TemplateDir" }

if ($Lang -eq 'zh') { $Snippet = @'
<!-- aboutme-connector:start -->
## AboutMe(按需加载,一行指针)

- **我的自我说明在 `~/.agent-profile/`。平时不要读、开场不要问、不要自动注入。**
- 开关:`AboutMe: off`(出现在当前项目指令,或我明确要求,任意措辞)→本会话完全不读不写;`lite`→只读"怎么和我协作"章节。默认 on。opencode 可用 `/aboutme off|lite|on`。
- 只在两种时机读:① 我明确要求读档(任意措辞,无需固定关键词;opencode `/aboutme read` 亦可)→读 `ABOUTME.md` + `delta.md` 全文;② 你需要我的背景或协作偏好才能完成任务→只读 `ABOUTME.md` 的"怎么和我协作"章节。
- 按 `WORKFLOW.md` 维护档案:会话中觉察到我的新项目/能力/日程/偏好变化→随手写 delta(项目空间默认不写);我要求立即合并时(任意措辞;opencode `/aboutme merge`)合并,平时攒够条件 agent 自行合并,不用我催。
- 档案仍是种子(front-matter `updated: never`)而我要求开始使用→按 `ONBOARDING.md` 让我自由说(或指给你已有信息)、边听边归置写入,完成后给出使用说明。
- 秘密(密码/token/证件号)永不写入档案,也绝不进外发 prompt(web 搜索词、public repo、commit message);听到我给出秘密只提醒我别进档案。
<!-- aboutme-connector:end -->
'@
} else { $Snippet = @'
<!-- aboutme-connector:start -->
## AboutMe (on-demand load, one-line pointer)

- **My self-description lives in `~/.agent-profile/`. Never read it by default, never ask about it at session start, never auto-inject it.**
- Switch: `AboutMe: off` (in current project instructions or my explicit request in any wording) → no reads or writes this session; `lite` → read only the "How to work with me" section. Default: on. On opencode use `/aboutme off|lite|on`.
- Read it in only two cases: ① I explicitly ask to read the profile (any wording, no fixed keyword; `/aboutme read` also works) → read `ABOUTME.md` + `delta.md` in full; ② you need my background or collaboration preferences to complete the task → read only the "How to work with me" section of `ABOUTME.md`.
- Maintain the profile per `WORKFLOW.md`: noticed a change in my projects / skills / schedule / preferences → append to delta (not in project spaces by default); when I ask for an immediate merge (any wording; `/aboutme merge`) → merge, and the agent merges on its own when WORKFLOW conditions are met — no prompting.
- If the profile is still the seed (front-matter `updated: never`) and I ask to get started, run `ONBOARDING.md`: let me talk (or point you at existing info), organize it into the profile, then show the usage instructions.
- Secrets (passwords / tokens / ID numbers) never go into the profile and never into outbound prompts (web search queries / public repos / commit messages); if I volunteer one, only remind me to keep it out of the profile.
<!-- aboutme-connector:end -->
'@
}

# Point the pointer at the real absolute profile dir — `~` is not expanded by
# every agent/tool (esp. on Windows), which would break on-demand reads.
$ProfileDirDisplay = $ProfileDir.Replace('\', '/')
$Snippet = $Snippet.Replace('~/.agent-profile', $ProfileDirDisplay)

$Known = [ordered]@{
    opencode = "$TargetHome/.config/opencode/AGENTS.md"
    claude   = "$TargetHome/.claude/CLAUDE.md"
    codex    = "$TargetHome/.codex/AGENTS.md"
}
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Remove-MarkerBlock([string]$Text) {
    $pattern = '(?s)' + [regex]::Escape($MarkerStart) + '.*?' + [regex]::Escape($MarkerEnd) + '\r?\n?'
    return [regex]::Replace($Text, $pattern, '')
}

if ($Uninstall) {
    $count = 0
    foreach ($p in $Known.Values) {
        if (Test-Path -LiteralPath $p) {
            $raw = [IO.File]::ReadAllText($p)
            if ($raw.Contains($MarkerStart)) {
                [IO.File]::WriteAllText($p, (Remove-MarkerBlock $raw), $Utf8NoBom)
                Write-Host "pointer removed: $p"
                $count++
            }
        }
    }
    Write-Host "Uninstalled pointer from $count file(s)."
    Write-Host "Profile kept at $ProfileDir (personal data) — delete that directory manually if you want."
    return
}

Write-Host "== aboutme-connector installer (lang=$Lang) =="

# 1) profile directory
New-Item -ItemType Directory -Force -Path $ProfileDir | Out-Null
$copied = 0; $skipped = @()
foreach ($f in Get-ChildItem -LiteralPath $TemplateDir -File) {
    $dest = Join-Path $ProfileDir $f.Name
    if ((Test-Path -LiteralPath $dest) -and -not $Force) { $skipped += $f.Name; continue }
    Copy-Item -LiteralPath $f.FullName -Destination $dest -Force
    $copied++
}
Write-Host "profile: copied $copied file(s) -> $ProfileDir"
if ($skipped.Count -gt 0) {
    Write-Host "profile: kept existing $($skipped -join ', ') (use -Force to overwrite)"
}

# 2) entry files
$targets = @()
if ($Agents.Count -gt 0) {
    foreach ($a in $Agents) {
        $key = $a.ToLower()
        if (-not $Known.Contains($key)) { throw "unknown agent '$a'. valid: $($Known.Keys -join ', ')" }
        $targets += ,@($key, $Known[$key])
    }
} else {
    foreach ($k in $Known.Keys) { if (Test-Path -LiteralPath $Known[$k]) { $targets += ,@($k, $Known[$k]) } }
}

if ($targets.Count -eq 0) {
    Write-Host "entry: no agent entry file found (looked for opencode / claude / codex)."
    Write-Host "entry: re-run with e.g. -Agents opencode to create one."
} else {
    foreach ($t in $targets) {
        $name = $t[0]; $path = $t[1]
        if (Test-Path -LiteralPath $path) {
            $raw = [IO.File]::ReadAllText($path)
            if ($raw.Contains($MarkerStart) -and -not $Force) {
                Write-Host "entry [$name]: already installed, skipped ($path)"
                continue
            }
            $bak = "$path.bak.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
            Copy-Item -LiteralPath $path -Destination $bak
            $raw = Remove-MarkerBlock $raw
            $sep = if ($raw -match "`n$") { '' } else { "`n`n" }
            [IO.File]::WriteAllText($path, $raw + $sep + $Snippet + "`n", $Utf8NoBom)
            Write-Host "entry [$name]: pointer added (backup: $(Split-Path $bak -Leaf)) ($path)"
        } else {
            New-Item -ItemType Directory -Force -Path (Split-Path -Parent $path) | Out-Null
            [IO.File]::WriteAllText($path, $Snippet + "`n", $Utf8NoBom)
            Write-Host "entry [$name]: created with pointer ($path)"
        }
    }
}

# 3) /aboutme command, one file per targeted agent
$CmdDestMap = [ordered]@{
    opencode = "$TargetHome/.config/opencode/command/aboutme.md"
    claude   = "$TargetHome/.claude/commands/aboutme.md"
    codex    = "$TargetHome/.codex/prompts/aboutme.md"
}
$CmdSrcMap = @{
    opencode = Join-Path $RepoRoot "commands\opencode\aboutme.md"
    claude   = Join-Path $RepoRoot "commands\claude-code\aboutme.md"
    codex    = Join-Path $RepoRoot "commands\codex\aboutme.md"
}
foreach ($t in $targets) {
    $name = $t[0]; $src = $CmdSrcMap[$name]; $dest = $CmdDestMap[$name]
    if (-not (Test-Path -LiteralPath $src)) { continue }
    if ((Test-Path -LiteralPath $dest) -and -not $Force) {
        Write-Host "command [$name]: already present, skipped ($dest)"
        continue
    }
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dest) | Out-Null
    Copy-Item -LiteralPath $src -Destination $dest -Force
    Write-Host "command [$name]: /aboutme installed ($dest) — restart that tool to load"
}

# 4) usage instructions
if ($Lang -eq 'zh') { Write-Host @'

== 安装完成 ==
使用说明(三件事):
  1. 读档 — 明确要求 agent 读档(任意措辞,无需固定关键词;opencode 用 /aboutme read)。
  2. 干活 — 平时无需任何操作,agent 按档案里的协作规则来。
  3. 更新 — 碎片自动进 delta、攒够条件自动合并;立即合并用 /aboutme merge(或任意措辞要求)。
开关: /aboutme off|lite|on(opencode),或对 agent 说关/开(任意措辞)。
档案还是空的? 下次要求开始时,agent 会按 ONBOARDING.md 让你自由说、边听边归置写入,随后给出使用说明。
安全: 秘密永不进档案;仓库带 pre-commit 钩子拦截误提交。
卸载指针: install.ps1 -Uninstall (个人档案不会被删)
'@
} else { Write-Host @'

== Install complete ==
Usage (three things):
  1. Read — explicitly ask the agent to read the profile (any wording, no fixed keyword; on opencode: /aboutme read).
  2. Work — no action needed day to day; the agent follows the rules in the profile.
  3. Update — fragments go to delta.md and merge automatically once enough is collected; for an immediate merge use /aboutme merge (or just ask).
Switches: /aboutme off|lite|on (opencode), or tell the agent on/off in any wording.
Profile still empty? Next time you ask to get started, the agent runs ONBOARDING.md (you talk, it organizes that into the profile), then shows these instructions.
Security: secrets never enter the profile; the repo ships a pre-commit hook that blocks accidental commits.
Remove pointers: install.ps1 -Uninstall (your profile is never deleted)
'@
}
