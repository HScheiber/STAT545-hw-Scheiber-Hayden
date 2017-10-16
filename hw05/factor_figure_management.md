Homework 5 - Factor and figure management; Repo hygiene
================
Hayden Scheiber -
15 October, 2017

[Return to Main Page](https://github.com/HScheiber/STAT545-hw-Scheiber-Hayden/blob/master/README.md)

[Return to Homework 5 Landing Page](README.md)

------------------------------------------------------------------------

-   [Factor Management](#factor-management)
    1.  [Goals](#goals)
    2.  [Drop Oceania](#drop-oceania)
    3.  [Reorder the levels of country or continent](#reorder-the-levels-of-country-or-continent)
-   [File I/O](#file-io)
-   [Visualization design](#visualization-design)
-   [Writing Figures to File](#writing-figures-to-file)

------------------------------------------------------------------------

Welcome! This is my attempt at further developing my data wrangling and reshaping skills, as part of STAT 545 assignment 5. A link to the assignment itself can be found [here](http://stat545.com/hw05_factor-figure-boss-repo-hygiene.html "STAT 545 Assignment 5").

------------------------------------------------------------------------

Below are the packages that are used in the making of this assignment.

``` r
suppressPackageStartupMessages(library(gapminder))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(knitr))
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(forcats))
suppressPackageStartupMessages(library(gridExtra))
```

Factor Management
-----------------

<a href="#top">Back to top</a>

#### Goals

<a href="#top">Back to top</a>

-   Define factor variables
-   Drop factor / levels
-   Reorder levels based on knowledge from data

For this part, I will work with the `gapminder` dataset.

#### Drop Oceania

<a href="#top">Back to top</a>

First, lets make sure that the `continent` variable is indeed a factor, using the `class` function. Then we can have a look at the levels associated it. This can easily be done using the function `levels`.

``` r
class(gapminder$continent)
```

    ## [1] "factor"

``` r
levels(gapminder$continent)
```

    ## [1] "Africa"   "Americas" "Asia"     "Europe"   "Oceania"

There are five levels, corresponding to the five unique continents which are contained in this variable. How many of the entries correspond to Oceania? How many don't?

``` r
table(gapminder$continent)
```

    ## 
    ##   Africa Americas     Asia   Europe  Oceania 
    ##      624      300      396      360       24

``` r
table(gapminder$continent)[1:4] %>%
  sum()
```

    ## [1] 1680

So 24 entries are for the continent of Oceania, whereas the other 1680 rows correspond to other continents.

We can also look at the numeric values of the continent variable, which are mapped to the levels. Below I show the first 100 as an example.

``` r
as.numeric(head(gapminder$continent,n=100))
```

    ##   [1] 3 3 3 3 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 1 1 1 1 1 1 1 1 1 1 1
    ##  [36] 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 5 5 5 5 5 5 5 5 5 5
    ##  [71] 5 5 4 4 4 4 4 4 4 4 4 4 4 4 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3

So now we want to get rid of all the entries associated with Oceania, and remove it from the levels as well. My first attempt was to use the `filter` function.

``` r
gap.rm.oceania <- gapminder %>%
  filter(continent != "Oceania")
  
table(gap.rm.oceania$continent)
```

    ## 
    ##   Africa Americas     Asia   Europe  Oceania 
    ##      624      300      396      360        0

``` r
length(gap.rm.oceania$continent)
```

    ## [1] 1680

Using `filter` does indeed remove the rows associated with Oceania, as only the 1680 other rows remain. However, the level `Oceania` is still present! There are simply no entries that point to it. As you might expect, there is an R function that can get rid of unused levels: `droplevels`.

``` r
gap.rmlevel.oceania <- droplevels(gap.rm.oceania)

table(gap.rmlevel.oceania$continent)
```

    ## 
    ##   Africa Americas     Asia   Europe 
    ##      624      300      396      360

``` r
length(gap.rmlevel.oceania$continent)
```

    ## [1] 1680

Another option for getting rid of unused levels is to use the `factor` function like so:

``` r
gap.continent.rmlevel.oceania <- factor(gap.rm.oceania$continent)

table(gap.continent.rmlevel.oceania)
```

    ## gap.continent.rmlevel.oceania
    ##   Africa Americas     Asia   Europe 
    ##      624      300      396      360

``` r
length(gap.continent.rmlevel.oceania)
```

    ## [1] 1680

#### Reorder the levels of country or continent

<a href="#top">Back to top</a>

Use the forcats package to change the order of the factor levels, based on a principled summary of one of the quantitative variables. Consider experimenting with a summary statistic beyond the most basic choice of the median.

For this question, I have decided to use the range of life expectancy for each country over the years on record as my summary statistic. I calculate this below and show the first 10 entries in descending order.

``` r
gap.countries.LERange <- gapminder %>%
  group_by(country) %>%
  summarize(continent = unique(continent),
        lifeExp.Range = max(lifeExp) - min(lifeExp),
        pop.Range = max(pop) - min(pop),
        gdpPercap.Range = max(gdpPercap)-min(gdpPercap)) %>%
  arrange(desc(lifeExp.Range))
  
knitr::kable(head(gap.countries.LERange,n=10),col.names = 
        c('Country','Continent',
        'Life Expectancy (Years)',
        'Population',
        'GDP per capita'), 
        align = 'c',
        format = 'html', 
        caption = "<h4>Ranges in Life Expectancy, Population, and GDP per capita: 1952-2007</h4>")
```

<table>
<caption>
<h4>
Ranges in Life Expectancy, Population, and GDP per capita: 1952-2007
</h4>
</caption>
<thead>
<tr>
<th style="text-align:center;">
Country
</th>
<th style="text-align:center;">
Continent
</th>
<th style="text-align:center;">
Life Expectancy (Years)
</th>
<th style="text-align:center;">
Population
</th>
<th style="text-align:center;">
GDP per capita
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
Oman
</td>
<td style="text-align:center;">
Asia
</td>
<td style="text-align:center;">
38.062
</td>
<td style="text-align:center;">
2697064
</td>
<td style="text-align:center;">
20487.9626
</td>
</tr>
<tr>
<td style="text-align:center;">
Vietnam
</td>
<td style="text-align:center;">
Asia
</td>
<td style="text-align:center;">
33.837
</td>
<td style="text-align:center;">
59015517
</td>
<td style="text-align:center;">
1836.5099
</td>
</tr>
<tr>
<td style="text-align:center;">
Indonesia
</td>
<td style="text-align:center;">
Asia
</td>
<td style="text-align:center;">
33.182
</td>
<td style="text-align:center;">
141495000
</td>
<td style="text-align:center;">
2790.9699
</td>
</tr>
<tr>
<td style="text-align:center;">
Saudi Arabia
</td>
<td style="text-align:center;">
Asia
</td>
<td style="text-align:center;">
32.902
</td>
<td style="text-align:center;">
23595361
</td>
<td style="text-align:center;">
27708.2078
</td>
</tr>
<tr>
<td style="text-align:center;">
Libya
</td>
<td style="text-align:center;">
Africa
</td>
<td style="text-align:center;">
31.229
</td>
<td style="text-align:center;">
5017185
</td>
<td style="text-align:center;">
19563.6637
</td>
</tr>
<tr>
<td style="text-align:center;">
Korea, Rep.
</td>
<td style="text-align:center;">
Asia
</td>
<td style="text-align:center;">
31.170
</td>
<td style="text-align:center;">
28097219
</td>
<td style="text-align:center;">
22317.5475
</td>
</tr>
<tr>
<td style="text-align:center;">
Nicaragua
</td>
<td style="text-align:center;">
Americas
</td>
<td style="text-align:center;">
30.585
</td>
<td style="text-align:center;">
4509566
</td>
<td style="text-align:center;">
3316.2194
</td>
</tr>
<tr>
<td style="text-align:center;">
West Bank and Gaza
</td>
<td style="text-align:center;">
Asia
</td>
<td style="text-align:center;">
30.262
</td>
<td style="text-align:center;">
2987747
</td>
<td style="text-align:center;">
5595.0753
</td>
</tr>
<tr>
<td style="text-align:center;">
Yemen, Rep.
</td>
<td style="text-align:center;">
Asia
</td>
<td style="text-align:center;">
30.150
</td>
<td style="text-align:center;">
17247914
</td>
<td style="text-align:center;">
1499.0523
</td>
</tr>
<tr>
<td style="text-align:center;">
Gambia
</td>
<td style="text-align:center;">
Africa
</td>
<td style="text-align:center;">
29.448
</td>
<td style="text-align:center;">
1404039
</td>
<td style="text-align:center;">
399.5246
</td>
</tr>
</tbody>
</table>
Note that the numerical entries for the country factors have not changed after the above data manipulation, only their ordering has been changed. To show this, I'll include the numeric factors in the below table.

``` r
gap.countries.LERange %>%
  mutate(numeric.factor = as.numeric(country)) %>%
  select(country,numeric.factor,lifeExp.Range) %>%
  head(n=10) %>%
  knitr::kable(col.names = 
        c('Country','Factor','Life Expectancy Range (years)'), 
        align = 'c',
        format = 'html', 
        caption = "<h4>Numeric Factors are not Modified</h4>")
```

<table>
<caption>
<h4>
Numeric Factors are not Modified
</h4>
</caption>
<thead>
<tr>
<th style="text-align:center;">
Country
</th>
<th style="text-align:center;">
Factor
</th>
<th style="text-align:center;">
Life Expectancy Range (years)
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
Oman
</td>
<td style="text-align:center;">
97
</td>
<td style="text-align:center;">
38.062
</td>
</tr>
<tr>
<td style="text-align:center;">
Vietnam
</td>
<td style="text-align:center;">
138
</td>
<td style="text-align:center;">
33.837
</td>
</tr>
<tr>
<td style="text-align:center;">
Indonesia
</td>
<td style="text-align:center;">
60
</td>
<td style="text-align:center;">
33.182
</td>
</tr>
<tr>
<td style="text-align:center;">
Saudi Arabia
</td>
<td style="text-align:center;">
110
</td>
<td style="text-align:center;">
32.902
</td>
</tr>
<tr>
<td style="text-align:center;">
Libya
</td>
<td style="text-align:center;">
76
</td>
<td style="text-align:center;">
31.229
</td>
</tr>
<tr>
<td style="text-align:center;">
Korea, Rep.
</td>
<td style="text-align:center;">
71
</td>
<td style="text-align:center;">
31.170
</td>
</tr>
<tr>
<td style="text-align:center;">
Nicaragua
</td>
<td style="text-align:center;">
93
</td>
<td style="text-align:center;">
30.585
</td>
</tr>
<tr>
<td style="text-align:center;">
West Bank and Gaza
</td>
<td style="text-align:center;">
139
</td>
<td style="text-align:center;">
30.262
</td>
</tr>
<tr>
<td style="text-align:center;">
Yemen, Rep.
</td>
<td style="text-align:center;">
140
</td>
<td style="text-align:center;">
30.150
</td>
</tr>
<tr>
<td style="text-align:center;">
Gambia
</td>
<td style="text-align:center;">
47
</td>
<td style="text-align:center;">
29.448
</td>
</tr>
</tbody>
</table>
Just to show that these are really the same numeric labels as before, I'll output a few numeric labels directly from the original data frame.

``` r
as.numeric(gapminder$country[gapminder$country == "Oman"]) %>%
  unique()
```

    ## [1] 97

``` r
as.numeric(gapminder$country[gapminder$country == "Vietnam"]) %>%
  unique()
```

    ## [1] 138

``` r
as.numeric(gapminder$country[gapminder$country == "Indonesia"]) %>%
  unique()
```

    ## [1] 60

I want to order the factor numbers in the new dataset by life expectancy range. Since the entries are already ordered within the dataframe, I can use `forcats::fct_inorder()` to reorder the numerical entries of the factor by the order that they appear.

``` r
gap.countries.LERange$country <- fct_inorder(gap.countries.LERange$country)

gap.countries.LERange %>%
  mutate(numeric.factor = as.numeric(country)) %>%
  select(country,numeric.factor,lifeExp.Range) %>%
  head(n=10) %>%
  knitr::kable(col.names = 
        c('Country','Factor','Life Expectancy Range (years)'), 
        align = 'c',
        format = 'html', 
        caption = "<h4>Numeric Factors Reordered</h4>")
```

<table>
<caption>
<h4>
Numeric Factors Reordered
</h4>
</caption>
<thead>
<tr>
<th style="text-align:center;">
Country
</th>
<th style="text-align:center;">
Factor
</th>
<th style="text-align:center;">
Life Expectancy Range (years)
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
Oman
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
38.062
</td>
</tr>
<tr>
<td style="text-align:center;">
Vietnam
</td>
<td style="text-align:center;">
2
</td>
<td style="text-align:center;">
33.837
</td>
</tr>
<tr>
<td style="text-align:center;">
Indonesia
</td>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
33.182
</td>
</tr>
<tr>
<td style="text-align:center;">
Saudi Arabia
</td>
<td style="text-align:center;">
4
</td>
<td style="text-align:center;">
32.902
</td>
</tr>
<tr>
<td style="text-align:center;">
Libya
</td>
<td style="text-align:center;">
5
</td>
<td style="text-align:center;">
31.229
</td>
</tr>
<tr>
<td style="text-align:center;">
Korea, Rep.
</td>
<td style="text-align:center;">
6
</td>
<td style="text-align:center;">
31.170
</td>
</tr>
<tr>
<td style="text-align:center;">
Nicaragua
</td>
<td style="text-align:center;">
7
</td>
<td style="text-align:center;">
30.585
</td>
</tr>
<tr>
<td style="text-align:center;">
West Bank and Gaza
</td>
<td style="text-align:center;">
8
</td>
<td style="text-align:center;">
30.262
</td>
</tr>
<tr>
<td style="text-align:center;">
Yemen, Rep.
</td>
<td style="text-align:center;">
9
</td>
<td style="text-align:center;">
30.150
</td>
</tr>
<tr>
<td style="text-align:center;">
Gambia
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
29.448
</td>
</tr>
</tbody>
</table>
So we see that the numeric factors for the `country` variable are now relabelled in order of decreasing life expectancy range!

Now that I have my factors in order, I want to save this data frame to file. Since this is just a demo, I'll save it to my temporary folder using a uniquely generated name with `tempfile`.

``` r
tmp <- tempfile("gap_countries_LERange", fileext = ".csv")
write_csv(gap.countries.LERange,tmp)
```

It's easy to bring this data back to working memory with `read_csv`. I explicitly define the column types to avoid a warning message. Since the `.csv` file format doesn't preserve the factor indices, I also have to re-assign the `country` variable as a factor.

``` r
col.type <- cols(
  country = col_character(),
  continent = col_character(),
  lifeExp.Range = col_double(),
  pop.Range = col_double(),
  gdpPercap.Range = col_double()
)

copied.data <- read_csv(tmp,col_types = col.type) 

copied.data$country <- fct_inorder(copied.data$country)

copied.data %>%
  mutate(numeric.factor = as.numeric(country)) %>%
  select(country,numeric.factor,lifeExp.Range) %>%
  head(n=10) %>%
  knitr::kable(col.names = 
        c('Country','Factor','Life Expectancy Range (years)'), 
        align = 'c',
        format = 'html', 
        caption = "<h4>Reloaded Data</h4>")
```

<table>
<caption>
<h4>
Reloaded Data
</h4>
</caption>
<thead>
<tr>
<th style="text-align:center;">
Country
</th>
<th style="text-align:center;">
Factor
</th>
<th style="text-align:center;">
Life Expectancy Range (years)
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
Oman
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
38.062
</td>
</tr>
<tr>
<td style="text-align:center;">
Vietnam
</td>
<td style="text-align:center;">
2
</td>
<td style="text-align:center;">
33.837
</td>
</tr>
<tr>
<td style="text-align:center;">
Indonesia
</td>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
33.182
</td>
</tr>
<tr>
<td style="text-align:center;">
Saudi Arabia
</td>
<td style="text-align:center;">
4
</td>
<td style="text-align:center;">
32.902
</td>
</tr>
<tr>
<td style="text-align:center;">
Libya
</td>
<td style="text-align:center;">
5
</td>
<td style="text-align:center;">
31.229
</td>
</tr>
<tr>
<td style="text-align:center;">
Korea, Rep.
</td>
<td style="text-align:center;">
6
</td>
<td style="text-align:center;">
31.170
</td>
</tr>
<tr>
<td style="text-align:center;">
Nicaragua
</td>
<td style="text-align:center;">
7
</td>
<td style="text-align:center;">
30.585
</td>
</tr>
<tr>
<td style="text-align:center;">
West Bank and Gaza
</td>
<td style="text-align:center;">
8
</td>
<td style="text-align:center;">
30.262
</td>
</tr>
<tr>
<td style="text-align:center;">
Yemen, Rep.
</td>
<td style="text-align:center;">
9
</td>
<td style="text-align:center;">
30.150
</td>
</tr>
<tr>
<td style="text-align:center;">
Gambia
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
29.448
</td>
</tr>
</tbody>
</table>
If I load without re-assigning `country` to a factor, then it is simply loaded as a string. This means `write_csv` saves factors as their labels, numeric indices are thrown out!

``` r
copied.data.reloaded <- read_csv(tmp,col_types = col.type)

str(copied.data$country)
```

    ##  Factor w/ 142 levels "Oman","Vietnam",..: 1 2 3 4 5 6 7 8 9 10 ...

``` r
str(copied.data.reloaded$country)
```

    ##  chr [1:142] "Oman" "Vietnam" "Indonesia" "Saudi Arabia" "Libya" ...

File I/O
--------

<a href="#top">Back to top</a>

We just saw in the previous section that saving a file using `write_csv` destroys any information about factor indices. What if we want to save an R object exactly as it is in our working memory? This can be done with `saveRDS` and reloaded with `readRDS`. Let's give it a try with our modified data set. I'll once again use a temporary file name.

``` r
tmp2 <- tempfile("gap_countries_LERange", fileext = ".rds")
saveRDS(gap.countries.LERange,tmp2)
```

Reloading it and comparing the structure before and after:

``` r
copied.data.rds <- readRDS(tmp2)

str(copied.data.rds)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    142 obs. of  5 variables:
    ##  $ country        : Factor w/ 142 levels "Oman","Vietnam",..: 1 2 3 4 5 6 7 8 9 10 ...
    ##  $ continent      : Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 1 3 2 3 3 1 ...
    ##  $ lifeExp.Range  : num  38.1 33.8 33.2 32.9 31.2 ...
    ##  $ pop.Range      : num  2.70e+06 5.90e+07 1.41e+08 2.36e+07 5.02e+06 ...
    ##  $ gdpPercap.Range: num  20488 1837 2791 27708 19564 ...

``` r
str(gap.countries.LERange)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    142 obs. of  5 variables:
    ##  $ country        : Factor w/ 142 levels "Oman","Vietnam",..: 1 2 3 4 5 6 7 8 9 10 ...
    ##  $ continent      : Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 1 3 2 3 3 1 ...
    ##  $ lifeExp.Range  : num  38.1 33.8 33.2 32.9 31.2 ...
    ##  $ pop.Range      : num  2.70e+06 5.90e+07 1.41e+08 2.36e+07 5.02e+06 ...
    ##  $ gdpPercap.Range: num  20488 1837 2791 27708 19564 ...

The file is completely identical. Factors and their indices are intact. Another way of saving data is using the `dput` function. This type of write method saves an R object as an ASCII text representation, which may be useful when passing the object to different environments which may not be able to read `.rds` filetypes.

``` r
tmp3 <- tempfile("gap_countries_LERange", fileext = ".txt")
dput(gap.countries.LERange,tmp3)

dget(tmp3) %>%
  mutate(numeric.factor = as.numeric(country)) %>%
  select(country,numeric.factor,lifeExp.Range) %>%
  head(n=10) %>%
  knitr::kable(col.names = 
        c('Country','Factor','Life Expectancy Range (years)'), 
        align = 'c',
        format = 'html', 
        caption = "<h4>Reloaded Data with dget</h4>")
```

<table>
<caption>
<h4>
Reloaded Data with dget
</h4>
</caption>
<thead>
<tr>
<th style="text-align:center;">
Country
</th>
<th style="text-align:center;">
Factor
</th>
<th style="text-align:center;">
Life Expectancy Range (years)
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
Oman
</td>
<td style="text-align:center;">
1
</td>
<td style="text-align:center;">
38.062
</td>
</tr>
<tr>
<td style="text-align:center;">
Vietnam
</td>
<td style="text-align:center;">
2
</td>
<td style="text-align:center;">
33.837
</td>
</tr>
<tr>
<td style="text-align:center;">
Indonesia
</td>
<td style="text-align:center;">
3
</td>
<td style="text-align:center;">
33.182
</td>
</tr>
<tr>
<td style="text-align:center;">
Saudi Arabia
</td>
<td style="text-align:center;">
4
</td>
<td style="text-align:center;">
32.902
</td>
</tr>
<tr>
<td style="text-align:center;">
Libya
</td>
<td style="text-align:center;">
5
</td>
<td style="text-align:center;">
31.229
</td>
</tr>
<tr>
<td style="text-align:center;">
Korea, Rep.
</td>
<td style="text-align:center;">
6
</td>
<td style="text-align:center;">
31.170
</td>
</tr>
<tr>
<td style="text-align:center;">
Nicaragua
</td>
<td style="text-align:center;">
7
</td>
<td style="text-align:center;">
30.585
</td>
</tr>
<tr>
<td style="text-align:center;">
West Bank and Gaza
</td>
<td style="text-align:center;">
8
</td>
<td style="text-align:center;">
30.262
</td>
</tr>
<tr>
<td style="text-align:center;">
Yemen, Rep.
</td>
<td style="text-align:center;">
9
</td>
<td style="text-align:center;">
30.150
</td>
</tr>
<tr>
<td style="text-align:center;">
Gambia
</td>
<td style="text-align:center;">
10
</td>
<td style="text-align:center;">
29.448
</td>
</tr>
</tbody>
</table>
It seems that `dput` maintains the structure of factors as well.

Visualization design
--------------------

<a href="#top">Back to top</a>

In this section, I've decided to `join` some outside data with the `gapminder` dataframe in order to make an interesting plot. In [homework 4](https://github.com/HScheiber/STAT545-hw-Scheiber-Hayden/blob/master/hw04/tidy_joins.md#create-a-second-data-frame-complementary-to-gapminder-join-this-with-part-of-gapminder) I obtained a data set from the [world bank](https://data.worldbank.org/indicator/EG.USE.PCAP.KG.OE) that lists energy consumption per capita for 1960 to 2016. Below I re-load that data. I saved the column names for the file using `saveRDS` (not shown), so I load them first into a variable `col.metadata`.

``` r
col.metadata <- readRDS("metadata_energy.rds")

data.energy <- suppressWarnings(read_csv("Energy_use.csv", 
        col_types = col.metadata))
```

I used `suppressWarnings` because it appears that `read_csv` thinks there is an additional empty column that I did not name. I'll remove it with indexing.

``` r
data.energy <- data.energy[-length(data.energy)]
```

Here's a look at what the data frame looks like:

``` r
data.energy %>%
  head(n=5) %>%
  knitr::kable( 
        align = 'c',
        format = 'html', 
        caption = "<h4>Energy Use Per capita (Kg of oil equivalent)</h4>")
```

<table>
<caption>
<h4>
Energy Use Per capita (Kg of oil equivalent)
</h4>
</caption>
<thead>
<tr>
<th style="text-align:center;">
Country Name
</th>
<th style="text-align:center;">
Country Code
</th>
<th style="text-align:center;">
Indicator Name
</th>
<th style="text-align:center;">
Indicator Code
</th>
<th style="text-align:center;">
1960
</th>
<th style="text-align:center;">
1961
</th>
<th style="text-align:center;">
1962
</th>
<th style="text-align:center;">
1963
</th>
<th style="text-align:center;">
1964
</th>
<th style="text-align:center;">
1965
</th>
<th style="text-align:center;">
1966
</th>
<th style="text-align:center;">
1967
</th>
<th style="text-align:center;">
1968
</th>
<th style="text-align:center;">
1969
</th>
<th style="text-align:center;">
1970
</th>
<th style="text-align:center;">
1971
</th>
<th style="text-align:center;">
1972
</th>
<th style="text-align:center;">
1973
</th>
<th style="text-align:center;">
1974
</th>
<th style="text-align:center;">
1975
</th>
<th style="text-align:center;">
1976
</th>
<th style="text-align:center;">
1977
</th>
<th style="text-align:center;">
1978
</th>
<th style="text-align:center;">
1979
</th>
<th style="text-align:center;">
1980
</th>
<th style="text-align:center;">
1981
</th>
<th style="text-align:center;">
1982
</th>
<th style="text-align:center;">
1983
</th>
<th style="text-align:center;">
1984
</th>
<th style="text-align:center;">
1985
</th>
<th style="text-align:center;">
1986
</th>
<th style="text-align:center;">
1987
</th>
<th style="text-align:center;">
1988
</th>
<th style="text-align:center;">
1989
</th>
<th style="text-align:center;">
1990
</th>
<th style="text-align:center;">
1991
</th>
<th style="text-align:center;">
1992
</th>
<th style="text-align:center;">
1993
</th>
<th style="text-align:center;">
1994
</th>
<th style="text-align:center;">
1995
</th>
<th style="text-align:center;">
1996
</th>
<th style="text-align:center;">
1997
</th>
<th style="text-align:center;">
1998
</th>
<th style="text-align:center;">
1999
</th>
<th style="text-align:center;">
2000
</th>
<th style="text-align:center;">
2001
</th>
<th style="text-align:center;">
2002
</th>
<th style="text-align:center;">
2003
</th>
<th style="text-align:center;">
2004
</th>
<th style="text-align:center;">
2005
</th>
<th style="text-align:center;">
2006
</th>
<th style="text-align:center;">
2007
</th>
<th style="text-align:center;">
2008
</th>
<th style="text-align:center;">
2009
</th>
<th style="text-align:center;">
2010
</th>
<th style="text-align:center;">
2011
</th>
<th style="text-align:center;">
2012
</th>
<th style="text-align:center;">
2013
</th>
<th style="text-align:center;">
2014
</th>
<th style="text-align:center;">
2015
</th>
<th style="text-align:center;">
2016
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
Aruba
</td>
<td style="text-align:center;">
ABW
</td>
<td style="text-align:center;">
Energy use (kg of oil equivalent per capita)
</td>
<td style="text-align:center;">
EG.USE.PCAP.KG.OE
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
</tr>
<tr>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
AFG
</td>
<td style="text-align:center;">
Energy use (kg of oil equivalent per capita)
</td>
<td style="text-align:center;">
EG.USE.PCAP.KG.OE
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
</tr>
<tr>
<td style="text-align:center;">
Angola
</td>
<td style="text-align:center;">
AGO
</td>
<td style="text-align:center;">
Energy use (kg of oil equivalent per capita)
</td>
<td style="text-align:center;">
EG.USE.PCAP.KG.OE
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
555.8826
</td>
<td style="text-align:center;">
584.3152
</td>
<td style="text-align:center;">
567.5612
</td>
<td style="text-align:center;">
564.5783
</td>
<td style="text-align:center;">
536.4042
</td>
<td style="text-align:center;">
515.4481
</td>
<td style="text-align:center;">
493.8022
</td>
<td style="text-align:center;">
527.3258
</td>
<td style="text-align:center;">
518.2229
</td>
<td style="text-align:center;">
510.9863
</td>
<td style="text-align:center;">
496.8536
</td>
<td style="text-align:center;">
472.8293
</td>
<td style="text-align:center;">
468.8811
</td>
<td style="text-align:center;">
457.7808
</td>
<td style="text-align:center;">
470.3735
</td>
<td style="text-align:center;">
462.1985
</td>
<td style="text-align:center;">
460.8183
</td>
<td style="text-align:center;">
467.2142
</td>
<td style="text-align:center;">
464.9752
</td>
<td style="text-align:center;">
483.3574
</td>
<td style="text-align:center;">
479.8715
</td>
<td style="text-align:center;">
467.1092
</td>
<td style="text-align:center;">
468.0538
</td>
<td style="text-align:center;">
459.4536
</td>
<td style="text-align:center;">
445.3262
</td>
<td style="text-align:center;">
445.3477
</td>
<td style="text-align:center;">
442.7813
</td>
<td style="text-align:center;">
429.8326
</td>
<td style="text-align:center;">
438.8703
</td>
<td style="text-align:center;">
437.3376
</td>
<td style="text-align:center;">
442.0004
</td>
<td style="text-align:center;">
446.9038
</td>
<td style="text-align:center;">
465.5403
</td>
<td style="text-align:center;">
462.1575
</td>
<td style="text-align:center;">
430.9351
</td>
<td style="text-align:center;">
456.2469
</td>
<td style="text-align:center;">
469.6202
</td>
<td style="text-align:center;">
490.5364
</td>
<td style="text-align:center;">
514.4114
</td>
<td style="text-align:center;">
520.6751
</td>
<td style="text-align:center;">
521.8258
</td>
<td style="text-align:center;">
552.6229
</td>
<td style="text-align:center;">
534.1191
</td>
<td style="text-align:center;">
545.0405
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
</tr>
<tr>
<td style="text-align:center;">
Albania
</td>
<td style="text-align:center;">
ALB
</td>
<td style="text-align:center;">
Energy use (kg of oil equivalent per capita)
</td>
<td style="text-align:center;">
EG.USE.PCAP.KG.OE
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
785.1615
</td>
<td style="text-align:center;">
865.5925
</td>
<td style="text-align:center;">
762.7254
</td>
<td style="text-align:center;">
776.9347
</td>
<td style="text-align:center;">
826.9521
</td>
<td style="text-align:center;">
890.9534
</td>
<td style="text-align:center;">
923.7289
</td>
<td style="text-align:center;">
1010.8192
</td>
<td style="text-align:center;">
864.1995
</td>
<td style="text-align:center;">
1149.5361
</td>
<td style="text-align:center;">
989.2001
</td>
<td style="text-align:center;">
966.6833
</td>
<td style="text-align:center;">
1000.1220
</td>
<td style="text-align:center;">
1018.2631
</td>
<td style="text-align:center;">
916.5552
</td>
<td style="text-align:center;">
963.9272
</td>
<td style="text-align:center;">
921.8930
</td>
<td style="text-align:center;">
927.7445
</td>
<td style="text-align:center;">
896.4378
</td>
<td style="text-align:center;">
813.2557
</td>
<td style="text-align:center;">
572.7818
</td>
<td style="text-align:center;">
418.2866
</td>
<td style="text-align:center;">
412.3789
</td>
<td style="text-align:center;">
441.2493
</td>
<td style="text-align:center;">
417.0348
</td>
<td style="text-align:center;">
447.8489
</td>
<td style="text-align:center;">
384.5950
</td>
<td style="text-align:center;">
426.6828
</td>
<td style="text-align:center;">
576.1836
</td>
<td style="text-align:center;">
580.4948
</td>
<td style="text-align:center;">
597.2653
</td>
<td style="text-align:center;">
660.0480
</td>
<td style="text-align:center;">
648.1684
</td>
<td style="text-align:center;">
715.4145
</td>
<td style="text-align:center;">
719.5844
</td>
<td style="text-align:center;">
706.8594
</td>
<td style="text-align:center;">
679.8618
</td>
<td style="text-align:center;">
710.7485
</td>
<td style="text-align:center;">
732.3167
</td>
<td style="text-align:center;">
729.1544
</td>
<td style="text-align:center;">
764.9686
</td>
<td style="text-align:center;">
687.8963
</td>
<td style="text-align:center;">
801.3300
</td>
<td style="text-align:center;">
808.4558
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
</tr>
<tr>
<td style="text-align:center;">
Andorra
</td>
<td style="text-align:center;">
AND
</td>
<td style="text-align:center;">
Energy use (kg of oil equivalent per capita)
</td>
<td style="text-align:center;">
EG.USE.PCAP.KG.OE
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
</tr>
</tbody>
</table>
I want to remove columns 2:4, as well as the column for 2016, because it contains no data. I also need to rename `Country Name` to `country` so I can `join` it with `gapminder`. Finally, I also convert it into long format and remove any missing data points.

``` r
# Remove columns 2:4 plus the last column for 2016
data.energy <- data.energy %>%
  select('Country Name', as.character(1960:2015))

# Rename the columns
names(data.energy) <- c("country",1960:2015)

# Convert to long format
data.energy.long <- data.energy %>%
  gather(year, Energy.Use.Per.Capita, 2:ncol(data.energy)) %>%
  filter(!is.na(Energy.Use.Per.Capita)) %>%
  arrange(desc(Energy.Use.Per.Capita))

# Need to have year column as numeric
data.energy.long$year <- as.numeric(data.energy.long$year)

knitr::kable(head(data.energy.long), 
  align = 'c',
  format = 'html', 
  caption = "<h4>Energy Use in Kg of Oil Equivalent per Capita</h4>")
```

<table>
<caption>
<h4>
Energy Use in Kg of Oil Equivalent per Capita
</h4>
</caption>
<thead>
<tr>
<th style="text-align:center;">
country
</th>
<th style="text-align:center;">
year
</th>
<th style="text-align:center;">
Energy.Use.Per.Capita
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
Curacao
</td>
<td style="text-align:center;">
1973
</td>
<td style="text-align:center;">
40710.11
</td>
</tr>
<tr>
<td style="text-align:center;">
Curacao
</td>
<td style="text-align:center;">
1974
</td>
<td style="text-align:center;">
37557.34
</td>
</tr>
<tr>
<td style="text-align:center;">
Curacao
</td>
<td style="text-align:center;">
1971
</td>
<td style="text-align:center;">
37113.34
</td>
</tr>
<tr>
<td style="text-align:center;">
Curacao
</td>
<td style="text-align:center;">
1972
</td>
<td style="text-align:center;">
36146.70
</td>
</tr>
<tr>
<td style="text-align:center;">
Curacao
</td>
<td style="text-align:center;">
1983
</td>
<td style="text-align:center;">
28902.85
</td>
</tr>
<tr>
<td style="text-align:center;">
Curacao
</td>
<td style="text-align:center;">
1976
</td>
<td style="text-align:center;">
28353.13
</td>
</tr>
</tbody>
</table>
Time to `join` with `gapminder`. For this, I want to use `inner_join` by country and year so that I only get countries that have entries from both datasets.

``` r
gapminder.energy <- inner_join(gapminder,data.energy.long, by = c("country","year"))
```

    ## Warning: Column `country` joining factor and character vector, coercing
    ## into character vector

``` r
glimpse(gapminder.energy)
```

    ## Observations: 880
    ## Variables: 7
    ## $ country               <chr> "Albania", "Albania", "Albania", "Albani...
    ## $ continent             <fctr> Europe, Europe, Europe, Europe, Europe,...
    ## $ year                  <dbl> 1972, 1977, 1982, 1987, 1992, 1997, 2002...
    ## $ lifeExp               <dbl> 67.690, 68.930, 70.420, 72.000, 71.581, ...
    ## $ pop                   <int> 2263554, 2509048, 2780097, 3075321, 3326...
    ## $ gdpPercap             <dbl> 3313.422, 3533.004, 3630.881, 3738.933, ...
    ## $ Energy.Use.Per.Capita <dbl> 865.5925, 923.7289, 966.6833, 921.8930, ...

Now we can do some interesting plots. How about the correlation between GDP per capita and Energy use per capita? We can compare it with life Expectancy vs energy usage on the same plot.

``` r
numcountries <- length(unique(gapminder.energy$country)) %>%
  as.character()
  
# Disable scientific notation
options(scipen = 999)

plot.gdp.energy <- gapminder.energy %>%
  ggplot(aes(y = gdpPercap, x = Energy.Use.Per.Capita)) + 
  geom_point(aes(colour=continent)) +
  geom_smooth(size=1.5, method = "loess", level = 0.95, 
    fullrange = TRUE, se = TRUE, linetype = "dashed",
    colour = "black",na.rm = TRUE) +
  scale_colour_discrete("Continent") +
  scale_y_continuous(breaks = seq(0, 120000, 20000),
      labels = paste("$", seq(0, 120000, 20000), sep=""),
      limits = c(0, 120000),
      minor_breaks = NULL) +
  scale_x_continuous(breaks = seq(0, 15000, 1000),
      labels = as.character(seq(0, 15000, 1000)),
      limits = c(0, 15000),
      minor_breaks = NULL) +
  labs(y = "GDP per Capita", 
      x = "Energy Use per Capita per Year (Kg oil Equiv.)",
      title = "Correlation between Energy usage and GDP per capita",
      subtitle = paste("Data produced from", numcountries, "countries between 1962 and 2007")) +
  theme_bw() +
  theme(axis.title = element_text(size=16),
      plot.subtitle = element_text(size=12,hjust = 0.49),
      strip.text = element_text(size=14, face="bold"),
      plot.title = element_text(size=16, face="bold",hjust = 0.49),
      axis.text.x = element_text(size=12,face ="bold"),
      axis.text.y = element_text(size=12,face ="bold"),
      legend.title = element_text(size=14, face ="bold"),
      legend.text = element_text(size=12, face ="bold"))
      
      
plot.lifeExp.energy <- gapminder.energy %>%
  ggplot(aes(y = lifeExp, x = Energy.Use.Per.Capita)) + 
  geom_point(aes(colour=continent)) +
  geom_smooth(size=1.5, method = "loess", level = 0.95, 
    fullrange = TRUE, se = TRUE, linetype = "dashed",
    colour = "black",na.rm = TRUE) +
  scale_colour_discrete("Continent") +
  scale_y_continuous(breaks = seq(35, 85, 5),
      labels = seq(35, 85, 5),
      limits = c(35, 85),
      minor_breaks = NULL) +
  scale_x_continuous(breaks = seq(0, 15000, 1000),
      labels = as.character(seq(0, 15000, 1000)),
      limits = c(0, 15000),
      minor_breaks = NULL) +
  labs(y = "Life Expectancy", 
      x = "Energy Use per Capita per Year (Kg oil Equiv.)",
      title = "Correlation between Energy usage and Life Expectancy",
      subtitle = paste("Data produced from", numcountries, "countries between 1962 and 2007"),
      caption = "Data source: Gapminder and World Bank") +
  theme_bw() +
  theme(axis.title = element_text(size=16),
      plot.subtitle = element_text(size=12,hjust = 0.49),
      strip.text = element_text(size=14, face="bold"),
      plot.title = element_text(size=16, face="bold",hjust = 0.49),
      axis.text.x = element_text(size=12,face ="bold"),
      axis.text.y = element_text(size=12,face ="bold"),
      legend.title = element_text(size=14, face ="bold"),
      legend.text = element_text(size=12, face ="bold"),
      plot.caption = element_text(size=10, face ="bold"))
      
      
      
      
grid.arrange(plot.gdp.energy, plot.lifeExp.energy, nrow = 2, heights = c(0.5, 0.5))
```

![](factor_figure_management_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-23-1.png)

Those are some interesting correlations! Let's do one more: the distribution of energy use per capita in each continent.

``` r
gapminder.energy %>%
  ggplot(aes(x = Energy.Use.Per.Capita, fill = continent)) +
  facet_wrap(~continent, scales = "free_y") +
  geom_density() +
  scale_y_continuous(breaks = NULL) +
  scale_x_continuous(breaks = seq(0, 15000, 5000),
      labels = seq(0, 15000, 5000)) +
  theme_bw() +
  theme(axis.text.x = element_text(size=12,face ="bold"),
      plot.subtitle = element_text(size=12,hjust = 0.49),
      plot.title = element_text(size=16,face ="bold",hjust = 0.5),
      strip.background = element_rect(fill="#d9d9d9"),
      axis.title = element_text(size=14, face ="bold"),
      strip.text = element_text(size=14, face="bold"),
      plot.caption = element_text(size=10, face ="bold")) +
  labs(x = "Energy Use per Capita Per year (Kg Oil Equiv.)",
      subtitle = paste("Data produced from", numcountries, "countries between 1962 and 2007"),
      y = "Density of Countries (Relative to Continent)",
      title = "Spread of Energy use per Capita by Continent",
      caption = "Data source: Gapminder and World Bank") +
  guides(fill=FALSE)
```

![](factor_figure_management_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-24-1.png)

Over the last 6 or so weeks I have learned to plot beautiful images using `ggplot`. The above plots a result of the design knowledge accumulated from in-class examples and experience from previous assignments. I'm pretty happy with how my plots look now!

Writing Figures to File
-----------------------

We already have two plots assigned to variables from the previous section. Let's save one as a `PNG` image, and the other as an `pdf` image. Note that pdf images are vectorized, so their "resolution" scales as needed!

``` r
ggsave("energy_vs_gdp.png",
  plot = plot.gdp.energy, 
  device = "png",
  width = 10, 
  height = 7,
  dpi = 500)

ggsave("energy_vs_lifeExp.pdf", 
  plot = plot.lifeExp.energy,
  device = "pdf",
  width = 10,
  height = 7)
```

It seems that the `eps` format cannot encode some elements of the image. I should also note that explicitly telling `ggsave` each argument is good practice, otherwise the order of the arguments will be the only way in which `ggsave` can interpret the inputs.

It's simple enough to re-insert the saved images back into the page. This is done outside of a code chunk with `![alt text](image/path.filetype)`.

!['Energy vs GDP'](energy_vs_gdp.png)

This embedded image is higher resolution than the rendered source image!

Unfortunately, `pdf` images cannot be embedded in markdown files. Instead, you can click on [this link](energy_vs_lifeExp.pdf) to load it separately!

<a href="#top">Back to top</a>
