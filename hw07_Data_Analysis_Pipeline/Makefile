.PHONY: all clean
.DELETE_ON_ERROR:
.SECONDARY:

all: CandyPop_By_Age_Candy.png CandyPop_By_Candy.png

clean:
	rm -f Raw_Candy.xlsx Clean_candy_wide.rds Ratios_Group_Age.rds Ratios_No_Group.rds CandyPop_By_Age_Candy.png CandyPop_By_Candy.png

Raw_Candy.xlsx:
	Rscript -e 'download.file("https://www.scq.ubc.ca/wp-content/uploads/2015/10/CANDY-HIERARCHY-2015-SURVEY-Responses.xlsx", destfile = "Raw_Candy.xlsx", quiet = TRUE, mode="wb")'

Clean_candy_wide.rds: Clean_candy_data.r Raw_Candy.xlsx
	Rscript $<

Ratios_Group_Age.rds Ratios_No_Group.rds: Manipulate_candy_data.r Clean_candy_wide.rds
	Rscript $<

CandyPop_By_Age_Candy.png CandyPop_By_Candy.png: Plot_candy_data.r Ratios_Group_Age.rds Ratios_No_Group.rds
	Rscript $<