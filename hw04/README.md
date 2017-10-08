STAT 545 - Homework 4 Landing Page
================

[Return to main page.](https://github.com/HScheiber/STAT545-hw-Scheiber-Hayden/blob/master/README.md "Main page")

------------------------------------------------------------------------

Welcome the homework 4 section of my repository. In this section, I work on my data wrangling and reshaping skills by tackling some realistic problems. A link to the assignment itself can be found on the [STAT545 website](http://stat545.com/hw04_tidy-data-joins.html).

Links
-----

-   [Homework 4: Tidy data and joins.](/hw04/tidy_joins.md)

-   [R markdown source code for Homework 4](/hw04/tidy_joins.Rmd)

Progress Report
---------------

I found that reshaping data can be a real pain sometimes. For this assignment I relied a lot on the [data wrangling cheat sheet](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf) for `dplyr` and `tidyr`.

It became very obvious to me from this assignment that `ggplot` absolutely prefers to use data in long format. However, to make tables human-readable it is often better to have them in a wide or semi-wide format.

I had a very hard time reshaing the table I title "Highest and Lowest Life Expectancy by Year in Asia". I tried using the `spread` function but kept running into issues. In the end, I relied on other `dplyr` functions to spread the rows into multiple columns. It felt very clunky, but it worked!

Working with data from an external source that was poorly formatted was annoying. However, I've had to do this many times before in other programming languages. Sometimes the hardest part of data analysis is just importing the data into a usable data structure! I found that R had some very nice functions for making this process as pain-free as possible.
