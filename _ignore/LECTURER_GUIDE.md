# `_ignore/` — Source files and build infrastructure

This folder holds the **editable source files** for the workshop. Participants never see this folder — they work with the rendered HTML files in `./slides/` and `./exercises/` at the repo root.

## Folder structure

```
_ignore/
├── sessions/           .qmd source files for Revealjs slides
│   ├── tweaks.css      Custom CSS (spacing, .smaller-text, .smaller-output)
│   ├── tweaks_code.css Code/output font size overrides
│   └── course_content.R  Generates the course schedule table
├── exercises/          .qmd source files for HTML exercises
├── img/                Images used in slides and exercises
├── .render_hashes.json MD5 checksums for incremental rendering (auto-generated)
├── synthetic_data.R    Script that generates the synthetic survey data
├── STYLE_GUIDE_SLIDES.md    Formatting conventions for session slides
├── STYLE_GUIDE_EXERCISES.md Formatting conventions for exercises
└── README.md           This file
```

## Editing workflow

1. Edit `.qmd` files in `sessions/` or `exercises/`
2. Render → HTML is generated next to the `.qmd`
3. HTML is copied to `./slides/` or `./exercises/` at the repo root
4. Commit both the `.qmd` source and the `.html` output

## Rendering

All rendering functions live in `R/render.R`. Load them with:

```r
source("R/render.R")
```

### `render()` — Interactive menu

Call without arguments to get a numbered menu of all `.qmd` files:

```r
render()
```

- Files marked with `*` have changed since the last render
- Select one or more files by number (e.g. `2 5 7`)
- Batch options at the bottom: all sessions, all exercises, everything, force-render
- Only changed files are re-rendered by default (based on MD5 hashes stored in `.render_hashes.json`)

### `render(file = ...)` — Single file

Render a specific file by path:

```r
render("_ignore/sessions/2_Raster_Data_in_R.qmd")
```

### `render(what = ...)` — Batch by type

Render all files of a given type (only changed ones):

```r
render(what = "sessions")    # all session slides
render(what = "exercises")   # all exercises
render(what = "all")         # everything
```

Add `force = TRUE` to ignore the hash cache and re-render regardless:

```r
render(what = "all", force = TRUE)
```

### `render_current()` — RStudio shortcut

Renders whatever `.qmd` file is currently open in the RStudio editor:

```r
render_current()
```

- Automatically detects the active editor tab
- Only works for files in `sessions/` or `exercises/`
- Renders and copies the HTML to the correct output folder
- Use `render_current(force = FALSE)` to skip unchanged files

### How incremental rendering works

- On each successful render, the MD5 hash of the `.qmd` is stored in `_ignore/.render_hashes.json`
- On the next `render()` call, the current hash is compared to the stored one
- If they match and the `.html` exists, the file is skipped
- `force = TRUE` bypasses this check
- Explicitly selecting a file in the interactive menu always renders it (ignores the hash)

### Rendering from the command line

If you prefer the terminal over R:

```bash
quarto render _ignore/sessions/3_Raster_Data_Processing.qmd
```

This renders in place (HTML appears next to the `.qmd`). You then need to manually copy it:

```bash
cp _ignore/sessions/3_Raster_Data_Processing.html slides/
```

The `render()` function handles this copy step automatically.

## Style guides

Detailed formatting conventions are documented in:

- **[STYLE_GUIDE_SLIDES.md](STYLE_GUIDE_SLIDES.md)** — YAML header, fragments, columns, CSS classes, source attribution, chunk options for Revealjs session slides
- **[STYLE_GUIDE_EXERCISES.md](STYLE_GUIDE_EXERCISES.md)** — YAML header, document structure, callout boxes, solution patterns, file paths, chunk options for HTML exercises
