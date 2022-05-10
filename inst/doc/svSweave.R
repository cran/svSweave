## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(svSweave)

## ----hist, fig.cap=fig("An example of a simple histogram.")-------------------
hist(rnorm(50))

## ----boxplot, fig.cap=fig("A second plot as an example.")---------------------
boxplot(rnorm(50))

## ----head_iris----------------------------------------------------------------
knitr::kable(head(iris),
  caption = tab("The few first lines of the `iris` dataset."))

## ----head_cars----------------------------------------------------------------
knitr::kable(head(cars),
  caption = tab("the first few lines of `cars`."), format = "pandoc")

