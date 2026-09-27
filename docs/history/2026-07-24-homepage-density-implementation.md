# Homepage behavior lessons

Historical summary, distilled on 2026-09-07. Superseded as a specification;
all prior design and implementation choices may be reconsidered.

The experiment separated date arithmetic and formatting from platform rendering.
It calculated recurring meetings, applied per-occurrence overrides, combined them
with event data, and provided an empty-season fallback. This separation made pure
logic testable; it did not validate the integrated calendar or rendered homepage.

Cases worth remembering if similar behavior is chosen again include month/year
rollover, the local timezone and daylight-saving changes, before/after-start
boundaries, cancelled or rescheduled occurrences, partial overrides, invalid
inputs, unavailable event sources, empty calendars, and duplicate meetings.

An optional member-count formatter rounded down to a multiple of five with a
plus (183 became 180+), kept small positive counts exact, and omitted zero. This
was an understatement convention, not a reliable way to prevent stale data or
a requirement to publish counts.

Facts repeated in a footer and contact page could drift away from editable
meeting settings. Cached output could also freeze time-sensitive dates. Those
are ownership and freshness problems to consider in any implementation.

The static checks and isolated PHP tests did not boot the old application.
Their commands and code listings are retired; a Rails suite should exercise the
behavior actually selected for the new site.
