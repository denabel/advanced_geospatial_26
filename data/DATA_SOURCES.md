# Data folder overview

This folder contains all datasets used in the course, organized by source.

```
data/
├── boundaries/    Administrative borders (BKG Germany, Esri World)
├── worldpop/      Population & demographics (WorldPop, Univ. of Southampton)
├── nightlights/   Nighttime lights (NASA Black Marble, VNP46A4)
├── era5/          Climate reanalysis (Copernicus ERA5-Land)
├── issp/          Survey data (ISSP Environment module, via GESIS)
├── survey/        Synthetic survey geocoordinates (for exercises)
├── z22/           German Census 2022 grid data (via z22 R package)
├── misc/          District-level attributes (e-car shares etc.)
└── stacks/        Pre-built raster stacks/cubes (outputs from Sessions 5/6)
```

## Where does each dataset come from?

**`boundaries/`**
- `VG250_KRS.*` — German districts — [Federal Agency for Cartography and Geodesy (BKG)](https://gdz.bkg.bund.de/index.php/default/open-data.html)
- `VG250_LAN.*` — German federal states — same source
- `World_Countries.geojson` — World country boundaries — [Esri / ArcGIS Hub](https://hub.arcgis.com/datasets/esri::world-countries-generalized/)

**`worldpop/`**
- `deu_ppp_*` — Germany population grids 2000 & 2020 — [WorldPop](https://www.worldpop.org/)
- `usa_ppp_*` — USA population grid 2020 — WorldPop
- `US-CA_ppp_*` — California population grids 2017–2020 — WorldPop
- `US-TX_ppp_*` — Texas population grids 2000 & 2017–2020 — WorldPop
- `gender_ratio_*` — Gender ratio grids 2000 & 2020 — WorldPop

**`nightlights/`**
- `VNP46A4_*` — Annual nighttime lights composites 2017–2020 — [NASA Black Marble](https://blackmarble.gsfc.nasa.gov/), accessed via the [`blackmarbler`](https://worldbank.github.io/blackmarbler/) R package

**`era5/`**
- `era5_temperature*.grib` — Monthly mean 2m temperature — [Copernicus ERA5-Land](https://cds.climate.copernicus.eu/). Focal years: 1993, 2000, 2010, 2020. Baseline: 1961–1990.
- `annual_values_base.rds` — Pre-computed annual baseline (R object)

**`issp/`**
- `ZA8793_v1-0-0.dta` — ISSP Environment cumulation (1993–2020) — [GESIS](https://search.gesis.org/research_data/ZA7650)

**`survey/`**
- `synthetic_survey_geocoordinates.rds` — 2,000 simulated survey locations in Germany
- `synthetic_geocoordinates.csv` — Same data as CSV (without `sf` geometry). Created with the [`geosynth`](https://github.com/StefanJuenger/geosynth) R package.

**`z22/`**
- `*.tif` — Single-variable Census grids (population, rent, age, ...)
- `*.nc` — Multi-layer categorical Census grids (age groups, heating, ...). Downloaded with the [`z22`](https://cran.r-project.org/package=z22) R package (1 km resolution).

**`misc/`**
- `attributes_districts.csv` — District-level attributes (e-car share etc.) for Session 4

**`stacks/`**
- `CA_pop_stack.tif` — California population stack (`terra`, 2017–2020)
- `CA_pop_cube.*` — California population cube (`stars`, multiple formats)
- `TX_pop_stack.tif` — Texas population stack (`terra`, 2017–2020)
- `TX_pop_cube.rds` — Texas population cube (`stars`)

## Citation

Please cite the original data sources if you reuse any of these datasets.
See the course [README](../README.md) for full references and links.
