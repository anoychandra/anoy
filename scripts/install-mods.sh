#!/usr/bin/env bash
# Installs the 9 Claude Code mods from the "9 Claude Mods" guide at user scope,
# so they load in every session. Needs Claude Code 2.1.287+ and git.
# Usage: scripts/install-mods.sh [--skip-browser]
set -uo pipefail

SKIP_BROWSER=0
[[ "${1:-}" == "--skip-browser" ]] && SKIP_BROWSER=1

PLAYGROUND_DIR="${CLAUDE_MODS_SRC:-$HOME/.claude/mod-sources}/claude-code-playground"
failed=()

run() {
  echo "+ $*"
  "$@" || failed+=("$*")
}

# 01 Savvy Progress
run claude plugin marketplace add johnnyvizz/claude-kit
run claude plugin install savvy-progress@claude-kit --scope user

# 02 Claude Skins
run claude plugin marketplace add hellosverre/claude-skins
run claude plugin install skins@hellosverre-mods --scope user

# 03 You Should Know (built in, nothing to download)
run claude plugin enable cc-plugin-you-should-know@builtin --scope user

# 04 Filetree
run claude plugin marketplace add data-goblin/claude-code-filetree
run claude plugin install filetree@claude-code-filetree --scope user

# 05 Cache Tax
run claude plugin marketplace add karanb192/claude-code-mods
run claude plugin install cache-tax@claude-code-mods --scope user

# 06 Blast Radius + 09 Replay Theater (Anthropic's sample mods). The marketplace
# lives in a subfolder, so keep a clone in a fixed place: moving it breaks them.
if [[ -d "$PLAYGROUND_DIR/.git" ]]; then
  run git -C "$PLAYGROUND_DIR" pull --ff-only
else
  mkdir -p "$(dirname "$PLAYGROUND_DIR")"
  run git clone --depth 1 https://github.com/anthropics/claude-code-playground.git "$PLAYGROUND_DIR"
fi
run claude plugin marketplace add "$PLAYGROUND_DIR/claude-code/mods"
run claude plugin install blast-radius@claude-code-playground-mods --scope user
run claude plugin install replay-theater@claude-code-playground-mods --scope user

# 07 Reflect
run claude plugin marketplace add bayramannakov/claude-reflect
run claude plugin install reflect-mod@claude-reflect-marketplace --scope user

# 08 Terminal Browser (macOS and Linux terminals only)
if [[ $SKIP_BROWSER -eq 1 ]]; then
  echo "Skipping Terminal Browser (--skip-browser)."
elif [[ "$(uname -s)" != Darwin && "$(uname -s)" != Linux ]]; then
  echo "Skipping Terminal Browser: it runs on macOS and Linux only."
else
  if ! command -v terminal-browser >/dev/null 2>&1; then
    if command -v brew >/dev/null 2>&1; then
      run brew install terminal-browser
    else
      echo "Homebrew not found. Install the browser with:"
      echo "  curl -fsSL https://terminal-browser.sh/install | bash"
    fi
  fi
  run claude plugin marketplace add zenbu-labs/terminal-browser
  run claude plugin install terminal-browser@terminal-browser --scope user
fi

echo
if [[ ${#failed[@]} -gt 0 ]]; then
  echo "Done with ${#failed[@]} failed step(s):"
  printf '  %s\n' "${failed[@]}"
  exit 1
fi
echo "All mods installed. Start a new Claude Code session (or run /reload-plugins)."
