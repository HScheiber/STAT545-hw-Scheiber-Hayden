suppressPackageStartupMessages(library(readxl))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(purrr))
suppressPackageStartupMessages(library(listviewer))
suppressPackageStartupMessages(library(tibble))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(stringi))
suppressPackageStartupMessages(library(combinat))
suppressPackageStartupMessages(library(purrr))

# Load the candy survey data
candies <- read_excel("./hw07_Data_analysis_Pipeline/Raw_Candy.xlsx")

# Make new dataframe for cleaned data
candies_clean <- candies

# Modify column names
column_names <- names(candies)
column_names[seq(1,3)] <- c("Time","Age","Going")
names(candies_clean) <- column_names

# Remove uninteresting questions
imp_q <- names(candies_clean) %>%
	stringr::str_detect("^\\[.*\\]$")
candies_clean[imp_q]


# Convert the ages to integers, remove any ages above 100, as they are likely to be incorrect
candies_clean$Age <- as.integer(candies$`How old are you?`)
candies_clean$Age[candies_clean$Age > 100] <- NA

# Convert "Are you going to go?" answers to binary. 1 = yes, 0 = no.
candies_clean$Going[candies_clean$Going == "Yes"] <- 1
candies_clean$Going[candies_clean$Going == "No"] <- 0
candies_clean$Going <- as.numeric(candies_clean$Going) %>%
	as.logical()