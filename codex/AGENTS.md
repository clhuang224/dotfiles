# Global Codex CLI preferences

These apply across all projects for this user, regardless of repo-local `AGENTS.md` files (which add project-specific rules on top, they don't replace these).

## Commits

- Write commit messages and code comments in **English**.
- Use **Conventional Commits** format (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`, etc.).
- Keep commits **small and atomic** — one logical change per commit. Don't batch unrelated changes into a single commit.
- Every commit message MUST end with this exact trailer line:

  ```
  Co-authored-by: Codex [model] ([context size]) <noreply@openai.com>
  ```

## TypeScript

- Enable **strict mode** (`"strict": true` in `tsconfig.json`) on new TypeScript projects. Don't relax it for convenience.
- When a type is a union of a few string literals, keep the literal values in **English**. If there's a corresponding Chinese display label, handle it through a separate map/lookup (e.g. `Record<Status, string>`) instead of using Chinese text as the literal values themselves.

## Testing

- Prefer **Vitest** over Jasmine/Karma for new JS/TS projects where there's a choice.

## Angular

- For new Angular projects, default to **standalone components + Signals**, not NgModules.
