# Shared project guidance

Applies to Codex, Claude, and other agents working in this repository.

## Direction and context

This is the future Ruby on Rails public website for Robert E. Burns American
Legion Post 165 in Two Rivers, Wisconsin, intended for hosting at Hetzner. It
complements the separate application at `~/Development/LegionPostTools`.
Read `docs/HANDOFF.md` for current repository status. For companion deployment
and data integration, start with `docs/companion-review.md` and recheck the cited
source files; the review records a changing checkout, not live production state.

Read relevant audience and mission context in `docs/LEGION.md`,
`docs/POST_MEMBERS.md`, and `docs/COMMUNITY.md` before substantial product,
design, or communication decisions. These describe the people we serve, not a
fixed feature list or visual specification. Treat demographic and operational
claims as context to verify when publishing specific facts.

`docs/DESIGN_NOTES.md`, `docs/content-notes.md`, and `docs/history/` preserve
observations and earlier experiments. Prior approvals, layouts, navigation,
copy, fonts, palettes, feature exclusions, and implementation choices do not bind
new work. Future agents may rethink them without seeking permission merely
because an old document chose differently. Rails and Hetzner are the current
user-directed choices; the remaining architecture and design are open.

## Authorization and execution

Carry requested work through implementation and proportionate verification.
Make reasonable routine decisions. Ask only for a material unresolved decision
or a tool-enforced permission requirement; continue independent authorized work
while clarification is pending.

- Inspect the worktree first. Preserve unrelated tracked and untracked changes;
  never reset, overwrite, stage, or clean them as incidental housekeeping.
- Honor authorization already given. A request to fix something includes local
  repair and verification. Commit, push, publish, deploy, and live data changes
  require authorization covering that action.
- Explicit user instructions take precedence over skill workflows, subject to
  system/tool restrictions. If a skill blocks progress, identify its path and
  exact instruction and explain the conflict.
- Scale process to the task. Plans, worktrees, TDD, reviews, and delegation are
  tools, not mandatory phases. Do not spawn subagents unless the user requests it.
- Apply skills only when relevant. The subject and audience are established;
  routine design work does not require reconfirming them.
- Changes in this repository do not authorize changes to LegionPostTools or its
  production services. Inspect its current guidance before borrowing conventions.

## Quality and care

Respect the Legion mission and the people it serves. Favor clear, truthful,
accessible communication and workflows volunteers can sustain. Use verified
local facts; omit unknown details rather than inventing them. Keep credentials
and private member information out of Git and public content.

Preserve logical reading order, keyboard access, visible focus, text alternatives,
and AA contrast. Apply authorization, input validation, and output escaping to
new application behavior. These quality expectations do not prescribe a design.

## Production operations

Read `docs/DEPLOYMENT.md` before server work. Use `bin/release` and its owned
persistent SSH tunnel for SSH, Kamal, and Docker/buildx. Stop on tunnel failure;
never fall back to repeated direct connections. Preserve the members and
Two Rivers services. The latest launch result is in
`docs/deployment/2026-09-27-coming-soon-status.md`.

## Verification

Read `docs/development.md` for the runtime and commands. `bin/ci` runs style,
security checks, database-free application tests, autoload validation, and
production asset compilation. `bin/rails test` runs focused application tests.
This app has no database connection or migration step. Keep companion databases
and credentials out of this app. A separate Kamal configuration and `bin/release`
are prepared; running push, setup, or deploy requires authorization for that action.

Run required checks once; repeat or broaden for new changes, failures, or
unresolved risks. Check relevant desktop/mobile, keyboard, and empty states when
UI is introduced. Distinguish static checks, application tests, browser checks,
and container verification. Report what changed and material limitations.
