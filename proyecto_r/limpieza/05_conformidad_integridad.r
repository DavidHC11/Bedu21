conformidad_c <- function(df) {
  # c_price de formato de cadena de moneda a número
  df <- df %>% mutate(c_price = gsub("\\$", "", c_price))
  df <- df %>% mutate(c_price = gsub(",", "", c_price))
  df <- df %>% mutate(c_price = as.numeric(c_price))

  # Valores mayores a 20e6 en noches máximas
  # - c_maximum_nights_avg_ntm, c_maximum_maximum_nights,
  # - c_minimum_maximum_nights, c_maximum_nights
  outliers <- which(df$c_maximum_nights_avg_ntm >= 20e6)
  df <- df[-outliers, ]

  # Valores mayores en columnas mínimas
  desorden <- which(df$c_maximum_minimum_nights > df$c_maximum_maximum_nights)
  df <- df[-desorden, ]

  return(df)
}

conformidad_v <- function(df) {
  # rare_props <- as.vector((as.data.frame(table(df$v_property_type)) %>%
  #   filter(Freq <= 10))$Var1)
  # df <- df %>% filter(!(v_property_type %in% rare_props))

  df <- df %>% mutate(
    v_host_is_superhost = factor(v_host_is_superhost, levels = c("t", "f"), labels = c(1, 0)),
    v_host_identity_verified = factor(v_host_identity_verified, levels = c("t", "f"), labels = c(1, 0)),
    v_has_availability = factor(v_has_availability, levels = c("t", "f"), labels = c(1, 0)),
    v_instant_bookable = factor(v_instant_bookable, levels = c("t", "f"), labels = c(1, 0))
  )

  return(df)
}