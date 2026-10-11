# Installs the Claude Code mods from the "9 Claude Mods" guide at user scope on
# Windows. Needs Claude Code 2.1.287+ and git. Terminal Browser is skipped: it
# runs on macOS and Linux only. Blast Radius needs Claude Code run from Git Bash.
$ErrorActionPreference = 'Continue'

$srcRoot = if ($env:CLAUDE_MODS_SRC) { $env:CLAUDE_MODS_SRC } else { Join-Path $HOME '.claude\mod-sources' }
$playground = Join-Path $srcRoot 'claude-code-playground'
$failed = @()

function Run([string[]]$cmd) {
  Write-Host "+ $($cmd -join ' ')"
  & $cmd[0] $cmd[1..($cmd.Length - 1)]
  if ($LASTEXITCODE -ne 0) { $script:failed += ($cmd -join ' ') }
}

# 01 Savvy Progress
Run claude, plugin, marketplace, add, johnnyvizz/claude-kit
Run claude, plugin, install, savvy-progress@claude-kit, '--scope', user

# 02 Claude Skins
Run claude, plugin, marketplace, add, hellosverre/claude-skins
Run claude, plugin, install, skins@hellosverre-mods, '--scope', user

# 03 You Should Know (built in, nothing to download)
Run claude, plugin, enable, cc-plugin-you-should-know@builtin, '--scope', user

# 04 Filetree
Run claude, plugin, marketplace, add, data-goblin/claude-code-filetree
Run claude, plugin, install, filetree@claude-code-filetree, '--scope', user

# 05 Cache Tax
Run claude, plugin, marketplace, add, karanb192/claude-code-mods
Run claude, plugin, install, cache-tax@claude-code-mods, '--scope', user

# 06 Blast Radius + 09 Replay Theater. Keep the clone where it is: moving it breaks them.
if (Test-Path (Join-Path $playground '.git')) {
  Run git, '-C', $playground, pull, '--ff-only'
} else {
  New-Item -ItemType Directory -Force -Path $srcRoot | Out-Null
  Run git, clone, '--depth', 1, 'https://github.com/anthropics/claude-code-playground.git', $playground
}
Run claude, plugin, marketplace, add, (Join-Path $playground 'claude-code\mods')
Run claude, plugin, install, blast-radius@claude-code-playground-mods, '--scope', user
Run claude, plugin, install, replay-theater@claude-code-playground-mods, '--scope', user

# 07 Reflect
Run claude, plugin, marketplace, add, bayramannakov/claude-reflect
Run claude, plugin, install, reflect-mod@claude-reflect-marketplace, '--scope', user

Write-Host "Skipping 08 Terminal Browser: it runs on macOS and Linux only."
Write-Host ""
if ($failed.Count -gt 0) {
  Write-Host "Done with $($failed.Count) failed step(s):"
  $failed | ForEach-Object { Write-Host "  $_" }
  exit 1
}
Write-Host "All mods installed. Start a new Claude Code session (or run /reload-plugins)."
