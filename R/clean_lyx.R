#' Clean up, weave or tangle Sweave files produced by LyX with the SciViews Sweave module
#'
#' These functions process `.Rnw`` files produced by LyX and the SciViews Sweave
#' module (not the standard Sweave module provided with LyX <= 2.0.0!). The
#' SciViews-LyX extension defines `rchunk` commands to contain R chunks
#' (embedded R code processed by Sweave). Unfortunately, LyX use to write two
#' lines feeds for each line of code, introducing extra lines in the R chunks.
#' Moreover, tabulations are interpreted as 8 spaces, while R code use to
#' consider a tabulation as equivalent to 4 spaces. [clean_lyx()] corrects
#' these little problems, and it should not affect R noweb files produced by a
#' different software.
#'
#' @param RnwCon A connection object or a character string corresponding to the
#' path to a R noweb file to be read.
#' @param RnwCon2 Idem, but where the cleaned up R noweb file should be written
#' (by default, on the same file or connection).
#' @param encoding The encoding of the `.Rnw` file. It is UTF-8 by default, but
#' you can change it here.
#' @param file The Sweave source file.
#' @param  driver The actual function to do the process, see [Sweave()].
#' @param syntax `NULL` or an object of class 'SweaveSyntax' or a character
#' string with its name,  see [Sweave()].
#' @param width The width used for outputs, 80 characters by default.
#' @param useFancyQuotes Do we use fancy quotes in R outputs?
#' @param annotate Is the R code extracted from the `.Rnw` file annotated?
#' @param logFile The file to use to log results of weaving/tangling the
#' document.
#' @param ... Further arguments passed to the driver's setup function of
#' [Sweave()] or [Stangle()].
#'
#' @return
#' For [clean_lyx()], a list for Sweave options found in the document; `NULL`
#' for the other functions: these functions are invoked for their side effects.
#' The function [weave_lyx()] uses the standard Sweave driver (but it uses knitr
#' for LyX documents that use the SciViews Knitr module), while [knit_lyx()]
#' does the same, but using the knitr driver. Similarly, [purl_lyx()] is the
#' knitr counterpart of [tangle_lyx()] standard tangling function.
#'
#' @export
#' @author Philippe Grosjean
#' @seealso [knitr::knit()], [utils::Sweave()]
#' @keywords utilities
#' @concept Literate programming
clean_lyx <- function(RnwCon, RnwCon2 = RnwCon, encoding = "UTF-8") {
  # By default, it is supposed to be a Sweave document
  opts <- list(kind = "Sweave")

  # Run in LyX as the Sweave copier using something like:
  #> R -e svSweave::clean_lyx(\"$$i\",\"$$o\") -q --vanilla --slave

  # Make sure default encoding is the same
  options(encoding = encoding)
  Sys.setlocale("LC_CTYPE", "UTF-8")

  # Read the data in the Rnw file
  Rnw <- readLines(RnwCon, encoding = encoding)

  # Is it a knitr document?
  if (any(grepl("\\%Sweave-kind=knitr", Rnw)))
    opts$kind <- "Knitr"

  # If the Rnw file is produced with LyX and SciViews Sweave module, chunks are
  # separated by \rchunk{<<[pars]>>= ... @}

  # Beginning of R-Chunks (rewrite into <<[pars]>>=)
  #starts <- grepl("^\\\\rchunk\\{<<.*>>=$", Rnw)
  #Rnw[starts] <- sub("^\\\\rchunk\\{", "", Rnw[starts])
  starts <- grepl("^<<.*>>=$", Rnw)

  # End of R-Chunks (rewrite as @)
  #ends <- grepl("^@[ \t]*\\}$", Rnw)
  #Rnw[ends] <- "@"
  ends <- Rnw == "@"

  parts <- cumsum(starts | ends)
  chunk <- parts %% 2 > 0   # R chunks are odd parts

  # Do we need to change something?
  if (!any(chunk)) {
    writeLines(Rnw, RnwCon2)
    return(invisible(opts))
  }

  # Eliminate empty strings not followed by empty strings inside chunks
  Rnw[chunk & Rnw == "" & Rnw != c(Rnw[-1], " ")] <- NA
  isna <- is.na(Rnw)
  Rnw <- Rnw[!isna]
  chunk <- chunk[!isna]

  # Eliminate successive empty strings (keep only one)
  Rnw[chunk & Rnw == "" & Rnw == c(Rnw[-1], " ")] <- NA
  Rnw <- Rnw[!is.na(Rnw)]

  # Convert tabulations into four spaces inside chunks (8 spaces by default)
  Rnw[chunk] <- gsub("\t", "    ", Rnw[chunk])

  # Write the result to the new .Rnw file
  writeLines(Rnw, RnwCon2, useBytes = TRUE)

  # Invisibly return opts
  invisible(opts)
}

# Backward compatibility

#' @export
#' @rdname clean_lyx
cleanLyxRnw <- clean_lyx
