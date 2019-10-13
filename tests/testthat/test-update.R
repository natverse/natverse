test_that("natverse_update ", {
  pckgs <- natverse_deps()
  expect_is(pckgs, 'character')
})
