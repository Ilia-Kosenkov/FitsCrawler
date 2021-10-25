box::use(
  fs[fs_path = path, dir_ls = dir_ls],
  fits_keys = ./fits_keys[...],
  keys_info = ./keys_info[...],
  file_data = ./file_data[...],
  dplyr[mutate, slice],
  # purrr[map_dfr = map_dfr],
  furrr[map_dfr = future_map_dfr],
  future[ft_plan = plan, ft_session = multisession, ft_seq = sequential],
  tictoc[tic, toc],
  readr[write_csv],
  glue[glue]
)

box::reload(keys_info)

#ft_plan(ft_cluster(workers = 4L))
ft_plan(ft_session(workers = 6L))

proc_file <- function(path) {
  path |>
    fits_keys$get() |>
    keys_info$get()
}


tic()
root <- fs_path("G:", "Data")
filter <- "V"
fs_path(root, filter) |>
  dir_ls(glob = "*.fits", recurse = TRUE) |>
  file_data$get() |>
  mutate(map_dfr(path, proc_file, .progress = TRUE)) |>
  match_type() |>
  write_csv(glue("log{filter}.csv"))
  

toc()