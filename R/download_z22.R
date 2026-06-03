library(z22)

# options(z22.data_repo = "C:/Users/mueller2/a_projects/z22data-main")

z22_features_to_grab <-
  z22::z22_features() |> 
  dplyr::filter(z22 == TRUE) |>   
  dplyr::slice(-c(26:27)) |>
  dplyr::slice(-30) |>
  dplyr::pull(feature)

z22_features <-
  purrr::map(
    z22_features_to_grab, z22::z22_data, res = "1km", as = "raster", 
    year = 2022
  )

z22_features |> 
  purrr::imap(~{
    
    length_x <- terra::nlyr(.x)
    
    if (length_x == 1) {
      
      # terra::writeCDF(
      #   x = .x, 
      #   filename = paste0("./data/z22_", features_to_grab[.y], ".nc"),
      #   overwrite = TRUE
      # )
      # 
      # x_spatraster <- terra::project(.x[[1]], "EPSG:25832")
      
      terra::writeRaster(
        x = .x,
        filename = paste0("./data/z22/", z22_features_to_grab[.y], ".tif"),
        overwrite = TRUE
      )
      
    } else {
      terra::writeCDF(
        x = .x, 
        filename = paste0("./data/z22/", z22_features_to_grab[.y], ".nc"),
        overwrite = TRUE
      )
    }
  })





