library(shiny)
library(tidyverse)
library(DT)

data <- read.csv("data/ucr_crime_1975_2015.csv", stringsAsFactors = FALSE)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      tags$style(".well {background-color:rgba(13, 160, 165, 0.15);}"),
      selectInput("year", "SELECT YEAR", c("Average Over Time", 
                                           sort(unique(data$year), decreasing = TRUE))
                                           , selectize = FALSE),
      radioButtons("crime", "SELECT A CRIME", c("SELECT ALL" = "violent_per_100k",
                                                "Homicide" = "homs_per_100k",
                                                "Rape" = "rape_per_100k",
                                                "Robbery" = "rob_per_100k",
                                                "Aggravated Assault" = "agg_ass_per_100k")),
      selectInput("city", "SELECT A CITY", c("All Cities", unique(data$department_name)), selectize = FALSE)
      
    
    ),
    mainPanel(
      #plotOutput("map"),
      dataTableOutput("table"),
      fluidRow(
        splitLayout(cellWidths = c("25%", "25%", "25%", "25%"),
        plotOutput("hom", hover = hoverOpts(id="plot_hover")),
        plotOutput("rape"),
        plotOutput("rob"),
        plotOutput("assault"))
      ),
      # hover not working, need to fix this
      fluidRow(column(width = 3, verbatimTextOutput("hover_info")))
    )
  )
)

server <- function(input, output) {
  #output$map <- renderPlot(
   # bcl %>% filter(Price > input$priceInput[1],
    #               Price < input$priceInput[2]) %>% 
     # ggplot(aes(Price)) + geom_histogram()
  #)
  output$table <- renderDataTable(data %>% filter(year == input$year) %>% 
                                select(department_name, total_pop, input$crime) %>% 
                                mutate_if(is.numeric, round, 0) %>% 
                                #rename_if(input$crime == "violent_per_100k", 
                                 # "TOTAL CRIME (per capita)" = input$crime)
                                #} else if(input$crime == "homs_per_100k") {
                                #  "HOMICIDES (per capita)" == input$crime
                                #} else if (input$crime == "rape_per_100k") {
                                 # "RAPE (per capita)" == input$crime
                                #} else if (input$crime == "rob_per_100k") {
                                #  "ROBBERY (per capita)" == input$crime
                                #} else {"AGGRAVATED ASSAULT (per capita)" == input$crime}
                                #%>% 
                                rename("CITY" = department_name, 
                                       "POPULATION" = total_pop,
                                       "RATE" = input$crime), #%>% 
                                #,
                                       #"RATE (per capita)" = input$crime) #%>%
                                #arrange(desc("RATE (per capita)"))#,
                                       #"TOTAL VIOLENT CRIME (per capita)" = violent_per_100k,
                                       #"HOMICIDE (per capita)" = homs_per_100k, 
                                       #"RAPE (per capita)" = rape_per_100k, 
                                       #"ROBBERY (per capita)" = rob_per_100k, 
                                       #"AGGRAVATED ASSAULT (per capita)" = agg_ass_per_100k)# %>% 
                                
                                options = list(order = list(3, 'desc')))
  output$hom <- renderPlot(data %>% filter(department_name == input$city) %>% 
      ggplot(aes(x = year, y = homs_per_100k)) + geom_line(color = "#0D9DA3") + 
      labs(x = "Year", y = "Homicides (per capita)", title = "HOMICIDE") +
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank(), axis.line = element_line(colour = "black"),
            aspect.ratio=1)
  )
  # hover not working, fix this
  output$hom_hover <- renderPrint({cat("Year")
    str(input$plot_hover)})
  
  output$rape <- renderPlot(
    data %>% filter(department_name == input$city) %>% 
    ggplot(aes(x = year, y = rape_per_100k)) + geom_line(color = "#0D9DA3") + 
    labs(x = "Year", y = "Rape (per capita)", title = "RAPE") +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"),
          aspect.ratio=1)
  )
  
  output$rob <- renderPlot(data %>% filter(department_name == input$city) %>% 
    ggplot(aes(x = year, y = rob_per_100k)) + geom_line(color = "#0D9DA3") + 
    labs(x = "Year", y = "Robberies (per capita)", title = "ROBBERY") +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"),
          aspect.ratio=1)
  )
  
  output$assault <- renderPlot(data %>% filter(department_name == input$city) %>% 
    ggplot(aes(x = year, y = agg_ass_per_100k)) + geom_line(color = "#0D9DA3") + 
    labs(x = "Year", y = "Aggravated Assault (per capita)", 
         title = "AGGRAVATED ASSAULT") +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"),
          aspect.ratio=1)
  )
  
}

shinyApp(ui = ui, server = server)