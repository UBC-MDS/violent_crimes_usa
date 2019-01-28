library(shiny)
library(tidyverse)
library(DT)
library(leaflet)
library(htmltools)
library(rsconnect)
library(shinydashboard)
library(plotly)

data <- read_csv("data/crime_clean.csv")

ui <- dashboardPage(skin = "black",

  dashboardHeader(title = "US Violent Crime", disable = TRUE),

  dashboardSidebar(
    sidebarMenu(

      tags$style(HTML(
        "hr {border-top: 0px solid #0D9DA3; margin-top: 0px;}
         .skin-black .main-sidebar {padding-top: 0px;}")),

      # add whitespace
      hr(),

      # year input
      selectizeInput("year", "SELECT YEAR",
                  c("Average Over Time" = "1975-2014",
                  sort(unique(data$year), decreasing = TRUE))),


      # crimes input
      checkboxGroupInput("crime", "SELECT CRIME(S)",
                         c("Homicide" = "HOMICIDE",
                           "Rape" = "RAPE",
                           "Robbery" = "ROBBERY",
                           "Aggravated Assault" = "AGGRAVATED ASSAULT"),
                         selected = "ROBBERY"),


      # city selector
      selectizeInput("city", "SELECT CITY",
                  c("All Cities", unique(data$department_name)))

    )
  ),

    dashboardBody(
      # change colours: 1&2: header background, 3: sidebar background, 4: main display background
      tags$head(tags$style(HTML('
        .skin-black .main-header .logo {background-color: #f2f4fb;}
        .skin-black .main-header .navbar {background-color: #f2f4fb;}
        .skin-black .main-sidebar {background-color: #5c5470;}
        .content-wrapper, .right-side {background-color: #ffffff;}
        '))),

      tags$div(
        style="margin-bottom:20px;"
      ),

      # title the map/table
      h2(textOutput("subtitle")),

      # display selected year
      h4(textOutput("selected_year")),

      # display selected crime(s)
      h4(textOutput("selected_crimes")),
      
      

      # create tabs
      tabsetPanel(type = "tabs",
        tabPanel("Map", leafletOutput("map", height = 320)),
        tabPanel("Rank Table", dataTableOutput("table"))
      ),

      # display plot
      fluidRow(
        h3(textOutput("plot_title"), style = "margin-bottom:20px"),
        plotlyOutput("lineplot"),
        style='padding:20px;'
      )
  )
)

server <- function(input, output) {

  #interactive titles
  output$plot_title <- renderText(paste("Crime Rates Over Time for", input$city, ":"))
  output$subtitle <- renderText("Compare Crime Rates (per 100k population) of Major US Cities")
  output$selected_year <- renderText({paste("|", input$year)})
  output$selected_crimes <- renderText({paste( "|", input$crime)})
  
  # map plot
  output$map <- renderLeaflet({
    validate(need((is.null(input$crime) == FALSE),
                  '\n\n\n     TO VIEW THE U.S. CRIME MAP, PLEASE SELECT A CRIME.'))
    leaflet(data_map()) %>%
      addProviderTiles(providers$Esri.WorldGrayCanvas, 
                       options = providerTileOptions(minZoom = 4, maxZoom = 9)) %>%
      setMaxBounds(lng1 = -130.807, lat1 = 21.268, lng2 = -59.588, lat2 = 51.3855) %>%
      setView(lng = -98.58, lat = 38, zoom = 4) %>%
      addCircleMarkers(data = data_map(),
                       radius = ~ 9,
                       color = ~ if_else(COUNT <= 20, "#20639b", 
                                 if_else(COUNT <= 100, "#3caea3", 
                                 if_else(COUNT <= 1000, "orange", "#d7191c"))),
                       label = ~ paste(sep = "", CITY, ": ", COUNT, " incidents"),
                       labelOptions = labelOptions(style = list(
                         "font-size" = "12px"
                       )),
                       stroke = FALSE,
                       fillOpacity = 0.6) %>% 
                       #clusterOptions = markerClusterOptions(
                         #spiderfyOnMaxZoom = FALSE,
                         #showCoverageOnHover = FALSE,
                         #zoomToBoundsOnClick = FALSE,
                         #singleMarkerMode = TRUE))
     addLegend(title = "Crime rates",
               colors = c("#d7101c", "orange", "#3caea3", "#20639b"),
               labels = c("> 1000", "100 - 1000", "20 - 100", "< 20"))
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
    #data_edit <- data_edit[rep(row.names(data_edit), data_edit$COUNT), ]
    return(data_edit)
  })

  # rank table plot
  output$table <- renderDataTable(data_time_ave() %>%
      select(-c("lon", "lat")),
    rownames = ""
  )

  # select "All Cities"
  city_choice <- reactive ({
    # if user selects "All Cities" find average crime rate per year across all cities
    if(input$city == "All Cities") {
      data_edit <- data %>% group_by(year) %>%
        summarise(HOMICIDE = round(mean(homs_per_100k),0),
                  RAPE = round(mean(rape_per_100k),0),
                  ROBBERY = round(mean(rob_per_100k),0),
                  ASSAULT = round(mean(agg_ass_per_100k),0))

      # if user selects any other city, report that city's crime rates over time
    } else {
      data_edit <- data %>% filter(department_name == input$city) %>%
        mutate(HOMICIDE = round(homs_per_100k,0),
               RAPE = round(rape_per_100k,0),
               ROBBERY = round(rob_per_100k,0),
               ASSAULT = round(agg_ass_per_100k,0))
    }

    return(data_edit)
  })

  lineplot_edit <- reactive ({
    plot <- city_choice() %>% 
      ggplot(aes(x = year, text = paste("(incidents per capita)"))) +
      labs(x = "YEAR", y = "# OF INCIDENTS (per 100k population)", color = "Crime types") +
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank(), axis.line = element_line(colour = "black"))
    if("HOMICIDE"%in%input$crime) {
      plot <- plot + geom_line(aes(y = HOMICIDE, colour = "Homicide")) }
    if("RAPE"%in%input$crime) {
      plot <- plot + geom_line(aes(y = RAPE, colour = "Rape")) }
    if("ROBBERY"%in%input$crime) {
      plot <- plot + geom_line(aes(y = ROBBERY, colour = "Robbery")) }
    if("AGGRAVATED ASSAULT"%in%input$crime) {
      plot <- plot + geom_line(aes(y = ASSAULT, colour = "Assault")) }
    else{
      plot }
    
    plot + scale_color_manual("", breaks = c("Homicide", 
                                             "Rape", 
                                             "Robbery", 
                                             "Assault"),
                                  values = c("Homicide" = "#bf68f6", 
                                             "Rape" = "#96cd39", 
                                             "Robbery" = "#67bac6", 
                                             "Assault" = "#ffaaa5"))
    
    return(ggplotly(plot, tooltip = c("x", "y", "text")))
  })

  # crime rates over time plot
  output$lineplot <- renderPlotly({
    validate(need((is.null(input$crime) == FALSE),
             'TO VIEW A PLOT OF CRIME RATES OVER TIME, PLEASE SELECT A CRIME.'))
    validate(need((input$city != ""),
                  'TO VIEW A PLOT OF CRIME RATES OVER TIME, PLEASE SELECT A CITY.'))
  lineplot_edit() %>% layout(legend = list(x = 0.8, y = 0.95, font = list(size = 14)))
  })


}

shinyApp(ui = ui, server = server)
