test_that("convert_country handles shortcuts", {
  expect_equal(convert_country(c("Japan", "Brazil"), to = "flag"),
               c("\U0001F1EF\U0001F1F5", "\U0001F1E7\U0001F1F7"))
  expect_equal(convert_country("Germany", to = "currency"), "EUR")
  expect_equal(convert_country(c("USA", "France"), to = "continent"),
               c("Americas", "Europe"))
})

test_that("country_codes returns a tidy tibble", {
  cc <- country_codes()
  expect_s3_class(cc, "tbl_df")
  expect_true(all(c("country", "iso3c", "iso2c") %in% names(cc)))
  expect_false(anyNA(cc$iso3c))

  cc2 <- country_codes(c("continent", "currency"))
  expect_true(all(c("continent", "currency") %in% names(cc2)))
})

test_that("country_groups and in_group work", {
  eu <- country_groups("EU")
  expect_equal(nrow(eu), 27)
  expect_true("FRA" %in% eu$iso3c)

  expect_equal(in_group(c("France", "United States", "Japan"), "EU"),
               c(TRUE, FALSE, FALSE))
  expect_error(country_groups("NOPE"), class = "worlddatajoin_error")
})

test_that("bundled datasets have expected shape", {
  expect_true(nrow(common_indicators) >= 15)
  expect_true(all(c("name", "code", "description") %in% names(common_indicators)))
  expect_true(nrow(country_meta) > 200)
  expect_true(all(c("iso3c", "flag", "landlocked") %in% names(country_meta)))
  expect_true(nrow(world_tiles) > 150)
  expect_true(all(c("iso3c", "row", "col") %in% names(world_tiles)))
  expect_type(world_snapshot, "list")
  expect_true(nrow(world_snapshot$countries) > 150)
})
