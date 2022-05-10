context("labelling")

describe("figure, tables and equations labelling", {

  it("creates sequential figure numbers", {
    # Figure 1
    expect_error(
      fig("A caption", reset = TRUE),
      "You must provide either 'label' or 'ref'",
      fixed = TRUE
    )
    # Provide a label
    expect_equal(fig("A caption", label = "a_label"),
      "<style>.fig-a_label::after{content:\"1\"}</style><span class=\"figheader\">Figure\\ 1: </span>A caption")
    # Get a link to that figure
    expect_equal(fig$a_label,
      "<a class=\"fig-a_label\" href=\"#fig:a_label\"></a>")

    # Figure 2
    # Get the caption
    expect_equal(fig("Another caption", label = "label_b"),
      "<style>.fig-label_b::after{content:\"2\"}</style><span class=\"figheader\">Figure\\ 2: </span>Another caption")
    # Get a link to that figure
    expect_equal(fig$label_b,
      "<a class=\"fig-label_b\" href=\"#fig:label_b\"></a>")
  })

  it("creates sequential table numbers", {
    # Table 1
    expect_error(
      tab("One legend", reset = TRUE),
      "You must provide either 'label' or 'ref'",
      fixed = TRUE
    )
    # Get caption
    expect_equal(tab("One legend", label = "table_1"),
      "[1:]{#tab:table_1} One legend<style>.tab-table_1::after{content:\"1\"}</style>")
    # Get a link to that table
    expect_equal(tab$table_1,
      "<a class=\"tab-table_1\" href=\"#tab:table_1\"></a>")

    # Table 2
    # Get caption
    expect_equal(tab("A second legend", label = "table_2"),
      "[2:]{#tab:table_2} A second legend<style>.tab-table_2::after{content:\"2\"}</style>")
    # Get a link to that table
    expect_equal(tab$table_2,
      "<a class=\"tab-table_2\" href=\"#tab:table_2\"></a>")
  })

  it("creates sequential equation numbers", {
    # Equation 1
    expect_equal(eq(first_equation, reset = TRUE),
      "\\label{eq:first_equation} \\tag{1}")
    expect_equal(eq$first_equation, "$\\eqref{eq:first_equation}$")
    # Equation 2
    expect_equal(eq$second_equation, "$\\eqref{eq:second_equation}$")
    expect_equal(eq(second_equation), "\\label{eq:second_equation} \\tag{2}")
    # Recall both equations
    expect_equal(eq$first_equation, "$\\eqref{eq:first_equation}$")
    expect_equal(eq$second_equation, "$\\eqref{eq:second_equation}$")
  })

  # TODO: generate new labels
})
