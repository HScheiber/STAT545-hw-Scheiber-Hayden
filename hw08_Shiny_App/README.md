STAT 545 - Homework 8 Landing Page
================

[Return to main page.](https://github.com/HScheiber/STAT545-hw-Scheiber-Hayden/blob/master/README.md "Main page")

------------------------------------------------------------------------

Welcome the homework 8 section of my repository. In this section, I build a `Shiny` App based on data from the BC liquor store. A link to the assignment itself can be found on the [STAT545 website](http://stat545.com/hw08_shiny.html).

Link to Project:
-----

- [App website](https://scheiber.shinyapps.io/BC_Liquor_App/)

- [Server Script](server.R)

- [User Interface Script](ui.R)

- [App Script](app.R)

- [BC Liquour Store Source Data](https://www.opendatabc.ca/dataset/bc-liquor-store-product-price-list-current-prices)

App Features
--------

- Dynamic title frame. The size of the picture and text scale with the browser frame size. I used html and CSS here to get the design I wanted.

- The price range automatically scales to the minimum and maximum prices of the selected products.

- Can filter by country or all countries.

- Can filter by type of product.

- Number of matching search results is returned.

- Three tabs: histogram of alcohol %; searchable table of search results; and a log scale plot of alcohol % vs price, coloured by country.

- Utilized ggplot theme features to make the plots look nicer.


Progress Report
---------------

- I spent hours perfecting that title so that it scaled with the size of the webpage, but I learned a lot doing it! I learned the syntax to impliment HTML and CSS into `shiny` apps, it's actually super easy once you get the hang of it. Stack exchange was my friend here.

- It was really hard to get the minimum and maximum of the slider to update with the max/min price in the filtered data. I managed to get it in the end but it felt like a hack doing what I did.

- I spent so much time debugging and making sure no errors pop up under any circumstances. If you can get my app to throw an error please let me know!

- Overall I had a fun time doing this project. I really enjoyed putting together all of the stuff I've been learning about throughout the course into a small app. There's so much more I could add to it, but I think I've done enough for the purposes of this project!

A helpful resource I used:

- [Shiny Tutorial](https://shiny.rstudio.com/tutorial/written-tutorial/lesson1/)