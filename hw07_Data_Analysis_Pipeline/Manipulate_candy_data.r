.libPaths(c("C:/Users/Hayden/Documents/R/win-library/3.4", "C:/Program Files/R/R-3.4.1/library"))
suppressPackageStartupMessages(library(tidyverse))

# Read the data file to memory
candies_clean <- readRDS("./DataFiles/Clean_candy_wide.rds")

# Group by age and convert to long format
candies_group_age_long <- candies_clean %>%
	group_by(Age) %>%
	summarise_at( .vars = names(candies_clean[4:length(candies_clean)]), funs(mean), na.rm = TRUE) %>%
	t() %>%
	data.frame

# Write column names as age
colnames(candies_group_age_long) <- as.character(unlist(candies_group_age_long[1,]))

# Remove the unknown age column
candies_group_age_long = candies_group_age_long[-1,-length(candies_group_age_long)]

# Without grouping by age
candies_long_no_group <- candies_clean %>%
	summarise_at( .vars = names(candies_clean[4:length(candies_clean)]), funs(mean), na.rm = TRUE) %>%
	gather(key = Candy, value = Joy_Despair_Ratio) %>%
	arrange(Joy_Despair_Ratio)

# Save both files
saveRDS(candies_group_age_long,"./DataFiles/Ratios_Group_Age.rds")
saveRDS(candies_long_no_group,"./DataFiles/Ratios_No_Group.rds")