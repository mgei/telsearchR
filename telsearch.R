# get from tel.search.ch API

library(tidyverse)
library(lubridate)
library(httr)
library(xml2)
library(purrr)


telsearch <- function(was,
                      wo,
                      q,
                      privat = 1,
                      firma = 1,
                      pos,
                      maxnum = 200,
                      key,
                      lang,
                      count_only = 0,
                      adj_formats = T) {
  
  if (missing(was)) {
    stop("was keyword is mandatory")
  }
  
  if (missing(key) & maxnum > 10) {
    warning("without a key the maxnum is 10")
    maxnum <- 10
  }
  
  url <- paste0("https://tel.search.ch/api/",
                "?was=", was, 
                if (!missing(wo)) { paste0("&wo=", wo) },
                if (!missing(q)) { paste0("&q=", q) },
                "&privat=", privat,
                "&firma=", firma,
                if (!missing(pos)) { paste0("&pos=", pos) },
                "&maxnum=", maxnum,
                if (!missing(key)) { paste0("&key=", key) },
                if (!missing(lang)) { paste0("&lang=", lang) },
                if (!missing(count_only)) { paste0("&count_only=", count_only) }
  )
  
  get1 <- GET(url)
  read1 <- read_xml(get1)
  
  # we need to remove attributes
  xml_attrs(read1) <- c()
  
  # https://stackoverflow.com/a/35106671/9285732
  nodes1 <- xml_find_all(read1, ".//entry")
  
  map_df(nodes1, function(x) {
    kids <- xml_children(x)
    setNames(as.list(type.convert(xml_text(kids))), 
             xml_name(kids))
  }) -> tbl_data
  
  # adjust formats
  if (adj_formats) {
    
    tbl_data <- tbl_data %>% 
      mutate_all(as.character) %>% 
      mutate(updated = ymd_hms(updated),
             published = ymd_hms(published))
    
    # these fields are only there if we provided a key
    if (!missing(key)) {
      
      tbl_data <- tbl_data %>%
        mutate(pos = as.integer(pos),
               zip = as.integer(zip),
               poboxzip = as.integer(poboxzip))
      
    }
  }
  
  return(tbl_data)
  
}