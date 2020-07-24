pseudoremote <- function(type, ...) {
  structure(list(...), class = c(paste0(type, "_remote"), "remote"))
}

`%||%` <- function (a, b) if (!is.null(a)) a else b

## -2 = not installed, but available on CRAN
## -1 = installed, but out of date
##  0 = installed, most recent version
##  1 = installed, version ahead of CRAN
##  2 = package not on CRAN

remotes_uninstalled <- -2L
remotes_behind <- -1L
remotes_current <- 0L
remotes_ahead <- 1L
remotes_unavailable <- 2L

#adapted from the remotes package to support only cran, github, local installations..

package2pseudoremote <- function(name, lib = .libPaths(), repos = getOption("repos"), type = getOption("pkgType")) {

  #get the package descriptions first..
  x <- tryCatch(utils::packageDescription(name, lib.loc = lib), error = function(e) NA, warning = function(e) NA)

  # will be NA if not installed
  if (identical(x, NA)) {
    return(pseudoremote("cran",
                  name = name,
                  repos = repos,
                  pkg_type = type,
                  sha = NA_character_))
  }

  if (is.null(x$RemoteType) || x$RemoteType == "cran") {

    # Packages installed with install.packages() or locally without remotes
    return(pseudoremote("cran",
                  name = x$Package,
                  repos = repos,
                  pkg_type = type,
                  sha = x$Version))
  }

  switch(x$RemoteType,
         standard = pseudoremote("cran",
                           name = x$Package,
                           repos = x$RemoteRepos %||% repos,
                           pkg_type = x$RemotePkgType %||% type,
                           sha = x$RemoteSha),
         github = pseudoremote("github",
                           host = x$RemoteHost,
                           package = x$RemotePackage,
                           repo = x$RemoteRepo,
                           subdir = x$RemoteSubdir,
                           username = x$RemoteUsername,
                           ref = x$RemoteRef,
                           sha = x$RemoteSha),
         local = pseudoremote("local",
                          path = stringr::str_trim(x$RemoteUrl),
                          subdir = x$RemoteSubdir,
                          sha = {
                            # Packages installed locally might have RemoteSha == NA_character_
                            x$RemoteSha %||% x$Version
                          }),
         stop(sprintf("can't convert package %s with RemoteType '%s' to pseudoremote", name, x$RemoteType))
  )
}

package_deps_new <- function(package = character(), installed = character(),
                             available = character(), diff = logical(), is_cran = logical(),
                             remote = list()) {

  res <- structure(
    data.frame(package = package, installed = installed, available = available, diff = diff, is_cran = is_cran, stringsAsFactors = FALSE),
    class = c("package_deps", "data.frame")
  )

  res$remote = structure(remote, class = "remotes")
  res
}

remotes_local_sha  <- function(pkgname) {
  package2pseudoremote(pkgname)$sha %||% NA_character_
}

format.remotes <- function(x, ...) {
  vapply(x, format, character(1))
}

format.cran_remote <- function(x, ...) {
  "CRAN"
}

format.github_remote <- function(x, ...) {
  "GitHub"
}

format.local_remote <- function(x, ...) {
  "local"
}


parse_one_extra <- function(x, ...) {
  pieces <- strsplit(x, "::", fixed = TRUE)[[1]]

  if ((length(pieces) == 1) && grepl("/", pieces)) {
    type <- "github"
    repo <- pieces
  } else if (length(pieces) == 2) {
    type <- pieces[1]
    repo <- pieces[2]
  } else {
    stop("Malformed remote specification '", x, "'", call. = FALSE)
  }
  tryCatch({
    res <- remotes::github_remote(repo, ...)
  }, error = function(e) stop("Unknown remote type: ", type, "\n  ", conditionMessage(e), call. = FALSE)
  )
  res
}


load_pkg_description <- function(path) {

  path <- normalizePath(path)
  path_desc <- file.path(path, "DESCRIPTION")

  fields <- colnames(read.dcf(path_desc))
  desc <-  as.list(read.dcf(path_desc, keep.white = fields)[1, ])

  names(desc) <- tolower(names(desc))
  desc$path <- path

  desc
}


#adapted from `remotes::compare_versions`..
remotes_cran_compare_versions <- function(inst, remote, is_cran) {
  #first check if the lengths of all args are equal..
  stopifnot(length(inst) == length(remote) && length(inst) == length(is_cran))

  compare_var <- function(i, c, cran) {
    if (!cran) {
      if (identical(i, c)) {
        return(remotes_current)
      } else {
        return(remotes_behind)
      }
    }
    if (is.na(c)) return(remotes_unavailable)           # not on CRAN
    if (is.na(i)) return(remotes_uninstalled)           # not installed, but on CRAN

    utils::compareVersion(i, c)
  }

  #apply along the sequence and just return back..
  vapply(seq_along(inst),
         function(i) compare_var(inst[[i]], remote[[i]], is_cran[[i]]),
         integer(1))
}
