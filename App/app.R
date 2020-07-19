#
#
# This is a Shiny web application developed by Yolanda Zhao and Zihan Ye as part of their STATS
#440 final project on May 11, 2018. 

# You can run the application by clicking the 'Run App' button above.

#Please make sure that you have downloaded "WCMA Public Thumbs" to your desktop before running
#the App using the link:
# https://rs.williams.edu/pages/view.php?ref=92421&k=0e4c94d372



require(ggplot2)
library(shiny)
library(stringr)

#### Preprocessing Data
ref <- read.csv("wcma-collection.csv", stringsAsFactors = FALSE)
raw <- ref
files = list.files("~Desktop/WCMA Public Thumbs",
                   pattern = '*jpg$',
                   full.name = TRUE)
## get a list of filenames
filenames = list.files(
  "./WCMA Public Thumbs",
  pattern = '*jpg$',
  full.name = FALSE
)

## Reclassifying works by Prendergast into drawing/painting/print/photo
prendergast <- ref[ref$classification == "WCMA-Prendergast", ]
prendDrawing <- grep("watercolor", prendergast$object_name)
prendPainting <- grep("painting", prendergast$object_name)
prendPrint <- grep("print", prendergast$object_name)
prendPhoto <- grep("photo", prendergast$object_name)

prendergast[prendDrawing, ]$classification <- "WCMA-DRAWING"
prendergast[prendPainting, ]$classification <- "WCMA-PAINTING"
prendergast[prendPrint, ]$classification <- "WCMA-PRINTS"
prendergast[prendPhoto, ]$classification <- "WCMA-PHOTO"

ref2 <- ref[-which(ref$classification == "WCMA-Prendergast"), ]
ref <- rbind(ref2, prendergast)
ref <- ref[!duplicated(ref$filename),]
remove <-
  c(
    "WCMA-DEC ARTS",
    "WCMA Reserve Collection",
    "WCMA-WALLS",
    "WCMA-Prendergast",
    "WCMA-PACIFIC"
  )
removeRows <- ref[ref$classification %in% remove, ]
removeNames <- removeRows$filename


## Removing special characters from ref
combined <- ref[!ref$classification %in% remove, ]
combined$title <-
  str_replace_all(combined$title, "[^[:alnum:]]", " ")
combined$maker <-
  str_replace_all(combined$maker, "[^[:alnum:]]", " ")
combined$creation_date <-
  str_replace_all(combined$creation_date, "[^[:alnum:]]", " ")
for (i in 1:25) {
  combined[, i] <- str_replace_all(combined[, i], "  ", " ")
}
combined$maker <- trimws(combined$maker, which = "both")


## Merge meta data information with grouping results 
results <- read.csv("results.csv")
combined<- merge(combined,results,by="filename",all=FALSE)

## Create Color Summary
colornames <-
  c("Black",
    "White",
    "Gray",
    "Red",
    "Orange",
    "Yellow",
    "Green",
    "Blue",
    "Purple")
content <-
  c(
    "Value < 15",
    "Value > 95 and Saturation < 2",
    "Value Between 35 and 95, Saturation < 6",
    "Hue > 330 or Hue < 25",
    "Hue Between 25 and 50",
    "Hue Between 50 and 70",
    "Hue between 70 and 160",
    "Hue Between 160 and 250",
    "Hue Between 250 and 330"
  )
des <- matrix(nrow = 9, ncol = 2)
colnames(des) <- c("Color", "Condition")
des[, 1] <- colornames
des[, 2] <- content
ColorTable <- data.frame(des)

## Create Empty Table
errortable <- data.frame()

#### Designing the web app

