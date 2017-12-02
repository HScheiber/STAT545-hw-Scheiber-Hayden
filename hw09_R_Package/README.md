STAT 547M - Homework 9 Landing Page
================

[Return to main page.](https://github.com/HScheiber/STAT545-hw-Scheiber-Hayden/blob/master/README.md "Main page")

------------------------------------------------------------------------

Welcome the homework 9 section of my repository. In this section, I construct an R package. A link to the assignment itself on the STAT545 website can be found [here](http://stat545.com/hw09_package.html).

Link to Project:
-----

- The package is found in its [own separate repository](https://github.com/HScheiber/powers).

- [Here is a link to the package vignette](https://github.com/HScheiber/powers/blob/master/inst/doc/powers_vignette.pdf).

- It can be installed with `devtools::install_github("HScheiber/powers")` in Rstudio.

Progress Report
---------------

- There are so many components to making an R package it makes my head spin! It took me a long time to get a point where checking the package no longer yielded a warning or error message.

- I still don't really understand why both a vignette and README are necessary. It seems to me that a vignette covers everything that a README would and more. I suppose a README is only useful if you happen to just stumble upon a package and no nothing about it...

- I spent a lot of time making sure my `pow` internal function could handle both strings and integers seamlessly. There are a __lot__ of `if-else` statements to ensure it all works.

- It took me a while to figure out that I had to also add dependencies to the `DESCRIPTION` file in order to properly build and check the package. My package depends on `ggplot2` and `stringr` for its functionality.

- I also spent a good deal of time making sure I got 0 errors, warnings, or notes when `checking` my package. One note actually required that instal an entire program called `ghostscript`, so if you try to check my package and don't have that program set in rstudio's path, you may also get a note! Theres another warning that sometimes pops up during check, but doesn't seem to actually count as a warning. The `RMS check` process likes to rebuild my vignettes, and it also likes to warn me about it rebuilding them. This doesn't affect functionality in any way, and the vignettes are always rebuilt faithfully.

- I kept having a warning during the check process because I technically defined a global variable in my `pow.R` function that was actually just a variable for the column name in a data frame, which I needed to define in order to use `ggplot`. To get around this warning, instead of the `aes()` function, I used `aes_string()` and defined my data frame variables with a string.

A helpful resource I used:

- [Writing Package Vignettes.](http://www.stats.uwo.ca/faculty/murdoch/ism2013/5Vignettes.pdf)

- [Generating .rd files](https://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html)

- [R packages by Hadley Wickham](http://r-pkgs.had.co.nz/)

- [Write your own R package](http://stat545.com/packages00_index.html)