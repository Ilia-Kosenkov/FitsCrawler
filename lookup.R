box::use(
  fs[fs_path = path],
  readr[read_csv],
  dplyr[mutate, select, filter, transmute, if_else, group_by, summarise, n, arrange],
  stringr[str_detect],
  lubridate[ymd, ymd_hms, ddays, floor_date],
  vctrs[vec_c, vec_slice],
  purrr[map_dfr]
)

mjd_origin <- ymd("1858-11-17", tz = "UTC")

fs_path("logV.csv") |>
  read_csv(show_col_type = FALSE) |>
  mutate(
    `DATE-OBS` = if_else(is.na(`DATE-OBS`), DATE |> ymd_hms(tz = "UTC"), `DATE-OBS`),
    MJD = (`DATE-OBS` - mjd_origin) / ddays(1)
  ) |>
  select(target, type, id, MJD, `DATE-OBS`, DATE, EXPTIME, AMPLIF) -> data
  
proc_obj <- function(obj_pattern) {
  data |>
    filter(str_detect(target, obj_pattern)) |>
    mutate(cat = (MJD + 0.5) %/% 1) |>
    filter(type == "light") |>
    group_by(cat) |>
    summarise(
      target = vec_slice(target, 1L),
      MJD = mean(MJD), 
      DATE = mean(`DATE-OBS`) |> floor_date("day"),
      N = n(),
      EXPTIME = mean(EXPTIME), 
      AMPLIF = vec_slice(AMPLIF, 1L),
    ) |>
    select(-cat)
}


vec_c("404", "4641", "1957", "1357", "1118", "2012") |>
  map_dfr(proc_obj) |>
  arrange(MJD, target) -> result

print(result, n = 100)