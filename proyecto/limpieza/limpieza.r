# ================== Dependencias globales ======================

library(dplyr)
library(tidyr)


# ====================== Dependencias locales ========================

# ** Cambiar directorio de trabajo adecuado a ubicación de fuentes.
setwd("proyecto/limpieza")

source("./01_seleccion_variables.r")
source("./02_etiquetado_variables.r")
source("./03_eliminacion_duplicados.r")
source("./04_completitud.r")
source("./05_conformidad_integridad.r")

# ** Cambiar directorio de trabajo a ubicación de CSV.
setwd("..")

R.utils::gunzip("listings2019.csv", remove = FALSE)
R.utils::gunzip("listings2020.csv", remove = FALSE)

data2019 <- read.csv("listings2019.csv", encoding = "UTF-8")
data2020 <- read.csv("listings2020.csv", encoding = "UTF-8")

df <- seleccionar_variables(data2019)

df <- etiquetar_variables(df)

df <- eliminar_duplicados(df)

df <- eliminar_nulos(df)

df <- eliminar_cadenas_no_validas(df)

# ========= Conformidad ==========

df <- conformidad_c(df)

df <- conformidad_v(df)

write.csv(df, "preprocessed2019.csv")
