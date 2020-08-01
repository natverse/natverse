library(natverse)

r = getOption("repos")
r["CRAN"] = "http://cran.us.r-project.org"
options(repos = r)

context("check for return type")
test_that("natverse_update ", {
   pckgs <- natverse_deps(verbose = FALSE)
   expect_is(pckgs, 'data.frame')

})

stub_remoteversions <- function(pkgnames, pkgtype){
  print(paste0('mocking ',pkgtype, '  now..'))
  test_df = natverse:::get_remoteversions(pkgnames, pkgtype)
  if(pkgtype == 'Github'){
    test_df[test_df$package == "nat.flybrains",'diff'] = 0
  } else if(pkgtype == 'CRAN'){
    test_df[test_df$package == "zip",'diff'] = -1
  }
  test_df
}

#perform mock tests for checking package installations..

context("check with stubs")
test_that("check github package installations", {

  mockery::stub(natverse_deps,'get_remoteversions', stub_remoteversions, depth = 1)

  deps_df <- natverse_deps(verbose = TRUE)

  expect_true(any("zip" == deps_df['package']))
  expect_false(any("nat.flybrains" == deps_df['package']))


})
