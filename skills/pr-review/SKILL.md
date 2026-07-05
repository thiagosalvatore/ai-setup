---
name: pr-review
description: >-
  Review a coworker's pull request the way I do — code organization/architecture, test
  coverage, logic vs stated intent, and performance. Use when I ask to review a PR, a
  pull request, "review this PR", or give a PR number/URL to look over.
---

# PR review

Review a coworker's pull request end-to-end. Be thorough and skeptical: assume there is
always an edge case being missed, and go looking for it. Produce a report for me — do not
post anything to GitHub unless I explicitly ask.

**This is a collaboration, not a solo review.** You don't have to figure out everything by
yourself. When you're unsure whether something is actually a problem — a judgment call, a
finding you can't fully confirm, a maybe-nitpick — bring it to me and ask what I think
before treating it as a finding, instead of guessing. We decide together whether it makes
the review. Confident, clear-cut issues you can just report; it's the uncertain ones that
should become a question.

## 1. Gather context

- Identify the PR: a number, URL, or branch. If it's ambiguous, ask which one.
- Read the PR itself:
  - `gh pr view <pr> --json title,body,author,files,additions,deletions,url,comments`
  - `gh pr diff <pr>` for the full diff.
- Read the intent behind it:
  - The PR description — what does the author claim this does?
  - Any linked ticket/issue. Follow links in the body (`gh issue view <n>`, or fetch the
    URL). The stated requirement is the source of truth for whether the code is correct.
- For frontend PRs, look for a screenshot or recording in the PR body and comments. If one
  is attached, **read it** (download the image and open it) — it shows what the feature is
  meant to look like and do, and makes the rest of the review sharper. It's nice-to-have,
  not required; if there's none, note that a visual would have helped and move on.

## 2. Review dimensions

Go through each. For every issue, cite the file and line, explain *why* it's a problem,
and where useful suggest the fix.

**Logic — does the code do what the PR says?**
- Engineers often describe one thing and implement something subtly different. Read
  carefully and confirm the implementation matches the description and the linked ticket.
- Assume a missing edge case exists. Probe empty/null inputs, boundaries, error paths,
  concurrency, and unusual states. Trace the change through to make sure it holds up.

**Code organization / architecture**
- Respect the architecture already in place (MVC, Clean Architecture, layered, etc.).
  Business logic doesn't belong in views/controllers; API/transport concerns don't belong
  in the business/domain layer; and business rules don't belong in the API layer. Flag
  code that leaks across these boundaries.
- SOLID matters where it earns its keep — apply it when it helps, don't dogmatically
  demand it. If the whole project ignores it, don't fight the codebase; raise it to the
  author as a **nitpick** rather than a blocker.
- Clear naming, small focused units, no obvious duplication.

**Tests**
- New/changed behavior should be tested. Missing tests on real logic is a blocker.
- Coverage should go beyond the happy path — check for edge cases, error handling, and
  boundaries. Call out untested branches specifically.
- Watch for tests that assert nothing meaningful or that were weakened to pass.

**Performance**
- N+1 queries — flag loops that issue per-item queries; suggest batching/eager loading.
- Memory: never load large files fully into memory — prefer streaming/chunking. Watch for
  leaks (unclosed resources, growing caches, retained references).
- Prefer async to use otherwise-idle CPU where the codebase supports it (skip if it
  doesn't).
- Long-running work should run in the background / a worker, never inline on an API
  request path.

## 3. Report

Group findings by severity so I can act fast:

- **Blocking** — correctness bugs, missing tests on real logic, architecture violations,
  performance problems that will bite in production.
- **Should fix** — real issues that aren't strictly blocking.
- **Nitpick** — style, naming, optional SOLID/pattern suggestions.

Start with a 2–3 line summary: what the PR does, whether it matches its stated intent, and
your overall call (approve / approve-with-comments / request-changes). Then the grouped
findings. If nothing is wrong in a dimension, say so briefly rather than padding.

If I ask you to post the review, use `gh pr review` / `gh pr comment` — but only on my
explicit say-so, since it's visible to the author and the team.
