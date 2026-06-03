course_content <-
  tibble::tribble(
    ~Day, ~Time, ~Title,
    "June 9",  "10:00–11:15", "Introduction",
    "June 9",  "11:15–11:30", "Coffee Break",
    "June 9",  "11:30–13:00", "Raster data in R",
    "June 9",  "13:00–14:00", "Lunch Break",
    "June 9",  "14:00–15:15", "Raster data processing",
    "June 9",  "15:15–15:30", "Coffee Break",
    "June 9",  "15:30–17:00", "Graphical display of raster data in maps",
    "June 10", "10:00–11:15", "Datacube processing I",
    "June 10", "11:15–11:30", "Coffee Break",
    "June 10", "11:30–13:00", "Datacube processing II & API access",
    "June 10", "13:00–14:00", "Lunch Break",
    "June 10", "14:00–15:15", "Data integration and linking (with survey data)",
    "June 10", "15:15–15:30", "Coffee Break",
    "June 10", "15:30–17:00", "Outlook and open session with own application"
  ) |>
  knitr::kable() |>
  kableExtra::kable_styling(font_size = 18) |>
  kableExtra::column_spec(1, color = "gray") |>
  kableExtra::column_spec(2, color = "gray") |>
  kableExtra::column_spec(3, bold = TRUE) |>
  kableExtra::row_spec(2, color = "gray") |>
  kableExtra::row_spec(4, color = "gray") |>
  kableExtra::row_spec(6, color = "gray") |>
  kableExtra::row_spec(9, color = "gray") |>
  kableExtra::row_spec(11, color = "gray") |>
  kableExtra::row_spec(13, color = "gray") |>
  kableExtra::row_spec(7, extra_css = "border-bottom: 2px solid")
