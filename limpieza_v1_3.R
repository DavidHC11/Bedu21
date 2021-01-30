setwd("./proyecto")
library(dplyr)
library(tidyr)
data <- read.csv('listings.csv', encoding='UTF-8')
#Por ahora no consideraremos algunas variables de texto, seleccionaremos las
#variables que consideramos más útiles para nuestro objetivo
df <- data %>% select(id, 
                                       last_scraped, 
                                       name, 
                                       host_id, 
                                       host_name, 
                                       host_since,
                                       host_response_time,
                                       host_response_rate, 
                                       host_acceptance_rate, 
                                       host_is_superhost, 
                                       host_total_listings_count,
                                       host_verifications, 
                                       host_identity_verified, 
                                       neighbourhood,
                                       neighbourhood_cleansed,
                                       neighbourhood_group_cleansed,
                                       latitude,
                                       longitude,
                                       property_type,
                                       room_type,
                                       accommodates,
                                       bathrooms,
                                       bathrooms_text,
                                       bedrooms,
                                       beds,
                                       amenities,
                                       price,
                                       minimum_nights,
                                       maximum_nights,
                                       minimum_minimum_nights,
                                       maximum_minimum_nights,
                                       minimum_maximum_nights,
                                       maximum_maximum_nights,
                                       minimum_nights_avg_ntm,
                                       maximum_nights_avg_ntm,
                                       calendar_updated,
                                       has_availability,
                                       availability_30,
                                       availability_60,
                                       availability_90,
                                       availability_365,
                                       calendar_last_scraped,
                                       number_of_reviews,
                                       number_of_reviews_ltm,
                                       number_of_reviews_l30d,
                                       first_review,
                                       last_review,
                                       review_scores_rating,
                                       review_scores_accuracy,
                                       review_scores_cleanliness,
                                       review_scores_checkin,
                                       review_scores_communication,
                                       review_scores_location,
                                       review_scores_value,
                                       license,
                                       instant_bookable,
                                       calculated_host_listings_count)

#ETIQUETADO
categoricas <- c(
  "bathrooms",
  "bedrooms",
  "beds",
  "host_response_time",
  "host_is_superhost",
  "host_identity_verified",
  "neighbourhood",
  "neighbourhood_cleansed",
  "neighbourhood_group_cleansed",
  "property_type",
  "room_type",
  "accommodates",
  "calendar_updated",
  "has_availability",
  "license",
  "instant_bookable"
)

numericas <- c(
  "host_total_listings_count",
  "minimum_nights",
  "maximum_nights",
  "minimum_minimum_nights",
  "maximum_minimum_nights",
  "minimum_maximum_nights",
  "maximum_maximum_nights",
  "id",
  "host_id",
  "host_response_rate",
  "host_acceptance_rate",
  "latitude",
  "longitude",
  "price",
  "minimum_nights_avg_ntm",
  "maximum_nights_avg_ntm",
  "availability_30",
  "availability_60",
  "availability_90",
  "availability_365",
  "number_of_reviews",
  "number_of_reviews_ltm",
  "number_of_reviews_l30d",
  "review_scores_rating",
  "review_scores_accuracy",
  "review_scores_cleanliness",
  "review_scores_checkin",
  "review_scores_communication",
  "review_scores_location",
  "review_scores_value",
  "calculated_host_listings_count"
)

fechas <- c(
  "last_scraped",
  "host_since",
  "calendar_updated",
  "first_review",
  "last_review",
  "calendar_last_scraped"
)

textos<-c(
  "host_name",
  "host_verifications",
  "bathrooms_text",
  "name",
  "amenities"
  )


for (texto in textos) {
  colnames(df)[match(texto, colnames(df))] <- paste("t_", texto, sep = "")
}

for (categorica in categoricas) {
  colnames(df)[match(categorica, colnames(df))] <- paste("v_", categorica, sep = "")
}
for (numerica in numericas) {
  colnames(df)[match(numerica, colnames(df))] <- paste("c_", numerica, sep = "")
}
for (fecha in fechas) {
  colnames(df)[match(fecha, colnames(df))] <- paste("d_", fecha, sep = "")
}

#DUPLICADOS
#Vamos cuales registros están identicamente duplicados y posteriormente cuales 
#estan duplicados por el id
sprintf("Existen %d repetidos", eval(dim(df)[1] - table(duplicated(df))))

duplicadosid<-as.data.frame(duplicated(select(df, -c_id)))
indexid<-which(duplicadosid==T)
df<-df[-indexid,]

#Completitud

completitud<-c()

for(i in 1:length(colnames(df))){
  
completitud[i]<-1-sum(is.na(df[,i]))/dim(df)[1]

}

completitud<-as.data.frame(completitud)
completitud<-cbind(Variables=colnames(df), completitud)
(com<-completitud[completitud[,2]<.80,1])

df<-select(df, -com)

#Borrar filas que tuvieran NA 
filas<-c()
for (i in 1:nrow(df)) {
  if (sum(is.na(df[i,]))>0) {
    filas<-c(i,filas)
  }
}

df<-df[-filas,]

#Completitud por ""

c_2<-c()

for(i in 1:length(colnames(df))){
  
  c_2[i]<-1-sum(df[,i]=="")/dim(df)[1]
  
}

c_2<-as.data.frame(c_2)
c_2<-cbind(Variables = colnames(df), c_2)
(com2<-c_2[c_2[,2]<.80,1])

df<-select(df, -c("v_neighbourhood" ,"d_first_review","d_last_review"))
unique(df$v_host_response_time)

#Completitud por "N/A"
c_3<-c()

for(i in 1:length(colnames(df))){
  
  c_3[i]<-1-(length(grep("N/A",df[,i],fixed = T))/dim(df)[1])
  
}

c_3<-as.data.frame(c_3)
c_3<-cbind(Variables = colnames(df), c_3)
(com3<-c_3[c_3[,2]<.80,1])

df<-select(df, -c("v_host_response_time", "c_host_response_rate", "c_host_acceptance_rate"))

#Conformidad

summary(df)









