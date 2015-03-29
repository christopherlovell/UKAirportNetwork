# Notes: 
# 
# - some of the columns have different headings in the source files, which I updated manually


files<-list.files(path = "data\\input",pattern=".csv",full.names = T)

nodes<-""
# get all airport names for manual country assignment
nodes<-lapply(files,function(x){
  airports<-read.csv(x)
  
  # filter columns
  airports.filter<-airports[,c("apt1_apt_name","apt2_apt_name")]
  
  # generate unique node list with ids
  c(name=unique(c(as.character(airports.filter[,1]),as.character(airports.filter[,2]))))
})

# filter by unique names, and save to file for manual country assignment in excel
all_airports<-unique(do.call(c,nodes))
#write.table(all_airports,file = "data//output//airports_names.csv",sep = ",")

# get manually assigned groups
airport_groups<-read.csv("data//output//airports.csv",sep=",",header=T)

for(x in files){
  # Load data
  airports<-read.csv(x)
  
  # filter columns
  tryCatch(airports.filter<-airports[,c("apt1_apt_name","apt2_apt_name","total_pax_tp")],
           error=function(e){
             print(e);
             next;
             })
  
  # generate unique node list with ids
  nodes<-data.frame(name=unique(c(as.character(airports.filter[,1]),as.character(airports.filter[,2]))))
  
  nodes$country<-apply(nodes,1,function(x) airport_groups[which(airport_groups[,c("X")] %in% x["name"]),c("X.1")])
  
  edges<-airports.filter
  edges$apt1_id<-apply(airports.filter,1,function(x) which(nodes[,c("name")] %in% x[1]))
  edges$apt2_id<-apply(airports.filter,1,function(x) which(nodes[,c("name")] %in% x[2]))
  
  # zero-index the edge id's
  edges$apt1_id<-edges$apt1_id-1
  edges$apt2_id<-edges$apt2_id-1
  
  # normalise passenger number counts to prevent excessively wide edges
  edges$total_pax_tp<-edges$total_pax_tp/10000
  
  # regex year from filename
  ind<-regexpr("(\\d{4})",x)[1]
  year<-substr(x,ind,ind+3)

  if(!(paste("data//output",year,sep="//") %in% list.dirs("data//output/"))){
    dir.create(paste("data//output",year,sep="//"))  
  }
  
  write.table(nodes,paste("data//output",year,"nodes.csv",sep="//"),sep=",",col.names=NA)
  write.table(edges,paste("data//output",year,"edges.csv",sep="//"),sep=",",col.names=NA)
}

