STAT 547M - Homework 10 Landing Page
================

[Return to main page.](https://github.com/HScheiber/STAT545-hw-Scheiber-Hayden/blob/master/README.md "Main page")

------------------------------------------------------------------------

Welcome the homework 10 section of my repository. In this section, I scrape data from the web using R. A link to the assignment itself on the STAT545 website can be found [here](http://stat545.com/hw10_data-from-web.html).

Link to Project:
-----

- [Web Data Scraping](/hw10_Web_Data_Scraping/Web_Data_Scraping.md)

Progress Report
---------------

- At first I wanted to find an API with interesting data and do a cool analysis on it. The problem was that it seemed that most of the really interesting data sets were behind a paywall. Instead I decided to try my hand at data scraping __without__ an API. I decided to use the BC transit website because there was a lot of information there, some of which I thought I could scrape together into a small interesting analysis.

- I ran into a lot of issues on the course of this assignment, but was always able to find an answer with enough persistent googling. Sometimes just __finding__ the problem was the difficult part. For example, I had an issue where `knitr` wasn't properly displaying my first set of plots. The data just wasn't there at all. I finally was able to trace the problem down to the fact that I was using a string compare between emojis. Unfortunately, there was no way to get around the fact that I needed to be able to tell the difference between these emojis (a checkmark and an X mark). Finally, I figured out that I had to write the emoji in its unicode form.

- Overall this assignment was on the more difficult side for me, but I was able to encorporate a lot of what I had learned in other assignments, such as regex with `stringr`, writing functions, and data wrangling with `dplyr`.


A helpful resource I used:

- [Answer to a specific question I had about interpreting emojis in R](https://stackoverflow.com/questions/41541138/translation-and-mapping-of-emoticons-encoded-as-utf-8-code-in-text)

- [The purrr cheat-sheet](https://github.com/rstudio/cheatsheets/raw/master/purrr.pdf)

- [Vancouver Transit Webpage](http://www.transitdb.ca/routes/)

- [Extracting data from the web presentation](https://github.com/ropensci/user2016-tutorial/blob/master/03-scraping-data-without-an-api.pdf)