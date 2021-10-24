box::use(
  FITSio[readFITS, readFITSheader, parseHdr],
  fs[fs_path = path],
  stringr[str_sub, str_trim, str_locate_all],
  tibble[as_tibble],
  dplyr[mutate, across, if_else],
  purrr[map_if, map2_int]
)

get_keys <- function(path) {
  path |> 
    readFITSheader() -> input
  
  keys <- input |>
    str_sub(1, 8) |>
    str_trim("right")
  
  vals <- input |>
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



fs_path("G:", "Data", "B", "20190722", "HD204827", "HD204827_B_0001.fits") |> 
  get_keys() |>
  print()

