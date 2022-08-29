
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ferriswheels <img src="man/figures/logo.gif" align="right" height="139" />

<!-- badges: start -->
<!-- badges: end -->

The goal of ferriswheels is to provide a fun harmless little data set to
play with

## Installation

You can install the development version of ferriswheels like so:

``` r
remotes::install_github("emilhvitfeldt/ferriswheels")
```

## Example

This data set contains a number of interesting variables yo play with.

``` r
library(ferriswheels)
str(wheels)
#> Classes 'tbl_df', 'tbl' and 'data.frame':    74 obs. of  21 variables:
#>  $ name                 : chr  "360 Pensacola Beach" "Amuran" "Asiatique Sky" "Aurora Wheel" ...
#>  $ height               : num  200 303 200 295 180 ...
#>  $ diameter             : num  NA 200 200 272 NA ...
#>  $ opened               : Date, format: "2012-07-03" "2004-01-01" ...
#>  $ closed               : Date, format: "2013-01-01" NA ...
#>  $ country              : chr  "USA" "Japan" "Tailand" "Japan" ...
#>  $ location             : chr  "Pensacola Beach; Florida" "Kagoshima; Kyushu" "Asiatique the Riverfront" "Nagashima Spa Land; Mie; Honshu" ...
#>  $ number_of_cabins     : num  42 36 42 NA 40 48 42 NA 36 48 ...
#>  $ passengers_per_cabin : num  6 NA NA NA 6 40 8 NA 8 8 ...
#>  $ seating_capacity     : num  252 NA NA NA 240 1920 336 NA 288 384 ...
#>  $ hourly_capacity      : int  1260 NA NA NA 960 5760 1550 NA 1440 1152 ...
#>  $ ride_duration_minutes: num  12 14.5 NA NA 15 20 13 15 12 20 ...
#>  $ climate_controlled   : chr  "Yes" "Yes" "Yes" NA ...
#>  $ construction_cost    : chr  "Unknown" "Unknown" "Unknown" "Unknown" ...
#>  $ status               : chr  "Moved" "Operating" "Operating" "Operating" ...
#>  $ design_manufacturer  : chr  "Realty Masters of FL" NA "Dutch Wheels (Vekoma)" NA ...
#>  $ type                 : chr  "Transportable" NA NA "Fixed" ...
#>  $ vip_area             : chr  "Yes" NA NA NA ...
#>  $ ticket_cost_to_ride  : chr  NA NA NA NA ...
#>  $ official_website     : chr  NA NA "http://www.asiatiquesky.com/" "http://www.nagashima-onsen.co.jp/" ...
#>  $ turns                : num  4 1 NA NA NA 1 1 NA 3 NA ...
```

For starters, we can look at the diameter and height, colored by the
number of cabins

``` r
library(tidyverse)

wheels |>
  ggplot(aes(height, diameter, color = number_of_cabins)) +
  geom_point() +
  scale_color_viridis_b()
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

If we look at the height of the Ferris wheels as a function of opening
date, we see that in the most recent time that the height have gotten
larger and larger.

``` r
wheels |>
  ggplot(aes(opened, height)) +
  geom_point()
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

Now image we want to get a feel for how these Ferris wheels look. We can
construct them ourselves.

``` r
library(ggforce)

# We need complete data for these calculations
complete_wheels <- wheels |>
  select(name, height, diameter, number_of_cabins) |>
  drop_na()

set.seed(1234)
selected_complete_wheels <- complete_wheels |>
  # We have limited plotting space, so we are filtering to only include the
  # ferris wheels with the best spread out carts
  slice_max(order_by = diameter / number_of_cabins, n = 6, with_ties = FALSE)

# We are creating a seperate data.frame for the position of the carts
carts <- selected_complete_wheels |>
  group_by(name) |>
  summarise(
    cart = seq_len(number_of_cabins),
    # Get x and y for the carts
    cart_x = cos(cart / number_of_cabins * 2 * pi),
    cart_y = sin(cart / number_of_cabins * 2 * pi),
    # Size them to be the right distance from the center
    cart_x = cart_x * (diameter / 2),
    cart_y = cart_y * (diameter / 2),
    # Make sure the carts are raised enough
    cart_y = cart_y + height - diameter / 2,
    # Lower the carts just a bit so it appears they are hanging
    cart_y = cart_y - 12.5,
    cart_color = as.character(cart %% 3),
    .groups = "drop"
  )

selected_complete_wheels |>
  ggplot() +
  # Grass
  geom_abline(slope = 0, intercept = 0, color = "darkgreen") +
  ylim(0, NA) +
  # Ferris wheel circle
  geom_circle(aes(x0 = 0, y0 = height - diameter / 2, r = diameter / 2)) +
  # Left leg
  geom_segment(aes(x = -(height - diameter / 2)/2, xend = 0,
                   yend = height - diameter / 2, y = 0)) +
  # right leg
  geom_segment(aes(x = (height - diameter / 2)/2, xend = 0,
                   yend = height - diameter / 2, y = 0)) +
  # Carts
  geom_point(aes(cart_x, cart_y, fill = cart_color), data = carts, shape = 24) +
  facet_wrap(~name) +
  coord_fixed() +
  theme_minimal() +
  guides(fill = "none") +
  labs(y = NULL, x = NULL)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />
