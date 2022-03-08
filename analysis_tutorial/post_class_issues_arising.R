# questions/problems arising during analysis
#

library(dplyr)
library(ggplot2)
library(maps)

geodat <- read.delim("~/git/envbiogeo-mgap/datasets/GEOTRACES_IDP2021_Seawater_Discrete_Sample_Data_v1_nfYzzsKg.clean.txt")

############
# 08-03-2022


# extract year or month for the sample
trace_years = sapply( strsplit( as.character(geodat$yyyy.mm.ddThh.mm.ss.sss) , "-", fixed=TRUE), "[", 1)
table(trace_years)
trace_years = gsub("^(\\d+)-.*","\\1", as.character(geodat$yyyy.mm.ddThh.mm.ss.sss) )
table(trace_years)
length(trace_years)

trace_month = sapply( strsplit( as.character(geodat$yyyy.mm.ddThh.mm.ss.sss) , "-", fixed=TRUE), "[", 2)
table(trace_month)


# subset the dataset to only include points that have a value for element of choice
# this requires the package dplyr - imported above with library(dplyr)
geodat_Al = filter(geodat, !is.na(geodat$Al_D_CONC_BOTTLE_nmol.kg) )

# check that it worked
dim(geodat)
#[1] 96184   318
dim( filter(geodat, !is.na(Al_D_CONC_BOTTLE_nmol.kg) ) )
#[1] 9144  318
dim( geodat_Al )
#[1] 9144  318

# REMEMBER TO ONLY USE THE FILTERED ONE FOR THE REST OF THE SCRIPT
trace_years = gsub("^(\\d+)-.*","\\1", as.character(geodat_Al$yyyy.mm.ddThh.mm.ss.sss) )
table(trace_years)
length(trace_years)

# viewing traces based on year
ggplot(geodat_Al, aes(x=Al_D_CONC_BOTTLE_nmol.kg , y=DEPTH_m , color=trace_years ) ) +
  scale_y_reverse(limits=c(6000,0)) +
  geom_line(size=3, alpha=0.5)


# viewing traces or points based on cruise name
table(geodat$Operators.Cruise.Name)
# each cruise is given a unique color, there may be a lot
ggplot(geodat_Al, aes(x=Al_D_CONC_BOTTLE_nmol.kg , y=DEPTH_m , color=Operators.Cruise.Name ) ) +
  scale_y_reverse(limits=c(6000,0)) +
  geom_line(size=3, alpha=0.5)



# simpler way of correcting the longitude in one line
# using geodat_Al for just samples with Aluminium
range(geodat_Al$Longitude_degrees_east)
longitude_corrected = ifelse(geodat_Al$Longitude_degrees_east > 180, geodat_Al$Longitude_degrees_east - 360, geodat_Al$Longitude_degrees_east)
range(longitude_corrected)
# make short table for just the map plotting
al_short_for_map = cbind( select(geodat_Al, Al_D_CONC_BOTTLE_nmol.kg , DEPTH_m , Latitude_degrees_north ), longitude_corrected )
# check if that worked too
dim(al_short_for_map)


# plot of world map with more or less than 50nM Al
worldpolygons = map_data("world")
ggplot(worldpolygons) +
  coord_cartesian(expand = c(0,0)) +
  labs(x=NULL, y=NULL) +
  theme_bw() +
  geom_polygon( aes(x=long, y = lat, group = group), fill="#cdcdcd", colour="#ffffff") +
  geom_point(data=filter(al_short_for_map, DEPTH_m > 1000), aes( x=longitude_corrected, y=Latitude_degrees_north ), color="#aaeeaa", alpha=0.2, size=3, shape=6 ) +
  geom_point(data=filter(al_short_for_map, Al_D_CONC_BOTTLE_nmol.kg >= 50 & DEPTH_m > 1000), aes( x=longitude_corrected, y=Latitude_degrees_north ), color="#640000", alpha=0.3, size=2, shape=19 ) + 
  geom_point(data=filter(al_short_for_map, Al_D_CONC_BOTTLE_nmol.kg < 50 & DEPTH_m > 1000), aes( x=longitude_corrected, y=Latitude_degrees_north ), color="#000064", alpha=0.3, size=2, shape=19 )

# zoom in on region in the world
# fx, the mediterranean, change the xlim and ylim in coord_cartesian()
ggplot(worldpolygons) +
  coord_cartesian(expand = c(0,0), xlim = c(-20,50), ylim = c(25,55) ) +
  labs(x=NULL, y=NULL) +
  theme_bw() +
  geom_polygon( aes(x=long, y = lat, group = group), fill="#cdcdcd", colour="#ffffff") +
  geom_point(data=filter(al_short_for_map, DEPTH_m > 1000), aes( x=longitude_corrected, y=Latitude_degrees_north ), color="#aaeeaa", alpha=0.2, size=4, shape=6 ) +
  geom_point(data=filter(al_short_for_map, Al_D_CONC_BOTTLE_nmol.kg >= 50 & DEPTH_m > 1000), aes( x=longitude_corrected, y=Latitude_degrees_north ), color="#640000", alpha=0.6, size=3, shape=19 ) + 
  geom_point(data=filter(al_short_for_map, Al_D_CONC_BOTTLE_nmol.kg < 50 & DEPTH_m > 1000), aes( x=longitude_corrected, y=Latitude_degrees_north ), color="#000064", alpha=0.6, size=3, shape=19 )










