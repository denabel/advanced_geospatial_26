#' Render and copy Quarto files to output folders
#'
#' Renders .qmd files and copies the resulting .html to ./slides/ or ./exercises/.
#' Call `render()` without arguments for an interactive menu.
#'
#' @param file Path to a single .qmd file (optional). Skips the menu.
#' @param what Character; "all", "sessions", or "exercises". Skips the menu.
#'
#' @examples
#' # Interactive menu — pick by number
#' render()
#'
#' # Direct: render a single file
#' render("_ignore/sessions/2_Raster_Data_in_R.qmd")
#'
#' # Direct: render all sessions
#' render(what = "sessions")
render <- function(file = NULL, what = NULL) {

  # Map source folders to output folders
  targets <- list(
    sessions  = list(src = "./_ignore/sessions/",  dest = "./slides/"),
    exercises = list(src = "./_ignore/exercises/", dest = "./exercises/")
  )

  # Collect all .qmd files
  all_qmds <- c(
    list.files(targets$sessions$src,  pattern = "\\.qmd$", full.names = TRUE),
    list.files(targets$exercises$src, pattern = "\\.qmd$", full.names = TRUE)
  )

  # --- Direct file mode (no menu) ---
  if (!is.null(file)) {
    stopifnot(file.exists(file), grepl("\\.qmd$", file))
    render_and_copy(file, targets)
    return(invisible(NULL))
  }

  # --- Direct batch mode (no menu) ---
  if (!is.null(what)) {
    what <- match.arg(what, c("all", "sessions", "exercises"))
    types <- if (what == "all") names(targets) else what
    render_batch(types, targets)
    return(invisible(NULL))
  }

  # --- Interactive menu ---
  if (!interactive()) {
    stop("Interactive mode requires an R console. Use render(file=...) or render(what=...) instead.")
  }

  # Build menu items
  labels <- c(
    sprintf("[S] %s", basename(all_qmds[grepl("sessions", all_qmds)])),
    sprintf("[E] %s", basename(all_qmds[grepl("exercises", all_qmds)]))
  )

  cat("\n== Render Menu ==\n\n")
  for (i in seq_along(all_qmds)) {
    cat(sprintf("  %2d. %s\n", i, labels[i]))
  }
  cat(sprintf("\n  %2d. All sessions\n", length(all_qmds) + 1))
  cat(sprintf("  %2d. All exercises\n", length(all_qmds) + 2))
  cat(sprintf("  %2d. Everything\n", length(all_qmds) + 3))
  cat(sprintf("   0. Cancel\n"))

  # Read selection (supports multiple, e.g. "2 5 7")
  cat("\nSelect (number, or multiple separated by spaces): ")
  input <- readline()
  choices <- as.integer(strsplit(trimws(input), "\\s+")[[1]])

  if (any(is.na(choices)) || any(choices < 0)) {
    message("Invalid input. Cancelled.")
    return(invisible(NULL))
  }
  if (0 %in% choices) {
    message("Cancelled.")
    return(invisible(NULL))
  }

  n <- length(all_qmds)

  # Process batch shortcuts
  if ((n + 3) %in% choices) {
    render_batch(names(targets), targets)
    return(invisible(NULL))
  }
  if ((n + 1) %in% choices) {
    render_batch("sessions", targets)
    choices <- setdiff(choices, n + 1)
  }
  if ((n + 2) %in% choices) {
    render_batch("exercises", targets)
    choices <- setdiff(choices, n + 2)
  }

  # Process individual files
  file_choices <- choices[choices >= 1 & choices <= n]
  for (i in file_choices) {
    render_and_copy(all_qmds[i], targets)
  }

  invisible(NULL)
}


# --- Helper: render one file and copy ---
render_and_copy <- function(file, targets) {
  type <- if (grepl("sessions", file)) "sessions" else "exercises"
  dest <- targets[[type]]$dest

  message("Rendering: ", basename(file))
  quarto::quarto_render(file)

  html <- sub("\\.qmd$", ".html", file)
  if (file.exists(html)) {
    file.copy(html, dest, overwrite = TRUE)
    message("  -> copied to ", dest)
  }
}

# --- Helper: render all files of given types ---
render_batch <- function(types, targets) {
  for (type in types) {
    src  <- targets[[type]]$src
    dest <- targets[[type]]$dest

    qmds <- list.files(src, pattern = "\\.qmd$", full.names = TRUE)
    message("Rendering ", length(qmds), " ", type, "...")

    for (f in qmds) {
      message("  ", basename(f))
      quarto::quarto_render(f)
    }

    htmls <- list.files(src, pattern = "\\.html$", full.names = TRUE)
    file.copy(htmls, dest, overwrite = TRUE)
    message("Copied ", length(htmls), " files to ", dest)
  }
}
