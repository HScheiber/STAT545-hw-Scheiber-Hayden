STAT 547M - Homework 9 Landing Page
================

[Return to main page.](https://github.com/HScheiber/STAT545-hw-Scheiber-Hayden/blob/master/README.md "Main page")

------------------------------------------------------------------------

Welcome the homework 9 section of my repository. In this section, I construct an R package. A link to the assignment itself on the STAT545 website can be found [here](http://stat545.com/hw09_package.html).

Link to Project:
-----

- The package is found in its [own separate repository](https://github.com/HScheiber/powers).

- [Here is a link to the package vignette](https://github.com/HScheiber/powers/blob/master/inst/doc/my_vignette.pdf).

- It can be installed with `devtools::install_github("HScheiber/powers")` in Rstudio.

Progress Report
---------------

- There are so many components to making an R package it makes my head spin! It took me a long time to get a point where checking the package no longer yielded a warning or error message.

- I still don't really understand why both a vignette and README are necessary. It seems that they both have the same purpose.

- I spent a lot of time making sure my `pow` internal function could handle both strings and integers seamlessly. There are a __lot__ of `if-else` statements to ensure it all works.

- It took me a while to figure out that I had to also add dependencies to the `DESCRIPTION` file in order to properly build and check the package. My package depends on `ggplot2` and `stringr` for its functionality.


A helpful resource I used:

- [Writing Package Vignettes.](http://www.stats.uwo.ca/faculty/murdoch/ism2013/5Vignettes.pdf)

- [Generating .rd files](https://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html)

- [R packages by Hadley Wickham](http://r-pkgs.had.co.nz/)

- [Write your own R package](http://stat545.com/packages00_index.html)