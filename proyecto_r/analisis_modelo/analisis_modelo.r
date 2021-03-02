# ================== Dependencias globales ======================

library(dplyr)
library(tidyr)
library(corrplot)

# ====================== Dependencias locales ========================

# ** Cambiar directorio de trabajo adecuado a ubicación de fuentes.
setwd("proyecto/analisis_modelo")

# ** Cambiar directorio de trabajo a ubicación de CSV.

setwd("..")

df <- read.csv("preprocessed2019.csv", encoding = "UTF-8")

df <- df[, grep("^(c|v)", colnames(df), ignore.case = TRUE)]

variables <- select(
    df,
    -c_id,
    -c_host_id,
    -c_availability_60,
    -c_availability_90,
    -c_availability_365,
    -c_minimum_minimum_nights,
    -c_maximum_minimum_nights,
    -c_minimum_maximum_nights,
    -c_maximum_maximum_nights,
    -c_minimum_nights_avg_ntm,
    -c_maximum_nights_avg_ntm,
    -c_number_of_reviews_ltm,
    -v_neighbourhood,
    -v_calendar_updated,
    -v_has_availability,
    -c_calculated_host_listings_count
)

corrplot(cor(variables))

hist(variables$c_price)
barplot(table(variables$v_host_is_superhost))
barplot(table(variables$v_host_identity_verified))

# ================== Modelo =====================

train <- sample(nrow(variables), round(nrow(variables) / 2))

variables_train <- variables[train, ]

modeloglm <- glm(
    v_host_identity_verified ~ .,
    data = variables_train,
    family = binomial
)

summary(modeloglm)

step(modeloglm)

modelo2 <- glm(
    formula = v_host_identity_verified ~
        c_host_total_listings_count +
        c_latitude +
        c_longitude +
        v_accommodates +
        v_bathrooms +
        v_beds +
        c_minimum_nights +
        c_availability_30 +
        c_number_of_reviews +
        v_instant_bookable,
    family = binomial,
    data = variables_train
)


variables_train$predicciones <- ifelse(modelo2$fitted.values < 0.5, 0, 1)

prueba <- predict(modelo2, newdata = variables[-train, ], type = "response")


for (i in seq(0, 1, 0.01)) {
    prueba2 <- ifelse(prueba > i, 1, 0)

    confusion <- table(prueba2, variables$v_host_identity_verified[-train])

    efectividad <- round(sum(diag(confusion)) / sum(colSums(confusion)), 5)
    if (efectividad > 0.6) {
        print(sprintf("%f, %f", i, efectividad))
    }
}

variables_train$predicciones <- ifelse(modelo2$fitted.values < 0.52, 0, 1)
prueba2 <- ifelse(prueba > 0.52, 1, 0)
confusion <- table(prueba2, variables$v_host_identity_verified[-train])