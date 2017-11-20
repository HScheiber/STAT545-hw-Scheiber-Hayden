# Load Libraries
library(shiny)
library(tidyverse)
library(stringr)
library(DT)

# Define the server function
server <- function(input, output, session) {
  
	
	# Load data
	bcl_data <- read_csv("bcl-data.csv",
		col_types = cols(
			Type = col_character(),
			Subtype = col_character(),
			Country = col_character(),
			Name = col_character(),
			Alcohol_Content = col_double(),
			Price = col_double(),
			Sweetness = col_integer()
		))
	
	# Convert names from all caps to only first letter capital
	bcl_data[1:4] <- sapply(bcl_data[1:4],str_to_title)
	
	
	#make dynamic slider
	output$Priceslider <- renderUI({
		# If no types of product selected
		if (is_empty(input$TypeIn)){
			return(NULL)
		}else if(is_empty(input$SelCountry)){
			
			# Need to initilize slider before filtered data is generated
			filteredDat <- bcl_data %>%
				filter(Type %in% input$TypeIn)
		
		} else if (input$SelCountry == "All"){
			
			filteredDat <- bcl_data %>%
				filter(Type %in% input$TypeIn)
			
		}else{
			
			filteredDat <- bcl_data %>%
				filter(Type %in% input$TypeIn,
							 Country == input$SelCountry)
			
		}
		
		maxkaw <- max(filteredDat$Price, na.rm = TRUE)
		minkaw <- min(filteredDat$Price, na.rm = TRUE)
		
		sliderInput("PriceIn", 
								"Price Range:", 
								min = minkaw, 
								max = maxkaw, 
								value = c(minkaw, maxkaw),
								pre = "CAD $")
		
	})
	
	
	# Create Country Select Menu
	output$countrylist <- renderUI({
		selectInput("SelCountry", "Filter By Country:", 
								choices = c("All", unique(bcl_data$Country)), 
								selected = "All", multiple = FALSE)
	})
		
	
	# Filter data frame
	Filtered_bcl <- reactive({ 
		
		if (is_empty(input$PriceIn[1]) | is_empty(input$SelCountry)){
			return(NULL)
		}else if(input$SelCountry == "All"){
			bcl_data %>%
				filter(Price >= input$PriceIn[1],
							 Price <= input$PriceIn[2],
							 Type %in% input$TypeIn)
		}else{
			bcl_data %>%
				filter(Price >= input$PriceIn[1],
							 Price <= input$PriceIn[2],
							 Type %in% input$TypeIn,
							 Country == input$SelCountry)
		}
	})
	
	
	# Upper plot of alcohol content histogram
	output$Hist_AlcCont <- renderPlot({
		# Catch empty dataset
		if(is_empty(Filtered_bcl())){
			return(NULL)
		}
		
		# Generate list for subtitles
		strlen <- length(input$TypeIn)
		if (strlen == 1){
			listtypes <- input$TypeIn
		}else if (strlen == 2){
			listtypes <- str_c(input$TypeIn, collapse = " and ")
		}else{
			first_str <- str_c(input$TypeIn[1:strlen-1], collapse = ", ")
			sec_str <- input$TypeIn[strlen]
			
			## concatenate both together after
			listtypes <- str_c(first_str, sec_str, sep = ', and ')
		}
		
		# Generate subtitle country text
		if (input$SelCountry == "All"){
			countrytext = ""
		}else{
			countrytext = paste0(" in ", input$SelCountry)
		}
		
		if (nrow(Filtered_bcl()) >= 1){
		Filtered_bcl() %>%
			ggplot() +
			aes(x = Alcohol_Content) +
			geom_histogram(binwidth=1) +
			scale_x_continuous(breaks = seq(0, 100, 10),
												 labels = as.character(seq(0, 100, 10)),
												 limits = c(0, 100)) +
			theme_bw() +
			theme(axis.text.x = element_text(size=12, face = "bold"),
						axis.text.y = element_text(size=12, face = "bold"),
						plot.title = element_text(size=14, face = "bold", hjust = 0.5),
						axis.title = element_text(size=14, face = "bold"),
						plot.subtitle = element_text(size=12, face = "bold")) +
			labs(x = "Alcohol Content (%)", 
					 y = "Number of Products",
					 title = "Distribution of Alcohol Content",
					 subtitle = paste0("Content for: ", 
					 									listtypes, 
					 									" Products. $", 
					 									input$PriceIn[1], 
					 									" - $", 
					 									input$PriceIn[2],
					 									countrytext)
					 )
		}else{
			return(NULL)
		}
	})
	
	
	# Table of selected data
	output$table_head <- DT::renderDataTable( 
		# Catch empty dataset
		(if(is_empty(Filtered_bcl())){
			return(NULL)
		}else{
			return(Filtered_bcl())
		}),
		options = list(scrollX = TRUE)
	)
	
	
	# Plot of alcohol price vs percentage
	output$Plot_price_vs_alc_perc <- renderPlot({ 
		# Catch empty dataset
		if(is_empty(Filtered_bcl())){
			return(NULL)
		}
		
		# Generate list for subtitles
		strlen <- length(input$TypeIn)
		if (strlen == 1){
			listtypes <- input$TypeIn
		}else if (strlen == 2){
			listtypes <- str_c(input$TypeIn, collapse = " and ")
		}else{
			first_str <- str_c(input$TypeIn[1:strlen-1], collapse = ", ")
			sec_str <- input$TypeIn[strlen]
			
			## concatenate both together after
			listtypes <- str_c(first_str, sec_str, sep = ', and ')
		}
		
		if (input$SelCountry == "All"){
			countrytext = ""
		}else{
			countrytext = paste0(" in ", input$SelCountry)
		}
		
		if (nrow(Filtered_bcl()) >= 1){
		Filtered_bcl() %>%
			ggplot(aes(x = Alcohol_Content, y = Price, color = Country)) +
			geom_point() +
			theme_bw() +
			scale_x_continuous(breaks = seq(0, 100, 10),
												 labels = as.character(seq(0, 100, 10)),
												 limits = c(0, 100)) +
			scale_y_log10(breaks = as.integer(10^seq(0,5,1)),
												 labels = paste0("$",as.integer(10^seq(0,5,1))),
												 limits = c(1, 10^5)) +
			theme(axis.text.x = element_text(size=12, face = "bold"),
						axis.text.y = element_text(size=12, face = "bold"),
						plot.title = element_text(size=14, face = "bold", hjust = 0.5),
						axis.title = element_text(size=14, face = "bold"),
						plot.subtitle = element_text(size=12, face = "bold"),
						legend.position="none") +
			labs(x = "Alcohol Content (%)", 
					 y = "Price",
					 title = "Alcohol Content vs Price",
					 subtitle = paste0("Content for: ", 
					 									listtypes, 
					 									" Products. $", 
					 									input$PriceIn[1], 
					 									" - $", 
					 									input$PriceIn[2],
					 									countrytext)
					 )
		}else{
			return(NULL)
		}
	})
	

	# Create title image linked to title text
	output$Title_Logo <- renderUI({
		
		# Define width
		width <- session$clientData$output_Title_Logo_width
		
		# Define "Unofficial" text separate properties
		midtext <- span("\tUnofficial",
										style = "color: red;
													   font-size: 5.0vw; 
														 font-weight: bold;
														 font-variant: small-caps;"
										)
		
		# Generate the image and title alignment using CSS and HTML
		div(
			img(
				src = "BCL-Logo.jpg", 
				alt = "BC Liquour Store", 
				align ="left",
				style = "width: 95%"),
			span(
				HTML(paste("The", midtext, "App", sep = '<br/>')),
				style = "vertical-align: middle;
								 display: table-cell;
								 font-size: 3.8vw; 
								 text-align: center"
				),
			style = "display: table; 
							 width: 100%"
		)
	})
	
	
	# 'Search Options' dynamic sidebar title
	output$Options <- renderUI({
		div(
			"Search Options",
			style = "font-size: 2.0vw; 
							 text-align: center;
							 font-weight: bold"
			)
	})
	
}

