
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

<!-- badges: end -->

# Installation

You can install the development version of hurricanegeom with:

``` r
library(devtools)
install.packages("ELW-courses/hurricanegeom")
#> Warning in install.packages :
#>   package 'hurricanegeom' is in use and will not be installed
```

# Creating a new geom

> This is a deliverable of the *Building Data Visualization Tools*
> course, the 4th course of the *Mastering Software Development in R*
> sepecialization offered by the Johns Hopkins University.

Within this repo are the files used to create a new `geom_*` used by the
`ggplot2` package to visualize the wind speeds associated with
hurricanes. Functions are included for reading, cleaning, and outputting
hurricane data based on user specified hurricane name and datetime
point. Examples are provided for hurricane Katrina and hurricane Ike.

## Hurricane Katrina

Hurricane Katrina was an Atlantic hurricane made landfall in
Buras-Triumph, Louisiana on August 29, 2005 at approximately 6:10 am CDT
as a category 3 storm.

### Data setup and cleaning

Load the hurricane data and examine for the hurricane name and time
point of interest.

``` r
raw_data <- load_hurricane_data(file = "ebtrk_atlc_1988_2015.txt")
#> Rows: 11824 Columns: 29
#> ── Column specification ─────────────────────────────────────────────────────────────────────────────────────────────────
#> 
#> chr  (7): storm_id, storm_name, month, day, hour, storm_type, final
#> dbl (22): year, latitude, longitude, max_wind, min_pressure, rad_max_wind, eye_diameter, pressure_1, pressure_2, radi...
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
head(raw_data)
#> # A tibble: 6 × 29
#>   storm_id storm_name month day   hour   year latitude longitude max_wind min_pressure rad_max_wind eye_diameter
#>   <chr>    <chr>      <chr> <chr> <chr> <dbl>    <dbl>     <dbl>    <dbl>        <dbl>        <dbl>        <dbl>
#> 1 AL0188   ALBERTO    08    05    18     1988     32        77.5       20         1015           NA           NA
#> 2 AL0188   ALBERTO    08    06    00     1988     32.8      76.2       20         1014           NA           NA
#> 3 AL0188   ALBERTO    08    06    06     1988     34        75.2       20         1013           NA           NA
#> 4 AL0188   ALBERTO    08    06    12     1988     35.2      74.6       25         1012           NA           NA
#> 5 AL0188   ALBERTO    08    06    18     1988     37        73.5       25         1011           NA           NA
#> 6 AL0188   ALBERTO    08    07    00     1988     38.7      72.4       25         1009           NA           NA
#> # ℹ 17 more variables: pressure_1 <dbl>, pressure_2 <dbl>, radius_34_ne <dbl>, radius_34_se <dbl>, radius_34_sw <dbl>,
#> #   radius_34_nw <dbl>, radius_50_ne <dbl>, radius_50_se <dbl>, radius_50_sw <dbl>, radius_50_nw <dbl>,
#> #   radius_64_ne <dbl>, radius_64_se <dbl>, radius_64_sw <dbl>, radius_64_nw <dbl>, storm_type <chr>,
#> #   distance_to_land <dbl>, final <chr>
```

Select the data for hurricane Katrina at 12:00 on August 27, 2011.

``` r
katrina <- clean_hurricane_data(raw_data, "Katrina", "2005-08-29-12-00")
head(katrina)
#> # A tibble: 3 × 10
#>   storm_id     storm_name date                latitude longitude wind_speed    ne    se    sw    nw
#>   <chr>        <chr>      <dttm>                 <dbl>     <dbl> <chr>      <dbl> <dbl> <dbl> <dbl>
#> 1 KATRINA-2005 KATRINA    2005-08-29 12:00:00     29.5     -89.6 34           200   200   150   100
#> 2 KATRINA-2005 KATRINA    2005-08-29 12:00:00     29.5     -89.6 50           120   120    75    75
#> 3 KATRINA-2005 KATRINA    2005-08-29 12:00:00     29.5     -89.6 64            90    90    60    60
```

### geom_hurricane figure

Use the cleaned data to create the base map on which to plot the
hurricane data, then plot the hurricane data using geom_hurricane.

``` r
hurricane_base_map(katrina) +
  geom_hurricane(data = katrina, aes(x = longitude, y = latitude, r_ne = ne, r_se = se, r_nw = nw, r_sw =sw, 
                                   speed = wind_speed, fill = wind_speed), group = 1)+
  scale_fill_manual(name = "Wind speed (kts)", values = c("red", "orange", "yellow"))
```

<img src="man/figures/README-katrina map-1.png" width="100%" />

The plot can be modified to show a percentage of maximum wind radii by
specifying the scale_radii parameter.

``` r
hurricane_base_map(katrina) +
  geom_hurricane(data = katrina, aes(x = longitude, y = latitude, r_ne = ne, r_se = se, r_nw = nw, r_sw =sw, 
                                   speed = wind_speed, fill = wind_speed), scale_radii = 0.5, group = 1)+
  scale_fill_manual(name = "Wind speed (kts)", values = c("red", "orange", "yellow"))
```

<img src="man/figures/README-katrina scale map-1.png" width="100%" />

## Hurricane Ike

Hurricane Ike was an Atlantic hurricane that made landfall first in Cuba
then in Galveston, Texas on September 13, 2008 at approximately 2:10 am
CDT as a category 2 storm.

Select the data for hurricane Ike at 12:00 on September 13, 2008 and
plot resulting data.

### Data cleaning

``` r
ike <- clean_hurricane_data(raw_data, "ike", "2008-09-13-12-00")
head(ike)
#> # A tibble: 3 × 10
#>   storm_id storm_name date                latitude longitude wind_speed    ne    se    sw    nw
#>   <chr>    <chr>      <dttm>                 <dbl>     <dbl> <chr>      <dbl> <dbl> <dbl> <dbl>
#> 1 IKE-2008 IKE        2008-09-13 12:00:00     30.3     -95.2 34           125   180   125    60
#> 2 IKE-2008 IKE        2008-09-13 12:00:00     30.3     -95.2 50            75    90    60    45
#> 3 IKE-2008 IKE        2008-09-13 12:00:00     30.3     -95.2 64            50    45    30    20
```

### geom_hurricane figure

``` r
hurricane_base_map(ike) +
  geom_hurricane(data = ike, aes(x = longitude, y = latitude, r_ne = ne, r_se = se, r_nw = nw, r_sw =sw, 
                                   speed = wind_speed, fill = wind_speed), group = 1)+
  scale_fill_manual(name = "Wind speed (kts)", values = c("red", "orange", "yellow"))
```

<img src="man/figures/README-ike map-1.png" width="100%" />
