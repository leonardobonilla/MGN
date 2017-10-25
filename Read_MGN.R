
# Open and merge rural area maps

############################

rm(list=ls())
library(data.table)
library(rgdal)
library(maptools)
library(stringr)
library(plyr)
library(dplyr)

# Leonardo
setwd("C:/Users/lbonilme/Dropbox/CEER v2/")

data_2005 <-"Datos/DANE/Cartografia DANE/MGN/2005/"

########################################################

#  Roads 

########################################################

# List of dptos (without San Andres that has no roads)
dpto <- list.files(data_2005, full.names = F)
dpto <- dpto[dpto != "88_SAN_ANDRES"]
dpto <- dpto[dpto != "Colombia"]

# batch read dptos
map <- list()

i <- 1 
for(d in dpto) {
  print(d)
  eval(parse(text=paste("map[[",i,"]] <- readOGR(dsn = paste0(data_2005,\"",d,"/VIAS\"), layer = \"VIAS\")", sep="")))
  i <- i+1
  }

# Merge maps correcting for unique ID
# Keep key variables 
var_road <- c("type","oneway","bridge", "tunnel","maxspeed")

uid<-1
map_col <- map[[1]][,var_road]
n <- length(slot(map_col, "lines"))
map_col <- spChFIDs(map_col, as.character(uid:(uid+n-1)))
uid <- uid + n

for (i in 2:length(dpto)) {
  print(i)
  map_temp <- map[[i]][,var_road]
  n <- length(slot(map_temp, "lines"))
  map_temp <- spChFIDs(map_temp, as.character(uid:(uid+n-1)))
  uid <- uid + n
  map_col <- spRbind(map_col,map_temp)
}

# plot(map_col)
writeOGR(map_col, dsn = paste0(data_2005,"Colombia"), layer = "VIAS", driver = "ESRI Shapefile")


########################################################

#  Rural sections 

########################################################

# List of dptos
dpto <- list.files(data_2005, full.names = F)
dpto <- dpto[dpto != "Colombia"]

# batch read dptos
map <- list()

i <- 1 
for(d in dpto) {
  print(d)
  eval(parse(text=paste("map[[",i,"]] <- readOGR(dsn = paste0(data_2005,\"",d,"/MGN\"), layer = \"MGN_Seccion_rural\")", sep="")))
  i <- i+1
}

# Merge maps correcting for unique ID

uid<-1
map_col <- map[[1]]
n <- length(slot(map_col, "polygons"))
map_col <- spChFIDs(map_col, as.character(uid:(uid+n-1)))
uid <- uid + n

for (i in 2:length(dpto)) {
  print(i)
  map_temp <- map[[i]]
  n <- length(slot(map_temp, "polygons"))
  map_temp <- spChFIDs(map_temp, as.character(uid:(uid+n-1)))
  uid <- uid + n
  map_col <- spRbind(map_col,map_temp)
}

plot(map_col)
writeOGR(map_col, dsn = paste0(data_2005,"Colombia"), layer = "MGN_seccion_rural_col", driver = "ESRI Shapefile")


