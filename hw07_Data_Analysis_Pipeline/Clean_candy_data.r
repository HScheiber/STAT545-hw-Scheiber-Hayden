suppressPackageStartupMessages(library(readxl))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(stringr))


# Load the candy survey data
candies <- read_excel("Raw_Candy.xlsx")

# Make new dataframe for cleaned data
candies_clean <- candies

# Modify column names
column_names <- names(candies)
column_names[seq(1,3)] <- c("Time","Age","Going")
names(candies_clean) <- column_names

# Remove uninteresting questions
imp_q <- names(candies_clean) %>%
	stringr::str_detect("^\\[.*\\]$")
imp_q[seq(1,3)] <- TRUE
candies_clean <- candies_clean[imp_q]

# Remove [Brackets] from candy names
names(candies_clean) <- str_replace(names(candies_clean),"\\[(.*)\\]","\\1")

# Convert spaces to _
names(candies_clean) <- str_replace_all(names(candies_clean),"\\s","_")

# Convert the ages to integers, remove any ages above 100 and below 5, as they are likely to be incorrect
candies_clean$Age <- as.integer(candies$`How old are you?`)
candies_clean$Age[candies_clean$Age > 100 | candies_clean$Age < 5 ] <- NA

# Convert "Are you going to go?" answers to binary. TRUE = yes, FALSE = no.
candies_clean$Going[candies_clean$Going == "Yes"] <- 1
candies_clean$Going[candies_clean$Going == "No"] <- 0
candies_clean$Going <- as.numeric(candies_clean$Going) %>%
	as.logical()

# function to Convert: Dispair -> FALSE and Joy -> TRUE.
dispair_joy_binary <- function(input) {
	i=0;
	output = logical(length(input))
	for (jd in input){
		i=i+1;
		if (is.na(jd)) {
			output[i] = NA
		}else	if (jd  == "JOY"){
				output[i] = TRUE
		}else if (jd  == "DESPAIR"){
				output[i] = FALSE
		}else{
				output[i] = NA
		}
	}
	return(output)
}
# Apply the above function to all the candy data
candies_clean[4:length(candies_clean)] <- sapply(candies_clean[4:length(candies_clean)], dispair_joy_binary)

# Save to file
saveRDS(candies_clean,"Clean_candy_wide.rds")
