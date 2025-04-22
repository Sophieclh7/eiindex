#' A-level Attainment Data by Parliamentary Constituency
#'
#' This dataset includes average A-level grades by parliamentary constituency,
#' based on cleaned and imputed Department for Education data.
#'
#' @format A data frame with one row per parliamentary constituency:
#' \describe{
#'   \item{pcon_code}{Parliamentary constituency code}
#'   \item{average_a_level_grade}{Numeric A-level grade score (1–10)}
#' }
#' @source Aggregated from raw data in \code{aggregated_attainment_by_pcon_202024.csv}
"a_levels"