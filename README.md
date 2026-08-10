# dotfiles

Personal config synced across machines via this repo.

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
