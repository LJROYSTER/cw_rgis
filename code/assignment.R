# Take-home assignment for 10/16/2025

if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview,
               here)

# Q1. Read the dataset "data_finsync_nc.csv" from the data subdirectory 
# and assign it to an object named `df_fish`.
# Reference: Chapter 2

df_fish <- read_csv("data/data_finsync_nc.csv")

# Q2. Using `df_fish`, create a dataframe with unique site name (`site_id`), 
# longitude (`lon`), and latitude (`lat`), and assign it to `df_site`.
# Hint: use `distinct()` function.
# Reference: Chapter 2
df_site <- df_fish %>% 
  distinct(site_id, lon, lat) 
 
# Q3. `df_site` currently has no coordinate reference system (CRS). 
# Convert it to an `sf` object and assign the WGS 84 CRS (EPSG: 4326). 
# Save the resulting object as `sf_site`.
# Reference: Chapter 2

sf_site <- df_fish %>% 
  distinct(site_id, lon, lat) %>%
  st_as_sf(coords = c("lon", "lat"),
           crs = 4326)

print(sf_site)

# Q4. Read "sf_nc_county.rds" from the data subdirectory using the `readRDS()` function.
# Assign the result to `sf_nc_county`.
# Reference: Chapter 3
# read from an RDS file

sf_nc_county <- readRDS(file = "data/sf_nc_county.rds")

# Q5. Using the `st_join()` function, associate the county column from `sf_nc_county`
# with each site in `sf_site`. Assign the result to `sf_site_w_county`.
# Reference: Chapter 3
sf_site_w_county <- st_join(x = sf_site,
                        y = sf_nc_county) 
# Q6. Convert `sf_site_w_county` to a tibble using the `as_tibble()` function.
# Assign the result to `df_site_w_county`.
# Reference: Chapter 3
df_nc_w_county<- (sf_site_w_county) %>% 
  as_tibble()

# Q7. Using `df_site_w_county`, create a vector of county names that have at least one fish survey site.
# Assign the result to `v_s1`. (Hint: use group_by(), summarize(), filter(), and pull()).
# Confirm the result contains 49 counties with `length(v_s1)`.
# Reference: https://aterui.github.io/biostats/data-manipulation.html#group-operation
v_s1<- (df_nc_w_county) %>% 
  as_tibble() %>% 
  group_by(county) %>% 
  summarize(n=n()) 
  

