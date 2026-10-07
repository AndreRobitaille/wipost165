# Civic pennant — October 7, 2026

Status: **the owner disliked the banner/pennant image and requested AI artwork
based on real Two Rivers photos.** See the [harbor illustration revision](../2026-10-harbor-study/README.md).
This original study remains comparison material. It does not replace
any Rails page. The owner likes the messaging, wants a more compelling visual
identity, found the ten outside references too experimental, and clarified that
Take the Con does not imply a literal binder. This pass tries one concrete middle
ground instead of another reference collection.

## Direction

A contemporary civic pennant gives Post 165 an identifiable graphic without
people, photography, fictional activities, or an invented building. A tilted
Post pennant, diagonal bands, restrained gold trim, and contrasting dates supply
its character. Ordinary navigation and reading remain familiar. The official
Legion wordmark is unchanged; the pennant is proposed local artwork, not an
official Legion emblem.

Palette: Legion-inspired blue `#064775`, deep navy `#102f46`, red `#b32334`,
gold `#e8c67c`, pale reading ground `#eff2ed`, and warm white `#fcfaf3`.
The reading ground/text adapt to dark appearance. Gold is an accent on dark
surfaces, not small text on the light reading ground.

Company Sans handles headings, navigation, and body text. Company Display is
reserved for the Post number, calendar dates, and meeting time. Both are existing
licensed assets; see `app/assets/fonts/FONT-LICENSE.txt`.

Desktop composition:

```text
Legion wordmark + Post identity             Home / Events / First visit / Contact

        POST 165 pennant                  Still serving. In good company.
          over diagonal bands             Mission / Events action
                                          First-visit introduction

October 24 / Next public occasion                         Regular meeting

Have a question?                                         Contact the Post
```

Home uses a large identity graphic and a compact next-occasion band. Events groups
continuous rows by month, with large dates and a clear arrow response on hover.
First visit keeps all five answers expanded, with a red meeting pennant alongside
the desktop reading column. Contact makes the actual channels prominent and keeps
the mailing address distinct from the meeting location. A smaller pennant carries
the identity into each interior page.

On phones, the Home pennant becomes a compact mark beside the opening label.
The initial separate graphic section was removed after inspection because it
pushed the next occasion too far down. The design controls adjust only pennant
angle/scale; they belong to the review host, not the proposed public navigation.

## Content and scope

The four events are the same fixed calendar snapshot used in the earlier study,
labelled October 7, 2026. They are not a newly verified or live schedule. Contact
and meeting facts come from `docs/launch-content-readiness.md`. No publisher reads,
publisher changes, people/stories/photos, or production actions are part of this
study. Existing Home messaging and the five visit questions are preserved.

The review includes four local page views, event dialogs, and actual email/phone
link destinations. These are prototype interactions: normal event URLs,
no-JavaScript fallbacks, feed lifecycle and empty/unavailable behavior, and the
supporting About/Membership/Help pages still belong to a future Rails translation.
Do not copy the fixed event data into the app. V1 and V2 application code is
unchanged by this proposal.

## Review evidence

Representative captures are in `previews/`. `browser-checks.json` records the
sandboxed preview navigation; `functional-checks.json` records focused interaction
and layout checks in a temporary direct rendering of the same fragment. These
checks verify prototype behavior, not owner approval or production readiness.

Checked all four page views at 320, 390, 630, 800, 1024, and 1440px: no horizontal
page overflow or out-of-bounds link targets; all five visit answers remain visible.
Inspected desktop/intermediate/phone captures of the sandboxed preview and both
light/dark phone appearances. Event details open in the host preview and in the
direct harness. Escape restores the event trigger, Enter reopens it, Close works,
and Tab/Shift+Tab remain within the dialog after a focused keyboard refinement.
See `modal-final-checks.json` and `previews/event-modal-host.png`.

The fragment passes JavaScript syntax, embedded-asset, document-shape, and size
checks. Thirteen primary text/background combinations meet 4.5:1 contrast; the
lowest checked pair is 5.12:1. Browser runs reported no script errors. This is a
focused prototype review, not a complete accessibility audit or Rails verification.
No application tests or production build were rerun because application code did
not change. No commit, push, publication, or deployment occurred.

Editable source: [study fragment](study-fragment.html). This self-contained review
source embeds the existing licensed fonts and unchanged official wordmark. Its
interactive inline counterpart is saved in this chat's durable visualization
folder. Owner feedback on the appearance is still the next decision.
