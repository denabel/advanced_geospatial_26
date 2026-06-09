# =============================================================================
# Generate synthetic survey data with spatially correlated attributes
# Requires: z22, terra, sf, dplyr, readr (+ internet for z22 API)
# Run once, then commit the resulting RDS + CSV to the repo.
# =============================================================================

library(terra)
library(sf)
library(dplyr)
library(readr)

# --- Load base coordinates ---
# These are pre-generated point locations across Germany (EPSG:3035)
synthetic_coordinates <- readRDS("./data/survey/synthetic_survey_geocoordinates.rds")


# =============================================================================
# Helper: load a z22 Census raster layer
# =============================================================================
load_z22 <- function(variable) {
  z22::z22_data(variable, res = "1km", as = "raster")[[1]]
}


# =============================================================================
# 1. Age (continuous, ~18-85)
#    Source: Census average age per 1km cell
#    Method: extract local mean, add individual noise
# =============================================================================
age_avg_raster <- load_z22("age_avg")

# Extract local average age (1km buffer for spatial smoothing)
local_age <- terra::extract(
  age_avg_raster,
  synthetic_coordinates |> sf::st_buffer(1000),
  fun = mean, na.rm = TRUE, ID = FALSE
) |> unlist()

# Add individual variation and clamp to realistic range
set.seed(42)
synthetic_coordinates$age <-
  round(pmin(pmax(local_age + rnorm(length(local_age), 0, 5), 18), 85))


# =============================================================================
# 2. Female (binary 0/1)
#    Source: Census 65+ share as proxy (older areas → more female)
#    Method: convert share to probability, sample via rbinom
# =============================================================================
age_65_raster <- load_z22("age_from_65")

# Extract local 65+ share at each point
local_65_share <- terra::extract(
  age_65_raster,
  synthetic_coordinates,
  ID = FALSE
) |> unlist()

# P(female) ≈ 0.50 in young areas, up to ~0.55 in older areas
prob_female <- pmin(0.5 + (local_65_share / 100) * 0.15, 0.65)
prob_female[is.na(prob_female)] <- 0.5

set.seed(123)
synthetic_coordinates$female <- rbinom(length(prob_female), 1, prob_female)


# =============================================================================
# 3. Citizenship (binary 0/1: German citizen)
#    Source: Census citizens / population ratio
#    Method: convert ratio to probability, sample via rbinom
# =============================================================================
citizenship_raster <- load_z22("citizens")
population_raster <- load_z22("population")

# Probability of being a citizen per cell
probs_citizens <- terra::values(citizenship_raster) / terra::values(population_raster)

# Sample binary attribute; +0.1 shifts the distribution toward 1 (most are citizens)
citizenship_raster$sample <-
  rbinom(length(probs_citizens), size = 1, prob = pmin(probs_citizens + .1, 1))

synthetic_coordinates$citizenship <-
  terra::extract(citizenship_raster$sample, synthetic_coordinates, ID = FALSE) |>
  unlist()


# =============================================================================
# 4. Rent (continuous, €/m²)
#    Source: Census average rent per 1km cell
#    Method: extract local mean with 1km buffer (smoothed, no extra noise)
# =============================================================================
rent_avg_raster <- load_z22("rent_avg")

synthetic_coordinates$rent_avg <-
  terra::extract(
    rent_avg_raster,
    synthetic_coordinates |> sf::st_buffer(1000),
    ID = FALSE, fun = mean, na.rm = TRUE
  ) |>
  unlist()


# =============================================================================
# 5. Income (ordered categorical, 10 groups)
#    Source: composite of rent, dwelling space, owner-occupier rate
#    Method: weighted index → classify into quantile-based income brackets
# =============================================================================
income_groups <- c(
  "< 1000 €", "1000-1500 €", "1500-2000 €", "2000-2500 €", "2500-3000 €",
  "3000-3500 €", "3500-4000 €", "4000-4500 €", "4500-5000 €", "> 5000 €"
)

# Load predictors: areas with high rent, large dwellings, and high
# owner-occupier rates tend to have higher household income
owner_occ_raster <- load_z22("owner_occupier")
space_raster <- load_z22("inhabitant_space")

# Normalize each raster to 0-1 range for comparable weighting
normalize <- function(r) {
  vals <- terra::values(r)
  min_v <- min(vals, na.rm = TRUE)
  max_v <- max(vals, na.rm = TRUE)
  (r - min_v) / (max_v - min_v)
}

rent_norm <- normalize(rent_avg_raster)
space_norm <- normalize(space_raster)
owner_norm <- normalize(owner_occ_raster)

# Weighted composite index: rent matters most, then space, then ownership
income_index <- 0.5 * rent_norm + 0.3 * space_norm + 0.2 * owner_norm

# Extract index at each point (buffer for smoothing)
local_income_index <- terra::extract(
  income_index,
  synthetic_coordinates |> sf::st_buffer(1000),
  fun = mean, na.rm = TRUE, ID = FALSE
) |> unlist()

# Classify into income brackets based on quantiles of the index
breaks <- quantile(local_income_index, probs = seq(0, 1, length.out = length(income_groups) + 1), na.rm = TRUE)
income_class <- cut(local_income_index, breaks = breaks, labels = income_groups, include.lowest = TRUE)

# Add noise: randomly shift some people ±1 bracket for realism
set.seed(456)
income_numeric <- as.numeric(income_class)
noise <- sample(c(-1, 0, 0, 0, 1), length(income_numeric), replace = TRUE)
income_numeric <- pmin(pmax(income_numeric + noise, 1), length(income_groups))

synthetic_coordinates$income <- ordered(
  income_groups[income_numeric],
  levels = income_groups
)


# =============================================================================
# Select and order columns
# =============================================================================
synthetic_coordinates <- synthetic_coordinates |>
  dplyr::select(age, female, citizenship, income, rent_avg) 


# =============================================================================
# Export: RDS (with geometry) + CSV (with x/y columns, no geometry)
# =============================================================================
synthetic_coordinates_csv <-
  synthetic_coordinates |>
  dplyr::mutate(
    x = sf::st_coordinates(synthetic_coordinates)[, 1],
    y = sf::st_coordinates(synthetic_coordinates)[, 2]
  ) |>
  sf::st_drop_geometry() |> 
  dplyr::mutate(crs = 3035)

readr::write_csv(synthetic_coordinates_csv, "./data/survey/synthetic_geocoordinates.csv")
saveRDS(synthetic_coordinates, "./data/survey/synthetic_survey_geocoordinates.rds")

message("Done! Synthetic data saved with columns: ",
        paste(names(synthetic_coordinates), collapse = ", "))
