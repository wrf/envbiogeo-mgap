# day 2
#
# recall that lines starting with # are ignored

# this reads in the data
geodat <- read.delim("~/git/envbiogeo-mgap/datasets/GEOTRACES_IDP2021_Seawater_Discrete_Sample_Data_v1_nfYzzsKg.clean.txt")
head(geodat)

names(geodat)

table( geodat[,1] )

# make histograms of depth, or temperature
# use breaks= to set the number of bins, more breaks means finer resolution
hist( geodat$DEPTH_m , breaks=100 )
hist( geodat$CTDTMP_T_VALUE_SENSOR_deg.C , breaks=50)

plot( geodat$CTDTMP_T_VALUE_SENSOR_deg.C , geodat$DEPTH_m , ylim=c(7000,0) , pch=16, col="#abde1211")

# O2 has mirror of nutrient type profile
plot( geodat$OXYGEN_D_CONC_BOTTLE_umol.kg , geodat$DEPTH_m , ylim=c(7000,0) , pch=16, col="#128bde11" )

# NITRATE has nutrient type profile
plot( geodat$NITRATE_D_CONC_BOTTLE_umol.kg , geodat$DEPTH_m , ylim=c(7000,0) , pch=16, col="#122b6e11" )

# plot both Al and Fe
plot( geodat$Al_D_CONC_BOTTLE_nmol.kg , geodat$DEPTH_m , xlim=c(0,25), ylim=c(7000,0) , pch=16, cex=2, col="#8888aa22" )
points( geodat$Fe_D_CONC_BOTTLE_nmol.kg , geodat$DEPTH_m , pch=16, cex=2, col="#ee666644" )

# logical/boolean for
# "is or is not tropical latitude"
# makes a long list of either TRUE or FALSE values
is_tropical = ( -23 <= geodat$Latitude_degrees_north & geodat$Latitude_degrees_north <= 23)

# use ! to make "opposite of", so TRUE becomes FALSE
is_not_tropical = !is_tropical

# can subset two ways
# using $ variable name, and then subset
tropical_temps = geodat$CTDTMP_T_VALUE_SENSOR_deg.C[is_tropical]
# or use [row,column]
tropical_temps = geodat[is_tropical,30]


hist(tropical_temps)
# make subset plot of only tropical latitudes
plot( geodat$CTDTMP_T_VALUE_SENSOR_deg.C[is_tropical] , geodat$DEPTH_m[is_tropical] , ylim=c(7000,0) , pch=16, col="#abde1211")
# plot of high latitudes
plot( geodat$CTDTMP_T_VALUE_SENSOR_deg.C[is_not_tropical] , geodat$DEPTH_m[is_not_tropical] , ylim=c(7000,0) , pch=16, col="#abde1211")

# trying to identify streak of warm water at 2000-4000m deep
is_deep = geodat$DEPTH_m > 2000
is_warm = geodat$CTDTMP_T_VALUE_SENSOR_deg.C > 10
# can combine two logicals with &
is_deep_and_hot =  is_deep & is_warm
table(is_deep_and_hot)

# make a subset table of all rows that are deep and hot
# NOT DISCUSSED: we need to use droplevels() to remove entries with no data
high_temp_data = droplevels( geodat[is_deep_and_hot,] )

# see what cruises collected those data
table(high_temp_data$Cruise)

# number 1 was GA04N
was_first_cruise = geodat$Cruise == "GA04N"
table(was_first_cruise)
# plot the subset that shows the high temp + deep pattern
# for some reason ???
plot( geodat$CTDTMP_T_VALUE_SENSOR_deg.C[was_first_cruise] , geodat$DEPTH_m[was_first_cruise] , ylim=c(7000,0) , pch=16, col="#abde1211")




