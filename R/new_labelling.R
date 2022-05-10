#' Reference figures, tables and equations in R Markdown documents
#'
#' These functions return closures that allow for constructing a series of
#' numbered items and to reference them. The number is create the first time a
#' label is encountered, and provided again for further use of the same label.
#'
#' @param type The type of numbering (arabic or roman).
#' @param string_html The string prototyping the legend, with `++++` being the
#' name (`fig` by default) `@@@@` being a placeholder for the text, `####` as a
#' placeholder for the number, or `%%%%` as a placeholder for the label.
#' @param string_latex Idem for LaTeX.
#' @param string_word Idem for Word.
#' @param string_ref_html Idem for reference in HTML format.
#' @param string_ref_latex Idem for reference in LaTeX format.
#' @param string_ref_word Idem for reference in Word format.
#' @param name The name to use before the number, e.g., "Fig." to get "Fig. 1"
#' as cross-reference text for the first figure. If you provide `name = NULL`,
#' only the number is produced.
#' @param caption The test of the caption.
#' @param label A short string uniquely identifying the item within the
#' collection. To set a label in and equation, give a name instead of a string.
#' @param ref The reference to the label.
#' @param reset If `TRUE`, the collection is reset. Useful if you want to
#' restart numbering at the beginning of each chapter.
#'
#' @return
#' The function returns a caption if `text =` is provided, or an anchor if it is
#' missing. If `text=` contains a name, it returns a link.
#' Same for the `label=` for `eq()`: if it is a text, a couple label + tag to
#' place inside display equations is produced, and if it is a name, a link is
#' provided. [new_labelling()] creates a new labelling function, which has the
#' same arguments as [fig()].
#'
#' @details
#' A new labelling type is created using [new_labelling()] which is a function
#' factory (a function that creates functions).
#'
#' @export
#' @author Philippe Grosjean
#' @keywords utilities
#' @concept automatic numbering of items in documents
#' @examples
#' # These function are supposed to be used in an R Markdown document
#' # see the svSweave vignette
#' # Produce a caption that contains the required code to number and reference
#' # a figure in HTML documents
#' fig("A caption", label = "a_label")
#' # Produce a reference to that figure
#' fig$a_label
new_labelling <- function(type = c("arabic", "roman"),
string_html = paste0('<style>.++++-%%%%::after{content:"####"}</style>',
  '<span class="figheader">Figure\\ ####: </span>@@@@'),
string_latex = '@@@@',
string_word = '[Figure\\ ####:]{#++++:%%%%} @@@@',
string_ref_html = '<a class="++++-%%%%" href="#++++:%%%%"></a>',
string_ref_latex = '\\ref{++++:%%%%}',
string_ref_word = '[####](#++++:%%%%)',
name = "fig") {
  type <- match.arg(type)
  conv <- switch(type,
    arabic = function(x) x,
    roman = function(x) as.roman(x)
  )
  string_html <- as.character(string_html)[1]
  string_latex <- as.character(string_latex)[1]
  string_word <- as.character(string_word)[1]
  string_ref_html <- as.character(string_ref_html)[1]
  string_ref_latex <- as.character(string_ref_latex)[1]
  sstring_ref_word <- as.character(string_ref_word)[1]
  name <- as.character(name)[1]
  labels <- list()

  # Return a function that creates the enumeration of the items
  structure(function(caption = "", label = knitr::opts_current$get("label"),
    ref = NULL, reset = FALSE) {
    # Do we reset labels?
    if (isTRUE(reset))
      labels <<- list()

    if (!missing(ref)) {# Create a reference to an item
      label <- ref
      string_html <- string_ref_html
      string_latex <- string_ref_latex
      string_word <- string_ref_word
    }
    is_word <- .is_word_output()
    if (is_word) {
      string <- string_word
    } else if (knitr::is_latex_output()) {
      string <- string_latex
    } else {
      string <- string_html
    }

    if (is.null(label))
      stop("You must provide either 'label' or 'ref'")

    # We use four parts: the name, the label, the value, and the caption
    # They are mapped, respectively, to ++++, %%%%, #### and @@@@ in the string
    label <- gsub("\\.", "-", make.names(label))
    if (missing(ref) || is_word) {
      value <- labels[[label]]
      # Does it exists?
      if (is.null(value)) {
        value <- length(labels) + 1
        # Record this item in labels
        labels[[label]] <- value
        labels <<- labels
      }
      value <- conv(value) # arabic or roman
    } else value <- "" # Not used in ref
    gsub("\\+\\+\\+\\+", name, gsub("%%%%", label, gsub("####", value,
      gsub("@@@@", caption, string))))
  }, class = c("function", "subsettable_labelling_ref"))
}

