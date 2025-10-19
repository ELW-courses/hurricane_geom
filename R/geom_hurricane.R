########################################################################
#                                                                      #
#  Author :  EL Williams                                               #
#  Project:  Coursera - Building Data Visualization Tools              #
#  Date   :  2025-10-18                                                #
#                                                                      #
########################################################################

#' @title geom_hurricane
#' @import ggplot2 
#' @description geom_hurricane plots the wind radius and speed of a selected hurricane and datetime
#' @details The graphic is a pie-style plot showing the radius and speed of winds from hurricane data using the 
#' ggplot interface.
#'
#' @param mapping 
#' @param data data to be used
#' @param stat stat objected with default "identity"
#' @param postion position object with default "identity"
#' @param na.rm handling of NA values, removal default to FALSE
#' @param show.legend option to show or hide the legend with default set to FALSE
#' @param inherit.aes option to inherit aesthetics specified
#' @return a layer containing a `Geom*` object responsible for rendering the pie-style graphic
#' @examples
#' \dontrun{
#' ggplot() +
#'   geom_hurricane(aes(x = longitude, y = latitude, r_ne = ne, r_se = se, r_nw = nw, r_sw =sw, 
#'   speed = wind_speed, fill = wind_speed), group = 1))
#' }
#' @export
#' 
geom_hurricane <- function(mapping = NULL,
                           data = NULL,
                           stat = "identity",
                           position = "identity",
                           na.rm = FALSE,
                           show.legend = FALSE,
                           inherit.aes = TRUE, ...){
  ggplot2::layer(geom = GeomHurricane,
                 mapping = mapping,
                 data = data,
                 stat = stat,
                 position = position,
                 show.legend = show.legend,
                 inherit.aes = inherit.aes,
                 params = list(na.rm = na.rm , ...))
}
