########################################################################
#                                                                      #
#  Author :  EL Williams                                               #
#  Project:  Coursera - Building Data Visualization Tools              #
#  Date   :  2025-10-18                                                #
#                                                                      #
########################################################################

#' @title hurricane_base_map
#' @import ggplot2
#' @importFrom geosphere destPoint
#' @description hurricane_base_map uses cleaned hurricane data to get a base map for plotting hurricane data
#' @details This function uses cleaned hurricane data to calculate the total area coverage of the specified hurricane,
#' add a buffer, and create a base map for the hurricane data to be plotted on to
#' @seealso \link{clean_hurricane_data}
#'
#' @param cleaned_data Object containing the cleaned hurricane data
#' @return ggplot2 object showing map location centered on hurricane center
#' @examples
#' \dontrun{
#' baseMap <- hurricane_base_map(katrina)
#' baseMap
#' }
#' @export
#' 
hurricane_base_map <- function(cleaned_data){
  if(exists("base_plot", envir = globalenv())){rm(base_plot, envir = globalenv())}
  #cleaned data: irene
  (center <- cbind(cleaned_data$longitude, cleaned_data$latitude))
  (radius <- cleaned_data %>% dplyr::select(ne, se,  sw, nw) %>%
      mutate_all(~.*1852)) #Convert nautical knots to meters
  #
  #Empty list to fill
  hurricane_data <- list()
  ##Loop to get wind_speed and radius values for each quadrant
  for(r in 1:4){ #For each quadrant
    for(i in 1:nrow(radius)){ #For each windspeed
      hurricane_data <- geosphere::destPoint(p = center[i,], # Center of the "circle", same for all wind_speed at a single point in time 
                                             b = ((r-1)*90):(90*r),  #360 degrees divided into quadrants = 90
                                             d = radius[i,r]) %>% 
        as_tibble() %>%
        bind_rows(hurricane_data)
      #
    }
  }
  ##base plot:
  #Get boundaries of wind speed plus buffer area:
  bounds <- data.frame(
    min_lat = min(hurricane_data$lat)-0.5,
    max_lat = max(hurricane_data$lat)+0.5,
    min_lon = min(hurricane_data$lon)-0.5,
    max_lon = max(hurricane_data$lon)+0.5
  )
  #Get all states and crop to hurricane bb:
  base_plot <- ggplot2::map_data("state") %>% ggplot(aes(x = long, y = lat, group = group)) + 
    geom_polygon(fill = "#666666", color = "#333333") + 
    theme_void()+
    coord_equal(xlim = c(bounds$min_lon, bounds$max_lon), ylim = c(bounds$min_lat, bounds$max_lat)) 
  #
  return(base_plot)
}
