# Claude Code mods

Setup for the nine mods in the "9 Claude Mods you need to try" guide. Mods need
Claude Code 2.1.287 or newer, and they only draw in the Claude Code terminal and
the Code tab of the desktop app. They don't draw in cloud sessions or the
VS Code extension.

| #  | Mod              | Install id                                    | Try it                          |
|----|------------------|-----------------------------------------------|---------------------------------|
| 01 | Savvy Progress   | `savvy-progress@claude-kit`                   | `/agents-info`                  |
| 02 | Claude Skins     | `skins@hellosverre-mods`                      | `/skin dracula`, `/skin noir`   |
| 03 | You Should Know  | `cc-plugin-you-should-know@builtin`           | watch the space above the prompt |
| 04 | Filetree         | `filetree@claude-code-filetree`               | `/tui fullscreen` (110+ columns) |
| 05 | Cache Tax        | `cache-tax@claude-code-mods`                  | `/keepwarm 90m`, `/keepwarm off` |
| 06 | Blast Radius     | `blast-radius@claude-code-playground-mods`    | ask Claude to `rm -rf` a test folder |
| 07 | Reflect          | `reflect-mod@claude-reflect-marketplace`      | correct Claude once, click Save |
| 08 | Terminal Browser | `terminal-browser@terminal-browser`           | `/browser` (macOS/Linux only)   |
| 09 | Replay Theater   | `replay-theater@claude-code-playground-mods`  | `/replay` after Claude edits files |

## Install for every session (recommended)

Run the script from your normal terminal, outside Claude Code:

```bash
# macOS / Linux / Git Bash
scripts/install-mods.sh            # add --skip-browser to leave out Terminal Browser
```

```powershell
# Windows PowerShell (Terminal Browser is skipped, it doesn't run on Windows)
powershell -ExecutionPolicy Bypass -File scripts\install-mods.ps1
```

The script installs every mod at user scope. It clones Anthropic's
`claude-code-playground` into `~/.claude/mod-sources/` for Blast Radius and
Replay Theater. Don't move that folder, or those two mods stop loading. If a
session is already open, run `/reload-plugins` or start a new one.

Terminal Browser also needs the `terminal-browser` binary. The script installs
it with Homebrew. Without Homebrew, run
`curl -fsSL https://terminal-browser.sh/install | bash`.

## Install from this repository

`.claude/settings.json` registers all the marketplaces and enables all nine
mods for this project. Open the repo in Claude Code and accept the workspace
trust dialog, then install the mods it offers through `/plugin`. Each person
still installs the plugins themselves. Enabling a plugin in project settings
doesn't download it.

To turn one off on your machine only, set it to `false` in
`.claude/settings.local.json`, for example:

```json
{ "enabledPlugins": { "reflect-mod@claude-reflect-marketplace": false } }
```

## Things to know

- Mods aren't sandboxed. They run with your permissions. All eight
  downloadable mods passed `claude plugin validate` when this setup was made.
- Blast Radius needs bash, git, find and du. On Windows, run Claude Code from
  Git Bash.
- Use Reflect's mod (`reflect-mod`) or its older Python plugin
  (`claude-reflect`), not both.
- Filetree and Reflect show real file names and prompt text, so use a demo
  project when you share your screen.
- The cost Savvy Progress shows is an estimate, not your bill.
- Filetree and Terminal Browser have optional settings. Change them with
  `/plugin configure <id>`.
