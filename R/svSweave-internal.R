.onLoad <- function(lib, pkg) { # nocov start
  # Automatically set the default out.extra of subsequent R chunks so that
  # the id of the generated plot is equivalent to the chunk label
  fig_id_auto()
} # nocov end
