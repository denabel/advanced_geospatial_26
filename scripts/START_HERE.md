# 📂 Your workspace

This folder is for **your own scripts** during the course.

## Why this folder?

All exercises reference data paths like `./data/z22/population.tif`. These paths work correctly when your R working directory is set to the **project root** (the folder containing `advanced_geospatial_26.Rproj`).

By placing your scripts here in `scripts/`, you are one level below that root — so use paths like:

```r
# From a script inside scripts/
pop <- terra::rast("./data/z22/population.tif")
```

**Wait — that won't work from a subfolder!** Correct. That's why you should always use the RStudio Project:

## How to get started

1. **Open `advanced_geospatial_26.Rproj`** in RStudio (double-click the file).  
   This sets your working directory to the project root automatically.
2. **Create your scripts** in this folder (e.g., `exercise_2_1.R`).
3. **Use paths exactly as shown in the slides and exercises**, e.g.:
   ```r
   terra::rast("./data/z22/population.tif")
   sf::read_sf("./data/boundaries/VG250_KRS.shp")
   ```
   These work because RStudio runs your code from the project root, not from the script's location.

> 💡 **Tip:** If paths don't work, check your working directory with `getwd()`. It should end with `advanced_geospatial_26`.

## A quick note on relative paths

In R, file paths can be **absolute** or **relative**:

```r
# Absolute — full path from the root of your file system
terra::rast("C:/Users/anna/Downloads/advanced_geospatial_26/data/z22/population.tif")

# Relative — starts from your current working directory
terra::rast("./data/z22/population.tif")
```

**Relative paths are almost always better** because they work on any computer, not just yours. When you share your script with a colleague or move the project folder, everything still works.

Here's what the notation means:

- `./`  = the current working directory (i.e., the project root)
- `../` = one level UP from the current directory
- no prefix = same as `./`, just shorter

So `./data/z22/population.tif` and `data/z22/population.tif` do the same thing — the `./` just makes it explicit that you mean "starting from here".

**The key rule:** Your working directory determines where `./` points to. That's why opening the `.Rproj` file matters — it sets `./` to the project root, so `./data/...` finds the course data regardless of where your script file lives.
