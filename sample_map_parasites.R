#### Create a map of fish for parasite project ####
setwd("/Users/jenniferhoey/Documents/Graduate School/Rutgers/Summer Flounder/Maps")

library(maps)
library(mapdata)
library(plotly)
library(plyr)
library(scales)

pade <- read.csv("~/Documents/Graduate School/Rutgers/Summer Flounder/Adults/seamap_parasites_locations.csv") #my data for full-bodied adult sampling sites

pade.sum <- ddply(pade,.(lat,lon),nrow) # basically counts number of lat/lon combos
pade.ord <- pade.sum[order(-pade.sum$V1),] # order so it is easy to how many fish are at a particular lat/lon

# radius <- sqrt(pade.sum$V1/pi) # rescale so that circle area (versus radius) reflects number of fish

# Create fake data for legend
lat <- c(28.6, 28, 27.2, 26.2)
lon <- c(-75, -75, -75, -75)
V1 <- c(1, 3, 5, 7)
legend.coor <- as.data.frame(cbind(lat, lon, V1))

all <- rbind(pade.ord, legend.coor)
radius <- sqrt(all$V1/pi) # rescale so that circle area (versus radius) reflects number of fish
symbols(all$lon, all$lat,circles = radius, xlim=c(-85,-72), ylim=c(23,36), inches = 0.2, bg = "#0000FF80")

# Plot map!
png(file="~/Documents/Graduate School/Rutgers/Summer Flounder/Maps/parasite_map.png", width=6, height=6.5, res=300, units="in")

par(
  mar=c(5, 7, 4, 2), # panel magin size in "line number" units
  mgp=c(3, 1, 0), # default is c(3,1,0); line number for axis label, tick label, axis
  tcl=-0.5, # size of tick marks as distance INTO figure (negative means pointing outward)
  cex=1, # character expansion factor; keep as 1; if you have a many-panel figure, they start changing the default!
  ps=18, # point size, which is the font size
  bg=NA
)

map("worldHires", c("us", "canada", "bah", "cub"), xlim=c(-85,-72), ylim=c(23,36), col="gray90", fill=TRUE) #plots the region of the USA & canada that I want
map("state", xlim=c(-85,-72), ylim=c(23,36), add = TRUE, boundary=FALSE, col = 'black') # plots US state boundaries
title(xlab = "Longitude (°)", ylab = "Latitude (°)")

axis(1, at=seq(-85,-72, by=5), labels=seq(-85,-72, by= 5))
axis(2, at=seq(20,36, by = 5), labels=seq(20,36, by= 5), las = TRUE)
box()
text(-75,32, expression(italic("Atlantic Ocean")))

text(-74.5, 29.3, expression(underline("# of fish")), cex=0.75)
text(-74.2,28.6, "1", cex=0.65)
text(-74.1,28, "3", cex=0.65)
text(-74,27.2, "5", cex=0.65)
text(-73.9,26.2, "7", cex=0.65)

# Plot symbols last
symbols(all$lon, all$lat,circles = radius, xlim=c(-85,-70), ylim=c(23,36), inches = 0.16, bg = "#0000FF80", add = TRUE)

# points(c(-77.8666,-80.8605,-76.6197,-77.8958), c(34.0452,31.9016,34.6667,33.7128), col = 'tomato', pch = 17, bg = 'black')

dev.off()
