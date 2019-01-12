EDA
================

This is a exploratory data analysis to explore the [Marshall Violent
Crime](https://github.com/themarshallproject/city-crime) dataset.

``` r
# load libraries
suppressPackageStartupMessages(library(tidyverse))
```

``` r
# load data
crime <- read_csv("../data/ucr_crime_1975_2015.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   ORI = col_character(),
    ##   year = col_double(),
    ##   department_name = col_character(),
    ##   total_pop = col_double(),
    ##   homs_sum = col_double(),
    ##   rape_sum = col_double(),
    ##   rob_sum = col_double(),
    ##   agg_ass_sum = col_double(),
    ##   violent_crime = col_double(),
    ##   months_reported = col_double(),
    ##   violent_per_100k = col_double(),
    ##   homs_per_100k = col_double(),
    ##   rape_per_100k = col_double(),
    ##   rob_per_100k = col_double(),
    ##   agg_ass_per_100k = col_double(),
    ##   source = col_character(),
    ##   url = col_character()
    ## )

``` r
# size of data
dim(crime )
```

    ## [1] 2829   17

There are 2,829 entries in the raw dataset.

``` r
# explore department_name (city name) variable
crime$department_name %>%
  unique()
```

    ##  [1] "Albuquerque, N.M."           "Arlington, Texas"           
    ##  [3] "Atlanta"                     "Aurora, Colo."              
    ##  [5] "Austin, Texas"               "Baltimore"                  
    ##  [7] "Baltimore County, Md."       "Boston"                     
    ##  [9] "Buffalo, N.Y."               "Charlotte-Mecklenburg, N.C."
    ## [11] "Chicago"                     "Cincinnati"                 
    ## [13] "Cleveland"                   "Columbus, Ohio"             
    ## [15] "Dallas"                      "Denver"                     
    ## [17] "Detroit"                     "El Paso, Texas"             
    ## [19] "Fairfax County, Va."         "Fort Worth, Texas"          
    ## [21] "Fresno, Calif."              "Honolulu"                   
    ## [23] "Houston"                     "Indianapolis"               
    ## [25] "Jacksonville, Fla."          "Kansas City, Mo."           
    ## [27] "Las Vegas"                   "Long Beach, Calif."         
    ## [29] "Los Angeles"                 "Los Angeles County, Calif." 
    ## [31] "Louisville, Ky."             "Memphis, Tenn."             
    ## [33] "Mesa, Ariz."                 "Miami"                      
    ## [35] "Miami-Dade County, Fla."     "Milwaukee"                  
    ## [37] "Minneapolis"                 "Montgomery County, Md."     
    ## [39] "Nashville, Tenn."            "Nassau County, N.Y."        
    ## [41] "National"                    "New Orleans"                
    ## [43] "New York City"               "Newark, N.J."               
    ## [45] "Oakland, Calif."             "Oklahoma City"              
    ## [47] "Omaha, Neb."                 "Orlando, Fla."              
    ## [49] "Philadelphia"                "Phoenix"                    
    ## [51] "Pittsburgh"                  "Portland, Ore."             
    ## [53] "Prince George's County, Md." "Raleigh, N.C."              
    ## [55] "Sacramento, Calif."          "Salt Lake City"             
    ## [57] "San Antonio"                 "San Diego"                  
    ## [59] "San Francisco"               "San Jose"                   
    ## [61] "Seattle"                     "St. Louis, Mo."             
    ## [63] "Suffolk County, N.Y."        "Tampa, Fla."                
    ## [65] "Tucson, Ariz."               "Tulsa, Okla."               
    ## [67] "Virginia Beach, Va."         "Washington, D.C."           
    ## [69] "Wichita, Kan."

There are some potential issues with this variable:

  - some police departments oversee counties as well, for the purpose of
    this app, we only want to display information about cities.

  - the variable value “National” is not a meaningful entry for our app.

<!-- end list -->

``` r
# count the number of problematic city names
crime$department_name %>%
  unique() %>% 
  str_subset(pattern = "County|National")
```

    ## [1] "Baltimore County, Md."       "Fairfax County, Va."        
    ## [3] "Los Angeles County, Calif."  "Miami-Dade County, Fla."    
    ## [5] "Montgomery County, Md."      "Nassau County, N.Y."        
    ## [7] "National"                    "Prince George's County, Md."
    ## [9] "Suffolk County, N.Y."

There are 9 potentially problematic city names for our application.

``` r
# explore incomplete entries
# identify annual reports with less than 12 months reported
crime %>% 
  filter(months_reported < 12) %>% 
  select(ORI, months_reported)
```

    ## # A tibble: 53 x 2
    ##    ORI     months_reported
    ##    <chr>             <dbl>
    ##  1 FL01300              11
    ##  2 NY05101               9
    ##  3 TXHPD00              10
    ##  4 NY01401              10
    ##  5 VA02901              11
    ##  6 TXHPD00               9
    ##  7 NY05101               7
    ##  8 NY05101               8
    ##  9 NY02900              11
    ## 10 NY05101              11
    ## # ... with 43 more rows

There are 53 annual reports with less than 12 months reported.
