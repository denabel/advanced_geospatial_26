# ──────────────────────────────────────────────────────────────────────────────
# Download German Census 2022 grid data via the z22 package
# "Advanced Geospatial Data Processing for Social Scientists"
#
# This script fetches all available 1 km grid features from the German
# Census 2022 and writes them to ./data/z22/. Single-layer variables are
# stored as GeoTIFF (.tif), multi-layer categorical variables as NetCDF (.nc).
#
# Requirements:
#   - The `z22` package (CRAN): install.packages("z22")
#   - Internet access (data is downloaded from the z22 data repository)
#
# Output: ./data/z22/<feature_name>.tif  (single-layer features)
#         ./data/z22/<feature_name>.nc   (multi-layer categorical features)
# ──────────────────────────────────────────────────────────────────────────────

library(z22)

# --- Identify available features ----------------------------------------------

# Get all features that are available as 1 km grid data
z22_features_to_grab <-
  z22::z22_features() |>
  dplyr::filter(z22 == TRUE) |>
  dplyr::slice(-c(26:27)) |>      # Drop features that cause issues
  dplyr::slice(-30) |>
  dplyr::pull(feature)

# --- Download all features at 1 km resolution --------------------------------

z22_features <-
  purrr::map(
    z22_features_to_grab,
    z22::z22_data,
    res = "1km",
    as = "raster",
    year = 2022
  )

# --- Write to disk: .tif for single layers, .nc for multi-layer --------------

z22_features |>
  purrr::imap(~{
    n_layers <- terra::nlyr(.x)
    feature_name <- z22_features_to_grab[.y]

    if (n_layers == 1) {
      # Single variable -> GeoTIFF
      terra::writeRaster(
        x = .x,
        filename = paste0("./data/z22/", feature_name, ".tif"),
        overwrite = TRUE
      )
    } else {
      # Categorical variable with multiple groups -> NetCDF
      terra::writeCDF(
        x = .x,
        filename = paste0("./data/z22/", feature_name, ".nc"),
        overwrite = TRUE
      )
    }
  })
