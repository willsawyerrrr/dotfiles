---
name: research-plan-implement
description: Three-phase workflow for non-trivial tasks — research with an agent and grill the user, plan via a private Notion review cycle, then implement with a fresh agent. Use when the user invokes /research-plan-implement, asks to "research, plan, then implement", or hands over a task large enough that jumping straight to code would waste effort.
---

# Research → Plan → Implement

Three sequential phases, each backed by a **fresh agent**. Do not skip phases, merge them, or reuse an agent across phases. Each phase ends with an explicit user confirmation before the next begins.

Pick a short kebab-case `<task-directory>` from the task statement (e.g. `auth-token-refresh`). All durable artifacts live under `docs/<task-directory>/`. Create that directory at the start of Phase 1.

## Phase 1 — Research

1. **Spawn a research agent** (Explore for codebase-heavy questions, general-purpose otherwise). Brief it with the full task statement and ask for a self-contained report covering:
   - existing materials in the repo relevant to the task (files, patterns, prior implementations)
   - external docs / APIs / services the task depends on
   - constraints, prior art, related tickets or commits
   - open questions and assumptions
2. **Write the agent's findings to `docs/<task-directory>/research.md`.** Sections: _Task statement_, _Findings_, _Open questions_, _Assumptions_. This is the durable record — keep it current as understanding evolves.
3. **Grill the user.** Walk each branch of the decision tree one question at a time. For every question, give your recommended answer with reasoning. If a question can be answered by reading the codebase, read it instead of asking. Continue until no open questions remain.
4. **Update `research.md` after each round** so it reflects the current shared understanding.

## Phase 2 — Plan

1. **Spawn a fresh planning agent.** Give it the task statement and the path to `docs/<task-directory>/research.md`. Ask it to produce an implementation plan: ordered steps, files to touch, interfaces / data shapes, risks, rollout, test approach.
2. **Create a private Notion page with the plan** using `mcp__notion__notion-create-pages`. Title it `Plan: <task>`. Place it in the user's private space (no `parent` argument, or the user's own private parent — never a shared team page). Share the page URL back to the user and ask them to leave Notion comments inline on anything they want changed.
3. **Iterate on Notion comments.** When the user signals they have commented (ask them to ping you), read the page and its comments via `mcp__notion__notion-fetch` and `mcp__notion__notion-get-comments`. For each comment: either update the page with `mcp__notion__notion-update-page`, or push back with reasoning and ask for resolution. Repeat until the user explicitly approves the plan.
4. **Once approved, write the final plan to `docs/<task-directory>/plan.md`** so it lives alongside the research doc in the repo. The Notion page is the review surface; the markdown file is the source of truth from this point on.
5. **Delete the Notion page** once `plan.md` is committed to the repo — archive it via `mcp__notion__notion-update-page` or move it to trash via `mcp__notion__notion-move-pages`. Confirm deletion succeeded before moving to Phase 3.

## Phase 3 — Implement

1. **Spawn a fresh implementation agent.** Brief it with the task statement, `docs/<task-directory>/research.md`, and `docs/<task-directory>/plan.md`. Tell it to implement the plan as written — not to redesign it. If it discovers the plan is wrong, it should stop and surface the conflict, not silently deviate.
2. **Verify before reporting done.** Read the actual diff. If the agent deviated from the plan, decide whether to accept the deviation, ask the agent to revise, or escalate to the user. The agent's summary describes intent, not what shipped.

## Rules

- Each phase uses a **new** agent. No carry-over.
- Do not start Phase 2 until the user confirms Phase 1, or Phase 3 until the user approves the plan in Notion.
- `research.md` and `plan.md` are the durable record. Keep both current; they outlive the conversation.
- If the task turns out to be trivial mid-research, surface that and offer to skip the remaining phases rather than going through the motions.
- If Notion MCP tools are unavailable, stop and ask the user how to handle the review step before continuing — do not silently fall back to inline review.
