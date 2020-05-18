#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define UI for application that draws a histogram
ui <- fluidPage(
  # Application title
  titlePanel("WCMA Collection"),
  plotOutput("plot"),
  hr(),
  
  fluidRow(
    column(width=2,
           h4("Pick Your Personality")
           ,
           selectInput('year', "Medium:", list("Wild Forest"=1, "Sunday on a Spring"=2))
    ),
    
    column(width=1,imageOutput("Person1"),
    column(width=1,textOutput("person1"),
    column(width=1,imageOutput("Person2"))
    #render images of clusters here
  ),
  
  fluidRow(
    column(3,
           h4("Pick Your Color")
           ,
           selectInput('year', "Medium:", list("Sunrise Orange"=1, "very Blue"=2))
    ),
    column(width=1,imageOutput("Color1")),
    column(width=1,imageOutput("Color2"))
  ),
  
  fluidRow(column(4, offset=1,
                  selectInput('year', "Medium:", list("Drawing"="WCMA-DRAWING",
                                                      "Sculpture"="WCMA-SCULPTURE", 
                                                      "Ancient"="WCMA-ANCIENT",
                                                      "Amerindian"="WCMA-AMERINDIAN",
                                                      "Prints"="WMCA-PRINTS",
                                                      "Painting"="WCMA-PAINTING",
                                                      "Eastern"="WCMA-EASTERN",
                                                      "African"="WCMA-AFRICAN",
                                                      "Pacific"="WCMA-PACIFIC",
                                                      "Photo"="WCMA-PHOTO")),
                  
                  sliderInput("complexity", "Complexity:",
                              min = 1, max = 10,
                              value = 5),
                  
                  actionButton("finish", "Recommend Me Something")             
  )
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
  output$Person1 <- renderImage({
    filename = normalizePath(file.path("10_1 copy.jpg"))
    list(src = filename,width="100px",height="100px")
  }, deleteFile = FALSE)
  
  output$Person2 <- renderImage({
    filename = normalizePath(file.path("16_1 copy.jpg"))
    list(src = filename,width="100px",height="100px")
  }, deleteFile = FALSE)
  
  output$Color1 <- renderImage({
    filename = normalizePath(file.path("20_1_4_a copy.jpg"))
    list(src = filename,width="100px",height="100px")
  }, deleteFile = FALSE)
  
  output$Color2 <- renderImage({
    filename = normalizePath(file.path("20_1_4_a copy.jpg"))
    list(src = filename,width="100px",height="100px")
  }, deleteFile = FALSE)
  
  output$person1 <- renderText("person1")
}

# Run the application 
shinyApp(ui = ui, server = server)