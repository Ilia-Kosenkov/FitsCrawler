box::use(
  purrr[map_chr],
  stringr[str_sub, str_which],
  vctrs[vec_c, vec_slice]
)
read_header <- function (path) 
{
    by <- 80L
    n <- 36L
    con <- file(path, open = "rb")
    on.exit(close(con), add = TRUE)
    finished <- FALSE
    count <- 0L
    result <- character(0)
    while(!finished && count < 6L) {
      count <- count + 1L
      keys <- readChar(con, by * n) |> suppressWarnings()
      if(nchar(keys) == 0L) {
        finished <- TRUE
      }
      else {
        tmp <- map_chr(
          1:n - 1L, 
          \(.x) str_sub(keys, by * .x + 1L, by * .x + by)
        )
        
        id <- str_which(tmp, "^END")
        if(length(id) > 0) {
          result <- vec_c(result, vec_slice(tmp, seq_len(id)))
          finished <- TRUE
        } else {
          result <- vec_c(result, tmp)
        }
      }
    }
    
    result
}