# 1. ---------------------------------------------------

# Importamos dplyr para realizar operaciones con dataframes.
library(dplyr)

# URLs de los datasets a usar.
url_liga_2019_2020 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
url_liga_2018_2019 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
url_liga_2017_2018 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"

# Creamos directorio para guardar los archivos CSV y lo usamos como directorio
# de trabajo.
dir.create("csv")
setwd("csv")

# Descargamos los datasets.
download.file(url = url_liga_2019_2020, destfile = "liga_19-20.csv", mode = "wb")
download.file(url = url_liga_2018_2019, destfile = "liga_18-19.csv", mode = "wb")
download.file(url = url_liga_2017_2018, destfile = "liga_17-18.csv", mode = "wb")

# Cargamos los datasets en memoria.
datasets <- lapply(dir(), read.csv)

# Seleccionamos columnas Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR de cada
# dataset
datasets <- lapply(datasets, select, Date, HomeTeam, HS, AwayTeam, AS)

# Transformamos las fechas al formato indicado.
datasets <- lapply(datasets, mutate, Date = as.Date(Date, "%d/%m/%Y"))

# Cambiamos los nombres de las columnas
datasets <- lapply(datasets, rename,
    date = Date,
    home.team = HomeTeam,
    home.score = HS,
    away.team = AwayTeam,
    away.score = AS)

# Unimos todos los dataframes en uno solo.
dataset <- do.call(rbind, datasets)

# Guardamos el dataframe
write.csv(dataset, "soccer.csv", row.names = FALSE)

# 2. --------------------------------------------------
library(fbRanks)

lista_soccer <- create.fbRanks.dataframes("soccer.csv")

anotaciones <- lista_soccer$scores

equipos  <- lista_soccer$teams

fechas <- unique(anotaciones$date)

n <- length(fechas)

ranking <- rank.teams(scores = anotaciones,
                      teams = equipos,
                      max.date = fechas[n - 1],
                      min.date = fechas[1])
                      
predict(ranking, date = fechas[n])
