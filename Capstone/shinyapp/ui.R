library(shiny)
library(shinythemes)
library(markdown)


shinyUI(navbarPage("Text Prediction", inverse = TRUE, collapsible = TRUE, theme = shinytheme("superhero"),
                   tabPanel("App",
                            sidebarLayout(
                              sidebarPanel(
                                div(actionButton("randomWordButton", label = "Random Word", class = "btn-primary"), align = "center"),
                                br(),
                                p("Please enter a word, phrase, or sequence of letters into the box below.", align = "center"),
                                textInput("inputText", label = "Enter Text:", value = ""),
                                selectInput("modelSelector", label = "Select Model:", 
                                            choices = c("Combined Model", "Blogs Model" ,"Twitter Model", "News Model")),
                                sliderInput("maxInput", label = "Maximum Words Used:", min = 1, max = 4, value = 2),
                                sliderInput("maxWords", label = "Maximum Words Predicted:", min = 1, max = 50, value = 15)
                              ),
                              mainPanel(
                                tabsetPanel(
                                  tabPanel("Next Word", icon = icon("cloud"),
                                           h2("Next Word Prediction", align = "center"),
                                           plotOutput("wordPlot"),
                                           h2(textOutput("predictedWord"), align = "center", 
                                              style = "color:fuchsia; border:3px double black; padding: 5px;")
                                  ),
                                  tabPanel("More Words", icon = icon("book"),
                                           h2("Continuously Predict Next Word", align = "center"),
                                           br(),
                                           div(actionButton("nextWordsButton", label = "Next Words", class = "btn-primary"), 
                                               align = "center"),
                                           br(),
                                           div(textOutput("extraWords"), 
                                               style = "border:3px double black; padding: 5% 10%; overflow-y:auto; max-height: 400px" )
                                  ),
                                  tabPanel("Word Suggestion", icon = icon("list"),
                                           h2("Last Word Alternative Suggestions", align = "center"),
                                           br(),
                                           div(tableOutput("suggestions"), align = "center", 
                                               style = "overflow-y:auto; max-height: 500px")
                                  )
                                )
                              )
                            )
                   ),
                   tabPanel("Instructions",
                            includeMarkdown("instructions.md")),
                   tabPanel("About",
                            includeMarkdown("about.md"))
))
