Source: https://books.lesscrime.info/learncrimemapping/04_transforming_data/index.html

<a id="quarto-document-content"></a>
<a id="title-block-header"></a>
<a id="transforming-and-summarising-data"></a>

# `<a id="sec-transforming-data"></a>`{=html}4  Transforming and summarising data

Figure: Students group loose data shapes into rows and summarise the groups in a compact table.

In [Chapter 3](../03_data_wrangling/index.llms.md) we learned how to load tabular data and choose the rows and columns needed for an analysis. This chapter continues the data-wrangling process. We will learn how to create new columns, summarise and arrange rows, connect several operations in a pipeline and save the processed result without changing the original data.

TipBefore you start

1.  Open Positron or -- if you already have Positron open -- start a new R session by clicking the **Restart R** (**⟳**) button in the **Console** panel. This makes sure no code you ran previously will interfere with the work you do in this chapter.
2.  Make sure you are working in the crime mapping project workspace you created in [Section 1.5](../01_getting_started/index.llms.md#sec-create-project). In the top-right corner of the Positron window, you should see a folder icon and the words `crime_mapping`. If not, click the **File** menu, then **Open Folder ...** and choose the `crime_mapping` folder.

<a id="introduction"></a>

## 4.1 Introduction

Selecting columns and filtering rows allow us to choose existing data. But often we also need to be more active in wrangling data, to create new columns, update existing columns and summarise groups of data. In this chapter we will continue working with the San Francisco robbery and Austin aggravated-assault datasets introduced in [Chapter 3](../03_data_wrangling/index.llms.md).

In this chapter, we will learn how to:

- create or change columns with `mutate()`;
- summarise and count rows;
- arrange rows into a useful order;
- save processed data separately from the original files;
- combine sequential operations with the pipe operator; and
- check that a complete script runs in a fresh R session.

Most of the examples in this chapter are labelled **R Console** because they are temporary code that helps us understand and practise each function. In [Section 4.7](#sec-complete-wrangling-scripts), we will use what we have learned to extend copies of the scripts from [Chapter 3](../03_data_wrangling/index.llms.md) and create two complete, reproducible analyses.

The complete data-wrangling process follows these stages:

Load data

using the code from [Chapter 3](../03_data_wrangling/index.llms.md)

Transform data

by filtering and creating columns

Summarise data

by counting and arranging rows

Save data

in the `data/processed` folder

<a id="sec-mutate"></a>
<a id="transforming-values"></a>

## 4.2 Transforming values

It is often useful to create new columns in our data, or change the values of existing columns. The `mutate()` function in the dplyr package gives us a way to transform existing columns in our dataset using almost any R function.

Figure: Cartoon labelled dplyr: mutate, add columns, keep existing. Monsters use a crane to place a new column C beside existing columns A and B, illustrating that creating a column does not remove the original columns.

[](https://lubridate.tidyverse.org/)

For example, say we wanted to create a new column in our aggravated-assault dataset specifying the day of the week on which each crime occurred. We can do this using the `wday()` function from the [lubridate package](https://lubridate.tidyverse.org/) (using the `label = TRUE` argument to produce weekday names, rather than numbers):

<a id="lst-transforming-data-derive-weekday"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">mutate</span>(agg_assault_data, <span class="at">weekday =</span> <span class="fu">wday</span>(date, <span class="at">label =</span> <span class="cn">TRUE</span>))</span></code></pre></div>
<figcaption>Code 4.1</figcaption>
</figure>

    # A tibble: 8,696 × 6
       date                longitude latitude location_type location_category
       <dttm>                  <dbl>    <dbl> <chr>         <chr>            
     1 2019-01-01 00:00:00     -97.7     30.3 residence     residence        
     2 2019-01-01 00:00:00     -97.8     30.2 residence     residence        
     3 2019-01-01 00:01:00     -97.7     30.3 <NA>          <NA>             
     4 2019-01-01 00:15:00     -97.7     30.3 <NA>          <NA>             
     5 2019-01-01 00:27:00     -97.8     30.2 residence     residence        
     6 2019-01-01 00:30:00     -97.7     30.3 <NA>          <NA>             
     7 2019-01-01 00:51:00     -97.7     30.3 <NA>          <NA>             
     8 2019-01-01 01:00:00     -97.7     30.4 residence     residence        
     9 2019-01-01 01:00:00     -97.7     30.3 <NA>          <NA>             
    10 2019-01-01 01:12:00     -97.7     30.3 residence     residence        
    # ℹ 8,686 more rows
    # ℹ 1 more variable: weekday <ord>

We can also change existing columns. However (as with objects) there is no way to undo this, so you should only replace columns if you are sure you will not need them. For example, if we wanted to remove the time portion of the `date` variable using the `as_date()` function (also from the lubridate package) and at the same time create the weekday variable:

<a id="lst-transforming-data-convert-date-and-derive-weekday"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">mutate</span>(</span>
<span id="cb2-2"><a href="#cb2-2"></a>  agg_assault_data,</span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="at">date =</span> <span class="fu">as_date</span>(date),</span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="at">weekday =</span> <span class="fu">wday</span>(date, <span class="at">label =</span> <span class="cn">TRUE</span>)</span>
<span id="cb2-5"><a href="#cb2-5"></a>)</span></code></pre></div>
<figcaption>Code 4.2</figcaption>
</figure>

    # A tibble: 8,696 × 6
       date       longitude latitude location_type location_category weekday
       <date>         <dbl>    <dbl> <chr>         <chr>             <ord>  
     1 2019-01-01     -97.7     30.3 residence     residence         Tue    
     2 2019-01-01     -97.8     30.2 residence     residence         Tue    
     3 2019-01-01     -97.7     30.3 <NA>          <NA>              Tue    
     4 2019-01-01     -97.7     30.3 <NA>          <NA>              Tue    
     5 2019-01-01     -97.8     30.2 residence     residence         Tue    
     6 2019-01-01     -97.7     30.3 <NA>          <NA>              Tue    
     7 2019-01-01     -97.7     30.3 <NA>          <NA>              Tue    
     8 2019-01-01     -97.7     30.4 residence     residence         Tue    
     9 2019-01-01     -97.7     30.3 <NA>          <NA>              Tue    
    10 2019-01-01     -97.7     30.3 residence     residence         Tue    
    # ℹ 8,686 more rows

You may sometimes want to change only some values in a column. With a categorical variable, we can change one value to another using the `replace_values()` function from the dplyr package. Look at this code and use the comments (lines starting with `#`) to understand how it works.

<a id="lst-transforming-data-recode-location-categories"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">mutate</span>(</span>
<span id="cb2-2"><a href="#cb2-2"></a>  agg_assault_data,</span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="at">location_category =</span> <span class="fu">replace_values</span>(</span>
<span id="cb2-4"><a href="#cb2-4"></a>    location_category,</span>
<span id="cb2-5"><a href="#cb2-5"></a>    <span class="co"># We specify which existing values we want to convert into which new values</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>    <span class="co"># by providing the existing value on the left-hand side and the new value</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>    <span class="co"># on the right hand side, separated by a tilde (~) character</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>    <span class="st">&quot;open space&quot;</span> <span class="sc">~</span> <span class="st">&quot;public open space&quot;</span>,</span>
<span id="cb2-9"><a href="#cb2-9"></a>    <span class="st">&quot;street&quot;</span> <span class="sc">~</span> <span class="st">&quot;street or road&quot;</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  )</span>
<span id="cb2-11"><a href="#cb2-11"></a>)</span></code></pre></div>
<figcaption>Code 4.3</figcaption>
</figure>

    # A tibble: 8,696 × 5
       date                longitude latitude location_type location_category
       <dttm>                  <dbl>    <dbl> <chr>         <chr>            
     1 2019-01-01 00:00:00     -97.7     30.3 residence     residence        
     2 2019-01-01 00:00:00     -97.8     30.2 residence     residence        
     3 2019-01-01 00:01:00     -97.7     30.3 <NA>          <NA>             
     4 2019-01-01 00:15:00     -97.7     30.3 <NA>          <NA>             
     5 2019-01-01 00:27:00     -97.8     30.2 residence     residence        
     6 2019-01-01 00:30:00     -97.7     30.3 <NA>          <NA>             
     7 2019-01-01 00:51:00     -97.7     30.3 <NA>          <NA>             
     8 2019-01-01 01:00:00     -97.7     30.4 residence     residence        
     9 2019-01-01 01:00:00     -97.7     30.3 <NA>          <NA>             
    10 2019-01-01 01:12:00     -97.7     30.3 residence     residence        
    # ℹ 8,686 more rows

`replace_values()` keeps the existing value for any values that we have not specified.

We could also make changes based on more-complicated sets of criteria using the `case_when()` function, but we will return to that in [Chapter 15](../15_mapping_time/index.llms.md).

Functions used inside `mutate()` usually return one value for every row in the dataset. These are known as *vectorised* functions. A function such as `mean()` or `max()` instead returns a single summary value. R can repeat that value in every row if it is used inside `mutate()`, but that is usually not what we want. To reduce several rows to one summary row, we use the next data-wrangling function: `summarise()`.

QuizTransforming values

**What does `mutate(agg_assault_data, weekday = wday(date, label = TRUE))` return?**

- It permanently changes the original data, even if the result is not assigned.
- It returns a tibble containing a new or changed column. (Correct answer)
- It keeps only rows that contain the new value.
- It changes only the name of an existing column.

<a id="sec-summarise"></a>
<a id="summarising-rows"></a>

## 4.3 Summarising rows

Summarising data is often useful in crime analysis. We can use the `summarise()` function from the dplyr package to produce summaries of different columns in our data. There is an identical function called `summarize()` so that you do not have to remember whether to use the US or British spelling.

By default, `summarise()` collapses data into a single row, with each column summarised using a function that you specify. For example, we can calculate the mean longitude and latitude of the aggravated-assault locations.

<a id="lst-transforming-data-summarise-mean-coordinates"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">summarise</span>(</span>
<span id="cb2-2"><a href="#cb2-2"></a>  agg_assault_data,</span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="at">mean_lng =</span> <span class="fu">mean</span>(longitude, <span class="at">na.rm =</span> <span class="cn">TRUE</span>),</span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="at">mean_lat =</span> <span class="fu">mean</span>(latitude, <span class="at">na.rm =</span> <span class="cn">TRUE</span>)</span>
<span id="cb2-5"><a href="#cb2-5"></a>)</span></code></pre></div>
<figcaption>Code 4.4</figcaption>
</figure>

    # A tibble: 1 × 2
      mean_lng mean_lat
         <dbl>    <dbl>
    1    -97.7     30.3

TipWhat does the argument `na.rm = TRUE` do?

<a id="callout-3"></a>

Lots of functions in R have an argument called `na.rm` that can be set to either `TRUE` or `FALSE`. Setting `na.rm = TRUE` in this case specifies that the `mean()` function should remove (`rm`) any missing (`NA`) values before calculating the mean.

If we do not specify this and our data contain any missing values, the `mean()` function will return `NA`. Functions in R do this because it is not possible to completely answer the question 'what is the mean of these values?' if some of the values are missing.

This logic applies in lots of cases. For example, if you create an R object called `value` with the code `value <- 2` and then run the R code `value > 1`, you will get the answer `TRUE`. But if you set the object `value` to be `NA` using the code `value <- NA`, when you run the R code `value > 1` you will get the answer `NA`. This is because there is no way to know if the missing value represented by `NA` is greater than 1 or not. This is why it is often useful to calculate statistics such as a mean value after removing any missing values using the `na.rm = TRUE` argument.

`summarise()` becomes more useful if we first divide our data into groups, since we then get a summary for each group separately. We can use the `.by` argument of the `summarise()` function to specify that we want separate summaries for each unique value of one or more columns in the data. For example, to produce a separate summary for each unique value of `location_category`, we can use this code:

<a id="lst-transforming-data-summarise-coordinates-by-category"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">summarise</span>(</span>
<span id="cb2-2"><a href="#cb2-2"></a>  agg_assault_data,</span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="at">mean_lng =</span> <span class="fu">mean</span>(longitude, <span class="at">na.rm =</span> <span class="cn">TRUE</span>),</span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="at">mean_lat =</span> <span class="fu">mean</span>(latitude, <span class="at">na.rm =</span> <span class="cn">TRUE</span>),</span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="at">.by =</span> location_category</span>
<span id="cb2-6"><a href="#cb2-6"></a>)</span></code></pre></div>
<figcaption>Code 4.5</figcaption>
</figure>

    # A tibble: 12 × 3
       location_category mean_lng mean_lat
       <chr>                <dbl>    <dbl>
     1 residence            -97.7     30.3
     2 <NA>                 -97.7     30.3
     3 hotel                -97.7     30.3
     4 other                -97.7     30.3
     5 retail               -97.7     30.3
     6 healthcare           -97.7     30.3
     7 open space           -97.7     30.3
     8 commercial           -97.7     30.3
     9 education            -97.7     30.3
    10 government           -97.7     30.3
    11 leisure              -97.7     30.4
    12 transportation       -97.7     30.2

