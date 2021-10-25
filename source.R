box::use(
  fs[fs_path = path],
  fits_keys = ./fits_keys[...],
  keys_info = ./keys_info[...]
)

box::reload(keys_info)




fs_path("G:", "Data", "B", "20190722", "HD204827", "HD204827_B_*.fits") |> 
  # fits_keys$get() |>
  # keys_info$get() |>
  # View()
