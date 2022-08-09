## code to prepare `wheels` dataset goes here

library(tidyverse)
library(rvest)

wheels_urls <- read_html("https://www.observationwheeldirectory.com/wheels/") |>
  html_element("table") |>
  html_elements("a") |>
  html_attr("href")

extract_table <- function(x) {
  read_html(x) |>
    html_element("table") |>
    html_table()
}

all_tables <- map(wheels_urls, extract_table)

format_table <- function(x) {
  x <- x[, 1:2]
  x |>
    set_names(c("variable", "value")) |>
    mutate(name = names(x)[2])
}

all_tables_clean <- map_dfr(all_tables, format_table)

wheels <- all_tables_clean |>
  pivot_wider(names_from = variable, values_from = value)

wheels <- wheels |>
  janitor::clean_names() |>
  mutate(across(contains("turns"), as.integer)) |>
  mutate(turns = rowSums(cbind(turns, number_of_turns_rotations_per_ride,
           average_number_of_turns_rotations_per_ride), na.rm = TRUE)) |>
  mutate(turns = ifelse(turns == 0, NA, turns)) |>
  select(-number_of_turns_rotations_per_ride,
         -average_number_of_turns_rotations_per_ride) |>
  mutate(across(c(number_of_cabins, passengers_per_cabin,
                  seating_capacity, hourly_capacity, ride_duration_minutes),
                as.integer)) |>
  mutate(across(where(is.character), ~if_else(.x == "", NA_character_, .x)))

ft_calc <- function(x) {
  x |>
    str_extract("[\\d\\.]+ft") |>
    str_remove("ft") |>
    as.numeric()
}

date_calc <- function(x) {
  case_when(
    str_detect(x, "\\d+/\\d+/\\d+") ~ lubridate::mdy(x),
    str_detect(x, "\\d{4}") ~ lubridate::mdy(paste0("1/1/", x)),
    TRUE ~ lubridate::NA_Date_
  )
}

wheels <- wheels |>
  mutate(across(c(height, diameter), ft_calc)) |>
  mutate(across(c(opened, closed), date_calc))

wheels <- wheels |>
  mutate(ride_duration_minutes = rowSums(cbind(
    ride_duration_minutes,
    as.numeric(str_extract(ride_duration, "[\\d\\.]+"))
  ), na.rm = TRUE)) |>
  mutate(ride_duration_minutes = ifelse(ride_duration_minutes == 0, NA, ride_duration_minutes)) %>%
  select(-ride_duration)

# https://en.wikipedia.org/wiki/Capital_Wheel
wheels <- wheels |>
  add_row(
    name = "Capital Wheel",
    height = 175,
    diameter = 165,
    opened = lubridate::ymd("2014-05-23"),
    closed = NA,
    country = "USA",
    location = "National Harbor, Maryland",
    number_of_cabins = 42,
    passengers_per_cabin = 8,
    seating_capacity = 42 * 8,
    hourly_capacity = NA,
    ride_duration_minutes = 15,
    climate_controlled = "sometimes",
    construction_cost = NA,
    status = "Operating",
    design_manufacturer = "CWA Construction",
    type = NA,
    vip_area = "Yes",
    ticket_cost_to_ride = "$15 for adults, $13.50 for seniors, and $11.25 for children",
    official_website = "https://thecapitalwheel.com/",
    turns = NA
  )

usethis::use_data(wheels, overwrite = TRUE)
