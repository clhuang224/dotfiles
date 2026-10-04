# dotfiles

Dotfiles for syncing my coding-agent preferences (Claude Code, Codex CLI, GitHub Copilot CLI) across machines and tools. Each tool's global instructions file lives here and is symlinked into place, so one set of rules applies everywhere.

## Overview

Global coding-agent preferences (language, writing, commit conventions, Git safety, secrets handling, TypeScript rules, testing, Angular) are kept in one file per tool, each symlinked into the location that tool reads:

| Tool             | Source file                       | Symlinked to                                       |
| ----------------- | ---------------------------------- | --------------------------------------------------- |
| Claude Code        | `claude/CLAUDE.md`                | `~/.claude/CLAUDE.md`                                |
| Codex CLI          | `codex/AGENTS.md`                 | `~/.codex/AGENTS.md`                                 |
| GitHub Copilot CLI | `copilot/global.instructions.md`  | `~/.copilot/instructions/global.instructions.md`     |

The three files share the same ruleset; only tool-specific formatting (e.g. frontmatter) and the commit trailer's tool name differ. When adding or changing a rule, update all three.

Claude Code also gets an on-demand team mode (see [Claude Code team mode](#claude-code-team-mode)). It has no Codex or Copilot counterpart, so it is the one exception to updating all three.

## Claude Code global config

`claude/CLAUDE.md` is this user's global Claude Code preferences file. On each machine it needs to be symlinked into place:

**Windows (PowerShell, run as the user — may need Developer Mode enabled for symlinks without admin):**

```powershell
New-Item -ItemType SymbolicLink -Path "$HOME\.claude\CLAUDE.md" -Target "C:\path\to\dotfiles\claude\CLAUDE.md" -Force
```

**macOS / Linux:**

```bash
ln -sf "$(pwd)/claude/CLAUDE.md" ~/.claude/CLAUDE.md
```

After cloning this repo on a new machine, run the appropriate command above once. Edits to `claude/CLAUDE.md` (from either the symlink or the repo path) then apply everywhere and can be committed/pushed like any other file.

## Claude Code team mode

A `/team` skill plus role subagents for running a task as a small team: the main agent coordinates and reviews, and dispatches roles as needed.

| Source | Symlinked to | Purpose |
| --- | --- | --- |
| `claude/skills/team/` | `~/.claude/skills/team` | Coordinator protocol, loaded only when you type `/team` |
| `claude/agents/` | `~/.claude/agents` | Role subagents: `pm`, `rd`, `qa`, `doc`, `ux`, `ui` |

- The skill holds the rules for the coordinator (when a team is worth it, how to dispatch and review). Each agent file repeats the few rules subagents must follow themselves, such as never committing, because subagents do not see the skill.
- A project can override a role by defining an agent with the same name in its own `.claude/agents/`, and add project-only roles there. Project agents take precedence over these.
- The whole `agents/` directory is linked, so an agent created at user level (for example with `/agents`) is saved into this repo.

**macOS / Linux:**

```bash
mkdir -p ~/.claude/skills
ln -sfn "$(pwd)/claude/skills/team" ~/.claude/skills/team
ln -sfn "$(pwd)/claude/agents" ~/.claude/agents
```

**Windows (PowerShell; not yet tested):**

```powershell
New-Item -ItemType SymbolicLink -Path "$HOME\.claude\skills\team" -Target "C:\path\to\dotfiles\claude\skills\team" -Force
New-Item -ItemType SymbolicLink -Path "$HOME\.claude\agents" -Target "C:\path\to\dotfiles\claude\agents" -Force
```

If the agents do not show up after creating `~/.claude/agents` for the first time, restart Claude Code.

## Codex CLI global config

`codex/AGENTS.md` is this user's global Codex CLI preferences file. Codex CLI reads a single global `AGENTS.md` from its home directory, so symlink it into place:

**Windows (PowerShell, run as the user — may need Developer Mode enabled for symlinks without admin):**

```powershell
New-Item -ItemType SymbolicLink -Path "$HOME\.codex\AGENTS.md" -Target "C:\path\to\dotfiles\codex\AGENTS.md" -Force
```

**macOS / Linux:**

```bash
ln -sf "$(pwd)/codex/AGENTS.md" ~/.codex/AGENTS.md
```

## GitHub Copilot global config

`copilot/global.instructions.md` is this user's global GitHub Copilot CLI preferences file. Copilot CLI discovers personal instructions under `~/.copilot/instructions/**/*.instructions.md` (the filename must end in `.instructions.md`), so symlink it into place:

**Windows (PowerShell, run as the user — may need Developer Mode enabled for symlinks without admin):**

```powershell
New-Item -ItemType SymbolicLink -Path "$HOME\.copilot\instructions\global.instructions.md" -Target "C:\path\to\dotfiles\copilot\global.instructions.md" -Force
```

**macOS / Linux:**

```bash
mkdir -p ~/.copilot/instructions
ln -sf "$(pwd)/copilot/global.instructions.md" ~/.copilot/instructions/global.instructions.md
```

Note: this only covers Copilot **CLI**. GitHub Copilot Chat in VS Code doesn't yet support a single global instructions file the same way — for a given project you'd still add a repo-local `.github/copilot-instructions.md`, or sync personal instructions across machines via VS Code's Settings Sync ("Prompts and Instructions").
