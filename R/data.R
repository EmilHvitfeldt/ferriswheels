#' Ferris Wheels
#'
#' A data set containing information of the ferris wheels around the world.
#'
#' @format A data frame with `r nrow(wheels)` rows and `r ncol(wheels)`
#' variables:
#'
#' \describe{
#'   \item{name}{Character, name of ferris wheel}
#'   \item{height}{Double, height if ferris wheel in ft}
#'   \item{diameter}{Double, diameter of ferris wheel in ft}
#'   \item{opened}{Date, time ferris wheel was opened. January 1st was used for
#'     wheels where only the year was posted}
#'   \item{closed}{Date, time ferris wheel was closed. January 1st was used for
#'     wheels where only the year was posted}
#'   \item{country}{Character, country of origin}
#'   \item{location}{Character, location of ferris wheel. Sometimes city or
#'     theme park}
#'   \item{number_of_cabins}{Integer, number of cabins}
#'   \item{passengers_per_cabin}{Integer, Number of passengers per cabin}
#'   \item{seating_capacity}{Integer, total number of seats}
#'   \item{hourly_capacity}{Integer, number of passergers per hour}
#'   \item{ride_duration_minutes}{Integer, ride duration in minutes}
#'   \item{climate_controlled}{Character, are cabin climate controlled? Takes
#'     values `"Yes"`, `"no"` and `NA`}
#'   \item{construction_cost}{Character, approcimate construction cost}
#'   \item{status}{Character, status of ferris wheel}
#'   \item{design_manufacturer}{Character, name of manufacturer}
#'   \item{type}{Character, type of ferris wheel. One of "`Centerless`",
#'     "`Eccentric`", "`Enclosed`", "`Fixed`", "`Portable`", and
#'     "`Transportable`"}
#'   \item{vip_area}{Character, indictor of VIP area}
#'   \item{ticket_cost_to_ride}{Character, ticket price, not cleaned}
#'   \item{official_website}{Character, URL for ferris wheel}
#'   \item{turns}{Integer, number of turns per ride}
#' }
#'
#' @source \url{https://www.observationwheeldirectory.com/}
"wheels"
