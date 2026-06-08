# Style Guide: Workshop Slides

Quick reference for the `.qmd` session files in `_ignore/sessions/`.

---

## 1. YAML Header (every session)

```yaml
title: "Session Title"
subtitle: "Advanced Geospatial Data Processing for Social Scientists"
author: "Dennis Abel & Stefan Jünger"
date: June 9, 2026
execute:
  echo: true                # show code by default
knitr:
  opts_knit:
    root.dir: ../../        # working directory = repo root (two levels up from _ignore/sessions/)
format:
  revealjs:
    embed-resources: true   # self-contained HTML (no external deps)
    theme: [simple, tweaks.css, tweaks_code.css]
    smaller: true           # smaller base font size globally
    scrollable: true        # slides scroll if content overflows
    slide-number: "c/t"     # current / total
    logo: ../img/GESIS-Logo_2024.svg.png
editor_options:
  chunk_output_type: console  # RStudio: output in console, not inline
```

Key points:

- **`root.dir: ../../`** — All file paths in R chunks (e.g. `"./data/z22/population.tif"`) are relative to the **repo root**, not to the `.qmd` file location. This is set via `knitr: opts_knit:` because the `.qmd` files live two levels deep (`_ignore/sessions/`).
- **`execute: echo: true`** — Code is shown by default; override per chunk with `#| echo: false`.
- **`embed-resources: true`** — The rendered HTML is fully self-contained (images, CSS, JS all embedded). This makes the file large but portable — no broken links when sharing.
- **`editor_options: chunk_output_type: console`** — When editing in RStudio, chunk output goes to the console instead of appearing inline below the chunk.

Two custom CSS files extend the theme:

- **`tweaks.css`** — Spacing (h2, p), custom classes (`.smaller-text`, `.smaller-output`)
- **`tweaks_code.css`** — Code and output font size globally at 0.9em

---

## 2. Fragments — Reveal content step by step

### Output after click (code visible immediately)

~~~qmd
```{r}
#| output-location: fragment
head(data, 5)
```
~~~

Code is visible on load. Click → output appears below.

### Output in right column, after click

~~~qmd
```{r}
#| output-location: column-fragment
#| fig.asp: .8
plot(data)
```
~~~

Code on the left. Click → plot appears on the right.

### Entire block after click (including text)

~~~qmd
::: {.fragment}
Some explanatory text...

```{r}
#| output-location: fragment
code()
```
:::
~~~

Click 1 → text + code appear. Click 2 → output appears.

### Sequential blocks on one slide

~~~qmd
```{r}
#| output-location: fragment
first_step()
```

::: {.fragment}
Explanatory text for the second step:

```{r}
#| output-location: fragment
second_step()
```
:::
~~~

- Click 1: output of block 1
- Click 2: text + code of block 2
- Click 3: output of block 2

---

## 3. Column Layouts

### Two equal columns

~~~qmd
:::: columns
::: {.column width="50%"}
Left content (text, image, code)
:::

::: {.column width="50%"}
Right content
:::
::::
~~~

### Unequal columns (e.g. 40/60)

~~~qmd
:::: columns
::: {.column width="40%"}
Narrow text
:::

::: {.column width="60%"}
Wide plot
:::
::::
~~~

### Column with fragment (plot after click)

~~~qmd
:::: columns
::: {.column width="50%"}
```{r}
code()
```
:::

::: {.column width="50%"}
::: {.fragment}
```{r}
#| echo: false
plot(result)
```
:::
:::
::::
~~~

> **Note:** For the common pattern "code left, plot right as fragment",
> `#| output-location: column-fragment` is the simpler alternative
> (see section 2) — no manual column layout needed.

---

## 4. Custom CSS Classes

### `.smaller-text` — Shrink an entire section

~~~qmd
::: {.smaller-text}
This text (and everything inside) is rendered at 0.8em.
Useful for long code examples or source blocks.
:::
~~~

Defined in `tweaks.css`:

```css
.reveal .smaller-text { font-size: 0.8em; }
```

### `.smaller-output` — Shrink only R output

~~~qmd
```{r}
#| class-output: smaller-output
head(world, 10)
```
~~~

Code stays at normal size, only the output shrinks (40%). Border and background are automatically removed.

Defined in `tweaks.css`:

```css
.reveal pre.smaller-output { font-size: 40%; }
```

---

## 5. Image Source Attribution

Consistent format across all slides:

~~~qmd
![](../img/image.png){.r-stretch fig-align="center"}

<small>Source: [Description](https://url)</small>
~~~

When no URL is available:

~~~qmd
<small>Source: Author / Institution, Year</small>
~~~

---

## 6. Callout Boxes

~~~qmd
::: {.callout-note}
## Title
Note content
:::

::: {.callout-tip}
## Title
Tip content
:::

::: {.callout-warning}
## Title
Warning content
:::
~~~

---

## 7. Common Chunk Options

- **`#| echo: false`** — Hide code, show only output
- **`#| eval: false`** — Show code, do not execute
- **`#| include: false`** — Hide both code and output (for setup chunks)
- **`#| output-location: fragment`** — Output appears after click (below)
- **`#| output-location: column-fragment`** — Output appears after click (right column)
- **`#| class-output: smaller-output`** — Shrink the output (see section 4)
- **`#| fig.asp: .8`** — Plot aspect ratio
- **`#| out-width: "80%"`** — Plot width on the slide
- **`#| code-line-numbers: "3"`** — Highlight line 3 in the code block
- **`#| layout-ncol: 2`** — Arrange multiple plots side by side