You can add multiple grouping variables using the `c()` (*combine*) function if you want to generate summary values for groups within groups:

<a id="lst-transforming-data-summarise-coordinates-by-category-and-type"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">summarise</span>(</span>
<span id="cb2-2"><a href="#cb2-2"></a>  agg_assault_data,</span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="at">mean_lng =</span> <span class="fu">mean</span>(longitude, <span class="at">na.rm =</span> <span class="cn">TRUE</span>),</span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="at">mean_lat =</span> <span class="fu">mean</span>(latitude, <span class="at">na.rm =</span> <span class="cn">TRUE</span>),</span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="at">.by =</span> <span class="fu">c</span>(location_category, location_type)</span>
<span id="cb2-6"><a href="#cb2-6"></a>)</span></code></pre></div>
<figcaption>Code 4.6</figcaption>
</figure>

    # A tibble: 24 × 4
       location_category location_type     mean_lng mean_lat
       <chr>             <chr>                <dbl>    <dbl>
     1 residence         residence            -97.7     30.3
     2 <NA>              <NA>                 -97.7     30.3
     3 hotel             hotel                -97.7     30.3
     4 other             other                -97.7     30.3
     5 retail            other retail         -97.7     30.3
     6 healthcare        healthcare           -97.7     30.3
     7 retail            mall                 -97.8     30.3
     8 retail            convenience store    -97.7     30.3
     9 open space        green space          -97.7     30.3
    10 commercial        office               -97.7     30.3
    # ℹ 14 more rows

