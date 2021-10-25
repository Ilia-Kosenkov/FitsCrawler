box::use(
  ./fits[read_header],
  stringr[str_sub, str_trim, str_locate_all],
  tibble[as_tibble],
  dplyr[mutate, across, if_else],
  purrr[map_if, map2_int]
)

#' @export
get <- function(path) {
  path |> 
    read_header() -> input
  
  keys <- input |>
    str_sub(1, 8) |>
    str_trim("right")
  
  input |>
    str_sub(10) |>
    as_tibble() |>
    mutate(
      Quote = str_locate_all(value, "(?<=')"),
      Slash = str_locate_all(value, "/"),
      across(
        c(Quote, Slash),
        \(x) map_if(x, \(.x) isTRUE(length(.x) > 0), max, .else = \(.x) -1L)
      )
    ) |>
    mutate(
      Last = map2_int(Quote, Slash, max),
      .keep = "unused"
    ) |>
    mutate(
      value = 
        if_else(
          Last == -1L, 
          value, 
          str_sub(value, 1L, Last - 1L)
        ) |>
        str_trim(),
      .keep = "unused"
    ) |>
    mutate(key = keys, .before = value)
}