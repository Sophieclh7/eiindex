#' A-level Attainment Data by Parliamentary Constituency
#'
#' This dataset includes average A-level grades by parliamentary constituency,
#'
#' @format A data frame with one row per parliamentary constituency:
#' \describe{
#'   \item{pcon_code}{Parliamentary constituency code}
#'   \item{average_a_level_grade}{Numeric average A-level grade for academic year 2022/23, except for Warrington North (E14001017) and Worthing West (E14001055) which use data from 2023/24}
#' }
#' @source [UK Government Explore Education Statistics](https://explore-education-statistics.service.gov.uk/find-statistics/a-level-and-other-16-to-18-results/2023-24)
#' \describe{ Dataset: `aggregated_attainment_by_pcon_202024.csv`}
"a_levels"

#' GCSE Attainment Data by Parliamentary Constituency
#'
#' This dataset includes average GCSE attainment 8 score by parliamentary constituency
#'
#' @format A data frame with one row per parliamentary constituency:
#' \describe{
#'   \item{pcon_code}{Parliamentary constituency code}
#'   \item{average_gcse_grade}{Average GCSE attainment 8 score for academic year 2022/23}
#' }
#' @source [UK Government Explore Education Statistics](https://explore-education-statistics.service.gov.uk/find-statistics/key-stage-4-performance/2022-23)  
#' \describe{Dataset: 2223_sl_pcon_data_revised.csv}
"gcses"

#' KS2 Attainment Data by Parliamentary Constituency
#'
#' This dataset includes KS2 attainment by parliamentary constituency
#'
#' @format A data frame with one row per parliamentary constituency:
#' \describe{
#'   \item{pcon_code}{Parliamentary constituency code}
#'   \item{ks2_percent_meeting_standard}{Percent KS2 students meeting expected standard in reading, writing and maths for academic year 2022/23}
#' }
#' @source [UK Government Explore Education Statistics](https://explore-education-statistics.service.gov.uk/find-statistics/key-stage-2-attainment/2022-23) 
#' \describe{Dataset: ks2_parliamentary_constituency_2019_to_2023_revised.csv}
"ks2"

#' Progression to higher education/apprenticeships by Parliamentary Constituency
#'
#' This dataset includes the percent of students who progress to higher education/apprenticeships by parliamentary constituency
#'
#' @format A data frame with one row per parliamentary constituency:
#' \describe{
#'   \item{pcon_code}{Parliamentary constituency code}
#'   \item{percent_progressed}{Percent students who progressed to a Level 4 or higher destination post school, which is equivalent to Bachelor's degree or Level 4 apprenticeship, for academic cohort from 2020/21}
#' }
#' @source [UK Government Explore Education Statistics](https://explore-education-statistics.service.gov.uk/data-catalogue/data-set/8536ca17-09fc-4d90-960e-03c85432c296)  
#' \describe{Dataset: l4_tidy_2023_all_la_final.csv}
"progression"

#' Pupil funding by Parliamentary Constituency
#'
#' This dataset includes real values for funding per pupil by parliamentary constituency
#'
#' @format A data frame with one row per parliamentary constituency:
#' \describe{
#'   \item{pcon_code}{Parliamentary constituency code}
#'   \item{funding_per_pupil}{Per pupil funding in real terms (not cash terms) for academic year from 2022/23}
#' }
#' @source [UK Parliament House of Commons Library](https://commonslibrary.parliament.uk/research-briefings/cbp-10036/)  
#' \describe{Dataset: Schoolfunding.xlsx (Downloaded from 'school funding' link on page)}
"funding"

#' Pupil to teacher ratio by Parliamentary Constituency
#'
#' This dataset includes pupil to teacher ratio by parliamentary constituency
#'
#' @format A data frame with one row per parliamentary constituency:
#' \describe{
#'   \item{pcon_code}{Parliamentary constituency code}
#'   \item{pupil_to_qual_teacher_ratio}{Pupil to qualified teacher ratio for academic year 2022/23}
#' }
#' @source [UK Government Explore Education Statistics](https://explore-education-statistics.service.gov.uk/data-catalogue/data-set/997087c9-5b1c-4635-b412-83b4bb0130a6)  
#' \describe{Dataset: workforce_ptrs_2010_2023_pcon.csv)}
"pt_ratio"

