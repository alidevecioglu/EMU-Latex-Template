# Contributing

This template exists because format-control requirements keep surfacing
the same handful of mechanical issues across different students' theses.
It only stays useful if it keeps absorbing what future EMU students run
into, since IGSR requirements and department/school conventions can and
do change over time. If something in your own format-control review
doesn't match what this template produces, that's a signal worth
reporting, not just fixing quietly in your own copy.

## What counts as a good contribution

- **A format-control issue you actually hit**, ideally with a note on
  what the reviewer said. This is the same bar the existing fixes were
  held to (see README, "Fixes applied"): confirmed against real feedback,
  not guessed at from reading the template.
- **An IGSR requirement that changed.** Page margins, required front-matter
  sections, citation style, the Department-vs-School approval wording,
  anything the Institute updates that this template now gets wrong.
- **A genuine LaTeX bug**: a macro that breaks under a normal, expected
  use case (a long table, a landscape figure, a nested list), not a
  workaround for one specific document's edge case.
- **Documentation**: a fix that only lives in your head until it's
  written down doesn't help the next student.

## What doesn't belong here

- Content from your own thesis (title, abstract, chapters, bibliography
  entries). This is a template; keep your actual thesis in your own fork
  or a separate repo, the way `chapters/`, `figures/`, and the front-matter
  placeholders in `EMU_Thesis.tex` are meant to be replaced downstream,
  not upstream.
- Personal formatting preferences that aren't format-control requirements.
  If IGSR doesn't check for it, it's your thesis's call, not the
  template's.
- Large, speculative refactors "while we're in there." Small, scoped,
  explained changes are easier to trust and easier to revert if wrong.

## How to contribute

1. Open an issue first if you're not sure a change belongs here, especially
   for anything bigger than a one-line fix. A quick "does this match your
   experience too" check saves a rewritten pull request later.
2. Fork the repo, make your change, and confirm it compiles:
   ```bash
   ./compile.sh
   ```
   Check the output PDF for the actual page(s) your change affects, not
   just that the build didn't error.
3. If your fix changes visible output (spacing, alignment, a new default),
   say what it looked like before and after in the pull request. A
   before/after screenshot of the relevant page is the fastest way to get
   a review approved.
4. Update `README.md` if you're adding or changing a fix: the "Fixes
   applied" list is meant to be a complete, current account of everywhere
   this fork diverges from the original template, with the reasoning for
   each divergence, not just a changelog.
5. Keep the original attribution intact. This template is CC BY 4.0
   (see `LICENSE`); don't remove the credit to Erfan A. Shams or the
   authorship history in `EMU_Thesis.sty`'s header, add to it.

## Reporting a format-control issue without a fix in hand

Not everyone who hits a problem has time to also fix it, and that's fine.
Open an issue with:

- What the reviewer flagged, as close to their exact wording as you have.
- Which file/section of the template produced the flagged output.
- A page number or screenshot from your own compiled PDF if you have one.

That's enough for someone else to pick up.

## Style notes for this repo specifically

- Comments explaining *why* a fix exists (what it addresses, what breaks
  without it) are more valuable here than comments explaining *what* the
  LaTeX does; the "what" is usually clear from the code itself.
- Match the existing `chapters/NN-kebab-title.tex` naming and `\input{}`
  pattern for any new example content.
- Don't use em dashes in prose you add to this repo (README, this file,
  code comments); use a comma, colon, or period instead.
