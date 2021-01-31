setwd("./proyecto")

# ================== Dependencias ======================
library(dplyr)
library(tidyr)


# =============== Lectura del dataset ===============
data <- read.csv("listings.csv", encoding = "UTF-8")

# Por ahora no consideraremos algunas variables de texto, seleccionaremos las
# variables que consideramos más útiles para nuestro objetivo
df <- data %>% select(
  id,
  last_scraped,
  name,
  host_id,
  host_name,
  host_since,
  host_response_time,
  host_response_rate,
  host_acceptance_rate,
  host_is_superhost,
  host_total_listings_count,
  host_verifications,
  host_identity_verified,
  neighbourhood,
  neighbourhood_cleansed,
  neighbourhood_group_cleansed,
  latitude,
  longitude,
  property_type,
  room_type,
  accommodates,
  bathrooms,
  bathrooms_text,
  bedrooms,
  beds,
  amenities,
  price,
  minimum_nights,
  maximum_nights,
  minimum_minimum_nights,
  maximum_minimum_nights,
  minimum_maximum_nights,
  maximum_maximum_nights,
  minimum_nights_avg_ntm,
  maximum_nights_avg_ntm,
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
  calculated_host_listings_count
)

# ================= Etiquetado de variables ===============
categoricas <- c(
  "bathrooms",
  "bedrooms",
  "beds",
  "host_response_time",
  "host_is_superhost",
  "host_identity_verified",
  "neighbourhood",
  "neighbourhood_cleansed",
  "neighbourhood_group_cleansed",
  "property_type",
  "room_type",
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
  "amenities"
)

# ============== Sustitución de nombres ================

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

# ================== Eliminación de duplicados =======================

# Vemos cuales registros están duplicados con columna id
duplicados_con_id <- dim(df)[1] - table(duplicated(df))
sprintf("Existen %d duplicados considerando columna de ID.", duplicados_con_id)

# Vemos cuántos registros están duplicados sin considerar columna id
duplicados_sin_id <- as.data.frame(duplicated(select(df, -c_id)))
indexid <- which(duplicados_sin_id == T)

# Eliminamos las entradas duplicadas en el data frame con id
df <- df[-indexid, ]

# ================= Completitud de los datos =======================

# Calculamos completitud según la cantidad de nulos por columna
completitud <- c()
numero_de_filas <- dim(df)[1]
numero_de_columnas <- dim(df)[2]
for (i in seq_len(numero_de_columnas)) {
  cantidad_de_nulos <- sum(is.na(df[, i]))
  completitud[i] <- 1 - cantidad_de_nulos / numero_de_filas
}

completitud <- as.data.frame(completitud)
completitud <- cbind(Variables = colnames(df), completitud)

# Definimos un threshold de completitud para filtrar columnas
comp_threshold <- 0.8
incompletas <- completitud[completitud[, 2] < comp_threshold, ]$Variables

# Eliminamos variables consideradas incompletas
df <- select(df, -all_of(incompletas))

# Borrar filas que tuvieran NA
filas_con_nulos <- c()
numero_de_filas <- dim(df)[1]
numero_de_columnas <- dim(df)[2]

for (i in seq_len(numero_de_filas)) {
  nulos_en_fila <- sum(is.na(df[i, ]))
  if (nulos_en_fila > 0) {
    filas_con_nulos <- c(filas_con_nulos, i)
  }
}

if (length(filas_con_nulos) > 0) {
  df <- df[-filas_con_nulos, ]
}

# Completitud por cadena vacía ""

completitud_vacias <- c()
numero_de_filas <- dim(df)[1]
numero_de_columnas <- dim(df)[2]
for (i in seq_len(numero_de_columnas)) {
  cantidad_de_vacias <- sum(df[, i] == "")
  completitud_vacias[i] <- 1 - cantidad_de_vacias / numero_de_filas
}

completitud_vacias <- as.data.frame(completitud_vacias)
completitud_vacias <- cbind(Variables = colnames(df), completitud_vacias)
columnas_con_vacias <- completitud_vacias[completitud_vacias[, 2] < .80, 1]

df <- select(df, -all_of(columnas_con_vacias))
unique(df$v_host_response_time)

# Completitud por "N/A"

completitud_na <- c()
numero_de_filas <- dim(df)[1]
numero_de_columnas <- dim(df)[2]
for (i in seq_len(numero_de_columnas)) {
  cantidad_de_nas <- length(grep("N/A", df[, i], fixed = T))
  completitud_na[i] <- 1 - cantidad_de_nas / numero_de_filas
}

completitud_na <- as.data.frame(completitud_na)
completitud_na <- cbind(Variables = colnames(df), completitud_na)
columnas_con_nas <- completitud_na[completitud_na[, 2] < .80, 1]

df <- select(df, -all_of(columnas_con_nas))

# ======================= Conformidad ===========================

summary(df)