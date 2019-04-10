#' Detects the conflicts between natverse and other packages
#'
#' This function lists all the conflicts between packages in the natverse
#' and other packages have been already loaded n the environment.
#' Adapted and modified from conflicts function in 'tidyverse' package
#'
#'
#' @export
#' @examples
#' natverse_conflicts()
natverse_conflicts <- function() {

  envs <- purrr::set_names(search()) #list all search paths..
  objs <- invert(lapply(envs, ls_env))#vectorise the functions in the path acc to the originating environment (package)
  conflicts <- purrr::keep(objs, ~length(.x) > 1) #keep only those with more than one origins (conflicts)
  nat_names <- paste0("package:", natverse_packages())#list packages used by natverse
  conflicts <- purrr::keep(conflicts, ~any(.x %in% nat_names)) #isolate only those conflicted by natverse (dependencies and imports)
  conflict_funs <- purrr::imap(conflicts, confirm_conflict)
  conflict_funs <- purrr::compact(conflict_funs) #remove the zero entries..
  structure(conflict_funs, class = "natverse_conflicts") #for printing the conflicts in a pretty manner


}


##subfunctions now..

ls_env <- function(env) {
  x <- ls(pos = env)
# this is to provide exceptions to some conflicts (not used here)..
#  if (identical(env, "package:dplyr")) {
#    x <- setdiff(x, c("intersect", "setdiff", "setequal", "union"))
#  }
  x
}

invert <- function(x) {
  if (length(x) == 0) return()
  stacked <- utils::stack(x)
  tapply(as.character(stacked$ind), stacked$values, list)
}



natverse_packages <-  function (include_self = TRUE)
{
  raw <- paste(utils::packageDescription("natverse")$Depends,
               utils::packageDescription("natverse")$Imports, sep ='') #using both depends and imports here..
  imports <- strsplit(raw, ",")[[1]]
  parsed <- gsub("^\\s+|\\s+$", "", imports)
  names <- vapply(strsplit(parsed, " +"), "[[", 1, FUN.VALUE = character(1))
  if (include_self) {
    names <- c(names, "natverse")
  }
  names
}

#' @importFrom magrittr %>%
#confirm if it is a conflict by checking if its a function, removing duplicated functions also..
confirm_conflict <- function(packages, name) {
  # Only look at functions
  objs <- packages %>%
    purrr::map(~ get(name, pos = .)) %>%
    purrr::keep(is.function)

  if (length(objs) <= 1)
    return()

  # Remove identical functions
  objs <- objs[!duplicated(objs)]
  packages <- packages[!duplicated(packages)]
  if (length(objs) == 1)
    return()

  packages
}

#print functions now..
natverse_conflict_message <- function(x) {
  if (length(x) == 0) return("")

  header <- cli::rule(
    left = crayon::bold("Conflicts"),
    right = "natverse_conflicts()"
  )

  pkgs <- x %>% purrr::map(~ gsub("^package:", "", .))
  others <- pkgs %>% purrr::map(`[`, -1)
  other_calls <- purrr::map2_chr(
    others, names(others),
    ~ paste0(crayon::blue(.x), "::", .y, "()", collapse = ", ")
  )

  winner <- pkgs %>% purrr::map_chr(1)
  funs <- format(paste0(crayon::blue(winner), "::", crayon::green(paste0(names(x), "()"))))
  bullets <- paste0(
    crayon::red(cli::symbol$cross), " ", funs,
    " masks ", other_calls,
    collapse = "\n"
  )

  paste0(header, "\n", bullets)
}

print.natverse_conflicts <- function(x, ..., startup = FALSE) {
  cli::cat_line(natverse_conflict_message(x))
}

