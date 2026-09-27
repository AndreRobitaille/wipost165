# Companion review inventory — 2026-09-07

See [findings and limitations](companion-review.md). This is a coverage index, not
an instruction to reread or copy everything. Includes ignored project documents;
excludes Git internals, dependencies, runtime files, and local agent session state.
Empty placeholders are listed for completeness. No script was executed.

Review levels: **read** means full text inspected; **sections** means relevant
passages inspected; **indexed** means purpose/headings reviewed for relevance,
not a line-by-line review of old embedded code. **sample** identifies illustrative
Kamal hooks whose behavior was inspected, not activated.

128 files: 27 script/task/hook sample, 100 Markdown, 1 empty placeholder.

| Companion path | Review |
| --- | --- |
| `.kamal/hooks/docker-setup.sample` | sample |
| `.kamal/hooks/post-app-boot.sample` | sample |
| `.kamal/hooks/post-deploy.sample` | sample |
| `.kamal/hooks/post-proxy-reboot.sample` | sample |
| `.kamal/hooks/pre-app-boot.sample` | sample |
| `.kamal/hooks/pre-build.sample` | sample |
| `.kamal/hooks/pre-connect.sample` | sample |
| `.kamal/hooks/pre-deploy.sample` | sample |
| `.kamal/hooks/pre-proxy-reboot.sample` | sample |
| `AGENTS.md` | read |
| `CLAUDE.md` | read |
| `README.md` | sections |
| `bin/brakeman` | read |
| `bin/bundler-audit` | read |
| `bin/ci` | read |
| `bin/dev` | read |
| `bin/docker-entrypoint` | read |
| `bin/importmap` | read |
| `bin/jobs` | read |
| `bin/kamal` | read |
| `bin/rails` | read |
| `bin/rake` | read |
| `bin/release` | read |
| `bin/rubocop` | read |
| `bin/setup` | read |
| `bin/sync_prod_db` | read |
| `bin/thrust` | read |
| `config/postgres/init.sh` | read |
| `docs/AGENDA_ITEM_CATALOG_REORDERING.md` | indexed |
| `docs/AGENDA_PRESENTATION.md` | indexed |
| `docs/AGENT_ENVIRONMENT.md` | indexed |
| `docs/AMERICAN_LEGION_CONTEXT.md` | sections |
| `docs/ARCHITECTURE.md` | read |
| `docs/CALENDAR.md` | sections |
| `docs/CALENDAR_API.md` | read |
| `docs/CALENDAR_EVENT_DELETION.md` | indexed |
| `docs/CALENDAR_REFINEMENTS.md` | sections |
| `docs/COMMANDER_AGENDA_AND_ROLL_CALL.md` | indexed |
| `docs/DASHBOARD_ACTIVITIES.md` | read |
| `docs/DATED_AGENDA_DELETION.md` | indexed |
| `docs/DELETION_CONFIRMATION_DESIGN.md` | indexed |
| `docs/DEPLOYMENT.md` | read |
| `docs/ENDEAVOR_ACTIVITIES.md` | sections |
| `docs/ENDEAVOR_DEVELOPMENT_PLAN.md` | indexed |
| `docs/ENDEAVOR_GOVERNANCE.md` | indexed |
| `docs/ENDEAVOR_HISTORY_AI.md` | indexed |
| `docs/ENDEAVOR_HISTORY_AI_DESIGN.md` | indexed |
| `docs/ENDEAVOR_HISTORY_AI_IMPLEMENTATION_PLAN.md` | indexed |
| `docs/ENDEAVOR_HISTORY_AI_LIVE_EVALUATION.md` | indexed |
| `docs/ENDEAVOR_HISTORY_READING_DESIGN.md` | indexed |
| `docs/ENDEAVOR_MANAGEMENT_OVERVIEW.md` | indexed |
| `docs/ENDEAVOR_MEMBER_HISTORY_EXPLORATION.md` | indexed |
| `docs/ENDEAVOR_MVP_RENAME.md` | indexed |
| `docs/ENDEAVOR_REASONING_EVALUATION.md` | indexed |
| `docs/LOOPS_ROSTER_SYNC.md` | indexed |
| `docs/MEETING_FOUNDATION_AND_MEMBER_ARCHIVE.md` | indexed |
| `docs/MEMBERSHIP_MEETING_AGENDA_STRUCTURE.md` | indexed |
| `docs/MEMBER_SIGN_IN_GUIDE.md` | indexed |
| `docs/MINUTES_APPROVAL_AND_ATTESTATION.md` | sections |
| `docs/MINUTES_LIFECYCLE.md` | indexed |
| `docs/OFFICER_WORKSPACE_EXPERIENCE.md` | indexed |
| `docs/OFFICIAL_MEETING_DOCUMENTS.md` | indexed |
| `docs/PDF_DOCUMENT_DELIVERY.md` | indexed |
| `docs/PURPOSE.md` | sections |
| `docs/ROADMAP.md` | indexed |
| `docs/ROLES.md` | indexed |
| `docs/STANDARD_MEMBER_EXPERIENCE.md` | indexed |
| `docs/USERS.md` | sections |
| `docs/USER_MANAGEMENT_GUIDE.md` | indexed |
| `docs/agent-operator-skill.md` | indexed |
| `docs/loops-agent-sign-in-template-change.md` | indexed |
| `docs/reference/structured-agendas-model.md` | indexed |
| `docs/superpowers/AGENTS.md` | read |
| `docs/superpowers/CLAUDE.md` | indexed |
| `docs/superpowers/plans/2026-07-10-rails-foundation.md` | indexed |
| `docs/superpowers/plans/2026-07-11-admin-and-roster-import.md` | indexed |
| `docs/superpowers/plans/2026-07-11-auth-hardening-follow-up.md` | indexed |
| `docs/superpowers/plans/2026-07-11-documentation-foundation.md` | indexed |
| `docs/superpowers/plans/2026-07-11-login-screen.md` | indexed |
| `docs/superpowers/plans/2026-07-11-passwordless-auth-completion.md` | indexed |
| `docs/superpowers/plans/2026-07-12-admin-roster-plan-1-foundation.md` | indexed |
| `docs/superpowers/plans/2026-07-12-admin-roster-plan-2-people-person.md` | indexed |
| `docs/superpowers/plans/2026-07-12-admin-roster-plan-3-import-behaviors-admin.md` | indexed |
| `docs/superpowers/plans/2026-07-12-production-deployment-roadmap.md` | indexed |
| `docs/superpowers/plans/2026-07-12-roster-access-controls-plan.md` | indexed |
| `docs/superpowers/plans/2026-07-13-admin-hub-reorganization.md` | indexed |
| `docs/superpowers/plans/2026-07-13-agenda-item-catalog.md` | indexed |
| `docs/superpowers/plans/2026-07-13-meeting-type-templates.md` | indexed |
| `docs/superpowers/plans/2026-07-18-dated-agendas.md` | indexed |
| `docs/superpowers/plans/2026-07-18-meeting-type-hardening.md` | indexed |
| `docs/superpowers/plans/2026-07-18-position-titles-reorder.md` | indexed |
| `docs/superpowers/plans/2026-07-19-dated-agenda-review-fixes.md` | indexed |
| `docs/superpowers/plans/2026-07-19-dated-agendas-ui.md` | indexed |
| `docs/superpowers/plans/2026-07-19-kamal-ssh-persistence.md` | indexed |
| `docs/superpowers/plans/2026-07-19-meeting-types-admin-refresh.md` | indexed |
| `docs/superpowers/plans/2026-08-22-agent-sign-in-and-access.md` | indexed |
| `docs/superpowers/plans/2026-08-22-officer-agent-operability.md` | indexed |
| `docs/superpowers/plans/2026-08-22-tracked-items.md` | indexed |
| `docs/superpowers/specs/2026-07-10-foundation-and-meetings-design.md` | indexed |
| `docs/superpowers/specs/2026-07-11-admin-and-roster-import-design.md` | indexed |
| `docs/superpowers/specs/2026-07-11-auth-hardening-follow-up-design.md` | indexed |
| `docs/superpowers/specs/2026-07-11-authentication-flow-design.md` | indexed |
| `docs/superpowers/specs/2026-07-11-documentation-foundation-design.md` | indexed |
| `docs/superpowers/specs/2026-07-11-visual-design-system-design.md` | indexed |
| `docs/superpowers/specs/2026-07-12-admin-roster-visual-ux-design.md` | indexed |
| `docs/superpowers/specs/2026-07-12-production-deployment-roadmap-design.md` | sections |
| `docs/superpowers/specs/2026-07-12-roster-access-controls-design.md` | indexed |
| `docs/superpowers/specs/2026-07-13-admin-hub-reorganization-design.md` | indexed |
| `docs/superpowers/specs/2026-07-13-agenda-item-catalog-design.md` | indexed |
| `docs/superpowers/specs/2026-07-13-meeting-type-templates-design.md` | indexed |
| `docs/superpowers/specs/2026-07-18-dated-agendas-design.md` | indexed |
| `docs/superpowers/specs/2026-07-18-meeting-type-hardening-design.md` | indexed |
| `docs/superpowers/specs/2026-07-18-position-titles-reorder-design.md` | indexed |
| `docs/superpowers/specs/2026-07-19-dated-agendas-ui-design.md` | indexed |
| `docs/superpowers/specs/2026-07-19-kamal-ssh-persistence-design.md` | sections |
| `docs/superpowers/specs/2026-07-19-meeting-types-admin-refresh-design.md` | indexed |
| `docs/superpowers/specs/2026-08-22-agenda-sections-design.md` | indexed |
| `docs/superpowers/specs/2026-08-22-agent-sign-in-and-access-design.md` | indexed |
| `docs/superpowers/specs/2026-08-22-officer-agent-operability-design.md` | indexed |
| `docs/superpowers/specs/2026-08-22-people-api-design.md` | indexed |
| `docs/superpowers/specs/2026-08-22-tracked-items-design.md` | indexed |
| `docs/superpowers/specs/2026-08-29-agent-agenda-api-parity-design.md` | indexed |
| `docs/superpowers/specs/2026-08-30-roster-managed-user-access-design.md` | indexed |
| `docs/superpowers/specs/2026-08-31-admin-jobs-console-design.md` | indexed |
| `docs/superpowers/specs/2026-08-31-agent-minutes-api-parity-design.md` | indexed |
| `lib/tasks/endeavor_history.rake` | read |
| `script/.keep` | empty |
| `script/evaluate_endeavor_history.rb` | read |

Additional implementation cross-checks: `config/deploy.yml`, `Dockerfile`,
`config/routes.rb`, `app/models/calendar_event.rb`, `app/models/calendar_month.rb`,
API calendar controllers, and the authentication callback in
`app/controllers/api/base_controller.rb`. Configuration/scripts establish repository
intent; they do not verify current production state.
