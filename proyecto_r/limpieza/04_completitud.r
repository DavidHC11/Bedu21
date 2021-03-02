library(dplyr)

eliminar_nulos <- function(df) {
    # Calculamos completitud según la cantidad de nulos por columna
    completitud <- c()
    numero_de_filas <- dim(df)[1]
    numero_de_columnas <- dim(df)[2]
    for (i in seq_len(numero_de_columnas)) {
        cantidad_de_nulos <- sum(is.na(df[, i]))
        completitud[i] <- 1 - cantidad_de_nulos / numero_de_filas
    }

    completitud <- as.data.frame(completitud)
    completitud <- cbind(Variables = colnames(df), completitud)

    # Definimos un threshold de completitud para filtrar columnas
    comp_threshold <- 0.8
    incompletas <- completitud[completitud[, 2] < comp_threshold, ]$Variables

    # Eliminamos variables consideradas incompletas
    df <- select(df, -all_of(incompletas))

    # Borrar filas que tuvieran NA
    filas_con_nulos <- c()
    numero_de_filas <- dim(df)[1]
    numero_de_columnas <- dim(df)[2]

    for (i in seq_len(numero_de_filas)) {
        nulos_en_fila <- sum(is.na(df[i, ]))
        if (nulos_en_fila > 0) {
            filas_con_nulos <- c(filas_con_nulos, i)
        }
    }

    if (length(filas_con_nulos) > 0) {
        df <- df[-filas_con_nulos, ]
    }

    return(df)
}

eliminar_cadenas_no_validas <- function(df) {

    # Completitud por cadena vacía ""

    completitud_vacias <- c()
    numero_de_filas <- dim(df)[1]
    numero_de_columnas <- dim(df)[2]
    for (i in seq_len(numero_de_columnas)) {
        cantidad_de_vacias <- sum(df[, i] == "")
        completitud_vacias[i] <- 1 - cantidad_de_vacias / numero_de_filas
    }

    completitud_vacias <- as.data.frame(completitud_vacias)
    completitud_vacias <- cbind(Variables = colnames(df), completitud_vacias)
    columnas_con_vacias <- completitud_vacias[completitud_vacias[, 2] < .80, 1]

    df <- select(df, -all_of(columnas_con_vacias))
    unique(df$v_host_response_time)

    # Completitud por "N/A"

    completitud_na <- c()
    numero_de_filas <- dim(df)[1]
    numero_de_columnas <- dim(df)[2]
    for (i in seq_len(numero_de_columnas)) {
        cantidad_de_nas <- length(grep("N/A", df[, i], fixed = T))
        completitud_na[i] <- 1 - cantidad_de_nas / numero_de_filas
    }

    completitud_na <- as.data.frame(completitud_na)
    completitud_na <- cbind(Variables = colnames(df), completitud_na)
    columnas_con_nas <- completitud_na[completitud_na[, 2] < .80, 1]

    df <- select(df, -all_of(columnas_con_nas))

    return(df)
}