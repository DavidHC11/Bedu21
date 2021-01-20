library(ggplot2)
library(dplyr)
library(boot)
library(DescTools)

wd = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(wd)
setwd("csv")

set.seed(12345)

# Leemos archivo resultado de postwork 2
data_liga_17_20 = read.csv("liga_17-20.csv")

# Encontramos la máxima cantidad de goles de cada parte
max_home_goals <- max(data_liga_17_20$FTHG)
max_away_goals <- max(data_liga_17_20$FTAG)

# Esta función recibe una muestra del bootstrapping del dataframe original con
# ambas variables aleatorias y devuelve la matriz de cocientes entre
# la probabilidad conjunta y el producto de las probabilidades marginales.
quotients <- function(data, indices, max_home_goals, max_away_goals) {
  # Obtenemos muestra de bootstrapping
  boot_sample <- data[indices,]
  
  # Número de partidos
  n <- length(boot_sample$FTHG)

  # Tabla de frecuencias relativas de proabilidades de goles en casa
  p_home <- table(factor(boot_sample$FTHG, levels = 0:max_home_goals)) / n

  # Tabla de frecuencias relativas de probabilidades de goles de visita
  p_away <- table(factor(boot_sample$FTAG, levels = 0:max_away_goals)) / n

  # Tabla de frecuencias relativas de probabilidades conjuntas
  p_joint <- table(factor(boot_sample$FTAG, levels = 0:max_away_goals), 
                   factor(boot_sample$FTHG, levels = 0:max_home_goals)) / n
  
  # Tabla de producto de probablidades marginales
  p_prod <- p_away %o% p_home
  
  
  # Devolvemos tabla de cocientes
  (q <- p_joint / p_prod)
  
  # Se devuelve la media de los cocientes de la matriz obtenida
  mean(q, na.rm = TRUE)
  
}

boot_result <- boot(data = data_liga_17_20,
                    statistic = quotients,
                    R = 1000,
                    max_home_goals = max_home_goals,
                    max_away_goals = max_away_goals)

plot(boot_result)
boot.ci(boot_result, type="basic")
