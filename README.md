# Global Cycles 2021 #
information and code for course projects for the [biogeochemical cycles class](https://www.mgap.geo.uni-muenchen.de/index.html) in 2021

The project will consist of:

* 8-10 page report featuring primary analysis about a nutrient/element of choice (at least one, or combinations for rarer ones) from the GEOTRACES database
* include an introduction, brief methods, results/description of observations, discussion, figures (roughly 1 page of combined figures) and references
* can be a global overview, or detailed about a location of interest; this can be determined after beginning to look at the data
* short overview presentation/discussion (1-3 slides, 5 min + questions) for the final day of class, possibly not very formal

The following items can be used by all for comparison:

```
CTDPRS_T_VALUE_SENSOR_dbar       CTDTMP_T_VALUE_SENSOR_deg.C
CTDSAL_D_CONC_SENSOR_pss.78      SALINITY_D_CONC_BOTTLE
OXYGEN_D_CONC_BOTTLE_umol.kg     CTDOXY_D_CONC_SENSOR_umol.kg
PHOSPHATE_D_CONC_BOTTLE_umol.kg  SILICATE_D_CONC_BOTTLE_umol.kg
NITRATE_D_CONC_BOTTLE_umol.kg    NITRITE_D_CONC_BOTTLE_umol.kg
PH_TOT_BOTTLE                    TALK_D_CONC_BOTTLE_umol
DIC_D_CONC_BOTTLE_umol
```

## Using the GEOTRACES database ##
We will make use of recently collected data from the [GEOTRACES](https://www.geotraces.org/) database (part of [SCOR](https://scor-int.org/scor/about/)), which collects data on marine trace metal concentrations from around the world. The cruise tracks can be viewed [here](https://www.egeotraces.org/).

The basic dataset we will be using for the course consists of ~90k samples. [CTD data](https://oceanexplorer.noaa.gov/technology/ctd/ctd.html) are available for most samples, while the trace metals in the set have around 1k to 10k samples. These data were minimally processed for use in R, only by changing some symbols to allow smooth importing. The raw data can be downloaded at the [webODV website](https://geotraces.webodv.awi.de/) if necessary.

Some [publications and reviews have already been generated](https://royalsocietypublishing.org/toc/rsta/374/2081) using the GEOTRACES datasets.

We are not restricted to GEOTRACES. Other datasets would be allowed for comparisons, such as the [NOAA World Ocean Database dataset](https://www.ncei.noaa.gov/access/world-ocean-database-select/dbsearch.html) (better for longer timeseries studies), or the [Integrated Ocean Drilling Program](https://www.iodp.org/resources/access-data-and-samples) datasets.

## Setting up R ##
For the analysis portion, we will be using the programming/statistics [language R](https://en.wikipedia.org/wiki/R_(programming_language)).

It is probably best to use a development environment like [RStudio](https://www.rstudio.com/). R-base (files of the programming language) must be installed on your system first. If you *have* used R before, and have a preferred working environment, you can of course use that instead.

RStudio can be [downloaded here](https://www.rstudio.com/products/rstudio/download/) (get the Desktop version), and Rbase can be [downloaded here](https://cran.rstudio.com/), for MacOS, Windows, or Linux.

For an overview tutorial about RStudio and R, first watch this [tutorial](https://www.rstudio.com/resources/webinars/a-gentle-introduction-to-tidy-statistics-in-r/) about using RStudio.

For more details about statistics in R, see [learning statistics with R](https://learningstatisticswithr.com/), and another good place to start would be Chapter 3 of that book (free as a pdf). **IF YOU HAVE NEVER USED R OR ANY OTHER PROGRAMMING LANGUAGE, PLEASE READ CHAPTER 3, AND FOLLOW ALONG WITH RSTUDIO**. Note: this is *Chapter 3: Getting started with R* **NOT** *Section III Working with data*.

We will make frequent use of two supplemental packages: [dplyr](https://dplyr.tidyverse.org/) for data management/organization, and [ggplot](https://ggplot2.tidyverse.org/) for mapping/plotting. These can be installed from the `Tools` -> `Install Packages...` menus in RStudio. The usage of those two packages differs substantially from standard R, and it may seem like it is almost another language.

## Analysis of GEOTRACES in R ##

The basic dataset can be downloaded [here](https://bitbucket.org/wrf/datasets/downloads/GEOTRACES_IDP2021_Seawater_Discrete_Sample_Data_v1_nfYzzsKg.clean.zip). This includes sample metadata, nutrients, trace metals, radionuclides, and dissolved rare earth elements.

We will be starting with the sort of analyses in this [tutorial](https://github.com/wrf/envbiogeo-mgap/tree/main/analysis_tutorial).

### Intro or Discussion ###

For the discussion about the nutrient or metal, consider trying to answer some of the following questions:

* is it evenly distributed around the world? do some ocean basins have more or less?
* is it constant with depth? does it have a conservative, nutrient, or scavenged profile? see review by [Bruland 2003](https://doi.org/10.1016/B0-08-043751-6/06105-3)
* do organisms use this substance, say for enzymes? which enzymes, and which biological processes? check [KEGG](https://www.kegg.jp/kegg/kegg2.html) or [Uniprot DB](https://www.uniprot.org/)
* are there natural sources, say from volcanoes or rivers? how much does this contribute?
* are there human sources, say from industrial processes? which ones? what do they make? is that region well known for that industry? does this industry cause other problems?




# Other links #
* video of carbon cycle https://www.youtube.com/watch?v=dwVsD9CiokY

