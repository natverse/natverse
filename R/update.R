#' Update natverse packages
#'
#' This will check to see if all natverse packages (and optionally (if recursive
#' = TRUE), their dependencies ) are up-to-date, and will provide the command to
#' perform the installation in one go! Adapted and modified from the following
#' sources : update function in 'tidyverse' package, github_update function in
#' 'dtupdate' package
#'
#' @param recursive If \code{TRUE}, will also check all dependencies of natverse
#'   packages.
#' @param source set the source of updates to 'CRAN' or 'GITHUB' natverse
#'   packages.
#' @return A \code{tibble} detailing dependencies and their status.
#' @export
#' @examples
#' natverse_update()
natverse_update <- function(recursive = FALSE, source = c('CRAN', 'GITHUB')) {
  source=match.arg(source)
  if (source == 'CRAN') {
    deps <- natverse_deps(recursive)
  } else if (source == 'GITHUB') {
    deps <- natverse_githubdeps(recursive)
  }

  behind_temp <- dplyr::filter(deps, deps$behind)
  deps$status <- paste0(crayon::green(cli::symbol$tick))
  deps[deps$behind & !is.na(deps$behind), "status"] <- paste0(crayon::red(cli::symbol$cross))
  # NB fancy question marks always seem to be red
  deps[is.na(deps$behind), "status"] <- cli::symbol$fancy_question_mark
  deps$behind <- NULL

  if (nrow(behind_temp) == 0) {
    cli::cat_line(paste("\nAll natverse dependencies from", source, "are up-to-date, see details below:"))
    cli::cat_line()
    cli::cat_line(format(knitr::kable(deps,format = "pandoc")))
    return(invisible(deps))
  }

  cli::cat_line(paste("\nThe following natverse dependencies from", source, "are out-of-date, see details below:"))
  cli::cat_line()
  cli::cat_line(format(knitr::kable(deps,format = "pandoc")))
  cli::cat_line()
  cli::cat_line("Start a clean R session then run:")

  if(source == 'CRAN'){
    pkg_str <- paste0(deparse(behind_temp$package), collapse = "\n")
    cli::cat_line("install.packages(", pkg_str, ")")
  } else if(source == 'GITHUB') {
    just_repo <- apply(behind_temp, 1, function(x) {stringr::str_match(x["source"],
                                                         "\\(([[:alnum:]-_\\.]*/[[:alnum:]-_\\.]*)[@[:alnum:]]*")[,2]})
    pkg_str <- paste0(deparse(just_repo), collapse = "\n")
    cli::cat_line("devtools::install_github(", pkg_str, ")")
  }
  invisible(deps)
}

##subfunctions..


#This function grabs the dependencies of the natverse package which have been installed via CRAN

natverse_deps <- function(recursive = FALSE) {

  #set the location of the repository or else you get complaints from knitr and examples
  r = getOption("repos")
  if(isTRUE(is.na(r["CRAN"])) || "@CRAN@" %in% r) {
    # CRAN option completely unset or has signalling value
    r["CRAN"] = "https://cloud.r-project.org/"
    op <- options(repos = r)
    on.exit(options(op))
  }

  pkg_deps <- natverse_dep_pkgs()

  #we also don't want to update the github packages here, so ignore them as well..
  pkgs_local_df <- local_package_info()
  github_pkgs=pkgs_local_df[grepl('Github', pkgs_local_df$source), 'package']
  pkg_deps <- setdiff(pkg_deps, github_pkgs) #just ignore the github packages..

  pkgs <- installed.packages()
  cran_version <- lapply(pkgs[pkg_deps, "Version"], base::package_version) #get the version number for the dependent packages in r format..
  local_version <- lapply(pkg_deps, utils::packageVersion) #get the version number for the dependent packages in r format..

  behind <- purrr::map2_lgl(cran_version, local_version, `>`) #check if the local version is lower and store it in behind flag..

  #construct a dataframe with the details to pass on..
  tibble::tibble(
    package = pkg_deps,
    cran = cran_version %>% purrr::map_chr(as.character),
    local = local_version %>% purrr::map_chr(as.character),
    behind = behind
  )

}

# internal function to return names of natverse dependencies
natverse_dep_pkgs <- function(recursive = FALSE, include.base=FALSE) {
  pkgs_local <- utils::installed.packages() #list all installed packages only, as you will only update packages after installing them?, will be changed once natverse
  #is on CRAN (may be someone updated dependencies alone)..

  deps <- tools::package_dependencies("natverse", pkgs_local, recursive = recursive) # check only the dependencies of natverse(which is currently local only)

  pkg_deps <- unique(sort(unlist(deps))) #just flatten the list

  # don't include base by default because they come with each version of R not from CRAN
  if(isFALSE(include.base)){
    pkgs <- utils::available.packages() #list all the packages available in CRAN repositories with row names as pkgnames..
    base_pkgs <- pkgs[pkgs[,'Priority']=='recommended' &!is.na(pkgs[,'Priority']),'Package']
    pkg_deps <- setdiff(pkg_deps, base_pkgs) #just ignore the base packages..
  }
  pkg_deps
}

