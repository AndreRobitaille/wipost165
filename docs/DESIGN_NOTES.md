# Design notes — what we learned building the Post 165 site

For the current synthesis of owner intent, start with [PURPOSE](PURPOSE.md) and
[UI/UX and visual guidance](UI_UX_GUIDE.md). This file preserves earlier evidence;
its old copy suggestions and layout preferences are not a current specification.

**Status:** historical observations, not specification. Nothing here binds the
new Rails design. These notes describe earlier iterations and owner feedback;
comparative claims are design judgments, not measured user research. Audience,
event frequency, and content availability may have changed. Read
[the current handoff](HANDOFF.md) for status following the Rails pivot.

This file exists to hand a fresh design session the things that were expensive to
learn and are not visible in `COMMUNITY.md`, `LEGION.md`, or `POST_MEMBERS.md`.
Those three describe the audience. This one describes what happened when we
designed *for* that audience — which instincts turned out to be wrong, which
structural decisions kept paying off, and which of the post owner's reactions
were consistent enough to be treated as real signal.

Treat it as a record of evidence. If a new direction disagrees with something
here, that is allowed — the earlier failure is useful context, not a requirement to justify a new choice.

---

## 1. The one test that mattered most

Two Rivers residents "value patriotism expressed through action rather than
symbolism alone" and "appreciate authenticity over polished marketing."
Translated into a design test that we actually used on every screen:

> **Point at something on this page that is specific, checkable, and could only
> be true of this post.** A date. A name. A place. A number. A photograph of a
> real morning.

The first homepage failed this test completely. It was 3,085px tall — 3.7
viewports — to deliver 426 words, and it contained **no date, no photograph, no
person's name, and no number other than "1919."** Every element was a star, a
seal, a ribbon, or an adjective. It looked patriotic and said nothing.

In that iteration, symbolism alone did not communicate local activity.
Specific, verifiable content gave the decoration a purpose.

## 2. Failures worth not repeating

**Uniform sections flatten hierarchy.** Six homepage bands each had the same
anatomy: centered eyebrow → serif heading → one paragraph → one button. When
everything is shaped identically, nothing reads as important, and the only thing
creating visual interest is vertical padding. Padding is air, not content. The
fix was not better bands — it was fewer, differently-shaped things.

**Copy that describes the site's own structure is dead weight.** We shipped a
sentence that read, in effect, "we keep event types separated so visitors can
find what applies to them." That is information architecture narrated out loud.
Beneath it sat three cards announcing that categories exist, naming zero actual
events. Both were deleted. If a section explains how to read the page, redesign
the page.

**A layout that depends on photography will look broken.** The available
photographs are amateur and low-resolution. Displayed small they read as
authentic; enlarged they read as careless. And the post may simply not supply
any. The old design omitted photo elements cleanly when images were absent.
That protected the layout; a future design can choose another useful empty state.

**Anything requiring a volunteer to remember a seasonal switch will fail.** The
earlier brief described no public events from October to March; that assumption
needs confirmation against the current calendar. A naive "next event" hero says
*nothing is happening here* for half the year, which is the exact opposite of the
site's story. An automatic useful empty state reduced the need for seasonal editorial work.

**Stale facts are worse than absent facts.** Dues, member counts, and contact
people drift. Empty values must omit their row entirely rather than print a
placeholder or an empty label. Nothing ships as visible lorem or a
plausible-looking invented number.

## 3. What worked

**The homepage is an answer page, not a brochure.** Visitors arrive deliberately
— from a link or word of mouth — holding one of two questions: *when is that
thing?* or *what is this post, and should I join?* Unnecessary scrolling delayed those answers in the old design. The redesign compressed 3.7 viewports of
brochure into roughly 2 viewports carrying materially more information. Density,
here, is a form of respect.

**One loud moment, quiet everywhere else.** Instead of a fixed decorative frame,
we used an intensity dial: the full motif appeared in exactly one place, and
every interior page dropped to a single connective thread and let content
breathe. One recurring quiet element that appears everywhere does more identity
work than several loud ones that appear once — and it repeats across pages
without fatigue.

**A named human outperforms a form.** Trust in this community is earned slowly
and travels by word of mouth. A first name, a role, and a way to reach that
person was the highest-value element on the page. "Ask a person, not a form."

