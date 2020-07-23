pseudoremote <- function(type, ...) {
  structure(list(...), class = c(paste0(type, "_remote"), "remote"))
}



`%||%` <- function (a, b) if (!is.null(a)) a else b

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
