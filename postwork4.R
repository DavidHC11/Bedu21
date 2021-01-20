library(ggplot2)
library(dplyr)
#library(boot)
library(tidymodels)

wd = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(wd)
setwd("csv")

# Leemos archivo resultado de postwork 2
data_liga_17_20 = read.csv("liga_17-20.csv")

max_home_goals <- max(data_liga_17_20$FTHG)
max_away_goals <- max(data_liga_17_20$FTAG)
max_goals <- max(max_away_goals, max_home_goals)


# Obtenemos tabla de frecuencias relativas de probabilidades de goles en casa
freqs_home = table(factor(data_liga_17_20$FTHG, levels = 0:max_goals)) / 
  length(data_liga_17_20$FTHG)

# Obtenemos tabla de frecuencias relativas de probabilidades de goles de visita
freqs_away = table(factor(data_liga_17_20$FTAG, levels = 0:max_goals)) / 
  length(data_liga_17_20$FTAG)

# Obtenemos tabla de frecuencias relativas de probabilidades conjuntas
freqs_join = freqs_home %o% freqs_away

x <- cor(freqs_home, freqs_away)

q <- freqs_join / x

# joins <- function(data, indices, max_home_goals, max_away_goals) {
#   # Obtenemos muestra de bootstrapping
#   boot_sample <- data[indices,]
# 
#   # Obtenemos tabla de frecuencias relativas de proabilidades de goles en casa
#   p_home <- table(factor(boot_sample$FTHG, levels = 0:max_home_goals)) /
#     length(boot_sample$FTHG)
# 
#   # Obtenemos tabla de frecuencias relativas de probabilidades de goles de visita
#   p_away <- table(factor(boot_sample$FTAG, levels = 0:max_away_goals)) /
#     length(boot_sample$FTAG)
# 
#   # Obtenemos tabla de frecuencias relativas de probabilidades conjuntas
#   as.matrix(p_away %o% p_home)
# }

# boot_result <- boot(data = data_liga_17_20,
#                     statistic = joins,
#                     R = 1000,
#                     max_home_goals = max_home_goals,
#                     max_away_goals = max_away_goals)

boot_result <- bootstraps(data = q, times = 1000)
