library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)

source("functions")

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Day Of Innovation: Shiny Test Planner"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
          numericInput(
              "sessions",
              "Total Sessions Available for Testing",
              value = 1000,
              min = 100
          ),
          sliderInput(
              "controlRate",
              "Control Rate",
              value = 0.05,
              min = 0.0, 
              max = 1.0,
              step = 0.001
          ),
          numericInput(
              "numArms",
              "Number of Alternative Variants",
              value = 1,
              min = 1,
              max = 6
          ),
          h3("Alternative Rates"),
          sliderInput(
              "rate1", 
              "Variant 1", 
              value = 0.05, 
              min = 0, 
              max = 1,
              step = 0.001
          ),
          conditionalPanel(
              "input.numArms > 1",
              sliderInput(
                  "rate2", 
                  "Variant 2", 
                  value = 0.05, 
                  min = 0, 
                  max = 1,
                  step = 0.001
              )
          ),
          conditionalPanel(
              "input.numArms > 2",
              sliderInput(
                  "rate3", 
                  "Variant 3", 
                  value = 0.05, 
                  min = 0, 
                  max = 1,
                  step = 0.001
              )
          ),
          conditionalPanel(
              "input.numArms > 3",
              sliderInput(
                  "rate4", 
                  "Variant 4", 
                  value = 0.05, 
                  min = 0, 
                  max = 1,
                  step = 0.001
              )
          ),
          conditionalPanel(
              "input.numArms > 4",
              sliderInput(
                  "rate5", 
                  "Variant 5", 
                  value = 0.05, 
                  min = 0, 
                  max = 1,
                  step = 0.001
              )
          ),
          conditionalPanel(
              "input.numArms > 5",
              sliderInput(
                  "rate6", 
                  "Variant 6", 
                  value = 0.05, 
                  min = 0, 
                  max = 1,
                  step = 0.001
              )
          ),
          h3("todo: change to sessions/day later"),
          numericInput(
              "batchSize",
              "number of sessions in a batch",
              value = 10,
              min = 1
          ),
          numericInput(
              "lagNumber",
              "number of batches until we expect a reward",
              value = 4,
              min = 0
          )
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("costPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
   output$costPlot <- renderPlot({
       testRates <- map_dbl(1:6, ~input[[paste0('rate', .x)]])[1:input$numArms]
       rates <- c(input$controlRate, testRates)
       numberOfBatches <- floor(input$sessions/input$batchSize)

       run_simulation(
           rates, 
           input$controlRate, 
           input$sessions, 
           input$batchSize, 
           numberOfBatches, 
           input$lagNumber
        ) %>% 
           tidy_cumulative_cost() %>% 
           plot_cumulative_cost()
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

