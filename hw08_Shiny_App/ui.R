# Load Libraries
library(shiny)
library(tidyverse)
library(DT)

# Define UI for the app
ui <- fluidPage(
	
	
	# Title Frame
	titlePanel(
		htmlOutput("Title_Logo")
		),
	
	
	# Sidebar Frame
	sidebarPanel(
		htmlOutput("Options"),
		br(),
		uiOutput("Priceslider"),
		checkboxGroupInput(
			"TypeIn",
			"Type of Product:",
			choices = c("Beer", "Refreshment", "Spirits", "Wine"),
			selected = c("Beer", "Refreshment", "Spirits", "Wine")
		),
		br(),
		uiOutput("countrylist"),
		width = 3
	),
	
	
	# Main Frame
	mainPanel(
		tabsetPanel(
			tabPanel("Alc % Histogram", plotOutput("Hist_AlcCont")),
			tabPanel("Searchable Table", DT::dataTableOutput("table_head")),
			tabPanel("Alc % vs Price", plotOutput("Plot_price_vs_alc_perc"))
		),
		width = 9
	),
	title="BCL Unofficial App"
)