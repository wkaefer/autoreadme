# 📚 AutoReadme – Automated README Management Suite

A comprehensive suite of Unix pipeline utilities that validates, generates, and manages README.md files while automatically creating Apache web server auxiliary files. AutoReadme ensures your project documentation stays synchronized with actual directory contents.

## ✨ Features

- **Automated Table Management** – Generate and merge file tables automatically
- **Validation** – Ensure README.md matches actual project directory structure
- **Apache Integration** – Create .htaccess, .contents, .header.html, and .readme.html files
- **Git Aware** – Respects .gitignore and custom ignore lists
- **Flexible** – Use individual tools or the unified `autoreadme` command
- **Emoji Support** – Automatic file type emoji assignment
- **HTML Generation** – Convert Markdown to HTML using markdown_py
- **Backup System** – Automatic versioned backups before any changes

---

## 🚀 Quick Start

### Installation

Clone the repository and optionally install the tools:

```bash
git clone <repository-url>
cd autoreadme
make install_all           # Install all tools to ~/bin or PATH
```

### Basic Usage

Update your README.md automatically:

```bash
./autoreadme                      # Run full pipeline
./autoreadme --no-htaccess        # Skip .htaccess generation
./autoreadme --create_header      # Create full HTML header
```

If `README.md` does not exist, `autoreadme` creates a starter template automatically.
If `README.md` exists but has no `## Files ##` section, the section scaffold is appended automatically.

Generate individual components:

```bash
./generate_table                   # List all files with emojis
./generate_table | ./merge_table README.md   # Merge with existing entries
./checkreadme                      # Validate README.md
```

---

## 🔧 How It Works

AutoReadme implements a Unix pipeline architecture where each tool performs a single, well-defined task:

```
Directory Scan
    ↓
generate_table (creates file table from filesystem)
    ↓
merge_table (preserves user descriptions from README.md)
    ↓
README.md Updated
    ↓
generate_html (converts to HTML)
    ↓
generate_files (creates Apache auxiliary files)
    ↓
checkreadme (validates consistency)
```

Each step can be run independently or chained together automatically by `autoreadme`.

---

## 📖 Tools in Detail

### `autoreadme` 🧼

**The Unified Command** – Orchestrates the entire pipeline in the correct sequence.

```bash
autoreadme [options]
```

**What it does:**
1. Backs up the current README.md
2. Generates a fresh file table
3. Merges it with existing README.md entries (preserving descriptions)
4. Updates README.md with the merged table
5. Generates HTML files (.header.html, .readme.html)
6. Creates Apache auxiliary files (.htaccess, .contents, .info)
7. Validates everything with checkreadme

**Options:**
- `--no-htaccess` – Skip .htaccess generation
- `--create_header` – Create full HTML document header
- `--ignore FILE...` – Files to deny access to
- `--ignore-patterns PATTERN...` – Patterns to deny; also used as the base list for `.htaccess`

---

### `generate_table` 🧮

**File Scanner** – Builds a Markdown table from the current directory.

```bash
generate_table [-v|--verbose]
```

**Output:** Markdown table with file names, type emojis, and empty descriptions
**Features:**
- Detects file types using MIME detection
- Assigns appropriate emojis based on file extension
- Respects .gitignore and ignore_list.txt
- Outputs to stdout (designed for piping)

**Example:**
```bash
./generate_table
```

---

### `merge_table` 🔗

**Description Merger** – Combines generated table with existing README.md entries.

This is the key to not losing your manual descriptions when updating the file list.

```bash
generate_table | merge_table README.md
```

**What it preserves:**
- User-written descriptions from README.md
- Files marked with '!' prefix (older/removed files)
- Emoji assignments
- Natural sort order

---

### `checkreadme` 🕵️

**Validator** – Ensures README.md table matches actual directory contents.

```bash
checkreadme
```

**Checks for:**
- ✅ Files that exist but aren't listed
- ✅ Files listed but don't exist
- ✅ Missing or empty descriptions
- ✅ Malformed table rows

**Exit Status:**
- 0 = Valid
- 1 = Issues found

---

### `generate_html` 🌐

**Markdown to HTML** – Converts README.md to HTML files for Apache.

```bash
generate_html [--create_header]
```

**Creates:**
- `.header.html` – Project title (first header)
- `.readme.html` – Full README minus the Files section

**Features:**
- Uses b4markdown preprocessor
- Supports markdown_py syntax highlighting
- Adjustable CSS via MARKDOWN_CSS environment variable
- Mermaid diagram support

---

### `generate_files` 🏗️

**Apache Generator** – Creates all Apache web server auxiliary files.

```bash
generate_files [options]
```

**Creates:**
- `.htaccess` – Apache directives with AddDescription entries
- `.contents` – Alternative AccessFileName
- `.info` – File information for tree command

**Options:**
- `--no-htaccess` – Skip .htaccess generation
- `--ignore FILE...` – Files to deny access to
- `--ignore-patterns PATTERN...` – Patterns to deny; `.htaccess` also appends matching entries from `~/.config/autoreadme/ignore_htaccess.txt`