## Define UI for application that draws a histogram
ui <- fluidPage(navbarPage(
  "WCMA Collection",
  tabPanel(
    "Your Preferences",
    # Application title
    titlePanel("Create Your Own WCMA Tour"),
    fluidRow(column(
      4,
      h4("Pick Your Type"),
      selectInput(
        'medium',
        "Type:",
        list(
          "Drawing" = "WCMA-DRAWING",
          "Sculpture" =
            "WCMA-SCULPTURE",
          "Ancient" =
            "WCMA-ANCIENT",
          "Amerindian" =
            "WCMA-AMERINDIAN",
          "Prints" =
            "WMCA-PRINTS",
          "Painting" =
            "WCMA-PAINTING",
          "Eastern" =
            "WCMA-EASTERN",
          "African" =
            "WCMA-AFRICAN",
          
          
          "Photo" =
            "WCMA-PHOTO"
        )
      )
    )),
    
    fluidRow(
      column(
        width = 2,
        offset = 0.5,
        h4("Pick Your Color"),
        selectInput(
          'color',
          "Color:",
          list(
            "Orange" = "orange",
            "Mixed Colors" = "Colorful",
            "Red" = "red",
            "White" = "white",
            "Blue" =
              "blue",
            "Green" = "green",
            "Purple" = "purple",
            "Black" = "black",
            "Yellow" =
              "yellow",
            "Gray" = "gray"
          )
        )
      ),
      
      column(
        width = 2,
        offset = 0.5,
        fluidRow(offset = 0.5, 'Orange', imageOutput("Color1", height =
                                                       "160px")),
        fluidRow(offset = 1, 'Mixed Colors', imageOutput("Color2", height =
                                                           "180px"))
      ),
      
      column(
        width = 2,
        offset = 0.5,
        fluidRow(offset = 1, 'Red', imageOutput("Color3", height =
                                                  "160px")),
        fluidRow(offset = 1, 'White', imageOutput("Color4", height =
                                                    "180px"))
      ),
      
      column(
        width = 2,
        offset = 0.5,
        fluidRow(offset = 1, 'Blue', imageOutput("Color5", height =
                                                   "160px")),
        fluidRow(offset = 1, 'Green', imageOutput("Color6", height =
                                                    "180px"))
      ),
      
      column(
        width = 2,
        offset = 0.5,
        fluidRow(offset = 1, 'Purple', imageOutput("Color7", height =
                                                     "160px")),
        fluidRow(offset = 1, 'Black', imageOutput("Color8", height =
                                                    "180px"))
      ),
      
      column(
        width = 2,
        offset = 0.5,
        fluidRow(offset = 1, 'Yellow', imageOutput("Color9", height =
                                                     "160px")),
        fluidRow(offset = 1, 'Gray', imageOutput("Color10", height =
                                                   "180px"))
      )
      
    ),
    
    
    fluidRow(
      column(
        width = 2,
        offset = 0.5,
        h4("Pick Your Style"),
        selectInput(
          'personality',
          "Personality:",
          list(
            "Worn Out" = 1,
            "Midnight" = 2,
            "Desert" = 3,
            "Dazed and Confused" = 4
          )
        )
      ),
      
      column(
        width = 2,
        offset = 0.5,
        fluidRow(offset = 0.5, 'Worn Out', imageOutput("Person1", height =
                                                         "170px"))
      ),
      
      column(
        width = 2,
        offset = 0.5,
        fluidRow(offset = 0.5, 'Midnight', imageOutput("Person2", height =
                                                         "170px"))
      ),
      
      column(
        width = 2,
        offset = 0.5,
        fluidRow(offset = 0.5, 'Desert', imageOutput("Person3", height =
                                                       "170px"))
      ),
      
      column(
        width = 2,
        offset = 0.5,
        fluidRow(
          offset = 0.5,
          'Dazed and Confused',
          imageOutput("Person4", height = "170px")
        )
      )
      
    ),
    
    fluidRow(
      actionButton("finish", "Recommend Me Something"),
      actionButton("another", "Works By The Same Maker"),
      align = "center"
    ),
    fluidRow(
      textOutput("errortext"),
      imageOutput("image1", height = "150px"),
      tableOutput("artinfo"),
      textOutput("errortext1"),
      imageOutput("anotherpiece", height = "150px"),
      tableOutput("anotherinfo"),
      align = "center"
    )
  ),
  tabPanel("Diversity of Art Types", imageOutput("barClassification")),
  tabPanel(
    "How Did We Define Color?",
    textOutput("ColorText"),
    tableOutput("ColorSum"),
    uiOutput("tab")
  ),
  tabPanel(
    "What Exactly Is Style?",
    textOutput("PersonalityText0"),
    textOutput("PersonalityText1"),
    textOutput("PersonalityText2"),
    textOutput("PersonalityText3"),
    textOutput("PersonalityText4"),
    textOutput("PersonalityText5"),
    uiOutput("tab2")
  )
))


