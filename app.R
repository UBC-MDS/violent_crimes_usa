library(shiny)
library(tidyverse)
library(DT)

data <- read.csv("data/crime_clean.csv", stringsAsFactors = FALSE)

# TO DO ALYCIA: "Average over time", "all cities"
# Notes for George: I copied my rape graph into the map section as a placeholder or else the app won't run for me
# Notes for George: I renamed variables within checkboxGroupInput, so note the rename I did in the table,
# you will likely need to do the same in your map. Sorry! It was the easiest way I could make the table names pretty

ui <- fluidPage(
  
  sidebarLayout(
    sidebarPanel(
      tags$style(".well {background-color:rgba(13, 160, 165, 0.15);}"),
      tags$style(HTML("hr {border-top: 1px solid #0D9DA3; margin-top: 300px; margin-bottom: 20px;}")),
      
      helpText("Compare violent crime rates (per capita) of major US cities:"),
      
      # year input
      selectInput("year", "SELECT YEAR", 
                  c("Average Over Time" = "1975-2014",
                    sort(unique(data$year), decreasing = TRUE)), 
                  selectize = FALSE),
      
      # crimes input
      checkboxGroupInput("crime", "SELECT CRIME(S)", 
                         c("Homicide" = "HOMICIDES", 
                           "Rape" = "RAPE",
                           "Robbery" = "ROBBERIES",
                           "Aggravated Assault" = "AGGRAVATED ASSAULTS"),
                         selected = "HOMICIDES"),
      
      # break line
      hr(),
      helpText("Graph violent crime trends of a specific city over time:"),
      
      # city selector
      selectInput("city", "SELECT A CITY", 
                  c("All Cities", unique(data$department_name)), selectize = FALSE)

    
    ),
  
    mainPanel(
      titlePanel(title = list(textOutput("year_caption"))),
      
      # create tabs
      tabsetPanel(type = "tabs",
        tabPanel("Map", plotOutput("map")), 
        tabPanel("Rank Table", dataTableOutput("table"))),
      
      # display 4 city violent crime plots
      fluidRow(
        splitLayout(cellWidths = c("50%","50%"),
                    plotOutput("hom"),
                    plotOutput("rape")),
        splitLayout(cellWidths = c("50%","50%"),
                  plotOutput("rob"),
                  plotOutput("assault")))

      # hover not working, need to fix this
      #fluidRow(column(width = 3, verbatimTextOutput("hover_info")))
    
    ) 
  )
)

server <- function(input, output) {
  # interactive title
  output$year_caption <- renderText({paste(input$crime, "(per capita),", input$year)})
  
  # map plot
  output$map <- renderPlot(data %>% filter(department_name == input$city) %>% 
                             ggplot(aes(x = year, y = rape_per_100k)) + geom_line(color = "#0D9DA3") + 
                             labs(x = "Year", y = "Rape (per capita)", title = "RAPE") +
                             theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                                   panel.background = element_blank(), axis.line = element_line(colour = "black"),
                                   aspect.ratio=1))
  # rank table plot
  output$table <- renderDataTable(data %>% filter(year == input$year) %>% 
                                    rename("CITY" = department_name, 
                                           "POPULATION" = total_pop,
                                           "TOTAL VIOLENT CRIME" = violent_per_100k,
                                           "HOMICIDES" = homs_per_100k,
                                           "RAPE" = rape_per_100k,
                                           "ROBBERIES" = rob_per_100k,
                                           "AGGRAVATED ASSAULTS" = agg_ass_per_100k
                                    ) %>% 
                                    select("CITY", "POPULATION", input$crime) %>% 
                                    mutate_if(is.numeric, round, 0)
  )
  # homicides over time plot
  output$hom <- renderPlot(data %>% filter(department_name == input$city) %>% 
      ggplot(aes(x = year, y = homs_per_100k)) + geom_line(color = "#0D9DA3") + 
      labs(x = "Year", y = "Homicides (per capita)", title = "HOMICIDE") +
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank(), axis.line = element_line(colour = "black"),
            aspect.ratio=1)
  )
  # hover not working, fix this
  #output$hom_hover <- renderPrint({cat("Year")
   # str(input$plot_hover)})
  
  # rape over time plot
  output$rape <- renderPlot(
    data %>% filter(department_name == input$city) %>% 
    ggplot(aes(x = year, y = rape_per_100k)) + geom_line(color = "#0D9DA3") + 
    labs(x = "Year", y = "Rape (per capita)", title = "RAPE") +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"),
          aspect.ratio=1)
  )
  # robberies over time plot
  output$rob <- renderPlot(data %>% filter(department_name == input$city) %>% 
    ggplot(aes(x = year, y = rob_per_100k)) + geom_line(color = "#0D9DA3") + 
    labs(x = "Year", y = "Robberies (per capita)", title = "ROBBERY") +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"),
          aspect.ratio=1)
  )
  # assaults over time plot
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