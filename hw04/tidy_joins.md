Homework 4 - Tidy data and joins
================
Hayden Scheiber -
07 October, 2017

[Return to Main Page](https://github.com/HScheiber/STAT545-hw-Scheiber-Hayden/blob/master/README.md)

[Return to Homework 4 Landing Page](README.md)

------------------------------------------------------------------------

-   [General data reshaping and relationship to aggregation](#general-data-reshaping-and-relationship-to-aggregation)
    1.  [Make a tibble with one row per year and columns for life expectancy for two or more countries](#make-a-tibble-with-one-row-per-year-and-columns-for-life-expectancy-for-two-or-more-countries)
    2.  [Compute some measure of life expectancy for all possible combinations of continent and year](#compute-some-measure-of-life-expectancy-for-all-possible-combinations-of-continent-and-year)
    3.  [Take a tibble with 24 rows: 2 per year, and reshape it so you have one row per year](#take-a-tibble-with-24-rows-2-per-year-and-reshape-it-so-you-have-one-row-per-year)
-   [Join, merge, look up](#join-merge-look-up)
    1.  [Create a second data frame, complementary to Gapminder. Join this with part of Gapminder](#create-a-second-data-frame-complementary-to-gapminder-join-this-with-part-of-gapminder)

------------------------------------------------------------------------

Welcome! This is the data wrangling and reshaping skills development, as part of STAT 545 assignment 4.

First we need to load the `gapminder` dataset and the `tidyverse` package, as well as `knitr` for nicer table outputs. When making my plots I realized that I needed to re-shaped a data-frame using a function from `reshape2`, so I load that library as well.

``` r
suppressPackageStartupMessages(library(gapminder))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(knitr))
suppressPackageStartupMessages(library(reshape2))
```

General data reshaping and relationship to aggregation
------------------------------------------------------

### Make a tibble with one row per year and columns for life expectancy for two or more countries

<a href="#top">Back to top</a>

Let's compare life expectancy of *Canada*, *Rwanada*, and *China*. I begin by selecting data only from those countries using `filter`. Then, using `select` I retain only the columns I want to keep. I'll show the first 5 rows of this table to give an idea of what it looks like.

``` r
data.selected.long <- gapminder %>%
        filter(country %in% c('Canada', 'Rwanda', 'China')) %>%
        select(country, year,lifeExp)

knitr::kable(head(data.selected.long,n=5))
```

| country |  year|  lifeExp|
|:--------|-----:|--------:|
| Canada  |  1952|    68.75|
| Canada  |  1957|    69.96|
| Canada  |  1962|    71.30|
| Canada  |  1967|    72.13|
| Canada  |  1972|    72.88|

Now it's time to reshape this data into the form we want. The `spread` function is used to convert a single column into multiple columns. This is useful for our *country* column because there are only three values present there, which will become the three new columns in the reshaped dataframe.

``` r
data.selected.wide <- data.selected.long %>%
        spread(country,lifeExp) 

knitr::kable(data.selected.wide,col.names = 
        c('Year','Life Expectancy in Canada (Years)', 
        'Life Expectancy in China (Years)', 
        'Life Expectancy in Rwanda (Years)'),
        align = 'c',
        caption = 'Based on data from Gapminder',
        format = 'markdown')
```

<table style="width:100%;">
<colgroup>
<col width="6%" />
<col width="31%" />
<col width="30%" />
<col width="31%" />
</colgroup>
<thead>
<tr class="header">
<th align="center">Year</th>
<th align="center">Life Expectancy in Canada (Years)</th>
<th align="center">Life Expectancy in China (Years)</th>
<th align="center">Life Expectancy in Rwanda (Years)</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center">1952</td>
<td align="center">68.750</td>
<td align="center">44.00000</td>
<td align="center">40.000</td>
</tr>
<tr class="even">
<td align="center">1957</td>
<td align="center">69.960</td>
<td align="center">50.54896</td>
<td align="center">41.500</td>
</tr>
<tr class="odd">
<td align="center">1962</td>
<td align="center">71.300</td>
<td align="center">44.50136</td>
<td align="center">43.000</td>
</tr>
<tr class="even">
<td align="center">1967</td>
<td align="center">72.130</td>
<td align="center">58.38112</td>
<td align="center">44.100</td>
</tr>
<tr class="odd">
<td align="center">1972</td>
<td align="center">72.880</td>
<td align="center">63.11888</td>
<td align="center">44.600</td>
</tr>
<tr class="even">
<td align="center">1977</td>
<td align="center">74.210</td>
<td align="center">63.96736</td>
<td align="center">45.000</td>
</tr>
<tr class="odd">
<td align="center">1982</td>
<td align="center">75.760</td>
<td align="center">65.52500</td>
<td align="center">46.218</td>
</tr>
<tr class="even">
<td align="center">1987</td>
<td align="center">76.860</td>
<td align="center">67.27400</td>
<td align="center">44.020</td>
</tr>
<tr class="odd">
<td align="center">1992</td>
<td align="center">77.950</td>
<td align="center">68.69000</td>
<td align="center">23.599</td>
</tr>
<tr class="even">
<td align="center">1997</td>
<td align="center">78.610</td>
<td align="center">70.42600</td>
<td align="center">36.087</td>
</tr>
<tr class="odd">
<td align="center">2002</td>
<td align="center">79.770</td>
<td align="center">72.02800</td>
<td align="center">43.413</td>
</tr>
<tr class="even">
<td align="center">2007</td>
<td align="center">80.653</td>
<td align="center">72.96100</td>
<td align="center">46.242</td>
</tr>
</tbody>
</table>

I found that it was easier to use the long format to make a scatterplot comparison of the selected country's life expectancies vs year.

``` r
data.selected.long %>%
  ggplot(aes(x = year, y = lifeExp, colour=country)) + 
  geom_point() +
  scale_colour_discrete("Country") +
  scale_x_continuous(breaks = seq(1950, 2010, 10),
      labels = as.character(seq(1950, 2010, 10)),
      limits = c(1950, 2010),
      minor_breaks = NULL) +
  scale_y_continuous(breaks = seq(0, 85, 5),
      labels = as.character(seq(0, 85, 5)),
      limits = c(5, 85),
      minor_breaks = NULL) +
  theme_bw() + # black and white theme
  theme(axis.title = element_text(size=14),
      strip.text = element_text(size=14, face="bold"),
      plot.title = element_text(size=14, face="bold",hjust = 0.49),
      axis.text.x = element_text(size=12,face ="bold"),
      axis.text.y = element_text(size=12,face ="bold"),
      legend.title = element_text(size=14, face ="bold"),
      legend.text = element_text(size=12, face ="bold")) +
  labs(x = "Year", 
      y = "Life Expectancy",
      title = "Comparison of Life Expectancies: Canada, Rwanada, and China",
      caption = "Based on data from Gapminder")
```

![](tidy_joins_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-1.png)

### Compute some measure of life expectancy for all possible combinations of continent and year

<a href="#top">Back to top</a>

In this section, I have decided that I will compute the median life expectancy for each continent at each year.

``` r
data.lifeExp.wide <- gapminder %>%
        group_by(continent, year) %>%
        mutate(lifeExp.median = median(lifeExp)) %>%
        select(continent, year, lifeExp.median) %>%
        unique() %>%
        spread(continent,lifeExp.median)

knitr::kable(data.lifeExp.wide,col.names = 
        c('Year','Africa', 
        'Americas', 
        'Asia', 
        'Europe', 
        'Oceania'),
        align = 'c',
        format = 'html', 
        caption = "<h4>Median Life Expectancy by Continent (Years)</h4>")
```

<table>
<caption>
<h4>
Median Life Expectancy by Continent (Years)
</h4>
</caption>
<thead>
<tr>
<th style="text-align:center;">
Year
</th>
<th style="text-align:center;">
Africa
</th>
<th style="text-align:center;">
Americas
</th>
<th style="text-align:center;">
Asia
</th>
<th style="text-align:center;">
Europe
</th>
<th style="text-align:center;">
Oceania
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
1952
</td>
<td style="text-align:center;">
38.8330
</td>
<td style="text-align:center;">
54.745
</td>
<td style="text-align:center;">
44.869
</td>
<td style="text-align:center;">
65.9000
</td>
<td style="text-align:center;">
69.2550
</td>
</tr>
<tr>
<td style="text-align:center;">
1957
</td>
<td style="text-align:center;">
40.5925
</td>
<td style="text-align:center;">
56.074
</td>
<td style="text-align:center;">
48.284
</td>
<td style="text-align:center;">
67.6500
</td>
<td style="text-align:center;">
70.2950
</td>
</tr>
<tr>
<td style="text-align:center;">
1962
</td>
<td style="text-align:center;">
42.6305
</td>
<td style="text-align:center;">
58.299
</td>
<td style="text-align:center;">
49.325
</td>
<td style="text-align:center;">
69.5250
</td>
<td style="text-align:center;">
71.0850
</td>
</tr>
<tr>
<td style="text-align:center;">
1967
</td>
<td style="text-align:center;">
44.6985
</td>
<td style="text-align:center;">
60.523
</td>
<td style="text-align:center;">
53.655
</td>
<td style="text-align:center;">
70.6100
</td>
<td style="text-align:center;">
71.3100
</td>
</tr>
<tr>
<td style="text-align:center;">
1972
</td>
<td style="text-align:center;">
47.0315
</td>
<td style="text-align:center;">
63.441
</td>
<td style="text-align:center;">
56.950
</td>
<td style="text-align:center;">
70.8850
</td>
<td style="text-align:center;">
71.9100
</td>
</tr>
<tr>
<td style="text-align:center;">
1977
</td>
<td style="text-align:center;">
49.2725
</td>
<td style="text-align:center;">
66.353
</td>
<td style="text-align:center;">
60.765
</td>
<td style="text-align:center;">
72.3350
</td>
<td style="text-align:center;">
72.8550
</td>
</tr>
<tr>
<td style="text-align:center;">
1982
</td>
<td style="text-align:center;">
50.7560
</td>
<td style="text-align:center;">
67.405
</td>
<td style="text-align:center;">
63.739
</td>
<td style="text-align:center;">
73.4900
</td>
<td style="text-align:center;">
74.2900
</td>
</tr>
<tr>
<td style="text-align:center;">
1987
</td>
<td style="text-align:center;">
51.6395
</td>
<td style="text-align:center;">
69.498
</td>
<td style="text-align:center;">
66.295
</td>
<td style="text-align:center;">
74.8150
</td>
<td style="text-align:center;">
75.3200
</td>
</tr>
<tr>
<td style="text-align:center;">
1992
</td>
<td style="text-align:center;">
52.4290
</td>
<td style="text-align:center;">
69.862
</td>
<td style="text-align:center;">
68.690
</td>
<td style="text-align:center;">
75.4510
</td>
<td style="text-align:center;">
76.9450
</td>
</tr>
<tr>
<td style="text-align:center;">
1997
</td>
<td style="text-align:center;">
52.7590
</td>
<td style="text-align:center;">
72.146
</td>
<td style="text-align:center;">
70.265
</td>
<td style="text-align:center;">
76.1160
</td>
<td style="text-align:center;">
78.1900
</td>
</tr>
<tr>
<td style="text-align:center;">
2002
</td>
<td style="text-align:center;">
51.2355
</td>
<td style="text-align:center;">
72.047
</td>
<td style="text-align:center;">
71.028
</td>
<td style="text-align:center;">
77.5365
</td>
<td style="text-align:center;">
79.7400
</td>
</tr>
<tr>
<td style="text-align:center;">
2007
</td>
<td style="text-align:center;">
52.9265
</td>
<td style="text-align:center;">
72.899
</td>
<td style="text-align:center;">
72.396
</td>
<td style="text-align:center;">
78.6085
</td>
<td style="text-align:center;">
80.7195
</td>
</tr>
</tbody>
</table>
To exchange columns for rows is very easy in R. Just use the transpose function `t()`.

``` r
data.lifeExp.wide.t <- t(data.lifeExp.wide)
  
# This step forces the years to be formatted as integers instead of floating point numbers
data.lifeExp.wide.t.table <- rbind(formatC(data.lifeExp.wide.t[1,],format="d"),
        data.lifeExp.wide.t[-1,])

knitr::kable(data.lifeExp.wide.t.table, 
        col.names = NULL,
        align = 'c',
        format = 'html', 
        caption = "<h4>Median Life Expectancy by Continent (Years)</h4>")
```

<table>
<caption>
<h4>
Median Life Expectancy by Continent (Years)
</h4>
</caption>
<tbody>
<tr>
<td style="text-align:left;">
</td>
<td style="text-align:center;">
1952
</td>
<td style="text-align:center;">
1957
</td>
<td style="text-align:center;">
1962
</td>
<td style="text-align:center;">
1967
</td>
<td style="text-align:center;">
1972
</td>
<td style="text-align:center;">
1977
</td>
<td style="text-align:center;">
1982
</td>
<td style="text-align:center;">
1987
</td>
<td style="text-align:center;">
1992
</td>
<td style="text-align:center;">
1997
</td>
<td style="text-align:center;">
2002
</td>
<td style="text-align:center;">
2007
</td>
</tr>
<tr>
<td style="text-align:left;">
Africa
</td>
<td style="text-align:center;">
38.833
</td>
<td style="text-align:center;">
40.5925
</td>
<td style="text-align:center;">
42.6305
</td>
<td style="text-align:center;">
44.6985
</td>
<td style="text-align:center;">
47.0315
</td>
<td style="text-align:center;">
49.2725
</td>
<td style="text-align:center;">
50.756
</td>
<td style="text-align:center;">
51.6395
</td>
<td style="text-align:center;">
52.429
</td>
<td style="text-align:center;">
52.759
</td>
<td style="text-align:center;">
51.2355
</td>
<td style="text-align:center;">
52.9265
</td>
</tr>
<tr>
<td style="text-align:left;">
Americas
</td>
<td style="text-align:center;">
54.745
</td>
<td style="text-align:center;">
56.074
</td>
<td style="text-align:center;">
58.299
</td>
<td style="text-align:center;">
60.523
</td>
<td style="text-align:center;">
63.441
</td>
<td style="text-align:center;">
66.353
</td>
<td style="text-align:center;">
67.405
</td>
<td style="text-align:center;">
69.498
</td>
<td style="text-align:center;">
69.862
</td>
<td style="text-align:center;">
72.146
</td>
<td style="text-align:center;">
72.047
</td>
<td style="text-align:center;">
72.899
</td>
</tr>
<tr>
<td style="text-align:left;">
Asia
</td>
<td style="text-align:center;">
44.869
</td>
<td style="text-align:center;">
48.284
</td>
<td style="text-align:center;">
49.325
</td>
<td style="text-align:center;">
53.655
</td>
<td style="text-align:center;">
56.95
</td>
<td style="text-align:center;">
60.765
</td>
<td style="text-align:center;">
63.739
</td>
<td style="text-align:center;">
66.295
</td>
<td style="text-align:center;">
68.69
</td>
<td style="text-align:center;">
70.265
</td>
<td style="text-align:center;">
71.028
</td>
<td style="text-align:center;">
72.396
</td>
</tr>
<tr>
<td style="text-align:left;">
Europe
</td>
<td style="text-align:center;">
65.9
</td>
<td style="text-align:center;">
67.65
</td>
<td style="text-align:center;">
69.525
</td>
<td style="text-align:center;">
70.61
</td>
<td style="text-align:center;">
70.885
</td>
<td style="text-align:center;">
72.335
</td>
<td style="text-align:center;">
73.49
</td>
<td style="text-align:center;">
74.815
</td>
<td style="text-align:center;">
75.451
</td>
<td style="text-align:center;">
76.116
</td>
<td style="text-align:center;">
77.5365
</td>
<td style="text-align:center;">
78.6085
</td>
</tr>
<tr>
<td style="text-align:left;">
Oceania
</td>
<td style="text-align:center;">
69.255
</td>
<td style="text-align:center;">
70.295
</td>
<td style="text-align:center;">
71.085
</td>
<td style="text-align:center;">
71.31
</td>
<td style="text-align:center;">
71.91
</td>
<td style="text-align:center;">
72.855
</td>
<td style="text-align:center;">
74.29
</td>
<td style="text-align:center;">
75.32
</td>
<td style="text-align:center;">
76.945
</td>
<td style="text-align:center;">
78.19
</td>
<td style="text-align:center;">
79.74
</td>
<td style="text-align:center;">
80.7195
</td>
</tr>
</tbody>
</table>
This type of data format is human readable, but it isn't the best format for `ggplot`. The only types of plots I could *maybe* see being easier with these formats are comparisons between different years or different continents. Even then, it seems to make colouring points by continent more awkward.

``` r
ggplot(data.lifeExp.wide,aes(x = year)) +
  geom_point(aes(y=Europe, colour='Europe')) +
  geom_point(aes(y=Asia, colour='Asia')) +
  scale_x_continuous(breaks = seq(1950, 2010, 10),
    labels = as.character(seq(1950, 2010, 10)),
    limits = c(1950, 2010),
    minor_breaks = NULL) +
  scale_colour_discrete(name = "Continent") +
  theme_minimal() +
  theme(axis.text.x = element_text(size=12,face ="bold"),
    axis.text.y = element_text(size=12,face ="bold"),
    plot.title = element_text(size=16,face ="bold",hjust = 0.5),
    axis.title = element_text(size=14, face ="bold"),
    legend.title = element_text(size=14, face ="bold"),
    legend.text = element_text(size=12, face ="bold")) +
  labs(x = "Year", 
    y = "Median Life Expectancy (Year)",
    title = "Comparison of Median Life Expectancy by Year: Asia vs Europe",
    caption = "Based on data from Gapminder")
```

![](tidy_joins_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-7-1.png)

If we use data in long format, as below, only a single layer of `geom_point` is required, but I also have to `filter` the data first. I think this method is better simply because of the colour aesthetic, which automatically maps to continent. In the previous example I had to manually map it, which just felt wrong.

``` r
# Same process as before, but without spread
data.lifeExp.long <- gapminder %>%
  group_by(continent, year) %>%
  mutate(lifeExp.median = median(lifeExp)) %>%
  select(continent, year, lifeExp.median) %>%
  unique()

data.lifeExp.long %>%
  filter(continent %in% c('Americas','Africa')) %>%
  ggplot(aes(x = year, y = lifeExp.median, colour = continent)) +
  geom_point() +
  scale_x_continuous(breaks = seq(1950, 2010, 10),
    labels = as.character(seq(1950, 2010, 10)),
    limits = c(1950, 2010),
    minor_breaks = NULL) +
  scale_colour_discrete(name = "Continent") +
  theme_minimal() +
  theme(axis.text.x = element_text(size=12,face ="bold"),
    axis.text.y = element_text(size=12,face ="bold"),
    plot.title = element_text(size=16,face ="bold",hjust = 0.5),
    axis.title = element_text(size=14, face ="bold"),
    legend.title = element_text(size=14, face ="bold"),
    legend.text = element_text(size=12, face ="bold")) +
  labs(x = "Year", 
    y = "Median Life Expectancy (Year)",
    title = "Comparison of Median Life Expectancy by Year: Americas vs Africa",
    caption = "Based on data from Gapminder")
```

![](tidy_joins_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-8-1.png)

### Take a tibble with 24 rows: 2 per year, and reshape it so you have one row per year

<a href="#top">Back to top</a>

For this, we start with the tibble created [here](http://stat545.com/block010_dplyr-end-single-table.html#window-functions "Window Functions").

``` r
data.lifeExp.Asia <- gapminder %>%
  filter(continent == "Asia") %>%
  select(year, country, lifeExp) %>%
  group_by(year) %>%
  filter(min_rank(desc(lifeExp)) < 2 | min_rank(lifeExp) < 2) %>% 
  arrange(year)

knitr::kable(data.lifeExp.Asia, 
  col.names = c('Year','Country','Life Expectancy (Years)'),
  align = 'c',
  format = 'html', 
  caption = "<h4>Highest and Lowest Life Expectancy by Year in Asia</h4>")
```

<table>
<caption>
<h4>
Highest and Lowest Life Expectancy by Year in Asia
</h4>
</caption>
<thead>
<tr>
<th style="text-align:center;">
Year
</th>
<th style="text-align:center;">
Country
</th>
<th style="text-align:center;">
Life Expectancy (Years)
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
1952
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
28.801
</td>
</tr>
<tr>
<td style="text-align:center;">
1952
</td>
<td style="text-align:center;">
Israel
</td>
<td style="text-align:center;">
65.390
</td>
</tr>
<tr>
<td style="text-align:center;">
1957
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
30.332
</td>
</tr>
<tr>
<td style="text-align:center;">
1957
</td>
<td style="text-align:center;">
Israel
</td>
<td style="text-align:center;">
67.840
</td>
</tr>
<tr>
<td style="text-align:center;">
1962
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
31.997
</td>
</tr>
<tr>
<td style="text-align:center;">
1962
</td>
<td style="text-align:center;">
Israel
</td>
<td style="text-align:center;">
69.390
</td>
</tr>
<tr>
<td style="text-align:center;">
1967
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
34.020
</td>
</tr>
<tr>
<td style="text-align:center;">
1967
</td>
<td style="text-align:center;">
Japan
</td>
<td style="text-align:center;">
71.430
</td>
</tr>
<tr>
<td style="text-align:center;">
1972
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
36.088
</td>
</tr>
<tr>
<td style="text-align:center;">
1972
</td>
<td style="text-align:center;">
Japan
</td>
<td style="text-align:center;">
73.420
</td>
</tr>
<tr>
<td style="text-align:center;">
1977
</td>
<td style="text-align:center;">
Cambodia
</td>
<td style="text-align:center;">
31.220
</td>
</tr>
<tr>
<td style="text-align:center;">
1977
</td>
<td style="text-align:center;">
Japan
</td>
<td style="text-align:center;">
75.380
</td>
</tr>
<tr>
<td style="text-align:center;">
1982
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
39.854
</td>
</tr>
<tr>
<td style="text-align:center;">
1982
</td>
<td style="text-align:center;">
Japan
</td>
<td style="text-align:center;">
77.110
</td>
</tr>
<tr>
<td style="text-align:center;">
1987
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
40.822
</td>
</tr>
<tr>
<td style="text-align:center;">
1987
</td>
<td style="text-align:center;">
Japan
</td>
<td style="text-align:center;">
78.670
</td>
</tr>
<tr>
<td style="text-align:center;">
1992
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
41.674
</td>
</tr>
<tr>
<td style="text-align:center;">
1992
</td>
<td style="text-align:center;">
Japan
</td>
<td style="text-align:center;">
79.360
</td>
</tr>
<tr>
<td style="text-align:center;">
1997
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
41.763
</td>
</tr>
<tr>
<td style="text-align:center;">
1997
</td>
<td style="text-align:center;">
Japan
</td>
<td style="text-align:center;">
80.690
</td>
</tr>
<tr>
<td style="text-align:center;">
2002
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
42.129
</td>
</tr>
<tr>
<td style="text-align:center;">
2002
</td>
<td style="text-align:center;">
Japan
</td>
<td style="text-align:center;">
82.000
</td>
</tr>
<tr>
<td style="text-align:center;">
2007
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
43.828
</td>
</tr>
<tr>
<td style="text-align:center;">
2007
</td>
<td style="text-align:center;">
Japan
</td>
<td style="text-align:center;">
82.603
</td>
</tr>
</tbody>
</table>
I would like to reshape this data so that there is only one row per year. I think there is probably an easier way of doing this, but I found a way that worked! I added new columns that indicated the maximum and minimum life expectancy of each year group, then cut away the previous and removed the duplicates.

``` r
data.lifeExp.Asia.grouped <- data.lifeExp.Asia %>%
  group_by(year) %>%
  mutate(min.lifeExp = min(lifeExp), 
         max.lifeExp = max(lifeExp),
         min.lifeExp.Country = country[1], 
         max.lifeExp.Country = country[2]) %>%
  select(year, 
         min.lifeExp.Country,
         min.lifeExp,
         max.lifeExp.Country,
         max.lifeExp) %>%
  unique()

knitr::kable(data.lifeExp.Asia.grouped,
  col.names = c("Year", 
                "Country with Lowest Life Expectancy",
                "Life Expectancy (Years)",
                "Country with Highest Life Expectancy",
                "Life Expectancy (Years)"),
  align = 'c',
  format = 'html', 
  caption = "<h4>Highest and Lowest Life Expectancy by Year in Asia (Years)</h4>")
```

<table>
<caption>
<h4>
Highest and Lowest Life Expectancy by Year in Asia (Years)
</h4>
</caption>
<thead>
<tr>
<th style="text-align:center;">
Year
</th>
<th style="text-align:center;">
Country with Lowest Life Expectancy
</th>
<th style="text-align:center;">
Life Expectancy (Years)
</th>
<th style="text-align:center;">
Country with Highest Life Expectancy
</th>
<th style="text-align:center;">
Life Expectancy (Years)
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
1952
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
28.801
</td>
<td style="text-align:center;">
Israel
</td>
<td style="text-align:center;">
65.390
</td>
</tr>
<tr>
<td style="text-align:center;">
1957
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
30.332
</td>
<td style="text-align:center;">
Israel
</td>
<td style="text-align:center;">
67.840
</td>
</tr>
<tr>
<td style="text-align:center;">
1962
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
31.997
</td>
<td style="text-align:center;">
Israel
</td>
<td style="text-align:center;">
69.390
</td>
</tr>
<tr>
<td style="text-align:center;">
1967
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
34.020
</td>
<td style="text-align:center;">
Japan
</td>
<td style="text-align:center;">
71.430
</td>
</tr>
<tr>
<td style="text-align:center;">
1972
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
36.088
</td>
<td style="text-align:center;">
Japan
</td>
<td style="text-align:center;">
73.420
</td>
</tr>
<tr>
<td style="text-align:center;">
1977
</td>
<td style="text-align:center;">
Cambodia
</td>
<td style="text-align:center;">
31.220
</td>
<td style="text-align:center;">
Japan
</td>
<td style="text-align:center;">
75.380
</td>
</tr>
<tr>
<td style="text-align:center;">
1982
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
39.854
</td>
<td style="text-align:center;">
Japan
</td>
<td style="text-align:center;">
77.110
</td>
</tr>
<tr>
<td style="text-align:center;">
1987
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
40.822
</td>
<td style="text-align:center;">
Japan
</td>
<td style="text-align:center;">
78.670
</td>
</tr>
<tr>
<td style="text-align:center;">
1992
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
41.674
</td>
<td style="text-align:center;">
Japan
</td>
<td style="text-align:center;">
79.360
</td>
</tr>
<tr>
<td style="text-align:center;">
1997
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
41.763
</td>
<td style="text-align:center;">
Japan
</td>
<td style="text-align:center;">
80.690
</td>
</tr>
<tr>
<td style="text-align:center;">
2002
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
42.129
</td>
<td style="text-align:center;">
Japan
</td>
<td style="text-align:center;">
82.000
</td>
</tr>
<tr>
<td style="text-align:center;">
2007
</td>
<td style="text-align:center;">
Afghanistan
</td>
<td style="text-align:center;">
43.828
</td>
<td style="text-align:center;">
Japan
</td>
<td style="text-align:center;">
82.603
</td>
</tr>
</tbody>
</table>
Join, merge, look up
--------------------

### Create a second data frame, complementary to Gapminder. Join this with part of Gapminder

<a href="#top">Back to top</a>

Hello.
