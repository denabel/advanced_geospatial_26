#' Render and copy Quarto files to output folders
#'
#' Renders .qmd files and copies the resulting .html to ./slides/ or ./exercises/.
#' By default, only files that changed since the last render are rebuilt (based on
#' MD5 checksums stored in .render_hashes.json). Call `render()` without arguments
#' for an interactive menu.
#'
#' @param file Path to a single .qmd file (optional). Skips the menu.
#' @param what Character; "all", "sessions", or "exercises". Skips the menu.
#' @param force Logical; if TRUE, render all files regardless of whether they changed.
#'
#' @examples
#' # Interactive menu — pick by number
#' render()
#'
#' # Direct: render a single file
#' render("_ignore/sessions/2_Raster_Data_in_R.qmd")
#'
#' # Direct: render all sessions (only changed files)
#' render(what = "sessions")
#'
#' # Direct: force-render everything
#' render(what = "all", force = TRUE)
render <- function(file = NULL, what = NULL, force = FALSE) {

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
    render_and_copy(file, targets, force = force)
    return(invisible(NULL))
  }

  # --- Direct batch mode (no menu) ---
  if (!is.null(what)) {
    what <- match.arg(what, c("all", "sessions", "exercises"))
    types <- if (what == "all") names(targets) else what
    render_batch(types, targets, force = force)
    return(invisible(NULL))
  }

  # --- Interactive menu ---
  if (!interactive()) {
    stop("Interactive mode requires an R console. Use render(file=...) or render(what=...) instead.")
  }

  # Build menu items — mark changed files
  labels <- character(length(all_qmds))
  for (i in seq_along(all_qmds)) {
    prefix <- if (grepl("sessions", all_qmds[i])) "[S]" else "[E]"
    changed <- needs_render(all_qmds[i], targets)
    marker <- if (changed) " *" else ""
    labels[i] <- sprintf("%s %s%s", prefix, basename(all_qmds[i]), marker)
  }

  cat("\n== Render Menu ==\n")
  cat("(* = changed since last render)\n\n")
  for (i in seq_along(all_qmds)) {
    cat(sprintf("  %2d. %s\n", i, labels[i]))
  }
  n <- length(all_qmds)
  cat(sprintf("\n  %2d. All sessions (changed only)\n", n + 1))
  cat(sprintf("  %2d. All exercises (changed only)\n", n + 2))
  cat(sprintf("  %2d. Everything (changed only)\n", n + 3))
  cat(sprintf("  %2d. Force-render everything\n", n + 4))
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

  # Process batch shortcuts
  if ((n + 4) %in% choices) {
    render_batch(names(targets), targets, force = TRUE)
    return(invisible(NULL))
  }
  if ((n + 3) %in% choices) {
    render_batch(names(targets), targets, force = FALSE)
    return(invisible(NULL))
  }
  if ((n + 1) %in% choices) {
    render_batch("sessions", targets, force = FALSE)
    choices <- setdiff(choices, n + 1)
  }
  if ((n + 2) %in% choices) {
    render_batch("exercises", targets, force = FALSE)
    choices <- setdiff(choices, n + 2)
  }

  # Process individual files (always render when explicitly selected)
  file_choices <- choices[choices >= 1 & choices <= n]
  for (i in file_choices) {
    render_and_copy(all_qmds[i], targets, force = TRUE)
  }

  invisible(NULL)
}


# --- Hash store: tracks which .qmd content was last rendered ---

hash_file <- "./_ignore/.render_hashes.json"

read_hashes <- function() {
  if (file.exists(hash_file)) {
    jsonlite::fromJSON(hash_file, simplifyVector = TRUE)
  } else {
    list()
  }
}

write_hashes <- function(hashes) {
  jsonlite::write_json(hashes, hash_file, pretty = TRUE, auto_unbox = TRUE)
}

file_hash <- function(path) {
  tools::md5sum(path)[[1]]
}


# --- Helper: check if a .qmd needs re-rendering ---
needs_render <- function(qmd_file, targets) {
  type <- if (grepl("sessions", qmd_file)) "sessions" else "exercises"
  dest <- targets[[type]]$dest
  html_name <- sub("\\.qmd$", ".html", basename(qmd_file))
  html_path <- file.path(dest, html_name)

  # No HTML yet → needs render
  if (!file.exists(html_path)) return(TRUE)

  # Compare current hash with stored hash from last successful render
  hashes <- read_hashes()
  key <- normalizePath(qmd_file, winslash = "/", mustWork = FALSE)
  current <- file_hash(qmd_file)
  stored <- hashes[[key]]

  is.null(stored) || stored != current
}

# --- Helper: record hash after successful render ---
record_hash <- function(qmd_file) {
  hashes <- read_hashes()
  key <- normalizePath(qmd_file, winslash = "/", mustWork = FALSE)
  hashes[[key]] <- file_hash(qmd_file)
  write_hashes(hashes)
}


# --- Helper: render one file and copy ---
render_and_copy <- function(file, targets, force = FALSE) {
  type <- if (grepl("sessions", file)) "sessions" else "exercises"
  dest <- targets[[type]]$dest

  if (!force && !needs_render(file, targets)) {
    message("Skipping (unchanged): ", basename(file))
    return(invisible(NULL))
  }

  message("Rendering: ", basename(file))
  quarto::quarto_render(file)

  html <- sub("\\.qmd$", ".html", file)
  if (file.exists(html)) {
    file.copy(html, dest, overwrite = TRUE)
    record_hash(file)
    message("  -> copied to ", dest)
  }
}

# --- Helper: render all files of given types ---
render_batch <- function(types, targets, force = FALSE) {
  for (type in types) {
    src  <- targets[[type]]$src
    dest <- targets[[type]]$dest

    qmds <- list.files(src, pattern = "\\.qmd$", full.names = TRUE)

    if (!force) {
      to_render <- Filter(function(f) needs_render(f, targets), qmds)
      skipped <- length(qmds) - length(to_render)
      if (skipped > 0) message("Skipping ", skipped, " unchanged ", type)
      if (length(to_render) == 0) {
        message("Nothing to render for ", type, " -- all up to date.")
        next
      }
      qmds <- to_render
    }

    message("Rendering ", length(qmds), " ", type, "...")

    for (f in qmds) {
      message("  ", basename(f))
      quarto::quarto_render(f)
      record_hash(f)
    }

    htmls <- list.files(src, pattern = "\\.html$", full.names = TRUE)
    file.copy(htmls, dest, overwrite = TRUE)
    message("Copied ", length(htmls), " files to ", dest)
  }
}
