#' graphs
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
get_bounds <- function(x) {
  Q1 <- quantile(x, 0.25, na.rm = TRUE)
  Q3 <- quantile(x, 0.75, na.rm = TRUE)
  IQR <- Q3 - Q1
  list(inf = Q1 - 1.5 * IQR, sup = Q3 + 1.5 * IQR)
}

graph_boxplot <- function(df, borne_inf, borne_sup) {
  df_filtre <- df %>% filter(Estimation_impot >= borne_inf, Estimation_impot <= borne_sup)
  ordre <- df_filtre %>% group_by(Nature) %>% summarise(med = median(Estimation_impot)) %>% arrange(med) %>% pull(Nature)
  df_filtre <- df_filtre %>% mutate(Nature = factor(Nature, levels = ordre))
  counts <- df_filtre %>% group_by(Nature) %>% summarise(n = n(), y_pos = max(Estimation_impot)*1.05)
  ggplot(df_filtre, aes(x = Nature, y = Estimation_impot, fill = Nature)) +
    geom_boxplot(outlier.shape = NA) +
    geom_text(data = counts, aes(x = Nature, y = y_pos, label = paste0("n = ", n)), inherit.aes = FALSE, size = 3) +
    scale_fill_brewer(palette = "Set2") +
    theme_minimal() + labs(title = "Valeurs normales par nature de l'immeuble") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "none")
}

graph_jitter <- function(df, borne_inf, borne_sup) {
  df_ext <- df %>% filter(Estimation_impot < borne_inf | Estimation_impot > borne_sup)
  ggplot2::ggplot(df_ext, aes(x = Nature, y = Estimation_impot, color = Nature)) +
    geom_jitter(width = 0.2, alpha = 0.7) +
    scale_color_brewer(palette = "Set1") +
    theme_minimal() + labs(title = "Valeurs extr\u00eames par nature de l'immeuble") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "none")
}

graph_commune_bar <- function(df) {
  df %>%
    group_by(Commune) %>%
    summarise(Impot_total = sum(Estimation_impot, na.rm = TRUE)) %>%
    ggplot(aes(x = reorder(Commune, Impot_total), y = Impot_total)) +
    geom_bar(stat = "identity", fill = "darkgreen") +
    coord_flip() +
    labs(title = "Total imp\u00f4t par commune", x = "Commune", y = "Total imp\u00f4t") +
    theme_minimal()
}

#graph_commune_table <- function(df) {
#  df %>%
#    dplyr::count(Commune, Quartier) %>%
#    reactable::reactable()
#}

graph_affectation_bar <- function(df) {
  df %>%
    group_by(Affectation) %>%
    summarise(Valeur_totale = sum(Valeur_Cadastrale, na.rm = TRUE)) %>%
    ggplot(aes(x = reorder(Affectation, Valeur_totale), y = Valeur_totale)) +
    geom_col(fill = "orange") +
    coord_flip() +
    labs(title = "Valeur cadastrale par affectation", x = "Affectation", y = "Valeur") +
    theme_minimal()
}

graph_donut_pref <- function(df) {
  df_2<-df%>%
    group_by(Prefecture) %>%
    summarise(Nb = n(), .groups = "drop") %>%
    mutate(Pourcent = round(Nb / sum(Nb) * 100, 1),
           label = paste0(Prefecture, ": ", Pourcent, "%"),
           ymax = cumsum(Pourcent),
           ymin = c(0, head(ymax, n=-1)),
           labelPosition =  (ymax + ymin) / 2)

  ggplot(df_2, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill = Prefecture)) +
    geom_rect()+
    geom_label( x=3.5, aes(y=labelPosition, label=label), size=6) +
    scale_fill_brewer(palette=4) +
    coord_polar(theta="y") +
    xlim(c(2, 4)) +
    theme_void()+ theme(legend.position = "none") +
    labs(title = "R\u00e9partition des parcelles par pr\u00e9fecture")
}

graph_density <- function(df, borne_inf, borne_sup) {
  df_density <- df %>%
    mutate(Type_Bien = ifelse(Nature == "Terrain nu", "Terrain nu", "Terrain construit")) %>%
    filter(Estimation_impot >= borne_inf, Estimation_impot <= borne_sup)
  plotly::ggplotly(
    ggplot2::ggplot(df_density, aes(x = Estimation_impot, fill = Type_Bien)) +
      geom_density(alpha = 0.5) +
      scale_fill_manual(values = c("Terrain nu" = "#66c2a5", "Terrain construit" = "#fc8d62")) +
      theme_minimal() + labs(title = "Densit\u00e9 - Terrain nu vs Terrain construit")
  )
}

graph_cumul <- function(df, borne_inf, borne_sup) {
  df_labeled <- df %>%
    mutate(Groupe = ifelse(Estimation_impot > borne_sup | Estimation_impot < borne_inf, "Valeurs extr\u00eames", "Valeurs normales"))
  parts <- df_labeled %>%
    group_by(Groupe) %>% summarise(Total_impot = sum(Estimation_impot), Nb_parcelles = n(), .groups = "drop") %>%
    mutate(Pourcentage = 100 * Total_impot / sum(Total_impot), Etiquette = paste0(round(Pourcentage, 1), "%\n(n = ", Nb_parcelles, ")"))
  ggplot(parts, aes(x = Groupe, y = Pourcentage, fill = Groupe)) +
    geom_bar(stat = "identity", width = 0.6) +
    geom_text(aes(label = Etiquette), vjust = -0.1) +
    scale_fill_manual(values = c("Valeurs extr\u00eames" = "#E41A1C", "Valeurs normales" = "#377EB8")) +
    ylim(0, 100) + theme_minimal() + labs(title = "Part de l'imp\u00f4t total") +
    theme(legend.position = "none")
}

#' @importFrom dplyr mutate filter select arrange summarise group_by ungroup pull count summarise_all
#' @importFrom magrittr %>%
#' @importFrom ggplot2 aes geom_bar geom_boxplot geom_col geom_density geom_jitter geom_label geom_rect geom_text ggplot labs scale_fill_brewer scale_fill_manual scale_color_brewer theme theme_minimal theme_void coord_flip coord_polar xlim ylim element_text
#' @importFrom stats quantile median reorder
#' @importFrom tidyr pivot_wider
#' @importFrom reactable reactable reactableTheme colDef colGroup
#' @importFrom reactablefmtr data_bars color_scales
#' @importFrom plotly ggplotly
#' @importFrom leaflet leaflet addTiles addMarkers markerClusterOptions leafletOutput renderLeaflet addCircleMarkers
#' @importFrom dplyr n
#' @importFrom utils head
NULL


