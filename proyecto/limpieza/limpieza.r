# ================== Dependencias globales ======================

setwd("proyecto/limpieza")
library(dplyr)
library(tidyr)

# ====================== Dependencias locales ========================

# ** Cambiar directorio de trabajo adecuado a ubicación de fuentes.
source("./01_seleccion_variables.r")
source("./02_etiquetado_variables.r")
source("./03_eliminacion_duplicados.r")
source("./04_completitud.r")
source("./05_conformidad_integridad.r")

# ** Cambiar directorio de trabajo a ubicación de CSV.

setwd("..")
data <- read.csv("listings.csv", encoding = "UTF-8")

df <- seleccionar_variables(data)

df <- etiquetar_variables(df)

df <- eliminar_duplicados(df)

df <- eliminar_nulos(df)

df <- eliminar_cadenas_no_validas(df)

# ========= Conformidad ==========

df <- conformidad_c(df)

df <- conformidad_v(df)

