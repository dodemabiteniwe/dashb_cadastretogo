#' quar_table
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
quar_table <- function(df) {
  tableau <- df %>%
    group_by(Localite, Nature) %>%
    summarise(
      Valeur_Cadastrale = sum(Valeur_Cadastrale, na.rm = TRUE),
      Estimation_Impot = sum(Estimation_impot, na.rm = TRUE),
      Nb_Immeubles = n(),
      .groups = "drop"
    ) %>%
    group_by(Localite) %>%
    mutate(
      Total_Impot = sum(Estimation_Impot),
      Total_Valeur = sum(Valeur_Cadastrale)
    ) %>%
    ungroup() %>%
    mutate(
      Total_Impot_k = round(Total_Impot / 1000),
      Total_Valeur_M = round(Total_Valeur / 1e6),
      Pourcent_Impot = round(100 * Total_Impot / Total_Valeur, 2)
    ) %>%
    select(Localite, Nature, Nb_Immeubles, Total_Impot_k, Total_Valeur_M) %>%
    tidyr::pivot_wider(names_from = Nature, values_from = Nb_Immeubles, values_fill = 0)

  natures_cols <- setdiff(colnames(tableau), c("Localite", "Total_Impot_k", "Total_Valeur_M"))
  pal_scale <- c("#F4FFFD", "#E9DAEC","#A295E9", "#A270E5", "#43009A")

  reactable(
    tableau,
    theme = reactableTheme(
      style = list(fontFamily = "sans-serif"),
      borderColor = "#DADADA"
    ),
    defaultColDef = colDef(
      vAlign = "center",
      align = "center",
      headerVAlign = "center",
      style = color_scales(tableau, span = 4:8, colors = pal_scale),
      headerStyle = list(fontFamily = "sans-serif")
    ),
    defaultSorted = list(Total_Impot_k = "desc"),
    columnGroups = list(
      colGroup(name = "", columns = c("Localite", "Total_Impot_k", "Total_Valeur_M")),
      colGroup(name = "Nature des immeubles", columns = natures_cols)
    ),
    columns = list(
      Localite = colDef(name = "Quartier", minWidth = 150),
      Total_Valeur_M = colDef(name = "V.C", align = "right",
                              cell = data_bars(tableau, fill_color = "#4575b4", text_position = "outside-end")),
      Total_Impot_k = colDef(name = "Imp\u00f4t E.", align = "right",
                             cell = data_bars(tableau, fill_color = "#d73027", text_position = "outside-end"))
    ),
    compact = TRUE,
    searchable = TRUE,
    sortable = TRUE,
    pagination = TRUE,
    wrap = FALSE
  )
}
