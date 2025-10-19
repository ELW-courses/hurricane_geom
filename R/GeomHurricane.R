########################################################################
#                                                                      #
#  Author :  EL Williams                                               #
#  Project:  Coursera - Building Data Visualization Tools              #
#  Date   :  2025-10-18                                                #
#                                                                      #
########################################################################

#' @title GeomHurricane
#' @import ggplot2
#' @importFrom geosphere destPoint
#' @importFrom grid polygonGrob gpar
#' @description Creates a new `Geom*` to show hurricane strength and coverage
#' @details The `Geom*` is created by calculating the center of the hurricane at the datetime provided in the data,
#' converts the radial distance covered for plotting, calculates the area covered by each wind speed portion, and
#' creates a grob for each wind speed area for each quadrant around the hurricane's center.
#'
#' @param GeomHurricane `Geom*` name created to plot hurricane data#'
#' @param required_aes a character vector of required aesthetics
#' @param default_aes default values for aesthetics including color, linewidth, group, size, linetype, color, and alpha level
#' Within this param, a value can be provided to scale the hurricane coverage area between 0 (no area) and 1 (whole area)
#' @param draw_key function used to draw the key in the legend
#' @return pie-style grpahic showing the wind speed and radius covered by the hurricane
#' @export
#' 
GeomHurricane <- ggplot2::ggproto("GeomHurricane", ggplot2::Geom,
                                  required_aes = c("x", 
                                                   "y", 
                                                   "r_ne", #northeast
                                                   "r_se", #southeast
                                                   "r_sw", #southwest
                                                   "r_nw", #northwest
                                                   "speed"), #Wind speeds
                                  default_aes = ggplot2::aes(color = "black", 
                                                             linewidth = 0.5, 
                                                             group = 1, 
                                                             size = 1,
                                                             linetype = 0, #no outline
                                                             fill = "red", #ref fill
                                                             alpha = 0.7,
                                                             scale_radii = 1.0), #Default value 
                                  draw_key = ggplot2::draw_key_polygon,
                                  #
                                  draw_group = function(data, panel_params, coord) {
                                    #Empty object to fill
                                    df_hurricane <- list()
                                    speeds <- unique(data$speed)
                                    #
                                    ##Get radii values based on center of hurricane
                                    center <- cbind(data$x, data$y)
                                    radius <- data %>% dplyr::select(r_ne, r_se, r_sw, r_nw) %>%
                                      mutate_all(~.*1852*data$scale_radii) #Convert nautical knots to meters and scale radius
                                    #
                                    ##Create mapping for colors and fills based on scales
                                    colors <- c("red", "orange", "yellow")
                                    color_map <- setNames(colors, sort(speeds))
                                    fill_map <- color_map
                                    #
                                    ##Loop to get wind_speed and radius values for each quadrant
                                    for(r in 1:4){ #For each quadrant
                                      for(i in 1:nrow(radius)){ #For each wind speed
                                        df_hurricane <- geosphere::destPoint(p = center[i,], # Center of the "circle", same for all wind_speed at a single point in time 
                                                                             b = ((r-1)*90):(90*r),  #360 degrees divided into quadrants = 90
                                                                             d = radius[i,r]) %>% 
                                          rbind(center) %>% 
                                          as_tibble() %>%
                                          dplyr::rename(x = lon, y = lat) %>% 
                                          dplyr::mutate(quadrant = r, wind_speed = as.factor(speeds[i]), 
                                                        color = color_map[i],
                                                        fill = fill_map[i],
                                                        alpha = 0.7, linewidth = 1, linetype = 1) %>%  bind_rows(df_hurricane)
                                        #
                                      }
                                    }
                                    #  
                                    #Transform data for this group
                                    df_hurricane <- coord$transform(df_hurricane, panel_params)
                                    #
                                    #Split into df for each wind speed for each quadrant
                                    split_dfs <- df_hurricane %>% dplyr::group_by(quadrant, wind_speed) %>% dplyr::group_split()
                                    # Draw each quadrant
                                    grobs <- lapply(rev(split_dfs), function(group_df) {
                                      # Draw the quadrant
                                      grid::polygonGrob(
                                        x = group_df$x,
                                        y = group_df$y,
                                        id.lengths = rep(nrow(group_df), 1),
                                        default.units = "native",
                                        gp = grid::gpar(
                                          col = group_df$color,
                                          fill = group_df$fill,
                                          lwd = group_df$linewidth * .pt,
                                          lty = group_df$linetype,
                                          alpha = group_df$alpha
                                        )
                                      )
                                    })
                                    # Combine into a single gTree
                                    grid::gTree(children = do.call(grid::gList, grobs))
                                  }
)
