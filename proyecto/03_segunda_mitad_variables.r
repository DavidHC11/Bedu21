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
                        calculated_host_listings_count)

str(part_2)


categoricas <- c(
    "calendar_updated",
    "has_availability",
    "license",
    "instant_bookable"
)

numericas <- c(
    "maximum_nights_avg_ntm",
    "availability_30",
    "availability_60",
    "availability_90",
    "availability_365",
    "number_of_reviews",
    "number_of_reviews_ltm",
    "number_of_reviews_l30d",
    "review_scores_rating",
    "review_scores_accuracy",
    "review_scores_cleanliness",
    "review_scores_checkin",
    "review_scores_communication",
    "review_scores_location",
    "review_scores_value",
    "calculated_host_listings_count",
)

fechas <- c(
    "calendar_updated",
    "first_review",
    "last_review",
)

for (categorica in categoricas) {
    colnames(part_2)[match(categorica, colnames(part_2))] <- paste("v_", categorica, sep = "")
}
for (numerica in numericas) {
    colnames(part_2)[match(numerica, colnames(part_2))] <- paste("c_", numerica, sep = "")
}
for (fecha in fechas) {
    colnames(part_2)[match(fecha, colnames(part_2))] <- paste("d_", fecha, sep = "")
}
