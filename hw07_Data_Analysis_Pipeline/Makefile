.PHONY: all clean
.DELETE_ON_ERROR:
.SECONDARY:

all: Raw_Candy.xlsx

clean:
	rm -f Raw_Candy.xlsx

Raw_Candy.xlsx:
	Rscript -e 'download.file("https://www.scq.ubc.ca/wp-content/uploads/2015/10/CANDY-HIERARCHY-2015-SURVEY-Responses.xlsx", destfile = "Raw_Candy.xlsx", quiet = TRUE, mode="wb")'
