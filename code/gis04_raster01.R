
if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               terra,
               tidyterra,
               mapview,
               stars)
# data format
(spr_ex <- rast("data/spr_example.tif"))
# overwrite = TRUE enables overwriting
writeRaster(x = spr_ex, 
            filename = "data/spr_elev.tif",
            overwrite = TRUE)
# visualize raster data; geom_spatraster() (from "tidyterre" package)
ggplot() +
  geom_spatraster(
    data = spr_ex
    )
# if you want mapview() version to work 
star_ex <- st_as_stars(spr_ex)
mapview(star_ex)

#Data type in raster
  #continuous
v_elev <- values(spr_ex)

extract(spr_ex, y = cbind(6.0000, 50.0000))

# pick three spots from the map

extract(spr_ex, y = cbind(5.9, 49.85))
 #lowest
extract(spr_ex, y = cbind(6.1, 49.7))

#random
extract(spr_ex, y = cbind(6.4, 49.8))

#extract data at multiple points
(df_point <- tibble(
  lon = c(6, 5.9), 
  lat = c(50, 49.96)))

extract(spr_ex, y = df_point)

#discrete data
#0, 1 binary representation
## load forest raster
(spr_for <- rast("data/spr_forest_nc.tif"))

ggplot() +
  geom_spatraster(data = spr_for)

unique(spr_for)

v_binary <- values(spr_for)
(p_forest <- mean(v_binary))
mean(v_binary)*100

# multiple classes - code values with multiple categories
(spr_land <- rast("data/spr_land_reclass.tif"))

#1001 = forest
# 1010 = crop
# 1100 = urban 
unique(spr_land)

extract(spr_land, cbind(-79.8063, 36.0701))

# reclass
cm <- cbind(
  c(0, 1001, 1010, 1100),
             c(0, 1, 0, 0))

spr_bin <- classify(spr_land,
                    rcl = cm)

unique(spr_bin)

v_bin <- values(spr_bin)
mean(v_bin)* 100

# calculate % cropland
cm_crop <- cbind(
  c(0, 1001, 1010, 1100), 
  c(0, 0, 1, 0)
)

spr_crop <- classify( 
  x = spr_land, 
  rcl = cm_crop)

v_crop <- values(spr_crop)
mean(v_crop)
#calculate % urban  


cm_urban <- cbind(
  c(0, 1001, 1010, 1100), 
  c(0, 0, 0, 1)
)

spr_urban <- classify(spr_land, 
                      rcl = cm_urban)

unique(spr_urban) 
v_urban <- values(spr_urban)
mean(v_urban) * 100

##exercise
# Read a GeoTIFF file
(spr_prec_ncne <- rast("data/spr_prec_ncne.tif"))

# Inspect raster properties 
##Row = 162, column = 532 
## 0.0083...
## long extend = -79.89181, -75.45847, 
# Lat extend = 35.24153, 36.59153
## WGS84
##min = 1063.099976 max= 1501.5


# Visualize the raster
ggplot() +
  geom_spatraster(data = spr_prec_ncne )

# Extract values
sf_site <- readRDS("data/sf_finsync_nc.rds")

df_xy <- st_coordinates(sf_site)
df_land <- extract(spr_land, df_xy)
#forest 
df_land %>% 
  filter(code == 1001) %>% 
  nrow()
#Cropland
df_land %>% 
  filter(code == 1010) %>% 
  nrow()
#urban
df_land %>% 
  filter(code == 1100) %>% 
  nrow()

#quicker approach 
table(df_land)

#forest

