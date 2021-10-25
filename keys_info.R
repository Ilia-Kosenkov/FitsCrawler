box::use(
  dplyr[filter, mutate, distinct, across],
  tidyr[pivot_wider],
  readr[parse_integer, parse_double]
)
#' @export
get <- function(keys) {
  keys |>
    filter(key != "COMMENT" & key != "HISTORY" & nzchar(key)) |>
    distinct(key, .keep_all = TRUE) |>
    pivot_wider(names_from = "key", values_from = "value")
}