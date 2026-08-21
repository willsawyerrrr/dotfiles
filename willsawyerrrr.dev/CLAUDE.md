# CLAUDE.md

Shared conventions across willsawyerrrr.dev projects.

## Repo layout

Each repo is a bare + per-branch-worktree layout (`.bare` plus a worktree per
branch); `main` stays checked out in `main/`. Every piece of work happens in
its own dedicated worktree named after its branch, keeping parallel work from
colliding on git state.

## Workflow

- Feature work on branches → PRs; keep `main` releasable.
- One feature per pull request. Each distinct change ships in its own branch
  and PR, even when several are requested in quick succession. Never bundle
  two unrelated changes together just because one was asked for while another
  was already in motion — open a separate branch and PR for a request that
  arrives mid-flight rather than folding it into work in progress.
- PR titles are user-facing copy: keep the Conventional Commit `type(scope):`
  prefix, but phrase the description for someone using the app, not for an
  implementer, and make it read as a self-contained sentence.
- Merge PRs via GitHub auto-merge (`gh pr merge --auto`), not by polling for
  CI to go green. Enable it once the PR is open; GitHub merges the moment the
  required checks pass.
- Keep documentation in sync with the code. When a change alters behaviour,
  scope, or a workflow, update the affected docs (`docs/` and the project's
  `CLAUDE.md`) as part of the same change, so `main` is never merged with
  stale docs.
- Claude drives everything in these repos — code, docs, CI, config — and owns
  the git and PR lifecycle autonomously: branching, committing, pushing, and
  opening, updating, and merging pull requests, all without per-turn
  confirmation.
- A defect or gap found along the way gets fixed, not raised as a question.
  Never park it as an optional follow-up for someone to approve: open its own
  branch and PR for it and say what was done. Report findings — the reasoning
  behind a decision, a trade-off taken, something deliberately left alone and
  why — but report them as work already in hand, not as a menu. Ask only
  where the answer is genuinely the user's to give and no default is
  defensible: what the app should do, which of several valid behaviours is
  wanted, or an outward-facing act with consequences beyond the repo.
- Delegate work to subagents rather than doing it inline, reserving the main
  thread for orchestration and conversation. Launch independent subagents
  concurrently.
