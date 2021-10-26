box::use(
  dplyr[filter, mutate, distinct, across, if_else],
  tidyr[pivot_wider],
  readr[parse_integer, parse_double],
  stringr[str_replace_all, str_replace, str_trim],
  forcats[as_factor]
)
#' @export
get <- function(keys) {
  keys |>
    filter(key != "COMMENT" & key != "HISTORY" & nzchar(key)) |>
    distinct(key, .keep_all = TRUE) |>
    pivot_wider(names_from = "key", values_from = "value")
}

#' @export
match_type <- function(table) {
  table |>
    mutate(
      SIMPLE = SIMPLE == "T",
      AMPLIF = if_else(AMPLIF == "0", "EM", "Conventional"),
      across(
        c(
          BITPIX, NAXIS, NAXIS1, NAXIS2, 
          INDEX, BITDEP, ADCONV
        ),
        parse_integer
      ),
      across(
        c(
          ACTEXPT, ACTACCT, ACTKINT, TEMPC,
          EXPTIME, VSPEED, HSPEED, CCDGAIN,
          ANGLE, RAWANGLE
        ), 
        \(.x) str_replace(.x, "(?<=\\d),(?=\\d)", ".") |> parse_double()
      ),
      across(where(is.character), \(.x) {str_replace_all(.x, "'", "") |> str_trim()}),
      END = NULL,
      across(
        c(
          AMPLIF, BAND, IMAGETYP, REGIME, CLOCKAMP,
          AMPGAIN, MODE, READOUT, TRIGGER
        ), 
        as_factor
      )
    )
}