# Define server logic required to draw a histogram
server <- function(input, output) {
  output$Color1 <- renderImage({
    filename = normalizePath(file.path("One.JPG"))
    list(
      src = filename,
      width = "150px",
      height = "150px",
      align = "center"
    )
  }, deleteFile = FALSE)
  
  output$Color2 <- renderImage({
    filename = normalizePath(file.path("Two.JPG"))
    list(
      src = filename,
      width = "150px",
      height = "150px",
      align = "center"
    )
  }, deleteFile = FALSE)
  
  output$Color3 <- renderImage({
    filename = normalizePath(file.path("Three.JPG"))
    list(
      src = filename,
      width = "150px",
      height = "150px",
      align = "center"
    )
  }, deleteFile = FALSE)
  
  output$Color4 <- renderImage({
    filename = normalizePath(file.path("Four.JPG"))
    list(
      src = filename,
      width = "150px",
      height = "150px",
      align = "center"
    )
  }, deleteFile = FALSE)
  
  output$Color5 <- renderImage({
    filename = normalizePath(file.path("Five.JPG"))
    list(
      src = filename,
      width = "150px",
      height = "150px",
      align = "center"
    )
  }, deleteFile = FALSE)
  
  output$Color6 <- renderImage({
    filename = normalizePath(file.path("Six.JPG"))
    list(
      src = filename,
      width = "150px",
      height = "150px",
      align = "center"
    )
  }, deleteFile = FALSE)
  
  
  output$Color7 <- renderImage({
    filename = normalizePath(file.path("Seven.JPG"))
    list(
      src = filename,
      width = "150px",
      height = "150px",
      align = "center"
    )
  }, deleteFile = FALSE)
  
  
  output$Color8 <- renderImage({
    filename = normalizePath(file.path("Eight.JPG"))
    list(
      src = filename,
      width = "150px",
      height = "150px",
      align = "center"
    )
  }, deleteFile = FALSE)
  
  output$Color9 <- renderImage({
    filename = normalizePath(file.path("Nine.JPG"))
    list(
      src = filename,
      width = "150px",
      height = "150px",
      align = "center"
    )
  }, deleteFile = FALSE)
  
  output$Color10 <- renderImage({
    filename = normalizePath(file.path("Ten.JPG"))
    list(
      src = filename,
      width = "150px",
      height = "150px",
      align = "center"
    )
  }, deleteFile = FALSE)
  
  
  output$Person1 <- renderImage({
    filename = normalizePath(file.path("Person1.JPG"))
    list(
      src = filename,
      width = "150px",
      height = "150px",
      align = "center"
    )
  }, deleteFile = FALSE)
  
  
  output$Person2 <- renderImage({
    filename = normalizePath(file.path("Person2.JPG"))
    list(
      src = filename,
      width = "150px",
      height = "150px",
      align = "center"
    )
  }, deleteFile = FALSE)
  
  output$Person3 <- renderImage({
    filename = normalizePath(file.path("Person3.JPG"))
    list(
      src = filename,
      width = "150px",
      height = "150px",
      align = "center"
    )
  }, deleteFile = FALSE)
  
  output$Person4 <- renderImage({
    filename = normalizePath(file.path("Person4.JPG"))
    list(
      src = filename,
      width = "150px",
      height = "150px",
      align = "center"
    )
  }, deleteFile = FALSE)
  
  vals <- reactiveValues(rowind = 0)
  dummy <- 0
  
  observeEvent(input$finish, {
    output$anotherinfo <- renderTable({
      errortable
    })
    output$anotherpiece <- renderImage({
      list(
        src = "eyes.jpg",
        width = "150px",
        height = "150px",
        align = "center"
      )
    }, deleteFile = FALSE)
    output$errortext1 <- renderText({
      ""
    })
    output$errortext <- renderText({
      "We Found An Image For You!"
    })
    dummy <- dummy + 1
    if (dummy > 0) {
      color2 <- input$color
      medium2 <- input$medium
      personality2 <- input$personality
      rows <- which((combined$Personality.Clusters == personality2) &
                      (combined$classification == medium2) &
                      (combined$Colorful. == color2)
      )
      
      if (length(rows) == 0) {
        output$errortext <- renderText({
          "Sorry, there are no images found. Please try again."
        })
        output$image1 <- renderImage({
          list(
            src = "eyes.jpg",
            width = "150px",
            height = "150px",
            align = "center"
          )
        }, deleteFile = FALSE)
      }
      else{
        output$errotext <- renderText({
          "We Found An Image For You!"
        })
        plotrows <- sample(rows, 1)
        vals$rowind <- plotrows
        first <- as.character(combined[plotrows[1], ]$filename)
        filename1 <- paste0("~/Desktop/WCMA Public Thumbs/", first)
        output$image1 <- renderImage({
          list(
            src = filename1 ,
            width = "150px",
            height = "150px",
            align = "center"
          )
        }, deleteFile = FALSE)
        rownum <- plotrows
        title <- as.character(combined[rownum, ]$title)
        maker <- as.character(combined[rownum, ]$maker)
        date <- combined[rownum, ]$creation_date
        medium <- as.character(combined[rownum, ]$medium)
        mat <-
          data.frame(
            Title = title,
            Maker = maker,
            Date = date,
            Medium = medium
          )
        output$artinfo = renderTable({
          mat
        })
        dummy <- 0
      }
    }
  })
  
  dummy2 <- 0
  observeEvent(input$another, {
    dummy2 <- dummy2 + 1
    if (dummy2 > 0) {
      row <- vals$rowind
      artist <- as.character(combined[row, ]$maker)
      sameartist <- which(combined$maker == artist)
      if (length(sameartist) < 2) {
        output$errortext1 <- renderText({
          "Sorry, there are no other images by the same artist in the collection. Please start again."
        })
        output$anotherinfo <- renderTable({
          errortable
        })
        output$anotherpiece <- renderImage({
          list(
            src = "eyes.jpg",
            width = "150px",
            height = "150px",
            align = "center"
          )
        }, deleteFile = FALSE)
      }
      else {
        sameartist <- setdiff(sameartist, row)
        if (length(sameartist) == 1) {
          anotherrow <- sameartist
        }
        else{
          anotherrow <- sample(sameartist, 1)
        }
        second <- as.character(combined[anotherrow, ]$filename)
        filename2 <- paste0("~/Desktop/WCMA Public Thumbs/", second)
        output$anotherpiece = renderImage({
          list(
            src = filename2 ,
            width = "150px",
            height = "150px",
            align = "center"
          )
        }, deleteFile = FALSE)
        output$errortext1 <-
          renderText({
            "Here's Another Image By The Same Maker"
          })
        rownum <- anotherrow
        title <- as.character(combined[rownum, ]$title)
        maker <- as.character(combined[rownum, ]$maker)
        date <- combined[rownum, ]$creation_date
        medium <- as.character(combined[rownum, ]$medium)
        mat <-
          data.frame(
            Title = title,
            Maker = maker,
            Date = date,
            Medium = medium
          )
        output$anotherinfo = renderTable({
          mat
        })
        dummy2 <- 0
      }
    }
  })
  
  
  
  
  output$barClassification <-
    renderPlot({
      ggplot(combined[combined$classification != "WCMA-PACIFIC", ], aes(classification)) + geom_bar() +
        coord_flip() +
        ggtitle("Number of Images in WCMA collection by Category")
    })
  
  output$ColorSum <- renderTable({
    ColorTable
  })
  output$ColorText <-
    renderText({
      "Color is a subjective measure, but for this project we needed to objectively
      assign images to its primary color. In order to do this, we broke down the images into pixels and assigned every
      pixel a color based on the HSV criterion. HSV stands for Hue, Saturation, and Value.
      The table belows presents how color is assigned to each pixel based on the pixel’s HSV values. Please note that
      each assignment condition is mutually exclusive (a pixel can only be one color based on the condition).
      A web-based HSV Palette Explorer was used to identify the most appropriate ranges of HSV values for the 9 colors we grouped
      pixels into.
      If 40 percent or more of the pixels in a given image are primarily of one color
      (red, orange, yellow, green, blue, purple, black, white, or gray), then
      we put that image in the group corresponding to its primary color. Otherwise, we categorized
      the image as 'colorful', which means it's not of primarily one color (the most common color in its pixels
      appeared in less than 40% of its pixels)
      "
    })
  url <-
    a("HSV Palette Explorer", href = "https://alloyui.com/examples/color-picker/hsv")
  output$tab <- renderUI({
    tagList("URL link:", url)
  })
  
  
  output$PersonalityText0 <-
    renderText({
      "In order to determine the style of an image, we decided to look at
      three features related to the image's HSV values: value mean, saturation mean, and warmth, defined below."
    })
  
  output$PersonalityText1 <-
    renderText({
      "1. Value Mean: Measures lightness/darkness. The average of an image’s value
      across all of its pixels can give us information on the overall brightness of an image relative
      to other images."
    })
  output$PersonalityText2 <-
    renderText({
      "2. Saturation Mean: Measures the intensity of a color. The mean of an image’s
      saturation across all of its pixels can give us information on the overall color intensity of an
      image relative to other images."
    })
  output$PersonalityText3 <-
    renderText({
      "3. Warmth: Measures the proportion of warm colored pixels
      in a given image. A warm colored pixel is defined as a pixel whose hue is less than or equal
      to 90 or between 330 and 360."
    })
  output$PersonalityText4 <-
    renderText({
      "We used the Manhattan distance, which is the sum of absolute differences
      of each of the features for two given images, to measure how different those two images are in terms of
      these three visual features. The values for the features are standardized so that their impact on the distance measure are on the same scale.
      "
    })
  output$PersonalityText5 <-
    renderText({
      "Then, we used the k-means clustering algorithm to group the images that are least distant from each other
      (and therefore most similar to each other) into the same clusters. The K-means partitioning algorithm was chosen because it is computationally efficient,
      intuitive, and generally works well for large datasets. A silhouette plot was used to help us choose k, which is the number of clusters to divide the images into.
      There is, however, no generally agreed upon method for choosing the most optimal k every time.
      After consulting the silhouette plot and running the algorithm on several different values of k, we decided it was best to use k=4.
      "
    })
  
  url2 <-
    a("Overview of K-means Clustering", href = "https://en.wikipedia.org/wiki/K-means_clustering")
  output$tab2 <- renderUI({
    tagList("URL link:", url2)
  })
}


# Run the application
shinyApp(ui = ui, server = server)