---

### `b4markdown` 🔄

**Markdown Preprocessor** – Adds syntax highlighting before markdown_py conversion.

```bash
b4markdown [file]
```

**Features:**

| Prefix | Effect |
|--------|--------|
| `@-` | Gray highlight |
| `@+` | Cyan highlight |
| `@g` | Green highlight |
| `@b` | Blue highlight |
| `@p` | Purple highlight |
| `@y` | Yellow highlight |
| `@r` | Red highlight |
| `@o` | Orange highlight |
| `@@` | Page break |
| `#include filename` | Include another file |

---

### `bkup` 💾

**Backup Creator** – Creates versioned backups of files.

```bash
bkup [-r] file [file...]
```

**Features:**
- Creates incrementing numbered backups (.001, .002, etc.)
- Max 999 backups per file (configurable via MAX_BKUP)
- Stores in .backups/ folder
- `-r` flag moves (removes) original file

**Example:**
```bash
bkup README.md       # Copy to .backups/README.md.001
bkup *.txt          # Backup all text files
```

---

### `hr` 📏

**Decorative Horizontal Rules** – Generate styled terminal dividers.

```bash
hr [options] [text]
```

**Modes:**
- `ascii` – Alternating / and \ characters
- `emoji` – Random emojis from sequence
- `box` – Unicode box drawing characters
- `card` – Playing card symbols

**Available Themes:**
- `mythical`, `flowers`, `succulents`, `veggies`, `fruits`, `trees`
- `cosmic`, `birds`, `catsdogs`, `food`, `weather`, `hearts`, `tools`, `faces`

**Options:**
- `-c, --color` – Random foreground colors
- `-z, --back` – Random background colors
- `-m, --mode` – Character mode (ascii/emoji/box/card)
- `-l, --lines` – Number of lines to draw
- `-T, --theme` – Use a theme

**Examples:**
```bash
hr                                          # Simple rule
hr "Section Header"                         # Centered text
hr -m box -l 2 -c                          # Box mode, 2 lines, colored
hr --theme flowers                          # Flower emoji theme
```

---

### `qutopia` 🎭

**Terminal Art & Philosophy** – Display images and philosophical wisdom before dramatic exit.

```bash
qutopia
```

**Features:**
- Renders random images from ~/.local/share/qutopia/qutopia/
- Displays philosophical maxims in Unicode boxes
- Falls back to ANSI art if no images available
- Creates crash logs for entertainment
- Terminates dramatically with kill -9

**Philosophical Themes:**
- 🪞 Know Thyself – Self-awareness and introspection
- ⚖️ Nothing in Excess – Balance and moderation
- ☠️ Surety Brings Ruin – Warnings about overconfidence

---

## 📋 README.md File Table Format

AutoReadme requires a Markdown table under a `## Files ##` section:

```text
--->## Files ##    

    | File                 | 🧿 | Description                   |    
    |----------------------|----|-------------------------------|    
    | config.py            | 🐍 | Configuration module          |    
    | script.sh            | 🔩 | Main executable script        |
```

**Special Syntax:**
- Files beginning with `!` are marked as "older/removed" but still documented
- Empty descriptions are flagged as errors by checkreadme
- Descriptions can include escaped pipes: `\|`

---

## ⚙️ Configuration

### Environment Variables

| Variable | Purpose | Default |
|----------|---------|---------|
| `IGNORE_LIST` | Custom ignore list path | ~/.config/autoreadme/ignore_list.txt |
| `MARKDOWN` | Markdown filter command | b4markdown |
| `MARKDOWN_CSS` | CSS file path for HTML | /.markdown.css |
| `MAX_BKUP` | Max backups per file | 999 |
| `HR` | Environment shortcut for hr utility | (none) |

### Ignore Lists

Three-tier precedence (highest to lowest):
1. Environment variable: `IGNORE_LIST=path/to/file`
2. User config: `~/.config/autoreadme/ignore_list.txt`
3. Local fallback: `./ignore_list.txt`

Additional `.htaccess` deny patterns can be appended from:
- `~/.config/autoreadme/ignore_htaccess.txt`

This file is optional, ignores blank lines and `#` comments, and only affects generated `.htaccess` files.
Its patterns are only written when they match an existing top-level file or directory in the target path.
The repository includes a sample `ignore_htaccess.txt` that install copies into `~/.config/autoreadme/` if you do not already have one.

### Apache Directives

Embed Apache directives in README.md markdown comments:

```markdown
[.htaccess AddIcon "/.icons/image.gif" *.jpg ]: #
[.contents AddDescription "My custom files" folder/ ]: #
```

These are extracted and added to the generated files.

---

## 🎯 Common Workflows

### Update README & Generate Files

```bash
autoreadme
```

### Update Just the Table (No HTML/Apache files)

```bash
generate_table | merge_table README.md > README.new
mv README.new README.md
```

### Validate Without Modifying

```bash
checkreadme
```

### Create Backups for All Project Files

```bash
bkup *.py *.sh *.md
```

### Generate Files with Custom Ignores

