# CLAUDE.md

How I want you to write code, on every project.

## Comments

- Don't sprinkle comments everywhere. Code should be self-explanatory. If you need a
  comment to explain *what* the code does, the code isn't well written — fix the code
  (clearer names, smaller functions) instead of narrating it.
- The only comments worth writing explain *why* something non-obvious is the way it is
  (a workaround, a constraint, a subtle invariant) — never *what* the line does.
- Never delete or reword comments that were already in the code. Only edit comments you
  yourself added in this change.

## Clean code

- Small functions with a single, clear purpose. If a function does two things, split it.
- Avoid nested `if`s. Prefer early returns / guard clauses to keep the happy path flat.
- Name things for what they mean. No `data`, `tmp`, `x`, `handleStuff` — a good name
  removes the need for a comment.
- No magic strings or numbers. Extract them into named constants or enums.
- Say everything once. Duplicated logic is a bug waiting to happen — factor it out.
- Match the surrounding code's style and patterns; don't introduce a new pattern without
  a reason.
- Order of work: **make it work → make it right → make it fast.** Don't optimize before
  it's correct and clean.

## TDD

- Prefer test-driven development: write a failing test that captures the desired behavior,
  make it pass with the simplest change, then refactor with the test as a safety net.
- Red → green → refactor. Don't write production code without a failing test asking for it,
  unless the change genuinely has no testable behavior.

## Git & Graphite

- Prefer [Graphite](https://graphite.dev) for git work. Use the `gt` CLI (and the graphite
  MCP when available) over raw git for anything touching a stack — `gt create`,
  `gt restack`, `gt submit`, `gt sync`.
- Keep changes small and stacked. One focused change per PR; stack dependent work rather
  than piling it into one branch.
- Raw `git rebase` or `git push --force-with-lease` on a stacked branch bypasses
  Graphite's base tracking and breaks the stack. Only fall back to raw git when there's no
  `gt` equivalent.
- Never commit directly to `main`; branch (or `gt create`) first.

## Broken tests — never leave broken things

- There is no such thing as a "pre-existing failure we don't need to fix."
- If tests are broken when you arrive, or you break unrelated tests, fix them — never
  leave them red. Choose the smallest honest option:
  - If the fix belongs with your current work, include it in the current change.
  - If it's unrelated, fix it in a **separate worktree / stacked PR** so your main change
    stays focused. Don't fold an unrelated fix into the current diff just to avoid the
    stack.
- Don't disable, skip, or delete a test to make the suite green. Fix the cause.

## Verify by actually running it

- Tests are necessary but not sufficient. For anything with a runtime surface, exercise
  the real thing before calling it done.
- When building or changing a UI/web feature, drive it in the browser and confirm the
  behavior actually works — don't rely on unit tests alone.
