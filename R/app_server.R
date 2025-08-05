#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic readRDS
  donnees <- reactive({
    readRDS(app_sys("extdata/mad_cad_cleaned.rds"))
  })

  data1 <- mod_filtre_commune_server("filtre1", donnees)
  mod_indicateurs_server("carte1", data1)
  mod_carte_server("carte1", data1)

  data2 <- mod_filtre_commune_server("filtre2", donnees)
  mod_tableau_server("tableau1", data2)

  data3 <- mod_filtre_commune_server("filtre3", donnees)
  mod_graphiques_server("graph1", data3)
}
