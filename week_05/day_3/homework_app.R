library(shiny)
library(dplyr)
library(ggplot2)
library(CodeClanData)

source("homework_helper_file.R")


ui <- fluidPage(
    tabsetPanel(
    
        tabPanel("Five Country Medal Comparison",
            titlePanel(tags$h1("Five Country Medal Comparison")),
            sidebarLayout(
                sidebarPanel(
                    radioButtons(
                        "season",
                        tags$h4(tags$i("Which season?")),
                        choices = c("Summer", "Winter")
                    ),
                    radioButtons(
                        "medal", 
                        tags$h4(tags$i("Which medal?")),
                        choices = c("Gold", "Silver", "Bronze")
                    )
                ),
                
                mainPanel(
                    plotOutput("overall_medals")
                )
            )
        ),
        
        tabPanel("All Country Medal Comparison",
            titlePanel(tags$h1("All Country Medal Comparison")),
            sidebarLayout(
                sidebarPanel(
                    radioButtons(
                        "season_2",
                        tags$h4(tags$i("Which season?")),
                        choices = c("Summer", "Winter")
                    ),
                    selectInput(
                        "country",
                        tags$h4(tags$i("Which country?")),
                        choices = "some choices"
                    )
                ),
            
               mainPanel = (
                   "Some text"
               ) 
           
             )
        )
    )
)   

server <- function(input, output){
    output$overall_medals <- renderPlot({
        
        overall_medal_plot(input$medal, input$season)
        
    })
}

shinyApp(ui = ui, server = server)
