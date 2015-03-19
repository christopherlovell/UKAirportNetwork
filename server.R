# Load packages
library(d3Network)

# Load data once
airports13<-read.csv("data//Table_12_2_Dom_Air_Pax_Route_Analysis_2013.csv")

# filter columns
airports13.filter<-airports13[,c("apt1_apt_name","apt2_apt_name","total_pax_tp","grp_name")]

# generate unique node list with ids
nodes<-data.frame(name=unique(c(as.character(airports13.filter[,1]),as.character(airports13.filter[,2]))))
#nodes<-data.frame(id=seq(from = 1,to=length(nodes),by=1),nodes)

# assign node ids to edges
edges<-airports13.filter
edges$apt1_id<-apply(airports13.filter,1,function(x) which(nodes[,c("name")] %in% x[1]))
edges$apt2_id<-apply(airports13.filter,1,function(x) which(nodes[,c("name")] %in% x[2]))

edges$apt1_id<-edges$apt1_id-1
edges$apt2_id<-edges$apt2_id-1

edges$total_pax_tp<-edges$total_pax_tp/10000

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
