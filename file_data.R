box::use(
  fs[...],
  tibble[tibble],
  dplyr[mutate, if_else],
  stringr[str_match],
  readr[parse_integer],
  forcats[as_factor]
)
#' @export
get <- function(path) {
  tibble(path = path) |>
    mutate(
      test = path |>
        path_file() |> 
        path_ext_remove() |> 
        str_match("^(.+?)(?:_(bias|dark))?_([BVR])_(\\d{4})$")
    ) |>
    mutate(
      target = test[, 2],
      type = test[, 3],
      type = if_else(is.na(type), "light", type) |> as_factor(),
      filter = test[, 4] |> as_factor(),
      id = test[, 5] |> parse_integer(),
      .keep = "unused"
    )
    
}