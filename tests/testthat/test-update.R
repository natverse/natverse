
r = getOption("repos")
r["CRAN"] = "http://cran.us.r-project.org"
options(repos = r)


test_that("natverse_update ", {
   pckgs <- natverse_deps()
   expect_is(pckgs, 'data.frame')
})

