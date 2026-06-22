---
name: research-plan-implement
description: Three-phase workflow for non-trivial tasks — research with an agent and grill the user, plan via a private Notion review cycle, then implement with a fresh agent. Use when the user invokes /research-plan-implement, asks to "research, plan, then implement", or hands over a task large enough that jumping straight to code would waste effort.
---

# Research → Plan → Implement

Three sequential phases, each backed by a **fresh agent**. Do not skip phases, merge them, or reuse an agent across phases. The plan phase ends with explicit user approval (via Notion) before implementation begins; the research phase transitions to planning once grilling has resolved all open questions — no separate sign-off on the research doc.

Pick a short kebab-case `<task-directory>` for the work. If the user has given you a branch name, use it verbatim as `<task-directory>` so the worktree, branch, and docs stay in sync; otherwise derive one from the task statement (e.g. `auth-token-refresh`). All work — research notes, plan, and implementation — happens inside a dedicated git worktree; durable artifacts live under `docs/<task-directory>/` within that worktree.

**Create the worktree before anything else.** Call `EnterWorktree` with `name: <task-directory>`. The tool creates the worktree and switches the session's cwd into it; the new branch is named `<task-directory>` and the base ref is governed by the user's `worktree.baseRef` setting. Do not fetch, branch, or `cd` manually. Every subsequent step in all three phases — your own commands and every spawned agent — runs inside this worktree; the original checkout stays untouched.

**Rename the Claude Code session** as soon as `<task-directory>` is chosen, so the session is easy to find later. If the work is tied to a Linear issue, use `<ISSUE-ID>: <Issue title>` (e.g. `SCR-1234: Add some new feature`); otherwise use the `<task-directory>` value verbatim. Do this without asking.

## Phase 1 — Research

1. **Spawn a research agent** (Explore for codebase-heavy questions, general-purpose otherwise). Brief it with the full task statement and ask for a self-contained report covering:
   - existing materials in the repo relevant to the task (files, patterns, prior implementations)
   - external docs / APIs / services the task depends on
   - constraints, prior art, related tickets or commits
   - open questions and assumptions
2. **Write the agent's findings to `docs/<task-directory>/research.md`.** Sections: _Task statement_, _Findings_, _Open questions_, _Assumptions_. This is the durable record — keep it current as understanding evolves. The research doc is yours to maintain; do not ask the user to review or sign off on it.
3. **Grill the user** by invoking the `grill-me` skill. Continue until no open questions remain.
4. **Update `research.md` after each round** so it reflects the current shared understanding. Once all open questions are resolved and you're aligned with the user, move directly to Phase 2 — no further confirmation step.

## Phase 2 — Plan

