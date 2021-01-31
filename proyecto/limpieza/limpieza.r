# ================== Dependencias globales ======================
library(dplyr)
library(tidyr)

# ====================== Dependencias locales ========================

# ** Cambiar directorio de trabajo adecuado a ubicación de fuentes.
source("./01_seleccion_variables.r")
source("./02_etiquetado_variables.r")
source("./03_eliminacion_duplicados.r")
source("./04_completitud.r")

# ** Cambiar directorio de trabajo a ubicación de CSV.

setwd("..")
data <- read.csv("listings.csv", encoding = "UTF-8")

df <- seleccionar_variables(data)

df <- etiquetar_variables(df)

df <- eliminar_duplicados(df)

df <- eliminar_nulos(df)

df <- eliminar_cadenas_no_validas(df)

# ========= Conformidad ==========
# Revisar con hist() o table()
conformidad_c <- function(df) {
   
}
conformidad_t <- function(df) {
   
}
conformidad_v <- function(df) {
  rare_props <- as.vector((as.data.frame(table(df$v_property_type)) %>% filter(Freq <= 10))$Var1)
  df <- df %>% filter(!(v_property_type %in% rare_props))
  return(df)
}
conformidad_d <- function(df) {

}
