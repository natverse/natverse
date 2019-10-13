#' print status of natverse dependencies
#' This will check to see if all natverse packages (and optionally (if
#' \code{dependencies = TRUE}), their dependencies )
#' @param dependencies If \code{TRUE}, will also check all dependencies of natverse packages.
#' @return A character vector containing packages that are either missing or are not up-to-date.
#' @export
#' @examples
#' \dontrun{
#' natverse_deps()
#' }
natverse_deps <- function(dependencies = TRUE) {

  #Get details of the packages first..
  pkgstatus_df <- remotes::dev_package_deps(find.package("natverse"),dependencies = dependencies)

  #Now convert them to a readable format..
  deps <- data.frame(package=character(nrow(pkgstatus_df)),remote=character(nrow(pkgstatus_df)),
                     local=character(nrow(pkgstatus_df)),source=character(nrow(pkgstatus_df)),
                     behind=logical(nrow(pkgstatus_df)),stringsAsFactors=FALSE)
  deps$package  <- pkgstatus_df$package
  deps$remote <- pkgstatus_df$available
  deps$local <- pkgstatus_df$installed
  deps$source <- format.remotes(pkgstatus_df$remote)

  ## Status values from remotes package..
  ## -2 = not installed, but available on CRAN
  ## -1 = installed, but out of date
  ##  0 = installed, most recent version
  ##  1 = installed, version ahead of CRAN
  ##  2 = package not on CRAN

  deps$behind <- TRUE
  deps$behind[pkgstatus_df$diff == 0L] <- FALSE

  deps$missing <- FALSE
  deps$missing[pkgstatus_df$diff == -2L] <- TRUE

  behind_temp <- dplyr::filter(deps, deps$behind)
  missing_temp <- dplyr::filter(deps, deps$missing)

  #Perform some fancy formatting on them..
  deps$status <- paste0(crayon::green(cli::symbol$tick))
  deps[deps$behind & !is.na(deps$behind), "status"] <- paste0(crayon::red(cli::symbol$cross))
  # NB fancy question marks always seem to be red
  deps[deps$missing, "status"] <- cli::symbol$fancy_question_mark
  deps$behind <- NULL
  deps$missing <- NULL

  #Just trunacate the SHA1 hash
  deps$remote <- lapply(deps$remote, format_str, width = 12)
  deps$local <- lapply(deps$local, format_str, width = 12)

  pckglist = character(length = 0)

  if (nrow(behind_temp) == 0) {
    cli::cat_line(crayon::green(
      paste0(
        "\nAll natverse dependencies are up-to-date, see details below:"
      )
    ))
  } else{

    if(nrow(missing_temp)) {
      cli::cat_line(crayon::red(
        "\nThe following natverse dependencies are missing!\n"))
      cli::cat_line("  ", paste0(missing_temp$package, collapse = ', '))
      cli::cat_line("\nWe recommend installing them by running:")
      cli::cat_line('natverse_update(update=TRUE)')

      pckglist = c(pckglist,missing_temp$package)
    }
    cli::cat_line(crayon::red(
      paste0("\nThe following natverse dependencies are out-of-date, see details below:")))
    cli::cat_line("\nWe recommend updating them by running:")
    cli::cat_line('natverse_update(update=TRUE)')
    pckglist = c(pckglist,behind_temp$package)

  }
    cli::cat_line()
    cli::cat_line(format(knitr::kable(deps,format = "pandoc")))
    cli::cat_line()

    pckglist = unique(pckglist)

}

#' Check status of natverse packages and (optionally) update if necessary
#'
#' This will check to see if all natverse packages (and optionally (if
#' \code{recursive = TRUE}), their dependencies ) are up-to-date, and will
#' update them (optionally (if \code{update = TRUE})) if they are missing or are not up-to-date!
#' @param update If \code{TRUE}, will actually update the packages
#' @param recursive If \code{TRUE}, will also check all dependencies of natverse packages.
#' @param dependencies this parameter is passed onto function \code{\link[remotes]{update_packages}},
#' indicating which dependencies
#' to update here NA stands for "Depends", "Imports" and "LinkingTo" .
#' @param ... extra arguments to pass to \code{\link[remotes]{update_packages}}.
#' @export
#' @examples
#' \dontrun{
#' natverse_update()
#' }
natverse_update <- function(update=FALSE, recursive = TRUE, dependencies = NA, ...) {
  pkgs=c('natverse', natverse_deps(dependencies = recursive))
  if(interactive())
    message("Checking for remote updates for ", length(pkgs), " packages ...")
  if(update)
    remotes::update_packages(pkgs, ...)
}


# local functions taken directly from the package remotes

format.remotes <- function(x, ...) {
  vapply(x, format, character(1))
}

format_str <- function(x, width = Inf, trim = TRUE, justify = "none", ...) {
  x <- format(x, trim = trim, justify = justify, ...)

  if (width < Inf) {
    x_width <- nchar(x, "width")
    too_wide <- x_width > width
    if (any(too_wide)) {
      x[too_wide] <- paste0(substr(x[too_wide], 1, width - 3), "...")
    }
  }
  x
}
