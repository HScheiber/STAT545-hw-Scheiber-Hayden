# Load Libraries
library(shiny)
library(tidyverse)

# Define UI for the app
ui <- fluidPage(
	
	# Application title
	titlePanel(
		"The Unofficial BC Liquor Store App",
		imageOutput("BCL_Logo")
		),
	
	sidebarPanel(
		"This is my sidebar",
		sliderInput("PriceIn", 
								"Price of Booze" ,
								min = 0, 
								max = 300, 
								value = c(10, 20),
								pre = "CAD"
		),
		
		radioButtons(
			"TypeIn",
			"What kind of booze?",
			choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
			selected = "SPIRITS"
		)
	),
	
	mainPanel(
		plotOutput("Hist_AlcCont"),
		br(),br(),
		tableOutput("table_head"),
		br(),br(),
		plotOutput("Plot_price_vs_alc_perc")
	)
	
)