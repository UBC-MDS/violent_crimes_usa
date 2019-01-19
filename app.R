library(shiny)
library(tidyverse)
library(DT)
library(leaflet)
library(htmltools)

data <- read_csv("data/crime_clean.csv")

ui <- fluidPage(

  tags$style("label{font-family: Open Sans;}"),
  titlePanel("How Crime Rates Compare Across the US"),

  sidebarLayout(
    sidebarPanel(

      width = 2,
      tags$style(".well {background-color:rgba(13, 160, 165, 0.15);}"),
      tags$style(HTML("hr {border-top: 1px solid #0D9DA3; margin-top: 250px; margin-bottom: 20px;}")),

      helpText("Compare crime rates (per capita) of major US cities:"),

      # year input
      selectInput("year", "SELECT YEAR",
                  c("Average Over Time" = "1975-2014",
                    sort(unique(data$year), decreasing = TRUE)),
                  selectize = FALSE),

      # crimes input
      checkboxGroupInput("crime", "SELECT CRIME(S)",
                         c("Homicide" = "HOMICIDE",
                           "Rape" = "RAPE",
                           "Robbery" = "ROBBERY",
                           "Aggravated Assault" = "AGGRAVATED ASSAULT"),
                         selected = "HOMICIDE"),

      # break line
      hr(),
      helpText("Graph crime trends of a specific city over time:"),

      # city selector
      selectInput("city", "SELECT A CITY",
                  c("All Cities", unique(data$department_name)), selectize = FALSE)


    ),

    mainPanel(

      # title the map/table
      titlePanel(title = list(textOutput("caption"))),

      tags$div(
        style="margin-bottom:50px;",

      # create tabs
      tabsetPanel(type = "tabs",
        tabPanel("Map", leafletOutput("map")),
        tabPanel("Rank Table", dataTableOutput("table")))
      ),

      # display 4 city violent crime plots
      fluidRow(
        splitLayout(cellWidths = c("50%","50%"),
                    plotOutput("hom"),
                    plotOutput("rape")),
        splitLayout(cellWidths = c("50%","50%"),
                    plotOutput("rob"),
                    plotOutput("assault"))
      )

    )
  )
)

server <- function(input, output) {

  # interactive title
  #output$caption <- renderText({paste(input$crime, "(per capita),", input$year)})

  # map plot
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Esri.WorldGrayCanvas) %>% 
      setView(lng = -98.58, lat = 38, zoom = 4) %>% 
      addCircleMarkers(data = data_map(), 
                       radius = ~ sqrt(COUNT) * 0.8, 
                       color = "orange",
                       label = ~ paste(sep = "", CITY, ": ", COUNT, " incidents"))
  })

  # add total crime to table if user selects all crimes
  total_crime <- reactive({
    if(length(input$crime) < 4) {
      var_select <- c("CITY", "POPULATION", input$crime, "lon", "lat")
    } else {
      var_select <- c("CITY", "POPULATION", "TOTAL CRIME", input$crime, "lon", "lat")
    }
    return(var_select)
  })

  # sum averages over time
  data_time_ave <- reactive({

    # if user selectes "Average Over Time"
    if(input$year == "1975-2014") {
      # compute average the crime rates for each city
      data_ave <- data %>%
        group_by(department_name) %>%
        summarise("HOMICIDE" = mean(homs_per_100k),
               "RAPE" = mean(rape_per_100k),
               "ROBBERY" = mean(rob_per_100k),
               "AGGRAVATED ASSAULT" = mean(agg_ass_per_100k),
               "TOTAL CRIME" = mean(violent_per_100k))

      # subset population data to join with average data
      join_data <- data %>%
        filter(year == 2014) %>%
        select(department_name, total_pop, lon, lat)

      # join data and make presentation quality
      data_edit <- left_join(join_data, data_ave, by = "department_name")
      data_edit <- data_edit %>%
        rename("CITY" = department_name,
              "POPULATION" = total_pop) %>%
        select(total_crime()) %>%
        rename("POPULATION (in 2014)" = "POPULATION") %>%
        mutate_if(is.numeric, round, 0)
    }
    # if user selects any other year
    else {
      data_edit <- data %>% 
        filter(year == input$year) %>%
        rename("CITY" = department_name,
               "POPULATION" = total_pop,
               "TOTAL CRIME" = violent_per_100k,
               "HOMICIDE" = homs_per_100k,
               "RAPE" = rape_per_100k,
               "ROBBERY" = rob_per_100k,
               "AGGRAVATED ASSAULT" = agg_ass_per_100k) %>%
        select(total_crime()) %>%
        mutate_if(is.numeric, round, 0)
    }
    return(data_edit)
  })
  
  # prepare map data
  data_map <- reactive({
    data_edit <- data_time_ave()
    data_edit$COUNT <- data_edit %>% 
      select(c(one_of(input$crime))) %>% 
      rowSums()
    return(data_edit)
  })

  # rank table plot
  output$table <- renderDataTable(data_time_ave() %>% 
    select(-c("lon", "lat"))
  )

  # select "All Cities"
  city_choice <- reactive ({
    # if user selects "All Cities" find average crime rate per year across all cities
    if(input$city == "All Cities") {
      data_edit <- data %>% group_by(year) %>%
        summarise("HOMICIDE" = mean(homs_per_100k),
                  "RAPE" = mean(rape_per_100k),
                  "ROBBERY" = mean(rob_per_100k),
                  "ASSAULT" = mean(agg_ass_per_100k))

      # if user selects any other city, report that city's crime rates over time
    } else {
      data_edit <- data %>% filter(department_name == input$city) %>%
        rename("HOMICIDE" = homs_per_100k,
               "RAPE" = rape_per_100k,
               "ROBBERY" = rob_per_100k,
               "ASSAULT" = agg_ass_per_100k)
    }
    return(data_edit)
  })

  # homicides over time plot
  output$hom <- renderPlot(city_choice() %>%
      ggplot(aes(x = year, y = HOMICIDE)) + geom_line(color = "#0D9DA3") +
      labs(x = "Year", y = "Homicides (per capita)", title = "HOMICIDE RATES") +
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank(), axis.line = element_line(colour = "black"),
            aspect.ratio=1)
  )

  # rape over time plot
  output$rape <- renderPlot(city_choice() %>%
    ggplot(aes(x = year, y = RAPE)) + geom_line(color = "#0D9DA3") +
    labs(x = "Year", y = "Rape (per capita)", title = "RAPE RATES") +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"),
          aspect.ratio=1)
  )
  # robberies over time plot
  output$rob <- renderPlot(city_choice() %>%
    ggplot(aes(x = year, y = ROBBERY)) + geom_line(color = "#0D9DA3") +
    labs(x = "Year", y = "Robberies (per capita)", title = "ROBBERY RATES") +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"),
          aspect.ratio=1)
  )
  # assaults over time plot
  output$assault <- renderPlot(city_choice() %>%
    ggplot(aes(x = year, y = ASSAULT)) + geom_line(color = "#0D9DA3") +
    labs(x = "Year", y = "Assaults (per capita)",
         title = "AGGRAVATED ASSAULT RATES") +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"),
          aspect.ratio=1)
  )

}

shinyApp(ui = ui, server = server)
