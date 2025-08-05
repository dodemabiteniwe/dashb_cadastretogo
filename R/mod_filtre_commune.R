#' filtre_commune UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList icon selectInput sliderInput selectizeInput checkboxInput conditionalPanel
#' @importFrom shinyBS bsCollapse bsCollapsePanel
mod_filtre_commune_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shinyBS::bsCollapse(
      id = ns("collapse_filtre"),
      open = ns("panel1"),  # Panel ouvert par défaut
      shinyBS::bsCollapsePanel(
        title = tagList(shiny::icon("sliders"), "Filtres disponibles"),
        value = ns("panel1"),

        # Contenu du panneau
        selectInput(ns("commune"), "Choisir une commune :", choices = NULL),
        sliderInput(ns("impot"), "Estimation imp\u00f4t :", min = 0, max = 1000000, value = c(0, 1000000)),
        selectizeInput(ns("annee"), "Ann\u00e9e(s) d\u2019\u00e9valuation :", choices = NULL, multiple = TRUE),
        checkboxInput(ns("filtre_mois"), "Filtrer aussi par mois ?", value = FALSE),
        conditionalPanel(
          condition = sprintf("input['%s'] == true", ns("filtre_mois")),
          selectInput(ns("mois"), "Mois :", choices = month.name)
        )
      )
    )
  )
}

#' filtre_commune Server Functions
#'
#' @noRd
mod_filtre_commune_server <- function(id,data){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    observe({
      df <- data()
      communes <- c("Toutes", sort(unique(df$Commune)))
      updateSelectInput(session, "commune", choices = communes)

      max_impot <- max(df$Estimation_impot, na.rm = TRUE)
      updateSliderInput(session, "impot", min = 0, max = max_impot, value = c(0, max_impot))

      annees <- sort(unique(lubridate::year(df$Date_evaluation)))
      updateSelectizeInput(session, "annee", choices = annees, selected = annees)
    })

    reactive({
      df <- data()
      if (input$commune != "Toutes") {
        df <- df[df$Commune == input$commune, ]
      }

      df <- df[df$Estimation_impot >= input$impot[1] & df$Estimation_impot <= input$impot[2], ]
      df <- df[lubridate::year(df$Date_evaluation) %in% input$annee, ]

      if (isTRUE(input$filtre_mois)) {
        mois_num <- match(input$mois, month.name)
        df <- df[lubridate::month(df$Date_evaluation) == mois_num, ]
      }

      df
    })
  })
}

## To be copied in the UI
# mod_filtre_commune_ui("filtre_commune_1")

## To be copied in the server
# mod_filtre_commune_server("filtre_commune_1")
