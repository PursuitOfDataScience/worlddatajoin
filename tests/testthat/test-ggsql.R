test_that("world_query emits the expected ggsql clauses", {
  q <- world_query(gdp_per_capita, projection = "equal_earth",
                   palette = "magma", transform = "log10", title = "GDP")
  expect_s3_class(q, "ggsql_query")
  expect_match(q, "VISUALISE gdp_per_capita AS fill")
  expect_match(q, "FROM countryatlas_world")
  expect_match(q, "DRAW spatial")
  expect_match(q, "PROJECT TO equal_earth")
  expect_match(q, "SCALE fill TO magma VIA log10")
  expect_match(q, "LABEL title => 'GDP'")
})

test_that("world_query omits optional clauses and escapes quotes", {
  q <- world_query("pop", projection = NULL, palette = NULL,
                   title = "it's a map")
  expect_false(grepl("PROJECT", q))
  expect_false(grepl("SCALE", q))
  expect_match(q, "LABEL title => 'it''s a map'")
})

test_that("ggsql helpers error cleanly without the optional stack", {
  skip_if(requireNamespace("ggsql", quietly = TRUE))
  expect_error(
    interactive_map(world_snapshot$countries, gdp_per_capita, engine = "ggsql")
  )
})
