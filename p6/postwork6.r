library(dplyr)
library(zoo)

match_data <- read.csv("match.data.csv")

match_data$date <- as.Date(match_data$date, format = "%Y-%m-%d")

match_data$sumagoles <- match_data$home.score + match_data$away.score

match_data$mes <- format(match_data$date, "%Y-%m")

match_data_by_month <- group_by(match_data, mes)

promedios <- match_data_by_month %>%
    summarise(promedio_suma_goles = mean(sumagoles))

promedios <- promedios %>% mutate(mes = as.yearmon(mes))

promedios <- promedios %>% subset(mes <= as.yearmon("2019-12"))

plot(
    x = promedios$mes,
    y = promedios$promedio_suma_goles,
    type = "l",
    xlab = "Meses",
    ylab = "Promedio de suma de goles"
)