<a id="sec-transforming-data-counting-rows"></a>
<a id="counting-rows"></a>

### 4.3.1 Counting rows

One very common way of summarising data is to count the number of rows in a dataset that have each unique value of one or more columns. For example, if we have a dataset of crimes in which each row represents a single crime, we might want to count how many crimes happened on each day of the week, or how many crimes of each type are in the dataset. We can use `summarise()` to do that, together with the `n()` function (from the same dplyr package as `summarise()`). For example, if we wanted to count how many rows in the `agg_assault_data` dataset had each unique combination of `location_category` and `location_type`:

<a id="lst-transforming-data-count-rows-with-summarise"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">summarise</span>(agg_assault_data, <span class="at">n =</span> <span class="fu">n</span>(), <span class="at">.by =</span> <span class="fu">c</span>(location_category, location_type))</span></code></pre></div>
<figcaption>Code 4.7</figcaption>
</figure>

    # A tibble: 24 × 3
       location_category location_type         n
       <chr>             <chr>             <int>
     1 residence         residence          4385
     2 <NA>              <NA>               3352
     3 hotel             hotel               248
     4 other             other               205
     5 retail            other retail         30
     6 healthcare        healthcare           36
     7 retail            mall                 11
     8 retail            convenience store    90
     9 open space        green space         165
    10 commercial        office               28
    # ℹ 14 more rows

