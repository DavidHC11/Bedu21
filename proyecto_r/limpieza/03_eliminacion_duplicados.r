library(dplyr)

eliminar_duplicados <- function(df) {
    # Vemos cuales registros están duplicados con columna id
    duplicados_con_id <- dim(df)[1] - table(duplicated(df))
    sprintf(
        "Existen %d duplicados considerando columna de ID.",
        duplicados_con_id
    )

    # Vemos cuántos registros están duplicados sin considerar columna id
    duplicados_sin_id <- as.data.frame(duplicated(select(df, -c_id)))
    indexid <- which(duplicados_sin_id == T)

    # Eliminamos las entradas duplicadas en el data frame con id
    if (length(indexid) > 0) {
        df <- df[-indexid, ]
    }

    # Filas duplicadas con d_last_scraped
    df$d_calendar_last_scraped <- NULL

    return(df)
}