# Not used, but for future reference to implement numbering by chapter!
#<style>
#body { counter-reset: chapter; }
#h1 { counter-increment: chapter; }
#.chapternumdd::before { content: counter(chapter) "."; }
#</style>

# Backward compatibility

#' @export
#' @rdname new_labelling
newLabelling <- new_labelling

#' @export
#' @rdname new_labelling
fig <- new_labelling()

#' @export
#' @rdname new_labelling
tab <- new_labelling(string_html = '[####:]{#++++:%%%%} @@@@<style>.++++-%%%%::after{content:"####"}</style>',
  string_latex = '\\label{++++:%%%%} @@@@',
  string_word = '[Table ####:]{#++++:%%%%} @@@@',
  name = "tab")

# Equations are a little bit special
#' @export
#' @rdname new_labelling
eq <- (function() {
  labels <- list()

  # Return a function that creates the enumeration of the equations
  structure(function(label, ref, reset = FALSE) {
    # Do we reset eqs?
    if (isTRUE(reset))
      labels <<- list()

    if (!missing(ref) && # Create a reference to an equation
      !.is_word_output()) {
      paste0("$\\eqref{eq:", gsub("\\.", "-", make.names(ref)), "}$")

    } else {# Build the label and tag inside a display equation
      if (!missing(ref))
        label <- ref
      label <- as.character(substitute(label))
      label <- gsub("\\.", "-", make.names(label))
      value <- labels[[label]]
      # Does it exists?
      if (is.null(value)) {
        value <- length(labels) + 1
        # Record this item in labels
        labels[[label]] <- value
        labels <<- labels
      }
      if (.is_word_output()) {
        if (!missing(ref)) {
          paste0("[(", value, ")](#eq:", gsub("\\.", "-", make.names(ref)), ")")
        } else {
          paste0("$$ [(", value, ")]{#eq:", label, ' align="right"}')
        }
      } else {
        paste0("\\label{eq:", label, "} \\tag{", value, "}")
      }
    }
  }, class = c("function", "subsettable_labelling_ref"))
})()

#' Define a function as being 'subsettable' using $ operator
#'
#' @description For labelling items like [fig()], [tab()] or [eq()], implements
#' the `$` method to retrieve a reference and build a link to the element.
#' @export
#' @name subsettable
#' @param x A `subsettable_labelling_ref` function.
#' @param name The value to use for the `ref=` argument.
#' @method $ subsettable_labelling_ref
#' @keywords utilities
#' @concept create 'subsettable' functions
#' @examples
#' eq(pythagoras) # Create a label / tag pair for R Markdown display equations
#' eq$pythagoras  # Create a link to the equation somewhere else in the document
`$.subsettable_labelling_ref` <- function(x, name)
  x(ref = name)

#' Create a figure id from a chunk label
#'
#' This function looks at the current chunk label and returns id="fig:label"
#' that is usable in the `out.extra=` field of the R chunk. It allows to refer
#' to a figure generated from a chunk with this label. Use
#' `out.extra=chunk_id()` to set the id, or use `fig_id_auto()`.
#'
#' @param label The label to use. If provided, it supersedes the chunk label.
#'
#' @return A string to set the id like id="fig:label". For [fig_id_auto()],
#' the function installs a hook in 'knitr' to add an id automatically for each
#' plot make by changing `out.extra=`.
#' @export
#'
#' @examples
#' fig_id("my_label")
fig_id <- function(label) {
  if (knitr::is_latex_output())
    return("") # If we return NULL, markdown makes the fig and label is not set!
  if (missing(label))
    label <-  knitr::opts_current$get("label")
  if (!is.null(label)) {
    # Educate label
    label <- gsub("\\.", "-", make.names(label))
    # Create and id="label" string
    label <- paste0('id="fig:', label, '"')
  }
  label
}

#' @rdname fig_id
#' @export
fig_id_auto <- function() {
  knitr::opts_chunk$set(out.extra = substitute(fig_id()))
}

.is_word_output <- function() {
  res <- try(rmarkdown::default_output_format(knitr::current_input())$name ==
      "word_document", silent = TRUE)
  if (inherits(res, "try-error")) FALSE else res
}