```bash
autoreadme --ignore secret.txt private/ --ignore-patterns "*.bak"
```

For persistent extra `.htaccess` patterns, add one pattern per line to `~/.config/autoreadme/ignore_htaccess.txt`; unmatched entries are skipped until something exists.

---

## 📦 Dependencies

| Dependency | Purpose | Required |
|-----------|---------|----------|
| Python 3.10+ | Core tools (generate_table, merge_table, generate_files, checkreadme) | Yes |
| markdown_py 3.3.6+ | Markdown to HTML conversion | Yes (for HTML generation) |
| ksh93 | Shell for generate_html and b4markdown | Yes (for HTML generation) |
| chafa | Terminal image rendering (qutopia only) | No (optional for qutopia) |
| git | .gitignore awareness | Recommended |

---

## 🧪 Testing

Run the test suite:

```bash
make test              # Full pipeline test
make install           # Install single tool
make install_all       # Install all tools
```

---

## 🔨 Makefile Commands

```bash
make test              # Run full pipeline validation
make install <tool>    # Install a single tool
make install_all       # Install all tools to PATH
```

---

## 📄 File Conventions

### File Type Emojis

Common emoji assignments by file type:

| Pattern | Emoji | Type |
|---------|-------|------|
| `.py` | 🐍 | Python script |
| `.sh` | 🔩 | Shell script |
| `.md` | 📝 | Markdown |
| `.html` | 🌐 | Web document |
| `.css` | 🎨 | Stylesheet |
| `Makefile` | 🚂 | Build file |
| `.json` | 🔢 | JSON data |
| `.jpg/.png` | 🖼️ | Image |

---

## 📚 Man Pages

Comprehensive man pages are available for all utilities:

```bash
man autoreadme
man generate_table
man merge_table
man checkreadme
man generate_files
man generate_html
man b4markdown
man bkup
man hr
man qutopia
```

---

## 🎨 Output Files Reference

After running `autoreadme`, the following files are created/updated:

| File | Purpose |
|------|---------|
| `README.md` | Updated with merged file table |
| `.htaccess` | Apache server directives |
| `.contents` | Alternative Apache configuration |
| `.header.html` | Project title for directory listing |
| `.readme.html` | Full README as HTML |
| `.info` | File metadata for tree command |
| `.backups/*.001` | Versioned backups |

---

## 🤝 Contributing

The AutoReadme suite is designed for easy extension. Each tool can be:
- Used independently as a Unix pipeline component
- Modified for specific needs
- Combined with other Unix tools

Respect the philosophy: do one thing and do it well.

---

## 📝 Guides & Examples

### Example: Minimal Project Setup

```bash
# Initialize README with basic structure
autoreadme

# Add your file descriptions manually in README.md
# Then run again to validate
autoreadme
```

### Example: Apache Server Integration

```bash
# Set up Apache to use generated files
autoreadme

# In httpd.conf:
# AccessFileName .htaccess
# IndexStyleSheet "/.markdown.css"
# HeaderName .header.html
# ReadmeName .readme.html
```

### Example: Backup Before Major Changes

```bash
# Backup all Markdown files
bkup *.md

# Make changes...
# Restore from backup if needed:
# cp .backups/README.md.001 README.md
```

---

## 📄 License

Apache License 2.0 (standard practice for web server tools)

---

## Files ##

| File                 | 🧿 | Description                                        |
|----------------------|----|----------------------------------------------------|
| autoreadme           | 🔩 | Unified command orchestrating the full pipeline    |
| b4markdown           | 🔩 | Markdown preprocessor with syntax highlighting     |
| bkup                 | 🔩 | Create versioned backups to .backups/ directory    |
| checkreadme          | 🐍 | Validate README.md against actual directory        |
| generate_files       | 🐍 | Create .htaccess, .contents, .info files           |
| generate_html        | 🔩 | Convert README.md to .header.html and .readme.html |
| generate_table       | 🐍 | Create file table with emojis from directory scan  |
| help.txt             | 📃 | Help documentation for autoreadme command          |
| hr                   | 🔩 | Generate decorative horizontal terminal rules      |
| i2ico                | 🔩 | Convert images to ICO format files                 |
| ignore_list.py       | 🐍 | Module to read ignore list from configuration      |
| ignore_htaccess.txt  | 📃 | Sample .htaccess-only ignore pattern list          |
| ignore_list.txt      | 📃 | Default list of files and directories to ignore    |
| makefile             | 🚂 | Build and installation instructions                |
| man                  | 📁 | Manual pages for all utilities                     |
| markdown.css         | 🎨 | Example CSS for styling generated HTML             |
| merge_table          | 🐍 | Merge Generated and README.md Table                |
| mkimageindex         | 🔩 | Generate image thumbnail index for inclusion       |
| qutopia              | 🔩 | Terminal art and philosophical wisdom display      |
| recycle.jpg          | ♻️ | Folder icon for .backups directory                 |
| txt2image            | 🐍 | Create thumbnails of text and image files          |


[//]: # vim: syntax=markdown ts=2 sw=2 sts=2 et
