library(shiny)
library(shinyapps)

runApp(launch.browser = T)

shinyapps::deployApp()

nodes <- read.csv(paste("data//output","2008","nodes.csv",sep="//"),sep=",")
edges <- read.csv(paste("data//output","2008","edges.csv",sep="//"),sep=",")

edges<-edges[,-1]

g<-graph.data.frame(edges)

plot.igraph(g,vertex.label=NA)
tkplot(g)
plot(g,layout=layout.circle,vertex.label=NA)

ggplot(aggregate,aes(year,average.path.length.g.))+geom_point(stat="identity")

average.path.length(g)
diameter(g)
transitivity(g)  # global clustering coefficient
ecount(g)
vcount(g)

degree(g)
degree.distribution(g)

hist(degree(g))
#hist(degree.distribution(g))

adjacent.triangles(g)
alpha.centrality(g)


