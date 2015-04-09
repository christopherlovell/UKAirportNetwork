# Load packages
library(networkD3)
library(ggplot2)
library(shiny)

dirs<-list.dirs('data//output//')
dirs<-dirs[2:length(dirs)]  # ignore first root output directory
years<-substr(dirs,nchar(dirs)-3,nchar(dirs))

aggregate<-read.csv('data//output//aggregate.csv',header = T)
aggregate$year<-as.Date(aggregate$year,format = "%Y")
names(aggregate)<-c("id","Year","Average.Path.Length","Diameter","Transitivity","Edge.Count","Vertices.Count")

#### Shiny ####
shinyServer(function(input, output) {
  
  output$plot <- renderPlot({
    if(!is.null(input$plot.control)){
      print(ggplot(aggregate,aes_string(x="Year",y=input$plot.control))+geom_point(stat="identity")+geom_line())
    }else{
      print(ggplot(aggregate,aes_string(x="Year",y="Edge.Count"))+geom_point(stat="identity")+geom_line())
    }    
  })
  
  output$plotControl <- renderUI({
    selectInput('plot.control',
                label="Choose summary statistic: ",
                choices = names(aggregate)[3:length(aggregate)],
                selected="Edge.Count")
  })
  
  output$yearControl <- renderUI({
    selectInput('year',label="Choose year: ",choices = years,selected = "2013")
  })
  
  readNodes <- reactive({
    if(!is.null(input$year)){
      read.csv(paste("data//output",input$year,"nodes.csv",sep="//"),sep=",")
    }else{
      read.csv(paste("data//output","2013","nodes.csv",sep="//"),sep=",")
    }
  })
  
  readEdges <- reactive({
    if(!is.null(input$year)){
      read.csv(paste("data//output",input$year,"edges.csv",sep="//"),sep=",")
    }else{
      read.csv(paste("data//output","2013","edges.csv",sep="//"),sep=",")
    }
  })
  
  output$networkPlot <-
    renderForceNetwork({        
        nodes<-readNodes()
        edges<-readEdges()
        forceNetwork(Links = edges, Nodes = nodes, Source = "apt1_id",
                     Target = "apt2_id", Value = "total_pax_tp", NodeID = "name",
                     Group = "country", opacity = input$slider,
                     colourScale = "d3.scale.category10()")
    })
  
  output$table <- renderDataTable({
    edges<-readEdges2()
    edges$total_pax_tp<-edges$total_pax_tp*10
    names(edges)<-c("id","Airport 1","Airport 2","Total Passenger Traffic","id1","id2")
    edges[2:4]
  },options = list(pageLength = 10))
  
  output$yearControl2 <- renderUI({
    selectInput('year2',label="Choose year: ",choices = years,selected = "2013")
  })
  
  readEdges2 <- reactive({
    if(!is.null(input$year2)){
      read.csv(paste("data//output",input$year2,"edges.csv",sep="//"),sep=",")
    }else{
      read.csv(paste("data//output","2013","edges.csv",sep="//"),sep=",")
    }
  })
})
