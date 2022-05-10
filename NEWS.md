# svSweave 1.0.0

- `new_labelling()`, `fig()` and `tab()` are reworked to allow linking to figures and tables too.

- `eq()` is completely reworked to use Mathjax features for display equation numbering and cross-referencing.

- RStudio project added to the Github repository and many other satellite files.

- Documentation moved to Roxygen2.

- Functions renamed in snake_case with backward compatibility kept with old names

- Tests and vignette added

- 'pkgdown' site added.

# svSweave 0.9-9

- `newLabelling()`, `fig()`, `tab()` and `eq()` are added as utilities to enumerate and reference items like figures, tables or equations in a R markdown document.

# svSweave 0.9-8

- `weaveLyxRnw()`, `knitLyxRnw()`, `tangleLyxRnw()` and `purlLyxRnw()` now have a new argument `logFile =`, indicating which log file to use.

- `cleanLyxRnw()` now detects if the SciViews Knitr LyX module is used, and it automatically switches to knitr to knit or purl the document in `weaveLyxRnw()` and `tangleLyxRnw()`.

# svSweave 0.9-7

- All Asciidoc-related items are now moved to 'svDoc' package.

- Weaving and tangling are now done with `options(warn = 1)` for immediate issue of warnings.

# svSweave 0.9-6

- Slight reworking of the Asciidoc-related function `RdocXXX()`. `svBuild()` is renamed `makeRdoc()` to be more explicit.

- Addition of `header()` function that creates an Asciidoc header.

- Addition of dynamic R document features, using a customized shiny engine.

- Ten examples of dynamic documents added. They are adapted from shiny examples.

# svSweave 0.9-5

- Now knitr can also be used to weave your documents (`knitLyxRnw()`/`purlLyxRnw()`).

- Asciidoc updated to version 8.6-8.

# svSweave 0.9-4

- Added a dependence to the ascii package to support Asciidoc Sweave documents.

- Asciidoc 8.6-7 is installed with the package but it will only work if Python >= 2.4 is installed. Asciidoc is distributed under a GPL-2 license, like the package.

- `RasciidocToRnw()` and `RasciidocConvert()` added to convert SciViews R scripts embedding Sweave data into Asciidoc `.Rnw` files and to Html, respectively. `RasciidocThemes()` lists available HTML themes provided with this package.

- `svBuild()` is a convenient function to automatically compile any SciViews-R script into the final document.

# svSweave 0.9-3

- Added functions `tangleLyxRnw()` and `weaveLyxRnw()` to be called directly from LyX using `R -e svSweave::weaveLyxRnw("$$i")`.

# svSweave 0.9-2

- Added a `svSweave-package` help page.

# svSweave 0.9-1

- The LaTeX command for our chunks is renamed from \Rchunk{} to \rchunk{}.

# svSweave 0.9-0

- This is the first version distributed on R-forge and CRAN.
