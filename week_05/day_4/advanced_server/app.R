library(ggplot2)
library(shiny)
library(CodeClanData)
library(dplyr)


ui <- fluidPage(
    radioButtons('text_select',
                 'What text do you want to see?',
                 choices = c("Cat", "Dog")),
    textOutput("text_output")
)
server <- function(input, output) {
    output$text_output <- renderText({
        if (input$text_select == "Cat"){
            return("Cats are the best!")
        } else{
            return("Dogs are the best!")
        }
    })
}
shinyApp(ui = ui, server = server)