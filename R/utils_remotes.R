remote <- function(type, ...) {
  structure(list(...), class = c(paste0(type, "_remote"), "remote"))
}

#adapted from the remotes package to support only cran, github, local, url based installations..

package2remote <- function(name, lib = .libPaths(), repos = getOption("repos"), type = getOption("pkgType")) {

  #get the package descriptions first..
  x <- tryCatch(utils::packageDescription(name, lib.loc = lib), error = function(e) NA, warning = function(e) NA)

  # will be NA if not installed
  if (identical(x, NA)) {
    return(remote("cran",
                  name = name,
                  repos = repos,
                  pkg_type = type,
                  sha = NA_character_))
  }

  if (is.null(x$RemoteType) || x$RemoteType == "cran") {

    # Packages installed with install.packages() or locally without remotes
    return(remote("cran",
                  name = x$Package,
                  repos = repos,
                  pkg_type = type,
                  sha = x$Version))
  }

  switch(x$RemoteType,
         standard = remote("cran",
                           name = x$Package,
                           repos = x$RemoteRepos %||% repos,
                           pkg_type = x$RemotePkgType %||% type,
                           sha = x$RemoteSha),
         github = remote("github",
                         host = x$RemoteHost,
                         package = x$RemotePackage,
                         repo = x$RemoteRepo,
                         subdir = x$RemoteSubdir,
                         username = x$RemoteUsername,
                         ref = x$RemoteRef,
                         sha = x$RemoteSha,
                         auth_token = github_pat()),
         local = remote("local",
                        path = trim_ws(x$RemoteUrl),
                        subdir = x$RemoteSubdir,
                        sha = {
                          # Packages installed locally might have RemoteSha == NA_character_
                          x$RemoteSha %||% x$Version
                        }),
         url = remote("url",
                      url = trim_ws(x$RemoteUrl),
                      subdir = x$RemoteSubdir,
                      config = x$RemoteConfig,
                      pkg_type = x$RemotePkgType %||% type),
         stop(sprintf("can't convert package %s with RemoteType '%s' to remote", name, x$RemoteType))
  )
}