In this code, the `n()` function simply returns the number of rows of data in each group, i.e. the number of rows with each unique combination of values of `location_category` and `location_type`.

Since counting the number of rows in each group in a dataset is a very common task, dplyr includes another function called `count()` that allows you to do the same thing as in [Code 4.7](#lst-transforming-data-count-rows-with-summarise), but with slightly less typing. So if you wanted to know how many aggravated assaults had occurred in each location category and type, you could use this code instead of using `summarise()`:

<a id="lst-transforming-data-count-rows-with-count"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">count</span>(agg_assault_data, location_category, location_type)</span></code></pre></div>
<figcaption>Code 4.8</figcaption>
</figure>

    # A tibble: 24 × 3
       location_category location_type         n
       <chr>             <chr>             <int>
     1 commercial        construction         11
     2 commercial        factory/warehouse     2
     3 commercial        finance               1
     4 commercial        office               28
     5 commercial        storage               4
     6 education         child care           11
     7 education         college               5
     8 education         school               25
     9 government        government           18
    10 healthcare        healthcare           36
    # ℹ 14 more rows

Note that the first argument of `count()` is the dataset, and every subsequent argument specifies another variable that should be used to group the data.

QuizSummarising and counting rows

**What does `count(agg_assault_data, location_category, location_type)` return?**

- One row for every offence in the original data
- One row for each unique combination of location category and location type (Correct answer)
- One column for each unique location category
- Only rows that contain no missing values

<a id="arranging-rows"></a>

## 4.4 Arranging rows

It is sometimes useful to be able to place rows in a dataset into a particular order. We can do this using the `arrange()` function from the dplyr package. For example, we can sort the aggravated-assault data by date:

<a id="lst-transforming-data-sort-dates-ascending"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">arrange</span>(agg_assault_data, date)</span></code></pre></div>
<figcaption>Code 4.9</figcaption>
</figure>

    # A tibble: 8,696 × 5
       date                longitude latitude location_type location_category
       <dttm>                  <dbl>    <dbl> <chr>         <chr>            
     1 2019-01-01 00:00:00     -97.7     30.3 residence     residence        
     2 2019-01-01 00:00:00     -97.8     30.2 residence     residence        
     3 2019-01-01 00:01:00     -97.7     30.3 <NA>          <NA>             
     4 2019-01-01 00:15:00     -97.7     30.3 <NA>          <NA>             
     5 2019-01-01 00:27:00     -97.8     30.2 residence     residence        
     6 2019-01-01 00:30:00     -97.7     30.3 <NA>          <NA>             
     7 2019-01-01 00:51:00     -97.7     30.3 <NA>          <NA>             
     8 2019-01-01 01:00:00     -97.7     30.4 residence     residence        
     9 2019-01-01 01:00:00     -97.7     30.3 <NA>          <NA>             
    10 2019-01-01 01:12:00     -97.7     30.3 residence     residence        
    # ℹ 8,686 more rows

By default, `arrange()` sorts rows in ascending order, i.e. it sorts numeric values from the smallest to the largest, dates from earliest to latest and character values alphabetically. We can instead sort values in descending order by wrapping the name of a column in the `desc()` function:

<a id="lst-transforming-data-sort-dates-descending"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">arrange</span>(agg_assault_data, <span class="fu">desc</span>(date))</span></code></pre></div>
<figcaption>Code 4.10</figcaption>
</figure>

    # A tibble: 8,696 × 5
       date                longitude latitude location_type location_category
       <dttm>                  <dbl>    <dbl> <chr>         <chr>            
     1 2019-12-31 23:33:00     -97.7     30.4 residence     residence        
     2 2019-12-31 23:26:00     -97.7     30.4 residence     residence        
     3 2019-12-31 23:20:00     -97.7     30.3 <NA>          <NA>             
     4 2019-12-31 23:19:00     -97.7     30.3 <NA>          <NA>             
     5 2019-12-31 22:39:00     -97.7     30.3 other         other            
     6 2019-12-31 22:29:00     -97.7     30.3 residence     residence        
     7 2019-12-31 21:13:00     -97.8     30.2 residence     residence        
     8 2019-12-31 20:52:00     -97.7     30.3 residence     residence        
     9 2019-12-31 20:44:00     -97.7     30.3 residence     residence        
    10 2019-12-31 20:19:00     -97.7     30.3 <NA>          <NA>             
    # ℹ 8,686 more rows

We can also sort the data based on multiple columns -- the data are sorted first on the first column that you specify, with tied rows then sorted on the subsequent columns in order.

<a id="lst-transforming-data-sort-by-multiple-columns"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">arrange</span>(agg_assault_data, date, <span class="fu">desc</span>(location_type), location_category)</span></code></pre></div>
<figcaption>Code 4.11</figcaption>
</figure>

    # A tibble: 8,696 × 5
       date                longitude latitude location_type location_category
       <dttm>                  <dbl>    <dbl> <chr>         <chr>            
     1 2019-01-01 00:00:00     -97.7     30.3 residence     residence        
     2 2019-01-01 00:00:00     -97.8     30.2 residence     residence        
     3 2019-01-01 00:01:00     -97.7     30.3 <NA>          <NA>             
     4 2019-01-01 00:15:00     -97.7     30.3 <NA>          <NA>             
     5 2019-01-01 00:27:00     -97.8     30.2 residence     residence        
     6 2019-01-01 00:30:00     -97.7     30.3 <NA>          <NA>             
     7 2019-01-01 00:51:00     -97.7     30.3 <NA>          <NA>             
     8 2019-01-01 01:00:00     -97.7     30.4 residence     residence        
     9 2019-01-01 01:00:00     -97.7     30.3 <NA>          <NA>             
    10 2019-01-01 01:12:00     -97.7     30.3 residence     residence        
    # ℹ 8,686 more rows

QuizArranging rows in data

**Which code arranges `agg_assault_data` from the latest date to the earliest?**

- arrange(agg_assault_data, desc(date)) (Correct answer)
- arrange(agg_assault_data, date)
- filter(agg_assault_data, desc(date))
- arrange(desc(date), agg_assault_data)

In the R Console, type the code necessary to arrange `agg_assault_data` in order of latitude, in descending order (from largest to smallest). Once you've tried writing the code, if you need help you can click the 'Solution' button below.

`arrange(agg_assault_data, desc(latitude))`

<a id="sec-saving-data"></a>
<a id="saving-data"></a>

## 4.5 Saving data

Once we have finished wrangling a particular dataset, it is often useful to save it to a file so that we can use it again in future without going through all the steps of data wrangling again.

Most R functions that begin with `read_` (like `read_csv()` and `read_excel()`) have equivalent functions that begin `write_` and which save data into a particular file format. In this example, we will use the `write_csv()` function from the readr package, which is loaded when we load the tidyverse package.

In [Section 1.5](../01_getting_started/index.llms.md#sec-create-project) we learned that it is important to keep our original downloaded data files *sterile*, i.e. not to change them after we have downloaded them. That means we can always go back to the original data if we need to. To help with that, we will keep any files we save after wrangling in a separate sub-folder inside the `data` folder called `processed`. This is a common practice in data analysis, and it is good to get into the habit of doing it from the start.

<a id="lst-transforming-data-save-processed-data-example"></a>

<figure>
<pre><code>Code to add later</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Save the processed data without changing the original file</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="fu">write_csv</span>(</span>
<span id="cb2-3"><a href="#cb2-3"></a>  agg_assault_counts,</span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;processed&quot;</span>, <span class="st">&quot;aggravated_assault_counts.csv&quot;</span>)</span>
<span id="cb2-5"><a href="#cb2-5"></a>)</span></code></pre></div>
<figcaption>Code 4.12</figcaption>
</figure>

There are corresponding write functions for other types of data, but in this course we will store most non-spatial data in CSV format because it can be read by many different programs.

QuizSaving processed data

**Why should wrangled data be saved in `data/processed` rather than `data/raw`?**

- It replaces the original downloaded file with the processed data.
- It saves the R script in the processed-data folder.
- It keeps derived data separate while preserving the original download. (Correct answer)
- It allows write_csv() to save an Excel workbook.

<a id="sec-pipe-operator"></a>
<a id="stringing-functions-together"></a>

## 4.6 Stringing functions together

In this chapter we have learned how to use the dplyr functions `select()`, `filter()`, `mutate()`, `summarise()` and `arrange()` to wrangle data from one format to another. Data wrangling is part of almost all data analysis, so these are skills we will use frequently.

Data wrangling often involves multiple steps. For example, we might want to load some data, select certain columns, filter some rows, mutate some of the variables, summarise the dataset and save the result. We can do each of these steps separately, assigning the result of each step to a new object.

<a id="lst-transforming-data-wrangle-assaults-with-pipe"></a>

<figure>
<pre><code>Do not run this code</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Select only the columns we need</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>robbery2 <span class="ot">&lt;-</span> <span class="fu">select</span>(san_fran_rob, date_time)</span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Filter only those offences that occurred in the first quarter of 2019</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>robbery3 <span class="ot">&lt;-</span> <span class="fu">filter</span>(robbery2, <span class="fu">as_date</span>(date_time) <span class="sc">&lt;=</span> <span class="fu">ymd</span>(<span class="st">&quot;2019-03-31&quot;</span>))</span>
<span id="cb2-6"><a href="#cb2-6"></a></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="co"># Create a new weekday variable</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>robbery4 <span class="ot">&lt;-</span> <span class="fu">mutate</span>(robbery3, <span class="at">weekday =</span> <span class="fu">wday</span>(date_time, <span class="at">label =</span> <span class="cn">TRUE</span>))</span>
<span id="cb2-9"><a href="#cb2-9"></a></span>
<span id="cb2-10"><a href="#cb2-10"></a><span class="co"># Count how many offences occurred on each weekday</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>q1_weekday_counts <span class="ot">&lt;-</span> <span class="fu">count</span>(robbery4, weekday)</span></code></pre></div>
<figcaption>Code 4.13</figcaption>
</figure>

This code works, but creates three intermediate objects as well as the final `q1_weekday_counts` object. Intermediate objects can be useful when debugging a complicated analysis. However, they also create the substantial risk that you will accidentally use the wrong intermediate object in a later step, which can often cause errors in your code that are hard to fix. For example, when you write the code that creates the `robbery4` object, if you accidentally use `robbery2` as the input instead of `robbery3`, the filtering step in the data-wrangling process will have no effect. For that reason, it is generally better to avoid creating intermediate objects unless you actually need them.

Notice that:

1.  the first argument expected by `select()`, `filter()`, `mutate()` and `count()` is always the tibble produced by the previous step and
2.  once each of `robbery2`, `robbery3` and `robbery4` has been created, it is never used again in the code.

For example, `filter()` uses the `robbery2` object created by `select()`, but after that `robbery2` is never used again. Whenever you write code that consists of several sequential steps in which (a) each step uses the data produced by the previous step and (b) the data produced by each step is only used once, there is a better way to do it. This method uses the `|>` (or *pipe*) operator. The pipe operator works by using the result of the code on the left-hand side of the pipe as the first argument to a function on the right-hand side. So the code `x |> fun1() |> fun2()` starts with an object called `x`, uses that as the input to the function `fun1()`, then passes the result produced by `fun1()` and uses that as the input to `fun2()`.

It may be useful to read the pipe operator as 'and then', since piped code does the first thing *and then* the second thing with the result *and then* the third thing with the result of that, and so on. Piped code (sometimes called a *pipeline*) is a lot like the series of steps in a recipe.

For example, instead of creating multiple objects called `robbery2`, `robbery3`, `robbery4` and `q1_weekday_counts` and so on, we can use a single code pipeline. We will add this pipeline to a script in [Section 4.7](#sec-complete-wrangling-scripts). For now, look at [Code 4.14](#lst-transforming-data-weekday-counts-pipeline) and its numbered explanations -- note that each pipe operator (`|>`) corresponds to '*and then*' in the explanations accompanying [Code 4.14](#lst-transforming-data-weekday-counts-pipeline).

<a id="lst-transforming-data-weekday-counts-pipeline"></a>

<figure>
<pre><code>Code to add later</code></pre>
<a id="annotated-cell-14"></a>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r code-annotation-code number-lines code-with-copy code-annotated"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Produce counts of robberies each weekday</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="dv">1</span>q1_weekday_counts <span class="ot">&lt;-</span> san_fran_rob <span class="sc">|&gt;</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">filter</span>(</span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="dv">2</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>    <span class="fu">as_date</span>(date_time) <span class="sc">&gt;=</span> <span class="fu">ymd</span>(<span class="st">&quot;2019-01-01&quot;</span>),</span>
<span id="cb2-6"><a href="#cb2-6"></a>    <span class="fu">as_date</span>(date_time) <span class="sc">&lt;=</span> <span class="fu">ymd</span>(<span class="st">&quot;2019-03-31&quot;</span>)</span>
<span id="cb2-7"><a href="#cb2-7"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-8"><a href="#cb2-8"></a><span class="dv">3</span>  <span class="fu">mutate</span>(<span class="at">weekday =</span> <span class="fu">wday</span>(date_time, <span class="at">label =</span> <span class="cn">TRUE</span>)) <span class="sc">|&gt;</span></span>
<span id="cb2-9"><a href="#cb2-9"></a><span class="dv">4</span>  <span class="fu">count</span>(weekday)</span></code></pre></div>
<figcaption>Code 4.14</figcaption>
</figure>

1
: Take the `san_fran_rob` dataset, *and then*

2
: filter the rows to keep only those that occurred in the first quarter of 2019, *and then*

3
: create a new column called `weekday` that contains the day of the week on which each robbery occurred, *and then*

4
: count how many robberies occurred on each weekday.

You might not find the pipe operator completely intuitive at the moment, but it will become easier as you see more examples in future chapters.

TipWhat about the `%>%` pipe operator?

<a id="callout-7"></a>

If you have learned any R coding before, you might have learned to use the `%>%` pipe operator from the magrittr package. The `%>%` pipe operator was introduced several years ago to allow people to construct pipelines of code in R. The `%>%` operator was so widely used that the team that writes the R programming language decided to provide the `|>` pipe operator in R itself, to avoid the need to load the magrittr package. You might sometimes see the `|>` referred to as the *native* pipe operator.

You will still see the `%>%` pipe operator used in lots of R code examples online, and in code produced by AI tools that were trained on old data. In many straightforward pipelines, `%>%` can be replaced with the R pipe operator `|>`, since they work in similar ways. There are some differences between them, so do not assume every advanced example can be converted without changes.

QuizConstructing pipelines

**What does the pipe operator `|>` do?**

- It saves each intermediate result as a separate file.
- It passes the result of one step to the next function. (Correct answer)
- It automatically corrects errors in each function.
- It changes temporary Console code into permanent code.

<a id="sec-complete-wrangling-scripts"></a>
<a id="complete-scripts"></a>

## 4.7 Complete scripts

QuizComplete the scripts

In [Chapter 3](../03_data_wrangling/index.llms.md) you created `chapter_03a.R` and `chapter_03b.R`, which contain the code needed to download and load the two datasets used in this chapter. We will now make copies of those scripts and add the code needed to transform, summarise and save the data.

First check that `chapter_03a.R` and `chapter_03b.R` are in the `R` folder and that the files downloaded in [Chapter 3](../03_data_wrangling/index.llms.md) are in `data/raw`. Then make a copy of each script using the **Explorer** panel in Positron:

1.  If you cannot see the contents of the `R` folder, click the arrow beside the folder name to expand it.
2.  Right-click `chapter_03a.R` and choose **Copy**.
3.  Right-click the `R` folder and choose **Paste**. A copy of the script will appear in the folder.
4.  Right-click the copied file, choose **Rename**, type `chapter_04a.R` and press on your keyboard.
5.  Repeat these steps for `chapter_03b.R`, naming the copy `chapter_04b.R`.

Take care to copy the files rather than renaming the originals. When you have finished, the `R` folder should contain all four scripts: `chapter_03a.R`, `chapter_03b.R`, `chapter_04a.R` and `chapter_04b.R`.

Now amend `chapter_04a.R` by adding the pipeline from [Section 4.6](#sec-pipe-operator) that creates `q1_weekday_counts`. Then use the information in [Section 4.5](#sec-saving-data) to add the code needed to save those weekday counts in a new file called `q1_weekday_counts.csv` in the `processed` sub-folder within the `data` folder.

Once you have tried this yourself, click the 'Solution' button to compare your complete script with the model answer.

<a id="lst-transforming-data-script-04a-solution"></a>

<figure>
<pre><code>chapter_04a.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Load packages</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, httr2, readxl, tidyverse)</span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Download the data from a URL and store it in a local file</span></span>
<span id="cb2-5"><a href="#cb2-5"></a><span class="fu">request</span>(</span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/san_francisco_robbery.csv&quot;</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;san_francisco_robbery.csv&quot;</span>))</span>
<span id="cb2-9"><a href="#cb2-9"></a></span>
<span id="cb2-10"><a href="#cb2-10"></a><span class="co"># Load the local file into R</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>san_fran_rob <span class="ot">&lt;-</span> <span class="fu">read_csv</span>(<span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;san_francisco_robbery.csv&quot;</span>))</span>
<span id="cb2-12"><a href="#cb2-12"></a></span>
<span id="cb2-13"><a href="#cb2-13"></a><span class="co"># Produce counts of robberies each weekday</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>q1_weekday_counts <span class="ot">&lt;-</span> san_fran_rob <span class="sc">|&gt;</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  <span class="fu">filter</span>(</span>
<span id="cb2-16"><a href="#cb2-16"></a>    <span class="fu">as_date</span>(date_time) <span class="sc">&gt;=</span> <span class="fu">ymd</span>(<span class="st">&quot;2019-01-01&quot;</span>),</span>
<span id="cb2-17"><a href="#cb2-17"></a>    <span class="fu">as_date</span>(date_time) <span class="sc">&lt;=</span> <span class="fu">ymd</span>(<span class="st">&quot;2019-03-31&quot;</span>)</span>
<span id="cb2-18"><a href="#cb2-18"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>  <span class="fu">mutate</span>(<span class="at">weekday =</span> <span class="fu">wday</span>(date_time, <span class="at">label =</span> <span class="cn">TRUE</span>)) <span class="sc">|&gt;</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  <span class="fu">count</span>(weekday)</span>
<span id="cb2-21"><a href="#cb2-21"></a></span>
<span id="cb2-22"><a href="#cb2-22"></a><span class="co"># Save the processed data without changing the original file</span></span>
<span id="cb2-23"><a href="#cb2-23"></a><span class="fu">write_csv</span>(</span>
<span id="cb2-24"><a href="#cb2-24"></a>  q1_weekday_counts,</span>
<span id="cb2-25"><a href="#cb2-25"></a>  <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;processed&quot;</span>, <span class="st">&quot;q1_weekday_counts.csv&quot;</span>)</span>
<span id="cb2-26"><a href="#cb2-26"></a>)</span></code></pre></div>
<figcaption>Code 4.15</figcaption>
</figure>

------------------------------------------------------------------------

Now complete `chapter_04b.R` by:

1.  adding a pipeline that counts aggravated assaults by location category and weekday, then
2.  adding the code needed to save the result in a new file called `aggravated_assault_counts.csv`, stored in the relevant folder.

Try to complete the script before clicking the 'Solution' button.

<a id="lst-transforming-data-script-04b-solution"></a>

<figure>
<pre><code>chapter_04b.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Load packages</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, httr2, readxl, tidyverse)</span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Download the data from a URL and store it in a local file</span></span>
<span id="cb2-5"><a href="#cb2-5"></a><span class="fu">request</span>(</span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/aggravated_assaults.xlsx&quot;</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;aggravated_assaults.xlsx&quot;</span>))</span>
<span id="cb2-9"><a href="#cb2-9"></a></span>
<span id="cb2-10"><a href="#cb2-10"></a><span class="co"># Load the Austin data from the Excel workbook</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>agg_assault_data <span class="ot">&lt;-</span> <span class="fu">read_excel</span>(</span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;aggravated_assaults.xlsx&quot;</span>),</span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="at">sheet =</span> <span class="st">&quot;Austin&quot;</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>)</span>
<span id="cb2-15"><a href="#cb2-15"></a></span>
<span id="cb2-16"><a href="#cb2-16"></a><span class="co"># Count aggravated assaults by location category and weekday</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>agg_assault_counts <span class="ot">&lt;-</span> agg_assault_data <span class="sc">|&gt;</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="fu">filter</span>(<span class="sc">!</span><span class="fu">is.na</span>(location_category), <span class="sc">!</span><span class="fu">is.na</span>(date)) <span class="sc">|&gt;</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>  <span class="fu">mutate</span>(</span>
<span id="cb2-20"><a href="#cb2-20"></a>    <span class="at">date =</span> <span class="fu">as_date</span>(date),</span>
<span id="cb2-21"><a href="#cb2-21"></a>    <span class="at">weekday =</span> <span class="fu">wday</span>(date, <span class="at">label =</span> <span class="cn">TRUE</span>)</span>
<span id="cb2-22"><a href="#cb2-22"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>  <span class="fu">count</span>(location_category, weekday) <span class="sc">|&gt;</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  <span class="fu">arrange</span>(location_category, weekday)</span>
<span id="cb2-25"><a href="#cb2-25"></a></span>
<span id="cb2-26"><a href="#cb2-26"></a><span class="co"># Save the processed data without changing the original file</span></span>
<span id="cb2-27"><a href="#cb2-27"></a><span class="fu">write_csv</span>(</span>
<span id="cb2-28"><a href="#cb2-28"></a>  agg_assault_counts,</span>
<span id="cb2-29"><a href="#cb2-29"></a>  <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;processed&quot;</span>, <span class="st">&quot;aggravated_assault_counts.csv&quot;</span>)</span>
<span id="cb2-30"><a href="#cb2-30"></a>)</span></code></pre></div>
<figcaption>Code 4.16</figcaption>
</figure>

