STAT 545 - Homework 7 Landing Page
================

[Return to main page.](https://github.com/HScheiber/STAT545-hw-Scheiber-Hayden/blob/master/README.md "Main page")

------------------------------------------------------------------------

Welcome the homework 7 section of my repository. In this section, I build an automated data analysis pipeline using `Make`. A link to the assignment itself can be found on the [STAT545 website](http://stat545.com/hw07_automation.html).

Link to Project Pages:
-----

- LINK PAGES HERE


Progress Report
---------------

While cleaing the candy data, I wanted to convert all strings of `JOY` into `TRUE` and all strings of `DESPAIR` into `FALSE` so that working with the data downstream would be easier. I tried really hard to get `mutate_all` to do this but I could not for the life of me get it to work properly. In the end I just built my own custom function to do the job. If anyone reading this knows a way to do the above (when `NA` are also present in the data) let me know!

I then spent ages trying to use the `summarise_at()` function to calculate the ratio of joy to despair (with `mean`). I eventually realised that the names of the variables were causing the problems because they had spaces in them. I went back and used `stringr::str_replace_all()` to change all spaces to `_`.

I wanted to have my `Makefile` put the intermediate data files into a separate folder within the main directory, but I kept getting errors. It took **HOURS** to figure out why I kept getting stupid errors. Made me want to pull my hair out. But eventually I figured it out by googling. For whatever reason, I had to add `.libPaths(c("C:/Users/Hayden/Documents/R/win-library/3.4", "C:/Program Files/R/R-3.4.1/library"))` to my rscripts in order to load my libaries properly. This problem only cropped up when I started using subdirectories in my `Makefile`.


Some helpful resources I used:

- [dplyr cheat-sheet](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf).

- [How to use `summarise_each`](https://www.r-bloggers.com/aggregation-with-dplyr-summarise-and-summarise_each/)

- [Colour Brewer info](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/#palettes-color-brewer)