box::use(
  fs[fs_path = path, dir_ls = dir_ls],
  fits_keys = ./fits_keys[...],
  keys_info = ./keys_info[...],
  file_data = ./file_data[...],
  dplyr[mutate, slice],
  purrr[map_dfr = map_dfr]
)

proc_file <- function(path) {
  path |>
    fits_keys$get() |>
    keys_info$get()
}



fs_path("G:", "Data", "B", "20210706", "MAXIJ1820") |>
  dir_ls(glob = "*.fits", recurse = TRUE) |>
  file_data$get() |>
  mutate(map_dfr(path, proc_file)) |>
  print(n = 10000)