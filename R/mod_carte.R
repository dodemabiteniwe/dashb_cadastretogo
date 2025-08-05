#' carte UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_carte_ui <- function(id) {
  ns <- NS(id)
  tagList(
    leaflet::leafletOutput(ns("carte"), width = "100%", height = "100%")
  )
}

#' carte Server Functions
#'
#' @noRd
mod_carte_server <- function(id, data){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    output$carte <- leaflet::renderLeaflet({
      req(data())
      leaflet::leaflet(data()) %>%
        leaflet::addTiles() %>%
        leaflet::setView(lng = 1.218, lat = 6.138, zoom = 12)%>%
        #addProviderTiles(providers$Esri.WorldImagery, group = "Satellite (Esri)") %>%
        leaflet:: addMarkers(
          lng = ~longitude,
          lat = ~latitude,
          popup = ~paste0("<div style='border: 2px solid #003366; border-radius: 8px; padding: 10px; background-color: #ffffff; font-family: Arial;'>",
                          "<div style='color: #1C3B1A; font-weight: bold; font-size: 16px; margin-bottom: 6px;'>Cadastre: ", Num_Cad, "</div>",
                          "<div><span style='color: #1C3B1A; font-weight: bold;'>Imp\u00f4t:</span> ",
                          "<span style='color: #388E3C;'>",
                          ifelse(Estimation_impot == 0, "Exon\u00e9ration", paste0(Estimation_impot, " FCFA")),
                          "</span></div>",
                          "<div><span style='color: #1C3B1A; font-weight: bold;'>Valeur cadastrale:</span> ",
                          "<span style='color: #388E3C;'>", Valeur_Cadastrale, "</span></div>",
                          "<div><span style='color: #003366; font-weight: bold;'>NIF:</span> ",
                          "<span style='color: #388E3C;'>", Nif, "</span></div>",
                          "<div><span style='color: #003366; font-weight: bold;'>PlusCode:</span> ",
                          "<span style='color: #388E3C;'>", AdressePlusCode, "</span></div>",
                          "</div>"),
          clusterOptions = markerClusterOptions()
        )
    })
  })
}


## To be copied in the UI
# mod_carte_ui("carte_1")

## To be copied in the server
# mod_carte_server("carte_1")
