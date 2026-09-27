# Agent environment audit — 2026-09-07

> Historical audit from before the Rails pivot that same day. File paths, command
> descriptions, and platform references below describe the former repository or
> that machine at the time; they are not setup instructions for the new project.
> Some referenced files were retired. Use [the handoff](HANDOFF.md) and
> [current guidance](../AGENTS.md) for the repository's present state.

This is an audit record, not a standing workflow. `AGENTS.md` owns shared project
instructions; Claude entry points import it. Machine-specific observations below
must be rechecked on another installation or after plugin updates.

## Official migration baseline

Reviewed the official [Astra migration and prompting guidance](https://developers.openai.com/api/docs/guides/latest-model)
and [model page](https://developers.openai.com/api/docs/models/gpt-6-astra).
The exact identifier is `gpt-6-astra` (no embedded space). Astra's stronger
instruction following makes skills, lifecycle-injected text, and dated plans
relevant migration surfaces. The project guidance now makes follow-through,
existing authorization, proportionate checks, and delegation boundaries explicit.

For an applicable future API migration: preserve effective reasoning effort;
replace `none`/`minimal` with `low`; use Responses for tool calling; remove
unsupported sampling/logprob options; review old prompt-cache retention and EU
Fast-mode compatibility. These are compatibility notes, not a request to add an
API client to this theme.

## Repository findings and changes

- Root guidance was minimal while `CLAUDE.md` duplicated project requirements.
  Consolidated them in `AGENTS.md`, with a Claude import and nested imports under
  `docs/superpowers/`. Preserved ownership, design, content, accessibility,
  security, and deployment requirements.
- Dated plans required Superpowers, subagents, tests after each task, and commits.
  Added historical banners and nested guidance; retained the original plan/spec
  bodies as evidence. Those instructions are not current authorization.
- Corrected the handoff's three-block layout to the actual four-block board:
  events → ask → year → pillars in source/mobile order. Distinguished desktop
  column layout from reading order. Corrected the theme version to `0.4.3`, the
  photo limit to four, and the test description to include pure PHP tests.
- Reconciled contradictory local-preview claims: a personal Docker recipe is
  documented, but no WordPress server is provisioned by this repo and the static
  preview cannot render the dynamic homepage. Replaced an unverified assertion
  that live pages do not exist with an instruction to check the target site.
- Build, lint, and typecheck all execute the same static validator. Guidance now
  avoids running those aliases repeatedly and reserves PHP/browser checks for
  relevant changes. No runtime theme code or deployment workflow changed.
- The initial worktree contained modified `CLAUDE.md` and untracked
  `docs/DESIGN_NOTES.md`. The latter is byte-for-byte unchanged. The Claude entry
  point consolidation preserves the prior removal of duplicated command/path
  details by keeping commands only in the shared guidance.

No application model API client or active application model setting was found in
the theme, scripts, package configuration, or workflow. No application model
replacement, SDK update, paid model call, or fallback change was needed.

## Inherited configuration and plugin behavior

Inspected ancestor entry-point locations, the empty user Codex `AGENTS.md`,
Codex TOML/hooks, Claude settings and installed-plugin registry, plugin manifests,
relevant shared skills, and lifecycle scripts. No repository-local agent settings,
skills, or lifecycle hooks were present. The Claude project memory directory was
empty; no `/etc/codex` or `/etc/claude-code` directory was present.

- `~/.codex/config.toml` already selects `gpt-6-astra` with `medium` reasoning.
  Kept it unchanged, including unrelated profiles, plugins, permissions,
  historical migration notices, and processing preferences.
- Claude's Superpowers, claude-code-setup, and security-guidance flags were already
  false and remain false. Cowork plugin management was absent from inspected local
  installations/configuration. No uninstall or additional disable was needed.
- Superpowers 6.3.0's SessionStart script injects its mandatory skill instructions.
  Security-guidance 2.0.7 has SDK-bootstrap, edit, commit/push, and stop-review hooks,
  including asynchronous rewakes. Keeping their flags disabled avoids those
  workflows; switching models would not remove them.
- Native documents, PDF, spreadsheets, presentations, and skill-creator skills are
  available. No installed Anthropic DOCX/PDF/XLSX/PPTX/skill-creator duplicates were
  found to selectively disable. Other plugins were preserved.
- Ruby LSP's configuration is supplied inline by the marketplace (`strict: false`),
  not by a missing cached `.lsp.json`. Its command exists on PATH and its supported
  extensions are Ruby-related; no evidence justified changing it for this PHP repo.
- Retained frontend-design. Its confirmation wording is conditional on an unknown
  subject; this project's subject/audience are already established. Root guidance
  prevents routine reconfirmation and preserves the actual design brief.
- Repaired `~/.agents/skills/simplify/SKILL.md`: replaced the malformed
  `http://CLAUDE.md` reference and unconditional React/TypeScript conventions with
  local shared guidance and project-specific conventions. Retained its scope and
  behavior-preservation requirements; clarified proportionate verification.
- Reproduced a Claude status-line formatting failure with a literal `%` in model
  names. Repaired `~/.claude/statusline-command.sh` to pass dynamic values as
  arguments to constant `printf` formats, preserving literal percent/backslash
  text in model, directory, branch, and other displayed fields.
- Both Herdr SessionStart hooks report session metadata through a local socket
  only when Herdr environment variables are present. They do not inject prompts
  or require approval. Their scripts and configuration were preserved.

Before global edits, settings, config, status-line script, and simplify skill were
backed up under `~/.claude/backups/wipost165-astra-20260907T152037Z/`, with original
paths and SHA-256 hashes in `manifest.json`. Settings JSON and Codex TOML remained
byte-for-byte identical to those backups. The backup contains private machine
configuration and belongs outside Git.

## Verification and activation

Passed: static theme validation (`npm run lint`), diff whitespace checks,
JSON/TOML parsing, model/plugin assertions, original design-notes comparison,
status-line shell syntax and literal-text regressions, and both Herdr hooks'
syntax, inactive no-op, and active reporting against isolated temporary sockets.
Checked guidance imports/paths and historical-body preservation.

No full PHP suite or browser run was warranted for instruction/documentation and
status-line changes. No live WordPress state, model account access, or end-to-end
agent client reload was tested. Playground availability remains unverified; it
is not an Astra migration blocker.

Start a fresh agent session to reload edited guidance/skills and discard previously
injected instructions. The status-line repair applies on its next invocation.
No WordPress restart is needed. No commit, push, deploy, plugin uninstall, live
content write, or production change occurred.
