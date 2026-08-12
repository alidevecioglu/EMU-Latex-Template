#!/usr/bin/env bash
#
# Build the thesis PDF locally (macOS/Linux) with a full
# pdflatex -> bibtex -> makeindex -> pdflatex -> pdflatex sequence, then
# publish two deliverables at the repo root:
#   - "<title>.pdf"                 the full compiled thesis
#   - "<title> - Cover-Approval.pdf" pages 1-2 (title + approval), which
#     IGSR/your supervisor may want as a separately signed document
#
# See INSTALL.md if pdflatex/bibtex/makeindex are not on your PATH yet.

set -Eeuo pipefail

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
MAIN_TEX="$ROOT_DIR/EMU_Thesis.tex"
JOB_NAME="EMU_Thesis"
BUILD_PDF="$ROOT_DIR/$JOB_NAME.pdf"

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1 (see INSTALL.md)"
}

run_logged() {
  local label="$1"
  local log_file="$2"
  shift 2

  printf '  %s...\n' "$label"
  if ! "$@" >"$log_file" 2>&1; then
    printf '\n%s failed; last 80 log lines:\n' "$label" >&2
    tail -n 80 "$log_file" >&2
    die "$label failed"
  fi
}

require_command pdflatex
require_command bibtex
require_command makeindex
require_command pdfinfo
require_command pdfseparate
require_command pdfunite

[[ -f "$MAIN_TEX" ]] || die "Main LaTeX file not found: $MAIN_TEX"

# Use the LaTeX \title{...} value as the root PDF filename. Characters that are
# invalid or troublesome in filenames are replaced with a single space.
THESIS_TITLE="$(
  sed -n 's/^[[:space:]]*\\title{\(.*\)}[[:space:]]*$/\1/p' "$MAIN_TEX" |
    sed -n '1p'
)"
[[ -n "$THESIS_TITLE" ]] || die "Could not read a single-line \\title{...} from $MAIN_TEX"

# Strips filesystem-unsafe characters, LaTeX escapes (\), and braces, since
# the title is read as raw LaTeX source (e.g. the placeholder title's
# "\LaTeX~" would otherwise leave a literal backslash in the filename,
# which breaks glob-based file matching such as the release workflow's).
OUTPUT_STEM="$(
  printf '%s' "$THESIS_TITLE" |
    sed 's#[/:*?"<>|\\{}]# #g; s/[[:space:]][[:space:]]*/ /g; s/^ //; s/ $//'
)"
[[ -n "$OUTPUT_STEM" ]] || die "The thesis title did not produce a valid filename"
THESIS_OUTPUT="$ROOT_DIR/$OUTPUT_STEM.pdf"
COVER_OUTPUT="$ROOT_DIR/$OUTPUT_STEM - Cover-Approval.pdf"

# Keep temporary outputs and command logs together, then remove them on exit.
TEMP_DIR="$(mktemp -d "$ROOT_DIR/.compile-thesis.XXXXXX")"
cleanup() {
  if [[ -n "${TEMP_DIR:-}" && -d "$TEMP_DIR" ]]; then
    rm -rf -- "$TEMP_DIR"
  fi
}
trap cleanup EXIT

printf 'Compiling %s...\n' "$MAIN_TEX"
(
  cd "$ROOT_DIR"
  run_logged "LaTeX pass 1" "$TEMP_DIR/pdflatex-1.log" \
    pdflatex -interaction=nonstopmode -halt-on-error -file-line-error "$JOB_NAME.tex"
  run_logged "BibTeX" "$TEMP_DIR/bibtex.log" bibtex "$JOB_NAME"
  # makeindex is a no-op (empty .ind) if you never use \index{...}; harmless either way.
  run_logged "makeindex" "$TEMP_DIR/makeindex.log" \
    makeindex "$JOB_NAME.idx" -s EMU_Index.ist
  run_logged "LaTeX pass 2" "$TEMP_DIR/pdflatex-2.log" \
    pdflatex -interaction=nonstopmode -halt-on-error -file-line-error "$JOB_NAME.tex"
  run_logged "LaTeX pass 3" "$TEMP_DIR/pdflatex-3.log" \
    pdflatex -interaction=nonstopmode -halt-on-error -file-line-error "$JOB_NAME.tex"
)

[[ -s "$BUILD_PDF" ]] || die "Compilation completed without producing $BUILD_PDF"

FULL_PAGE_COUNT="$(pdfinfo "$BUILD_PDF" | awk '/^Pages:/ { print $2; exit }')"
[[ "$FULL_PAGE_COUNT" =~ ^[0-9]+$ ]] || die "Could not determine the compiled PDF page count"
(( FULL_PAGE_COUNT >= 2 )) || die "The compiled thesis has fewer than two pages"

# Prepare and validate both deliverables before replacing the root copies.
cp -- "$BUILD_PDF" "$TEMP_DIR/$OUTPUT_STEM.pdf"
run_logged "Extracting pages 1-2" "$TEMP_DIR/pdfseparate.log" \
  pdfseparate -f 1 -l 2 "$BUILD_PDF" "$TEMP_DIR/page-%d.pdf"
[[ -s "$TEMP_DIR/page-1.pdf" && -s "$TEMP_DIR/page-2.pdf" ]] ||
  die "Could not extract the first two pages"
run_logged "Creating cover/approval PDF" "$TEMP_DIR/pdfunite.log" \
  pdfunite "$TEMP_DIR/page-1.pdf" "$TEMP_DIR/page-2.pdf" "$TEMP_DIR/cover-approval.pdf"

COVER_PAGE_COUNT="$(pdfinfo "$TEMP_DIR/cover-approval.pdf" | awk '/^Pages:/ { print $2; exit }')"
[[ "$COVER_PAGE_COUNT" == "2" ]] || die "Extracted cover/approval PDF does not have exactly two pages"

mv -f -- "$TEMP_DIR/$OUTPUT_STEM.pdf" "$THESIS_OUTPUT"
mv -f -- "$TEMP_DIR/cover-approval.pdf" "$COVER_OUTPUT"

# Remove the intermediate build PDF so exactly the two deliverables above
# remain at the repo root (matters for anything that globs "*.pdf", e.g.
# the release workflow). Guard against the unlikely case where the title
# sanitized down to the job name itself, which would make this the same
# file as $THESIS_OUTPUT.
if [[ "$BUILD_PDF" != "$THESIS_OUTPUT" && -f "$BUILD_PDF" ]]; then
  rm -f -- "$BUILD_PDF"
fi

printf '\nCreated:\n'
printf '  %s (%s pages)\n' "$THESIS_OUTPUT" "$FULL_PAGE_COUNT"
printf '  %s (%s pages)\n' "$COVER_OUTPUT" "$COVER_PAGE_COUNT"
