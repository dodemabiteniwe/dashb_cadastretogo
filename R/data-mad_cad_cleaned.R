#' Données cadastrales nettoyées (mad_cad_cleaned)
#'
#' Ce jeu de données contient les informations cadastrales nettoyées issues du
#' registre foncier au Togo. Il est utilisé pour alimenter l'application Shiny
#' de visualisation, d'analyse et de gestion des données foncières.
#'
#' @format Un tibble avec 8 629 lignes et 20 variables :
#' \describe{
#'   \item{id}{Identifiant unique de l’enregistrement (numérique)}
#'   \item{Source}{Origine de la demande (ex. "Première immatriculation", "Morcellement de titre existant")}
#'   \item{Num_TF}{Numéro de Titre Foncier (caractère, éventuellement manquant)}
#'   \item{Num_Req}{Numéro de la requête ou dossier de demande}
#'   \item{Num_Cad}{Numéro cadastral de la parcelle}
#'   \item{Prefecture}{Nom de la préfecture}
#'   \item{Commune}{Nom de la commune}
#'   \item{Localite}{Nom de la localité ou quartier}
#'   \item{Superficie}{Superficie de la parcelle en m²}
#'   \item{Nature}{Nature de la propriété (ex. "Villa", "Terrain nu", "Maison à étage")}
#'   \item{Affectation}{Usage ou affectation déclarée du bien (ex. "Habitation principale", "Terrain à bâtir")}
#'   \item{Valeur_Cadastrale}{Valeur cadastrale estimée en FCFA}
#'   \item{Base_impot}{Base de calcul de l’impôt en FCFA}
#'   \item{Estimation_impot}{Montant estimé de l’impôt en FCFA}
#'   \item{Date_evaluation}{Date d’évaluation du bien (au format Date)}
#'   \item{Nif}{Numéro d’identification fiscale (peut être manquant)}
#'   \item{latitude}{Latitude géographique de la parcelle}
#'   \item{longitude}{Longitude géographique de la parcelle}
#'   \item{AdressePlusCode}{Code d’adresse PlusCode (Google Open Location Code)}
#'   \item{Exoneration}{Indique si le bien est exonéré d’impôt ("Oui" ou "Non")}
#' }
#'
#' @source Registre foncier national du Togo
"mad_cad_cleaned"
