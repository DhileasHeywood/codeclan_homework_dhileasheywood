library(tidyverse)
library(plotly)
library(shiny)
library(shinythemes)


# Reading in the data needed for the app.
board_game_data <- read_csv(here::here("clean_data/board_game_clean_data"))
# Define UI for application.
ui <- fluidPage(

    theme = shinytheme("superhero"),
    
    # Application title
    titlePanel(
        tags$h1("Board Game Rating Analysis")
    ),
    
    # First tab
        
    tabsetPanel(
        # I want to have an "overview" panel, to give an idea of the data. What categories of
        # games there are, and how many games are in each category. What years had a lot of 
        # board game releases in them, etc. 
        tabPanel("Overview",
    
            # Sideb 
            fluidRow(
                column(6,
                       sliderInput(
                           "overview_category", 
                           tags$h3("What size of category?"), 
                           min = 0,
                           max = 1500,
                           value = c(300, 500)
                       )
                       
                ),
                
                column(6, 
                       sliderInput(
                           "overview_year",
                           tags$h3("Which years?"),
                           min = 1800,
                           max = 2017, 
                           value = c(1950, 2017),
                           sep = ""
                       )
                )
            ),
                
            fluidRow(
                
                column(
                    6, 
                    plotlyOutput("overview_category_plot")
                ), 
                column(6,
                    plotlyOutput("overview_year_plot")
                )
                
            )
        ),
    
        tabPanel("Rating",
                 
                fluidRow(
                    column(12,
                           selectInput(
                               "rating_graph",
                               label = "Rating vs:", 
                               choices = c(
                                    "Maximum play time" = "max_time",
                                    "Minimum play time" = "min_time",
                                    "Maximum number of players" = "max_players",
                                    "Minimum number of players" = "min_players", 
                                    "Number of votes received" = "num_votes"
                               ),
                               selected = "num_votes"
                           )
                        
                        )
                
                    ),
                fluidRow(
                    column(12,
                        
                        plotOutput("rating_plot")   
                           
                        )
                )
                )
            )    
)


# Define server logic required to draw many graphs
server <- function(input, output){
    
    # I'm putting in a reactive data frame, so that I can filter the data using the sliders.
    filtered_overview_category <- reactive({
        board_game_data %>% 
            group_by(category) %>% 
            summarise(category_count = n()) %>% 
            filter(category_count >= input$overview_category[1], category_count <= input$overview_category[2])
    })
    
    # This is the first plot for the overview tab, showing how many games are in each category.
    # I've used a plotly graph becaus there are a lot of categories. I wanted allow users to  
    # hover over a bar, and see what the height of it is, and which category it relates to. 
    output$overview_category_plot <- renderPlotly({
        
        plot_ly(data = filtered_overview_category(), x = ~category, y = ~category_count, type = "bar", color = "#31434F", colors = "#31434F")
        
    })
    
    # I'm using another reactive data frame here, for the same reason. 
    filtered_overview_year <- reactive({
        board_game_data %>%
            filter(year >= input$overview_year[1], year <= input$overview_year[2]) %>% 
            group_by(year) %>% 
            summarise(year_count = n())
    })
    
    
    # This is the second plot for the overview tab, showing how many games were released in each
    # year. I've used another plotly graph because there are games released over hundreds of 
    # years. Again, I wanted allow users to be able to hover over bars to see their year and 
    # height.
    output$overview_year_plot <- renderPlotly({
        plot_ly(data = filtered_overview_year(), x = ~year, y = ~year_count, type = "bar", color = "#31434F", colors = "#31434F")
    })
    
    
    # I can't get this to work! I can't figure out why. It's supposed to show rank vs a few things
    # to give the ficticious game designers an idea of what's popular in a game. Is there a trend 
    # between play time or number of players and rank? Is there a trend between rank and the number
    # of votes received? 
    output$rating_plot <- renderPlot({
        ggplot(board_game_data) +
            aes(x = input$rating_graph, y = rank, colour = geek_rating) +
            geom_point() +
            scale_y_reverse() 
    })
    
}

shinyApp(ui = ui, server = server)
