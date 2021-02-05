library(dplyr)
library(ggplot2)

# Se carga archivo del postwork previo
#setwd("./Downloads/BEDU Postworks/3")
all_matches <- read.csv("liga_17-20.csv")

# Se crean las tablas de probabilidades
home_prob <- (table(all_matches$FTHG)/dim(all_matches)[1]) * 100 
away_prob <- (table(all_matches$FTAG)/dim(all_matches)[1]) * 100
joint_prob <- (table(all_matches$FTHG, all_matches$FTAG)/dim(all_matches)[1]) * 100

# Se transforman las tablas en DFs
home_prob <- as.data.frame(home_prob)
away_prob <- as.data.frame(away_prob)
joint_prob <- as.data.frame(joint_prob)


# Se identifican los nombres de las columnas en los DFs
all <- c(home_prob, away_prob, joint_prob)
lapply(all, names)

# Se renombran los nombres de columna para mayor legibilidad
home_prob <- rename(home_prob, Goals = Var1, Probability = Freq)
away_prob <- rename(away_prob, Goals = Var1, Probability = Freq)
joint_prob <- rename(joint_prob, HomeGoals = Var1, AwayGoals = Var2, Probability = Freq)

#Se realizan los gráficos de barras correspondientes con los ejes x -> Goals, y -> Probability
ggplot(home_prob, aes(x=Goals, y=Probability)) +
  geom_col()
ggplot(away_prob, aes(x=Goals, y=Probability)) +
  geom_col()

#Se realizan los gráficos de barras correspondientes con los ejes x -> HomeGoals, y -> AwayGoals, z -> Probability
ggplot(joint_prob, aes(x=HomeGoals, y=AwayGoals, fill=Probability)) +
  geom_tile()