**Ask for help, not for belonging.** The biggest single content shift: we
replaced a membership facts table (eligibility, dues, roster size) with an
invitation to *contribute*. A facts table reads as an application form — it puts
the price before the reason, and it asks someone to admit they want belonging,
which is a large and slightly embarrassing thing to ask of a veteran who is
struggling. Being *needed* asks nothing to be confessed. The post's apparent
weakness — only five or six events a year — became its strongest line:
*we are not asking for your Tuesdays.*

**Understatement over claims.** The old member-count display rounded *down* to the
nearest five with a plus. It avoided overstating the count at the time of entry,
but could still become stale as the roster changed. This is not a requirement
to show a count or use that formatter. That instinct generalizes: with this audience,
the safest register is plain fact stated once, never repeated for emphasis.

**Never make a forward promise; extend a forward invitation.** This audience
judges organizations by what they consistently accomplish, not what they
promise. "We'll be here in the future" is a boast in the one register they
distrust. "Help us be here" is not.

## 4. Structural lessons to consider

- **Logical reading order matters.** Check visual order, source order, and keyboard
  focus together at narrow and wide widths. The former grid was one solution.
- **Lead with useful information.** The old design placed dated events first on
  mobile; a new design can choose hierarchy for the experience it creates.
- **Design the empty state first.** Zero events, no photos, no contact person set
  — that is the page a visitor may well get. If it looks abandoned, the design
  is wrong regardless of how the populated version looks.
- **Color is never the only channel.** Category distinctions (public vs. members)
  carry a text label as well as a color.
- **Contrast is a floor, not a nicety.** Several muted greys we liked failed AA
  on the cream page background and had to be replaced. Check the actual pair,
  not the vibe.
- **Routine editing benefited from simplicity.** Officers could update facts
  without layout decisions. The new application can choose its own editing model;
  reducing volunteer effort remains a useful way to evaluate it.

## 5. Post-owner reactions that repeated

Useful as calibration, not as rules:

- **Heavy rules were rejected as too heavy.** A 2px navy divider was removed; a
  1px hairline in the existing warm tone was accepted. Separation is welcome;
  weight is not.
- **Vertical rhythm should stay tight.** Added space was scrutinized in
  fractions of a rem. There was an explicit ceiling on how much height a
  cosmetic change could add.
- **Empty voids read as broken, not as breathing room.** Two of the loudest
  complaints were a large gap under a column and a strap with a void in the
  middle — both were sizing bugs, but they were reported as *the design looks
  broken*. Whitespace is only luxurious when it is obviously deliberate.
- **The column line matters.** A section that spanned the full width beneath a
  two-column layout broke the vertical line the rest of the page establishes,
  and it was noticed immediately.
- **Grouping should follow meaning.** The year-at-a-glance strip was moved to sit
  directly with the dated event list, because both answer "when," and the owner
  wanted them read together.

## 6. Deliberately open

These were reasoned choices, not constraints. A new design session should feel
free to rework any of them — the notes are here so the reasoning is not lost,
not to fence the work in:

- Typography. We self-hosted a warm old-style serif for display and a civic sans
  for UI, on the reasoning that it should read dignified rather than trendy, and
  never depend on an external CDN. The *reasoning* is worth keeping; the specific
  faces are not sacred.
- The palette. Navy foundation, cream canvas, gold as a structural accent, red as
  a controlled accent. The one thing that mattered was that gold do *real*
  structural work rather than sit unused, and that red stay rare enough to still
  mean something.
- The two-column board composition, the strap that replaced the hero, the
  twelve-month rhythm strip, the placement of photographs. All of these are one
  answer to the problem in §1 and §3, not the only one.
- Where the emblem appears. The guidance we followed was formal and sparing,
  never decorative wallpaper.

## 7. Earlier brief preferences

These describe the earlier direction, not a veto on new design ideas:

generic patriotic clip art · excessive eagles · tactical or military-cosplay
aesthetics · political-campaign styling · glossy corporate marketing language ·
posed stock flag imagery · layouts that collapse without photography · homepage
news feeds that will go stale.

## 8. Questions worth asking again

If a new design session can get answers to these, it will be designing with
facts rather than around them:

1. Which of the twelve months actually have a recurring event? Earlier notes recorded only the brat fry
   and the car show as confirmed then; current details still need verification.
2. Who is the named contact, and are they willing to be named?
3. Are there photographs the post is proud of — and if not, is shipping without
   any an accepted outcome?
4. Robert E. Burns: who was he? A real local name is the most un-fakeable "then"
   anchor available, and it is still missing.
