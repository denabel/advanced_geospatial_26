# Style Guide: Workshop Exercises

Quick reference for the `.qmd` exercise files in `_ignore/exercises/`.

---

## 1. YAML Header (every exercise)

```yaml
title: "Exercise 2_1: Vector Data Refresher"
subtitle: 'Advanced Geospatial Data Processing for Social Scientists'
author: Dennis Abel & Stefan Jünger
format:
  html:
    embed-resources: true   # self-contained HTML, no external deps
    code-copy: true         # adds a "copy" button to code blocks
execute:
  echo: true                # show code by default
knitr:
  opts_knit:
    root.dir: ../../        # working directory = repo root (two levels up)
editor: visual              # RStudio visual editor mode
callout-icon: false         # no icons next to callout boxes
callout-appearance: minimal # clean callout style
editor_options:
  chunk_output_type: console
```

Key points:

- **`root.dir: ../../`** — All file paths in R chunks (e.g. `"./data/z22/population.tif"`) are relative to the **repo root**, not to the `.qmd` file location. Same as in the session slides.
- **`format: html`** — Exercises render as plain HTML documents (not Revealjs slides).
- **`code-copy: true`** — Adds a copy button to each code block so participants can easily copy-paste.
- **`callout-icon: false` / `callout-appearance: minimal`** — Keeps callout boxes clean and consistent.
- **Exception:** Exercise 1_1 (Package Installation) omits `execute`, `knitr`, and `editor_options` because it only contains `eval: false` chunks.

---

## 2. Document Structure

Every exercise follows this pattern:

~~~qmd
Introductory paragraph explaining the context and learning goals.

### Exercises

::: callout-note
## 🏋️ Exercise 1
Task description.
:::

::: {.callout-caution collapse="true"}
## 💡 Tip
Hints that participants can expand if they're stuck.
:::

::: callout-note
## 🏋️ Exercise 2
Next task.
:::

(... more exercises and tips ...)

### Solutions

::: {.callout-tip collapse="true"}
## ✅ Solution 1
```{r}
# solution code
```
:::
~~~

- **Exercises** use `callout-note` (blue) — always visible
- **Tips** use `callout-caution` (yellow) with `collapse="true"` — hidden by default
- **Solutions** use `callout-tip` (green) with `collapse="true"` — hidden by default
- Emojis in headings: 🏋️ for exercises, 💡 for tips, ✅ for solutions

---

## 3. Callout Box Types

~~~qmd
::: callout-note
## 🏋️ Exercise N
Always visible. Contains the task description.
:::

::: {.callout-caution collapse="true"}
## 💡 Tip
Collapsed by default. Click to expand.
Contains hints without giving away the solution.
:::

::: {.callout-tip collapse="true"}
## ✅ Solution N
Collapsed by default. Click to expand.
Contains the full working code with comments.
:::
~~~

> **Note the syntax difference:** Collapsible callouts need curly braces
> (`::: {.callout-caution collapse="true"}`), non-collapsible ones don't
> (`::: callout-note`).

---

## 4. Solution Code Patterns

### Standard solution (code runs and shows output)

~~~qmd
::: {.callout-tip collapse="true"}
## ✅ Solution 1
```{r}
library(sf)
data <- sf::st_read("./data/boundaries/VG250_KRS.shp", quiet = TRUE)
plot(sf::st_geometry(data))
```
:::
~~~

### Solution with hidden execution (show code, run silently behind the scenes)

When the visible code would produce unwanted messages or needs a slightly
different version to actually run:

~~~qmd
::: {.callout-tip collapse="true"}
## ✅ Solution 2
```{r}
#| eval: false
# This is what participants see
visible_code()
```

```{r}
#| echo: false
# This actually runs (e.g. with quiet = TRUE or different paths)
actual_code()
```
:::
~~~

---

## 5. File Paths

All paths are relative to the repo root (because of `root.dir: ../../`):

- **Boundaries:** `./data/boundaries/VG250_KRS.shp`, `VG250_LAN.shp`, `World_Countries.geojson`
- **Survey data:** `./data/survey/synthetic_survey_geocoordinates.rds`, `synthetic_geocoordinates.csv`
- **Census rasters:** `./data/z22/population.tif`, `age_avg.tif`, `rent_avg.tif`, `age_short.nc`
- **WorldPop:** `./data/worldpop/usa_ppp_2020_1km_Aggregated.tif`
- **ERA5:** `./data/era5/era5_temperature2020.grib`

---

## 6. Common Chunk Options

- **`#| echo: true`** — Show code (default via YAML, rarely needed explicitly)
- **`#| echo: false`** — Hide code, show only output
- **`#| eval: false`** — Show code, do not execute (for "what participants type" blocks)
- **`#| include: false`** — Hide both code and output (for setup)
- **`#| message: false`** — Suppress messages (e.g. from `sf::st_read()`)
- **`#| warning: false`** — Suppress warnings
