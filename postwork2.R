# Importamos dplyr para realizar operaciones con dataframes.
library(dplyr)

# URLs de los datasets a usar.
url_liga_2019_2020 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
url_liga_2018_2019 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
url_liga_2017_2018 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"

# Cambiamos directorio de trabajo a directorio donde se encuentra el script.
wd = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(wd)

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
datasets <- lapply(datasets, select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)

# Transformamos las fechas al formato indicado.
datasets <- lapply(datasets, mutate, Date = as.Date(Date, "%d/%m/%Y"))

# Unimos todos los dataframes en uno solo.
dataset <- do.call(rbind, datasets)
