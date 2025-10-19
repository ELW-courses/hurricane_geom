########################################################################
#                                                                      #
#  Author :  EL Williams                                               #
#  Project:  Coursera - Building Data Visualization Tools              #
#  Date   :  2025-10-18                                                #
#                                                                      #
########################################################################

#' @title clean_hurricane_data
#' @import readr dplyr
#' @importFrom lubridate make_datetime
#' @description clean_hurricane_data cleans the data provided to specific hurricane name and datetime 
#' @details This function takes the data provided and cleans the data by creating a storm_id column, converting 
#' longitude data, and ensuring dates are in the proper format. The data is then modified to gather wind 
#' speed and distance of coverage before filtering by the provided hurricane name and datetime of interest
#'
#' @param hurricane_data The object containing the hurricane data 
#' 
#' @param hurricane_name The name of the hurricane of interest
#' 
#' @param location_date The date and time point of interest, provided in the format "YYYY-mm-dd-hh-mm"
#' 
#' @seealso \link{validate_datetime}
#' @return tibble object containing the filtered and cleaned data
#' @examples
#' \dontrun{
#' katrina <- clean_hurricane_track(ext_tracks, "Katrina", "2005-08-29-12-00")
#' head(katrina)
#' }
#' @export
#' 
clean_hurricane_track <- function(hurricane_data, hurricane_name, location_date){
  #Check datetime format
  if(validate_datetime(location_date) == FALSE){
    stop("location_date incorrectly specfied. Should be in the format YYYY-mm-dd-hh-mm")
  }
  #Clean and filter data
  track <- hurricane_data %>% 
    #Update storm_id, longitude columns, create date column
    dplyr::mutate(storm_id = paste(storm_name, year, sep = "-"),
                  longitude = longitude*-1, 
                  date = lubridate::make_datetime(year, as.integer(month), as.integer(day), as.integer(hour))) %>%
    #Limit data frame columns
    dplyr::select(storm_id,  storm_name, date, latitude, longitude, contains("radius")) %>%
    #Pivot data to long format 
    tidyr::pivot_longer(cols = starts_with("radius"), names_to = "wind_speed",  names_prefix = "radius_") %>%
    tidyr::separate_wider_delim(wind_speed, "_", names = c("wind_speed", "position")) %>%
    tidyr::pivot_wider(names_from = position, values_from = value) %>% 
    #Subset to hurricane name and date ("YYYY-mm-dd-hh-mm")
    subset(storm_name == toupper(hurricane_name) & date == lubridate::ymd_hm(location_date))
  return(track)
}
#' 
#' 
#' 
#' 
#' 
#' 
#' @title validate_datetime
#' @description checks string for proper datetime format
#' @details This function checks the provided string for datetime format YYYY-mm-dd-hh-mm
#' 
#' @param text The string of text to be checked
#' @return TRUE or FALSE if the text matches the desrired format
#' @examples
#' \dontrun{
#' validate_datetime("2005-08-29-12-00")
#' }
#' @export
#' 
validate_datetime <- function(text) {
  # Regex pattern for YYYY-mm-dd-hh-ss format
  pattern <- "^\\d{4}-\\d{2}-\\d{2}-\\d{2}-\\d{2}$"
  # Check if string matches pattern
  grepl(pattern, text)
  }