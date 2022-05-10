#' @details
#' The SciViews 'svSweave' package provides additional function to use Sweave or
#' knitr with LyX and SciViews-LyX. There are also functions to reference
#' tables, figures or equations inside a R markdown.
#'
#' @section Important functions:
#'
#' - [fig()], [tab()] or [eq()] to enumerate and reference figures, tables and
#' equations in R Markdown documents.
#'
#' - [new_labelling()] to create new items iterators.
#'
#' - [clean_lyx()], [weave_lyx()], [knit_lyx()], [tangle_lyx()], [purl_lyx()]
#' to clean up, weave or tangle Sweave files produced by LyX with the SciViews
#' Sweave or Knitr modules.
#'
#' @keywords internal
"_PACKAGE"

#' @importFrom utils Sweave Stangle Rtangle RweaveLatex as.roman
#' @importFrom knitr knit purl current_input
#' @importFrom rmarkdown default_output_format
# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL
