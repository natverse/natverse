
test_that("natverse_update ", {
  natverse_update(update = TRUE, install_missing = TRUE,dep = FALSE,lib =.libPaths())
  pckgs <- natverse_deps()
  expect_is(pckgs, 'data.frame')
})

test_that("check missing packages ", {

  # For a github package

  pckgs <- natverse_deps()
  remove.packages(pkgs = 'DependenciesGraphs',lib =.libPaths())
  pckgs <- natverse_deps()
  expect_equal(pckgs[pckgs$status == -2L,'package'], 'DependenciesGraphs')
  # restore the setting back
  natverse_update(update = FALSE, install_missing = TRUE,dep = FALSE,lib =.libPaths())
  pckgs <- natverse_deps()
  expect_equal(nrow(pckgs), 0)


  # For a cran package

  remove.packages(pkgs = 'miniUI',lib =.libPaths())
  pckgs <- natverse_deps()
  expect_equal(pckgs[pckgs$status == -2L,'package'], 'miniUI')
  # restore the setting back
  natverse_update(update = FALSE, install_missing = TRUE, dep = FALSE,lib =.libPaths(),
                  repos = "https://cloud.r-project.org/")
  pckgs <- natverse_deps()
  expect_equal(nrow(pckgs), 0)


})

test_that("check packages with lower versions", {

  # For a github package

  #This test is not possible at the moment as the installation of a lower version from GitHub typically
  #makes the remote SHA same as the local SHA which leads to version match and hence no updates

  # For a cran package

  remove.packages(pkgs = 'labeling',lib =.libPaths())
  remotes::install_version('labeling', version = "0.2", force = TRUE,lib =.libPaths(),
                           repos = "https://cloud.r-project.org/")
  pckgs <- natverse_deps()
  expect_equal(pckgs[pckgs$status == -1L,'package'], 'labeling')
  # restore the setting back
  natverse_update(update = TRUE, install_missing = TRUE, dep = FALSE,upgrade = 'always',lib =.libPaths(),
                  repos = "https://cloud.r-project.org/")
  pckgs <- natverse_deps()
  expect_equal(nrow(pckgs), 0)

})




