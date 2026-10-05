Source: https://books.lesscrime.info/learncrimemapping/2026/03_data_wrangling/index.html

<a id="quarto-document-content"></a>
<a id="title-block-header"></a>
<a id="loading-and-selecting-data"></a>

# `<a id="sec-wrangling-data"></a>`{=html}3  Loading and selecting data

Figure: Students select a column and highlighted rows from a data table.

This chapter introduces the first essential skills of data wrangling: loading data into R and choosing the rows and columns needed for an analysis. We will learn how functions and packages work, how to read CSV and Excel files, how to give objects meaningful names and how to use the dplyr package to select and filter data.

TipBefore you start

1.  Open Positron or -- if you already have Positron open -- start a new R session by clicking the **Restart R** (**⟳**) button in the **Console** panel. This makes sure no code you ran previously will interfere with the work you do in this chapter.
2.  Make sure you are working in the crime mapping project workspace you created in [Section 1.5](../01_getting_started/index.llms.md#sec-create-project). In the top-right corner of the Positron window, you should see a folder icon and the words `crime_mapping`. If not, click the **File** menu, then **Open Folder ...** and choose the `crime_mapping` folder.

<a id="introduction"></a>

## 3.1 Introduction

**From [Chapter 3](#sec-wrangling-data) to [Chapter 7](../07_map_context/index.llms.md), we will learn all the skills needed to make a good crime map in R.** We will learn to:

- load data from a variety of sources, select columns and filter rows (this chapter);
- create new columns in datasets, change existing columns and summarise groups of rows ([Chapter 4](../04_transforming_data/index.llms.md));
- convert data to objects that can be used for mapping and use those objects to make a map ([Chapter 5](../05_your_second_crime_map/index.llms.md));
- estimate the density of crime in different places and show that on a map ([Chapter 6](../06_mapping_crime_patterns/index.llms.md)); and
- add context to a map using titles, legends, scale bars and north arrows ([Chapter 7](../07_map_context/index.llms.md)).

A major step in using any data to make decisions or draw conclusions is *data wrangling*: the process of transforming data from the format in which we originally have it to the format needed to analyse and present it to our audience.

Figure: Cartoon conveyor belt carries tables through stages labelled wrangle, visualise and model, ending with a booklet labelled complete analysis. The visualisation stage loops back to wrangling, illustrating that preparing and exploring data can be an iterative process.

In this chapter, we will learn how to:

- download CSV and Excel files into a workspace;
- load and inspect tabular data;
- give R objects meaningful names; and
- select columns and filter rows.

The work in this chapter follows four main stages:

Download data

into the `data/raw` folder

Load data

from a file into an R object

Select columns

to keep the variables we need

Filter rows

to keep the observations we need

To get started, create the first of two scripts used in this chapter:

1.  Click the **File** menu in Positron, then click **New File ...**.
2.  Type `chapter_03a.R` in the box marked **Select File Type or Enter File Name...**, then press ReturnReturn.
3.  Save the file in the `R` folder inside your `crime_mapping` workspace.

As we learned in [Chapter 2](../02_your_first_crime_map/index.llms.md), permanent code needed to repeat the analysis belongs in this script. Temporary code that helps you inspect the data or develop the permanent code belongs in the R Console. Code chunks in this chapter are labelled to show where each piece of code belongs.

<a id="sec-data-wrangling-functions"></a>
<a id="functions"></a>

### 3.1.1 Functions

In this chapter we will learn how to wrangle data in R using *functions* -- specialised pieces of code that *do* something to the data we give them. The code to use a function (sometimes called *calling* the function) has two parts: the function name followed by a pair of parentheses, inside which are zero or more *arguments* separated by commas. Arguments are a way of providing input that a function works on, or to fine-tune the way the function works (we will see many examples of this later). Remember that you can identify a function in R because the name will always have parentheses after it.

One basic R function is `sqrt()`, which calculates the square root of a number. The `sqrt()` function has only one argument: the number that we want to find the square root of. If we typed [Code 3.1](#lst-data-wrangling-calculate-square-root) into the R Console, R would show us the square root of 2.

<a id="lst-data-wrangling-calculate-square-root"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">sqrt</span>(<span class="dv">2</span>)</span></code></pre></div>
<figcaption>Code 3.1</figcaption>
</figure>

When you run code in R, by default R prints the output of your code -- in this case, just the number `1.414214` (for now, you can ignore the number `[1]` in square brackets).

<a id="sec-data-wrangling-packages"></a>
<a id="packages"></a>

### 3.1.2 Packages

R contains thousands of different functions that do different things. A few functions are contained in the default installation of R that you have already installed (this is sometimes referred to as *base R*). But most functions are contained in *packages*, which are extensions to base R. Most packages focus on a particular type of data analysis, so that there are packages devoted to time-series analysis, testing whether events are clustered in particular places, network analysis and thousands of other tasks. Packages are often developed by experts in the field, and are typically updated to introduce new features.

To use a function from a package we need to do two things: *install* that package on our computer, and then *load* the package into our R session. You may see code that does these two steps separately, using the `install.packages()` function to install a package and the `library()` function to load it. However, in this book we use the `p_load()` function from the [pacman package](https://trinker.github.io/pacman_dev/) to do both steps in one line of code. `p_load()` checks whether a package is already installed on your computer, and if it is not, installs it automatically and then loads it. Do not add `install.packages()` to your scripts. Re-installing packages every time a script runs is unnecessary, slows the script down and can make it harder for someone else to run your code on their computer.

In this chapter we will use functions from the here, httr2, readxl and tidyverse packages, so add this code to `chapter_03a.R`:

<a id="lst-data-wrangling-script-03a-packages"></a>

<figure>
<pre><code>chapter_03a.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Load packages</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, httr2, readxl, tidyverse)</span></code></pre></div>
<figcaption>Code 3.2</figcaption>
</figure>

Now run this code by clicking anywhere on that line of code then pressing on your keyboard.

TipWhy does this line of code start with `pacman::`?

<a id="callout-2"></a>

The pacman package is an R package that is used to manage other R packages. The `p_load()` function from that package is used to load packages. But we learned above that we must load a package before we can use it, which means we cannot use functions from the pacman package until we have loaded the pacman package. To get around that, instead of just using the function name `p_load()`, we can instead specify which package `p_load()` is from by prefixing the function name with the relevant package name, separated by `::`.

[](https://tidyverse.org/)

Many packages are focused on specialist tasks and so are only used occasionally, but a few packages are likely to be useful in almost all the code we write. Fortunately, packages can themselves load other packages, and all the main packages we need are loaded by the [tidyverse package](https://tidyverse.org/). That is why you will often see `pacman::p_load(tidyverse)` at the top of R code in subsequent chapters -- that short line of code loads several packages containing hundreds of functions that we can use in data analysis.

QuizData wrangling

**What is the purpose of data wrangling?**

- The process of collecting data from multiple sources.
- The process of transforming raw data into a format suitable for analysis. (Correct answer)
- The process of visualising data on a map.
- The process of cleaning corrupted data files.

**In general, what is a *function* in R?**

- A visual representation of data.
- A mathematical formula used in graphs.
- A set of instructions for saving data.
- A specialised piece of code that performs a task on data. (Correct answer)

<a id="sec-read-data"></a>
<a id="loading-data"></a>

## 3.2 Loading data

Before we can do anything with any data, we have to load it into R. In this course we will read tabular data in comma-separated values (CSV) and Excel formats, as well as spatial data in different formats (because there are lots of ways to store spatial data). We will learn how to read CSV and Excel data now, but leave loading spatial data until later.

*Tabular data* (sometimes known as *rectangular data*) describes data formats with multiple columns where every column has the same number of rows. For example, crime data might have columns for the type of crime, date and address at which the crime occurred.

  type                       date          address
  -------------------------- ------------- ----------------
  homicide                   13 Oct 2025   274 Main St
  non-residential burglary   23 May 2026   541 Station Rd
  personal robbery           25 Sep 2026   10 North Av

  : Crime data in rectangular format

Almost all the data we will use in this course will be in this rectangular format, and most of the functions we will use expect data to be rectangular.

<a id="sec-data-wrangling-loading-csv-data"></a>
<a id="loading-csv-data"></a>

### 3.2.1 Loading CSV data

[](https://readr.tidyverse.org/)

Data stored in CSV format is easy to load with the `read_csv()` function from the [readr package](https://readr.tidyverse.org). readr is one of the packages loaded by the tidyverse package, so all we need to do to use this package is include the code `pacman::p_load(tidyverse)` on the first line of our R script. We will use comments (lines of code beginning with `#`) to help explain the code as we go.

During this course, much of the data we use will come from the [crimemappingdata website](https://pkgs.lesscrime.info/crimemappingdata/). We will first download each original file to the `data/raw` folder and then load that local copy into R. Keeping a copy of the original data means that our analysis does not depend on repeatedly accessing a website, and that we can always return to the unchanged source file.

Add this code to the `chapter_03a.R` file and run it.

<a id="lst-data-wrangling-script-03a-download"></a>

<figure>
<pre><code>chapter_03a.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Download the data from a URL and store it in a local file</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="fu">request</span>(</span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/san_francisco_robbery.csv&quot;</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;san_francisco_robbery.csv&quot;</span>))</span></code></pre></div>
<figcaption>Code 3.3</figcaption>
</figure>

    <httr2_response>
    GET https://mpjashby.github.io/crimemappingdata/san_francisco_robbery.csv
    Status: 200 OK
    Content-Type: text/csv
    Body: On disk '/Users/mattashby/Documents/Crime Mapping Book/data/raw/san_francisco_robbery.csv' (65580 bytes)

The `request()` and `req_perform()` functions from the httr2 (pronounced 'hit-r two') package download the file, following the same pattern used in [Section 2.3.2](../02_your_first_crime_map/index.llms.md#sec-load-data). The `here()` function from the here package helps you specify where on your computer you want to store or retrieve a file inside the `crime_mapping` folder we created in [Section 1.5](../01_getting_started/index.llms.md#sec-create-project). In this case, `here()` specifies that the file should be stored in a file called `san_francisco_robbery.csv` inside the `raw` folder that is itself inside the `data` folder.

Now we've downloaded the data, we need to load it into R. Add this code to the script file and run it:

<a id="lst-data-wrangling-script-03a-load"></a>

<figure>
<pre><code>chapter_03a.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Load the local file into R</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>san_fran_rob <span class="ot">&lt;-</span> <span class="fu">read_csv</span>(<span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;san_francisco_robbery.csv&quot;</span>))</span></code></pre></div>
<figcaption>Code 3.4</figcaption>
</figure>

    Rows: 951 Columns: 5
    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: ","
    chr  (1): offense_type
    dbl  (3): uid, longitude, latitude
    dttm (1): date_time

    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

TipWhat do the messages produced by `read_csv()` mean?

<a id="callout-4"></a>

By default, the `read_csv()` function prints a message when it loads data to summarise the format of each data column. In the case of the `san_fran_rob` dataset, `read_csv()` tells us that:

- there is one column called `offense_type` that contains character (`chr`) values,
- there are three columns called `uid`, `longitude` and `latitude` containing numeric (`dbl`) values, and
- there is one column called `date_time` that contains values stored as dates and times (`dttm`).

There are some other possible types of data, but we will learn about these later on. The numeric values are referred to as `dbl` values because they are stored in a format that can handle numbers that are not whole numbers (e.g. 123.456). This format for storing numbers is called the *double-precision floating-point format*, which is often known as the double format for short. Most numbers in R are stored in double format, so you can think of the format code `dbl` as meaning 'numeric'. You don't need to remember that 'double' is short for double-precision floating-point format, just that it represents a number.

This code loads the data using the `read_csv()` function and stores the result in an object named `san_fran_rob`. Objects are places where we can store data. To create an object and store our data in it, we use the assignment operator `<-` (a less-than sign followed by a dash). Rather than typing a less-than sign and a dash every time you need to assign a value to an object, you can instead use the keyboard shortcut to type an assignment operator.

<a id="sec-naming-objects"></a>
<a id="naming-objects"></a>

### 3.2.2 Naming objects

Object names should briefly describe what an object contains. For example, `san_fran_rob` is more informative than a generic name such as `data`. Meaningful names make a script easier to understand and reduce the chance that you will accidentally use the wrong object. Using the wrong object is a common cause of errors in code, and those errors can be surprisingly hard to track down and fix, so it's best to avoid them by giving objects meaningful names in the first place.

Another way to make object names easier to work with is to only use names containing lowercase letters, numbers and underscores. Object names that follow these rules are said to be written in *snake_case*. Giving all your objects names in `snake_case` means you never have to remember whether you used upper or lower-case letters in an object name, and makes it easier to read object names containing multiple words. This is particularly important because R distinguishes between upper- and lower-case letters, so `crime_data`, `Crime_Data` and `CRIME_DATA` would be three different objects. Using lower-case snake case consistently means that you do not have to remember which variation you chose.

<figure>
<p>Figure: A cartoon comparing naming conventions: snake_case separates lowercase words with underscores, kebab-case uses dashes, and camelCase capitalises each word after the first. It also shows upper-case variants of snake case and camel case.</p>
</figure>

This rule applies even when one of the words in an object name normally uses upper-case letters, such as a name or an abbreviation. For example, you should call an object containing data on homicides in Abu Dhabi something like `abu_dhabi_homicides`, **not** `Abu_Dhabi_Homicides` or `AbuDhabiHomicides`. Similarly, if you had a dataset of offences of grievous bodily harm (usually abbreviated to GBH), you should call the object `gbh_data`, **not** `GBH_data` or `GBHData`.

``` {.sourceCode .numberSource .r .number-lines .code-with-copy}
# Good object names
san_fran_rob
aggravated_assault_data

# Avoid these names
Data
sanFranRob
san-fran-rob
data
```

These conventions also apply to column names. Data obtained from elsewhere will not always follow them, but we can use the `janitor::clean_names()` function to convert column names to snake case. We will use that function in [Chapter 5](../05_your_second_crime_map/index.llms.md).

QuizNaming objects

**Which is the best name for an object containing data on homicides in Abu Dhabi?**

- abu-dhabi-homicides
- Abu_Dhabi_homicides
- data
- abu_dhabi_homicides (Correct answer)

ImportantObject names can be overwritten

When choosing object names, it is important to remember that if you assign a value (such as the number `1` or the result of the function `read_csv()`) to an object name, R will overwrite any existing value of that object name. We can see this in a simple example:

<a id="lst-data-wrangling-replace-object-value"></a>

<figure>
<div class="sourceCode" id="cb1"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb1-1"><a href="#cb1-1"></a>one_to_ten <span class="ot">&lt;-</span> <span class="dv">1</span><span class="sc">:</span><span class="dv">10</span></span>
<span id="cb1-2"><a href="#cb1-2"></a>one_to_ten <span class="ot">&lt;-</span> <span class="fu">sqrt</span>(<span class="dv">2</span>)</span></code></pre></div>
<figcaption>Code 3.5</figcaption>
</figure>

If we were to run this code, the object `one_to_ten` would not actually hold the numbers from one to ten, but instead the value 1.414214 (the square root of two). There is no way to undo assignment of a value to an object, so once you have run the code `one_to_ten <- sqrt(2)` it is not possible to recover any previous value that was assigned to the object `one_to_ten`. For that reason, it is generally a bad idea to reuse object names to store different values in the same script.

Objects come in several different types, with tabular data typically being stored as a *data frame*. The `read_csv()` function produces a modern variation on the data frame called a *tibble*. Tibbles behave like data frames most of the time, but are designed to work conveniently with tidyverse functions. We will use tibbles throughout this course.

If the data are loaded successfully, R will list the columns in the data and the type of variable (numeric, date etc.) stored in each column.

To see the first few rows of data currently stored in an object, we can use the `head()` function. Remember that we run functions such as `head()` in the R Console, not in the script file, because it is temporary code (see [Section 2.2](../02_your_first_crime_map/index.llms.md#sec-permanent-code)). Add this code to the R Console and run it by pressing :

<a id="lst-data-wrangling-head-san-fran-rob"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">head</span>(san_fran_rob)</span></code></pre></div>
<figcaption>Code 3.6</figcaption>
</figure>

    # A tibble: 6 × 5
           uid offense_type     date_time           longitude latitude
         <dbl> <chr>            <dttm>                  <dbl>    <dbl>
    1 24103841 personal robbery 2019-01-01 19:50:00     -122.     37.8
    2 24103948 personal robbery 2019-01-02 08:00:00     -122.     37.8
    3 24104162 personal robbery 2019-01-03 00:30:00     -122.     37.8
    4 24104203 personal robbery 2019-01-03 03:13:00     -122.     37.8
    5 24104237 personal robbery 2019-01-03 09:30:00     -122.     37.7
    6 24104238 personal robbery 2019-01-03 09:30:00     -122.     37.7

<a id="sec-data-wrangling-loading-excel-data"></a>
<a id="loading-excel-data"></a>

### 3.2.3 Loading Excel data

[](https://readxl.tidyverse.org/)

Loading data from Microsoft Excel files is very similar to loading CSV data, with a few important differences. Functions to load Excel data are contained in the `readxl` package.

Create a second R script by repeating the Positron steps you used earlier. Name the file `chapter_03b.R` and save it in the `R` folder. Add [Code 3.7](#lst-data-wrangling-script-03b-download), then place the cursor on each statement and press to run it.

<a id="lst-data-wrangling-script-03b-download"></a>

<figure>
<pre><code>chapter_03b.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Load packages</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, httr2, readxl, tidyverse)</span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Download the data from a URL and store it in a local file</span></span>
<span id="cb2-5"><a href="#cb2-5"></a><span class="fu">request</span>(</span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/aggravated_assaults.xlsx&quot;</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;aggravated_assaults.xlsx&quot;</span>))</span></code></pre></div>
<figcaption>Code 3.7</figcaption>
</figure>

    <httr2_response>
    GET https://mpjashby.github.io/crimemappingdata/aggravated_assaults.xlsx
    Status: 200 OK
    Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
    Body: On disk '/Users/mattashby/Documents/Crime Mapping Book/data/raw/aggravated_assaults.xlsx' (383278 bytes)

Now we have downloaded our data, we can load it into R. Excel files can contain multiple *sheets*, so we need to specify which sheet we would like to load into a tibble. We can use the `excel_sheets()` function in the R Console to get a list of sheets in an Excel file:

<a id="lst-data-wrangling-list-excel-sheets"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Get a list of sheets in an Excel file</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="fu">excel_sheets</span>(<span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;aggravated_assaults.xlsx&quot;</span>))</span></code></pre></div>
<figcaption>Code 3.8</figcaption>
</figure>

    [1] "Austin"     "Fort Worth" "Seattle"   

We can now load the sheet containing data for Austin and view the first few rows of the resulting object:

<a id="lst-data-wrangling-script-03b-load"></a>

<figure>
<pre><code>chapter_03b.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Load the Austin data from the Excel workbook</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>agg_assault_data <span class="ot">&lt;-</span> <span class="fu">read_excel</span>(</span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;aggravated_assaults.xlsx&quot;</span>),</span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="at">sheet =</span> <span class="st">&quot;Austin&quot;</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>)</span></code></pre></div>
<figcaption>Code 3.9</figcaption>
</figure>

and, as usual, we can use the `head()` function to look at the data:

<a id="lst-data-wrangling-head-agg-assault-data"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">head</span>(agg_assault_data)</span></code></pre></div>
<figcaption>Code 3.10</figcaption>
</figure>

    # A tibble: 6 × 5
      date                longitude latitude location_type location_category
      <dttm>                  <dbl>    <dbl> <chr>         <chr>            
    1 2019-01-01 00:00:00     -97.7     30.3 residence     residence        
    2 2019-01-01 00:00:00     -97.8     30.2 residence     residence        
    3 2019-01-01 00:01:00     -97.7     30.3 <NA>          <NA>             
    4 2019-01-01 00:15:00     -97.7     30.3 <NA>          <NA>             
    5 2019-01-01 00:27:00     -97.8     30.2 residence     residence        
    6 2019-01-01 00:30:00     -97.7     30.3 <NA>          <NA>             

Now we have learned how to load our data into an object, we can use other R functions to work with that data in many different ways.

ImportantUse the right function for each file type

Different types of data are loaded into R with different functions, e.g. CSV files are loaded with the `read_csv()` function from the readr package and Microsoft Excel files are loaded with the `read_excel()` function from the readxl package. [Appendix A](../appendices/read_functions.llms.md) has a list of which function to use to load each type of file.

[Learn more about importing data](https://r4ds.hadley.nz/data-import.html) in the current edition of the free online book [R for Data Science](https://r4ds.hadley.nz/).

Excel data can often be messy and the `readxl` package contains various other functions that can be used to deal with this. You can [learn more about how to handle messy Excel data in this online tutorial](https://lesscrime.info/post/cleaning-ons-data/).

QuizReading data

Answer the following questions to check your understanding of what we've learned so far in this chapter. If you get a question wrong, you can keep trying until you get the right answer.

**What R package contains the function `read_csv()` to read CSV data?**

- readxl
- reader
- readr (Correct answer)
- readcsv

**What R code prints the first few rows of the tibble called `san_fran_rob`?**

- message(san_fran_rob)
- summary(san_fran_rob)
- peak_inside(san_fran_rob)
- head(san_fran_rob) (Correct answer)

**If we create an object using the code `number_ten <- 10` and then run the code `number_ten <- sqrt(2)`, what value will the object `number_ten` now have?**

- 10 (the number 10)
- 1.414214 (the square root of 2) (Correct answer)
- 10.41421 (10 plus the square root of 2)
- 14.14214 (10 times the square root of 2)

<a id="selecting-columns"></a>

## 3.3 Selecting columns

In this section we will learn how to reduce the size of our data by selecting only the columns we need and discarding the rest. This can be particularly useful if we are working with a very-large dataset, or if we want to produce a table containing only some columns.

Figure: Cartoon labelled dplyr: go wrangling. A cowboy monster lassos two unruly monsters representing data, illustrating how dplyr helps bring disorganised data under control.

We can use the `select()` function from the [dplyr package](https://dplyr.tidyverse.org/) (one of the packages that is loaded automatically when we call the `pacman::p_load(tidyverse)` function) to select columns.

If we wanted to select just the `date` and `location_type` columns from the `agg_assault_data` we loaded in [Section 3.2.3](#sec-data-wrangling-loading-excel-data), we can use this code:

<a id="lst-data-wrangling-select-assault-date-and-location"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">select</span>(agg_assault_data, date, location_type)</span></code></pre></div>
<figcaption>Code 3.11</figcaption>
</figure>

    # A tibble: 8,696 × 2
       date                location_type
       <dttm>              <chr>        
     1 2019-01-01 00:00:00 residence    
     2 2019-01-01 00:00:00 residence    
     3 2019-01-01 00:01:00 <NA>         
     4 2019-01-01 00:15:00 <NA>         
     5 2019-01-01 00:27:00 residence    
     6 2019-01-01 00:30:00 <NA>         
     7 2019-01-01 00:51:00 <NA>         
     8 2019-01-01 01:00:00 residence    
     9 2019-01-01 01:00:00 <NA>         
    10 2019-01-01 01:12:00 residence    
    # ℹ 8,686 more rows

[](https://dplyr.tidyverse.org/)

In [Section 3.1.1](#sec-data-wrangling-functions), we mentioned that the code needed to run (or *call*) a function in R has two parts: the function name followed by a pair of parentheses, inside which are zero or more *arguments* separated by commas. The arguments in the `select()` function (and many other functions in the `dplyr` package) work in a slightly different way to many other functions. Here, the first argument is the name of the data object that we want to select from. All the remaining arguments (here, `date` and `location_type`) are the names of the columns we want to select from the data.

We can select as many columns as we want, by just adding the names of the columns separated by commas. The columns in our new dataset will appear in the order in which we specify them in the `select()` function.

We can also use `select()` to rename columns at the same time as selecting them. For example, to select the columns `date` and `location_type` while also renaming `location_type` to be called `type`, we can use:

<a id="lst-data-wrangling-select-and-rename-location-type"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">select</span>(agg_assault_data, date, <span class="at">type =</span> location_type)</span></code></pre></div>
<figcaption>Code 3.12</figcaption>
</figure>

    # A tibble: 8,696 × 2
       date                type     
       <dttm>              <chr>    
     1 2019-01-01 00:00:00 residence
     2 2019-01-01 00:00:00 residence
     3 2019-01-01 00:01:00 <NA>     
     4 2019-01-01 00:15:00 <NA>     
     5 2019-01-01 00:27:00 residence
     6 2019-01-01 00:30:00 <NA>     
     7 2019-01-01 00:51:00 <NA>     
     8 2019-01-01 01:00:00 residence
     9 2019-01-01 01:00:00 <NA>     
    10 2019-01-01 01:12:00 residence
    # ℹ 8,686 more rows

`select()` removes any columns that we don't explicitly choose to keep. If we want to rename a column while keeping *all* the existing columns in the data, we can instead use the `rename()` function (also from the dplyr package):

<a id="lst-data-wrangling-rename-location-type"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">rename</span>(agg_assault_data, <span class="at">type =</span> location_type)</span></code></pre></div>
<figcaption>Code 3.13</figcaption>
</figure>

    # A tibble: 8,696 × 5
       date                longitude latitude type      location_category
       <dttm>                  <dbl>    <dbl> <chr>     <chr>            
     1 2019-01-01 00:00:00     -97.7     30.3 residence residence        
     2 2019-01-01 00:00:00     -97.8     30.2 residence residence        
     3 2019-01-01 00:01:00     -97.7     30.3 <NA>      <NA>             
     4 2019-01-01 00:15:00     -97.7     30.3 <NA>      <NA>             
     5 2019-01-01 00:27:00     -97.8     30.2 residence residence        
     6 2019-01-01 00:30:00     -97.7     30.3 <NA>      <NA>             
     7 2019-01-01 00:51:00     -97.7     30.3 <NA>      <NA>             
     8 2019-01-01 01:00:00     -97.7     30.4 residence residence        
     9 2019-01-01 01:00:00     -97.7     30.3 <NA>      <NA>             
    10 2019-01-01 01:12:00     -97.7     30.3 residence residence        
    # ℹ 8,686 more rows

Remember that functions in R generally do not change existing objects, but instead produce (or *return*) new ones. This means if we want to store the result of this function so we can use it later, we have to assign the value returned by the function to a new object (or overwrite the existing object, but this is a bad idea):

<a id="lst-data-wrangling-select-assault-coordinates"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>agg_assault_locations <span class="ot">&lt;-</span> <span class="fu">select</span>(</span>
<span id="cb2-2"><a href="#cb2-2"></a>  agg_assault_data,</span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="at">lon =</span> longitude,</span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="at">lat =</span> latitude</span>
<span id="cb2-5"><a href="#cb2-5"></a>)</span>
<span id="cb2-6"><a href="#cb2-6"></a></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="fu">head</span>(agg_assault_locations)</span></code></pre></div>
<figcaption>Code 3.14</figcaption>
</figure>

    # A tibble: 6 × 2
        lon   lat
      <dbl> <dbl>
    1 -97.7  30.3
    2 -97.8  30.2
    3 -97.7  30.3
    4 -97.7  30.3
    5 -97.8  30.2
    6 -97.7  30.3

You can learn more about selecting, filtering and arranging data using the functions in the `dplyr` package by reading this [Introduction to dplyr tutorial](https://dplyr.tidyverse.org/articles/dplyr.html).

QuizSelecting and renaming columns

**Which `dplyr` function allows you to change the name of columns while keeping all the columns in the original data?**

- rename() (Correct answer)
- select()

**Which `dplyr` function allows you to choose only some columns in the original data?**

- rename()
- select() (Correct answer)

<a id="sec-filter-data"></a>
<a id="filtering-rows"></a>

## 3.4 Filtering rows

Often in crime mapping we will only be interested in part of a particular dataset. In the same way that we can *select* particular *columns* in our data, we can *filter* particular *rows* using the `filter()` function from the dplyr package.

Figure: Cartoon illustrating filter with a table of animal type, food and site. The condition keeps only otters at the bay: the otter--urchin--bay and otter--abalone--bay rows have ticks; a shark at the channel and an otter at the wharf have crosses. Both conditions must be satisfied.

If we were only interested in offences in the `agg_assault_data` dataset that occurred in residences, we could use `filter()`:

<a id="lst-data-wrangling-filter-residential-assaults"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">filter</span>(agg_assault_data, location_type <span class="sc">==</span> <span class="st">&quot;residence&quot;</span>)</span></code></pre></div>
<figcaption>Code 3.15</figcaption>
</figure>

    # A tibble: 4,385 × 5
       date                longitude latitude location_type location_category
       <dttm>                  <dbl>    <dbl> <chr>         <chr>            
     1 2019-01-01 00:00:00     -97.7     30.3 residence     residence        
     2 2019-01-01 00:00:00     -97.8     30.2 residence     residence        
     3 2019-01-01 00:27:00     -97.8     30.2 residence     residence        
     4 2019-01-01 01:00:00     -97.7     30.4 residence     residence        
     5 2019-01-01 01:12:00     -97.7     30.3 residence     residence        
     6 2019-01-01 01:20:00     -97.7     30.4 residence     residence        
     7 2019-01-01 01:50:00     -97.7     30.3 residence     residence        
     8 2019-01-01 02:21:00     -97.8     30.2 residence     residence        
     9 2019-01-01 02:26:00     -97.8     30.2 residence     residence        
    10 2019-01-01 02:35:00     -97.7     30.4 residence     residence        
    # ℹ 4,375 more rows

Note that:

- the column *name* `location_type` is not surrounded by quotes (because it represents a column in the data) but the column *value* `"residence"` is (because it represents the *literal* character value "residence"), and
- the `==` (equal to) operator is used, since a single equals sign `=` has another meaning in R.

We can filter using the values of more than one column simultaneously. To filter offences in which the `location_category` is 'retail' and the `location_type` is 'convenience store':

<a id="lst-data-wrangling-filter-convenience-store-assaults"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">filter</span>(</span>
<span id="cb2-2"><a href="#cb2-2"></a>  agg_assault_data,</span>
<span id="cb2-3"><a href="#cb2-3"></a>  location_category <span class="sc">==</span> <span class="st">&quot;retail&quot;</span>,</span>
<span id="cb2-4"><a href="#cb2-4"></a>  location_type <span class="sc">==</span> <span class="st">&quot;convenience store&quot;</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>)</span></code></pre></div>
<figcaption>Code 3.16</figcaption>
</figure>

    # A tibble: 90 × 5
       date                longitude latitude location_type     location_category
       <dttm>                  <dbl>    <dbl> <chr>             <chr>            
     1 2019-01-06 16:58:00     -97.8     30.5 convenience store retail           
     2 2019-01-08 17:56:00     -97.7     30.3 convenience store retail           
     3 2019-01-10 01:25:00     -97.7     30.4 convenience store retail           
     4 2019-01-12 00:49:00     -97.6     30.4 convenience store retail           
     5 2019-01-12 05:53:00     -97.7     30.4 convenience store retail           
     6 2019-01-12 17:01:00     -97.7     30.4 convenience store retail           
     7 2019-01-12 19:12:00     -97.8     30.3 convenience store retail           
     8 2019-01-12 19:14:00     -97.7     30.4 convenience store retail           
     9 2019-01-13 04:10:00     -97.8     30.2 convenience store retail           
    10 2019-01-22 22:01:00     -97.7     30.3 convenience store retail           
    # ℹ 80 more rows

Important`filter()` returns rows that meet all the criteria you specify

When you run [Code 3.16](#lst-data-wrangling-filter-convenience-store-assaults), the result will contain only those rows in the original data for which the `location_category` column has the value 'retail' *and* the `location_type` column has the value 'convenience store'.

As well as filtering using the `==` (equals) operator, we can filter using the greater-than (`>`), less-than (`<`), greater-than-or-equal-to (`>=`) and less-than-or-equal-to (`<=`) operators. For example, we can choose offences that occurred in residences on or after 1 July 2019:

<a id="lst-data-wrangling-filter-residential-assaults-by-date"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">filter</span>(</span>
<span id="cb2-2"><a href="#cb2-2"></a>  agg_assault_data,</span>
<span id="cb2-3"><a href="#cb2-3"></a>  location_type <span class="sc">==</span> <span class="st">&quot;residence&quot;</span>,</span>
<span id="cb2-4"><a href="#cb2-4"></a>  date <span class="sc">&gt;=</span> <span class="fu">ymd</span>(<span class="st">&quot;2019-07-01&quot;</span>)</span>
<span id="cb2-5"><a href="#cb2-5"></a>)</span></code></pre></div>
<figcaption>Code 3.17</figcaption>
</figure>

    # A tibble: 2,286 × 5
       date                longitude latitude location_type location_category
       <dttm>                  <dbl>    <dbl> <chr>         <chr>            
     1 2019-07-01 02:40:00     -97.8     30.4 residence     residence        
     2 2019-07-01 07:26:00     -97.7     30.3 residence     residence        
     3 2019-07-01 08:25:00     -97.8     30.2 residence     residence        
     4 2019-07-01 09:39:00     -97.7     30.3 residence     residence        
     5 2019-07-01 09:40:00     -97.7     30.4 residence     residence        
     6 2019-07-01 16:24:00     -97.8     30.1 residence     residence        
     7 2019-07-01 17:30:00     -97.8     30.2 residence     residence        
     8 2019-07-01 17:41:00     -97.8     30.2 residence     residence        
     9 2019-07-01 18:03:00     -97.8     30.2 residence     residence        
    10 2019-07-01 18:16:00     -97.8     30.1 residence     residence        
    # ℹ 2,276 more rows

TipWhat does the `ymd()` function do?

<a id="callout-11"></a>

The `ymd()` function from the lubridate package (which we will find out more about below) converts a date stored as a text value to a value that R understands represents a calendar date. The function is called `ymd()` because it processes dates that are stored in year-month-date format. We will learn more about working with dates in [Chapter 15](../15_mapping_time/index.llms.md).

Sometimes we will want to filter rows that are one thing *or* another. We can do this with the `|` (or) operator. For example, we can filter offences that occurred either in leisure facilities *or* shopping malls on or after 1 July 2019:

<a id="lst-data-wrangling-filter-leisure-or-mall-assaults"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">filter</span>(</span>
<span id="cb2-2"><a href="#cb2-2"></a>  agg_assault_data,</span>
<span id="cb2-3"><a href="#cb2-3"></a>  location_category <span class="sc">==</span> <span class="st">&quot;leisure&quot;</span> <span class="sc">|</span> location_type <span class="sc">==</span> <span class="st">&quot;mall&quot;</span>,</span>
<span id="cb2-4"><a href="#cb2-4"></a>  date <span class="sc">&gt;=</span> <span class="fu">ymd</span>(<span class="st">&quot;2019-07-01&quot;</span>)</span>
<span id="cb2-5"><a href="#cb2-5"></a>)</span></code></pre></div>
<figcaption>Code 3.18</figcaption>
</figure>

    # A tibble: 10 × 5
       date                longitude latitude location_type location_category
       <dttm>                  <dbl>    <dbl> <chr>         <chr>            
     1 2019-07-01 09:00:00     -97.7     30.3 entertainment leisure          
     2 2019-07-15 14:06:00     -97.8     30.3 mall          retail           
     3 2019-08-06 23:20:00     -97.7     30.4 mall          retail           
     4 2019-08-18 13:31:00     -97.7     30.3 mall          retail           
     5 2019-08-25 15:35:00     -97.8     30.3 mall          retail           
     6 2019-09-06 15:58:00     -97.7     30.4 mall          retail           
     7 2019-10-05 16:47:00     -97.7     30.2 mall          retail           
     8 2019-11-01 22:23:00     -97.7     30.3 entertainment leisure          
     9 2019-11-18 16:29:00     -97.7     30.4 mall          retail           
    10 2019-11-27 14:14:00     -97.8     30.3 mall          retail           

If we want to filter offences that have any one of several different values *in the same column*, we can use the `%in%` (in) operator. To filter offences that occurred in either streets *or* publicly accessible open spaces:

<a id="lst-data-wrangling-filter-outdoor-assaults"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">filter</span>(agg_assault_data, location_category <span class="sc">%in%</span> <span class="fu">c</span>(<span class="st">&quot;open space&quot;</span>, <span class="st">&quot;street&quot;</span>))</span></code></pre></div>
<figcaption>Code 3.19</figcaption>
</figure>

    # A tibble: 165 × 5
       date                longitude latitude location_type location_category
       <dttm>                  <dbl>    <dbl> <chr>         <chr>            
     1 2019-01-07 21:37:00     -97.8     30.5 green space   open space       
     2 2019-01-08 14:02:00     -97.7     30.3 green space   open space       
     3 2019-01-10 01:59:00     -97.6     30.3 green space   open space       
     4 2019-01-11 17:00:00     -97.7     30.3 green space   open space       
     5 2019-01-12 15:50:00     -97.8     30.2 green space   open space       
     6 2019-01-12 16:00:00     -97.8     30.4 green space   open space       
     7 2019-01-15 07:20:00     -97.7     30.2 green space   open space       
     8 2019-01-17 00:00:00     -97.7     30.4 green space   open space       
     9 2019-01-22 22:00:00     -97.7     30.2 green space   open space       
    10 2019-01-29 01:40:00     -97.7     30.2 green space   open space       
    # ℹ 155 more rows

The code `c("open space", "street")` produces what is referred to in R as a *vector* (sometimes referred to as an *atomic vector*, especially in error messages). A vector is a one-dimensional sequence of values of the same type (i.e. all numbers, all character strings etc.). For example, a vector might hold several strings of text (as in the vector `c("open space", "street")`) or a series of numbers such as `c(1, 2, 3)`. There is lots we could learn about vectors, but for now it's only necessary to know that we can create vectors with the `c()` or *combine* function.

If we wanted to re-use a vector of values several times in our code, it might make sense to store the vector as an object. For example:

<a id="lst-data-wrangling-filter-selected-location-types"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Create vector of location types we are interested in</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>location_types <span class="ot">&lt;-</span> <span class="fu">c</span>(<span class="st">&quot;open space&quot;</span>, <span class="st">&quot;street&quot;</span>)</span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Filter the data</span></span>
<span id="cb2-5"><a href="#cb2-5"></a><span class="fu">filter</span>(agg_assault_data, location_category <span class="sc">%in%</span> location_types)</span></code></pre></div>
<figcaption>Code 3.20</figcaption>
</figure>

    # A tibble: 165 × 5
       date                longitude latitude location_type location_category
       <dttm>                  <dbl>    <dbl> <chr>         <chr>            
     1 2019-01-07 21:37:00     -97.8     30.5 green space   open space       
     2 2019-01-08 14:02:00     -97.7     30.3 green space   open space       
     3 2019-01-10 01:59:00     -97.6     30.3 green space   open space       
     4 2019-01-11 17:00:00     -97.7     30.3 green space   open space       
     5 2019-01-12 15:50:00     -97.8     30.2 green space   open space       
     6 2019-01-12 16:00:00     -97.8     30.4 green space   open space       
     7 2019-01-15 07:20:00     -97.7     30.2 green space   open space       
     8 2019-01-17 00:00:00     -97.7     30.4 green space   open space       
     9 2019-01-22 22:00:00     -97.7     30.2 green space   open space       
    10 2019-01-29 01:40:00     -97.7     30.2 green space   open space       
    # ℹ 155 more rows

Finally, you can filter based on the output of any R function that returns `TRUE` or `FALSE`. For example, missing values are represented in R as `NA`. We can test whether a value is missing using the `is.na()` function. If we wanted to remove rows from our data that had missing location types, we would filter for those rows that are *not* `NA`. We can do this by combining the `is.na()` function with the `!` (not) operator:

<a id="lst-data-wrangling-exclude-missing-location-types"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">filter</span>(agg_assault_data, <span class="sc">!</span><span class="fu">is.na</span>(location_type))</span></code></pre></div>
<figcaption>Code 3.21</figcaption>
</figure>

    # A tibble: 5,344 × 5
       date                longitude latitude location_type location_category
       <dttm>                  <dbl>    <dbl> <chr>         <chr>            
     1 2019-01-01 00:00:00     -97.7     30.3 residence     residence        
     2 2019-01-01 00:00:00     -97.8     30.2 residence     residence        
     3 2019-01-01 00:27:00     -97.8     30.2 residence     residence        
     4 2019-01-01 01:00:00     -97.7     30.4 residence     residence        
     5 2019-01-01 01:12:00     -97.7     30.3 residence     residence        
     6 2019-01-01 01:20:00     -97.7     30.4 residence     residence        
     7 2019-01-01 01:35:00     -97.7     30.3 hotel         hotel            
     8 2019-01-01 01:50:00     -97.7     30.3 residence     residence        
     9 2019-01-01 02:21:00     -97.8     30.2 residence     residence        
    10 2019-01-01 02:26:00     -97.8     30.2 residence     residence        
    # ℹ 5,334 more rows

This might be slightly confusing, but what R is doing in this case is:

1.  identifying whether each row in the `agg_assault_data` dataset has a missing value in the `location_type` column (using the `is.na()` function), returning either `TRUE` (if the value is missing) or `FALSE` (if the value is not missing) for each row, then
2.  reversing the `TRUE` and `FALSE` values (using the `!` operator), so that rows with missing values are now `FALSE` and rows without missing values are now `TRUE`, and finally
3.  returning only those rows for which the result of step 2 is `TRUE` (i.e. those rows that do not have missing values in the `location_type` column).

The overall effect of this code is therefore to remove any rows that have missing values in the `location_type` column.

We will see lots more examples of how to use `filter()` in future chapters.

QuizFiltering rows

**What is a vector (sometimes known as an atomic vector) in R?**

- A type of object that stores a tibble or data frame
- A type of object that stores a one-dimensional sequence of values of the same type (Correct answer)
- A type of object that stores a one-dimensional sequence of values that can be of different types
- There is no such thing as a vector in R

**Which offences (rows) will be returned by the code `filter(agg_assault_data, location_type %in% c("restaurant", "mall"))`?**

- Offences that occurred in both restaurants and in shopping malls (e.g. at restaurants inside shopping malls)
- Offences that occurred anywhere except restaurants or shopping malls (e.g. in homes)
- No offences, because the way the two criteria are combined is illogical
- Offences that occurred either in restaurants or in shopping malls (Correct answer)

**What does the `<=` operator mean?**

- greater than
- less than
- less than or equal to (Correct answer)
- greater than or equal to

<a id="complete-scripts"></a>

## 3.5 Complete scripts

QuizCheck your complete scripts

Before finishing the chapter, check that `chapter_03a.R` contains all the permanent code needed to download and load the San Francisco robbery data. Compare your script with the model answer after checking it yourself.

<a id="lst-data-wrangling-show-chapter-03a-script"></a>

<figure>
<pre><code>chapter_03a.R</code></pre>
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
<span id="cb2-11"><a href="#cb2-11"></a>san_fran_rob <span class="ot">&lt;-</span> <span class="fu">read_csv</span>(<span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;san_francisco_robbery.csv&quot;</span>))</span></code></pre></div>
<figcaption>Code 3.22</figcaption>
</figure>

------------------------------------------------------------------------

Now check that `chapter_03b.R` contains all the permanent code needed to download and load the Austin aggravated-assault data.

<a id="lst-data-wrangling-show-chapter-03b-script"></a>

<figure>
<pre><code>chapter_03b.R</code></pre>
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
<span id="cb2-11"><a href="#cb2-11"></a></span>
<span id="cb2-12"><a href="#cb2-12"></a>agg_assault_data <span class="ot">&lt;-</span> <span class="fu">read_excel</span>(</span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;aggravated_assaults.xlsx&quot;</span>),</span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="at">sheet =</span> <span class="st">&quot;Austin&quot;</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>)</span></code></pre></div>
<figcaption>Code 3.23</figcaption>
</figure>

Save both scripts by pressing .

<a id="in-summary"></a>

## 3.6 In summary

In this chapter we practised how to:

- download original CSV and Excel files into `data/raw`;
- load and inspect tabular data;
- distinguish functions, arguments, packages, objects and tibbles;
- choose meaningful snake-case object names;
- select or rename columns with `select()` and `rename()`; and
- choose rows that meet particular conditions with `filter()`.

Keep `chapter_03a.R` and `chapter_03b.R` in the `R` folder, together with the original downloaded files in `data/raw`. In [Chapter 4](../04_transforming_data/index.llms.md) we will continue working with these datasets to create new columns, produce summaries and save processed data.

QuizRevision questions

1.  What is data wrangling, and why is it usually needed before analysis?
2.  What is the difference between a function, an argument and a package?
3.  Why should R objects have meaningful names written in snake case?
4.  How do `select()` and `filter()` reduce a dataset in different ways?

[Artwork by Allison Horst](https://allisonhorst.com/)
