#' indicateurs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_indicateurs_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h3(textOutput(ns("parcel")), align = "right"),
    h4(textOutput(ns("superficieT")), align = "right"),
    h4(textOutput(ns("valeurcadastral")), align = "right"),
    h4(textOutput(ns("impot")), align = "right"),
    h4(textOutput(ns("exoprop")), align = "right")
  )
}

#' indicateurs Server Functions
#'
#' @noRd
mod_indicateurs_server <- function(id, data){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    output$parcel <- renderText({
      paste0(prettyNum(nrow(data()), big.mark=","), " parcelles")
    })

    output$superficieT <- renderText({
      superficie <- sum(data()$Superficie, na.rm = TRUE)
      paste0(prettyNum(superficie, big.mark=","), " m\u00b2 de superficie totale")
    })

    output$valeurcadastral <- renderText({
      valeur <- sum(data()$Valeur_Cadastrale, na.rm = TRUE)
      paste0(prettyNum(valeur, big.mark=","), " FCFA de V. Cad")
    })

    output$impot <- renderText({
      impot <- sum(data()$Estimation_impot, na.rm = TRUE)
      paste0(prettyNum(impot, big.mark=","), " FCFA d'imp\u00f4t estim\u00e9")
    })

    output$exoprop <- renderText({
      valeur_totale <- sum(data()$Valeur_Cadastrale, na.rm = TRUE)
      valeur_exoneree <- sum(data()$Valeur_Cadastrale[data()$Estimation_impot == 0], na.rm = TRUE)
      prop_exoneree <- ifelse(valeur_totale > 0, round(valeur_exoneree / valeur_totale * 100, 2), 0)
      paste0(prop_exoneree, "% d'exonn\u00e9ration de la V. cad.")
    })

  })
}


## To be copied in the UI
# mod_indicateurs_ui("indicateurs_1")

## To be copied in the server
# mod_indicateurs_server("indicateurs_1")
