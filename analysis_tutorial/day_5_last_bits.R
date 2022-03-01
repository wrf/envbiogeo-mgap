# day 5
# last bits, trying ggplot

library(maps)
library(ggplot2)

# read data as before
geodat <- read.delim("~/git/envbiogeo-mgap/datasets/GEOTRACES_IDP2021_Seawater_Discrete_Sample_Data_v1_nfYzzsKg.clean.txt")

# plotting two elements, and adding legend
plot( geodat$Cd_D_CONC_BOTTLE_nmol.kg , geodat$DEPTH_m , 
      ylim=c(1000,0) , pch=16, col="#88419d11" , cex=2,
      xlab="Cd (nmol/kg)", ylab="Depth (m)", cex.axis=1.4, cex.lab=1.4 )
points( geodat$Fe_D_CONC_BOTTLE_nmol.kg , geodat$DEPTH_m , cex=2,
        col="#99771211", pch=16)
legend( 1, 700 , legend=c("Cadmium", "Iron"), col=c("#88419d", "#997712"), 
        pch=16, pt.cex=5)

# making subset table of only one element
# that is, the table contains only rows that have a value for that element, meaning no NAs
# this can be useful if all other operations/plots etc will be only this element
geodat_fe = geodat[!is.na(geodat$Fe_D_CONC_BOTTLE_nmol.kg),]

# to make a blank plot, use type='n'
# this can be useful if multiple lines or points will go onto the plot with other commands
plot( geodat_fe$Fe_D_CONC_BOTTLE_nmol.kg , geodat_fe$DEPTH_m, 
      type='n', ylim=c(5000,0), xlim=c(0,10) )

# try using ggplot
# need to specify the x and y axis differently
# using the aes() function inside ggplot
# Cast.Identifier is used, meaning that each cast will be a separate line
# clearly there is an erroneous point
ggplot(geodat_fe, aes(x=Fe_D_CONC_BOTTLE_nmol.kg , y=DEPTH_m , group=Cast.Identifier ) ) +
         geom_line()

length( unique( geodat_fe$Cast.Identifier ) )
geodat_fe$NITRATE_D_CONC_BOTTLE_umol.kg

# extra parameters are added together with +
# instead of being options in plot() function
# the ggplot can also be saved as a variable
feplot = ggplot(geodat_fe, aes(x=Fe_D_CONC_BOTTLE_nmol.kg , y=DEPTH_m , group=Cast.Identifier)) +
  scale_y_reverse( limits=c(5000,0) ) +
  scale_x_continuous( limits=c(0,2) ) +
  geom_line( color="#771299" , alpha=0.05, size=1 )
# and called by itself
feplot
# or used to write to pdf
ggsave(file="~/git/envbiogeo-mgap/fe_traces_by_depth.pdf", feplot, device="pdf", width=8, height=7)




