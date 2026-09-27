# Shared project guidance

Applies to Codex, Claude, and other agents working in this repository.

## Direction and context

This is the future Ruby on Rails public website for Robert E. Burns American
Legion Post 165 in Two Rivers, Wisconsin, intended for hosting at Hetzner. It
complements the separate application at `~/Development/LegionPostTools`.
Read `docs/HANDOFF.md` for current repository status and `docs/ROADMAP.md` for
session priorities, completion criteria, and progress updates. Track companion
dependencies in `docs/companion-work-queue.md`; the reviewed publishing contract
remains the API authority. For companion deployment
and data integration, start with `docs/companion-review.md` and recheck the cited
source files; the review records a changing checkout, not live production state.

For substantial product, content, or design work, start with `docs/PURPOSE.md`
(the public site's purpose, audiences, and decisions from owner discussions) and
`docs/UI_UX_GUIDE.md` (the experience, visual direction, rejected approaches, and
review criteria). For implementation, read `docs/development.md` for setup and
verification. These guides complement the roadmap; they are not hidden task lists.

Read relevant audience and mission context in `docs/LEGION.md`,
`docs/POST_MEMBERS.md`, and `docs/COMMUNITY.md` before substantial product,
design, or communication decisions. These describe the people we serve, not a
fixed feature list or visual specification. Treat demographic and operational
claims as context to verify when publishing specific facts.

`docs/DESIGN_NOTES.md`, `docs/content-notes.md`, and `docs/history/` preserve
observations and earlier experiments. The purpose and UI/UX guides synthesize
current intent; dated explorations provide supporting evidence. Prior approvals, layouts, navigation,
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

Read `docs/DEPLOYMENT.md` before server work. **One operation means one outer SSH
connection**, from the first production inspection through build, deployment,
certificate issuance, and final verification. Use `bin/release session` and keep
that same shell/tunnel open throughout. Use `release_setup`, `release_deploy`,
`release_verify`, and `release_ssh` inside it. A failed command returns to the
same session for diagnosis; it is not permission to close and recreate the tunnel.

`bin/release check` is local-only. Never sequence a standalone remote preflight,
close its tunnel, and then create another for deployment. Standalone setup/deploy
commands are disabled. SSH, Net::SSH, and Docker must all use the session's local
forward. No direct fallback, parallel outer connections, or automatic reconnect.
If the tunnel itself fails, stop. Wait at least five minutes before one explicitly
chosen replacement attempt; preserve the next successful tunnel until finished.
Close only the tunnel owned by this operation, once, at the end. Preserve the
members and Two Rivers services. Latest status:
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
