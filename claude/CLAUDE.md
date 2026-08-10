# Global Claude Code preferences

These apply across all projects for this user, regardless of repo-local `CLAUDE.md` files (which add project-specific rules on top, they don't replace these).

## Commits

- Write commit messages and code comments in **English**.
- Use **Conventional Commits** format (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`, etc.).
- Keep commits **small and atomic** — one logical change per commit. Don't batch unrelated changes into a single commit.
- Every commit message MUST end with this exact trailer line:

  ```
  Co-authored-by: Claude Code Sonnet 5 (967k) <noreply@anthropic.com>
  ```

## TypeScript

- Enable **strict mode** (`"strict": true` in `tsconfig.json`) on new TypeScript projects. Don't relax it for convenience.

## Testing

- Prefer **Vitest** over Jasmine/Karma for new JS/TS projects where there's a choice.

## Angular

- For new Angular projects, default to **standalone components + Signals**, not NgModules.
