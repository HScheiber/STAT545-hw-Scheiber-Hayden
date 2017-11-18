# Load Libraries
library(shiny)
library(tidyverse)

# Define the server function
server <- function(input, output, session) {
   
	bcl_data <- read_csv("bcl-data.csv")
	
	Filtered_bcl <- reactive({ 
		bcl_data %>%
			filter(Price >= input$PriceIn[1],
						 Price <= input$PriceIn[2],
						 Type == input$TypeIn)
	})
	
	
	output$Hist_AlcCont <- renderPlot({ 
		Filtered_bcl() %>%
			ggplot() +
			aes(x = Alcohol_Content) +
			geom_histogram(binwidth=1)
	})
	
	output$table_head <- renderTable({ 
		Filtered_bcl() %>%
			head()
	})
	
	output$Plot_price_vs_alc_perc <- renderPlot({ 
		Filtered_bcl() %>%
			ggplot(aes(x = Alcohol_Content, y = Price)) +
			geom_point() 
	})
	
	output$BCL_Logo <- renderImage({
		# Get width and height of image
		width  <- session$clientData$output_BCL_Logo_width
		height <- session$clientData$output_BCL_Logo_height
		
		# Return the BCL logo
		return(list(
			src = "BCL-Logo.jpg",
			filetype = "image/jpeg",
			alt = "BC Liquour Store"
		))
	}, deleteFile = FALSE)
	
	
	
	
}

