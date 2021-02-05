library(ggplot2)
library(shiny)
library(shinydashboard)
library(dplyr)
#install.packages(DT)
library(DT)

ui <- fluidPage(
    
    dashboardPage(
      
      dashboardHeader(title = "Postwork 8"),
      
      dashboardSidebar(
        
        sidebarMenu(
          menuItem("Histograma", tabName = "Dashboard", icon = icon("affiliatetheme")),
          menuItem("Data Table", tabName = "DATATABLE", icon = icon("eye")),
          menuItem("Imagen", tabName = "imagenes", icon = icon("passport")),
          menuItem("PT3", tabName = "imag", icon = icon("passport"))
        )
        
      ),
      
      dashboardBody(
        
        tabItems(
          
          #Grafica 
          tabItem(tabName = "Dashboard",
                  fluidRow(
                    titlePanel("Grafico de barras"),
                    selectInput("equipo", "Selecciona el bando", 
                                choices = c("Visitante","Local")),
                    box(plotOutput("grafica"))
                  )
          ),
          #Tabla
          tabItem(tabName = "DATATABLE",
                  fluidRow(        
                    titlePanel(h3("Data Table")),
                    dataTableOutput ("tabla")
                  )
          ),
          tabItem(tabName = "imag",
                    fluidRow(
                      titlePanel(h3("Postwork 3")),
                      img( src = "hist1.png"),
                      img( src = "hist2.png"),
                      img(src="hist3.png")
                      
                    )
          ),
          #imagenes 2
          tabItem(tabName = "imagenes",
                  fluidRow(
                    titlePanel(h3("Momios")),
                    img( src = "alto.png"),
                    img( src = "bajo.png")
                    
                  )
          )
          
        )
      )
    )
  )


server<-function(input, output){
  
  datos<-eventReactive(input$equipo,{
    base<-read.csv("match.data.csv")
    return(base)
  })
  
  output$tabla<-renderDataTable({
    base<-datos()
    base<-datatable(base,escape = FALSE)
  return(base)    
  })
  
  output$grafica<-renderPlot({
    base<-datos()
    if(input$equipo=="Local"){
      g<-ggplot(base,aes(x=home.score,fill=home.team))+geom_bar()+facet_wrap(~home.team)
    } else{
      g<-ggplot(base,aes(x=away.score,fill=away.team))+geom_bar()+facet_wrap(~away.team)
    }
    plot(g)
  })
  
  
}
                  
                  
shinyApp(ui=ui,server = server)            
                  
                  
                  
                  
                  
                  
                  
                  
                  
                  
                  
                  