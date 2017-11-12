.PHONY: all clean
.DELETE_ON_ERROR:
.SECONDARY:

all: candy_report.md

clean:
	rm -r -f DataFiles

DataFiles/Raw_Candy.xlsx:
	mkdir DataFiles
	Rscript -e 'download.file("https://www.scq.ubc.ca/wp-content/uploads/2015/10/CANDY-HIERARCHY-2015-SURVEY-Responses.xlsx", destfile = "./DataFiles/Raw_Candy.xlsx", quiet = TRUE, mode="wb")'

DataFiles/Clean_candy_wide.rds: Clean_candy_data.r DataFiles/Raw_Candy.xlsx
	Rscript $<

DataFiles/Ratios_Group_Age.rds DataFiles/Ratios_No_Group.rds: Manipulate_candy_data.r DataFiles/Clean_candy_wide.rds
	Rscript $<

DataFiles/CandyPop_By_Age_Candy.png DataFiles/CandyPop_By_Candy.png: Plot_candy_data.r DataFiles/Ratios_Group_Age.rds DataFiles/Ratios_No_Group.rds
	Rscript $<

candy_report.md: candy_report.rmd DataFiles/CandyPop_By_Age_Candy.png DataFiles/CandyPop_By_Candy.png
	Rscript -e 'rmarkdown::render("candy_report.rmd")'
	rm -f candy_report.html
	