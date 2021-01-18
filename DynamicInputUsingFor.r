library("shiny")

# Este es un ejemplo en Shiny para hacer funcionar los ciclos (en lugar de un apply)

ui <-fluidPage(
  numericInput("numoftrends",
               label="Number of Linear Trends:",
               min = 1,
               max = 10,
               value = 1,
               step = 1),
  uiOutput("num_of_trends"),
  textOutput("see_ranges")
  
)

server <- function(input, output, session) {
  
  # Desarrollo original
  # output$num_of_trends <- renderUI({
  # lapply(1:input$numoftrends, function(i) {
  #   dateRangeInput(paste0("date_range_input", i), paste('Trend Date Range Input', i, ':'),
  #                  separator = " - ", start = as.Date("2020-01-01"),  end =  as.Date("2020-12-31"),
  #                  format = "yyyy-mm-dd",
  #                  startview = 'year')
  # })
  # })
    

    output$num_of_trends <- renderUI({
     # lista_numTrends <- vector(mode = "list", length = length(input$numoftrends))
      lista <- vector(mode = "list", length =  length(input$numoftrends))
      
            for(i in 1:input$numoftrends){
        local({
           my_i <- i
           lista[[my_i]] <<- dateRangeInput(paste0("date_range_input", my_i), paste('Trend Date Range Input', my_i, ':'),
                                               separator = " - ", start = as.Date("2020-01-01"),  end =  as.Date("2020-12-31"),
                                               format = "yyyy-mm-dd",
                                               startview = 'year')
        })
      }
      

     return(lista)
  })
    
    
  
  trend_list <- reactive({
    out <- list()
    for(i in 1:input$numoftrends) {
      out[[i]] <- input[[paste0("date_range_input", i)]]
    }
    out
  })
  
  output$see_ranges <- renderPrint({
    print(trend_list())
  })
}

shinyApp(ui = ui, server = server)