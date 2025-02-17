#' Create a new trick
#'
#' Create a trick to be used as an argument in `poof::add_tricks()`, mainly useful
#' to store tricks in packages
#'
#' @param label A string
#' @param condition A one sided formula, using condition helpers and context informers, whose
#'   right hand side expressions returns a boolean when evaluated by {poof}
#' @param action A one sided formula, using action helpers and context informers, whose
#'   right hand side triggers the desired actions when evaluated by {poof}
#'
#' @return a "poof_trick" object
#' @export
#'
#' @examples
#' new_trick(
#' "Edit user '.Rprofile'",
#' ~ selection_is_empty(),
#'~ usethis::edit_r_profile()
#' )
new_trick <- function(label, condition, action) {
  fml <- as.call(c(as.symbol("~"), condition[[2]], action[[2]]))
  trick <- list(fml)
  names(trick) <- label
  structure(trick, class = "poof_trick")
}

#' @export
print.poof_trick <- function(x, ...) {
  writeLines(c(
    "# A trick for the {poof} package",
    paste("label:", deparse(names(x))),
    paste("condition:", paste(deparse(x[[c(1,2)]]), collapse = "\n  ")),
    paste("action:", paste(deparse(x[[c(1,3)]]), collapse = "\n  "))
  ))
  invisible(x)
}



