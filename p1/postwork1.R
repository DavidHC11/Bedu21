fut<-read.csv("https://www.football-data.co.uk/mmz4281/1920/SP1.csv")
df<-data.frame(fut)
df
df1<-as.data.frame(cbind(goleslocal=df$FTHG,golesvisita=df$FTAG))
dfl<-df1$goleslocal
dfv<-df1$golesvisita
l<-table(dfl)
v<-table(dfv)
p<-table(df1)
prop.table(l)
prop.table(v)
prop.table(p)

