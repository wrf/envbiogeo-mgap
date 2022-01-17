# day 3
#
# mapping GEOTRACES in R

# do this first
# install.packages("maps")
# or go to the top menu tab "Tools" and pick "Install Packages..."

# make sure to load the "maps" library, to draw maps
library(maps)


# read in data
geodat <- read.delim("~/git/envbiogeo-mgap/datasets/GEOTRACES_IDP2021_Seawater_Discrete_Sample_Data_v1_nfYzzsKg.clean.txt")

# table() doesnt work well for numeric columns
table( geodat$CTDTMP_T_VALUE_SENSOR_deg.C )

# need to use round() or something similar
table( round(geodat$CTDTMP_T_VALUE_SENSOR_deg.C ) )

# but it is better to plot as a hist()
# change breaks= to change the number of bars in the histogram
hist( geodat$CTDTMP_T_VALUE_SENSOR_deg.C , breaks=50 )

# plot temp vs depth, draw a vertical line at x=10
plot( geodat$CTDTMP_T_VALUE_SENSOR_deg.C , geodat$DEPTH_m , ylim=c(7000,0) , pch=16, col="#abde1211")
abline(v=10)
# can change line to dashed or dots with lty=2 or lty=3
abline(v=c(0,15), lty=2, col="red")


# make logical vectors, for whether or not the depth is greater than 2000m
# or temperature is greater than 10 degrees C
is_deep = geodat$DEPTH_m > 2000
is_hot_water = geodat$CTDTMP_T_VALUE_SENSOR_deg.C > 10
# table() can show fast way to count how many TRUE or FALSE
table(is_hot_water)

# can combine two logicals with &
is_deep_and_hot =  is_deep & is_hot_water
table(is_deep_and_hot)


#
# fix longitude from 0 to 360 into values of -180 to 180
range(geodat$Longitude_degrees_east)

# make new variable for corrected values
longitude_corrected = geodat$Longitude_degrees_east
range(longitude_corrected)
# change those with values greater than 180, and move them to other hemisphere
longitude_corrected[ longitude_corrected > 180 ] = longitude_corrected[ longitude_corrected > 180 ] - 360
range(longitude_corrected)

# draw world map
worldmap = map( database="world" )

# draw world map, and plot some points on it
# firstly, for all places with points, then for places where the deep water is more than 10 degrees
worldmap = map( database="world" , fill=TRUE, col="#efefef")
points( longitude_corrected , geodat$Latitude_degrees_north , col="#9999aa66")
points( longitude_corrected[is_deep_and_hot] , geodat$Latitude_degrees_north[is_deep_and_hot] , pch=16, col="red" )


# plot nitrate vs depth
plot( geodat$NITRATE_D_CONC_BOTTLE_umol.kg , geodat$DEPTH_m , ylim=c(7000,0) , pch=16, cex=1, col="#99666644" )
abline( v=6.5 )

# subset data based on NO3 concentration
is_low_nitrate = geodat$NITRATE_D_CONC_BOTTLE_umol.kg < 6.5
is_deep_and_low_nitate = is_low_nitrate & is_deep

is_mid_level_nitrate = geodat$NITRATE_D_CONC_BOTTLE_umol.kg > 6.5 & geodat$NITRATE_D_CONC_BOTTLE_umol.kg < 10
is_deep_and_mid_nitrate = is_mid_level_nitrate & is_deep

# use xlim and ylim to subset the map
worldmap = map( database="world" , fill=TRUE, col="#efefef", xlim=c(-20,40) , ylim=c(25,55))
points( longitude_corrected[is_deep_and_low_nitate] , geodat$Latitude_degrees_north[is_deep_and_low_nitate] , pch=16, col="green" )
points( longitude_corrected[is_deep_and_mid_nitrate] , geodat$Latitude_degrees_north[is_deep_and_mid_nitrate] , pch=16, col="#1289bd" )


