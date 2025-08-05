#' graphiques UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_graphiques_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotly::plotlyOutput(ns("boxplot")),
    plotly::plotlyOutput(ns("jitter")),
    plotly::plotlyOutput(ns("barres_commune")),
    reactable::reactableOutput(ns("table_quartiers")),
    plotly::plotlyOutput(ns("barres_affectation")),
    plotly::plotlyOutput(ns("density")),
    plotly::plotlyOutput(ns("cumul"))
  )
}

#' graphiques Server Functions
#'
#' @noRd
mod_graphiques_server <- function(id, data){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    output$boxplot <- plotly::renderPlotly({
      df <- data()
      bounds <- get_bounds(df$Estimation_impot)
      graph_boxplot(df, bounds$inf, bounds$sup)
    })
    output$jitter <- plotly::renderPlotly({
      df <- data()
      bounds <- get_bounds(df$Estimation_impot)
      graph_jitter(df, bounds$inf, bounds$sup)
    })
    output$barres_commune <- plotly::renderPlotly({
      graph_commune_bar(data())
    })
    output$table_quartiers <- reactable::renderReactable({
      quar_table(data())
    })
    output$barres_affectation <- plotly::renderPlotly({
      graph_affectation_bar(data())
    })
    output$density <- plotly::renderPlotly({
      df <- data()
      bounds <- get_bounds(df$Estimation_impot)
      graph_density(df, bounds$inf, bounds$sup)
    })
    output$cumul <- plotly::renderPlotly({
      df <- data()
      bounds <- get_bounds(df$Estimation_impot)
      graph_cumul(df, bounds$inf, bounds$sup)
    })
    output$plot_donut_pref <- renderPlot({
      graph_donut_pref(data())
    })
  })
}

## To be copied in the UI
# mod_graphiques_ui("graphiques_1")

## To be copied in the server
# mod_graphiques_server("graphiques_1")
