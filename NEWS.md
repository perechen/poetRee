# poetRee 0.1.0

* API moved to `https://poetree.org/api/`.
* New `get_locations()`: places (Wikidata IDs) mentioned in poems, one mention per row, for one or many poem IDs.
* `get_text()` gains `rhyme` (IDs of rhyming lines) and `locations` (Wikidata IDs per line or token) arguments.
* `get_text()` parsing rewritten to follow API changes (new `rhyme` field, `locations` as `[]`, `false` or spans); columns are matched by name, not position.
* `get_text()` and `get_locations()` give an informative error for unknown corpora or poem IDs.
* `get_poems(tidy = FALSE)` now bundles co-authors of a poem into one row (grouping was reversed).
* `get_sources(tidy = FALSE)` bundles author IDs as `"11,12"` instead of a deparsed vector.
* Offline tests on synthetic fixtures; live API tests are skipped on CRAN and offline.
