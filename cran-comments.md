## R CMD check results

0 errors | 0 warnings | 0 notes

* This is a major release (1.0.0) that generalises the package from a single
  function to a complete toolkit. See NEWS.md.

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
