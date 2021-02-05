library(mongolite)

db <- "match_games"
collection <- "match"

pw <- "*****************" # Funciona, confía en mí
url <- sprintf("mongodb+srv://alan:%s@beducluster.ozq0h.mongodb.net/test", pw)

m <- mongo(url = url, db = db, collection = collection)

match_data <- read.csv("data.csv")

m$insert(match_data)

m$count()

query_date <- "2015-12-20"

query_template <- '{
    "$and": [
        {
            "Date": "%s"
        },
        {
            "$or": [
                {
                    "AwayTeam": "Real Madrid"
                },
                {
                    "HomeTeam": "Real Madrid"
                }
            ]
        }
    ]
}'

result_set <- m$find(
    query = sprintf(query_template, query_date)
)

entries <- dim(result_set)[1]

if (entries == 0) {
    print(
        sprintf(
            "Sin entradas para la fecha %s, buscando con fecha más cercana",
            query_date
        )
    )
    alternative <- m$iterate(sort = '{"Date": 1}')
    while (!is.null(entry <- alternative$one())) {
        if (
            entry$HomeTeam == "Real Madrid" ||
                entry$AwayTeam == "Real Madrid") {
            print(str(entry))
            break
        }
    }
} else {
    print(str(result_set))
}

m$disconnect()
