# Advanced Geospatial Data Processing for Social Scientists

![GESIS Workshop](https://img.shields.io/badge/GESIS-Workshop-e74c3c)
![Language: R](https://img.shields.io/badge/Language-R_≥_4.3-e67e22?logo=r)
![Slides: Quarto Revealjs](https://img.shields.io/badge/Slides-Quarto_Revealjs-f1c40f)
![Date: June 2026](https://img.shields.io/badge/Date-June_9--10,_2026-2ecc71)
![Last updated](https://img.shields.io/github/last-commit/denabel/advanced_geospatial_26?label=Last%20updated&color=3498db)

<p align=center>   
<a href="https://github.com/denabel/advanced_geospatial_26/archive/refs/heads/main.zip"><b>📥 CLICK HERE TO DOWNLOAD ALL COURSE MATERIALS</b></a> 
</p>

<p align=center>   
<a href="https://denabel.github.io/advanced_geospatial_26/"><b>🌐 CLICK HERE FOR AN UNCLUTTERED VIEW</b></a> 
</p>

Materials for the GESIS workshop "Advanced Geospatial Data Processing for Social Scientists" 

Dennis Abel (dennis.abel@gesis.org) & Stefan Jünger (stefan.juenger@gesis.org)

## 📖 Workshop Description
A growing interest in economics and the social sciences in Earth observation (EO) 
data has led to a broad thematic spectrum of publications in recent years. 
They range from studying environmental attitudes and behavior, 
economic development, conflicts and causes of flight, and electoral behavior. 
However, working with EO data requires advanced knowledge of geospatial data 
processing. Social science researchers face many obstacles in applying and using 
these data, resulting from 1) a lack of technical expertise, 2) a lack of knowledge 
of data sources and how to access them, 3) unfamiliarity with complex data formats, 
such as high-resolution, longitudinal raster datacubes, and 4) a lack of expertise 
in integrating the data into existing social science datasets. After all, despite 
the increased interest in the data, for the majority of researchers in the social 
sciences, complex geospatial data derived from remote sensing represents a black box.
 
This course aims to address this gap. We will focus on data access from large 
databases via APIs, data wrangling of raster data and datacubes, and introduction 
of workflow for data integration with users' datasets, such as survey data. This 
course is advanced and suitable for students and scientists who feel familiar 
with R and have some basic knowledge of working with geodata. 

## 📦 What do you find here?
This page comprises the official workshop repository with the most recent changes 
to our materials. You can find all the course data, slides, and exercises here. 
The section below links the slides and exercises that will open them directly in 
the browser as HTML files. They are also stored in the folders `./slides/` and 
`./exercises`. You can also find all the data in the folder `./data`, organized by source into subfolders (`boundaries/`, `worldpop/`, `nightlights/`, `era5/`, `issp/`, `survey/`, `z22/`, etc.). They comprise the following official (Open Data) sources:

- Administrative borders of Germany (Prefix *VG250_*) are provided by the German [Federal Agency for Cartography and Geodesy](http://www.bkg.bund.de) (2018). Check out their [Open Data Portal](https://gdz.bkg.bund.de/index.php/default/open-data.html).

- German Census 2022 data are provided by the [Federal Statistical Office Germany, Wiesbaden 2024](https://www.zensus2022.de). We used our colleague [Jonas Lieth](https://www.gesis.org/institut/ueber-uns/mitarbeitendenverzeichnis/person/Jonas.Lieth)'s `R` package [`z22`](https://github.com/JsLth/z22) to gather the data for you.

- WorldPop population data are from [WorldPop](https://www.worldpop.org/), University of Southampton.

- Night light data (VNP46A4) are from [NASA's Black Marble](https://blackmarble.gsfc.nasa.gov/) product suite. We used Robert Marty's and Gabriel Stefanini Vicente's (2025) [`blackmarbler`](https://worldbank.github.io/blackmarbler/) R package to access the data via the NASA API.

- ERA5-Land Reanalysis temperature data are from the [Copernicus Climate Change Service (C3S)](https://climate.copernicus.eu/). The data were accessed via the Copernicus API using the [`ecmwfr`](https://cran.r-project.org/package=ecmwfr) R package.

- The International Social Survey Programme (ISSP) Environment module data are [available at GESIS](https://search.gesis.org/research_data/ZA7650). The ISSP is a cross-national collaboration of research organizations delivering annual survey data on social attitudes and behaviors.

- The synthetic survey geocoordinates dataset is a simulated dataset comprising 2,000 spatial coordinates and one synthetic attribute. It was created using Stefan's experimental [`geosynth` R package](https://github.com/StefanJuenger/geosynth) for training spatial analysis workflows without data privacy constraints.

- World country boundaries are from [Esri / ArcGIS Hub](https://hub.arcgis.com/datasets/esri::world-countries-generalized/).

- US state and county boundaries are accessed via the [`tigris`](https://cran.r-project.org/package=tigris) R package (Kyle Walker).

**Please make sure that if you reuse any of the provided data to cite the original data sources.**

## 🚀 Getting started

1️⃣ **Download** the course materials using the link at the top of this page and **unzip** the folder.

2️⃣ **Open `advanced_geospatial_26.Rproj`** in RStudio (double-click the file). This sets your working directory correctly so that all data paths in the exercises work out of the box.

3️⃣ **Install packages** by running:
```r
source("R/install_packages.R")
```
The script only installs packages that are not yet on your system.

4️⃣ **Write your scripts** in the `scripts/` folder — see [`scripts/START_HERE.md`](scripts/START_HERE.md) for details.

## 🗓️ Course schedule

### Day 1 — June 9

| # | Time | Session | Slides | Exercises |
|:-:|---|---|---|---|
| 1 | 10:00–11:15 | 👋 Introduction | [Slides](https://denabel.github.io/advanced_geospatial_26/slides/1_Introduction.html) | [1_1 Package Installation](https://denabel.github.io/advanced_geospatial_26/exercises/1_1_Package_Installation.html) |
| 2 | 11:30–13:00 | 🗺️ Raster Data in R | [Slides](https://denabel.github.io/advanced_geospatial_26/slides/2_Raster_Data_in_R.html) | [2_1 Vector Refresher](https://denabel.github.io/advanced_geospatial_26/exercises/2_1_Vector_Data_Refresher.html) · [2_2 Basic Raster Operations](https://denabel.github.io/advanced_geospatial_26/exercises/2_2_Basic_Raster_Operations.html) |
| 3 | 14:00–15:15 | ⚙️ Raster Data Processing | [Slides](https://denabel.github.io/advanced_geospatial_26/slides/3_Raster_Data_Processing.html) | [3_1 Subsetting](https://denabel.github.io/advanced_geospatial_26/exercises/3_1_Subsetting_Raster_Data.html) · [3_2 Extracting & Analyzing](https://denabel.github.io/advanced_geospatial_26/exercises/3_2_Extracting_Analyzing_Raster_Information.html) |
| 4 | 15:30–17:00 | 🎨 Graphical Display | [Slides](https://denabel.github.io/advanced_geospatial_26/slides/4_Graphical_display.html) | [4_1 Simple Map](https://denabel.github.io/advanced_geospatial_26/exercises/4_1_Simple_Map.html) · [4_2 Fancy Map](https://denabel.github.io/advanced_geospatial_26/exercises/4_2_Fancy_Map.html) |

### Day 2 — June 10

| # | Time | Session | Slides | Exercises |
|:-:|---|---|---|---|
| 5 | 10:00–11:15 | 🧊 Datacube Processing I | [Slides](https://denabel.github.io/advanced_geospatial_26/slides/5_datacubes_I.html) | [5_1 Raster Stack (terra)](https://denabel.github.io/advanced_geospatial_26/exercises/5_1_Raster_stack_terra.html) · [5_2 Raster Cube (stars)](https://denabel.github.io/advanced_geospatial_26/exercises/5_2_Raster_cube_stars.html) |
| 6 | 11:30–13:00 | 🧊 Datacube Processing II | [Slides](https://denabel.github.io/advanced_geospatial_26/slides/6_datacubes_II.html) | [6_1 Map with Many Facets](https://denabel.github.io/advanced_geospatial_26/exercises/6_1_Map_with_many_facets.html) · [6_2 Illuminate Your Region](https://denabel.github.io/advanced_geospatial_26/exercises/6_2_Illuminate_your_region.html) |
| 7 | 14:00–15:15 | 🔗 Data Integration & Linking | [Slides](https://denabel.github.io/advanced_geospatial_26/slides/7_Data_Integration_Linking.html) | [7_1 Data Integration](https://denabel.github.io/advanced_geospatial_26/exercises/7_1_Data_Integration.html) |
| 8 | 15:30–17:00 | 🔭 Outlook | [Slides](https://denabel.github.io/advanced_geospatial_26/slides/8_Outlook.html) | — |
