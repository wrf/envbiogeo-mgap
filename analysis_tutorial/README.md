# Analysis of GEOTRACES in R #
Using data from the [GEOTRACES](https://www.geotraces.org/) database

[**DOWNLOAD DATA HERE**](https://bitbucket.org/wrf/datasets/downloads/GEOTRACES_IDP2021_Seawater_Discrete_Sample_Data_v1_nfYzzsKg.clean.zip)

It is advisable to first watch this [tutorial](https://www.rstudio.com/resources/webinars/a-gentle-introduction-to-tidy-statistics-in-r/) about using RStudio.

There are some handy references of commands for [base-R](https://raw.githubusercontent.com/rstudio/cheatsheets/master/base-r.pdf), [dplyr](https://raw.githubusercontent.com/rstudio/cheatsheets/master/data-transformation.pdf), and [ggplot](https://raw.githubusercontent.com/rstudio/cheatsheets/master/data-visualization.pdf).

For more details about statistics in R, see [learning statistics with R](https://learningstatisticswithr.com/), and another good place to start would be Chapter 3 of that book (free as a pdf). **IF YOU HAVE NEVER USED R OR ANY OTHER PROGRAMMING LANGUAGE, PLEASE READ CHAPTER 3, AND FOLLOW ALONG WITH RSTUDIO**.

### Getting started ###
R can run from the default starting directory, or can be changed to run and find files out of any given folder. You can see where the starting directory is (or current one, if changed) using the `getwd()` function.

```
> getwd()
[1] "/home/warren"
```

For example, I can set the directory to the github folder (on mac or linux). Here, `~` is a shortcut for the "home" folder. This can be set to any folder, and some input data files or output graphs will be automatically written to this folder, for convenience.

`setwd("~/git/envbiogeo-mgap/")`

Since we will be making use of the two extra libraries `dplyr` and `ggplot2`, we need to import them at the beginning.

```
library(ggplot2)
library(dplyr)
```

### Importing the data ###
The dataset is a large table of around 90k rows and 318 columns, which can be downloaded [here](https://bitbucket.org/wrf/datasets/downloads/GEOTRACES_IDP2021_Seawater_Discrete_Sample_Data_v1_nfYzzsKg.clean.zip). This needs to be unzipped first.

We can then load this table into R for processing with the `read.table()` function. Firstly, we specify what file to read in, by giving the path to that file (wherever it is on your computer). Two other options are specified, `head=TRUE`, meaning that the first line contains the column names, and `sep="\t"`, meaning that tabs are the separators (as opposed to commas, or something else).

```
geotrace_tm_file = "~/git/envbiogeo-mgap/datasets/GEOTRACES_IDP2021_Seawater_Discrete_Sample_Data_v1_nfYzzsKg.clean.txt"
geotrace_tm = read.table(geotrace_tm_file, head=TRUE, sep="\t")
```

**NOTE: if you are having difficulty finding the path to a file on your computer, in RStudio go to the "Import Dataset..." in the File menu, and choose "From Text (base)"** Find the file you are looking for, give it the name `geotrace_tm` (or any other relevant name), and it will import it and print the code to the console (as it appears below for my computer). Copy this and paste it into a script.

```
> geotrace_tm <- read.delim("~/git/envbiogeo-mgap/datasets/GEOTRACES_IDP2021_Seawater_Discrete_Sample_Data_v1_nfYzzsKg.clean.txt")
>   View(geotrace_tm)
```

Once it is read in, we can check basic things, like the dimensions of the table. The `dim()` function tells the number of rows and columns.

```
> dim(geotrace_tm)
[1] 96184   417
```

To see the column names, which we will later use to subset and analyze the table, we can use the `names()` function.

```
> names(geotrace_tm)
  [1] "Cruise"  
  [2] "Station"  
  [3] "Type"   
  [4] "yyyy.mm.ddThh.mm.ss.sss"  
  [5] "Longitude_degrees_east"  
  [6] "Latitude_degrees_north" 
  [7] "Bot..Depth_m" 
  [8] "Operators.Cruise.Name" 
  [9] "Ship.Name" 
 [10] "Period" 
 [11] "Chief.Scientist"
 ...
```

### Getting an overview of the dataset ###

![IDP2021_num_of_samples_by_year.png](https://github.com/wrf/envbiogeo-mgap/blob/main/images/IDP2021_num_of_samples_by_year.png)

We can get quick summaries from several functions.

For text columns, such as `$Chief.Scientist` or `$Ship.Name`, we can use the `unique()` function to give a vector with no duplicated entries. The order will be the order that they are encountered in the dataset.

```
> unique( geotrace_tm$Chief.Scientist )
 [1] Sarthou Geraldine               Rijkenberg Micha               
 [3] Gerringa Loes                   Boyle Edward                   
 [5] Jenkins William                 Ziveri Patrizia 
 ...
```

Suppose for some reason we want counts instead of just removing duplicates (say to make a summary table in a report), the `table()` function can be used the same way as `unique()`. We can see that this ordered the items alphabetically, and that the names are given as last-first.

```
> table( geotrace_tm$Chief.Scientist )

                Achterberg Eric          Alderkamp Anne-Carlijn 
                           1180                             369 
                      Ali Sajid                  Blain Stephane 
                            335                            2647 
                ...
```

If instead we want the top 10 or something similar, we can sort them by counts with the `sort()` function. We can even do this on the same line as `table()` by putting the `table()` inside of the `sort()` parentheses.

`sort( table( geotrace_tm$Chief.Scientist ) )`

We have to scroll to the bottom to get the most frequent. If we want them as most frequent first, we have to specify that we want the items in descending order.

`sort( table( geotrace_tm$Chief.Scientist ), decreasing = TRUE)`

For numerical columns, we instead can get a quick summary using the `hist()` plot, which makes a histogram in the plot window at the bottom right. For some cases, we can also use `table()`, but since that counts exact values, we would want to use it for something like years, or for rounded values with the `round()` function.

`hist( geotrace_tm$CTDTMP_T_VALUE_SENSOR_deg.C )` 

We could use `hist()` for any of the nutrients or trace metals as well.

Other useful functions include `head()` which gives the first 6 items or rows of a dataset, `summary()` which gives summary statistics (min/max/mean) for each column in a dataset, or `glimpse()` which prints the first columns for each row (from the `dplyr` package).

### Graphing points and lines ###
Suppose we want to check if the CTD sensor of salinity and the measured [Niskin bottle](https://en.wikipedia.org/wiki/Nansen_bottle) salinity are the same.

Using R base graphics, we can make use of the `plot()` function to draw scatter plots, as well as many other plot types.

`plot(geotrace_tm$CTDSAL_D_CONC_SENSOR_pss.78, geotrace_tm$SALINITY_D_CONC_BOTTLE )`

![IDP2021_ctd_salinity_vs_bottle.png](https://github.com/wrf/envbiogeo-mgap/blob/main/images/IDP2021_ctd_salinity_vs_bottle.png)


While it generally shows that the two measurements are quite close, this plot does not look very good. We should:

* adjust the axes to make the bulk of the data fit into the plot
* fix the label sizes
* relabel the axis with meaningful labels and units
* change the shape and/or color of the points

In base R, we do this by adding a few more arguments to the `plot()`. For very long lists of arguments in functions, we are allowed to split them onto different lines to improve readability.

```
plot(geotrace_tm$CTDSAL_D_CONC_SENSOR_pss.78, geotrace_tm$SALINITY_D_CONC_BOTTLE, 
     xlim=c(20,40), ylim=c(20,40), frame.plot=FALSE,
     pch=16, col="#db6a0044", cex=2,
     xlab="CTD Salinity (0/00)", ylab="Bottle Salinity (0/00)", cex.lab=1.4 )
```

* `xlim=c(20,40), ylim=c(20,40),` specify the limits of the x and y axes, with 2 numbers inside of a vector `c()`
* `frame.plot=FALSE` removes the black square border around the whole plot
* `pch=16` changes the point to solid circles, instead of rings. There are 25 symbol options in base R.
* `col="#db6a0044"` sets the color of the points to orange, as defined by hex values of red-green-blue, `"#RRGGBB"` where each `RR` `GG` and `BB` can take a value from 0 to 255, as 2 hexadecimal values. `#00` is zero, `#ff` is 255. In base R, the 7th and 8th positions can be used to define the **alpha**, which is the transparency, and here `44` would be 25%, meaning 75% transparent. We also could define the colors by name, using the [CSS colors](https://www.w3docs.com/learn-css/css-color-names.html). That could be written as `col="DarkOrange"` with the name in quotes, but no `#` symbol.
* `cex=2` "character expansion" changes the size of the points, 1 is default, so numbers larger than 1 makes the points larger
* `xlab="CTD Salinity (0/00)", ylab="Bottle Salinity (0/00)"` changes the axis labels, units of salinity are g/kg, meaning per mille (0/00)
* `cex.lab=1.4` changes the size of the labels


![IDP2021_ctd_salinity_vs_bottle_baseR.png](https://github.com/wrf/envbiogeo-mgap/blob/main/images/IDP2021_ctd_salinity_vs_bottle_baseR.png)

The same thing can be plotted with `ggplot()`, though the syntax is rather different. The first term is the dataset (here as `geotrace_tm`, and columns are specified by name. Changes to the default parameters are added functions using the `+` sign, rather than arguments within a function.

```
ggplot(geotrace_tm, aes(x=CTDSAL_D_CONC_SENSOR_pss.78, y=SALINITY_D_CONC_BOTTLE)) +
  scale_x_continuous( limits=c(20,40) ) +
  scale_y_continuous( limits=c(20,40) ) +
  geom_point( color="#db6a00", alpha=0.25, size=4)
```

![IDP2021_ctd_salinity_vs_bottle_ggplot.png](https://github.com/wrf/envbiogeo-mgap/blob/main/images/IDP2021_ctd_salinity_vs_bottle_ggplot.png)

While in many ways, base plot is simpler and easier to use, there are some limitations. Suppose we want to plot temperature traces by depth, and show each trace for each cast as a line. We can set the plot mode to `type="l"` meaning draw lines instead of points. We also set the y-limits to `c(6000,0)`, which will draw the axis as reversed, so the surface of the ocean will appear at the top of the plot.

```
plot( geotrace_tm$CTDTMP_T_VALUE_SENSOR_deg.C, geotrace_tm$DEPTH_m, type="l",
      xlim=c(-5,35), ylim=c(6000,0) )
```

![IDP2021_temp_vs_depth_baseR.png](https://github.com/wrf/envbiogeo-mgap/blob/main/images/IDP2021_temp_vs_depth_baseR.png)

...but this gives a huge mess that could belong in a modern art museum. It treats the whole dataset as one continuous line, so individual traces are not clear. We instead want ~5000 separate lines for the ~5000 casts. This is fairly easy with `ggplot()`, making use of the `group=` aesthetic attribute. This means that lines will be grouped by some factor, here we are using the `Cast.Identifier` in the dataset, a unique value for each cast/series of samples. Just as above, we also invert the y-axis by adding `scale_y_reverse()`.

```
ggplot(geotrace_tm, aes(x=CTDTMP_T_VALUE_SENSOR_deg.C , y=DEPTH_m , group=Cast.Identifier)) +
  scale_y_reverse() +
  geom_line( color="#77223a" , alpha=0.05, size=1)
```

Because we are drawing a lot of lines, they would normally overshadow each other a lot, so we want to set the alpha very low, here using `0.05`. Any given line is almost transparent, but we can see the general trends very well, such as the overall temperature of the ocean.

![IDP2021_temp_vs_depth_ggplot.png](https://github.com/wrf/envbiogeo-mgap/blob/main/images/IDP2021_temp_vs_depth_ggplot.png)

If for some reason we did not want the connectivity between samples, we can draw it as points using `geom_point()` instead of `geom_line()`.

```
ggplot(geotrace_tm, aes(x=CTDTMP_T_VALUE_SENSOR_deg.C , y=DEPTH_m )) +
  scale_y_reverse() +
  geom_point( color="#bc99ab" , alpha=0.05, size=4)
```

We can plot other things in the same way, like oxygen. Note the oxygen minimum zones, as well as regions of extremely high oxygen at the surface (where are they?)

```
oxygl = ggplot(geotrace_tm, aes(x=CTDOXY_D_CONC_SENSOR_umol.kg , y=DEPTH_m , group=Cast.Identifier)) +
  scale_y_reverse( limits=c(6000,0)) +
  geom_line( color="#1b5a99" , alpha=0.05, size=1)
oxygl
```

![IDP2021_depth_vs_oxygen_ggplot.png](https://github.com/wrf/envbiogeo-mgap/blob/main/images/IDP2021_depth_vs_oxygen_ggplot.png)

### Examining distribution of aluminium ###
The first element in the table is aluminium (alphabetically, not atomic number or abundance of samples). We can plot this against depth, just as above.

```
dg = ggplot(geotrace_tm, aes(x=Al_D_CONC_BOTTLE_nmol.kg , y=DEPTH_m ) ) +
  scale_y_reverse(limits=c(6000,0)) +
  geom_point( color="#8888aa" , alpha=0.3, size=4)
```

This can also be done as lines, as above, again making use of `group=Cast.Identifier`.

Suppose we want to highlight some subset of the data in the graph, such as the samples with relatively high aluminium concentrations. There are a few ways of doing this. One would be to make an additional column and specify the color of each point in that column. The other would be to subset the data, then redraw and overlay the points of interest - shown below. Samples with concentration above 100 nmol/kg are then highlighted in red.

```
aldg = ggplot(geotrace_tm, aes(x=Al_D_CONC_BOTTLE_nmol.kg , y=DEPTH_m ) ) +
  scale_y_reverse(limits=c(6000,0)) +
  geom_point( color="#8888aa" , alpha=0.3, size=4) +
  geom_point( data=filter(geotrace_tm, Al_D_CONC_BOTTLE_nmol.kg > 100), color="#ee0000", alpha=0.3, size=4)
aldg
```

![IDP2021_aluminium_depth_w_red.png](https://github.com/wrf/envbiogeo-mgap/blob/main/images/IDP2021_aluminium_depth_w_red.png)

To specify the color of points and make a new column, we use the `mutate()` function in `dplyr`. A few additional lines are needed such as defining the colors with `scale_color_manual( values=c("#8888aa","#ee0000" ) )` and removing the automatic legend with `theme(legend.position = "none")`.

```
aldg = geotrace_tm %>%
  mutate(concgrp = (Al_D_CONC_BOTTLE_nmol.kg > 100) ) %>%
  ggplot( aes(x=Al_D_CONC_BOTTLE_nmol.kg , y=DEPTH_m , color=concgrp ) ) +
  scale_y_reverse(limits=c(6000,0)) +
  scale_color_manual( values=c("#8888aa","#ee0000" ) ) +
  theme(legend.position = "none") +
  geom_point( alpha=0.3, size=4)
aldg
```

Where are these samples? We can examine this by checking and filtering the table, or graphically by plotting them onto a map. For instance, we can combine the two functions `filter()` and `summary()`.

### Making a global map ###
Suppose we now want to highlight those red points on a map, to know where they occur on the planet. We will need to first make some adjustments to the data. If we check the range of the latitude and longitude, we can see that latitude runs from the south pole to north pole, but longitude is defined starting at 0 and going to 360. In R, the default maps define longitude as -180 to +180, so we need to adjust all the points from 180 to 360 into values of -180 to 0.

```
> range( geotrace_tm$Longitude_degrees_east )
[1]   0.0000 359.9999
> range( geotrace_tm$Latitude_degrees_north )
[1] -71.6993  89.9905
```

We can do this by creating a new variable that will become a new column. This starts with the values of the longitude. Values from 0-180 should stay the same, but values greater than 180 need to be adjusted by 360 degrees. For instance, a longitude of 359 will be slightly west of London, so should end up as -1, thus we need to subtract 360 from all values greater than 180.

```
longitude_adj = geotrace_tm$Longitude_degrees_east
longitude_adj[longitude_adj > 180] = longitude_adj[longitude_adj > 180] - 360
tm_short = cbind( select(geotrace_tm, Al_D_CONC_BOTTLE_nmol.kg , DEPTH_m , Latitude_degrees_north ), longitude_adj )
```

Next, we draw a map of only the outlines of the countries, and will plot the points on top of that.

```
worldpolygons = map_data("world")

gt_gg = ggplot(worldpolygons) +
  coord_cartesian(expand = c(0,0)) +
  labs(x=NULL, y=NULL) +
  theme_bw() +
  geom_polygon( aes(x=long, y = lat, group = group), fill="#cdcdcd", colour="#ffffff") +
  geom_point(data=tm_short, aes( x=longitude_adj, y=Latitude_degrees_north ), color="#8888aa", alpha=0.2, size=2 ) +
  geom_point(data=filter(tm_short, Al_D_CONC_BOTTLE_nmol.kg > 100), aes( x=longitude_adj, y=Latitude_degrees_north ), color="#ee0000", alpha=0.3, size=2 )

gt_gg
ggsave(file="~/project/oceanography/geotraces/geotraces_2021_aluminium_map_w_red.pdf", gt_gg, device="pdf", width=12, height=6)
```

![IDP2021_aluminium_map_w_red.png](https://github.com/wrf/envbiogeo-mgap/blob/main/images/IDP2021_aluminium_map_w_red.png)


We can see that the high-aluminium samples are entirely within the Mediterranean. Why could that be? again, consult the literature to see if this is known, check the review by [Bruland 2003](https://doi.org/10.1016/B0-08-043751-6/06105-3).


