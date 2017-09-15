Gapminder Exploration
================
Hayden Scheiber
September 14, 2017

Gapminder: UN statistics on countries
=====================================

Below is a plot of Life Expectancy vs year for all countries covered by UN demographics data, beginning in 1952 and running up to the year 2007 in five year incriments.

![](hw01_gapminder_files/figure-markdown_github-ascii_identifiers/Plot_1-1.png)

-   Note the general trend towards longer life expectancies.
-   There are many possible reasons for this, but presumably most of the improvement is due to:
    -   Improvements in medical and agricultural technology.
    -   Increasing globalization, allowing for increased trade and ultimately more wealth.
    -   Improved relief efforts in natural disasters.
    -   Improvements in public education.

The UN recorded GDP per capita in the available data, and therefore we can look to see how strong the correlation between wealth and life expectancy really is.

![](hw01_gapminder_files/figure-markdown_github-ascii_identifiers/Plot_2-1.png)

This data is difficult to interpret with the current axes, perhaps a log scale plot of GDP per capita will improve the visualization:

![](hw01_gapminder_files/figure-markdown_github-ascii_identifiers/Plot_3-1.png)

This data suggests that there is a correlation between life expectancy and GDP per capita. We can see that rich countries tend to have long lifespans, but the correlation is anything but complete. There are plenty of poor countries with long life expectancies, so surely there are more variables at play!
