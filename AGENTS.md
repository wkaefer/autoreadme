# Working on AutoReadme

## Execution and data contracts

- Tools normally process the current working directory. `autoreadme` resolves its
  own location with `realpath` and prepends sibling tools to `PATH`.
- `autoreadme` runs backup → scan → merge → replace README table → HTML → Apache
  auxiliary files → validation. Under `/home/*` it also runs `mkimageindex`.
- `merge_table` emits only a table, not a complete README. Its CLI currently
  ignores filename arguments and reads `./README.md`; never redirect its output
  over README.md. Preserve surrounding prose when replacing the Files table.
- Table parsers depend on `## Files` and `| File` markers. Use `## Files ##` and
  the literal 🧿 column header; preserve descriptions, emoji, `!`-prefixed entries,
  and escaped pipes (`\|`). Pad columns for terminal display, counting emoji width.
- `ignore_list.py` selects `IGNORE_LIST` or the user config path, then falls back
  to `ignore_list.txt` beside the script, not in the working directory. A missing
  explicitly selected file skips user config and goes straight to that fallback.
- Never read, edit, index, or commit generated `.readme.html`, `.header.html`,
  `.htaccess`, `.contents`, or `.info` artifacts.

## Development and verification

- Use checkout tools explicitly: `./generate_table`,
  `./generate_table | ./merge_table`, and `./checkreadme` (read-only validation).
  New source files need descriptions in README.md's Files table.
- There is no dedicated automated test suite or configured lint/typecheck step.
  `make test` is a smoke pipeline, writes auxiliary files, and does not update
  README.md. It resolves tools through `PATH`; use
  `PATH="$PWD:$PATH" make test` when intentionally running it in the checkout.
- Prefer a disposable fixture directory for pipeline checks. With the checkout
  on `PATH`, run stages separately and check each status: the makefile uses
  `.ONESHELL` without fail-fast handling, so `make test` can mask earlier failures.
- Run `make test_ignore` only with an isolated `HOME`: it overwrites and then
  deletes `~/.config/autoreadme/ignore_list.txt`.
- `autoreadme` is Bash; `generate_html`, `b4markdown`, and `markdownfilter` use
  ksh93. HTML conversion uses `markdown_py`; do not syntax-check these as Bash.
- `generate_html` currently reads the misspelled `MARDKDOWN` environment variable
  to select its filter, despite documentation advertising `MARKDOWN`.

## Installation and source references

- `make install` copies the suite to `${PREFIX}/share/autoreadme` (default
  `PREFIX=$HOME/.local`) and links only selected commands into `${PREFIX}/bin`.
  `markdownfilter` requires separate CGI installation.
- `make install_all` and per-tool installation are not implemented. The makefile's
  catch-all `.DEFAULT` rule silently accepts unknown targets. Trust scripts and
  the lowercase `makefile` over conflicting README or Copilot command examples.
- Preserve makefile banners; new or edited targets use a three-line comment block
  (blank `#`, `# target - Description`, dashed `#` line), except `help`.
