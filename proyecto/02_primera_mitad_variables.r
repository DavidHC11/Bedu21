setwd("./proyecto")
library(dplyr)
library(tidyr)
data <- read.csv('listings.csv', encoding='UTF-8')

#TIPO DE VARIABLES
data1 <- data %>% rename(b_id = id, d_last_scraped = last_scraped, b_host_id = host_id, t_host_name = host_name, d_host_since = host_since, b_host_response_time = host_response_time, c_host_response_rate = host_response_rate, c_host_acceptance_rate = host_acceptance_rate, b_host_is_superhost = host_is_superhost, b_host_total_listings_count = host_total_listings_count, t_host_verifications = host_verifications, b_host_identity_verified = host_identity_verified, b_neighbourhood = neighbourhood, b_neighbourhood_cleansed = neighbourhood_cleansed, b_neighbourhood_group_cleansed = neighbourhood_group_cleansed, c_latitude = latitude, c_longitude = longitude, b_property_type = property_type, b_room_type = room_type, b_accommodates = accommodates, b_bathrooms = bathrooms, t_bathrooms_text = bathrooms_text, b_bedrooms = bedrooms, b_beds = beds,  b_amenities = amenities, c_price = price, b_minimum_nights = minimum_nights, b_maximum_nights = maximum_nights, b_minimum_minimum_nights = minimum_minimum_nights, b_maximum_minimum_nights = maximum_minimum_nights, b_minimum_maximum_nights = minimum_maximum_nights, b_maximum_maximum_nights = maximum_maximum_nights, c_minimum_nights_avg_ntm = minimum_nights_avg_ntm)

#CONFORMIDAD
data1 <- data1 %>% select(b_id, d_last_scraped, b_host_id, t_host_name, d_host_since, b_host_response_time, c_host_response_rate, c_host_acceptance_rate, b_host_is_superhost, b_host_total_listings_count, t_host_verifications, b_host_identity_verified, b_neighbourhood, b_neighbourhood_cleansed, b_neighbourhood_group_cleansed, c_latitude, c_longitude, b_property_type, b_room_type, b_accommodates, b_bathrooms, t_bathrooms_text, b_bedrooms, b_beds,  b_amenities, c_price, b_minimum_nights, b_maximum_nights, b_minimum_minimum_nights, b_maximum_minimum_nights, b_minimum_maximum_nights, b_maximum_maximum_nights, c_minimum_nights_avg_ntm)
data1 <- data1 %>% mutate(d_last_scraped = as.Date(d_last_scraped, "%Y-%m-%d"), d_host_since = as.Date(d_host_since, "%Y-%m-%d"))
data1 <- data1 %>% mutate(c_host_response_rate = gsub("\\%", "", c_host_response_rate), c_host_acceptance_rate = gsub("\\%", "", c_host_acceptance_rate), c_price = gsub("\\$", "", c_price))
data1 <- data1 %>% mutate(c_host_response_rate = as.numeric(c_host_response_rate)/100, c_host_acceptance_rate = as.numeric(c_host_acceptance_rate)/100, c_price = as.numeric(c_price))
data1 <- data1 %>% mutate(b_host_is_superhost = factor(b_host_is_superhost, levels=c('t', 'f'), labels=c(1, 0)), b_host_identity_verified = factor(b_host_identity_verified, levels=c('t', 'f'), labels=c(1, 0)))

View(data1)

# Categoricas
id,
host_id,
host_response_time,
host_is_superhost,
host_total_listings_count,
host_identity_verified,
neighbourhood,
neighbourhood_cleansed,
neighbourhood_group_cleansed,
property_type,
room_type,
accommodates,
bathrooms,
bedrooms,
beds,
amenities,
minimum_nights,
maximum_nights,
minimum_minimum_nights,
maximum_minimum_nights,
minimum_maximum_nights,
maximum_maximum_nights,


# Texto
host_name,
host_verifications,
bathrooms_text,


# Cantidades
host_response_rate,
host_acceptance_rate,
latitude,
longitude,
price,
minimum_nights_avg_ntm,


# Fechas
d_last_scraped,
d_host_since,