box::use(
  fs[fs_path = path, dir_ls = dir_ls],
  fits_keys = ./fits_keys[...],
  keys_info = ./keys_info[...],
  file_data = ./file_data[...]
)

box::reload(file_data)




fs_path("G:", "Data", "B", "20190722", "HD204827") |>
  dir_ls(glob = "*.fits") |>
  file_data$get() |>
  print()
  # fits_keys$get() |>
  # keys_info$get() |>
  # View()
