box::use(
  fs[fs_path = path, dir_ls = dir_ls],
  fits_keys = ./fits_keys[...],
  keys_info = ./keys_info[...],
  file_data = ./file_data[...],
  dplyr[mutate, slice],
  # purrr[map_dfr = map_dfr],
  furrr[map_dfr = future_map_dfr],
  future[ft_plan = plan, ft_cluster = cluster],
  tictoc[tic, toc]
)

ft_plan(ft_cluster(workers = 6L))

proc_file <- function(path) {
  path |>
    fits_keys$get() |>
    keys_info$get()
}


tic()

fs_path("G:", "Data", "B", "20210706") |>
  dir_ls(glob = "*.fits", recurse = TRUE) |>
  file_data$get() |>
  mutate(map_dfr(path, proc_file)) |>
  print()

toc()