Save both scripts by pressing .

Check `chapter_04a.R` and `chapter_04b.R` separately, following these steps for each script:

To check that the analysis is reproducible, restart R using the **Restart R** (**⟳**) button in Positron's **Console** panel, then run the script from beginning to end.

NoteKeep these files

Keep `chapter_04a.R` and `chapter_04b.R` in the `R` folder. Also keep the downloaded files in the `data/raw` folder and the two CSV files in the `data/processed` folder. The raw files should remain unchanged: if you want to alter the data, change the R code and create a new processed file.

<a id="in-summary"></a>

## 4.8 In summary

In this chapter we practised how to:

- create and transform columns;
- summarise, count and arrange rows;
- combine several operations using the pipe operator; and
- save derived data in `data/processed` while preserving the original files.

Developing your data wrangling skills will help you to produce better, faster analysis of crime (and other) data. If you would like to develop your skills further, you might be interested in:

- [Data Wrangling with R](https://cengel.github.io/R-data-wrangling/) by Claudia Engel, a free online book that explains the functions introduced in this tutorial (and some others) in more detail.
- [Data transformation with dplyr cheat sheet](https://opensource.posit.co/resources/cheatsheets/data-transformation/data-transformation.pdf) by Posit, which provides a handy two-page guide to the main functions in the `dplyr` package, which is very useful for reminding you of the code needed to run each of the functions we have used in this tutorial.
- [R for Data Science (second edition)](https://r4ds.hadley.nz/) by Hadley Wickham, Mine Çetinkaya-Rundel and Garrett Grolemund, a widely used free introduction to data analysis with R.

QuizRevision questions

Answer these questions to check you have understood the main points covered in this chapter. Write between 50 and 100 words to answer each question.

1.  How does `mutate()` differ from `summarise()`?
2.  How can grouping variables change the result produced by `summarise()` or `count()`?
3.  What does `arrange()` do, and how can you reverse the order?
4.  Why should processed data be saved separately from raw data?
5.  What are the benefits of using the pipe (`|>`) operator in R?

[Artwork by Allison Horst](https://allisonhorst.com/)
