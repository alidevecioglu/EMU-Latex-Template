# Installing LaTeX locally

Overleaf works fine for this template, but every compile round-trips to their
servers. A local install compiles the same document in a second or two and
works offline. Pick your OS below.

## macOS

Install [MacTeX](https://www.tug.org/mactex/) (full distribution, ~5 GB, includes
everything this template needs: `pdflatex`, `bibtex`, `makeindex`, and every
package referenced in `EMU_Thesis.sty`):

```bash
brew install --cask mactex
```

Or download the installer directly from https://www.tug.org/mactex/mactex-download.html.

After installing, open a **new** terminal window (PATH is set by the installer)
and confirm:

```bash
pdflatex --version
bibtex --version
makeindex --version
```

If you want a much smaller install and are comfortable letting it fetch
packages on first use, [BasicTeX](https://www.tug.org/mactex/morepackages.html)
(~100 MB) plus `tlmgr install <package>` for anything missing is an option, but
for a document with this many packages, MacTeX is the path of least resistance.

## Linux (Debian/Ubuntu)

```bash
sudo apt update
sudo apt install texlive-full
```

`texlive-full` is large (several GB) but guarantees every package this
template pulls in (`pgfplots`, `tikz`, `datatool`, `imakeidx`, `titlesec`,
`tocloft`, etc.) is present. If you want a leaner install, `texlive-latex-extra
texlive-science texlive-fonts-extra texlive-bibtex-extra` covers most of it;
if `pdflatex` complains about a missing `.sty`, install the matching
`texlive-*` package and re-run.

## Linux (Fedora/RHEL)

```bash
sudo dnf install texlive-scheme-full
```

## Linux (Arch)

```bash
sudo pacman -S texlive-most texlive-lang
```

## Verify and build

From the repo root:

```bash
./compile.sh
```

This runs the full `pdflatex → bibtex → makeindex → pdflatex → pdflatex`
sequence and writes `<title>.pdf` and `<title> - Cover-Approval.pdf` (pages
1–2) to the repo root. See `compile.sh` itself for what each step does, and
`README.md` for the rest of the project layout.

## Editor recommendation

Any editor works since this is plain text, but for local editing with syntax
highlighting, inline PDF preview, and SyncTeX (click text ↔ click PDF), either
[TeXstudio](https://www.texstudio.org/) or the [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop)
extension for VS Code are both solid, free options and were used to validate
this template.
