# 📚 AutoReadme – Auto-generated File Manager Helpers

This project includes a suite of small utilities designed to automate the generation and maintenance of metadata and web-visible documentation from the project structure itself. These scripts collectively streamline the creation of human- and machine-readable descriptions for all files in a directory.

---

## 🚀 Overview

The tools work together like a pipeline:

1. **`generate_table`** – Builds a file table with emojis and descriptions.
2. **`merge_table`** – Merges manually edited table data with auto-generated entries.
3. **`generate_files`** – Produces helper files like `.htaccess`, `.readme.html`, etc.
4. **`generate_html`** – Extracts and converts Markdown headers and content to HTML.
5. **`checkreadme`** – Verifies all files are accounted for in the `README.md`.
6. **`bkup`** - Save copies of files with incrementing extensions in .backups folder.
7. **`hr`** - Miscellaneous Utility, Command-Line Horizontal Break Display.

---

## 🔧 Tools in Detail

### 1. `generate_table` 🧮

Scans the directory for files (excluding ignored or git-ignored ones), associates emojis based on extension/type, and creates a Markdown table with emojis and descriptions.

#### Example:
```bash
./generate_table 
```
```ngix
#| File                 | 🧿 | Description                             |
#|----------------------|----|-----------------------------------------|
#| autoreadme           | 📄 |                                         |
#| bkup                 | 📄 |                                         |
#| checkreadme          | 📘 |                                         |
#| generate_files       | 🐍 |                                         |
#| generate_html        | 📄 |                                         |
#| makefile             | 🚂 |                                         |
#| merge_table          | 🐍 |                                         |
```

---

### 2. `merge_table` 🔗

Combines your handcrafted entries in `README.md` with newly generated ones to avoid losing your personal edits while staying up-to-date.

#### Example:
```bash
./generate_table | ./merge_table README.md 
```
```ngix
#| File                  | 🧿 | Description                               |
#|-----------------------|----|-------------------------------------------|
#| autoreadme            | 📄 | ReCreate Files                            |
#| bkup                  | 📄 | Save incrementinig copies to .backups/    |
#| checkreadme           | 📘 | Validate Listed files verses Existing     |
#|!checkreadme.ksh       |    | An Older Version                          |
#| generate_files        | 🐍 | Create .htaccess, .contents, .info        |
#| generate_html         | 📄 | Create .readme.html, .header.html         |
#| generate_table        | 🐍 | Create Files Table from Existing          |
#| makefile              | 🚂 | Instructions                              |
#| merge_table           | 🐍 | Merge Generated and README.md Table       |
```
---

### 3. `generate_files` 🏗️

Parses the README file’s file table and generates:

- `.htaccess` (for Apache config)
- `.readme.html` (full README content)
- `.header.html` (project title only)
- `.contents` (Alternate AccessFileName in Apache)
- `.info` for tree command

#### Example:

```bash
./generate_files
```

---

### 4. `generate_html` 🌐

Runs in `ksh93`. Uses `b4markdown` to convert Markdown into minimalistic HTML output:

- **`.header.html`** – Title block from `README.md`
- **`.readme.html`** – Entire `README.md` minus file list

#### Example:
```bash
./generate_html
```

---

### 5. `checkreadme` 🕵️
Validates that all present files are documented in `README.md`'s file table. Helps prevent “lost files” from slipping through the cracks.

#### Example:
```bash
./checkreadme
```

ᚠᚢᚦᚨᚱᚲᚷᚹᚺᚾᛁᛃᛇᛈᛉᛋᛏᛒᛖᛗᛚᛜᛟᛞᛞᛟᛜᛚᛗᛖᛒᛏᛋᛉᛈ

## 🔁 Unified Command: `autoreadme` 🧼📖

Now accepts and forwards arguments to sub-scripts like `generate_files`.

#### Example:
```bash
autoreadme --no-htaccess
```

A script that ties all of this together into one easy-to-run command. It:

- Generates a fresh table (`generate_table`)
- Merges it into the existing README (`merge_table`)
- Replaces the old table in-place
- Rebuilds auxiliary files (`generate_html`, `generate_files`)
- Verifies everything (`checkreadme`)

---

This collection of script are used to convert a README.md
file into files used by apache and other tools.

- .htaccess - Default AccessFileName
- .contents - Another AccessFileName 
- .readme.html - for apache directory listing
- .header.html - for apache directory listings
- .info for the tree command

The scripts validate that the File Grid Displayed
in the README.md file matches the contents of the directory.

Conventions:

- Files begining with a '!' reference Older files which have been removed
- Files ignored by git are also ignore in the table, but can be listed.
- Markdown Comment may also be directives to include in the .htaccess or .contents file.
```markdown
[.htaccess AddIcon "/.icons/oscar.jpg" tmp   ]: #
```
- Markdown to HTML is provided by the b4markdown script which calls markdown_py
- Defined a Different filter by setting Environment Variable MARKDOWN

## Images ##

Use the mkimageindex script to create a thumbnail of each image
and include with 'C' like syntax.

```sh
mkimageindex abc.txt xyz.jpg > .imageindex
```

Optionally Use #include "<file>" to include directive which will be included the generated markdown.

```c
#include "examplefile.html"
```

## Files ##

| File                 | 🧿 | Description                                              |
|----------------------|----|----------------------------------------------------------|
| autoreadme           | 🔩 | ReCreate Files                                           |
| b4markdown           | 🔩 | markdown_py wrapper, used by generate_html               |
| bkup                 | 🔩 | Save incrementinig copies to .backups/                   |
| checkreadme          | 🐍 | Validate Listed files verses Existing                    |
| generate_files       | 🐍 | Create .htaccess, .contents, .info                       |
| generate_html        | 🐍 | Create .readme.html, .header.html                        |
| generate_table       | 🐍 | Create Files Table from Existing                         |
| help.txt             | 📃 | Text document, cat help.txt \| more                      |
| hr                   | 🔩 | Console Horizontal Break                                 |
| i2ico                | 🔩 | Convert an Image to an .ico {16,32,48,256}               |
| ignore_list.py       | 🐍 | Module to Read ~/.config/autoreadme/ignore_list.txt      |
| ignore_list.txt      | 📃 | Default List of Ignored Files and Directories            |
| makefile             | 🚂 | Instructions                                             |
| markdown.css         | 🎨 | Example markdown.css file                                |
| merge_table          | 🐍 | Merge Generated and README.md Table                      |
| mkimageindex         | 🔩 | Generate imageindex (.imageindex to include in markdown) |
| qutopia              | 🔩 | Helpful Guidance                                         |
| recycle.jpg          | ♻️ | Image to place in .backups as folder.jpg                 |
| txt2image            | 🐍 | Create thumbnail of text or image files, mkimageindex    |

[.htaccess AddIcon "/.icons/oscar.jpg" tmp   ]: #
[//]: # vim: syntax=markdown ts=2 sw=2 sts=2 et 
