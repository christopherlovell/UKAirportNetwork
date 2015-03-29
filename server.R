# Load packages
library(d3Network)
library(networkD3)
library(shiny)

dirs<-list.dirs('data//output//')
dirs<-dirs[2:length(dirs)]  # ignore first root output directory
years<-substr(dirs,nchar(dirs)-3,nchar(dirs))

#### Shiny ####
shinyServer(function(input, output) {
  
  output$yearControl <- renderUI({
    selectInput('year',label="Choose year: ",choices = years)
  })
  
  readNodes <- reactive({
    read.csv(paste("data//output",input$year,"nodes.csv",sep="//"),sep=",")
  })
  
  readEdges <- reactive({
    read.csv(paste("data//output",input$year,"edges.csv",sep="//"),sep=",")
  })
  
  output$networkPlot <-
    renderForceNetwork({
      
      nodes<-readNodes()
      edges<-readEdges()
      forceNetwork(Links = edges, Nodes = nodes, Source = "apt1_id",
                   Target = "apt2_id", Value = "total_pax_tp", NodeID = "name",
                   Group = "country", opacity = input$slider,
                   colourScale = "d3.scale.category20b()")
    })

  
#     d3ForceNetwork(Nodes = nodes,
#                    Links = edges,
#                    Source = "apt1_id", Target = "apt2_id",
#                    Value = "total_pax_tp", 
#                    NodeID = "name",
#                    Group = "country",
#                    width = 600, height = 600,
#                    opacity = input$slider,
#                    zoom = T,
#                    standAlone = FALSE,
#                    parentElement = '#networkPlot',
#                    )
#})

})
