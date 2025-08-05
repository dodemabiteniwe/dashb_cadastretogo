#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    bootstrapPage(
      navbarPage(
        theme = shinythemes::shinytheme("cerulean"), collapsible = TRUE,
        HTML('<a style="text-decoration:none;cursor:default;color:#FFFFFF;" class="active" href="#">Dashboard Cadastre \u2013 OTR Togo</a>'), id = "nav",
        windowTitle = "Dashboard Cadastre \u2013 OTR Togo",

        tabPanel("Carte",
                 div(class = "outer",
                     tags$head(includeCSS(app_sys("app/www/styles.css"))),
                     leaflet::leafletOutput("carte1-carte", width = "100%", height = "100%"),
                     absolutePanel(
                       id = "controls", class = "panel panel-default",
                       top = 75, left = 55, width = 350, fixed = TRUE,
                       draggable = TRUE, height = "auto",

                       span(tags$i(h6("Les donn\u00e9es dans cette application sont \u00e0 jour au 30 juin 2025 et concerne que les \u00e9valuations Grand Lom\u00e9 de 2025 pour l'instant. ")), style = "color:#045a8d"),
                       mod_indicateurs_ui("carte1"),
                       mod_filtre_commune_ui("filtre1")
                     )
                 )
        ),

        tabPanel("Donn\u00e9es",
                 sidebarLayout(
                   sidebarPanel(
                     mod_filtre_commune_ui("filtre2"),
                     downloadButton("tableau1-telecharger", "T\u00e9l\u00e9charger donn\u00e9es XLSX")
                   ),
                   mainPanel(
                     DT::DTOutput("tableau1-table", width = "100%")
                   )
                 )
        ),

        tabPanel("Graphiques",
                 sidebarLayout(
                   sidebarPanel(
                     mod_filtre_commune_ui("filtre3"),
                     plotOutput("graph1-plot_donut_pref", width = "100%")
                   ),
                   mainPanel(
                     tabsetPanel(
                       tabPanel("Imp\u00f4ts estim\u00e9",
                                plotly::plotlyOutput("graph1-boxplot", width = "100%"),
                                plotly::plotlyOutput("graph1-jitter", width = "100%")
                       ),
                       tabPanel("Imp\u00f4ts/commune et r\u00e9sum\u00e9 par localit\u00e9",
                                plotly::plotlyOutput("graph1-barres_commune"),
                                h4("R\u00e9sum\u00e9 par quartier (localit\u00e9)"),
                                span(tags$i(h6("La valeur cadastrale (V.C) est en millions de FCFA et l'imp\u00f4t estim\u00e9 (Imp\u00f4t E.) en milliers de FCFA")), style = "color:#045a8d"),
                                reactable::reactableOutput("graph1-table_quartiers", width = "100%")
                       ),
                       tabPanel("Valeur Cadastrale/affectation",
                                plotly::plotlyOutput("graph1-barres_affectation", width = "100%")
                       ),
                       tabPanel("Imp\u00f4ts/Type imeuble",
                                plotly::plotlyOutput("graph1-density", width = "100%"),
                                plotly::plotlyOutput("graph1-cumul", width = "100%")
                       )
                     )
                   )
                 )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1"),
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "AppShinyCadastreTogo"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
