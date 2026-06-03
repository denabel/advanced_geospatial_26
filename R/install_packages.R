# ──────────────────────────────────────────────────────────────────────────────
# Install all R packages needed for the course
# "Advanced Geospatial Data Processing for Social Scientists"
#
# Run this script once before the course starts.
# It only installs packages that are not yet installed on your system.
# ──────────────────────────────────────────────────────────────────────────────

# -- CRAN packages ------------------------------------------------------------
# These packages are used in the visible slide code and/or the exercises.

cran_packages <- c(
  "blackmarbler",   # NASA Black Marble nighttime lights     (Session 6, Ex 6_2)
  "dplyr",          # Data wrangling                         (throughout)
  "ecmwfr",         # Copernicus Climate Data Store API      (Session 7)
  "ggplot2",        # Plotting                               (Sessions 4, 6, 7)
  "ggrepel",        # Non-overlapping text labels in ggplot2 (Session 4, Ex 4_2)
  "ggspatial",      # Map annotations (scale bar, north arrow) (Sessions 4, 6)
  "haven",          # Import SPSS/Stata files (ISSP data)    (Session 7)
  "keyring",        # Secure API key storage                 (Session 7)
  "randomForest",   # Random forest models                   (Session 6)
  "readr",          # CSV import                             (Session 4, Ex 2_1)
  "remotes",        # Install packages from GitHub           (Session 8)
  "rnaturalearth",  # World country polygons                 (Session 7)
  "scales",         # Scale transformations for ggplot2      (Sessions 3, 4, 6)
  "sf",             # Vector data (simple features)          (throughout)
  "sjlabelled",     # Remove SPSS/Stata labels               (Session 7)
  "stars",          # Raster data cubes                      (Sessions 2, 5, 6)
  "stringr",        # String manipulation                    (Session 7)
  "terra",          # Raster data processing                 (throughout)
  "tidyr",          # Reshaping data (pivot_longer etc.)     (Session 7)
  "tidyterra",      # ggplot2 support for terra objects      (Sessions 4, 6)
  "tigris",         # US Census boundary shapefiles          (Session 6, Ex 4_1)
  "units",          # Physical units for raster dimensions   (Session 5)
  "z22"             # German Census 2022 grid data           (data download)
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
