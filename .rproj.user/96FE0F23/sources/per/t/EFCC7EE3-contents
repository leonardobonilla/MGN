
# Open and merge rural area maps

############################

rm(list=ls())
packageList<-c("data.table","foreign","plyr","dplyr","haven","plotly","ggplot2","tidyr","sp", "rgeos","rgdal","raster","kml","broom","gtools","maptools","magrittr", "stringr","sf","lwgeom")
lapply(packageList,require,character.only=TRUE)

# Leonardo
setwd("E:/Users/lbonilme/Dropbox/CEER v2/")

rural <- "Papers/Docentes/" 
data_2005 <-"Datos/DANE/Cartografia DANE/MGN/2005/"

########################################################

#  Roads density by municipality

########################################################

# Load data
mun <- read_sf(dsn=paste0(rural,"Datos/DANE/mgn_codmun.shp"))
vias <- read_sf(paste0(data_2005,"Colombia/VIAS.shp")) %>% st_transform_proj(crs = st_crs(3857)) 
st_crs(vias) 
test <- vias[which(vias$DPTO_CCDGO == "17"),]

# road density by mun
int <- st_intersection(vias,mun)
int$len = st_length(int)
road <- as.data.table(int) %>% group_by(codmun) %>%
  summarize(length = sum(len))

write.dta(road, paste0(data_2005,"Colombia/road_mun.dta"))
write.csv(road, paste0(data_2005,"Colombia/road_mun.csv"))








