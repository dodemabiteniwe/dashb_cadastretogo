#' tableau UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_tableau_ui <- function(id) {
  ns <- NS(id)
  tagList(
    DT::DTOutput(ns("table"))
  )
}

#' tableau Server Functions
#'
#' @noRd
mod_tableau_server <- function(id, data){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    output$table <- DT::renderDT({
      DT::datatable(data(), options = list(pageLength = 10, scrollX = TRUE))
    })
    output$telecharger <- downloadHandler(
      filename = function() {
        paste0("cadastre_filtr\u00e9_", Sys.Date(), ".xlsx")
      },
      content = function(file) {
        openxlsx2::write_xlsx(data(), file, row_names = FALSE)
      }
    )

  })
}

## To be copied in the UI
# mod_tableau_ui("tableau_1")

## To be copied in the server
# mod_tableau_server("tableau_1")
