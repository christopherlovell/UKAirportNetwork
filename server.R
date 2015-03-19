# Load packages
library(d3Network)

nodes<-read.csv("data//output//13_nodes.csv",sep=",")
edges<-read.csv("data//output//13_edges.csv",sep = ",")

#### Shiny ####
shinyServer(function(input, output) {
  
  output$networkPlot <- renderPrint({
    d3ForceNetwork(Nodes = nodes,
                   Links = edges,
                   Source = "apt1_id", Target = "apt2_id",
                   Value = "total_pax_tp", 
                   NodeID = "name",
                   #Group = "grp_name",
                   width = 400, height = 500,
                   opacity = input$slider,
                   zoom = T,
                   standAlone = FALSE,
                   parentElement = '#networkPlot'
                   )
  })
})
