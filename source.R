box::use(
  FITSio[readFITS, readFITSheader, parseHdr],
  fs[fs_path = path],
  tibble[as_tibble],
  tidyr[pivot_wider],
  dplyr[mutate, n]
)

get_keys <- function(path) {
  path |> 
    readFITSheader() |>
    parseHdr() |>
    as_tibble() |>
    mutate(
      Id = (1L:n() + 1L) %/% 2L,
      Type = rep(c("Key", "Value"), n() / 2L)
    ) |>
    pivot_wider(Id, names_from = Type, values_from = value) 
}

fs_path("G:", "Data", "B", "20190722", "HD204827", "HD204827_B_0001.fits") |> 
  get_keys() |>
  print()

