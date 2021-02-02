# ================== Dependencias globales ======================

library(dplyr)
library(tidyr)
library(corrplot)
library(e1071)

# ====================== Dependencias locales ========================

# ** Cambiar directorio de trabajo adecuado a ubicación de fuentes.
setwd("proyecto/analisis_exploratorio")

# ** Cambiar directorio de trabajo a ubicación de CSV.

setwd("..")

df <- read.csv("preprocessed.csv", encoding = "UTF-8")

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
    -c_number_of_reviews_l30d,
    -c_calculated_host_listings_count
)

salida <- as.data.frame(select(
    df,
    v_host_is_superhost
))

train <- sample(nrow(variables), round(nrow(variables) / 2))

best <- svm(v_host_is_superhost ~ .,
    data = variables[train, ],
    kernel = "radial",
    cost = 100,
    gamma = 1.51
)

mc <- table(
    true = variables[-train, "v_host_is_superhost"],
    pred = predict(best,
        newdata = variables[-train, ]
    )
)

round(sum(diag(mc)) / sum(colSums(mc)), 5)

rs <- apply(mc, 1, sum)
r1 <- round(mc[1, ] / rs[1], 5)
r2 <- round(mc[2, ] / rs[2], 5)
rbind(No = r1, Yes = r2)

fitted <- attributes(predict(best, variables[-train, ],
    decision.values = TRUE
))$decision.values

efectividad <- c()

thresholds <- seq(-2, 1, 0.1)

for (threshold in thresholds) {
    eti <- ifelse(fitted < threshold, "Yes", "No")

    mc <- table(
        true = variables[-train, "v_host_is_superhost"],
        pred = eti
    )
    mc

    e <- round(sum(diag(mc)) / sum(colSums(mc)), 5)

    efectividad <- c(efectividad, e)
}

cbind(thresholds, efectividad)


eti <- ifelse(fitted < -1.0, "Yes", "No")

mc <- table(
    true = variables[-train, "v_host_is_superhost"],
    pred = eti
)
mc

e <- round(sum(diag(mc)) / sum(colSums(mc)), 5)

efectividad <- c(efectividad, e)


rs <- apply(mc, 1, sum)
r1 <- round(mc[1, ] / rs[1], 5)
r2 <- round(mc[2, ] / rs[2], 5)
rbind(No = r1, Yes = r2)



analisis_exploratorio <- function(df) {
    salida <- select(df, c_price)
    corrplot(cor(variables))
}