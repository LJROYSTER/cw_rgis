# Vector 2: spatial join

if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview)

# erase all objects in the environment
rm(list = ls())
sf_site <- readRDS("data/sf_finsync_nc.rds")
sf_nc_county <- readRDS("data/sf_nc_county.rds")

#visualize
mapview(sf_nc_county, legend = FALSE) + mapview(sf_site, legend = FALSE)

# join county information to sf_site
sf_site_join <- st_join(x = sf_site,
        y = sf_nc_county)

# count the number of fish surveys sites within Guilford county
sf_site_guilford <-
sf_site_join %>% 
  filter(county == "guilford")
# count the number of fish surveys sites within Clay county
sf_site_clay <-
sf_site_join %>%  
  filter(county == "clay")
# re-read stream layer
sf_str <- readRDS("data/sf_stream_gi.rds")

# produce a map with guilford county polygon, sites within guilford
# and stream lines in Guilford 
# USE ggplot() mapping functions
sf_gi_county <- sf_nc_county %>% 
  filter(county == "guilford")

ggplot () + 
  geom_sf(data = sf_gi_county) +
  geom_sf(data = sf_str,
          color = "plum") + 
  geom_sf(data = sf_site_guilford,
          color = "pink")

# geometric analysis 

# length #
sf_str_proj <- st_transform(sf_str, crs = 32617)
# calculate the length of each stream line segment
v_str_l <- st_length(sf_str_proj)
head(v_str_l)

sf_str_w_len <- sf_str %>% 
  mutate(length = v_str_l)

# area #
sf_nc_county_proj <- st_transform(sf_nc_county, crs = 32617)

# calculate the area of county polygons
v_area <- st_area(sf_nc_county_proj)

# create a column "Area" in sf_nc_county_proj, and identify which county is largest 
sf_nc_county_w_area <- sf_nc_county_proj %>% 
  mutate(area = as.numeric(v_area)/ 1E+6) %>% 
  arrange(desc(area))

# subset polygons for mapping
sf_county1k <- sf_nc_county_w_area %>% 
  filter(area > 1000)

# map the subset of countries
ggplot() +
  geom_sf(data = sf_county1k)

# exercise
sf_quakes <- readRDS("data/sf_quakes.rds")

sf_nz <- readRDS("data/sf_nz.rds")

sf_quakes_join <- st_join(sf_quakes, sf_nz)

sf_quakes_nz <- sf_quakes_join %>% 
  drop_na(fid)

nrow(sf_quakes_nz)

mapview(sf_nz, legend = FALSE) + mapview(sf_quakes, legend = FALSE)


df_n <- (sf_site_join) %>% 
  as_tibble() %>% 
  group_by(county) %>% 
  summarize(n=n())

sf_n_site <- left_join(x = sf_nc_county,
          y = df_n)
sf_n10 <- sf_n_site %>% 
  filter(n > 10)

ggplot() +
  geom_sf(data = sf_nc_county) + 
  geom_sf(data = sf_n_site %>% 
            filter(n > 1),
          fill = "grey") +
            geom_sf(data = sf_n10,
                    fill = "salmon")
         