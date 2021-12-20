# day 1

# lines that begin with a '#' are ignored as code
# this is you can write notes to yourself

# variable assignment
x = 5

y = 3

z = x * y

# making vectors of numbers
l = c( 1 , 5 , 9 , 16 )
m = c(7, 8, 9, 10)

# make scatterplot of l values as x axis and m values as y axis
plot( l, m )

# make barplot of just m
barplot( m )

# reverse order with rev()
barplot( rev(m) )

# read in tab-delimited text file of chromium isotope data
# from Canfield 2018

# the full path to the file (ie folders and everything)
# must be given in quotes "
# might be something like "C:/user/Desktop/something/something/my_stuff/the_file.txt"
chromium_data = read.table( "~/git/envbiogeo-mgap/chromium_fractions_2018.txt", 
                            header=TRUE , 
                            sep="\t" )
# you can also use File > Import Dataset > From text
# and be sure to copy the code from the console!

# print first few lines of a dataset, to see what it looks like
head( chromium_data )

# subset data with [,]
# as [rows, columns]
# print column 2, for all rows
chromium_data[ , 2 ]

# make histogram of column 2
hist( chromium_data[ , 2 ] , breaks=20 )

# print column 3, for all rows
chromium_data[,3]

# make a table of counts of column 3, and sort them
sort( table( chromium_data[,3]  ) )

# make a barplot
barplot( sort( table( chromium_data[,3]  ) ) , horiz=TRUE , las=1)


# plot column 2 vs column 4
# change x axis to reverse order with xlim=c(2000,0)
# define colors as either "red" or "#aabbcc" 
# with two digits each for red green and blue, RRGGBB
# two extra digits can be used to define alpha/transparency
# cex changes point or letter size

plot( chromium_data[,2] , chromium_data[,4] , xlim=c(2000,0) , pch=16,
      col="#8612a688" , cex=3, cex.lab=1.5, cex.axis=1.5,  
      xlab="Rock age (Ma)" , ylab="d53Cr")

plot( chromium_data[,2] , chromium_data[,4] , xlim=c(2000,0) , pch=21,
      bg="#8612a688" , cex=3, cex.lab=1.5, cex.axis=1.5,  
      xlab="Rock age (Ma)" , ylab="d53Cr")
abline( h=1 , lty=2 , col="gray" )






