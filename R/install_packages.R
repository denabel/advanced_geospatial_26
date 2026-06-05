# ──────────────────────────────────────────────────────────────────────────────
# Install all R packages needed for the course
# "Advanced Geospatial Data Processing for Social Scientists"
#
# Run this script once before the course starts.
# It only installs packages that are not yet installed on your system.
#
# Scope: every package needed to reproduce the visible code on the slides
# and in the exercises. Setup-only packages (kableExtra, tmap, etc.) that
# participants never see are excluded.
# ──────────────────────────────────────────────────────────────────────────────

cran_packages <- c(
  "blackmarbler",   # NASA Black Marble nighttime lights      (Session 6)
  "dplyr",          # Data wrangling                          (throughout)
  "easypackages",   # Bulk package installation helper        (Exercise 1_1)
  "ecmwfr",         # Copernicus Climate Data Store API       (Session 7, demo only)
  "ggplot2",        # Plotting                                (Sessions 4, 7; Exercises)
  "ggrepel",        # Non-overlapping text labels in ggplot2  (Session 4, Exercise 4_2)
  "ggspatial",      # Map annotations (scale bar, north arrow)(Sessions 4, 6; Exercises)
  "haven",          # Import SPSS/Stata files (ISSP data)     (Session 7, via prep_issp.R)
  "keyring",        # Secure API key storage                  (Session 7)
  "randomForest",   # Random forest models                    (Session 6)
  "readr",          # CSV import                              (Session 4, Exercise 2_1)
  "rnaturalearth",  # World country polygons                  (Session 7)
  "scales",         # Scale transformations for ggplot2       (Sessions 3, 4, 6, 7)
  "sf",             # Vector data (simple features)           (throughout)
  "sjlabelled",     # Remove SPSS/Stata labels                (Session 7, via prep_issp.R)
  "stars",          # Raster data cubes                       (Sessions 2, 5, 6; Exercises)
  "terra",          # Raster data processing                  (throughout)
  "tidyterra",      # ggplot2 support for terra objects       (Sessions 4, 6; Exercises)
  "tidyverse",      # Meta-package: dplyr, ggplot2, tidyr,    (throughout)
                    #   stringr, readr, forcats, tibble, ...
  "tigris",         # US Census boundary shapefiles           (Session 6; Exercises)
  "units",          # Physical units for raster dimensions    (Session 5)
  "z22"             # German Census 2022 grid data            (data download; Exercises)
)

# Only install what's missing
new_packages <- cran_packages[!cran_packages %in% installed.packages()[, "Package"]]

if (length(new_packages) > 0) {
  message("Installing ", length(new_packages), " package(s): ",
          paste(new_packages, collapse = ", "))
  install.packages(new_packages)
} else {
  message("All CRAN packages are already installed!")
}

message("\nDone! You're ready for the course.")