local_package_info <- function(lib.loc=.libPaths()[1]) {
  ip=utils::installed.packages(lib.loc = lib.loc)

  pkgs_local <- sort(ip[,"Package"])

  desc_local <- lapply(pkgs_local, utils::packageDescription, lib.loc=lib.loc)
  version_local <- vapply(desc_local, function(x) x$Version, character(1))
  date_local <- vapply(desc_local, pkg_date, character(1))
  source_local <- vapply(desc_local, pkg_source, character(1))

  pkgs_local_df <- data.frame(package=pkgs_local, version=version_local, date=date_local, source=source_local,
                              stringsAsFactors=FALSE, check.names=FALSE)

  rownames(pkgs_local_df) <- NULL
  # harmless, but I don't think this is used anywhere
  class(pkgs_local_df) <- c("githubupdate", "data.frame")
  pkgs_local_df
}

natverse_githubdeps <- function(recursive = FALSE) {

  pkgs_local_df <- local_package_info()

  if (any(grepl("Github", pkgs_local_df$source))) {

    pkgs_local_df <- dplyr::filter(pkgs_local_df, grepl("Github", source))

    just_repo <- stringr::str_match(pkgs_local_df$source,
                                    "\\(([[:alnum:]-_\\.]*/[[:alnum:]-_\\.]*)[@[:alnum:]]*")[,2]
    pkgs_local_df$gh_version <- get_versions(just_repo)
    pkgs_local_df$`*` <- ifelse(mapply(utils::compareVersion, pkgs_local_df$version, pkgs_local_df$gh_version,
                                       USE.NAMES=FALSE)<0, '*', '')
    pkgs_local_df$`*` <- ifelse(is.na(pkgs_local_df$gh_version), '', pkgs_local_df$`*`)

  }

  github_version <- lapply(pkgs_local_df$gh_version, base::package_version, strict = F) #get the version number for the dependent packages in r format..
  local_version <- lapply(pkgs_local_df$version, base::package_version, strict = F) #get the version number for the dependent packages in r format..

  behind <- purrr::map2_lgl(github_version, local_version, `>`)

  tibble::tibble(
    package = pkgs_local_df$package,
    github = github_version %>% purrr::map_chr(as.character),
    local = local_version %>% purrr::map_chr(as.character),
    source = pkgs_local_df$source,
    behind = behind
  )

}

pkg_date <- function (desc)  {
  if (!is.null(desc$`Date/Publication`)) {
    date <- desc$`Date/Publication`
  } else if (!is.null(desc$Built)) {
    built <- strsplit(desc$Built, "; ")[[1]]
    date <- built[3]
  } else {
    date <- NA_character_
  }
  as.character(as.Date(strptime(date, "%Y-%m-%d")))
}

pkg_source <- function (desc)  {
  if (!is.null(desc$GithubSHA1)) {
    str <- paste0("Github (", desc$GithubUsername, "/", desc$GithubRepo,
                  "@", substr(desc$GithubSHA1, 1, 7), ")")
  } else if (!is.null(desc$RemoteType)) {
    str <- paste0(desc$RemoteType, " (", desc$RemoteUsername,
                  "/", desc$RemoteRepo, "@", substr(desc$RemoteSha,
                                                    1, 7), ")")
  } else if (!is.null(desc$Repository)) {
    repo <- desc$Repository
    if (!is.null(desc$Built)) {
      built <- strsplit(desc$Built, "; ")[[1]]
      ver <- sub("$R ", "", built[1])
      repo <- paste0(repo, " (", ver, ")")
    }
    repo
  } else if (!is.null(desc$biocViews)) {
    "Bioconductor"
  } else {
    "local"
  }
}


.get_version <- function(x) {
  url_con <- url(x)
  on.exit(close(url_con))
  version <- suppressWarnings(try(
    as.character(read.dcf(url_con, fields="Version")), silent = TRUE
    ))
  if (inherits(version, "try-error")) NA else version
}

get_versions <- function(github_user_repo) {

  base_url <- "https://raw.githubusercontent.com/%s/master/DESCRIPTION"
  gh_urls <- sprintf(base_url, github_user_repo)

  unlist(
    pbapply::pbsapply(gh_urls, .get_version, USE.NAMES = FALSE),
    use.names=FALSE
  )
}

# print status of natverse dependencies
natverse_deps2 <- function(recursive = TRUE) {
  pkgs=c('natverse', natverse_dep_pkgs(recursive = recursive))
  pi=sessioninfo::package_info(pkgs, dependencies = FALSE)
  pi
}

# update natverse dependencies
natverse_update2 <- function(update=FALSE, recursive = TRUE, dependencies = NA, ...) {
  pkgs=c('natverse', natverse_dep_pkgs(recursive = recursive))
  if(interactive())
    message("Checking for remote updates for ", length(pkgs), " packages ...")
  if(update)
    remotes::update_packages(pkgs, ...)
}
