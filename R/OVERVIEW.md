# R scripts overview

Helper scripts for the course. None of these are called by participants
directly during exercises — they either prepare the course materials or
set up the environment.

## For participants

install_packages.R
  Install all R packages needed for slides and exercises in one go.
  Run once before the course starts. Only installs what's missing.

  Usage:  source("R/install_packages.R")

## For instructors

render.R
  Render Quarto (.qmd) slides and exercises to HTML and copy them
  into ./slides/ and ./exercises/. Offers an interactive menu or
  can be called directly with a file path or batch keyword.

  Usage:  source("R/render.R")
          render()                              # interactive menu
          render(what = "sessions")             # all slides
          render("_ignore/sessions/3_Raster_Data_Processing.qmd")  # single file

prep_issp.R
  Prepare the ISSP Environment module data for Session 7. Loads the
  Stata file from ./data/issp/, recodes countries, reverses the
  concern scale, and builds a Likert plot for the 2020 wave.
  Sourced automatically by the Session 7 slides — not run standalone.

  Input:   ./data/issp/ZA8793_v1-0-0.dta
  Output:  objects `issp` and `likert_plot_2020` in the R environment

download_z22.R
  Download German Census 2022 grid data via the z22 CRAN package and
  write them to ./data/z22/. Single-layer features become .tif,
  multi-layer categorical features become .nc.

  Requires: z22 package, internet access
  Output:   ./data/z22/*.tif and ./data/z22/*.nc

download_worldpop.R
  Function to download and process WorldPop population rasters for
  arbitrary countries, years, and demographic indicators. Aggregates
  to a configurable cell size and returns a stars object.

  Requires: terra, sf, stars, glue, furrr, tidyr, purrr
  Usage:    source("R/download_worldpop.R")
            download_worldpop(year = 2020, country = "KEN",
                              indicator = "all", cellsize = 10000)
