#########################################################################
### Example script to read the shapefiles from Willamette INFEWS outputs
### By Mikey Johnson, Last edited 2020-09-10
#########################################################################

# Loading Libraries
library(rgdal)     # geospatial data
library(ggplot2)   # easy plotting
library(cowplot)   # publication quality figures
library(tidyverse) # data science package collection
library(broom)     # data managment tidy and standard functions


# Setting the working directory
# This will be the same layers as the "Map_Year2014_Demo_Run0" files
sfl <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(sfl)


# Loading the Shapefile
test <- readOGR("Map_Year2014_Demo_Run0.shp")  # loading the shapefile
names(test)                                    # printing all the variable names

# Converting the Shapefile to a Data Frame
test_tidy <- tidy(test)                        # Shapefiel to dataframe
test$id <- row.names(test)                     # adding row to the shape file data, for joining the data
test_tidy <- left_join(test_tidy, test@data)   # joining the shapefile data to the dataframe
names(test_tidy)                               # printing all the variable name


# Plotting the data
ggplot(data = test_tidy)+
  geom_polygon(aes(x=long, y=lat, group=group, fill=IDU_Area))

ggplot(data = test_tidy)+
  geom_polygon(aes(x=long, y=lat, group=group, fill=nlcd_desc))

ggplot(data = test_tidy)+
  geom_polygon(aes(x=long, y=lat, group=group, fill=TREE_HT))


# Plotting the shapefile
ggplot(data = test_tidy)+
  geom_path(aes(x=long, y=lat, group=group))


# More complicated SWE plot
ggplot(data = test_tidy)+
  geom_polygon(aes(x=long, y=lat, group=group, fill=SNOWPACK))+
  scale_fill_continuous(low = "white", high = "blue",
                        limits = c(50,3200), breaks = seq(500, 3500, 500),
                        guide = guide_colourbar(nbin=100, draw.ulim = FALSE, draw.llim = FALSE))


# filtering the data to a smaller dataframe
test_tidy_filtered <- test_tidy %>% select("long",
                                           "lat",
                                           "order",
                                           "hole",
                                           "piece",
                                           "group",
                                           "id",
                                           "SNOWPACK")