1. **Spawn a fresh planning agent.** Give it the task statement and the path to `docs/<task-directory>/research.md`. Ask it to produce an implementation plan: ordered steps, files to touch, interfaces / data shapes, risks, rollout, test approach.
2. **Create a Notion page with the plan** using `mcp__notion__notion-create-pages`. Title it `Plan: <task>`. **Parent must be the user's "Claude planning document review" hub page** — find it via `mcp__notion__notion-search` with that exact title and use the returned page id as `parent: {"type": "page_id", "page_id": "<id>"}`. If search returns no match, **create the hub first**: call `mcp__notion__notion-create-pages` with title `Claude planning document review` and no parent (so it lands in the user's private space), then use the new hub's id as the parent for the plan page. Never place the plan as a standalone workspace-level page or under a shared team page. **Immediately open the new plan page** by running `open '<url>'` via Bash — do this every time a plan page is created, without asking. Then share the URL back to the user, tell them to leave Notion comments inline on anything they want changed, and explain that you will poll the page for comments rather than waiting to be pinged.
3. **Poll for comments instead of waiting to be pinged.** After sharing the URL, repeatedly check the page for new comments via `mcp__notion__notion-get-comments` (and `mcp__notion__notion-fetch` for any inline edits). Drive the polling cadence with `ScheduleWakeup` and **back off over time**: poll quickly at first (every 20–30s, e.g. `delaySeconds: 20`), then progressively lengthen the interval (e.g. 30s → 60s → 120s → cap around 300s) the longer the page stays quiet. Reset back to the fast cadence whenever a new comment lands, since more usually follow. Re-fetch comments each time you wake, passing the same `/research-plan-implement` context back so the loop continues. Keep polling until either new comments appear or the user explicitly approves; stop scheduling wake-ups once the plan is approved and committed. Track which comment ids you have already handled so you only act on new ones. For each new comment: either update the page with `mcp__notion__notion-update-page`, or push back with reasoning and ask for resolution. **After every `notion-update-page` call, re-fetch the page with `mcp__notion__notion-fetch` and confirm the edit actually landed as intended** — `update_content` operations can silently no-op or apply to the wrong block if `old_str` doesn't match exactly. If the page doesn't reflect the change, retry with corrected input before moving on. Repeat until the user explicitly approves the plan.
4. **Once approved, write the final plan to `docs/<task-directory>/plan.md`** so it lives alongside the research doc in the repo. The Notion page is the review surface; the markdown file is the source of truth from this point on.
5. **Trash the Notion page** once `plan.md` is committed by removing the child page reference from the hub. Fetch the hub via `mcp__notion__notion-fetch` to read its current content, then call `mcp__notion__notion-update-page` with `command: "update_content"`, `allow_deleting_content: true`, and a single `content_updates` entry whose `old_str` is the exact `<page url="...">...</page>` line for this plan and whose `new_str` is `""`. Removing the sub-page block from the hub's content sends the child page to trash. Verify by re-fetching the child page and checking that its `<page>` tag now carries the `deleted` attribute.

## Phase 3 — Implement

1. **Commit the docs first.** `docs/<task-directory>/research.md` and `plan.md` should already be in the worktree; stage and commit them on the `<task-directory>` branch (e.g. `docs: Add research and plan for <task-directory>`) so the implementation history starts from a clean tree. No new branch is needed — the worktree's branch is the implementation branch.
2. **Spawn a fresh implementation agent.** Brief it with the task statement and the paths to `docs/<task-directory>/research.md` and `docs/<task-directory>/plan.md`. State explicitly that it is working inside a git worktree and must not switch branches, create new worktrees, or call `EnterWorktree` / `ExitWorktree` itself. Tell it to implement the plan as written — not to redesign it. If it discovers the plan is wrong, it should stop and surface the conflict, not silently deviate. Explicitly instruct it to **commit its changes in multiple meaningful commits** so the user can review commit-by-commit — each commit a logical unit (e.g. one refactor, one feature step, one batch of tests), not a single mega-commit and not one commit per file. Commit messages must follow Conventional Commits with the first word after the type capitalised (e.g. `feat: Add token refresh`). The agent must **not push** — leave the branch local for the user to review and push themselves.
3. **Verify before reporting done.** Read the commit log and the diff of each commit. If the agent deviated from the plan, or if the commit breakdown is unhelpful (mega-commit, per-file noise, mixed concerns), decide whether to accept it, ask the agent to revise (including re-doing the commits), or escalate to the user. The agent's summary describes intent, not what shipped. Do not call `ExitWorktree` proactively — the user will be prompted to keep or remove the worktree on session exit, or can ask you to exit explicitly.

## Rules

- Each phase uses a **new** agent. No carry-over.
- All three phases run inside the worktree created at the start of Phase 1 via `EnterWorktree`. Never operate on the main checkout, never switch branches inside the worktree, and never push. Do not call `ExitWorktree` proactively — only when the user explicitly asks.
- Transition from Phase 1 to Phase 2 once grilling is complete and you're aligned with the user — no explicit sign-off on `research.md`. Do not start Phase 3 until the user approves the plan in Notion.
- `research.md` and `plan.md` are the durable record. Keep both current; they outlive the conversation.
- If the task turns out to be trivial mid-research, surface that and offer to skip the remaining phases rather than going through the motions. If you abandon the work, leave the worktree in place — the user can choose to remove it on session exit or via an explicit `ExitWorktree` request.
- If Notion MCP tools are unavailable, stop and ask the user how to handle the review step before continuing — do not silently fall back to inline review.