#' Free school meal eligibility by Parliamentary Constituency
#'
#' This dataset includes the percentage of pupils eligible for free school meals by parliamentary constituency
#'
#' @format A data frame with one row per parliamentary constituency:
#' \describe{
#'   \item{pcon_code}{Parliamentary constituency code}
#'   \item{weighted_percent_fsm}{Weighted percentage of pupils eligible for free school meals, calculated by dividing total number of eligible pupils for the constituency by total number of pupils in the constituency, for academic year 2022/23}
#' }
#' @source [UK Government Explore Education Statistics](https://explore-education-statistics.service.gov.uk/find-statistics/school-pupils-and-their-characteristics/2023-24)  
#' \describe{Dataset: spc_school_level_underlying_data.csv)}
"fsm"

#' Percentage of academy students by Parliamentary Constituency
#'
#' This dataset includes the percentage of academy students by parliamentary constituency
#'
#' @format A data frame with one row per parliamentary constituency:
#' \describe{
#'   \item{pcon_code}{Parliamentary constituency code}
#'   \item{weighted_percent_fsm}{Weighted percentage of pupils who attend academies, calculated by dividing total number of academy pupils for the constituency by total number of pupils in the constituency, for academic year 2022/23}
#' }
#' @source [UK Government Explore Education Statistics](https://explore-education-statistics.service.gov.uk/find-statistics/school-pupils-and-their-characteristics/2023-24)  
#' \describe{Dataset: spc_school_level_underlying_data.csv)}
"academies"

#' Percentage of private school students by Parliamentary Constituency
#'
#' This dataset includes the percentage of private school students by parliamentary constituency
#'
#' @format A data frame with one row per parliamentary constituency:
#' \describe{
#'   \item{pcon_code}{Parliamentary constituency code}
#'   \item{weighted_percent_private}{Weighted percentage of pupils who attend private schools, calculated by dividing total number of private school pupils for the constituency by total number of pupils in the constituency, for academic year 2022/23}
#' }
#' @source [UK Government Explore Education Statistics](https://explore-education-statistics.service.gov.uk/find-statistics/school-pupils-and-their-characteristics/2023-24)  
#' \describe{Dataset: spc_school_level_underlying_data.csv)}
"private"

#' Joined indicator datasets
#'
#' This dataset includes the joined columns for all indicator datasets
"ei_data"

#' Standardised data
#'
#' This dataset includes the data for all indicators after applying log transformations to funding and percentage of private school students, ensuring consistent directionality by multiplying pupil teacher ratio and percent elligible for free school meals by -1, then standardising using z scores
"ei_data_standardised"

#' Educational inequality index complete case data
#'
#' This dataset includes the educational inequality index scores for all indicators, domains and subdomains for constituencies with no missing data, as well as constituency codes and names, and local authority codes and names
'ei_index_complete_case'

#' Educational inequality index missing data
#'
#' This dataset includes the educational inequality index scores for all indicators, domains and subdomains for constituencies with missing data, as well as constituency codes and names (which have been marked with asterisks), and local authority codes and names. Scores were created by imputing the mean for missing values.
'ei_index_na'

#' Educational inequality index
#'
#' This dataset includes the educational inequality index scores for all indicators, domains and subdomains for all constituencies, as well as constituency codes and names, and local authority codes and names. Constituencies where missing data was imputed with the mean are marked with asterisks, and constituencies where missing data was imputed with the following year's values are marked with the (^) symbol
'ei_index'

#' Educational inequality index deciles
#'
#' This dataset includes which deciles constituencies fall under for the domain and subdomain scores
'ei_index_deciles'

#' Constituency to local authority lookup file
#'
#' This dataset includes constituency names and codes with their corresponding local authority names and codes
#' @source [Office for National Statistics](https://geoportal.statistics.gov.uk/search?collection=Dataset&q=Parliamentary%20Constituency%20to%20Local%20Authority%20District%20Lookup)  
#' \describe{Dataset: Ward_to_PCON_to_LAD_to_UTLA_(December_2023)_Lookup_in_the_UK.csv)}
'ei_la_lookup'