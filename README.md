# dotfiles

Personal config synced across machines via this repo.

## Overview

Global coding-agent preferences (language, commit conventions, TypeScript rules, testing, Angular) are kept in one file per tool, each symlinked into the location that tool reads:

| Tool             | Source file                       | Symlinked to                                       |
| ----------------- | ---------------------------------- | --------------------------------------------------- |
| Claude Code        | `claude/CLAUDE.md`                | `~/.claude/CLAUDE.md`                                |
| Codex CLI          | `codex/AGENTS.md`                 | `~/.codex/AGENTS.md`                                 |
| GitHub Copilot CLI | `copilot/global.instructions.md`  | `~/.copilot/instructions/global.instructions.md`     |

The three files share the same ruleset; only tool-specific formatting (e.g. frontmatter) and the commit trailer's tool name differ. When adding or changing a rule, update all three.

## Claude Code global config

`claude/CLAUDE.md` is this user's global Claude Code preferences file. On each machine it needs to be symlinked into place:

**Windows (PowerShell, run as the user — may need Developer Mode enabled for symlinks without admin):**

```powershell
New-Item -ItemType SymbolicLink -Path "$HOME\.claude\CLAUDE.md" -Target "D:\claude\dotfiles\claude\CLAUDE.md" -Force
```

**macOS / Linux:**

```bash
ln -sf "$(pwd)/claude/CLAUDE.md" ~/.claude/CLAUDE.md
```

After cloning this repo on a new machine, run the appropriate command above once. Edits to `claude/CLAUDE.md` (from either the symlink or the repo path) then apply everywhere and can be committed/pushed like any other file.

## Codex CLI global config

`codex/AGENTS.md` is this user's global Codex CLI preferences file. Codex CLI reads a single global `AGENTS.md` from its home directory, so symlink it into place:

**Windows (PowerShell, run as the user — may need Developer Mode enabled for symlinks without admin):**

```powershell
New-Item -ItemType SymbolicLink -Path "$HOME\.codex\AGENTS.md" -Target "D:\claude\dotfiles\codex\AGENTS.md" -Force
```

**macOS / Linux:**

```bash
ln -sf "$(pwd)/codex/AGENTS.md" ~/.codex/AGENTS.md
```

## GitHub Copilot global config

`copilot/global.instructions.md` is this user's global GitHub Copilot CLI preferences file. Copilot CLI discovers personal instructions under `~/.copilot/instructions/**/*.instructions.md` (the filename must end in `.instructions.md`), so symlink it into place:

**Windows (PowerShell, run as the user — may need Developer Mode enabled for symlinks without admin):**

```powershell
New-Item -ItemType SymbolicLink -Path "$HOME\.copilot\instructions\global.instructions.md" -Target "D:\claude\dotfiles\copilot\global.instructions.md" -Force
```

**macOS / Linux:**

```bash
mkdir -p ~/.copilot/instructions
ln -sf "$(pwd)/copilot/global.instructions.md" ~/.copilot/instructions/global.instructions.md
```

Note: this only covers Copilot **CLI**. GitHub Copilot Chat in VS Code doesn't yet support a single global instructions file the same way — for a given project you'd still add a repo-local `.github/copilot-instructions.md`, or sync personal instructions across machines via VS Code's Settings Sync ("Prompts and Instructions").
