# day 4
# more mapping

library(maps)

geodat <- read.delim("~/git/envbiogeo-mgap/datasets/GEOTRACES_IDP2021_Seawater_Discrete_Sample_Data_v1_nfYzzsKg.clean.txt")

# changing colors of points based on the value/concentration
# using oxygen as an example
plot( geodat$OXYGEN_D_CONC_BOTTLE_umol.kg , geodat$DEPTH_m , ylim=c(7000,0) , pch=16, col="#128bde11" )
# change the y limits to look at shallow samples
plot( geodat$OXYGEN_D_CONC_BOTTLE_umol.kg , geodat$DEPTH_m , ylim=c(1000,0) , pch=16, col="#128bde11" )

# points on the map are all overlaid, so deep and shallow all appear mashed on top of each other
# take a subset of datapoints that occur near the surface
is_surface_sample = geodat$DEPTH_m < 20
table(is_surface_sample)

# all samples have a depth, so range gives numbers
range(geodat$DEPTH_m[is_surface_sample])

# some samples are NA, so range does not work
range(geodat$OXYGEN_D_CONC_BOTTLE_umol.kg[is_surface_sample])

# hist() still gives us a good overview of the range, without the NAs
hist(geodat$OXYGEN_D_CONC_BOTTLE_umol.kg[is_surface_sample])

# define some colors, could be anything
oxygen_colors = c("red", "orange", "yellow", "blue", "darkblue")
# could also use #RRGGBB
oxygen_colors = c("#891212", "#C38809", "#FFFF00", "#888844", "#121289")

# make a quick plot to see what the colors look like
# here, the syntax 1:5 means make a list of 1 to 5, same as c(1,2,3,4,5)
barplot(1:5, col=oxygen_colors)
# could also use rep(1,5), meaning repeat 1 5x times, since there are 5 colors
barplot( rep(1,5), col=oxygen_colors)
# we could make this generic for any number, using length()
barplot( rep(1,length(oxygen_colors) ), col=oxygen_colors)

# filter samples that actually have O2 measurements
# could do the same for any element
has_oxygen_measurement = !is.na(geodat$OXYGEN_D_CONC_BOTTLE_umol.kg)
table(has_oxygen_measurement)

# combine, and now range() works
shallow_w_oxygen = has_oxygen_measurement & is_surface_sample
table(shallow_w_oxygen)
range(geodat$OXYGEN_D_CONC_BOTTLE_umol.kg[shallow_w_oxygen])

# oxygen_colors can be indexed with []
# prints all
oxygen_colors
# prints the first color
oxygen_colors[1]
# can give a list... to print the first one 3x
oxygen_colors[ c(1,1,1) ]

# each point on the map should be assigned a color
# based on the O2 concentration
# meaning each point needs to be assigned an index of 1 to 5, for the 5 colors
# we can do that by directly processing the values (1 to 458uM) into those numbers
# here we divide by 100 and round up with ceiling()
sample_color_index = ceiling( geodat$OXYGEN_D_CONC_BOTTLE_umol.kg[shallow_w_oxygen] / 100 )
# makes a long vector of numbers, ranging from 1 to 5
sample_color_index
sample_colors = oxygen_colors[sample_color_index]

# fix the longitude, as on day 3
longitude_corrected = geodat$Longitude_degrees_east
longitude_corrected[ longitude_corrected > 180 ] = longitude_corrected[ longitude_corrected > 180 ] - 360

# plot the map, and subset the points using shallow_w_oxygen
# for col=  we use sample_colors
worldmap = map( database="world" , fill=TRUE, col="#efefef")
points( longitude_corrected[shallow_w_oxygen] , geodat$Latitude_degrees_north[shallow_w_oxygen] , col=sample_colors, pch=16)

# take a subsample of data points in the OMZ, from 500 to 600m deep
is_midwater = geodat$DEPTH_m < 600 & geodat$DEPTH_m > 500
table(is_midwater)
midwater_w_oxygen = has_oxygen_measurement & is_midwater
table(midwater_w_oxygen)
# values are different at depth, so reassign the colors again
sample_color_index = ceiling( geodat$OXYGEN_D_CONC_BOTTLE_umol.kg[midwater_w_oxygen] / 100 )
sample_colors = oxygen_colors[sample_color_index]
# plot the map, this time showing 500-600m
worldmap = map( database="world" , fill=TRUE, col="#efefef")
points( longitude_corrected[midwater_w_oxygen] , geodat$Latitude_degrees_north[midwater_w_oxygen] , col=sample_colors, pch=16)

# instead of binning the colors in 100uM bins, we can make a smoother gradient
# using colorRampPalette() for however many colors we want
# we have to put (320)  in another set of parentheses
# colorRampPalette() take an argument of a vector of colors, 2 or more
# can be specified with #RRGGBB or by name
oxygen_colors = colorRampPalette( c("#891212", "yellow", "#121289") )(320)
oxygen_colors
# plot to quickly view the colors/gradient
plot(1:320, rep(1,320), pch=16, col=oxygen_colors)
# this time, no need to divide, could round instead
sample_color_index = round( geodat$OXYGEN_D_CONC_BOTTLE_umol.kg[midwater_w_oxygen] )
sample_colors = oxygen_colors[sample_color_index]
# it is not even necessary, since it will automatically round if nothing is specified
sample_colors = oxygen_colors[ geodat$OXYGEN_D_CONC_BOTTLE_umol.kg[midwater_w_oxygen] ]
sample_colors
worldmap = map( database="world" , fill=TRUE, col="#efefef")
points( longitude_corrected[midwater_w_oxygen] , geodat$Latitude_degrees_north[midwater_w_oxygen] , col=sample_colors, pch=16)


#
# try plotting some other elements to see the patterns
#
# typical nutrient type with Si
plot( geodat$SILICATE_D_CONC_BOTTLE_umol.kg , geodat$DEPTH_m , ylim=c(7000,0) , pch=16, col="#88419d11" )
# nitrite
plot( geodat$NITRITE_D_CONC_BOTTLE_umol.kg , geodat$DEPTH_m , ylim=c(7000,0) , pch=16, col="#6a51a311" )

# CFCs
plot( geodat$CFC.11_D_CONC_BOTTLE_pmol.kg , geodat$DEPTH_m , ylim=c(7000,0) , pch=16, col="#12ae6b22" )
# change y axis, showing possible temp factor
plot( geodat$CFC.11_D_CONC_BOTTLE_pmol.kg , geodat$CTDTMP_T_VALUE_SENSOR_deg.C , pch=16, col="#12ae6b22" )

# possible nutrient like pattern of Y
plot( geodat$Y_D_CONC_BOTTLE_pmol.kg , geodat$DEPTH_m , ylim=c(5000,0) , pch=16, col="#dd349722" )
# possible scavenged pattern of Mo
plot( geodat$Mo_D_CONC_BOTTLE_nmol.kg , geodat$DEPTH_m , ylim=c(5000,0) , pch=16, col="#41b6c422" )




