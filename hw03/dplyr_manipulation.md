Homework 3 - Gapminder Manipulation and Exploration with dplyr
================
Hayden Scheiber
29 September, 2017

-   [1. Task Menu](#task-menu)
    -   [1.1 Get the maximum and minimum of GDP per capita for all continents.](#get-the-maximum-and-minimum-of-gdp-per-capita-for-all-continents.)
    -   [1.2 Look at the spread of GDP per capita within the continents.](#look-at-the-spread-of-gdp-per-capita-within-the-continents.)

------------------------------------------------------------------------

Welcome! This is an exploration of the Gapminder data frame, as part of STAT 545 assignment 2. Click [here](README.md) to return to the homework 3 landing page, or [here](https://github.com/HScheiber/STAT545-hw-Scheiber-Hayden/blob/master/README.md) to return repository home page.

First we need to load the `gapminder` dataset and the `tidyverse` package, as well as `knitr` for nicer table outputs. When making my plots I realized that I needed to re-shaped a data-frame using a function from `reshape2`, so I load that library as well.

``` r
suppressPackageStartupMessages(library(gapminder))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(knitr))
suppressPackageStartupMessages(library(reshape2))
```

Here's an example of how to use `knitr::kable()` to make nicer looking tables. The `head()` command outputs the first `n` rows of an input data frame.

``` r
knitr::kable(head(gapminder,n=15))
```

| country     | continent |  year|  lifeExp|       pop|  gdpPercap|
|:------------|:----------|-----:|--------:|---------:|----------:|
| Afghanistan | Asia      |  1952|   28.801|   8425333|   779.4453|
| Afghanistan | Asia      |  1957|   30.332|   9240934|   820.8530|
| Afghanistan | Asia      |  1962|   31.997|  10267083|   853.1007|
| Afghanistan | Asia      |  1967|   34.020|  11537966|   836.1971|
| Afghanistan | Asia      |  1972|   36.088|  13079460|   739.9811|
| Afghanistan | Asia      |  1977|   38.438|  14880372|   786.1134|
| Afghanistan | Asia      |  1982|   39.854|  12881816|   978.0114|
| Afghanistan | Asia      |  1987|   40.822|  13867957|   852.3959|
| Afghanistan | Asia      |  1992|   41.674|  16317921|   649.3414|
| Afghanistan | Asia      |  1997|   41.763|  22227415|   635.3414|
| Afghanistan | Asia      |  2002|   42.129|  25268405|   726.7341|
| Afghanistan | Asia      |  2007|   43.828|  31889923|   974.5803|
| Albania     | Europe    |  1952|   55.230|   1282697|  1601.0561|
| Albania     | Europe    |  1957|   59.280|   1476505|  1942.2842|
| Albania     | Europe    |  1962|   64.820|   1728137|  2312.8890|

1. Task Menu
------------

#### 1.1 Get the maximum and minimum of GDP per capita for all continents.

This can be acheived easily using the `group_by()` combined with `summarize()`. Below, I group the gapminder data frame by continent and pipe that result into the summarize function, where I utilize the `max()` and `min()` functions to find the range of GDP per capita for each continent.

``` r
p1 <- group_by(gapminder,continent) %>%
  summarize(Max_GDPperCap=max(gdpPercap), Min_GPDperCap = min(gdpPercap)) 
knitr::kable(p1)
```

| continent |  Max\_GDPperCap|  Min\_GPDperCap|
|:----------|---------------:|---------------:|
| Africa    |        21951.21|        241.1659|
| Americas  |        42951.65|       1201.6372|
| Asia      |       113523.13|        331.0000|
| Europe    |        49357.19|        973.5332|
| Oceania   |        34435.37|      10039.5956|

I want to compare the min and max gdp per capita on the same plot. In order to do this, i need to utilize `reshape2::melt()` to get both GDP minimum and maximum under the same variable. I'm not sure if this is the only solution to my problem, but I couldn't find any other way to easily do this.

``` r
p2 <- reshape2::melt(p1,id = c("continent"))

knitr::kable(p2)
```

| continent | variable       |        value|
|:----------|:---------------|------------:|
| Africa    | Max\_GDPperCap |   21951.2118|
| Americas  | Max\_GDPperCap |   42951.6531|
| Asia      | Max\_GDPperCap |  113523.1329|
| Europe    | Max\_GDPperCap |   49357.1902|
| Oceania   | Max\_GDPperCap |   34435.3674|
| Africa    | Min\_GPDperCap |     241.1659|
| Americas  | Min\_GPDperCap |    1201.6372|
| Asia      | Min\_GPDperCap |     331.0000|
| Europe    | Min\_GPDperCap |     973.5332|
| Oceania   | Min\_GPDperCap |   10039.5956|

With above reorganized data frame, we can plot min and max GDP of each continent side-by side in the same bar plot. I took a lot of time to add theme changes here to spice things up a bit. I also spent some time to figure out how to include only some labels on the breaks of the y axis, as I used a log y-axis. Producing this plot was a learning experience for me. I even utilized a for loop!

``` r
breakvector <- c(1:10 %o% 10^(0:4)) # Define a vector of values for the log scale break lines, %o% is the outer product of the two lists
options(scipen=5) # Disable scientific notation
labelvector = vector("list",length(breakvector)) # initialize a blank list of equal length for the labels of the breaks

for (i in 1:length(labelvector)) { # Loop over all labels in 'labelvector' variable
  if (i %% 10 == 0 | i == 1) {
    labelvector[i] <- paste("$",toString(breakvector[i]),sep="") # Include the label for every 10th line break (ie $1, $10, $100...)
  }else{
    labelvector[i] <- "" # For all other line breaks, include blank label
  }
}

p2 %>%
  ggplot(aes(x = continent, y = value, fill = variable)) + 
  geom_bar(stat="identity", position='dodge',color='black') + 
  scale_fill_discrete("Legend", # Modifying legend title and labels
      labels = c("Maximum GDP per capita",
                 "Minimum GDP per capita")) + 
  scale_y_log10(breaks=breakvector, # Adding log scale lines, keeping only some labels
      labels=labelvector) +
  theme_bw() + # black and white theme
  theme(axis.title = element_text(size=14),
      strip.text = element_text(size=14, face="bold"),
      plot.title = element_text(hjust = 0.5)) +
  labs(x = "Continent", 
      y = "GDP Per Capita",
      title = "Minimum and Maximum GDP per capita of the Continents: 1952 - 2007",
      caption = "Based on data from Gapminder")
```

![](dplyr_manipulation_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-5-1.png)

#### 1.2 Look at the spread of GDP per capita within the continents.

For this, we need to group the data set by continent. Let's separate by decade: 50's 60's 70's 80's 90's 00's

``` r
p3 <- group_by(gapminder,continent,year) %>%
  filter(year > 2000)

knitr::kable(p3)
```

| country                  | continent |  year|  lifeExp|         pop|   gdpPercap|
|:-------------------------|:----------|-----:|--------:|-----------:|-----------:|
| Afghanistan              | Asia      |  2002|   42.129|    25268405|    726.7341|
| Afghanistan              | Asia      |  2007|   43.828|    31889923|    974.5803|
| Albania                  | Europe    |  2002|   75.651|     3508512|   4604.2117|
| Albania                  | Europe    |  2007|   76.423|     3600523|   5937.0295|
| Algeria                  | Africa    |  2002|   70.994|    31287142|   5288.0404|
| Algeria                  | Africa    |  2007|   72.301|    33333216|   6223.3675|
| Angola                   | Africa    |  2002|   41.003|    10866106|   2773.2873|
| Angola                   | Africa    |  2007|   42.731|    12420476|   4797.2313|
| Argentina                | Americas  |  2002|   74.340|    38331121|   8797.6407|
| Argentina                | Americas  |  2007|   75.320|    40301927|  12779.3796|
| Australia                | Oceania   |  2002|   80.370|    19546792|  30687.7547|
| Australia                | Oceania   |  2007|   81.235|    20434176|  34435.3674|
| Austria                  | Europe    |  2002|   78.980|     8148312|  32417.6077|
| Austria                  | Europe    |  2007|   79.829|     8199783|  36126.4927|
| Bahrain                  | Asia      |  2002|   74.795|      656397|  23403.5593|
| Bahrain                  | Asia      |  2007|   75.635|      708573|  29796.0483|
| Bangladesh               | Asia      |  2002|   62.013|   135656790|   1136.3904|
| Bangladesh               | Asia      |  2007|   64.062|   150448339|   1391.2538|
| Belgium                  | Europe    |  2002|   78.320|    10311970|  30485.8838|
| Belgium                  | Europe    |  2007|   79.441|    10392226|  33692.6051|
| Benin                    | Africa    |  2002|   54.406|     7026113|   1372.8779|
| Benin                    | Africa    |  2007|   56.728|     8078314|   1441.2849|
| Bolivia                  | Americas  |  2002|   63.883|     8445134|   3413.2627|
| Bolivia                  | Americas  |  2007|   65.554|     9119152|   3822.1371|
| Bosnia and Herzegovina   | Europe    |  2002|   74.090|     4165416|   6018.9752|
| Bosnia and Herzegovina   | Europe    |  2007|   74.852|     4552198|   7446.2988|
| Botswana                 | Africa    |  2002|   46.634|     1630347|  11003.6051|
| Botswana                 | Africa    |  2007|   50.728|     1639131|  12569.8518|
| Brazil                   | Americas  |  2002|   71.006|   179914212|   8131.2128|
| Brazil                   | Americas  |  2007|   72.390|   190010647|   9065.8008|
| Bulgaria                 | Europe    |  2002|   72.140|     7661799|   7696.7777|
| Bulgaria                 | Europe    |  2007|   73.005|     7322858|  10680.7928|
| Burkina Faso             | Africa    |  2002|   50.650|    12251209|   1037.6452|
| Burkina Faso             | Africa    |  2007|   52.295|    14326203|   1217.0330|
| Burundi                  | Africa    |  2002|   47.360|     7021078|    446.4035|
| Burundi                  | Africa    |  2007|   49.580|     8390505|    430.0707|
| Cambodia                 | Asia      |  2002|   56.752|    12926707|    896.2260|
| Cambodia                 | Asia      |  2007|   59.723|    14131858|   1713.7787|
| Cameroon                 | Africa    |  2002|   49.856|    15929988|   1934.0114|
| Cameroon                 | Africa    |  2007|   50.430|    17696293|   2042.0952|
| Canada                   | Americas  |  2002|   79.770|    31902268|  33328.9651|
| Canada                   | Americas  |  2007|   80.653|    33390141|  36319.2350|
| Central African Republic | Africa    |  2002|   43.308|     4048013|    738.6906|
| Central African Republic | Africa    |  2007|   44.741|     4369038|    706.0165|
| Chad                     | Africa    |  2002|   50.525|     8835739|   1156.1819|
| Chad                     | Africa    |  2007|   50.651|    10238807|   1704.0637|
| Chile                    | Americas  |  2002|   77.860|    15497046|  10778.7838|
| Chile                    | Americas  |  2007|   78.553|    16284741|  13171.6388|
| China                    | Asia      |  2002|   72.028|  1280400000|   3119.2809|
| China                    | Asia      |  2007|   72.961|  1318683096|   4959.1149|
| Colombia                 | Americas  |  2002|   71.682|    41008227|   5755.2600|
| Colombia                 | Americas  |  2007|   72.889|    44227550|   7006.5804|
| Comoros                  | Africa    |  2002|   62.974|      614382|   1075.8116|
| Comoros                  | Africa    |  2007|   65.152|      710960|    986.1479|
| Congo, Dem. Rep.         | Africa    |  2002|   44.966|    55379852|    241.1659|
| Congo, Dem. Rep.         | Africa    |  2007|   46.462|    64606759|    277.5519|
| Congo, Rep.              | Africa    |  2002|   52.970|     3328795|   3484.0620|
| Congo, Rep.              | Africa    |  2007|   55.322|     3800610|   3632.5578|
| Costa Rica               | Americas  |  2002|   78.123|     3834934|   7723.4472|
| Costa Rica               | Americas  |  2007|   78.782|     4133884|   9645.0614|
| Cote d'Ivoire            | Africa    |  2002|   46.832|    16252726|   1648.8008|
| Cote d'Ivoire            | Africa    |  2007|   48.328|    18013409|   1544.7501|
| Croatia                  | Europe    |  2002|   74.876|     4481020|  11628.3890|
| Croatia                  | Europe    |  2007|   75.748|     4493312|  14619.2227|
| Cuba                     | Americas  |  2002|   77.158|    11226999|   6340.6467|
| Cuba                     | Americas  |  2007|   78.273|    11416987|   8948.1029|
| Czech Republic           | Europe    |  2002|   75.510|    10256295|  17596.2102|
| Czech Republic           | Europe    |  2007|   76.486|    10228744|  22833.3085|
| Denmark                  | Europe    |  2002|   77.180|     5374693|  32166.5001|
| Denmark                  | Europe    |  2007|   78.332|     5468120|  35278.4187|
| Djibouti                 | Africa    |  2002|   53.373|      447416|   1908.2609|
| Djibouti                 | Africa    |  2007|   54.791|      496374|   2082.4816|
| Dominican Republic       | Americas  |  2002|   70.847|     8650322|   4563.8082|
| Dominican Republic       | Americas  |  2007|   72.235|     9319622|   6025.3748|
| Ecuador                  | Americas  |  2002|   74.173|    12921234|   5773.0445|
| Ecuador                  | Americas  |  2007|   74.994|    13755680|   6873.2623|
| Egypt                    | Africa    |  2002|   69.806|    73312559|   4754.6044|
| Egypt                    | Africa    |  2007|   71.338|    80264543|   5581.1810|
| El Salvador              | Americas  |  2002|   70.734|     6353681|   5351.5687|
| El Salvador              | Americas  |  2007|   71.878|     6939688|   5728.3535|
| Equatorial Guinea        | Africa    |  2002|   49.348|      495627|   7703.4959|
| Equatorial Guinea        | Africa    |  2007|   51.579|      551201|  12154.0897|
| Eritrea                  | Africa    |  2002|   55.240|     4414865|    765.3500|
| Eritrea                  | Africa    |  2007|   58.040|     4906585|    641.3695|
| Ethiopia                 | Africa    |  2002|   50.725|    67946797|    530.0535|
| Ethiopia                 | Africa    |  2007|   52.947|    76511887|    690.8056|
| Finland                  | Europe    |  2002|   78.370|     5193039|  28204.5906|
| Finland                  | Europe    |  2007|   79.313|     5238460|  33207.0844|
| France                   | Europe    |  2002|   79.590|    59925035|  28926.0323|
| France                   | Europe    |  2007|   80.657|    61083916|  30470.0167|
| Gabon                    | Africa    |  2002|   56.761|     1299304|  12521.7139|
| Gabon                    | Africa    |  2007|   56.735|     1454867|  13206.4845|
| Gambia                   | Africa    |  2002|   58.041|     1457766|    660.5856|
| Gambia                   | Africa    |  2007|   59.448|     1688359|    752.7497|
| Germany                  | Europe    |  2002|   78.670|    82350671|  30035.8020|
| Germany                  | Europe    |  2007|   79.406|    82400996|  32170.3744|
| Ghana                    | Africa    |  2002|   58.453|    20550751|   1111.9846|
| Ghana                    | Africa    |  2007|   60.022|    22873338|   1327.6089|
| Greece                   | Europe    |  2002|   78.256|    10603863|  22514.2548|
| Greece                   | Europe    |  2007|   79.483|    10706290|  27538.4119|
| Guatemala                | Americas  |  2002|   68.978|    11178650|   4858.3475|
| Guatemala                | Americas  |  2007|   70.259|    12572928|   5186.0500|
| Guinea                   | Africa    |  2002|   53.676|     8807818|    945.5836|
| Guinea                   | Africa    |  2007|   56.007|     9947814|    942.6542|
| Guinea-Bissau            | Africa    |  2002|   45.504|     1332459|    575.7047|
| Guinea-Bissau            | Africa    |  2007|   46.388|     1472041|    579.2317|
| Haiti                    | Americas  |  2002|   58.137|     7607651|   1270.3649|
| Haiti                    | Americas  |  2007|   60.916|     8502814|   1201.6372|
| Honduras                 | Americas  |  2002|   68.565|     6677328|   3099.7287|
| Honduras                 | Americas  |  2007|   70.198|     7483763|   3548.3308|
| Hong Kong, China         | Asia      |  2002|   81.495|     6762476|  30209.0152|
| Hong Kong, China         | Asia      |  2007|   82.208|     6980412|  39724.9787|
| Hungary                  | Europe    |  2002|   72.590|    10083313|  14843.9356|
| Hungary                  | Europe    |  2007|   73.338|     9956108|  18008.9444|
| Iceland                  | Europe    |  2002|   80.500|      288030|  31163.2020|
| Iceland                  | Europe    |  2007|   81.757|      301931|  36180.7892|
| India                    | Asia      |  2002|   62.879|  1034172547|   1746.7695|
| India                    | Asia      |  2007|   64.698|  1110396331|   2452.2104|
| Indonesia                | Asia      |  2002|   68.588|   211060000|   2873.9129|
| Indonesia                | Asia      |  2007|   70.650|   223547000|   3540.6516|
| Iran                     | Asia      |  2002|   69.451|    66907826|   9240.7620|
| Iran                     | Asia      |  2007|   70.964|    69453570|  11605.7145|
| Iraq                     | Asia      |  2002|   57.046|    24001816|   4390.7173|
| Iraq                     | Asia      |  2007|   59.545|    27499638|   4471.0619|
| Ireland                  | Europe    |  2002|   77.783|     3879155|  34077.0494|
| Ireland                  | Europe    |  2007|   78.885|     4109086|  40675.9964|
| Israel                   | Asia      |  2002|   79.696|     6029529|  21905.5951|
| Israel                   | Asia      |  2007|   80.745|     6426679|  25523.2771|
| Italy                    | Europe    |  2002|   80.240|    57926999|  27968.0982|
| Italy                    | Europe    |  2007|   80.546|    58147733|  28569.7197|
| Jamaica                  | Americas  |  2002|   72.047|     2664659|   6994.7749|
| Jamaica                  | Americas  |  2007|   72.567|     2780132|   7320.8803|
| Japan                    | Asia      |  2002|   82.000|   127065841|  28604.5919|
| Japan                    | Asia      |  2007|   82.603|   127467972|  31656.0681|
| Jordan                   | Asia      |  2002|   71.263|     5307470|   3844.9172|
| Jordan                   | Asia      |  2007|   72.535|     6053193|   4519.4612|
| Kenya                    | Africa    |  2002|   50.992|    31386842|   1287.5147|
| Kenya                    | Africa    |  2007|   54.110|    35610177|   1463.2493|
| Korea, Dem. Rep.         | Asia      |  2002|   66.662|    22215365|   1646.7582|
| Korea, Dem. Rep.         | Asia      |  2007|   67.297|    23301725|   1593.0655|
| Korea, Rep.              | Asia      |  2002|   77.045|    47969150|  19233.9882|
| Korea, Rep.              | Asia      |  2007|   78.623|    49044790|  23348.1397|
| Kuwait                   | Asia      |  2002|   76.904|     2111561|  35110.1057|
| Kuwait                   | Asia      |  2007|   77.588|     2505559|  47306.9898|
| Lebanon                  | Asia      |  2002|   71.028|     3677780|   9313.9388|
| Lebanon                  | Asia      |  2007|   71.993|     3921278|  10461.0587|
| Lesotho                  | Africa    |  2002|   44.593|     2046772|   1275.1846|
| Lesotho                  | Africa    |  2007|   42.592|     2012649|   1569.3314|
| Liberia                  | Africa    |  2002|   43.753|     2814651|    531.4824|
| Liberia                  | Africa    |  2007|   45.678|     3193942|    414.5073|
| Libya                    | Africa    |  2002|   72.737|     5368585|   9534.6775|
| Libya                    | Africa    |  2007|   73.952|     6036914|  12057.4993|
| Madagascar               | Africa    |  2002|   57.286|    16473477|    894.6371|
| Madagascar               | Africa    |  2007|   59.443|    19167654|   1044.7701|
| Malawi                   | Africa    |  2002|   45.009|    11824495|    665.4231|
| Malawi                   | Africa    |  2007|   48.303|    13327079|    759.3499|
| Malaysia                 | Asia      |  2002|   73.044|    22662365|  10206.9779|
| Malaysia                 | Asia      |  2007|   74.241|    24821286|  12451.6558|
| Mali                     | Africa    |  2002|   51.818|    10580176|    951.4098|
| Mali                     | Africa    |  2007|   54.467|    12031795|   1042.5816|
| Mauritania               | Africa    |  2002|   62.247|     2828858|   1579.0195|
| Mauritania               | Africa    |  2007|   64.164|     3270065|   1803.1515|
| Mauritius                | Africa    |  2002|   71.954|     1200206|   9021.8159|
| Mauritius                | Africa    |  2007|   72.801|     1250882|  10956.9911|
| Mexico                   | Americas  |  2002|   74.902|   102479927|  10742.4405|
| Mexico                   | Americas  |  2007|   76.195|   108700891|  11977.5750|
| Mongolia                 | Asia      |  2002|   65.033|     2674234|   2140.7393|
| Mongolia                 | Asia      |  2007|   66.803|     2874127|   3095.7723|
| Montenegro               | Europe    |  2002|   73.981|      720230|   6557.1943|
| Montenegro               | Europe    |  2007|   74.543|      684736|   9253.8961|
| Morocco                  | Africa    |  2002|   69.615|    31167783|   3258.4956|
| Morocco                  | Africa    |  2007|   71.164|    33757175|   3820.1752|
| Mozambique               | Africa    |  2002|   44.026|    18473780|    633.6179|
| Mozambique               | Africa    |  2007|   42.082|    19951656|    823.6856|
| Myanmar                  | Asia      |  2002|   59.908|    45598081|    611.0000|
| Myanmar                  | Asia      |  2007|   62.069|    47761980|    944.0000|
| Namibia                  | Africa    |  2002|   51.479|     1972153|   4072.3248|
| Namibia                  | Africa    |  2007|   52.906|     2055080|   4811.0604|
| Nepal                    | Asia      |  2002|   61.340|    25873917|   1057.2063|
| Nepal                    | Asia      |  2007|   63.785|    28901790|   1091.3598|
| Netherlands              | Europe    |  2002|   78.530|    16122830|  33724.7578|
| Netherlands              | Europe    |  2007|   79.762|    16570613|  36797.9333|
| New Zealand              | Oceania   |  2002|   79.110|     3908037|  23189.8014|
| New Zealand              | Oceania   |  2007|   80.204|     4115771|  25185.0091|
| Nicaragua                | Americas  |  2002|   70.836|     5146848|   2474.5488|
| Nicaragua                | Americas  |  2007|   72.899|     5675356|   2749.3210|
| Niger                    | Africa    |  2002|   54.496|    11140655|    601.0745|
| Niger                    | Africa    |  2007|   56.867|    12894865|    619.6769|
| Nigeria                  | Africa    |  2002|   46.608|   119901274|   1615.2864|
| Nigeria                  | Africa    |  2007|   46.859|   135031164|   2013.9773|
| Norway                   | Europe    |  2002|   79.050|     4535591|  44683.9753|
| Norway                   | Europe    |  2007|   80.196|     4627926|  49357.1902|
| Oman                     | Asia      |  2002|   74.193|     2713462|  19774.8369|
| Oman                     | Asia      |  2007|   75.640|     3204897|  22316.1929|
| Pakistan                 | Asia      |  2002|   63.610|   153403524|   2092.7124|
| Pakistan                 | Asia      |  2007|   65.483|   169270617|   2605.9476|
| Panama                   | Americas  |  2002|   74.712|     2990875|   7356.0319|
| Panama                   | Americas  |  2007|   75.537|     3242173|   9809.1856|
| Paraguay                 | Americas  |  2002|   70.755|     5884491|   3783.6742|
| Paraguay                 | Americas  |  2007|   71.752|     6667147|   4172.8385|
| Peru                     | Americas  |  2002|   69.906|    26769436|   5909.0201|
| Peru                     | Americas  |  2007|   71.421|    28674757|   7408.9056|
| Philippines              | Asia      |  2002|   70.303|    82995088|   2650.9211|
| Philippines              | Asia      |  2007|   71.688|    91077287|   3190.4810|
| Poland                   | Europe    |  2002|   74.670|    38625976|  12002.2391|
| Poland                   | Europe    |  2007|   75.563|    38518241|  15389.9247|
| Portugal                 | Europe    |  2002|   77.290|    10433867|  19970.9079|
| Portugal                 | Europe    |  2007|   78.098|    10642836|  20509.6478|
| Puerto Rico              | Americas  |  2002|   77.778|     3859606|  18855.6062|
| Puerto Rico              | Americas  |  2007|   78.746|     3942491|  19328.7090|
| Reunion                  | Africa    |  2002|   75.744|      743981|   6316.1652|
| Reunion                  | Africa    |  2007|   76.442|      798094|   7670.1226|
| Romania                  | Europe    |  2002|   71.322|    22404337|   7885.3601|
| Romania                  | Europe    |  2007|   72.476|    22276056|  10808.4756|
| Rwanda                   | Africa    |  2002|   43.413|     7852401|    785.6538|
| Rwanda                   | Africa    |  2007|   46.242|     8860588|    863.0885|
| Sao Tome and Principe    | Africa    |  2002|   64.337|      170372|   1353.0924|
| Sao Tome and Principe    | Africa    |  2007|   65.528|      199579|   1598.4351|
| Saudi Arabia             | Asia      |  2002|   71.626|    24501530|  19014.5412|
| Saudi Arabia             | Asia      |  2007|   72.777|    27601038|  21654.8319|
| Senegal                  | Africa    |  2002|   61.600|    10870037|   1519.6353|
| Senegal                  | Africa    |  2007|   63.062|    12267493|   1712.4721|
| Serbia                   | Europe    |  2002|   73.213|    10111559|   7236.0753|
| Serbia                   | Europe    |  2007|   74.002|    10150265|   9786.5347|
| Sierra Leone             | Africa    |  2002|   41.012|     5359092|    699.4897|
| Sierra Leone             | Africa    |  2007|   42.568|     6144562|    862.5408|
| Singapore                | Asia      |  2002|   78.770|     4197776|  36023.1054|
| Singapore                | Asia      |  2007|   79.972|     4553009|  47143.1796|
| Slovak Republic          | Europe    |  2002|   73.800|     5410052|  13638.7784|
| Slovak Republic          | Europe    |  2007|   74.663|     5447502|  18678.3144|
| Slovenia                 | Europe    |  2002|   76.660|     2011497|  20660.0194|
| Slovenia                 | Europe    |  2007|   77.926|     2009245|  25768.2576|
| Somalia                  | Africa    |  2002|   45.936|     7753310|    882.0818|
| Somalia                  | Africa    |  2007|   48.159|     9118773|    926.1411|
| South Africa             | Africa    |  2002|   53.365|    44433622|   7710.9464|
| South Africa             | Africa    |  2007|   49.339|    43997828|   9269.6578|
| Spain                    | Europe    |  2002|   79.780|    40152517|  24835.4717|
| Spain                    | Europe    |  2007|   80.941|    40448191|  28821.0637|
| Sri Lanka                | Asia      |  2002|   70.815|    19576783|   3015.3788|
| Sri Lanka                | Asia      |  2007|   72.396|    20378239|   3970.0954|
| Sudan                    | Africa    |  2002|   56.369|    37090298|   1993.3983|
| Sudan                    | Africa    |  2007|   58.556|    42292929|   2602.3950|
| Swaziland                | Africa    |  2002|   43.869|     1130269|   4128.1169|
| Swaziland                | Africa    |  2007|   39.613|     1133066|   4513.4806|
| Sweden                   | Europe    |  2002|   80.040|     8954175|  29341.6309|
| Sweden                   | Europe    |  2007|   80.884|     9031088|  33859.7484|
| Switzerland              | Europe    |  2002|   80.620|     7361757|  34480.9577|
| Switzerland              | Europe    |  2007|   81.701|     7554661|  37506.4191|
| Syria                    | Asia      |  2002|   73.053|    17155814|   4090.9253|
| Syria                    | Asia      |  2007|   74.143|    19314747|   4184.5481|
| Taiwan                   | Asia      |  2002|   76.990|    22454239|  23235.4233|
| Taiwan                   | Asia      |  2007|   78.400|    23174294|  28718.2768|
| Tanzania                 | Africa    |  2002|   49.651|    34593779|    899.0742|
| Tanzania                 | Africa    |  2007|   52.517|    38139640|   1107.4822|
| Thailand                 | Asia      |  2002|   68.564|    62806748|   5913.1875|
| Thailand                 | Asia      |  2007|   70.616|    65068149|   7458.3963|
| Togo                     | Africa    |  2002|   57.561|     4977378|    886.2206|
| Togo                     | Africa    |  2007|   58.420|     5701579|    882.9699|
| Trinidad and Tobago      | Americas  |  2002|   68.976|     1101832|  11460.6002|
| Trinidad and Tobago      | Americas  |  2007|   69.819|     1056608|  18008.5092|
| Tunisia                  | Africa    |  2002|   73.042|     9770575|   5722.8957|
| Tunisia                  | Africa    |  2007|   73.923|    10276158|   7092.9230|
| Turkey                   | Europe    |  2002|   70.845|    67308928|   6508.0857|
| Turkey                   | Europe    |  2007|   71.777|    71158647|   8458.2764|
| Uganda                   | Africa    |  2002|   47.813|    24739869|    927.7210|
| Uganda                   | Africa    |  2007|   51.542|    29170398|   1056.3801|
| United Kingdom           | Europe    |  2002|   78.471|    59912431|  29478.9992|
| United Kingdom           | Europe    |  2007|   79.425|    60776238|  33203.2613|
| United States            | Americas  |  2002|   77.310|   287675526|  39097.0995|
| United States            | Americas  |  2007|   78.242|   301139947|  42951.6531|
| Uruguay                  | Americas  |  2002|   75.307|     3363085|   7727.0020|
| Uruguay                  | Americas  |  2007|   76.384|     3447496|  10611.4630|
| Venezuela                | Americas  |  2002|   72.766|    24287670|   8605.0478|
| Venezuela                | Americas  |  2007|   73.747|    26084662|  11415.8057|
| Vietnam                  | Asia      |  2002|   73.017|    80908147|   1764.4567|
| Vietnam                  | Asia      |  2007|   74.249|    85262356|   2441.5764|
| West Bank and Gaza       | Asia      |  2002|   72.370|     3389578|   4515.4876|
| West Bank and Gaza       | Asia      |  2007|   73.422|     4018332|   3025.3498|
| Yemen, Rep.              | Asia      |  2002|   60.308|    18701257|   2234.8208|
| Yemen, Rep.              | Asia      |  2007|   62.698|    22211743|   2280.7699|
| Zambia                   | Africa    |  2002|   39.193|    10595811|   1071.6139|
| Zambia                   | Africa    |  2007|   42.384|    11746035|   1271.2116|
| Zimbabwe                 | Africa    |  2002|   39.989|    11926563|    672.0386|
| Zimbabwe                 | Africa    |  2007|   43.487|    12311143|    469.7093|
