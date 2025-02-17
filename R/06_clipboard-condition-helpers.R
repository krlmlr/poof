#' Clipboard Focused Condition Helpers
#' @export
#' @rdname clipboard-condition-helpers
clipboard_contains_text <- function() {
  w <- options(warn = 2)
  on.exit(options(warn = w$warn))
  !fails(clipboard_text())
}

#' @export
#' @rdname clipboard-condition-helpers
clipboard_is_parsable <- function() {
  clipboard_contains_text() && !fails(parse(text=clipboard_text()))
}

#' @export
#' @rdname clipboard-condition-helpers
clipboard_text <- function() {
  clipr::read_clip()
}
