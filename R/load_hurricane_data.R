########################################################################
#                                                                      #
#  Author :  EL Williams                                               #
#  Project:  Coursera - Building Data Visualization Tools              #
#  Date   :  2025-10-18                                                #
#                                                                      #
########################################################################

#' @title load_hurricane_data
#' @import readr 
#' @description load_hurricane_data loads hurricane data from a fixed width file
#' @details This function establishes column widths and column names, checks for the specified txt file using the file name provided, and loads the data.
#'  If the file does not exist, an error is returned stating that the file does not exist. 
#'
#' @param file_name The full file path to the txt file containing the hurricane data.
#' @return tibble object containing the data
#' @examples
#' \dontrun{
#' data <- load_hurricane_data("accident_2013.csv.bz2")
#' head(data)
#' }
#' @export
#' 
load_hurricane_data <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  #Else:
  ext_tracks_widths <- c(7, 10, 2, 2, 3, 5, 5, 6, 4, 5, 4, 4, 5, 3, 4, 3, 3, 3, 4, 3, 3, 3, 4, 3, 3, 3, 2, 6, 1)
  ext_tracks_colnames <- c("storm_id", "storm_name", "month", "day", "hour", "year", "latitude", "longitude",
                           "max_wind", "min_pressure", "rad_max_wind", "eye_diameter", "pressure_1", "pressure_2",
                           paste("radius_34", c("ne", "se", "sw", "nw"), sep = "_"),
                           paste("radius_50", c("ne", "se", "sw", "nw"), sep = "_"),
                           paste("radius_64", c("ne", "se", "sw", "nw"), sep = "_"),
                           "storm_type", "distance_to_land", "final")
  ext_tracks <- readr::read_fwf(file_name, 
                                readr::fwf_widths(ext_tracks_widths, ext_tracks_colnames),
                                na = "-99")
}
