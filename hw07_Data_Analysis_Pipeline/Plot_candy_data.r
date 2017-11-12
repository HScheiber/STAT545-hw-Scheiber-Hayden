.libPaths(c("C:/Users/Hayden/Documents/R/win-library/3.4", "C:/Program Files/R/R-3.4.1/library"))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(stringr))

# Read the data file to memory
ratios_Group_age <- readRDS("./DataFiles/Ratios_Group_Age.rds")
ratios_no_group <- readRDS("./DataFiles/Ratios_No_Group.rds")

# Convert _ back to spaces for plotting
ratios_no_group[[1]] <- str_replace_all(ratios_no_group[[1]],"_"," ")
row.names(ratios_Group_age) <- str_replace_all(row.names(ratios_Group_age),"_"," ")

# Set row names to first column
setDT(ratios_Group_age, keep.rownames = TRUE)[]
names(ratios_Group_age)[1] <- "Candy"

# Convert grouped data to long format
ratios_Group_age_long <- ratios_Group_age %>%
	gather("Age", "Joy_Despair_Ratio", 2:length(ratios_Group_age))

# Convert age column to integers
ratios_Group_age_long$Age <- as.integer(ratios_Group_age_long$Age)

# Add a column of average Joy/Despair ratio for the age grouped data, for sorting purposes
ratios_Group_age_long <- ratios_Group_age_long %>%
	group_by(Candy) %>%
	mutate(Average_Ratio = mean(Joy_Despair_Ratio,na.rm = TRUE))

# Plot of Joy_Ratio vs Candy Type 
p.UnGrouped <- ratios_no_group %>%
	ggplot(aes(y =  Joy_Despair_Ratio, x = reorder(Candy, Joy_Despair_Ratio))) + 
	geom_bar(stat = "identity") +
	scale_y_continuous(breaks = seq(0, 1, 0.25),
										 labels = seq(0, 1, 0.25),
										 limits = c(0, 1)) +
	labs(y = "Candy Popularity (Ratio of Joy to Despair)", 
			 x = "",
			 title = "Overall Popularity of Candy by Type (All Ages)",
			 subtitle = "Data produced from 2015 Candy Survey") +
	theme_bw() +
	theme(axis.title = element_text(size=16),
				plot.subtitle = element_text(size=12,hjust = 0.49),
				strip.text = element_text(size=14, face="bold"),
				plot.title = element_text(size=16, face="bold",hjust = 0.49),
				axis.text.x = element_text(size=12,face ="bold",angle = 90, hjust = 1, vjust = 0.3),
				axis.text.y = element_text(size=12,face ="bold"),
				legend.title = element_text(size=14, face ="bold"),
				legend.text = element_text(size=12, face ="bold"))

# Save as png
ggsave("./DataFiles/CandyPop_By_Candy.png",
			 plot = p.UnGrouped, 
			 device = "png",
			 width = 15, 
			 height = 15,
			 dpi = 500)

# Plot of Joy_Ratio vs Candy Type by age (3D plot)
p.Grouped <- ratios_Group_age_long %>%
	ggplot(aes(y =  Age, x = reorder(Candy, Average_Ratio))) + 
	geom_tile(aes(fill = Joy_Despair_Ratio)) +
	scale_y_continuous(breaks = seq(5, 70, 5),
										 labels = seq(5, 70, 5),
										 limits = c(5, 70)) +
	scale_fill_distiller("Joy to Despair Ratio\n", palette = "YlGnBu") +
	labs(y = "Age (Years)", 
			 x = "",
			 title = "Popularity of Candy by Type and Age",
			 subtitle = "Data produced from 2015 Candy Survey") +
	theme_bw() +
	theme(axis.title = element_text(size=16),
				plot.subtitle = element_text(size=12,hjust = 0.49),
				strip.text = element_text(size=14, face="bold"),
				plot.title = element_text(size=16, face="bold",hjust = 0.49),
				axis.text.x = element_text(size=12,face ="bold",angle = 90, hjust = 1, vjust = 0.3),
				axis.text.y = element_text(size=12,face ="bold"),
				legend.title = element_text(size=14, face ="bold"),
				legend.text = element_text(size=12, face ="bold"))

# Save as png
ggsave("./DataFiles/CandyPop_By_Age_Candy.png",
			 plot = p.Grouped, 
			 device = "png",
			 width = 17, 
			 height = 15,
			 dpi = 500)
