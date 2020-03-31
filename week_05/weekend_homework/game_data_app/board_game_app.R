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
                           tags$h3("Which years of game release?"),
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
                    column(6,
                            selectInput(
                               "rating_graph",
                               label = "Title of graph", 
                               choices = c(
                                    "Rating vs Maximum play time" = "max_time",
                                    "Rating vs Minimum play time" = "min_time",
                                    "Rating vs Maximum number of players" = "max_players",
                                    "Rating vs Minimum number of players" = "min_players", 
                                    "Rating vs Number of votes received" = "num_votes"
                               ),
                               selected = "num_votes"
                           )
                        
                        ),
                    
                    # This is a new idea, haven't had time to try and implement it yet.
                    column(6,
                            sliderInput(
                                "rank_range",
                                label = "Range of game rank", 
                                min = 1,
                                max = 4999,
                                value = c(1, 500)
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
    
    
    filtered_rank <- reactive({
        board_game_data %>% 
            filter(rank >= input$rank_range[1], rank <= input$rank_range[2])
    })
    
    # This plot shows rank vs a few things to give the ficticious game designers an idea of what's 
    # popular in a game. Is there a trend between play time or number of players and rank? Is there 
    # a trend between rank and the number of votes received? 
    output$rating_plot <- renderPlot({
        ggplot(filtered_rank()) +
            aes_string(x = input$rating_graph, y = "rank", colour = "geek_rating") +
            geom_point() +
            geom_smooth() +
            scale_y_reverse() 
    })
    
}

shinyApp(ui = ui, server = server)
