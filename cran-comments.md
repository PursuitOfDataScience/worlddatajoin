## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new submission.

## Resubmission

This is a resubmission. In response to the automated incoming pre-tests:

* Fixed: declared the minimum R version as `R (>= 4.1.0)` in DESCRIPTION,
  since the package uses the native pipe `|>` (introduced in R 4.1.0).
* The words flagged as "possibly misspelled" in DESCRIPTION — "choropleth",
  "choropleths" and "cartogram" — are correctly spelled cartography and
  data-visualization terms, not misspellings.

## Test environments

* local: R 4.4.1 on Linux
* GitHub Actions: ubuntu (devel, release, oldrel-1), macOS (release),
  windows (release)

## Notes

* All examples that touch the World Bank API or heavy optional spatial
  dependencies are wrapped in `\donttest{}` / `\dontrun{}`.
* Tests that require the network are skipped on CRAN and when the World Bank API
  is unreachable; the bundled `world_snapshot` dataset keeps the remaining tests
  offline and deterministic.
* Heavy spatial dependencies (`sf`, `rnaturalearth`, `cartogram`, `biscale`,
  `geofacet`, `gganimate`, `leaflet`, `ggiraph`, `plotly`, `rmapshaper`) are in
  `Suggests` and gated with `rlang::check_installed()`.
