library(shiny)
library(networkD3)

shinyUI(navbarPage(
  
  # Application title
  'UK Domestic Airport Traffic: Network Analysis |'
#   
  ,header=p(br()
            ,'The following is an interactive analysis of UK domestic airport traffic data, obtained from the'
            ,a(href='https://www.caa.co.uk/default.aspx?catid=80&pagetype=88&pageid=3&sglid=3','Civil Aviation Authority website')
            ,'. Years 1997-2000 were not available as of March 2015.'
            ,br()
            ,'All code used to generate the app is available'
            ,a(href="https://github.com/polyphant1/UKAirportNetwork","here")
            ,'. See my '
            ,a(href='http://polyphant.com/blog','blog')
            ,' for other data related work and analysis.'
            ,br()
            ,br())

  ,tabPanel("Visualisation",
    sidebarLayout(
      sidebarPanel(
        uiOutput("yearControl")
        ,sliderInput('slider', label = 'Choose vertex opacity',
                     min = 0, max = 1, step = 0.01, value = 0.8)
        ,br()
        ,'Visualisations generated using the '
        ,a(href = 'http://christophergandrud.github.io/networkD3/', 'networkD3')
        ,'package. Nodes represent airports (hover for names), edges represent 
        connections between these airports, where the number of passengers is
        represented by the thickness of the line.
        Node colours show country, legend below.'
        ,br()
        ,br()
        ,tags$div(HTML("<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"200\" height=\"30\"><circle cx=\"15\" cy=\"15\" r=\"15\" fill=\"#1f77b4\" /><text x=\"35\" y=\"20\">England</text></svg>"))
        ,tags$div(HTML("<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"200\" height=\"30\"><circle cx=\"15\" cy=\"15\" r=\"15\" fill=\"#ff7f0e\" /><text x=\"35\" y=\"20\">Scotland</text></svg>"))
        ,tags$div(HTML("<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"200\" height=\"30\"><circle cx=\"15\" cy=\"15\" r=\"15\" fill=\"#2ca02c\" /><text x=\"35\" y=\"20\">Channel Islands</text></svg>"))
        ,tags$div(HTML("<div style=\"float:left\">
                          <svg xmlns=\"http://www.w3.org/2000/svg\" width=\"250\" height=\"30\">
                            <circle cx=\"15\" cy=\"15\" r=\"15\" fill=\"#d62728\" />
                            <circle cx=\"30\" cy=\"15\" r=\"15\" fill=\"#9467bd\" />
                            <text x=\"50\" y=\"20\">Wales \\ Northern Ireland</text>
                            </svg>
                        </div>"))
        ,tags$div(HTML("<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"200\" height=\"30\"><circle cx=\"15\" cy=\"15\" r=\"15\" fill=\"#8c564b\" /><text x=\"35\" y=\"20\">Isle of Man</text></svg>"))
      ),
      mainPanel(
        forceNetworkOutput("networkPlot")
      )
    )
  )

  ,tabPanel("Analysis",
    sidebarLayout(
      sidebarPanel(
        uiOutput("plotControl")
        ,br()
        ,tags$ul(
          tags$li(tags$strong('Average.Path.Length'),' is the mean path length between all vertices in the graph.'), 
          tags$li(tags$strong('Diameter'),' is the longest path between two vertices in the graph, obtained by using a breadth-first search like method.'),
          tags$li(tags$strong('Transitivity'),' is a measure of the clustering coefficient of the graph. 0',HTML('&le;'),'T',HTML('&le;'),'1, where T=1 if the graph contains all possible edges.'),
          tags$li(tags$strong('Edge.Count'),' is the total number of edges.'),
          tags$li(tags$strong('Vertex.Count'),' is the total number of vertices.')
        )
      ),
      mainPanel(
        plotOutput("plot") 
      )
    )
  ),

  tabPanel("Data",
    sidebarLayout(
      sidebarPanel(
        uiOutput("yearControl2")
        ,br()
        ,'Total passenger numbers are shown here in thousands. Airport 1 is the departure airport, Airport 2 is the arrival airport.'
      ),
      mainPanel(
        mainPanel(dataTableOutput(outputId = 'table'))
      )
    )
  )
))
