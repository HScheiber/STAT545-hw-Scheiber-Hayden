Homework 6 - Data Wrangling Wrap Up
================
Hayden Scheiber -
07 November, 2017

[Return to Main Page](https://github.com/HScheiber/STAT545-hw-Scheiber-Hayden/blob/master/README.md)

[Return to Homework 6 Landing Page](README.md)

------------------------------------------------------------------------

-   [Character data](#character-data)
    1.  [Section 14.2 Excercises](#section-142-excercises)
    2.  [Section 14.3.1 Excercises](#section-1431-excercises)
    3.  [Section 14.3.2 Excercises](#section-1432-excercises)
    4.  [Section 14.3.3 Excercises](#section-1433-excercises)
    5.  [Section 14.3.4 Excercises](#section-1434-excercises)
    6.  [Section 14.3.5 Excercises](#section-1435-excercises)
    7.  [Section 14.4.2 Excercises](#section-1442-excercises)
    8.  [Section 14.4.3 Excercises](#section-1443-excercises)
    9.  [Section 14.4.4 Excercises](#section-1444-excercises)
    10. [Section 14.4.5 Excercises](#section-1445-excercises)
    11. [Section 14.4.6 Excercises](#section-1446-excercises)
    12. [Section 14.5 Excercises](#section-145-excercises)
    13. [Section 14.7 Excercises](#section-147-excercises)
-   [Writing functions](#writing-functions)

------------------------------------------------------------------------

Welcome! This is the first assignment for STAT 547M and the last assignment to look at Data Wrangline using R. A link to the assignment itself can be found [here](http://stat545.com/hw06_data-wrangling-conclusion.html "STAT 545 Assignment 6").

------------------------------------------------------------------------

Below are the packages that are used in the making of this assignment.

``` r
suppressPackageStartupMessages(library(gapminder))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(knitr))
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(stringi))
suppressPackageStartupMessages(library(combinat))
suppressPackageStartupMessages(library(purrr))
```

Character data
==============

<a href="#top">Back to top</a>

In this section I will follow along and do the exercises seen in the "Strings" chaper of [R for Data Science.](http://r4ds.had.co.nz/strings.html "R for Data Science")

Section 14.2 Excercises
-----------------------

<a href="#top">Back to top</a>

#### 1. In code that doesn’t use stringr, you’ll often see `paste()` and `paste0()`. What’s the difference between the two functions? What stringr function are they equivalent to? How do the functions differ in their handling of `NA`?

The `paste()` function is used to concatenate strings together. It can operate on vectors of strings, multiple string inputs, or anything else than can be coerced into strings. You can choose the separation parameter using the input `sep`. The default for `sep` is a space. `paste0()` is the same as `paste()` but with `sep = ""`. For exmaple:

``` r
paste("It is", TRUE, "that pi is approximately" , pi, sep = " ")
```

    ## [1] "It is TRUE that pi is approximately 3.14159265358979"

``` r
x = c("foo", "bar", "baz")

paste(x, x)
```

    ## [1] "foo foo" "bar bar" "baz baz"

``` r
paste0("foo", x)
```

    ## [1] "foofoo" "foobar" "foobaz"

Notice that `paste` and `paste0` does not concatenate vectors together, but instead operates on each element of the vector. Let's compare the behaviour of `paste()` to its equivalent `stringr` function `str_c` under some strage and specific conditions.

``` r
y = c(NA, "", "a string")

paste(y, NULL, sep = " ")
```

    ## [1] "NA "       " "         "a string "

``` r
str_c(y, NULL, sep = " ")
```

    ## [1] NA         ""         "a string"

A few differences between `paste()` and `str_c()`: The default separator for `str_c` is nothing, whereas for `paste()` it is a space. `str_c` ignores `NULL` whereas `paste()` treats it as an empty string. Finally, `paste()` converts `NA` into a string, but `str_c()` maintains it as a logical type object.

#### 2. In your own words, describe the difference between the `sep` and `collapse` arguments to `str_c()`.

The best way to answer this is with an example using the same vector of characters `x` as before:

``` r
str_c(x, x, sep = " ")
```

    ## [1] "foo foo" "bar bar" "baz baz"

``` r
str_c(x, x, collapse = "|", sep = " ")
```

    ## [1] "foo foo|bar bar|baz baz"

When collapse is set to `NULL` (the default), vectors of strings are not collapsed further into a single output, but when `collapse` is set to some string, everything in the input is collapsed into a single output string. The string *assigned* to `collapse` becomes the separator between vector elements that would have otherwise remained separate components of a vector in the output.

#### 3. Use `str_length()` and `str_sub()` to extract the middle character from a string. What will you do if the string has an even number of characters?

For this lets make two strings as examples: one an even length, and one an odd length. We can use `str_length()` to find the length of these strings:

``` r
odd_string <- "--> x <--"
even_string <- "--> yx <--"

(odd_l <- str_length(odd_string))
```

    ## [1] 9

``` r
(even_l <- str_length(even_string))
```

    ## [1] 10

Now lets create a function to extract just the middle character from the odd string using `str_sub()`. In the case of an even string, it should output the two middle characters.

``` r
string_mid <- function(input_string){
  if(!is.character(input_string)) {
    stop('This function only works for Character inputs!\n','You have provided an object of class: ', class(input_string)[1])
  }
  
  strlen <- str_length(input_string)
  
  ## if even
  if (strlen %% 2 == 0){
    
  output <- str_sub(input_string, 
        strlen/2, 
        strlen/2 + 1)
  
  ## if odd
  } else {
    output <- str_sub(input_string, 
        strlen/2 + 0.5, 
        strlen/2 + 0.5)
    
  }
  return(output)
}
```

Now we can try it out:

``` r
string_mid(odd_string)
```

    ## [1] "x"

``` r
string_mid(even_string)
```

    ## [1] "yx"

Working as expected.

#### 4. What does `str_wrap()` do? When might you want to use it?

`str_wrap()` formats blocks of text into nice-looking paragraphs. It might be easier to understand how it works with an example. I use `stri_rand_lipsum` to generate random text. The `writeLines()` function is used to show what the string output actually looks like, after being formatted by `str_wrap()`.

``` r
random_text <- stri_rand_lipsum(1)

str_wrap(random_text, width = 80, indent = 5, exdent = 1) %>%
  writeLines()
```

    ##      Lorem ipsum dolor sit amet, facilisis tempor fermentum volutpat quisque tempus
    ##  bibendum. Dis nec, et faucibus aptent. Luctus, mauris consectetur donec purus
    ##  purus augue cursus. Aliquet nisi faucibus lectus erat egestas. Auctor tincidunt
    ##  rutrum ipsum phasellus eros maecenas, donec, bibendum nunc ut. Arcu vel. Sed nec
    ##  elit, sit lobortis mauris quis lacinia posuere. At sapien vestibulum nulla, amet
    ##  etiam.

#### 5. What does `str_trim()` do? What’s the opposite of `str_trim()`?

<a href="#top">Back to top</a>

`str_trim()` trims away any white space at the start or end of a string. Note it recognizes more than just spaces, it recognizes tab (`\t`) and newline (`\n`) as well.

``` r
str_trim("    This once ugly string no longer has whitespace around it       \t  \t \t    \n \n           ")
```

    ## [1] "This once ugly string no longer has whitespace around it"

The opposite function of this is `str_pad`, which adds whitespace based on the input so that all strings end up at least some minimum `width`. The `side` input sets which side the whitespace should be added to (one of "left", "right", or "both"). For example:

``` r
str_input <- c("I", "want", "my", "strings", "to", "be", "the", "same", "length")

(str_output <- str_pad(str_input, width = max(str_length(str_input)), side = "both"))
```

    ## [1] "   I   " " want  " "  my   " "strings" "  to   " "  be   " "  the  "
    ## [8] " same  " "length "

``` r
str_length(str_output)
```

    ## [1] 7 7 7 7 7 7 7 7 7

#### 6. Write a function that turns (e.g.) a vector `c("a", "b", "c")` into the string `a, b, and c`. Think carefully about what it should do if given a vector of length 0, 1, or 2.

If given a vector of length 0, I want my function to throw back an error. If the input is a vector of length 1, then the output should just be the input string. I also want my function to trim away any whitespace.

``` r
string_vec_to_str <- function(input_vec){
  
  ## Error catch
  if(is_empty(input_vec)) {
    stop('This function only works for non-empty vectors of Character inputs!\n',
         'You have provided an empty vector')
  }
  
  if(!is.character(input_vec)) {
    stop('This function only works for non-empty vectors of Character inputs!\n',
         'You have provided an object of class: ', class(input_vec)[1])
  }
  
  ## calculate length of string vector
  strlen <- length(input_vec)
  
  ## Cut away white space if there
  input_vec <- str_trim(input_vec)

  ## Simply return if vector of length 1
  if (strlen == 1){
    return(input_vec)
  }
  
  ## Build the bulk of the list separate from the last element
  first_str <- str_c(input_vec[1:strlen-1], collapse = ", ")
  sec_str <- input_vec[strlen]
  
  ## concatenate both together after
  output <- str_c(first_str, sec_str, sep = ', and ')
  return(output)
}
```

Lets try it out on a few test character vectors. If I try it on an empty vector it throws an error, as expected.

``` r
string_vec_to_str(x)
```

    ## [1] "foo, bar, and baz"

``` r
string_vec_to_str(letters)
```

    ## [1] "a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, and z"

``` r
string_vec_to_str(" Foo \t ")
```

    ## [1] "Foo"

Section 14.3.1 Excercises
-------------------------

<a href="#top">Back to top</a>

#### 1. Explain why each of these strings don’t match a `\`: `"\"`, `"\\"`, `"\\\"`

`\` is a special character in R, it is the character used to escape special characters. In order to include `\` as a literal character in R, it must be escaped by another `\`, hence the literal character is actually stored as `\\`, but appears as `\` when interpreted. Therefore, the phrase we must match with regex is really `\\`.

In regex, `\` is *also* a special character, so in order to match with `\\` we must escape it with another `\`. However, we are actually making a regex string, so an literal `\` must be written `\\`! In other words, for every `\` we want to match in our string of interest, we need `\\` in our regex expression in order to properly escape it.

Therefore, only the regex expression `\\\\` will match with the character `\\` which is really just `\` when properly parsed. What a headache!

``` r
x <- c("foo", "\\", "bar")

writeLines(x)
```

    ## foo
    ## \
    ## bar

``` r
str_detect(x,"\\\\" )
```

    ## [1] FALSE  TRUE FALSE

#### 2. How would you match the expression `"'\?`

With lots of escape characters! Just to store this string we need three extra escapes. When we search for this string using regex, we will need to once again escape all of those escapes! Keep in mind that `?` is not a special character in R, but it is in regex.

``` r
x <- c("foo", "\"\'\\?", "bar")
writeLines(x)
```

    ## foo
    ## "'\?
    ## bar

``` r
str_detect(x,"\\\"\\\'\\\\\\?" )
```

    ## [1] FALSE  TRUE FALSE

#### 3. What patterns will the regular expression `\..\..\..` match? How would you represent it as a string?

Each of the `\.` in the above expression correspond to a literal period. Each of the un-escaped dots correspond to a wildcard for a single character. Therefore the expression is lookling for something like `(period)(any single character)(period)(any single character)(period)(any single character)`. To represent this as a string, every `\` character needs to be escaped with another `\`. It ends up looking like `\\..\\..\\..`

``` r
writeLines("\\..\\..\\..")
```

    ## \..\..\..

If we wanted to regex the literal string `\..\..\..` we would also have to escape all the periods and backslashes and it would look like:

``` r
match_str <- "\\..\\..\\.."
str_detect(match_str,"\\\\\\.\\.\\\\\\.\\.\\\\\\.\\." )
```

    ## [1] TRUE

Section 14.3.2 Excercises
-------------------------

<a href="#top">Back to top</a>

#### 1. How would you match the literal string `"$^$"`?

Once again, all we need are escape characters! Each of `"` needs to be escaped with a `\\\` since it is a special character in R. Whereas each of `$` and `^` only needs a double escape `\\` because they are only special characters in regex.

``` r
match_str <- "\"$^$\""
str_match(match_str,"\\\"\\$\\^\\$\\\"" ) %>%
  writeLines()
```

    ## "$^$"

#### 2. Given the corpus of common words in `stringr::words`, create regular expressions that find all words that:

**1. Start with “y”.**

For this, simply use the `^` command.

``` r
str_subset(stringr::words,"^y")
```

    ## [1] "year"      "yes"       "yesterday" "yet"       "you"       "young"

**2. End with “x”**

For this, we use `$`. Notice the ordering has changed.

``` r
str_subset(stringr::words,"x$")
```

    ## [1] "box" "sex" "six" "tax"

**3. Are exactly three letters long. (Don’t cheat by using `str_length()`!)**

This is pretty easy in regex, we just need to anchor three sinlge-character wildcards.

``` r
str_subset(stringr::words,"^...$")
```

    ##   [1] "act" "add" "age" "ago" "air" "all" "and" "any" "arm" "art" "ask"
    ##  [12] "bad" "bag" "bar" "bed" "bet" "big" "bit" "box" "boy" "bus" "but"
    ##  [23] "buy" "can" "car" "cat" "cup" "cut" "dad" "day" "die" "dog" "dry"
    ##  [34] "due" "eat" "egg" "end" "eye" "far" "few" "fit" "fly" "for" "fun"
    ##  [45] "gas" "get" "god" "guy" "hit" "hot" "how" "job" "key" "kid" "lad"
    ##  [56] "law" "lay" "leg" "let" "lie" "lot" "low" "man" "may" "mrs" "new"
    ##  [67] "non" "not" "now" "odd" "off" "old" "one" "out" "own" "pay" "per"
    ##  [78] "put" "red" "rid" "run" "say" "see" "set" "sex" "she" "sir" "sit"
    ##  [89] "six" "son" "sun" "tax" "tea" "ten" "the" "tie" "too" "top" "try"
    ## [100] "two" "use" "war" "way" "wee" "who" "why" "win" "yes" "yet" "you"

**4. Have seven letters or more.**

This is even easier: just use 7 wildcards without anchoring.

``` r
str_subset(stringr::words,".......") %>%
  head(20)
```

    ##  [1] "absolute"    "account"     "achieve"     "address"     "advertise"  
    ##  [6] "afternoon"   "against"     "already"     "alright"     "although"   
    ## [11] "america"     "another"     "apparent"    "appoint"     "approach"   
    ## [16] "appropriate" "arrange"     "associate"   "authority"   "available"

Section 14.3.3 Excercises
-------------------------

<a href="#top">Back to top</a>

#### 1. Create regular expressions to find all words that:

**1. Start with a vowel.**

For this, we just combine the start anchor `^` with our OR operator `|`

``` r
str_subset(stringr::words,"^(a|e|i|o|u)") %>%
  head(20)
```

    ##  [1] "a"         "able"      "about"     "absolute"  "accept"   
    ##  [6] "account"   "achieve"   "across"    "act"       "active"   
    ## [11] "actual"    "add"       "address"   "admit"     "advertise"
    ## [16] "affect"    "afford"    "after"     "afternoon" "again"

**2. That only contain consonants. (Hint: thinking about matching “not”-vowels.)**

This one was quite hard! The bracketed term `[^aeiou]` means "do not match any of the vowels". The `+` operator means "repeat 1 or more times"", but I also had to anchor it between the start and end of words to ensure it parses over the entire word.

``` r
str_subset(stringr::words,"^[^aeiou]+$")
```

    ## [1] "by"  "dry" "fly" "mrs" "try" "why"

**3. End with `ed`, but not with `eed`.**

For this one, we just need to use the NOT-match operator `[^]` on `e` before our indended match at the end of the word: `ed$`.

``` r
str_subset(stringr::words,"[^e]ed$")
```

    ## [1] "bed"     "hundred" "red"

**4. End with `ing` or `ise`.**

Here we just need to utilize the OR operator `|`:

``` r
str_subset(stringr::words,"(ing$)|(ise$)")
```

    ##  [1] "advertise" "bring"     "during"    "evening"   "exercise" 
    ##  [6] "king"      "meaning"   "morning"   "otherwise" "practise" 
    ## [11] "raise"     "realise"   "ring"      "rise"      "sing"     
    ## [16] "surprise"  "thing"

#### 2. Empirically verify the rule “i before e except after c”.

This rule of thumb suggests that generally if English words contain and `e` beside an `i` it will always be `ie` except if there is a `c` first, as in: `cei`. First lets look for all words that contain `ie` in that order and do not have a c beforehand:

``` r
str_subset(stringr::words,"[^c]ie")
```

    ##  [1] "achieve"    "believe"    "brief"      "client"     "die"       
    ##  [6] "experience" "field"      "friend"     "lie"        "piece"     
    ## [11] "quiet"      "tie"        "view"

What about words that contain `cie`? Are there any?

``` r
str_subset(stringr::words,"cie")
```

    ## [1] "science" "society"

A few, so the rule is broken here. What about the other side of the rule? Are there words that contain `ei` that are *not* after c?

``` r
str_subset(stringr::words,"[^c]ei")
```

    ## [1] "weigh"

Only one rule-breaker here. How many words *do* follow the `cei` generalization?

``` r
str_subset(stringr::words,"cei")
```

    ## [1] "receive"

There's also only one. Based on the data found here, I wouldn't say that the rule is a ubiquitous one!

#### 3. Is “q” always followed by a “u”?

This one is simple to check:

``` r
length(str_subset(stringr::words,"q"))
```

    ## [1] 10

``` r
str_subset(stringr::words,"q[^u]")
```

    ## character(0)

Out of 10 words in that list containing a `q`, *all* of them have a `u` that follows!

#### 4. Write a regular expression that matches a word if it’s probably written in British English, not American English.

This is a pretty hard question in general... According to the [wikipedia page](https://en.wikipedia.org/wiki/American_and_British_English_spelling_differences) here are a few of the differences:

| British | American |
|:-------:|:--------:|
|    ou   |     o    |
|   -re   |    -er   |
|   -ise  |   -ize   |
|  ae/oe  |     e    |
|   -yse  |   -yze   |
|  -ogue  |    -og   |

So, with this in mind here is my best attempt:

``` r
str_subset(stringr::words,"ou|re$|ise$|ae|oe|yse$|ogue$") %>%
  head(20)
```

    ##  [1] "about"     "account"   "advertise" "although"  "amount"   
    ##  [6] "around"    "aware"     "before"    "care"      "centre"   
    ## [11] "colour"    "compare"   "could"     "council"   "count"    
    ## [16] "country"   "county"    "couple"    "course"    "court"

#### 5. Create a regular expression that will match telephone numbers as commonly written in your country.

I need something to match this to, so I'll create a vector with a number that should match and one that shouldn't. To build the regex string, we need to use `\d` which stands for *any* digit, but once again we need to escape the backslash with an extra `\` each time.

``` r
telephone_nums <- c("123-456-7891", "123456789")
str_subset(telephone_nums, "\\d\\d\\d-\\d\\d\\d-\\d\\d\\d\\d")
```

    ## [1] "123-456-7891"

Section 14.3.4 Excercises
-------------------------

<a href="#top">Back to top</a>

#### 1. Describe the equivalents of `?`, `+`, `*` in `{m,n}` form.

The operator `?` corresponds to matching 0 or 1 of something. It is equivalent to `{0,1}`.

``` r
str_subset(stringr::fruit,"b[al](na)?")
```

    ## [1] "banana"       "blackberry"   "blackcurrant" "blood orange"
    ## [5] "blueberry"

``` r
str_subset(stringr::fruit,"b[al](na){0,1}")
```

    ## [1] "banana"       "blackberry"   "blackcurrant" "blood orange"
    ## [5] "blueberry"

The operator `+` means "match 1 or more". It is equivalent to `{1,}`

``` r
str_subset(stringr::fruit,"b[al](na)+")
```

    ## [1] "banana"

``` r
str_subset(stringr::fruit,"b[al](na){1,}")
```

    ## [1] "banana"

The operator `*` means "match 0 or more". It is the same as `{0,}`

``` r
str_subset(stringr::fruit,"j[al](na)*")
```

    ## [1] "jackfruit" "jambul"

``` r
str_subset(stringr::fruit,"j[al](na){0,}")
```

    ## [1] "jackfruit" "jambul"

#### 2. Describe in words what these regular expressions match: (read carefully to see if I’m using a regular expression or a string that defines a regular expression.)

**1. `^.*$`**

This expression means "start at the beginning of a word, find any single character 0 or more times, then end the word." This essentially corresponds to any word at all.

``` r
identical(str_subset(stringr::words,"^.*$"), stringr::words)
```

    ## [1] TRUE

**2. `"\\{.+\\}"`**

This is a regex string which becomes `\{.+\}` when interpreted. This expression will search for any string of characters of length 1 or more that is enclosed in literal curly braces `{ }`.

``` r
x <- c("{ aaa }", "{ abc }", "{}", "aaa")

str_subset(x,"\\{.+\\}")
```

    ## [1] "{ aaa }" "{ abc }"

**3. `\d{4}-\d{2}-\d{2}`**

This expression searches for: (any 4 digits)-(any 2 digits)-(any 2 digits). In order to use it as a regex string, we need to escape the backslashes.

``` r
x <- c("1234-12-12", "123-12-12", "12341212", "abcd-ab-ab")

str_subset(x,"\\d{4}-\\d{2}-\\d{2}")
```

    ## [1] "1234-12-12"

**4. `"\\\\{4}"`**

We have seen previously that the four-backslash construct corresponds to a search for a literal backslash in a string. This regex command searches for 4 literal backslashes, which in a string is represented by 8 backslashes, as each one needs to be escaped.

``` r
x <- c("\\\\\\\\", "\\\\\\", "\\\\", "\\")

str_subset(x,"\\\\{4}") %>%
  writeLines()
```

    ## \\\\

#### 3. Create regular expressions to find all words that:

**1. Start with three consonants.**

We need to use `^` to indicate the start of a word, then use *NOT* vowels for exactly three matches.

``` r
str_subset(stringr::words,"^[^aeiou]{3}") 
```

    ##  [1] "Christ"    "Christmas" "dry"       "fly"       "mrs"      
    ##  [6] "scheme"    "school"    "straight"  "strategy"  "street"   
    ## [11] "strike"    "strong"    "structure" "system"    "three"    
    ## [16] "through"   "throw"     "try"       "type"      "why"

**2. Have three or more vowels in a row.**

This is very similar to the last question, but we no longer need to use the `^` anchor.

``` r
str_subset(stringr::words,"[aeiou]{3}") 
```

    ## [1] "beauty"   "obvious"  "previous" "quiet"    "serious"  "various"

**3. Have two or more vowel-consonant pairs in a row.**

This one is pretty simple too, we just need to make sure to bracket our search pair and use `{2,}` to only keep 2+ matches.

``` r
str_subset(stringr::words,"([aeiou][^aeiou]){2,}") %>%
  head(20)
```

    ##  [1] "absolute"  "agent"     "along"     "america"   "another"  
    ##  [6] "apart"     "apparent"  "authority" "available" "aware"    
    ## [11] "away"      "balance"   "basis"     "become"    "before"   
    ## [16] "begin"     "behind"    "benefit"   "business"  "character"

#### 4. Solve the beginner regexp crosswords at <https://regexcrossword.com/challenges/beginner>.

I solved these. I found that the 4th one was particularly hard, until I realised one of the regex expressions was `/+` not `\+`, which corresponds to 1 or more slashes.

``` r
str_subset(c("//", "a/", "/a","aa") ,"/+") 
```

    ## [1] "//" "a/" "/a"

The answers I got were (reading from top left to bottom right in the usual order): 1. `HELP` 2. `BOBE` 3. `OOOO` 4. `**//` 5. `1984`

Section 14.3.5 Excercises
-------------------------

<a href="#top">Back to top</a>

#### 1. Describe, in words, what these expressions will match:

**1. `(.)\1\1`**

This expression will match any three of the same letter. It's a single-letter wildcard contained in brackets followed by two backreferences that reference the same bracketed single-letter wildcard.

``` r
c("aaab","aaa","abc","aab","abb") %>%
  str_subset("(.)\\1\\1") 
```

    ## [1] "aaab" "aaa"

**2. `"(.)(.)\\2\\1"` **

This is a string that will be interpreted into the regex expression `(.)(.)\2\1`. This will find 2 separate single-character wildcards, then backreference to the second bracketed term which is the same second single letter wildcard. Finally, it backreferences the first bracketed term which is the first single-letter wildcard. So it will search for terms structured something like `xyyx`.

``` r
c("abba","abca","aabb","abab") %>%
  str_subset("(.)(.)\\2\\1") 
```

    ## [1] "abba"

**3. `(..)\1`**

This regex expression looks for any two single characters, then the same two single characters. It searches for terms structured like `xyxy`.

``` r
c("abba","abca","aabb","abab") %>%
  str_subset("(..)\\1")
```

    ## [1] "abab"

**4. `"(.).\\1.\\1"`**

This string will be interpreted into the regex expression `(.).\1.\1`. This expression looks to find a wildcard (lets call it `x`), then find another separate wildcard, then find `x` again, then find another separate wildcard, and then find `x` again. Overall it will search for structures like `xyxzx`.

``` r
str_subset(stringr::words,"(.).\\1.\\1")
```

    ## [1] "eleven"

**5. `"(.)(.)(.).*\\3\\2\\1"`**

This string gets interpreted as `(.)(.)(.).*\3\2\1`. This says to find 3 wildcards (different or the same) that I'll call `x`, `y`, and `z`. Then it says to find 0 or more other characters. Finally, it says find `z` then `y` then `x` again in that order. The overall structure is `xyz(any or no characters)zyx`.

``` r
c("abc_cba","abc_xyz_cba","abccba","abc_bca","aaa_aab","aabbccbbaa") %>%
  str_subset("(.)(.)(.).*\\3\\2\\1")
```

    ## [1] "abc_cba"     "abc_xyz_cba" "abccba"      "aabbccbbaa"

#### 2. Construct regular expressions to match words that:

**1. Start and end with the same character.**

This is fairly simple to do with backreferences: we just need a wildcard in brackets anchored to the first letter, then backreference that bracketed term with an end anchor. Between the two anchored terms we can use the `*` operator with another wildcard to get any or no characters for the middle of the word.

``` r
str_subset(stringr::words,"^(.).*\\1$")
```

    ##  [1] "america"    "area"       "dad"        "dead"       "depend"    
    ##  [6] "educate"    "else"       "encourage"  "engine"     "europe"    
    ## [11] "evidence"   "example"    "excuse"     "exercise"   "expense"   
    ## [16] "experience" "eye"        "health"     "high"       "knock"     
    ## [21] "level"      "local"      "nation"     "non"        "rather"    
    ## [26] "refer"      "remember"   "serious"    "stairs"     "test"      
    ## [31] "tonight"    "transport"  "treat"      "trust"      "window"    
    ## [36] "yesterday"

**2. Contain a repeated pair of letters (e.g. “church” contains “ch” repeated twice.)**

This will be quite similar to the last expression, but we no longer need anchors. The bracketed term will also countain two wildcards now.

``` r
str_subset(stringr::words,"(..).*\\1")
```

    ##  [1] "appropriate" "church"      "condition"   "decide"      "environment"
    ##  [6] "london"      "paragraph"   "particular"  "photograph"  "prepare"    
    ## [11] "pressure"    "remember"    "represent"   "require"     "sense"      
    ## [16] "therefore"   "understand"  "whether"

**3. Contain one letter repeated in at least three places (e.g. “eleven” contains three “e”s.)**

For this, we just need to extend the construct from question 1 to three repetions, and remove the anchors.

``` r
str_subset(stringr::words,"(.).*\\1.*\\1")
```

    ##  [1] "appropriate" "available"   "believe"     "between"     "business"   
    ##  [6] "degree"      "difference"  "discuss"     "eleven"      "environment"
    ## [11] "evidence"    "exercise"    "expense"     "experience"  "individual" 
    ## [16] "paragraph"   "receive"     "remember"    "represent"   "telephone"  
    ## [21] "therefore"   "tomorrow"

Section 14.4.2 Excercises
-------------------------

<a href="#top">Back to top</a>

#### 1. For each of the following challenges, try solving it by using both a single regular expression, and a combination of multiple `str_detect()` calls.

**1. Find all words that start or end with `x`.**

For the regular expression version of this, we can utilize the OR operator `|`, combined with anchors.

``` r
str_subset(stringr::words,"(^x)|(x$)")
```

    ## [1] "box" "sex" "six" "tax"

Using `str_detect`, we can separately detect words that start with `x` or end with `x`, then simply index the results with `|`.

``` r
begin_x <- str_detect(stringr::words, "^x")
end_x <- str_detect(stringr::words, "x$")

stringr::words[begin_x | end_x]
```

    ## [1] "box" "sex" "six" "tax"

**2. Find all words that start with a vowel and end with a consonant.**

From what we've learned in the previous sections, this is a fairly easy expression. We use our "any-vowel" construct anchored to the start of a word, then wildcard 0 or more times, then "any-NOT-vowel" anchored to the end:

``` r
subset1 <- str_subset(stringr::words,"^[aeiou].*[^aeiou]$")
```

Working with multiple usages of `str_detect()` eliminates the need for the middle wildcard expression `.*`. We just need to index using the `AND` operator this time.

``` r
match_start <- str_detect(stringr::words,"^[aeiou]")
match_end <- str_detect(stringr::words,"[^aeiou]$")

subset2 <- stringr::words[match_start & match_end]

head(subset2,20)
```

    ##  [1] "about"     "accept"    "account"   "across"    "act"      
    ##  [6] "actual"    "add"       "address"   "admit"     "affect"   
    ## [11] "afford"    "after"     "afternoon" "again"     "against"  
    ## [16] "agent"     "air"       "all"       "allow"     "almost"

``` r
identical(subset1, subset2)
```

    ## [1] TRUE

**3. Are there any words that contain at least one of each different vowel?**

To do the regex expression for this one will be a ridiculously long expression containing all possible permutations of the vowels. To help with this, I need the function `combinat::permn()`

``` r
perms <- permn(c("a", "e", "i", "o", "u"))
for (i in 1:length(perms)){
  perms[i] <- str_c(perms[[i]], collapse = ".*")
}
# The ridiculously long regex expression
(phrase <- str_c(perms, collapse="|"))
```

    ## [1] "a.*e.*i.*o.*u|a.*e.*i.*u.*o|a.*e.*u.*i.*o|a.*u.*e.*i.*o|u.*a.*e.*i.*o|u.*a.*e.*o.*i|a.*u.*e.*o.*i|a.*e.*u.*o.*i|a.*e.*o.*u.*i|a.*e.*o.*i.*u|a.*o.*e.*i.*u|a.*o.*e.*u.*i|a.*o.*u.*e.*i|a.*u.*o.*e.*i|u.*a.*o.*e.*i|u.*o.*a.*e.*i|o.*u.*a.*e.*i|o.*a.*u.*e.*i|o.*a.*e.*u.*i|o.*a.*e.*i.*u|o.*a.*i.*e.*u|o.*a.*i.*u.*e|o.*a.*u.*i.*e|o.*u.*a.*i.*e|u.*o.*a.*i.*e|u.*a.*o.*i.*e|a.*u.*o.*i.*e|a.*o.*u.*i.*e|a.*o.*i.*u.*e|a.*o.*i.*e.*u|a.*i.*o.*e.*u|a.*i.*o.*u.*e|a.*i.*u.*o.*e|a.*u.*i.*o.*e|u.*a.*i.*o.*e|u.*a.*i.*e.*o|a.*u.*i.*e.*o|a.*i.*u.*e.*o|a.*i.*e.*u.*o|a.*i.*e.*o.*u|i.*a.*e.*o.*u|i.*a.*e.*u.*o|i.*a.*u.*e.*o|i.*u.*a.*e.*o|u.*i.*a.*e.*o|u.*i.*a.*o.*e|i.*u.*a.*o.*e|i.*a.*u.*o.*e|i.*a.*o.*u.*e|i.*a.*o.*e.*u|i.*o.*a.*e.*u|i.*o.*a.*u.*e|i.*o.*u.*a.*e|i.*u.*o.*a.*e|u.*i.*o.*a.*e|u.*o.*i.*a.*e|o.*u.*i.*a.*e|o.*i.*u.*a.*e|o.*i.*a.*u.*e|o.*i.*a.*e.*u|o.*i.*e.*a.*u|o.*i.*e.*u.*a|o.*i.*u.*e.*a|o.*u.*i.*e.*a|u.*o.*i.*e.*a|u.*i.*o.*e.*a|i.*u.*o.*e.*a|i.*o.*u.*e.*a|i.*o.*e.*u.*a|i.*o.*e.*a.*u|i.*e.*o.*a.*u|i.*e.*o.*u.*a|i.*e.*u.*o.*a|i.*u.*e.*o.*a|u.*i.*e.*o.*a|u.*i.*e.*a.*o|i.*u.*e.*a.*o|i.*e.*u.*a.*o|i.*e.*a.*u.*o|i.*e.*a.*o.*u|e.*i.*a.*o.*u|e.*i.*a.*u.*o|e.*i.*u.*a.*o|e.*u.*i.*a.*o|u.*e.*i.*a.*o|u.*e.*i.*o.*a|e.*u.*i.*o.*a|e.*i.*u.*o.*a|e.*i.*o.*u.*a|e.*i.*o.*a.*u|e.*o.*i.*a.*u|e.*o.*i.*u.*a|e.*o.*u.*i.*a|e.*u.*o.*i.*a|u.*e.*o.*i.*a|u.*o.*e.*i.*a|o.*u.*e.*i.*a|o.*e.*u.*i.*a|o.*e.*i.*u.*a|o.*e.*i.*a.*u|o.*e.*a.*i.*u|o.*e.*a.*u.*i|o.*e.*u.*a.*i|o.*u.*e.*a.*i|u.*o.*e.*a.*i|u.*e.*o.*a.*i|e.*u.*o.*a.*i|e.*o.*u.*a.*i|e.*o.*a.*u.*i|e.*o.*a.*i.*u|e.*a.*o.*i.*u|e.*a.*o.*u.*i|e.*a.*u.*o.*i|e.*u.*a.*o.*i|u.*e.*a.*o.*i|u.*e.*a.*i.*o|e.*u.*a.*i.*o|e.*a.*u.*i.*o|e.*a.*i.*u.*o|e.*a.*i.*o.*u"

``` r
str_subset(stringr::words,phrase)
```

    ## character(0)

There are no words in the `stringr::words` list that contain at least one of every vowel. Below I test to make sure the code actually works:

``` r
x <- c("aeiou", "ixyegogroojareaxu")
str_subset(x,phrase)
```

    ## [1] "aeiou"             "ixyegogroojareaxu"

It is MUCH easier to do this with multiple lines of `str_detect()`.

``` r
match_a <- str_detect(stringr::words,"a")
match_e <- str_detect(stringr::words,"e")
match_i <- str_detect(stringr::words,"i")
match_o <- str_detect(stringr::words,"o")
match_u <- str_detect(stringr::words,"u")

stringr::words[match_a & match_e & match_i & match_o & match_u]
```

    ## character(0)

#### 2. What word has the highest number of vowels? What word has the highest proportion of vowels? (Hint: what is the denominator?)

This is a great opportunity to use `str_count` combined with our "find any vowel" construct.

``` r
max_vowels <- str_count(stringr::words,"[aeiou]") %>%
  max()

max_vowels
```

    ## [1] 5

``` r
stringr::words[str_count(stringr::words,"[aeiou]") == max_vowels]
```

    ## [1] "appropriate" "associate"   "available"   "colleague"   "encourage"  
    ## [6] "experience"  "individual"  "television"

There are several words tied for the highest number of vowels: 5. Which words have the highest proportion of vowels? We can again find the number of letters in a word using `str_count()` combined with the wildcard operator.

``` r
num_vowels <- str_count(stringr::words,"[aeiou]")
num_letters <- str_count(stringr::words,".")

(highest_prop <- max(num_vowels/num_letters))
```

    ## [1] 1

``` r
stringr::words[num_vowels/num_letters == highest_prop]
```

    ## [1] "a"

The highest proportion of vowels is found in the word that only contains a single vowel!

Section 14.4.3 Excercises
-------------------------

<a href="#top">Back to top</a>

#### 1. In the previous example, you might have noticed that the regular expression matched “flickered”, which is not a colour. Modify the regex to fix the problem.

The question references the following problem: which sentences in `stringr::sentences` contain two or more colours?

``` r
# Define the regex expression
colours <- c("red", "orange", "yellow", "green", "blue", "purple")
(colour_match <- str_c(colours, collapse = "|"))
```

    ## [1] "red|orange|yellow|green|blue|purple"

``` r
more <- sentences[str_count(sentences, colour_match) > 1]
str_subset(more, colour_match)
```

    ## [1] "It is hard to erase blue or red ink."          
    ## [2] "The green light in the brown box flickered."   
    ## [3] "The sky in the west is tinged with orange red."

The original author was looking for sentences that matched their list of colours twice or more. They should have wrapped their colour expressions in `\b` to signify they wanted only those words.

``` r
colours <- c("\\bred", "orange", "yellow", "green", "blue", "purple\\b")
(colour_match <- str_c(colours, collapse = "\\b|\\b"))
```

    ## [1] "\\bred\\b|\\borange\\b|\\byellow\\b|\\bgreen\\b|\\bblue\\b|\\bpurple\\b"

``` r
more <- sentences[str_count(sentences, colour_match) > 1]
str_subset(more, colour_match)
```

    ## [1] "It is hard to erase blue or red ink."          
    ## [2] "The sky in the west is tinged with orange red."

#### 2. From the Harvard sentences data, extract:

**1. The first word from each sentence.**

I had to think about this one for a while. What operators in regex can we use to uniquely match an arbitrary first word, but not multiple words? I initially tried `^(.*)\s` but realised that the wildcard operator can also match whitespace! I realised that in order to extract the first word, I needed to tell regex to stop when it found a space. In regex this looks like `[^\s]+`.

``` r
str_extract(stringr::sentences,"^[^\\s]+") %>% 
  head(20)
```

    ##  [1] "The"   "Glue"  "It's"  "These" "Rice"  "The"   "The"   "The"  
    ##  [9] "Four"  "Large" "The"   "A"     "The"   "Kick"  "Help"  "A"    
    ## [17] "Smoky" "The"   "The"   "The"

**2. All words ending in `ing`.**

Here I want to build the expression that acts like: (match a word boundary)(match anything BUT a space)(match literal "ing")(match a word boundary). I use `str_extract_all` so that all matches are output, not just the first. The output of this is a list, so I convert it to a vector with `unlist` and remove duplicate words with `unique`.

``` r
matches <- str_subset(stringr::sentences,"\\b([^\\s]*)ing\\b")

str_extract_all(matches,"\\b([^\\s]*)ing\\b") %>% 
  unlist %>% 
  unique
```

    ##  [1] "spring"    "evening"   "morning"   "winding"   "living"   
    ##  [6] "king"      "Adding"    "making"    "raging"    "playing"  
    ## [11] "sleeping"  "ring"      "glaring"   "sinking"   "dying"    
    ## [16] "Bring"     "lodging"   "filing"    "wearing"   "wading"   
    ## [21] "swing"     "nothing"   "sing"      "painting"  "walking"  
    ## [26] "bring"     "shipping"  "puzzling"  "landing"   "thing"    
    ## [31] "waiting"   "whistling" "timing"    "changing"  "drenching"
    ## [36] "moving"    "working"

**3. All plurals.**

For simplicity, I will say that any word ending with `s` that is more than 3 letters is a plural. Finding every possible plural word would require a very long regex expression! The setup is similar to the other questions just done, but we need to specify a match of NOT-spaces 4 or more times using `{4,}`.

``` r
matches2 <- str_subset(stringr::sentences,"\\b([^\\s']{4,})s\\b")

str_extract_all(matches2,"\\b([^\\s]{4,})s\\b") %>% 
  unlist %>% 
  unique %>%
  head(20)
```

    ##  [1] "planks"    "bowls"     "lemons"    "makes"     "hours"    
    ##  [6] "stockings" "helps"     "fires"     "across"    "bonds"    
    ## [11] "Press"     "pants"     "useless"   "kittens"   "Sickness" 
    ## [16] "grass"     "books"     "keeps"     "chicks"    "leads"

Section 14.4.4 Excercises
-------------------------

<a href="#top">Back to top</a>

1. Find all words that come after a “number” like “one”, “two”, “three” etc. Pull out both the number and the word.
-------------------------------------------------------------------------------------------------------------------

First we will need a vector of character-numbers. I'll list numbers up to "ten", including the possibility that the first letter may be capitalized. I then combine them into a single regex expression, and surround the whole thing by a bracket. Finally, I build a regex expression to match any word, and combine it with the list of numbers, surrounded by its own brackets.

``` r
numbers <- c("[Oo]ne", "[Tt]wo", "[Tt]hree", "[Ff]our", "[Ff]ive", "[Ss]ix", "[Ss]even", "[Ee]ight", "[Nn]ine", "[Tt]en")

numbers2 <- str_c(numbers, collapse = "|")

## The regex expression
match_phrase <- str_c("\\b(",numbers2,") +([^\\s]+)\\b")


## Subset only matches
sentences[str_detect(stringr::sentences, match_phrase)] %>%
  str_extract(match_phrase)
```

    ##  [1] "Four hours"    "Two blue"      "seven books"   "two met"      
    ##  [5] "two factors"   "Ten pins"      "three lists"   "Two plus"     
    ##  [9] "two when"      "Eight miles"   "ten inches"    "one war"      
    ## [13] "Nine men"      "one button"    "six minutes"   "ten years"    
    ## [17] "Nine rows"     "two shares"    "two distinct"  "five cents"   
    ## [21] "Three for"     "two pins"      "five robins"   "four kinds"   
    ## [25] "Five years"    "three story"   "three inches"  "six comes"    
    ## [29] "three batches" "two leaves"    "Seven seals"   "One step"

2. Find all contractions. Separate out the pieces before and after the apostrophe.
----------------------------------------------------------------------------------

We can use `str_match()` to separate out the pieces before and after the apostrophe if we build the regex expression properly, using appropriate bracketing:

``` r
match_phrase <- ("\\b([^ ]+)'([^ ]+)\\b")

str_subset(stringr::sentences, match_phrase) %>%
  str_match(match_phrase)
```

    ##       [,1]         [,2]       [,3]
    ##  [1,] "It's"       "It"       "s" 
    ##  [2,] "man's"      "man"      "s" 
    ##  [3,] "don't"      "don"      "t" 
    ##  [4,] "store's"    "store"    "s" 
    ##  [5,] "workmen's"  "workmen"  "s" 
    ##  [6,] "Let's"      "Let"      "s" 
    ##  [7,] "sun's"      "sun"      "s" 
    ##  [8,] "child's"    "child"    "s" 
    ##  [9,] "king's"     "king"     "s" 
    ## [10,] "It's"       "It"       "s" 
    ## [11,] "don't"      "don"      "t" 
    ## [12,] "queen's"    "queen"    "s" 
    ## [13,] "don't"      "don"      "t" 
    ## [14,] "pirate's"   "pirate"   "s" 
    ## [15,] "neighbor's" "neighbor" "s"

Section 14.4.5 Excercises
-------------------------

<a href="#top">Back to top</a>

#### 1. Replace all forward slashes in a string with backslashes.

Recall that literal backslashes must be represented by *four* backslashes in the input string for functions that use regex.

``` r
c("//////", "a/b", "xxx/xx/x\\") %>%
  str_replace_all("/", "\\\\") %>%
  writeLines
```

    ## \\\\\\
    ## a\b
    ## xxx\xx\x\

#### 2. Implement a simple version of `str_to_lower()` using `replace_all()`.

The best way to impliment this without using `str_to_lower` is to utilize the `tolower` function within `str_replace_all`.

``` r
str_replace_all(stringr::sentences, "[A-Z]", tolower) %>%
  head(5)
```

    ## [1] "the birch canoe slid on the smooth planks." 
    ## [2] "glue the sheet to the dark blue background."
    ## [3] "it's easy to tell the depth of a well."     
    ## [4] "these days a chicken leg is a rare dish."   
    ## [5] "rice is often served in round bowls."

#### 3. Switch the first and last letters in `words`. Which of those strings are still words?

It's easiest to do this by splitting up the words into three segments: first letter, middle letter(s) (if any), and last letter. Then use backreferencing within `str_raplce` to switch around the first and last letter:

``` r
str_replace(stringr::words,"(^.)(.*)(.$)", "\\3\\2\\1") %>%
  head(50)
```

    ##  [1] "a"           "ebla"        "tboua"       "ebsoluta"    "tccepa"     
    ##  [6] "tccouna"     "echieva"     "scrosa"      "tca"         "ectiva"     
    ## [11] "lctuaa"      "dda"         "sddresa"     "tdmia"       "edvertisa"  
    ## [16] "tffeca"      "dffora"      "rftea"       "nfternooa"   "ngaia"      
    ## [21] "tgainsa"     "ega"         "tgena"       "oga"         "egrea"      
    ## [26] "ria"         "lla"         "wlloa"       "tlmosa"      "glona"      
    ## [31] "ylreada"     "tlrigha"     "olsa"        "hlthouga"    "slwaya"     
    ## [36] "america"     "tmouna"      "dna"         "rnothea"     "rnswea"     
    ## [41] "yna"         "tpara"       "tpparena"    "rppeaa"      "yppla"      
    ## [46] "tppoina"     "hpproaca"    "eppropriata" "area"        "ergua"

Most of the words become nonsense, but a few such as `a`, `america`, and `area` remain unchanged.

Section 14.4.6 Excercises
-------------------------

<a href="#top">Back to top</a>

#### 1. Split up a string like `"apples, pears, and bananas"` into individual components.

This is just basic usage of `str_split`. Note that `str_split` returns a list, so we can pipe the result into `.[[1]]` to extract our answer as a character vector.

``` r
my_fruit <- "apples, pears, and bananas"
str_split(my_fruit, boundary("word")) %>%
  .[[1]]
```

    ## [1] "apples"  "pears"   "and"     "bananas"

#### 2. Why is it better to split up by `boundary("word")` than `" "`?

The reason is that words may not always be separated by just spaces. They can be separated by a period, comma, newline, tab, or some other kind of punctuation mark. `boundary("word")` takes this into consideration for you.

``` r
str_split("A string may contain commas, colons:, tabs,\t and periods.", " ")[[1]]
```

    ## [1] "A"        "string"   "may"      "contain"  "commas,"  "colons:,"
    ## [7] "tabs,\t"   "and"      "periods."

``` r
str_split("A string may contain commas, colons:, tabs,\t and periods.", boundary("word"))[[1]]
```

    ## [1] "A"       "string"  "may"     "contain" "commas"  "colons"  "tabs"   
    ## [8] "and"     "periods"

#### 3. What does splitting with an empty string (`""`) do? Experiment, and then read the documentation.

As you might expect, this splits up a string into its component characters, including spaces.

``` r
str_split("test string", "")[[1]]
```

    ##  [1] "t" "e" "s" "t" " " "s" "t" "r" "i" "n" "g"

Section 14.5 Excercises
-----------------------

<a href="#top">Back to top</a>

#### 1. How would you find all strings containing `\` with `regex()` vs. with `fixed()`?

`Regex()` is the default, and we have already seen how to find all strings containing `\` with `regex()` it looks like:

``` r
c("\\","\\\\", "/", "abc", "ab\\") %>%
  str_subset(regex("\\\\")) %>%
  writeLines()
```

    ## \
    ## \\
    ## ab\

Using `fixed()`, the backslashes do not need to be escaped within the interpretation, but we still need two because the string that we are matching contains 2 (one for escaping).

``` r
c("\\","\\\\", "/", "abc", "ab\\") %>%
  str_subset(fixed("\\")) %>%
  writeLines()
```

    ## \
    ## \\
    ## ab\

#### 2. What are the five most common words in `sentences`?

For this, we should use `str_extract_all` with the `boundary("word")` option to extract all the words first. Since the output of `str_extract_all()` is a list, we can use `unlist` to get a huge vector containing just the words from all of the `sentences`. Since some of the words have a first uppercase letter, we use `str_to_lower()` to make them all lowercase for easier comparison.

Then we can sort and count them using the `dplyr` functions we learned so much about!

``` r
all_words <- str_extract_all(stringr::sentences, boundary("word")) %>%
  unlist %>%
  str_to_lower

tibble(all_words) %>%
  set_names("Word") %>%
  group_by(Word) %>%
  mutate(Number = length(Word)) %>%
  distinct(Word, Number) %>%
  arrange(desc(Number)) %>%
  head(5)
```

    ## # A tibble: 5 x 2
    ## # Groups:   Word [5]
    ##    Word Number
    ##   <chr>  <int>
    ## 1   the    751
    ## 2     a    202
    ## 3    of    132
    ## 4    to    123
    ## 5   and    118

Section 14.7 Excercises
-----------------------

<a href="#top">Back to top</a>

#### 1. Find the stringi functions that:

**1. Count the number of words.**

This function is called `stri_count_words`:

``` r
stri_count_words(sentences) %>%
  head(20)
```

    ##  [1]  8  8  9  9  7  7  8  8  7  8  8  8 10  7  8  9  6  7  8  8

**2. Find duplicated strings.**

The function `stri_duplicated` lists whether each element of vector of characters is duplicated. `stri_duplicated_any` outputs which position the first duplicate element is in:

``` r
input <- c("a", "b", "c", "a", "aa", "a")

stri_duplicated(input)
```

    ## [1] FALSE FALSE FALSE  TRUE FALSE  TRUE

``` r
stri_duplicated_any(input)
```

    ## [1] 4

**3. Generate random text.**

There are two functions that do this: `stri_rand_lipsum(nparagraphs)` generates pseudorandom paragraphs of "words", where the input `nparagraphs` determines how many paragraphs to output.`stri_rand_strings(lines, length)` generates random lines of text. `lines` determines how many lines to generate and `length` is the length of each line.

``` r
stri_rand_lipsum(1) %>%
  writeLines()
```

    ## Lorem ipsum dolor sit amet, tempor sed finibus sed, vulputate volutpat scelerisque eros sed odio! Maecenas, condimentum. Et amet ac vehicula feugiat a nec ut. Amet vel quam placerat a a quam tincidunt odio mauris sed. Ipsum, odio sed sem mollis sed lorem. Faucibus in nibh vitae malesuada risus nisl suspendisse. Mauris pharetra vehicula amet nascetur facilisis massa pellentesque. Dolor eleifend sit sodales sed mauris malesuada luctus quam. Nulla eget, ac iaculis, per. Torquent tincidunt sodales ipsum proin potenti habitasse ligula arcu. Auctor lobortis malesuada. Conubia tellus ex himenaeos, nullam mattis. Commodo elit in velit. Nulla molestie pellentesque magna nisl. Amet vestibulum ante consectetur, diam posuere metus mauris. Tellus proin sit maecenas elit curabitur, est.

``` r
stri_rand_strings(1, 10)
```

    ## [1] "Ed4MBcoLlT"

#### 2. How do you control the language that `stri_sort()` uses for sorting?

For the function `stri_sort()`, the language that is used for sorting is determined by the argument `locale`. The input for `locale` should be the language code corresponding to the language of choice, such as `"en"` for english.

``` r
stri_sort(words, locale = "en") %>% 
  head(20)
```

    ##  [1] "a"         "able"      "about"     "absolute"  "accept"   
    ##  [6] "account"   "achieve"   "across"    "act"       "active"   
    ## [11] "actual"    "add"       "address"   "admit"     "advertise"
    ## [16] "affect"    "afford"    "after"     "afternoon" "again"

Writing functions
-----------------

<a href="#top">Back to top</a>

I decided to write a function that would take as an input a dataframe that contains an independent variable `year`, and output a quadratic fit of the chosen dependent variable vs year for every `country`. Below is my creation!

``` r
le_Quad_fit <- function(dat, dependant_var = "lifeExp", offset = 1952, range = 55) {

  # Input must be a data frame
  if (!is.data.frame(dat)){
    stop('This function expects a data frames as input.\n',
         'You have provided an object of class: ', class(x)[1])
  }
  
  # Unique countries
  u_countries <- dat$country %>% 
    unique() %>%
    as.character
  
  # Generate a vector of years for later
  year <- seq(offset, offset + range, 0.1)
  
  # Pre-make tibble for output later
  param = list(0)
  quad_model = list(0)
  
  i=0; # index
  
  # Loop through all countries
  for (current_country in u_countries){
    
    i=i+1 #incriment
  
    current_dat <- (dat %>% filter(country == current_country))
    
    # Generate linear and quadratic terms
    current_dat$yearoffset <- current_dat$year - offset
    current_dat$yearoffset2 <- (current_dat$year - offset)^2

    # Quadratic fit
    the_fit <- lm(lifeExp ~ yearoffset + yearoffset2, current_dat)
  
    # Rename parameters
    param[[i]] <- setNames(coef(the_fit), c("Intercept", "Linear_Coef", "Quadratic_Coef"))
  
    # Generate the quadratic fit function
    quad_fit <- param[[i]][[1]] + param[[i]][[2]]*(year-offset) + param[[i]][[3]]*(year-offset)^(2)
  
    # Package into a tibble
    quad_model[[i]] <- tibble(quad_fit, year)
    
  }
  
  output <- tibble(country = u_countries , fit_parameters = param, model = quad_model)
  
  return(output)
}
```

Let's try using it and seeing what the output looks like:

``` r
# Generate all quadratic fits using our fancy new function
gap_life_fits <- le_Quad_fit(gapminder, dependant_var = "lifeExp", offset = 1952, range = 55)

str(gap_life_fits, max.level = 1)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    142 obs. of  3 variables:
    ##  $ country       : chr  "Afghanistan" "Albania" "Algeria" "Angola" ...
    ##  $ fit_parameters:List of 142
    ##  $ model         :List of 142

The output is a nice tibble that we can use to make quadratic fit plots. It also contains the coefficients of the fit and the name of each country. Below I show an example of the quadratic fit of Canada vs the data.

``` r
# Let's see Canada as an example
Country_choice <- "Canada"

gap_life_canada <- gap_life_fits %>% 
  filter(country == Country_choice)

dat <- (gapminder %>% filter(country == Country_choice))

ggplot() +
  geom_line(data = gap_life_canada[[1,3]], aes(x = year, y = quad_fit)) +
  geom_point(data = dat, aes(x = year, y = lifeExp)) +
  scale_x_continuous(breaks = seq(1950, 2010, 10),
    labels = as.character(seq(1950, 2010, 10)),
    limits = c(1950, 2010),
    minor_breaks = NULL) +
  theme_bw() +
  theme(axis.text.x = element_text(size=12,face ="bold", angle = 45, hjust = 1),
    axis.text.y = element_text(size=12,face ="bold"),
    plot.title = element_text(size=14,
      face ="bold",hjust = 0.5),
    axis.title = element_text(size=14, face ="bold"),
    strip.background = element_rect(fill="orange"),
    strip.text = element_text(size=14, face="bold"),
    legend.title = element_text(size=14, face ="bold"),
    legend.text = element_text(size=12, face ="bold")) +
  labs(x = "Year", 
    y = "Life Expectancy",
    title = paste0("Quadratic fit for Life Expectancy vs Year in ", Country_choice))
```

![](Data_Wrangling_Wrapup_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-83-1.png)

That's all for this project. Thanks for reading!

<a href="#top">Back to top</a>
