#' Print status of natverse dependencies
#'
#' This will check to see if all natverse packages (and optionally (if
#' \code{recursive = TRUE}), their dependencies ). End users should probably
#' just use the \code{\link{natverse_update}} function (which wraps
#' \code{natverse_deps}.
#'
#' @param recursive If \code{TRUE}, will also check all dependencies of natverse
#'   packages.
#' @param verbose Set to TRUE if you want to display the table of dependencies
#'   and warnings etc.
#' @param display_all Set to TRUE if you want to display all the contents of the
#'   table.
#' @param ... extra arguments to pass to \code{\link[base]{find.package}}.
#' @return A character vector containing packages that are either missing or are
#'   not up-to-date.
#' @export
#' @seealso \code{\link{natverse_update}}
#' @examples
#' \dontrun{
#' natverse_deps()
#' }
natverse_deps <- function(recursive = TRUE,verbose = TRUE, display_all = FALSE,...) {

  # set CRAN repository if unset
  r = getOption("repos")
  if(isTRUE(is.na(r["CRAN"])) || "@CRAN@" %in% r) {
    # CRAN option completely unset or has signalling value
    r["CRAN"] = "https://cloud.r-project.org/"
    op <- options(repos = r)
    on.exit(options(op))
  }

  #Get details of the dependencies of the main package here ('natverse') that has been installed in this machine
  #The first level dependencies that exists both on CRAN and GitHub..
  #For e.g. for `natverse` -> `fafbseg`,`fishatlas`,`insectbrainr` etc.
  pkgstatus_df <- remotes::dev_package_deps(suppressWarnings(find.package("natverse", ...)),
                                            dependencies = recursive)

  ## The below code is only necessary as the remotes package ignores dependencies of non-cran packages (Github) at
  ##  the second level like `fafbsegdata` below..
  #For e.g. for `fafbseg` -> `fafbsegdata`

  #Now collect only the develop (github) packages in the first level
  #(these are the ones not processed by the
  #remotes package further recursively)..
  firstleveldep <- remotes::local_package_deps(suppressWarnings(find.package("natverse", ...)),
                                               dependencies = recursive)

  #This is to undo changes done by `dev_package_deps` incase a package was installed from CRAN but a newer version is found in Github, the function should stick with the repo or source where it was installed from..
  temppkgstatus_df <- remotes::package_deps(firstleveldep)
  temppkgstatus_df <- temppkgstatus_df[temppkgstatus_df$is_cran,] #Choose only CRAN packages now..
  temppkgstatus_df <- temppkgstatus_df[!is.na(temppkgstatus_df$available),] #Sanity check with version number..

  pkgstatus_df <- pkgstatus_df[!(pkgstatus_df$package %in% temppkgstatus_df$package), ]
  pkgstatus_df <- rbind(pkgstatus_df,temppkgstatus_df) #Put them back now..

  #Convert them to remotes to recognize github pacakges from cran..
  firstlevelremote <- structure(lapply(firstleveldep, remotes_package2remote), class = "remotes")
  is_github_remote <- vapply(firstlevelremote, inherits, logical(1), "github_remote")
  firstlevelgitpkg <- firstleveldep[is_github_remote]


  #Now load the second level dependencies of the firstlevelgit packages
  github_deps <- unique(unlist(lapply(suppressWarnings(find.package(firstlevelgitpkg, ...)),
                                      remotes::local_package_deps,
                                      dependencies = recursive)))

  #Now subset only those that have not been listed before..
  github_deps <- setdiff(github_deps,pkgstatus_df$package)

  # Remove base packages from those dependencies
  inst <- utils::installed.packages()
  base <- unname(inst[inst[, "Priority"] %in% c("base", "recommended"), "Package"])
  github_deps <- setdiff(github_deps, base)

  #Now check the versions for these refined dependencies alone..
  refined_pkgs <- lapply(suppressWarnings(find.package(github_deps, ...)), remotes_load_pkg_description)

  #The following packages don't have local description files (which means not installed locally, could
  #be packages from either `CRAN` or `GitHub`)
  missing_pkgs <- setdiff(github_deps,unlist(lapply(refined_pkgs, `[`, c('package'))))

  repos_list <- lapply(refined_pkgs, `[`, c('repository'))
  is_cran<- which(unlist(lapply(repos_list, function(x) {if(is.null(x[[1]])){FALSE}
                                                         else if (x[[1]] == 'CRAN') {TRUE}})))

  repos_list <- lapply(refined_pkgs, `[`, c('remotetype'))
  is_github<- which(unlist(lapply(repos_list, function(x) {if(is.null(x[[1]])){FALSE}
                                                           else if (x[[1]] == 'github') {TRUE}})))

  #Warn about packages that are common in config between GitHub and CRAN
  if (length(intersect(is_github,is_cran)) && (verbose == TRUE)){
    cli::cat_line(crayon::red(
      "\nThe following packages below are configured as both CRAN and Github!\n"))
    cli::cat_line("  ", paste0(unlist(lapply(refined_pkgs[intersect(is_github,is_cran)], `[[`, c('package'))),
                               collapse = ','))
    cli::cat_line("\nWe recommend checking their configurations")
  }

 #Warn about packages that have no known information (either locally installed or githubs where repo not known as   they have been locally modified by a developer)..
  localpkgsids <- refined_pkgs[setdiff(1:length(refined_pkgs), union(is_github,is_cran))]
  localpkgs <- unlist(lapply(localpkgsids,`[[`, c('package')))

  #Get the git and cran ones seperately..
  cran_pkgslist <- refined_pkgs[is_cran]
  github_pkgslist <- refined_pkgs[is_github]

  #Checking cran versions..
  cran_pkgs <- unlist(lapply(cran_pkgslist, `[[`, c('package')))
  cranstatus_df <- get_remoteversions(cran_pkgs,'CRAN')

  #Checking github versions..
  github_pkgs <- unlist(lapply(github_pkgslist, function(x) {paste0(x$remoteusername,'/',x$remoterepo)}))
  githubstatus_df <- get_remoteversions(github_pkgs,'Github')

  #Now finally append them all..
  allpkgstatus_df <- rbind(pkgstatus_df,cranstatus_df,githubstatus_df)

  pkgstatus_df <- allpkgstatus_df

  #Check for a round of locally installed packages from the full df now..
  localstatus <- unlist(lapply(pkgstatus_df$package,local_remotes))
  localstatpkg <- pkgstatus_df$package[which(localstatus)]

  noinfopkgs <- union(localpkgs,missing_pkgs)
  noinfopkgs <- union(noinfopkgs,localstatpkg)
  #Warn about packages that are locally installed or information is missing..
  if (length(noinfopkgs)){
    pkgstatus_df <- pkgstatus_df[!(pkgstatus_df$package %in% noinfopkgs),]

    if (verbose == TRUE){
      cli::cat_line(crayon::yellow(
        "\nThe following packages are either locally installed or information about them is missing!\n"))
      cli::cat_line("  ", paste0(noinfopkgs, collapse = ', '))
      cli::cat_line("\nPlease install them manually from their appropriate source locations")
    }
  }

  #Now convert them to a readable format..
  deps <- data.frame(package=character(nrow(pkgstatus_df)),remote=character(nrow(pkgstatus_df)),
                     local=character(nrow(pkgstatus_df)),source=character(nrow(pkgstatus_df)),
                     behind=logical(nrow(pkgstatus_df)),stringsAsFactors=FALSE)
  deps$package  <- pkgstatus_df$package
  deps$remote <- pkgstatus_df$available
  deps$local <- pkgstatus_df$installed
  deps$source <- remotes_format.remotes(pkgstatus_df$remote)
  deps$diff <-  pkgstatus_df$diff
  deps$repo <-  lapply(pkgstatus_df$remote, function(x) x$username)
  deps[deps$source == 'CRAN','repo'] <- 'https://cran.rstudio.com/'


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
  deps$remote <- lapply(deps$remote, remotes_format_str, width = 12)
  deps$local <- lapply(deps$local, remotes_format_str, width = 12)

  pckglist = character(length = 0)

  if (nrow(behind_temp) == 0 && (verbose == TRUE)) {
    cli::cat_line(crayon::green(
      paste0(
        "\nAll natverse dependencies are up-to-date"
      )
    ))
  } else{

    if (verbose == TRUE){

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
  }

    row.names(deps) <- deps$package
    deps <- deps[ order(row.names(deps)), ]
    row.names(deps) <- NULL

    if (verbose == TRUE) {
      cli::cat_line()

      if (display_all == FALSE) {
        shortdeps <- deps[deps$diff != 0,]
        if (nrow(shortdeps) > 0) {
          cli::cat_line(format(
            knitr::kable(shortdeps[, c('package', 'remote', 'local', 'source', 'repo', 'status')],
                         format = "pandoc", row.names =
                           FALSE)
          ))
        }

      } else{
        cli::cat_line(format(knitr::kable(
          deps[, c('package', 'remote', 'local', 'source', 'repo', 'status')],
          format = "pandoc", row.names = FALSE
        )))
      }
      cli::cat_line()
    }

    pckglist = unique(pckglist)

    pckglist_df <- data.frame(package=character(length(pckglist)),
                              source=character(length(pckglist)),
                              reponame=character(length(pckglist)),
                              status=character(length(pckglist)),
                              stringsAsFactors=FALSE)
    pckglist_df$package = deps[deps$package %in% pckglist, 'package']
    pckglist_df$source = deps[deps$package %in% pckglist, 'source']
    pckglist_df$reponame = deps[deps$package %in% pckglist, 'repo']
    pckglist_df$status = deps[deps$package %in% pckglist, 'diff']

    invisible(pckglist_df)
}

#' Check status of natverse packages and (optionally) update if necessary
#'
#' This will check to see if all natverse packages (and by default, when
#' \code{recursive = TRUE}), their dependencies ) are up-to-date, and will
#' update them (optionally, if \code{update = TRUE}) if they are missing or are
#' not up-to-date!
#' @param update If \code{TRUE}, will actually update the packages rather than
#'   just reporting the status of dependent packages.
#' @param install_missing If \code{TRUE}, will install any missing packages.
#' @param recursive If \code{TRUE}, will also check all dependencies of natverse
#'   packages.
#' @param ... extra arguments to pass to \code{\link[remotes]{update_packages}},
#'   \code{\link[remotes]{install_cran}}, \code{\link[remotes]{install_github}}.
#' @param upgrade Whether or not to ask you about updating the dependencies of
#'   natverse packages. The 'default' value will ask in interactive session. Set
#'   to 'always' to install all dependencies without prompts. See
#'   \code{\link[remotes]{update_packages}} for further details.
#'
#' @export
#' @examples
#' \dontrun{
#' # check status of natverse and its dependencies
#' natverse_update()
#'
#' # ... actually install any updates
#' natverse_update(update=TRUE)
#'
#' # update any indirect dependencies without requesting your confirmation
#' natverse_update(update=TRUE, upgrade='always')
#' }
natverse_update <- function(update=FALSE, install_missing = update,
                            recursive = TRUE,
                            upgrade = c("default", "ask", "always", "never"),
                            ...) {
  if(interactive())
    message("Checking for remote package updates ...")
  pkgs_list=natverse_deps(recursive)

  if(nrow(pkgs_list)==0)
    return(invisible())

  missing_df <- pkgs_list[pkgs_list$status == -2L,]

  if(install_missing && nrow(missing_df)>0){
   #First install missing CRAN packages..
    temp_df <- missing_df[missing_df$source == 'CRAN',]
    if (nrow(temp_df)>0){
      remotes::install_cran(temp_df$package, upgrade=upgrade, ...)}
   #Next install missing Github packages..
    temp_df <- missing_df[missing_df$source == 'GitHub',]
    if (nrow(temp_df)>0){
      temp_df$repfullname <- paste0(temp_df$reponame,'/',temp_df$package)
      remotes::install_github(temp_df$repfullname, upgrade=upgrade, ...)}

    #This is to check again the state of dependencies
    pkgs_list=natverse_deps(recursive, verbose = FALSE)
  }

  if(update){
    # Now perform the updates
    remotes::update_packages(pkgs_list$package, upgrade=upgrade, ...)
  }
}


# local functions

get_remoteversions <- function (pkgnames, pkgtype = c('CRAN','Github')){

  pkgtype <- match.arg(pkgtype)

  #Convert the CRAN packages to remote to check for versions..
  if (pkgtype == 'CRAN'){
    cran_remt <- structure(lapply(pkgnames, remotes_package2remote, repos = getOption("repos"),
                                  type=getOption("pkgType")), class = "remotes")
    inst_ver <- vapply(pkgnames, remotes_local_sha, character(1))
    cran_ver <- vapply(cran_remt, function(x) remotes_remote_sha(x), character(1))
    is_cran_remote <- vapply(cran_remt, inherits, logical(1), "cran_remote")
    diff <- remotes_compare_versions(inst_ver, cran_ver, is_cran_remote)
    cranstatus_df <- structure(data.frame(package = pkgnames,installed = inst_ver,
                                          available = cran_ver,diff = diff,
                                          is_cran = is_cran_remote,
                                          stringsAsFactors = FALSE),class = c("package_deps", "data.frame"))

    cranstatus_df$remote <- cran_remt

    return(cranstatus_df)

  } else if (pkgtype == 'Github'){

    git_remote <- lapply(pkgnames, remotes_parse_one_remote)

    package <- vapply(git_remote, function(x) remotes_remote_package_name(x), character(1), USE.NAMES = FALSE)
    installed <- vapply(package, function(x) remotes_local_sha(x), character(1), USE.NAMES = FALSE)
    available <- vapply(git_remote, function(x) remotes_remote_sha(x), character(1), USE.NAMES = FALSE)

    diff <- installed == available
    diff <- ifelse(!is.na(diff) & diff, 'remotes'%:::%'CURRENT', 'remotes'%:::%'BEHIND')
    diff[is.na(installed)] <- 'remotes'%:::%'UNINSTALLED'
    githubstatus_df <- remotes_package_deps_new(package, installed, available, diff, is_cran = FALSE, git_remote)

    return(githubstatus_df)

  }

}

local_remotes <- function(pkgname) {
  localstatus <- FALSE
  tryCatch(
    expr = {
            pkgdir <- find.package(pkgname)

            pkg <- remotes_load_pkg_description(pkgdir)
            #For github packages..
            remotetype <- pkg$remotetype

            #For cran packages..
            remoterepository <- pkg$repository

            if (is.null(remotetype) && is.null(remoterepository)){localstatus <- TRUE}
            return(localstatus)

            },
    error = function(errormsg){
      message( "\npackage: ", pkgname, " was not found\n")
      return (NA)
            },
    warning = function(warnmsg){
      message( "\npackage: ", pkgname, " was not found\n")
      return (NA)
          }
  )
}
