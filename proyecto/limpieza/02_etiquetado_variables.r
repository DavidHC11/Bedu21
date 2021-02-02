etiquetar_variables <- function(df) {

    # Tipos de variables

    categoricas <- c(
        "bathrooms",
        "bedrooms",
        "beds",
        "host_response_time",
        "host_is_superhost",
        "host_identity_verified",
        "neighbourhood",
        "accommodates",
        "calendar_updated",
        "has_availability",
        "license",
        "instant_bookable"
    )

    numericas <- c(
        "host_total_listings_count",
        "minimum_nights",
        "maximum_nights",
        "minimum_minimum_nights",
        "maximum_minimum_nights",
        "minimum_maximum_nights",
        "maximum_maximum_nights",
        "id",
        "host_id",
        "host_response_rate",
        "host_acceptance_rate",
        "latitude",
        "longitude",
        "price",
        "minimum_nights_avg_ntm",
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
        "calculated_host_listings_count"
    )

    fechas <- c(
        "last_scraped",
        "host_since",
        "calendar_updated",
        "first_review",
        "last_review",
        "calendar_last_scraped"
    )

    textos <- c(
        "host_name",
        "host_verifications",
        "bathrooms_text",
        "name",
        "amenities",
        "neighbourhood_cleansed",
        "neighbourhood_group_cleansed",
        "property_type",
        "room_type"
    )


    for (texto in textos) {
        indice_columna <- match(texto, colnames(df))
        colnames(df)[indice_columna] <- paste("t_", texto, sep = "")
    }

    for (categorica in categoricas) {
        indice_columna <- match(categorica, colnames(df))
        colnames(df)[indice_columna] <- paste("v_", categorica, sep = "")
    }
    for (numerica in numericas) {
        indice_columna <- match(numerica, colnames(df))
        colnames(df)[indice_columna] <- paste("c_", numerica, sep = "")
    }
    for (fecha in fechas) {
        indice_columna <- match(fecha, colnames(df))
        colnames(df)[indice_columna] <- paste("d_", fecha, sep = "")
    }

    return(df)
}