conformidad_c <- function(df) {
    # c_price de formato de cadena de moneda a número
    df <- df %>% mutate(c_price = gsub("\\$", "", c_price))
    df <- df %>% mutate(c_price = gsub(",", "", c_price))
    df <- df %>% mutate(c_price = as.numeric(c_price))

    # c_maximum_nights valores mayores a 20e6
    df <- df[df$c_maximum_nights <= 10000, ]

    # c_minimum_maximum_nights valores mayores a 20e6
    df <- df[df$c_minimum_maximum_nights <= 10000, ]

    # c_maximum_nights_avg_ntm valores mayores a 20e6
    df <- df[df$c_maximum_nights_avg_ntm <= 10000, ]

    return(df)
}