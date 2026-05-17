# Copilot Instructions for AutoReadme

## Project Overview

AutoReadme is a suite of utilities that manages and validates README.md files in a project directory. It maintains a Markdown table of files with metadata, generates helper files for Apache web servers, and converts Markdown to HTML.

The project is a **Unix pipeline architecture** where small, single-purpose tools can be chained together:
- **generate_table**: Scans directory and creates/updates a file table
- **merge_table**: Merges user edits with auto-generated entries (preserves human annotations)
- **checkreadme**: Validates README.md file table against actual directory contents
- **generate_files**: Creates Apache auxiliary files (.htaccess, .contents, .info, .readme.html, .header.html)
- **generate_html**: Converts Markdown to HTML using b4markdown wrapper
- **b4markdown**: Preprocessor/postprocessor for Markdown → HTML conversion. Supports line-level (`@gtext`) and inline (`@g{text}`) color highlights. Inline form uses ASCII placeholders to survive markdown_py code-block escaping.

## Language & Runtime Details

- **Main tools**: Python 3 (3.10+) and ksh93
- **Build system**: Makefile (Unix convention, silent operation with MAKEFLAGS=-s)
- **Dependencies**: markdown_py (3.3.6 from README), installed system-wide

## Key Commands

### Running the Full Pipeline
```bash
make test
# Equivalent manual flow:
# generate_table | merge_table README.md
# generate_files
# generate_html
# checkreadme
```

### Individual Tool Examples
```bash
./generate_table [-v]                    # Generate fresh file table
./generate_table | ./merge_table         # Merge with README.md
./checkreadme                            # Validate README matches directory
./generate_files [args]                  # Create Apache files
./generate_html                          # Create HTML from Markdown
./autoreadme [args]                      # Unified command (runs full pipeline)
./bkup <filename>                        # Backup file to .backups/ with incrementing extension
```

## Critical Patterns & Conventions

### File Table Format
The README.md requires a Markdown table under "## Files ##" section:
```markdown
| File       | 🧿 | Description                |
|------------|----|----|
| autoreadme | 🔩 | Main unified command       |
```

**Special syntax in file table:**
- Files beginning with `!` are marked as "older/removed" (still documented but gone)
- Git-ignored files are excluded from table but can be manually listed

### Ignore List Loading Order
1. Environment variable: `IGNORE_LIST` (custom path)
2. User config: `~/.config/autoreadme/ignore_list.txt`
3. Local fallback: `./ignore_list.txt`

### Markdown Comments as Directives
Markdown comments with special syntax become directives in `.htaccess` or `.contents`:
```markdown
[.htaccess AddIcon "/.icons/oscar.jpg" tmp   ]: #
```

### Emoji Conventions
Each file type has a standard emoji representing its purpose:
- 🔩 Shell/binary utilities
- 🐍 Python scripts
- 🎨 CSS/styling files
- 📃 Text documentation
- 🚂 Makefile

## Architecture Notes

### Data Flow in Main Pipeline
1. **generate_table**: Reads filesystem + git ignore status → Markdown table lines
2. **merge_table**: Reads README.md table + new lines → merged table (preserves descriptions)
3. **README update**: Pipeline writes merged table back to README.md
4. **generate_files**: Parses README.md table → .htaccess, .contents, .info files
5. **generate_html**: Parses README.md + uses b4markdown → .readme.html, .header.html
6. **checkreadme**: Reads README.md table + filesystem → validation report

### Key Dependencies
- `bkup` must be available (checked at runtime in autoreadme)
- Scripts use `set -e` (bash) or equivalent error handling
- All Python scripts expect Python 3 with markdown_py available
- ksh93 scripts (generate_html, b4markdown) require ksh93 shell

## Configuration

### Environment Variables
- `IGNORE_LIST`: Path to custom ignore list file
- `MARKDOWN`: Alternative markdown filter command (used by b4markdown)

### Makefile Targets
- `make test`: Run full pipeline (fastest smoke test)
- `make install <program>`: Install a single tool to ~/bin or PATH
- `make install_all`: Install all tools

## Testing & Validation

The `make test` target executes the full pipeline in sequence:
```bash
make test  # equivalent to: generate_table && merge_table && generate_files && generate_html && checkreadme
```

This validates:
- Table generation from directory scan
- Merge logic preserves descriptions
- File generation succeeds
- HTML conversion works
- Final README table matches filesystem

## Notes for Contributors

- Python scripts use `argparse` for CLI argument handling
- Bash scripts use `realpath` to locate tool directory (enables portable installation)
- Shell scripts are silent by default; use `-v` or `--verbose` flags for diagnostics
- All tools respect .gitignore via `git check-ignore` subprocess calls
- The pipeline is idempotent: running it twice produces the same results
