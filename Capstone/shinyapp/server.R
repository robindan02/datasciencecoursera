library(shiny)
library(wordcloud)

source('prediction.R')


shinyServer(function(input, output, session) {

  ##### Reactive Vars -------------------------------------------------------------------------------------------------
  reactiveVariables <- reactiveValues(words = "", maxInput = 2, dataModels = comboModels)
  
  ##### Current Prediction --------------------------------------------------------------------------------------------
  prediction <- reactive( {
    predictNextWord(input$inputText, reactiveVariables$dataModels, maxWords = input$maxWords, maxInput = reactiveVariables$maxInput)
  })
  
  ##### Output Renders ------------------------------------------------------------------------------------------------
  output$predictedWord <- renderText(
    if(input$inputText != "") { prediction()[1,1] }
  )
  
  output$wordPlot <- renderPlot(execOnResize = TRUE,
    wordcloud(prediction()[,1], prediction()[,2], scale = c(2, 0.9), min.freq = 2, max.words = input$maxWords, 
              random.order = TRUE, rot.per = 0.5, use.r.layout = TRUE,
              colors = c(brewer.pal(4, "Pastel2"), brewer.pal(5,"Set1"), brewer.pal(4,"Dark2"), "#9F28BD") )
  )
  
  output$extraWords <- renderText( {
    reactiveVariables$words
  })
  
  output$suggestions <- renderTable(striped = TRUE, bordered = TRUE, width = "50%", colnames = FALSE, {
    findSimilar(input$inputText, reactiveVariables$dataModels, input$maxWords)
  })
  
  
  ##### Event Handlers ------------------------------------------------------------------------------------------------
  observeEvent(input$maxInput, {
    reactiveVariables$maxInput <- input$maxInput
  })
  
  observeEvent(input$modelSelector, {
    switch(input$modelSelector, 
           "Combined Model" = reactiveVariables$dataModels <- comboModels,
           "Blogs Model" = reactiveVariables$dataModels <- blogsModels,
           "Twitter Model" = reactiveVariables$dataModels <- twitterModels,
           "News Model" = reactiveVariables$dataModels <- newsModels
           )
  })
  
  observeEvent(input$randomWordButton, {
    updateTextInput(session, "inputText", value = sample(reactiveVariables$dataModels[[1]][1:50, 1], 1)) 
  })
  
  observeEvent(input$nextWordsButton, {
    for(i in 1:input$maxWords) {
      reactiveVariables$words <- paste(reactiveVariables$words, sample(predictNextWord(reactiveVariables$words, 
                                                              reactiveVariables$dataModels, maxWords = 2, 
                                                              maxInput = reactiveVariables$maxInput)[,1], 1), " ")
    }
  })
  
  # Clear current words on 'More Words' when relevant inputs change
  observeEvent( { 
    input$inputText 
    input$maxInput
    input$modelSelector 
    }, {  
    reactiveVariables$words <- paste(input$inputText, predictNextWord(input$inputText, reactiveVariables$dataModels, 
                                                     maxInput = reactiveVariables$maxInput)[1,1], " ")
  })
  
})