# EMU Thesis LaTeX Template (fixed fork)

![A man happily throws a Word document into the trash while a laptop on a nearby desk displays cleanly typeset LaTeX math](images/man-throws-word-into-trash.png)

A fork of the official Eastern Mediterranean University thesis LaTeX
template, with a set of formatting fixes applied that repeatedly came up
during format-control review across several actual EMU theses (see
"Fixes applied" below). The template's own design, preamble, geometry,
title/approval page layout, fonts, and bibliography style, is otherwise
unchanged from the original.

**This does not exempt you from format control.** It fixes mechanical
issues (caption alignment, float placement, page numbering, list
exclusions) that the stock template gets wrong for *every* student by
default. Content, wording, and anything specific to your program or
committee is still your responsibility to verify.

Requirements change and new format-control issues surface every year.
If this template should keep working for future EMU students, see
`CONTRIBUTING.md` for how to report or fix one.

## Why LaTeX instead of Word

A thesis is a long, structured, heavily cross-referenced document under a
strict formatting spec: exactly the case Word handles worst and LaTeX
handles best.

- **Consistency you don't maintain by hand.** Every table caption is
  left-aligned and every figure caption is centered because it's declared
  once (`\captionsetup`), not because you remembered to fix each one.
  Word's Styles panel can do this in principle; in practice a 100-page
  thesis with pasted-in tables from three sources always ends up
  inconsistent somewhere, and Track Changes is not the tool that catches it.
- **Numbering that never drifts.** Chapter, section, table, figure, and
  equation numbers, and every cross-reference to them (`Table~\ref{...}`,
  `Section~\ref{...}`), are computed at compile time. Reorder a chapter and
  every number and every reference to it updates automatically. In Word,
  reordering a chapter is the moment your figure numbers and your
  "see Table 4.2 above" callouts quietly go stale.
- **A real diff.** This template is plain text, so `git diff` shows you
  exactly which sentence changed between two revisions, which is how the
  formatting fixes in this fork were even findable in the first place.
  Track Changes in a `.docx` is a proprietary binary diff you can only
  view inside Word itself.
- **The bibliography is a database, not a chore.** `references.bib` +
  `\cite{}` means adding a citation, reordering references, or switching
  citation styles (APA, IEEE, Chicago) is a one-line style change, not a
  manual renumbering pass. Word's citation manager works until it doesn't,
  usually right before a deadline.
- **Math that looks like math.** `$e^{\pi i} + 1 = 0$` versus Word's
  Equation Editor, which is a separate, slower, less expressive tool
  bolted onto a word processor rather than a first-class part of the
  document language.
- **It's just a text file.** No "this document was created in a newer
  version of Word," no corrupted `.docx` the night before submission, no
  license required to open it. Any editor, any OS, forever.

The tradeoff is real: LaTeX has a learning curve Word doesn't, and this
template's job is to absorb as much of that curve as possible so you're
fighting your content, not your typesetting.

## Credit and license

Original template: **"Eastern Mediterranean University (EMU) Thesis
LaTeX Template 2022 (v1.0)"** by **Erfan A. Shams**, published on
Overleaf, licensed **Creative Commons Attribution 4.0 International (CC
BY 4.0)**. This fork and its modifications are licensed the same way.
See `LICENSE` for the full notice, and the header comments in
`EMU_Thesis.sty` for the file's own attribution history (it also credits
Aykut Hocanin and Ali Ovgun for earlier versions).

### Authorship history

`EMU_Thesis.sty` has passed through several hands, each building on the
last. This fork is the latest link, not a from-scratch rewrite:

| Who | What they added |
|---|---|
| Aykut Hocanin | Original macros for the EMU thesis format |
| Ali Ovgun (2016) | Revisions to the base template |
| Erfan A. Shams (2021) | Current published version: nomenclature-package support, horizontal (landscape) page support, INDEX support, and the CC BY 4.0 relicense this fork inherits |
| Ali Devecioglu (2026, this fork) | The format-control fixes and additions listed above: caption alignment, float placement, page-numbering, appendix list exclusion, revision markup, configurable chair/director title |

Each of those additions exists because the version before it didn't do
something a real thesis needed: landscape pages for wide figures, an
index for a math-heavy thesis, and, for this fork, format-control
rejections that kept recurring across multiple students' actual defense
submissions (see "Fixes applied" above for the specific reasoning behind
each one).

### Contributors

The fixes in this fork weren't guessed at. They're things this project's
author and the following fellow EMU students independently hit and
confirmed in their own theses' format-control review, which is what made
them worth fixing here for everyone:

- [İsmet Volkan Mimar](https://github.com/ism3t)
- [Mustafa Mehmet Yaman](https://github.com/YamanMustafa)

## Getting started

```bash
git clone <this-repo>
cd EMU-Latex-Template
./compile.sh
```

See `INSTALL.md` if `pdflatex`/`bibtex`/`makeindex` aren't installed yet
(macOS/Linux). Or just open the folder in Overleaf: the template was
originally written for and tested there, and still works the same way.

Edit `EMU_Thesis.tex` for your title, author, committee, and front-matter
metadata (marked with comments), then write your actual chapters in
`chapters/` and reference them with `\input{chapters/...}` the same way
the two example chapters are.

## Automated PDF releases

`.github/workflows/release.yml` builds the thesis on every push to
`main`/`master` (or manually via the Actions tab) and publishes a
[GitHub Release](../../releases) with the PDF attached, named
`<title>-v<run-number>.pdf`, plus the 2-page cover/approval PDF. It runs
the exact same `compile.sh` you'd run locally, inside the official
`texlive/texlive` container so the environment matches, so a release
only appears if the real build actually succeeds. No setup needed: it
uses the repo's default `GITHUB_TOKEN`, no secrets to configure. Disable
it by deleting the workflow file if you'd rather build and share PDFs by
hand.

## File structure

```
EMU_Thesis.tex          main file: preamble, front matter, \input chapters, back matter
EMU_Thesis.sty          EMU style file (fixes applied here + in EMU_Thesis.tex, see below)
EMU_Index.ist           index style (unchanged)
references.bib          example bibliography entries
compile.sh              full local build -> "<title>.pdf" + "<title> - Cover-Approval.pdf"
chapters/
  01-introduction.tex          example Chapter 1 (general LaTeX/formatting instructions)
  02-preliminary-sections.tex  example Chapter 2 (theorems, tables, figures, landscape pages)
  appendices.tex               example appendix content
figures/
  Discontinuity_removable.eps  the template's sample figure
```

Add your own chapters as `chapters/NN-kebab-title.tex` and `\input{}` them
from `EMU_Thesis.tex` in order; put your images in `figures/`.

## Fixes applied over the original template

Each of these was independently confirmed against real EMU format-control
feedback on more than one thesis before being folded in here, not guessed
at from the template alone.

1. **Table/figure caption alignment.** IGSR format control expects table
   captions left-aligned and figure captions centered; the stock template
   sets neither, so every student gets flagged for it. Fixed globally in
   `EMU_Thesis.tex`:
   ```latex
   \captionsetup[table]{justification=raggedright,singlelinecheck=false}
   \captionsetup[figure]{justification=centering,singlelinecheck=false}
   ```
   With this set globally, don't add `\centering` inside `\caption{}` for
   tables: it fights the global setting for that one caption.

2. **Figures/tables jumping to the top of the next page.** With LaTeX's
   default float parameters, a figure or table that *almost* fits under
   its paragraph gets pushed to the top of the following page instead,
   leaving a dead gap where it "should" have gone. A small trailing trim
   on every figure/table environment (in `EMU_Thesis.tex`) lets more of
   them stay where they're declared:
   ```latex
   \AtEndEnvironment{figure}{\vspace*{-6pt}}
   \AtEndEnvironment{table}{\vspace*{-18pt}}
   ```
   This is a targeted hack, not a principled fix. If you see any caption
   crowding a table/figure body after adding a lot of new floats, check
   this first.

3. **Main-body page numbering starting on the wrong page.** `\clearpage`
   is now issued immediately before `\pagenumbering{arabic}`, so page 1
   of the body reliably lands on the actual first page of Chapter 1.

4. **Appendix tables/figures leaking into the front-matter lists.** The
   List of Tables / List of Figures must only list body tables/figures,
   not the ones inside your appendices. Fixed by scoping `list=no` to the
   `appendices` environment in `EMU_Thesis.tex`:
   ```latex
   \begin{appendices}
   \captionsetup[table]{list=no}
   \captionsetup[figure]{list=no}
   \input{chapters/appendices}
   \end{appendices}
   ```

5. **Wide tables silently overflowing the right margin.** Not a macro
   fix, a documented pitfall (see the comment in
   `chapters/02-preliminary-sections.tex`). An unwrapped `l`/`c`/`r`
   table column takes the natural width of its widest cell; one long
   entry in that column can push the whole table past the text width
   with no compile error, just an `Overfull \hbox` warning easy to miss
   in a long log. Give every column of a wide table an explicit
   `p{...}` width instead.

6. **Caption and keyword capitalization convention.** Also
   format-control-checked, also not a macro fix: captions are sentence
   case (only the very first letter of the whole caption is capitalized;
   a later sentence within the same caption stays lowercase unless it's
   a proper noun, abbreviation, or technical term), and each keyword in
   the Abstract/ÖZ keyword line is capitalized. Both are called out in
   the relevant placeholder comments in `EMU_Thesis.tex`.

7. **Optional: committee-revision markup.** `\revadd{...}` (red text) and
   `\flaghl{...}` (yellow highlight) let you visibly mark what changed in
   response to committee/supervisor feedback during a revision pass,
   without hand-tracking it. Build with `\CLEANCOPY` defined to get a
   plain copy back for a pure formatting check, with nothing further to
   edit:
   ```bash
   pdflatex -jobname=EMU_Thesis_formatcheck "\def\CLEANCOPY{1}\input{EMU_Thesis.tex}"
   bibtex EMU_Thesis_formatcheck
   pdflatex -jobname=EMU_Thesis_formatcheck "\def\CLEANCOPY{1}\input{EMU_Thesis.tex}"
   pdflatex -jobname=EMU_Thesis_formatcheck "\def\CLEANCOPY{1}\input{EMU_Thesis.tex}"
   ```
   Defined in `EMU_Thesis.sty`; unused (and harmless) if you never wrap
   anything in `\revadd{}`/`\flaghl{}`.

8. **Department vs. School title on the approval page.** Some EMU units
   are organized as a "Department" (signed by a Chair) and others as a
   "School" (signed by a Director/Acting Director); the stock template
   hardcodes "Chair, Department of". Now configurable:
   ```latex
   \DeptChairTitle{Acting Director, School of}  % only if your unit needs it
   ```
   Defaults to the original "Chair, Department of" wording if you don't
   set it, so existing Department-based approval pages are unaffected.

## What's unchanged

The document class, page geometry, fonts, title-page and approval-page
layout, bibliography style, index mechanism, and every example chapter's
actual instructional content are all exactly as the original template
shipped them. If format control flags something not on the list above,
that's real content you need to fix yourself: check the IGSR guideline
document referenced in Chapter 1 first.
