library(dplyr)

datos_airbinb_nyc <- read.csv("listings.csv", encoding = "utf-8")

# Segunda mitad de las variables seleccionadas
part_2 <- datos_airbinb_nyc %>% select(maximum_nights_avg_ntm,
                        calendar_updated,
                        has_availability,
                        availability_30,
                        availability_60,
                        availability_90,
                        availability_365,
                        calendar_last_scraped,
                        number_of_reviews,
                        number_of_reviews_ltm,
                        number_of_reviews_l30d,
                        first_review,
                        last_review,
                        review_scores_rating,
                        review_scores_accuracy,
                        review_scores_cleanliness,
                        review_scores_checkin,
                        review_scores_communication,
                        review_scores_location,
                        review_scores_value,
                        license,
                        instant_bookable,
                        calculated_host_listings_count,
                        license,
                        instant_bookable)

str(part_2)

# Canversión de fechas a formato adecuado.
part_2 <- part_2 %>% mutate(
    calendar_last_scraped = as.Date(calendar_last_scraped, "%Y-%m-%d"),
    first_review = as.Date(first_review, "%Y-%m-%d"),
    last_review = as.Date(last_review, "%Y-%m-%d"),
)

# Conversión a valores booleanos
part_2$instant_bookable <- factor(
    part_2$instant_bookable,
    levels = c("t", "f"),
    labels = c(1, 0)
)

part_2$has_availability <- factor(
    part_2$has_availability,
    levels = c("t", "f"),
    labels = c(1, 0)
)

# Eliminación de columnas vacías
part_2$calendar_updated <- NULL
part_2$license <- NULL

