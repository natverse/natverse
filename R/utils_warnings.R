`%:::%` = function(pkg, fun) get(fun, envir = asNamespace(pkg),
                                 inherits = FALSE)

#These function redefs are added as per the strategy by https://stat.ethz.ch/pipermail/r-devel/2013-August/067210.html
#They will need to removed once the remotes module fixes the defect of considering second order dependencies from
#github packages.

remotes_compare_versions <- 'remotes'%:::%'compare_versions'
#remotes_format.remotes <- 'remotes'%:::%'format.remotes'
#remotes_format_str <- 'remotes'%:::%'format_str'
remotes_load_pkg_description <- 'remotes'%:::%'load_pkg_description'
#remotes_local_sha <- 'remotes'%:::%'local_sha'
#remotes_package2remote <- 'remotes'%:::%'package2remote'
#remotes_package_deps_new <- 'remotes'%:::%'package_deps_new'
#remotes_parse_one_remote <- 'remotes'%:::%'parse_one_extra'
#remotes_remote_package_name <- 'remotes'%:::%'remote_package_name'
#remotes_remote_sha <- 'remotes'%:::%'remote_sha'



