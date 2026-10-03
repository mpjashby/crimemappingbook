Source: https://books.lesscrime.info/learncrimemapping/15_mapping_time/index.html

<a id="quarto-document-content"></a>
<a id="title-block-header"></a>
<a id="mapping-crime-over-time"></a>

# `<a id="sec-mapping-time"></a>`{=html}15  Mapping crime over time

Figure: Students compare three maps showing changing concentrations over time beside a clock and wave.

Understanding how crime varies over time is essential for effective crime analysis. This chapter introduces techniques for identifying short-term and long-term variations in crime. We will learn how to handle date and time data, visualise temporal changes, and create animated maps to illustrate crime trends dynamically.

TipBefore you start

1.  Open Positron or -- if you already have Positron open -- start a new R session by clicking the **Restart R** (**⟳**) button in the **Console** panel. This makes sure no code you ran previously will interfere with the work you do in this chapter.
2.  Make sure you are working in the crime mapping project workspace you created in [Section 1.5](../01_getting_started/index.llms.md#sec-create-project). In the top-right corner of the Positron window, you should see a folder icon and the words `crime_mapping`. If not, click the **File** menu, then **Open Folder ...** and choose the `crime_mapping` folder.

<a id="introduction"></a>

## 15.1 Introduction

In this chapter, we will learn how to:

- handle dates and times in R;
- choose appropriate temporal units of analysis for crime data;
- calculate and interpret moving averages;
- create time-series and seasonal charts;
- compare spatial crime patterns across time periods; and
- create an animated map showing how a crime pattern changes over time.

Understanding how crime varies over time is just as important as understanding how it varies between places. Very few places are hotspots of crime all the time -- business districts might be hotspots of pickpocketing in the daytime but deserted at night, while a nearby entertainment district may be quiet in the daytime but a violence hotspot at night.

Crime varies over time in lots of ways. For example, there was a long-term drop in many types of crime in many countries starting in the mid 1990s, e.g. [residential burglary in England and Wales dropped by 67% between 1993 and 2008](https://crimesciencejournal.biomedcentral.com/articles/10.1186/s40163-016-0051-z) while the number of [homicides in New York City dropped almost 90% from 2,245 in 1990 to 289 in 2018](https://www.brennancenter.org/our-work/analysis-opinion/takeaways-2019-crime-data-major-american-cities). There are also short-term variations in crime. Many types of crime are more common at some times of year than others (known as *seasonal variation*). In Chicago between 2010 and 2019, for example, assaults, residential burglaries and personal robberies all varied throughout the year, with assaults in particular being consistently higher in summer than winter.

<a id="fig-chicago-seasonal-variation"></a>

<figure>
<p>Figure: Three line-chart panels show average daily assaults, personal robberies and residential burglaries in Chicago by month, with separate lines for 2010 to 2019. All three generally rise towards summer and fall towards winter, although robberies also dip in spring. Burglary and robbery levels differ substantially between years, so the panels have different vertical scales.</p>
<figcaption>Figure 15.1</figcaption>
</figure>

It is also important to understand short-term variation in crime. For example, between 2010 and 2019, both property damage and sexual violence in Chicago peaked at weekends, while there were fewer shoplifting offences on Sundays when some shops were closed or had shorter opening hours.

<a id="fig-chicago-weekly-variation"></a>

<figure>
<p>Figure: Three bar-chart panels compare average daily recorded offences in Chicago by weekday, pooled across 2010 to 2019. Property damage is highest on Saturday and Sunday, and sexual violence rises towards the weekend. Shoplifting is comparatively steady from Monday to Saturday but falls on Sunday. Each panel uses its own vertical scale.</p>
<figcaption>Figure 15.2</figcaption>
</figure>

Understanding variation in crime over time is important because we can use the temporal concentration of crime to focus efforts to respond to crime most effectively. For example, imagine we wanted to deploy police patrols to a hotspot to respond to a particular crime problem. Such patrols could be very effective if they were targeted at the times when crimes were most likely to happen or completely useless if the officers were deployed at the wrong day or the wrong time.

In this chapter we will learn how to incorporate variation over time into our analysis of where crime happens, including making animated maps like this one:

<a id="map-chicago-hourly-assault-animation"></a>

<figure>
<p>Figure: Animated density map of aggravated assaults in downtown Chicago. The animation cycles through 24 hours from midnight onwards. Every frame pools assaults recorded during that hour across 2010 to 2019; it does not show events from a single day. The street map and police-district outlines stay fixed, Lake Michigan remains to the east, and darker blue cells indicate higher estimated density on the same scale. From midnight into the early morning, a strong concentration appears near the eastern edge of the mapped area, north of the daytime concentration. Around six to nine in the morning the surface becomes much paler. During daytime and evening, the eastern concentration strengthens again further south, with additional smaller concentrations to the west and south. These changes show how a map pooling every hour would conceal time-specific patterns. Later static maps in this chapter compare three shifts side by side and outline their highest-density cells.</p>
<figcaption>Map 15.1</figcaption>
</figure>

QuizAnalysing temporal variation in crime

**Is it important to think about variation over time when analysing crime patterns?**

- No, because hotspots of crime are usually hotspots at all times
- Yes, because many crime hotspots are only hotspots some of the time (Correct answer)
- No, because spatial variation in crime is usually much more important than temporal variation
- Yes, because crime prevention depends more on when crime occurs than on where it occurs

**Which of the following statements about seasonal variations in crime is correct?**

- Almost all types of crime are more common in the winter than in the summer
- Almost all types of crime are more common in the summer than in the winter
- Different types of crime are more common at different times of year (Correct answer)
- Most types of crime occur at the same frequency at all times of year

<a id="handling-dates-in-r"></a>

## 15.2 Handling dates in R

Figure: Cartoon labelled lubridate: wrangle times and dates. Monsters in hard hats sort a mixed pile of year, month and day letters into separate piles labelled years, months and days, illustrating how date components can be extracted and organised.

At a very basic level, computers can store data in two ways: they can store numbers and they can store text. This makes storing dates slightly complicated, because dates aren't completely like numbers and they aren't completely like text either. Dates aren't like numbers because you can't do normal maths with dates (e.g. what date is the 29th of January plus one month?) and aren't like text because you can do some maths with them (e.g. it is easy to calculate three days from today). Dates are especially complicated because they can be written as text in so many different ways. For example, 17 January can be represented in all of these ways, all of them equally valid (although some are specific to particular countries):

- 17/01/2026
- 17.01.26
- 1/17/2026
- 2026-01-17
- 17 Jan 26
- 17 January 2026
- January 17th 2026

[](https://lubridate.tidyverse.org/)

R deals with this problem by *storing* dates internally as if they were numbers and *displaying* them (e.g. in the console or in a Quarto document) as if they were text, by default in the format `2026-10-03`. Fortunately, we don't have to worry about how dates and times are stored internally in R because we can use the [lubridate package](https://lubridate.tidyverse.org/) to work with them. lubridate contains functions for working with dates, including extracting parts of a date with functions such as `month()` and converting text to date values with functions like `ymd()`.

Because of the special nature of dates, if we want to work with a date variable (for example to create a chart of crime over time) it is important that it is stored as a date, not as text or as a number. Many R functions for reading data, including `read_csv()`, `read_tsv()` and `read_excel()`, will try to recognise columns of data that contain dates and times stored in common formats. These will automatically be stored as date variables when the data is loaded.

If R does not recognise automatically that a value contains a date, we can convert it to a date by using the date-parsing functions from lubridate. Which function to use depends on the order in which the components of the date (e.g. day, month and year) appear in the variable. For example, to convert the text "17 January 1981" to a date format we can use the `dmy()` function because the **d**ay of the month comes first, the **m**onth next and then the **y**ear. Similarly, converting the text "01/17/81" needs the function `mdy()`. Note that the lubridate date-parsing functions are able to convert both numeric and text-based months, and to ignore elements that aren't needed for the conversion, such as weekday names.

If a date is stored in multiple columns in a dataset, e.g. one column for the year, one column for the month and one column for the day, we can create a single date column using the `make_date()` function to combine them. Similarly, we can create a date-time column using the `make_datetime()` function. For example, imagine we have a dataset of crimes called `thefts`:

<a id="dlxhqoykxi"></a>

  year   month_of_year   day_of_month   hour   minute   x          y
  ------ --------------- -------------- ------ -------- ---------- ---------
  2020   9               1              18     0        491637.5   5459387
  2020   9               5              18     30       492301.0   5458898
  2020   9               9              0      0        491006.8   5458603
  2020   9               11             22     30       490776.5   5458368
  2020   9               11             23     30       491569.2   5458022
  2020   9               13             17     46       491672.8   5458843
  2020   9               14             14     0        491933.5   5459112
  2020   9               16             7      0        493244.5   5453038
  2020   9               18             5      31       490246.8   5458367
  2020   9               22             17     30       491015.9   5459166

We could use the three columns `year`, `month_of_year` and `day_of_month` to create a column containing the full date using the code:

<a id="lst-mapping-time-make-date-example"></a>

<figure>
<pre><code>Hypothetical code</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>thefts <span class="sc">|&gt;</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>  <span class="fu">mutate</span>(</span>
<span id="cb2-3"><a href="#cb2-3"></a>    <span class="at">date =</span> <span class="fu">make_date</span>(<span class="at">year =</span> year, <span class="at">month =</span> month_of_year, <span class="at">day =</span> day_of_month)</span>
<span id="cb2-4"><a href="#cb2-4"></a>  )</span></code></pre></div>
<figcaption>Code 15.1</figcaption>
</figure>

    # A tibble: 1,840 × 8
        year month_of_year day_of_month  hour minute       x        y date      
       <dbl>         <dbl>        <dbl> <dbl>  <dbl>   <dbl>    <dbl> <date>    
     1  2020             9            1     0      0 490778. 5458771. 2020-09-01
     2  2020             9            1     0      0 492552. 5456983. 2020-09-01
     3  2020             9            1     0      0 495975. 5456581. 2020-09-01
     4  2020             9            1     0      0 498185. 5453781. 2020-09-01
     5  2020             9            1     0      0 490318. 5454515. 2020-09-01
     6  2020             9            1     0      0 493661. 5458708. 2020-09-01
     7  2020             9            1     0      0 492757. 5458792. 2020-09-01
     8  2020             9            1     0      0 497944. 5458721. 2020-09-01
     9  2020             9            1     1      0 489018. 5457169. 2020-09-01
    10  2020             9            1     2      8 493537. 5454987. 2020-09-01
    # ℹ 1,830 more rows

Note that the column `date` in this tibble has the type `<date>`, which confirms that R is storing it as a date rather than as text.

Once we have converted dates stored as text to dates stored as dates, R understands that they are dates and we can do things like compare them. So while running `"Sat 17 January 1981" == "01/17/81"` to test if two dates are the same would give the answer `FALSE` (because the two pieces of text are different), once we've converted the text to date values R can tell that the two dates are the same:

<a id="lst-mapping-time-compare-identical-date-text"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This code returns TRUE only because the two pieces of text are identical</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="st">&quot;Sat 17 January 1981&quot;</span> <span class="sc">==</span> <span class="st">&quot;Sat 17 January 1981&quot;</span></span></code></pre></div>
<figcaption>Code 15.2</figcaption>
</figure>

    [1] TRUE

<a id="lst-mapping-time-compare-different-date-text"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This code returns FALSE because the two pieces of text are different, even</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="co"># though the dates they represent are the same</span></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="st">&quot;Sat 17 January 1981&quot;</span> <span class="sc">==</span> <span class="st">&quot;01/17/81&quot;</span></span></code></pre></div>
<figcaption>Code 15.3</figcaption>
</figure>

    [1] FALSE

<a id="lst-mapping-time-compare-parsed-dates"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This code returns TRUE because R knows they are dates and so compares them as</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="co"># dates, finding that the two dates are the same</span></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="fu">dmy</span>(<span class="st">&quot;Sat 17 January 1981&quot;</span>) <span class="sc">==</span> <span class="fu">mdy</span>(<span class="st">&quot;01/17/81&quot;</span>)</span></code></pre></div>
<figcaption>Code 15.4</figcaption>
</figure>

    [1] TRUE

<a id="sec-mapping-time-working-with-dates"></a>
<a id="working-with-dates"></a>

### 15.2.1 Working with dates

When analysing dates and times, it is often useful to be able to extract date or time portions. We can do this with the lubridate functions `year()`, `month()`, `wday()` (for day of the week), `mday()` (for day of the month), `yday()` (for day of the year, counting from 1 January), `hour()`, `minute()` and `second()`, each of which extracts the relevant portion of a date or time as a number. The `month()` and `wday()` functions are slightly different, because they can also return the day or month name as text by specifying the argument `label = TRUE`. We can see this by extracting the different portions of the current date and time, which we can retrieve with the `now()` function from lubridate.

<a id="lst-mapping-time-extract-date-components-code"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">message</span>(<span class="st">&quot;Current year: &quot;</span>, <span class="fu">year</span>(<span class="fu">now</span>()))</span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="fu">message</span>(<span class="st">&quot;Current month (as a number): &quot;</span>, <span class="fu">month</span>(<span class="fu">now</span>()))</span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="fu">message</span>(<span class="st">&quot;Current month (as text, abbreviated): &quot;</span>, <span class="fu">month</span>(<span class="fu">now</span>(), <span class="at">label =</span> <span class="cn">TRUE</span>))</span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="fu">message</span>(<span class="st">&quot;Current month (as text): &quot;</span>, <span class="fu">month</span>(<span class="fu">now</span>(), <span class="at">label =</span> <span class="cn">TRUE</span>, <span class="at">abbr =</span> <span class="cn">FALSE</span>))</span>
<span id="cb2-5"><a href="#cb2-5"></a><span class="fu">message</span>(<span class="st">&quot;Current day of the year (days since 1 Jan): &quot;</span>, <span class="fu">yday</span>(<span class="fu">now</span>()))</span>
<span id="cb2-6"><a href="#cb2-6"></a><span class="fu">message</span>(<span class="st">&quot;Current day of the month: &quot;</span>, <span class="fu">mday</span>(<span class="fu">now</span>()))</span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="fu">message</span>(<span class="st">&quot;Current day of the week (as a number): &quot;</span>, <span class="fu">wday</span>(<span class="fu">now</span>()))</span>
<span id="cb2-8"><a href="#cb2-8"></a><span class="fu">message</span>(<span class="st">&quot;Current day of the week (as text): &quot;</span>, <span class="fu">wday</span>(<span class="fu">now</span>(), <span class="at">label =</span> <span class="cn">TRUE</span>))</span>
<span id="cb2-9"><a href="#cb2-9"></a><span class="fu">message</span>(<span class="st">&quot;Current hour of the day: &quot;</span>, <span class="fu">hour</span>(<span class="fu">now</span>()))</span>
<span id="cb2-10"><a href="#cb2-10"></a><span class="fu">message</span>(<span class="st">&quot;Current minute: &quot;</span>, <span class="fu">minute</span>(<span class="fu">now</span>()))</span>
<span id="cb2-11"><a href="#cb2-11"></a><span class="fu">message</span>(<span class="st">&quot;Current second: &quot;</span>, <span class="fu">second</span>(<span class="fu">now</span>()))</span></code></pre></div>
<figcaption>Code 15.5</figcaption>
</figure>

    Current year: 2026

    Current month (as a number): 10

    Current month (as text, abbreviated): Oct

    Current month (as text): October

    Current day of the year (days since 1 Jan): 276

    Current day of the month: 3

    Current day of the week (as a number): 7

    Current day of the week (as text): Sat

    Current hour of the day: 23

    Current minute: 50

    Current second: 52.1593968868256

It is sometimes useful to be able to add to or subtract from dates. For example, if you wanted to filter a dataset so that only records from the past 28 days were included, you would need to work out the date 28 days ago. We can do this with a group of functions from lubridate that store a period of time that we can then add to or subtract from an existing date. These functions are `years()`, `months()`, `weeks()`, `days()`, `hours()`, `minutes()`, and `seconds()`.

ImportantRemember which lubridate functions extract parts of a date and which manipulate them

In the lubridate package, functions that are used to *extract* parts of a date are *singular*, e.g. `day()`, `month()`, `year()`. Functions that are used to *manipulate* dates by adding or subtracting from them are *plural*, e.g. `days()`, `months()`, `years()`. So, for example, you would use the code `month(now())` to extract the month (as a number between 1 and 12) from the current date but the code `now() + months(1)` to find out what the date and time will be one month from now.

To subtract 28 days from today's date (which we can retrieve with the `today()` function), we would use `today() - days(28)`.

<a id="lst-mapping-time-subtract-days-example"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">message</span>(<span class="fu">str_glue</span>(<span class="st">&quot;Today is {today()} and 28 days ago was {today() - days(28)}&quot;</span>))</span></code></pre></div>
<figcaption>Code 15.6</figcaption>
</figure>

    Today is 2026-10-03 and 28 days ago was 2026-09-05

Adding or subtracting periods from dates can be very useful when combined with the `filter()` function from the dplyr package. For example, if we had a dataset of crimes stored in an object called `crimes` and wanted to extract only those that occurred in the most-recent seven days, we could do this:

<a id="lst-mapping-time-filter-recent-dates-example"></a>

<figure>
<pre><code>Hypothetical code</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">filter</span>(crimes, occur_date <span class="sc">&gt;=</span> <span class="fu">today</span>() <span class="sc">-</span> <span class="fu">days</span>(<span class="dv">7</span>))</span></code></pre></div>
<figcaption>Code 15.7</figcaption>
</figure>

If we wanted to extract crimes that occurred between two dates, we can use the `between()` function from dplyr, which returns either `TRUE` or `FALSE` depending on whether each item in the first argument is between the values given in the second and third arguments (inclusive).

When filtering based on dates or times, it is important to understand that R can store dates in two ways: as a *date* object (shown as `<date>` when we print a tibble in the R Console) or as a *date-time* object (shown as `<dttm>` when we print a tibble). Date variables store only a date with no time, while date-time variables always include a time component, even if the data doesn't contain any information about time. If we store a variable that only has information about the date of an event as a date-time variable, R will silently add the time midnight to each date. This is important because if we compare a date variable to a date-time variable, R will silently convert the dates to date-times with the times set to midnight. If we are trying to filter crimes between two times, this might not be what we want. For example, if we used the code:

<a id="lst-mapping-time-between-dates-risky-example"></a>

<figure>
<pre><code>Hypothetical code</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">between</span>(offence_date, <span class="fu">ymd</span>(<span class="st">&quot;2021-01-01&quot;</span>), <span class="fu">ymd</span>(<span class="st">&quot;2021-01-31&quot;</span>))</span></code></pre></div>
<figcaption>Code 15.8</figcaption>
</figure>

to extract all the crimes that occurred in January 2021, that would work as we expected only if `offence_date` was a date variable. If the `offence_date` column instead held dates *and* times, R would filter the data *as if* we had specified:

<a id="lst-mapping-time-between-datetimes-expanded-example"></a>

<figure>
<pre><code>Hypothetical code</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">between</span>(offence_date, <span class="fu">ymd_hm</span>(<span class="st">&quot;2021-01-01 00:00&quot;</span>), <span class="fu">ymd_hm</span>(<span class="st">&quot;2021-01-31 00:00&quot;</span>))</span></code></pre></div>
<figcaption>Code 15.9</figcaption>
</figure>

which would exclude any crimes that occurred on 31 January (except those occurring at exactly 00:00 hours). To deal with this problem, we can either check to make sure the variables we are filtering on are date variables, convert them to date variables using the `as_date()` function, or assume that they might be date-time variables and specify the exact time that we want as the end of our range. For example, specifying:

<a id="lst-mapping-time-between-datetimes-complete-day-example"></a>

<figure>
<pre><code>Hypothetical code</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">between</span>(offence_date, <span class="fu">ymd_hm</span>(<span class="st">&quot;2021-01-01 00:00&quot;</span>), <span class="fu">ymd_hm</span>(<span class="st">&quot;2021-01-31 23:59&quot;</span>))</span></code></pre></div>
<figcaption>Code 15.10</figcaption>
</figure>

or

<a id="lst-mapping-time-between-converted-dates-example"></a>

<figure>
<pre><code>Hypothetical code</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">between</span>(<span class="fu">as_date</span>(offence_date), <span class="fu">ymd</span>(<span class="st">&quot;2021-01-01&quot;</span>), <span class="fu">ymd</span>(<span class="st">&quot;2021-01-31&quot;</span>))</span></code></pre></div>
<figcaption>Code 15.11</figcaption>
</figure>

would allow us to select all the crimes occurring in January 2021.

QuizHandling dates in R

**What function from the lubridate package would you use to convert "17/01/2025" into a proper date format?**

- mdy(\"17/01/2025\")
- dmy(\"17/01/2025\") (Correct answer)
- ymd(\"17/01/2025\")
- parse_date(\"17/01/2025\")

**How can you extract the month from a date variable in R?**

- extract_month(date)
- get_month(date)
- month(date) (Correct answer)
- date_month(date)

<a id="showing-change-over-time"></a>

## 15.3 Showing change over time

One common task in crime analysis is to show how crime changes over time. The simplest way to do this is to produce a *time-series chart*. For example, we can see how the frequency of aggravated assaults recorded by police in Chicago has changed over time:

<a id="fig-chicago-assault-trend"></a>

<figure>
<p>Figure: Time-series chart of aggravated assaults in Chicago from 2010 to 2019. Grey dots represent weekly counts and a black line represents a four-week moving average. Repeated summer peaks and winter troughs sit within a longer decline towards 2014, followed by a rise; the moving average smooths the week-to-week variation.</p>
<figcaption>Figure 15.3</figcaption>
</figure>

In this section we will learn how to construct a time-series chart like this. To get started, create a new file called `chapter_15a.R` in the `R` folder of your `crime_mapping` workspace. This file will contain code to download and prepare the datasets we will use in this chapter. Now add this code, which downloads the original datasets into `data/raw`, loads the local copies and prepares them for analysis by transforming the data to use an appropriate local coordinate reference system (as we learned in [Section 6.2.1](../06_mapping_crime_patterns/index.llms.md#sec-choosing-projected-crs)) and by filtering the data to contain only the police districts we are interested in.

<a id="lst-mapping-time-prepare-chicago-data-code"></a>

<figure>
<pre><code>chapter_15a.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This script creates charts and maps showing how aggravated assaults in</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="co"># Chicago varied over time between 2010 and 2019</span></span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Load packages</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, httr2, sf, sfhotspot, slider, tidyverse)</span>
<span id="cb2-6"><a href="#cb2-6"></a></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="co"># LOAD DATA --------------------------------------------------------------------</span></span>
<span id="cb2-8"><a href="#cb2-8"></a></span>
<span id="cb2-9"><a href="#cb2-9"></a><span class="co"># Download the original data</span></span>
<span id="cb2-10"><a href="#cb2-10"></a><span class="fu">request</span>(</span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/chicago_aggravated_assaults.csv.gz&quot;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">req_perform</span>(</span>
<span id="cb2-14"><a href="#cb2-14"></a>    <span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;chicago_aggravated_assaults.csv.gz&quot;</span>)</span>
<span id="cb2-15"><a href="#cb2-15"></a>  )</span>
<span id="cb2-16"><a href="#cb2-16"></a></span>
<span id="cb2-17"><a href="#cb2-17"></a><span class="fu">request</span>(</span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/chicago_police_districts.kml&quot;</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;chicago_police_districts.kml&quot;</span>))</span>
<span id="cb2-21"><a href="#cb2-21"></a></span>
<span id="cb2-22"><a href="#cb2-22"></a><span class="co"># Load Chicago aggravated assault data</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>assaults <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;chicago_aggravated_assaults.csv.gz&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  <span class="fu">read_csv</span>(<span class="at">show_col_types =</span> <span class="cn">FALSE</span>)</span>
<span id="cb2-25"><a href="#cb2-25"></a></span>
<span id="cb2-26"><a href="#cb2-26"></a><span class="co"># Load dataset of Chicago Police Department (CPD) district boundaries</span></span>
<span id="cb2-27"><a href="#cb2-27"></a>cpd_districts <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;chicago_police_districts.kml&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-28"><a href="#cb2-28"></a>  <span class="fu">read_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-29"><a href="#cb2-29"></a>  janitor<span class="sc">::</span><span class="fu">clean_names</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-30"><a href="#cb2-30"></a>  <span class="co"># Transform this object to use a suitable local coordinate reference system</span></span>
<span id="cb2-31"><a href="#cb2-31"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:26916&quot;</span>)</span>
<span id="cb2-32"><a href="#cb2-32"></a></span>
<span id="cb2-33"><a href="#cb2-33"></a><span class="co"># Create a separate dataset holding just the boundaries of the three CPD</span></span>
<span id="cb2-34"><a href="#cb2-34"></a><span class="co"># districts covering the downtown area</span></span>
<span id="cb2-35"><a href="#cb2-35"></a>cpd_central <span class="ot">&lt;-</span> <span class="fu">filter</span>(cpd_districts, name <span class="sc">%in%</span> <span class="fu">c</span>(<span class="st">&quot;1&quot;</span>, <span class="st">&quot;12&quot;</span>, <span class="st">&quot;18&quot;</span>))</span></code></pre></div>
<figcaption>Code 15.12</figcaption>
</figure>

    <httr2_response>
    GET https://mpjashby.github.io/crimemappingdata/chicago_aggravated_assaults.csv.gz
    Status: 200 OK
    Content-Type: application/gzip
    Body: On disk '/Users/mattashby/Documents/Crime Mapping Book/data/raw/chicago_aggravated_assaults.csv.gz' (1444320 bytes)

    <httr2_response>
    GET https://mpjashby.github.io/crimemappingdata/chicago_police_districts.kml
    Status: 200 OK
    Content-Type: application/vnd.google-earth.kml+xml
    Body: On disk '/Users/mattashby/Documents/Crime Mapping Book/data/raw/chicago_police_districts.kml' (967244 bytes)

The first task in charting the frequency of crime is to choose a temporal *unit of analysis*. For example, [Figure 15.3](#fig-chicago-assault-trend) counts the number of crimes each *week*. Weeks are often a good choice as units for counting crimes, since all weeks are the same length and because many human activities have a weekly cycle (e.g. people do different things at weekends than on weekdays, even though which days count as weekdays differs across cultures).

ImportantMonths are usually a bad choice of temporal unit of analysis

Months are much less useful than weeks as a temporal unit of analysis because months differ in length, so monthly counts of crime will look like they show some variation even if the amount of crime occurring each day remains constant. For example, if exactly 10 crimes occur every day throughout February and March, there will be 280 or 290 crimes in February (depending on whether it is a leap year) but 310 in March. In these circumstances, it will look like the volume of crime increased by 11% between February and March, not because the rate at which crimes occurred increased but because March is 11% longer than February.

Converting monthly counts to average daily rates deals with differences in the number of days per month, but does not solve every problem. Months contain different numbers of each weekday (e.g. one month might have four Fridays while the next has five), and crimes are typically concentrated on particular days of the week (more on that later). **Avoid using months as the temporal unit of analysis** unless there is a clear reason to use them, such as only having data available as monthly counts.

To count the number of crimes occurring each week we can use the `count()` function from the dplyr package. But before doing that, we have to allocate each crime to a week so that we can then count those weeks rather than counting days. To do this we use the `floor_date()` function from the lubridate package. This function rounds dates down to the start of a specified unit of time, in this case a week. By default, `floor_date()` treats Sunday as the start of the week and so if the specified unit of time is a week, all dates will be rounded down to the date of the previous Sunday.

`floor_date()` works on date variables, so if we want to use it on a date-time variable we should first convert it to a date variable using the `as_date()` function from lubridate. So to convert a date-time stored in a variable called `date` into the date of the first day of that week, we would use the code `floor_date(as_date(date), unit = "week")`.

One complication of counting incidents by week is that our data might not fit neatly into calendar weeks. For example, if we have data for a particular year and that year started on a Tuesday, the first weekly count will only have data for five days and it will look like there were fewer crimes that week in comparison to other weeks. This could be misleading, since this week only looks like it has less crime because we don't have data for the whole week. The same problem can happen with the last week of data, too. To deal with this, after counting the crimes by week we will remove the first and last row of the data using the `slice()` function from the dplyr package.

<a id="lst-mapping-time-count-weekly-assaults"></a>

<figure>
<pre><code>chapter_15a.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># SHOW CHANGE OVER TIME --------------------------------------------------------</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="co"># Count number of aggravated assaults each week</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>assault_weekly_counts <span class="ot">&lt;-</span> assaults <span class="sc">|&gt;</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="co"># Convert offence dates so that it appears each offence happened on the first</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="co"># day (Sunday) of the week</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>  <span class="fu">mutate</span>(<span class="at">week_date =</span> <span class="fu">floor_date</span>(<span class="fu">as_date</span>(date), <span class="at">unit =</span> <span class="st">&quot;week&quot;</span>)) <span class="sc">|&gt;</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="co"># Count the number of assaults each week</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="fu">count</span>(week_date, <span class="at">name =</span> <span class="st">&quot;count&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="co"># The code `(n() - 1)` gives us the row number of the second-to-last row in</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="co"># the data because `n()` returns the number of rows in the data. Note the</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="co"># parentheses!</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">slice</span>(<span class="dv">2</span><span class="sc">:</span>(<span class="fu">n</span>() <span class="sc">-</span> <span class="dv">1</span>))</span></code></pre></div>
<figcaption>Code 15.13</figcaption>
</figure>

<a id="lst-mapping-time-preview-weekly-assault-counts"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">head</span>(assault_weekly_counts)</span></code></pre></div>
<figcaption>Code 15.14</figcaption>
</figure>

    # A tibble: 6 × 2
      week_date  count
      <date>     <int>
    1 2010-01-03   234
    2 2010-01-10   300
    3 2010-01-17   303
    4 2010-01-24   257
    5 2010-01-31   276
    6 2010-02-07   264

Now we have weekly counts of aggravated assaults, we can plot them on a chart. As we learned in [Chapter 14](../14_no_maps/index.llms.md), we can use `ggauto::ggauto()` to create a basic chart automatically.

<a id="lst-mapping-time-weekly-assaults-chart-ggauto"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>assault_weekly_counts <span class="sc">|&gt;</span> ggauto<span class="sc">::</span><span class="fu">ggauto</span>(week_date, count)</span></code></pre></div>
<figcaption>Code 15.15</figcaption>
</figure>

<a id="fig-weekly-assaults-chart-ggauto"></a>

<figure>
<a id="fig-weekly-assaults-chart-ggauto"></a>Figure: Line chart of weekly aggravated-assault counts in Chicago from 2010 to 2019. Counts decline towards 2014 and then rise again, with repeated summer peaks and winter troughs. Large week-to-week fluctuations make the line jagged, so the long-term and seasonal patterns overlap.
<figcaption>Figure 15.4</figcaption>
</figure>

This chart already tells us quite a lot about how the frequency of assaults in Chicago has changed over time. For example, we can see a downward trend in assaults from 2010 to 2014, after which the frequency seems to have gone up somewhat. More obviously, we can see that there is strong seasonality in the frequency of assaults, with assaults peaking in the summer months and falling in the winter months. Finally, we can see there is a lot of short-term variation in the frequency of assaults, with the number of assaults varying substantially from one week to the next.

<a id="sec-mapping-time-signal-versus-noise-in-temporal-data"></a>
<a id="signal-versus-noise-in-temporal-data"></a>

### 15.3.1 Signal versus noise in temporal data

One issue created by the short-term variation in assaults visible in [Figure 15.4](#fig-weekly-assaults-chart-ggauto) is that it can be hard to see the longer-term trends in the data. While this week-to-week short-term variation is real, we often refer to this type of short-term variation as *noise* because it can obscure the *signal* of longer-term trends. This terminology originally came to statistics -- and therefore crime analysis -- from radio engineering, but has become common over time.

The key decision in making a time-series chart is usually choosing the balance between removing (or de-emphasising) the noise in a time series sufficiently to make longer-term trends easier to see, while not removing so much noise that we lose important information about the short-term variation. For example, if we tried to plot hourly counts of assaults in Chicago, there would be so much noise that it would be hard to see any long-term trends:

<a id="fig-mapping-time-hourly-assault-noise-chart"></a>

<figure>
<a id="fig-mapping-time-hourly-assault-noise-chart"></a>Figure: Scatter plot with date from 2010 to 2019 on the horizontal axis and hourly aggravated-assault counts in Chicago on the vertical axis. Most hours have low counts, forming dense horizontal bands; occasional hours have much higher counts. The overlapping dots make long-term trends difficult to distinguish.
<figcaption>Figure 15.5</figcaption>
</figure>

On the other hand, if we removed too much noise, for example by only plotting annual counts of assaults, we would remove most of the information (or signal) contained in the data about how assaults vary over time. While we would be able to see some of the long-term trend (although not whether the trend changed mid-year or between years), we would lose all information about the seasonal and the week-to-week variation in assaults:

<a id="fig-mapping-time-annual-assault-count-chart"></a>

<figure>
<a id="fig-mapping-time-annual-assault-count-chart"></a>Figure: Bar chart of annual aggravated-assault counts in Chicago from 2010 to 2019. Counts fall from roughly seventeen thousand in 2010 to thirteen thousand in 2013–14, then return to around fifteen thousand from 2016 onwards. Aggregating to years reveals that broad pattern but removes within-year seasonal and weekly variation.
<figcaption>Figure 15.6</figcaption>
</figure>

Striking the balance between removing noise while retaining information is one of those choices that partly depends on your experience as an analyst. One way to work out what balance to strike is to consider the needs of the audience you are producing analysis for. For example, if you are producing a chart for a city mayor who is interested in the long-term trend in assaults, it might be appropriate to remove more noise than if you were producing a chart for a local police commander that is more interested in the short term.

<a id="sec-mapping-time-adding-a-moving-average"></a>
<a id="adding-a-moving-average"></a>

### 15.3.2 Adding a moving average

One way to reduce the visual impact of noisy short-term variation on our chart is by adding a line showing a *moving average* (also called a *rolling average* or *rolling mean*) of the count of crime over time. A moving average is the average (or mean) of the count of crimes in the current week and a given number of adjacent (in this case, previous) weeks.

To add a moving average to our time-series chart, we need to move from using `ggauto()` to constructing the plot ourselves with the ggplot2 package that we learned about in [Chapter 14](../14_no_maps/index.llms.md). To start with, we will create a chart that shows each weekly count as a dot. We can then add a line showing the moving average.

Run this code in the R Console. Make sure you understand (using the notes below the chart) why we are using `aes()` here in two different ways.

<a id="lst-mapping-time-weekly-assault-points-chart"></a>

<figure>
<pre><code>R Console</code></pre>
<a id="annotated-cell-16"></a>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r code-annotation-code number-lines code-with-copy code-annotated"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Create plot of weekly assault counts with moving average</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>assault_weekly_counts <span class="sc">|&gt;</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="co"># Specify aesthetics that will be used by all layers in the plot</span></span>
<span id="cb2-5"><a href="#cb2-5"></a><span class="dv">1</span>  <span class="fu">aes</span>(<span class="at">x =</span> week_date) <span class="sc">+</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="co"># Add points showing weekly counts of assaults</span></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="dv">2</span>  <span class="fu">geom_point</span>(<span class="fu">aes</span>(<span class="at">y =</span> count), <span class="at">colour =</span> <span class="st">&quot;grey75&quot;</span>, <span class="at">size =</span> <span class="fl">0.75</span>) <span class="sc">+</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="fu">theme_minimal</span>()</span></code></pre></div>
<figcaption>Code 15.16</figcaption>
</figure>

1
: We specify that the x-axis of the chart will be controlled by the `week_date` column in the `assault_weekly_counts` tibble. We specify that in the `aes()` function that's added to `ggplot()` because the x-axis will be the same for all layers in the plot.

2
: We specify that the y-axis for the points layer will be controlled by the `count` column in the `assault_weekly_counts` tibble. We specify that in the `aes()` function that's added *inside* the `geom_point()` function because the column controlling the y-axis will be different for this layer than for other layers we will add later.

<a id="fig-mapping-time-weekly-assault-points-chart"></a>

<figure>
<a id="fig-mapping-time-weekly-assault-points-chart"></a>Figure: Scatter plot of weekly aggravated-assault counts in Chicago from 2010 to 2019. Grey points show recurring peaks and troughs, a low period around 2014 and higher counts before and after it. No connecting line or moving average has yet been added.
<figcaption>Figure 15.7</figcaption>
</figure>

We can now think about adding the moving average. Moving averages are calculated by plotting the mean frequency of assaults of a number of adjacent periods (weeks, in this case) instead of (or in addition to) the actual frequency of assaults in each period. For example, a four-week moving average would be calculated by averaging the counts of assaults in weeks 1, 2, 3 and 4. The moving average for week 5 would be calculated by averaging the counts of assaults in weeks 2, 3, 4 and 5, and so on.

<a id="fig-moving-average-windows"></a>

<figure>
<p>Figure: Diagram of a four-week trailing moving average. Each row marks a different target week with a large filled dot and joins it to the three preceding weeks with a horizontal line. As the target moves from week five to week eight, the four-week window shifts forwards one week at a time; future weeks are not included.</p>
<figcaption>Figure 15.8</figcaption>
</figure>

Since moving averages show the average count of crime over several weeks, they are less influenced by week-to-week variation. To calculate a moving average we have to choose how many weeks to include (known as the *window* of the moving average). The more weeks we include in the window, the smoother the values will appear from week to week and the more short-term variation will be obscured. There is a balance to be struck between making longer-term trends clear and obscuring genuine short-term variation, so you should experiment with different window lengths to ensure you are not over-smoothing.

We can calculate moving averages in R with the `slide_dbl()` function from the [slider package](https://slider.r-lib.org/) (so called because its functions slide along a series of values). `slide_dbl()` can calculate several types of moving averages, so we specify that it should use the `mean()` function to calculate the average by specifying `.f = mean` (note the lack of parentheses after `mean`). We use the `.before` argument (note the `.`) to specify how many weeks *before the current week* to include in our moving average. So if we wanted to calculate a four-week moving average (i.e. the current week and the previous three weeks), we would specify `.before = 3`. We also specify `.complete = TRUE` to stop `slide_dbl()` from trying to calculate averages for the first few weeks in our data, because we don't have the necessary data from previous weeks (i.e. before the start of our data) that we would need to make these averages accurate. `slide_dbl()` will use `NA` as the moving average value for those weeks, so we later need to specify `na.rm = TRUE` to tell `ggplot()` to ignore these when we plot the data.

Once we've calculated a moving average, we can show this using the line on our chart on top of the existing points, to show the longer-term trends and how much short-term variation there is in the data.

Add [Code 15.17](#lst-mapping-time-plot-assault-moving-average) to the `chapter_15a.R` file and run it. You can see we are also adding some other functions to the `ggplot()` stack, which are explained in the accompanying notes.

<a id="lst-mapping-time-plot-assault-moving-average"></a>

<figure>
<pre><code>chapter_15a.R</code></pre>
<a id="annotated-cell-17"></a>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r code-annotation-code number-lines code-with-copy code-annotated"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Create plot of weekly assault counts with moving average</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>assault_weekly_counts <span class="sc">|&gt;</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="co"># Calculate moving average</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">mutate</span>(<span class="at">moving_avg =</span> <span class="fu">slide_dbl</span>(count, mean, <span class="at">.before =</span> <span class="dv">3</span>, <span class="at">.complete =</span> <span class="cn">TRUE</span>)) <span class="sc">|&gt;</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="co"># Specify which columns in the data will control which parts of the chart</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>  <span class="fu">aes</span>(<span class="at">x =</span> week_date) <span class="sc">+</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="co"># Add points showing weekly counts of assaults</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="fu">geom_point</span>(<span class="fu">aes</span>(<span class="at">y =</span> count), <span class="at">colour =</span> <span class="st">&quot;grey75&quot;</span>, <span class="at">size =</span> <span class="fl">0.75</span>) <span class="sc">+</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="co"># Add line showing moving average</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="fu">geom_line</span>(<span class="fu">aes</span>(<span class="at">y =</span> moving_avg), <span class="at">na.rm =</span> <span class="cn">TRUE</span>) <span class="sc">+</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="co"># Specify how dates should be shown on the x axis</span></span>
<span id="cb2-13"><a href="#cb2-13"></a><span class="dv">1</span>  <span class="fu">scale_x_date</span>(<span class="at">date_breaks =</span> <span class="st">&quot;1 year&quot;</span>, <span class="at">date_labels =</span> <span class="st">&quot;%Y&quot;</span>, <span class="at">expand =</span> <span class="fu">c</span>(<span class="dv">0</span>, <span class="dv">0</span>)) <span class="sc">+</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="co"># Make sure y axis starts at zero</span></span>
<span id="cb2-15"><a href="#cb2-15"></a><span class="dv">2</span>  <span class="fu">scale_y_continuous</span>(<span class="at">limits =</span> <span class="fu">c</span>(<span class="dv">0</span>, <span class="cn">NA</span>), <span class="at">expand =</span> <span class="fu">c</span>(<span class="dv">0</span>, <span class="dv">0</span>), <span class="at">position =</span> <span class="st">&quot;right&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="co"># Add labels</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-18"><a href="#cb2-18"></a>    <span class="at">title =</span> <span class="st">&quot;Trend in aggravated assaults in Chicago&quot;</span>,</span>
<span id="cb2-19"><a href="#cb2-19"></a>    <span class="at">subtitle =</span> <span class="st">&quot;points show weekly counts, line shows four-week moving average&quot;</span>,</span>
<span id="cb2-20"><a href="#cb2-20"></a>    <span class="at">caption =</span> <span class="st">&quot;Data from Chicago Police Department&quot;</span>,</span>
<span id="cb2-21"><a href="#cb2-21"></a>    <span class="at">x =</span> <span class="cn">NULL</span>,</span>
<span id="cb2-22"><a href="#cb2-22"></a>    <span class="at">y =</span> <span class="st">&quot;weekly count of aggravated assaults&quot;</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>  ) <span class="sc">+</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  <span class="fu">theme_minimal</span>() <span class="sc">+</span></span>
<span id="cb2-25"><a href="#cb2-25"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-26"><a href="#cb2-26"></a>    <span class="at">panel.grid.minor.x =</span> <span class="fu">element_blank</span>(),</span>
<span id="cb2-27"><a href="#cb2-27"></a>    <span class="at">plot.caption =</span> <span class="fu">element_text</span>(<span class="at">colour =</span> <span class="st">&quot;grey40&quot;</span>),</span>
<span id="cb2-28"><a href="#cb2-28"></a>    <span class="at">plot.caption.position =</span> <span class="st">&quot;plot&quot;</span></span>
<span id="cb2-29"><a href="#cb2-29"></a>  )</span></code></pre></div>
<figcaption>Code 15.17</figcaption>
</figure>

1
: `scale_x_date()` controls the appearance of the horizontal (x) axis on the chart. The `date_breaks = "1 year"` argument specifies that we want a label at the start of each year, the `date_labels = "%Y"` argument uses a code to specify that we want each label to be a four-digit year, and the `expand = c(0, 0)` argument specifies that we want to remove the default extra space that ggplot2 adds at the ends of the axis. You can find a full list of codes used to specify different parts of a date and time in the axis labels by typing `?strptime` in the R Console.

2
: `scale_y_continuous()` controls the appearance of the vertical (y) axis on the chart. The `limits = c(0, NA)` argument specifies that we want the y axis to start at zero, and (by specifying `NA`) to finish at the maximum value in the data. The `expand = c(0, 0)` argument specifies that we want to remove the default extra space that ggplot2 adds at the ends of the axis. The `position = "right"` argument specifies that we want the y axis to be shown on the right-hand side of the chart rather than on the left-hand side, which is ggplot2's default. We put the y-axis on the right-hand side because the most-recent values in a time-series chart (which are on the right-hand end of the time series) are normally of most interest.

<a id="fig-mapping-time-plot-assault-moving-average"></a>

<figure>
<a id="fig-mapping-time-plot-assault-moving-average"></a>Figure: Time-series chart of aggravated assaults in Chicago from 2010 to 2019. Grey dots show weekly counts; a black four-week trailing moving-average line follows seasonal peaks and troughs while smoothing local variation. The low period around 2014 remains visible rather than being removed by smoothing.
<figcaption>Figure 15.9</figcaption>
</figure>

You can experiment with the effect of setting a longer or shorter window for the moving average by specifying larger or smaller values of the `.before` argument to `slide_dbl()`. For example, create an eight-week moving average by specifying `.before = 7`. What would happen to the apparent seasonal variation in the number of assaults (visible in [Figure 15.9](#fig-mapping-time-plot-assault-moving-average)) if you create a *52-week moving average* by specifying `.before = 51`?

TipWhy does this `ggplot()` stack have three calls to `aes()`?

<a id="callout-6"></a>

The `aes()` function is used to specify which columns in the data will control which parts of the chart. We can use `aes()` in two ways. If we add `aes()` directly to the stack just after `ggplot()`, that will specify which columns in the data will control the appearance of *all* the layers on the chart. Conversely, if we specify `aes()` inside one of the `geom_*()` family of functions, that will only affect the appearance of that specific layer.

In [Code 15.17](#lst-mapping-time-plot-assault-moving-average), we use `aes()` first to specify that the horizontal position of data in *all* the layers should be controlled by the `week_date` column in the data. We then use `aes()` inside both `geom_point()` and `geom_line()` to specify which (different) columns in the data should be used to control the vertical position of the points and lines.

<a id="sec-repeating-time-patterns"></a>
<a id="showing-repeating-patterns-over-time"></a>

## 15.4 Showing repeating patterns over time

We have already seen that there is seasonal variation in the number of aggravated assaults in Chicago. As is very common for assaults, there are more offences in the summer and fewer in the winter. We can see this in the time-series chart we have already produced, but it's hard to see the detail. For example, we might want to know how consistent this seasonal variation is across different years. Is it, for example, consistent enough that the local police might want to restrict the number of officers who can take holidays in certain weeks of the year to maximise the number of officers available when violent crime is likely to be highest?

To do this we can create a *seasonal chart*. This can be used to show any type of repeating variation, but is often used to show patterns across a year (hence the name). To create a seasonal plot we need to add a variable to our data specifying which year each weekly count belongs to, which we can do by using the `year()` function to extract the year from the offence dates. We can do this at the same time as we calculate the moving averages. Once we've done that, we can specify that we want our chart to have a separate line for each year by setting `group = year` inside the `aes()` function that controls how the data are shown on the chart, making each year a different colour using `colour = year`.

Run this code in the R Console. Note that since there is quite a lot of noise in the weekly counts, this chart uses an eight-week moving average (using the `.before = 7` argument to `slide_dbl()`) to make the seasonal pattern clearer.

<a id="lst-mapping-time-initial-seasonal-assault-chart"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Create a seasonal plot of aggravated assaults</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>assault_weekly_counts <span class="sc">|&gt;</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">mutate</span>(</span>
<span id="cb2-4"><a href="#cb2-4"></a>    <span class="co"># Create an eight-week moving average</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>    <span class="at">moving_avg =</span> <span class="fu">slide_dbl</span>(count, mean, <span class="at">.before =</span> <span class="dv">7</span>, <span class="at">.complete =</span> <span class="cn">TRUE</span>),</span>
<span id="cb2-6"><a href="#cb2-6"></a>    <span class="co"># Create a new column showing just the year</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>    <span class="at">year =</span> <span class="fu">year</span>(week_date)</span>
<span id="cb2-8"><a href="#cb2-8"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="co"># Specify which columns in the data should control which parts of the chart</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="fu">aes</span>(<span class="at">x =</span> week_date, <span class="at">y =</span> moving_avg, <span class="at">colour =</span> year, <span class="at">group =</span> year) <span class="sc">+</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="co"># Add lines</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">geom_line</span>(<span class="at">na.rm =</span> <span class="cn">TRUE</span>) <span class="sc">+</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="co"># Specify how dates should be shown on the x axis</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  <span class="fu">scale_x_date</span>(<span class="at">date_breaks =</span> <span class="st">&quot;1 year&quot;</span>, <span class="at">date_labels =</span> <span class="st">&quot;%Y&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="co"># Make sure y axis starts at zero</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>  <span class="fu">scale_y_continuous</span>(<span class="at">limits =</span> <span class="fu">c</span>(<span class="dv">0</span>, <span class="cn">NA</span>)) <span class="sc">+</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="co"># Specify that the legend should be labelled with whole numbers</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>  <span class="fu">scale_colour_continuous</span>(<span class="at">breaks =</span> <span class="fu">c</span>(<span class="dv">2010</span>, <span class="dv">2013</span>, <span class="dv">2016</span>, <span class="dv">2019</span>)) <span class="sc">+</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  <span class="co"># Add labels</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-22"><a href="#cb2-22"></a>    <span class="at">x =</span> <span class="cn">NULL</span>,</span>
<span id="cb2-23"><a href="#cb2-23"></a>    <span class="at">y =</span> <span class="st">&quot;moving average of weekly count of aggravated assaults&quot;</span>,</span>
<span id="cb2-24"><a href="#cb2-24"></a>    <span class="at">colour =</span> <span class="cn">NULL</span></span>
<span id="cb2-25"><a href="#cb2-25"></a>  ) <span class="sc">+</span></span>
<span id="cb2-26"><a href="#cb2-26"></a>  <span class="fu">theme_minimal</span>() <span class="sc">+</span></span>
<span id="cb2-27"><a href="#cb2-27"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-28"><a href="#cb2-28"></a>    <span class="at">panel.grid.minor.x =</span> <span class="fu">element_blank</span>()</span>
<span id="cb2-29"><a href="#cb2-29"></a>  )</span></code></pre></div>
<figcaption>Code 15.18</figcaption>
</figure>

<a id="fig-mapping-time-initial-seasonal-assault-chart"></a>

<figure>
<a id="fig-mapping-time-initial-seasonal-assault-chart"></a>Figure: Line chart of eight-week moving averages of weekly aggravated-assault counts in Chicago from 2010 to 2019. Separate blue-shaded lines for each year appear consecutively along a calendar-date axis, with breaks at year boundaries. Repeated summer peaks are visible, but corresponding months in different years are not aligned for comparison.
<figcaption>Figure 15.10</figcaption>
</figure>

This chart might not look like you expected it to. Although the grouping of the lines by year has worked (there is a break between the lines at the start of each year), it's no easier to compare the seasonal patterns across years. Comparing years would be much easier if we superimpose the weekly counts for each year on top of one another.

To do this, we need to trick `ggplot()` into plotting all the weekly counts as if they occurred in a single year, so the counts appear in the same locations on the horizontal axis of the chart, whichever year they occurred in. We can do this by creating a fake date value for each weekly count which has the same month and day of the month as the original date, but a single year across all the rows in the data. We will create this pseudo date by extracting the month and day of the month using the `month()` and `mday()` functions from the lubridate package, then creating a new date with `make_date()`.

Add this code to the end of your R script file and run it.

<a id="lst-mapping-time-plot-seasonal-assault-chart"></a>

<figure>
<pre><code>chapter_15a.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Create a seasonal plot of aggravated assaults</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>assault_weekly_counts <span class="sc">|&gt;</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">mutate</span>(</span>
<span id="cb2-4"><a href="#cb2-4"></a>    <span class="co"># Create an eight-week moving average</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>    <span class="at">moving_avg =</span> <span class="fu">slide_dbl</span>(count, mean, <span class="at">.before =</span> <span class="dv">7</span>, <span class="at">.complete =</span> <span class="cn">TRUE</span>),</span>
<span id="cb2-6"><a href="#cb2-6"></a>    <span class="co"># Create a new column showing just the year</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>    <span class="at">year =</span> <span class="fu">year</span>(week_date),</span>
<span id="cb2-8"><a href="#cb2-8"></a>    <span class="co"># By only specifying the `month` and `day` arguments to `make_date()` we</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>    <span class="co"># will create a date in 1970 (the year that R uses by default), but that</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>    <span class="co"># doesn&#39;t matter because we are not going to show the year on the chart</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>    <span class="at">pseudo_date =</span> <span class="fu">make_date</span>(<span class="at">month =</span> <span class="fu">month</span>(week_date), <span class="at">day =</span> <span class="fu">mday</span>(week_date))</span>
<span id="cb2-12"><a href="#cb2-12"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="co"># Specify which columns in the data should control which parts of the chart</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  <span class="fu">aes</span>(<span class="at">x =</span> pseudo_date, <span class="at">y =</span> moving_avg, <span class="at">colour =</span> year, <span class="at">group =</span> year) <span class="sc">+</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="co"># Add lines</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>  <span class="fu">geom_line</span>(<span class="at">na.rm =</span> <span class="cn">TRUE</span>) <span class="sc">+</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="co"># Specify how dates should be shown on the x axis</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>  <span class="fu">scale_x_date</span>(<span class="at">date_breaks =</span> <span class="st">&quot;1 month&quot;</span>, <span class="at">date_labels =</span> <span class="st">&quot;%b&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  <span class="co"># Make sure y axis starts at zero</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>  <span class="fu">scale_y_continuous</span>(<span class="at">limits =</span> <span class="fu">c</span>(<span class="dv">0</span>, <span class="cn">NA</span>)) <span class="sc">+</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  <span class="co"># Specify that the legend should be labelled with whole numbers</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>  <span class="fu">scale_colour_continuous</span>(<span class="at">breaks =</span> <span class="fu">c</span>(<span class="dv">2010</span>, <span class="dv">2013</span>, <span class="dv">2016</span>, <span class="dv">2019</span>)) <span class="sc">+</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  <span class="co"># Add labels</span></span>
<span id="cb2-25"><a href="#cb2-25"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-26"><a href="#cb2-26"></a>    <span class="at">x =</span> <span class="cn">NULL</span>,</span>
<span id="cb2-27"><a href="#cb2-27"></a>    <span class="at">y =</span> <span class="st">&quot;moving average of weekly count of aggravated assaults&quot;</span>,</span>
<span id="cb2-28"><a href="#cb2-28"></a>    <span class="at">colour =</span> <span class="cn">NULL</span></span>
<span id="cb2-29"><a href="#cb2-29"></a>  ) <span class="sc">+</span></span>
<span id="cb2-30"><a href="#cb2-30"></a>  <span class="fu">theme_minimal</span>() <span class="sc">+</span></span>
<span id="cb2-31"><a href="#cb2-31"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-32"><a href="#cb2-32"></a>    <span class="at">panel.grid.minor.x =</span> <span class="fu">element_blank</span>()</span>
<span id="cb2-33"><a href="#cb2-33"></a>  )</span></code></pre></div>
<figcaption>Code 15.19</figcaption>
</figure>

<a id="fig-mapping-time-plot-seasonal-assault-chart"></a>

<figure>
<a id="fig-mapping-time-plot-seasonal-assault-chart"></a>Figure: Seasonal line chart of eight-week moving averages of weekly aggravated-assault counts in Chicago, with one blue-shaded line for each year from 2010 to 2019. January to December runs along a shared horizontal axis. The lines generally rise from winter troughs to July–August peaks before falling again; their differing heights show variation between years.
<figcaption>Figure 15.11</figcaption>
</figure>

From this chart we can see that assaults consistently peak in July, although in one year they peaked slightly earlier in late June and in one year slightly later in August. At the other end of the year, weekly counts of assaults are almost always least frequent in late January and throughout February before starting to increase quite rapidly in March.

As well as showing seasonal variation, we can use the same technique to understand variation over other periods of time. For example, since we know a lot of human activities follow weekly patterns, we might want to produce a chart showing the number of crimes in each hour on each day of the week.

To do this, we:

1.  Extract the weekday and hour components of each date using `wday()` and `hour()`.
2.  Count the total number of crimes occurring in each hour of each day *across all ten years of the data* using `count()`.
3.  Create a pseudo-date-time using `make_datetime()`.

We can do this in a single piece of code. Add this R code to the end of the R script file. Remember to run this chunk of code.

<a id="lst-mapping-time-count-hourly-assaults"></a>

<figure>
<pre><code>chapter_15a.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Create counts of assaults by hours of the day and week</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>assault_hourly_counts <span class="ot">&lt;-</span> assaults <span class="sc">|&gt;</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="co"># Extract day of the week and hour of the day from the date column</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">mutate</span>(<span class="at">wday =</span> <span class="fu">wday</span>(date, <span class="at">label =</span> <span class="cn">TRUE</span>), <span class="at">hour =</span> <span class="fu">hour</span>(date)) <span class="sc">|&gt;</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="co"># Count crimes for each hour of each day of the week</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="fu">count</span>(wday, hour, <span class="at">name =</span> <span class="st">&quot;count&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>  <span class="co"># By only setting the `hour` argument to `make_datetime()` we will create a</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="co"># date-time on 1 January 1970, but that doesn&#39;t matter because we will not</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="co"># show the date on the chart</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="fu">mutate</span>(<span class="at">pseudo_date =</span> <span class="fu">make_datetime</span>(<span class="at">hour =</span> hour))</span></code></pre></div>
<figcaption>Code 15.20</figcaption>
</figure>

We can now create a chart with appropriate labels on the horizontal axis and a suitable qualitative colour scheme to show the days of the week using `scale_colour_brewer()`.

<a id="lst-mapping-time-hourly-assault-chart"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Create chart of assaults by hour of the day for each day of the week</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="fu">ggplot</span>(assault_hourly_counts) <span class="sc">+</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="co"># Specify which columns in the data should control each part of the chart</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">aes</span>(<span class="at">x =</span> pseudo_date, <span class="at">y =</span> count, <span class="at">colour =</span> wday, <span class="at">group =</span> wday) <span class="sc">+</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="co"># Add lines</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="fu">geom_line</span>() <span class="sc">+</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>  <span class="co"># Specify how dates should be shown on the x axis</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="fu">scale_x_datetime</span>(<span class="at">date_breaks =</span> <span class="st">&quot;2 hours&quot;</span>, <span class="at">date_labels =</span> <span class="st">&quot;%H:%M&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="co"># Make sure y axis starts at zero and labels have thousands separators</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="fu">scale_y_continuous</span>(<span class="at">limits =</span> <span class="fu">c</span>(<span class="dv">0</span>, <span class="cn">NA</span>), <span class="at">labels =</span> scales<span class="sc">::</span><span class="fu">comma_format</span>()) <span class="sc">+</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="co"># Specify a qualitative colour scheme should be used</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="fu">scale_colour_brewer</span>(<span class="at">type =</span> <span class="st">&quot;qual&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="co"># Add labels</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-15"><a href="#cb2-15"></a>    <span class="at">x =</span> <span class="cn">NULL</span>,</span>
<span id="cb2-16"><a href="#cb2-16"></a>    <span class="at">y =</span> <span class="st">&quot;hourly total of aggravated assaults, 2010–2019&quot;</span>,</span>
<span id="cb2-17"><a href="#cb2-17"></a>    <span class="at">colour =</span> <span class="cn">NULL</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>  ) <span class="sc">+</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>  <span class="fu">theme_minimal</span>()</span></code></pre></div>
<figcaption>Code 15.21</figcaption>
</figure>

<a id="fig-hourly-assault-chart"></a>

<figure>
<a id="fig-hourly-assault-chart"></a>Figure: Line chart with hour of day on the horizontal axis and pooled aggravated-assault totals in Chicago for 2010 to 2019 on the vertical axis. Seven coloured lines represent weekdays. All have a low near five to six in the morning; Saturday and Sunday have pronounced peaks just after midnight. The crossing lines make comparisons difficult.
<figcaption>Figure 15.12</figcaption>
</figure>

On this chart you can see that there are two distinct temporal patterns of assaults on different days of the week. Between Mondays and Thursdays, assaults peak between about 14:00 and 21:00 before reducing to a very low level at about 05:00. At the weekend, the picture is different: assaults peak between midnight and 02:00 on both Saturdays and Sundays (i.e. very late on Friday and Saturday evenings). In fact, there are more aggravated assaults between midnight and 03:00 on Saturdays and Sundays than at any other time of the week.

<a id="sec-small-multiple"></a>
<a id="small-multiple-charts"></a>

### 15.4.1 Small-multiple charts

[Figure 15.12](#fig-hourly-assault-chart) probably uses the maximum number of different colours for days of the week that we could use before some of the colours became too similar to one another to be distinguishable. But even with this many colours, it might not be easy for a colour-blind person to translate between the colours of the lines and the colours in the legend. When you find that there are too many colours on a chart, this is a good sign that you should consider using an alternative approach called *small-multiple charts* instead. Small-multiple charts are a way of showing several related data series in separate panels next to one another, to make it easier to see the details of each series while still being able to compare them to one another.

We can convert [Figure 15.12](#fig-hourly-assault-chart) into a small-multiple chart by splitting the data into two panels: one for weekdays and one for weekends. This will make it easier to see the details of each pattern, while still being able to compare them to one another. We can do this by (a) adding a column to the data specifying whether each day is a weekday or on a weekend, then (b) adding `facet_grid()` to our `ggplot()` stack.

Add this code to the `chapter_15a.R` file and run it.

<a id="lst-mapping-time-plot-faceted-hourly-assault-chart"></a>

<figure>
<pre><code>chapter_15a.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Create chart of assaults by hour of the day for each day of the week</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>assault_hourly_counts <span class="sc">|&gt;</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="co"># Create a new column specifying if each day is a weekday or weekend</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">mutate</span>(<span class="at">weekend =</span> <span class="fu">if_else</span>(wday <span class="sc">%in%</span> <span class="fu">c</span>(<span class="st">&quot;Sat&quot;</span>, <span class="st">&quot;Sun&quot;</span>), <span class="st">&quot;Sat–Sun&quot;</span>, <span class="st">&quot;Mon–Fri&quot;</span>)) <span class="sc">|&gt;</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="co"># Specify which columns in the data should control each part of the chart</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>  <span class="fu">aes</span>(<span class="at">x =</span> pseudo_date, <span class="at">y =</span> count, <span class="at">colour =</span> wday) <span class="sc">+</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="co"># Add lines</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="fu">geom_line</span>(<span class="at">linewidth =</span> <span class="dv">1</span>) <span class="sc">+</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="co"># Assign the facets to rows so that we can compare the same time on different</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="co"># days more easily (change `rows` to `cols` to see the alternative)</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="fu">facet_grid</span>(<span class="at">rows =</span> <span class="fu">vars</span>(weekend)) <span class="sc">+</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="co"># Specify how dates should be shown on the x axis</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="fu">scale_x_datetime</span>(<span class="at">date_breaks =</span> <span class="st">&quot;2 hours&quot;</span>, <span class="at">date_labels =</span> <span class="st">&quot;%H:%M&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  <span class="co"># Make sure y axis starts at zero and labels have thousands separators</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="fu">scale_y_continuous</span>(<span class="at">limits =</span> <span class="fu">c</span>(<span class="dv">0</span>, <span class="cn">NA</span>), <span class="at">labels =</span> scales<span class="sc">::</span><span class="fu">comma_format</span>()) <span class="sc">+</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>  <span class="co"># Specify a qualitative colour scheme should be used</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="fu">scale_colour_brewer</span>(<span class="at">type =</span> <span class="st">&quot;qual&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>  <span class="co"># Add labels</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-21"><a href="#cb2-21"></a>    <span class="at">x =</span> <span class="cn">NULL</span>,</span>
<span id="cb2-22"><a href="#cb2-22"></a>    <span class="at">y =</span> <span class="st">&quot;hourly total of aggravated assaults, 2010–2019&quot;</span>,</span>
<span id="cb2-23"><a href="#cb2-23"></a>    <span class="at">fill =</span> <span class="cn">NULL</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  ) <span class="sc">+</span></span>
<span id="cb2-25"><a href="#cb2-25"></a>  <span class="fu">theme_minimal</span>()</span></code></pre></div>
<figcaption>Code 15.22</figcaption>
</figure>

<a id="fig-mapping-time-plot-faceted-hourly-assault-chart"></a>

<figure>
<a id="fig-mapping-time-plot-faceted-hourly-assault-chart"></a>Figure: Two vertically stacked line charts compare hourly aggravated-assault totals in Chicago, pooled across 2010 to 2019. The top panel contains Monday to Friday and the bottom Saturday and Sunday. Both panels dip around five to six in the morning, but weekend nights have much larger post-midnight totals. Separating the panels reduces line overlap.
<figcaption>Figure 15.13</figcaption>
</figure>

This shows the two distinct patterns (weekdays and weekends) more clearly, while also letting us see that Friday is not like other weekdays since the peak in assaults continues later in the evening.

QuizShowing change over time

**Which of the following is an example of a repeating pattern in crime data?**

- A one-time spike in burglary due to a major event
- A steady decline in homicide rates over 10 years
- An increase in shoplifting before major holidays each year (Correct answer)
- A sudden crime wave in an area with no prior incidents

**How can temporal analysis of crime deal with the multiple ways in which crime varies over time?**

- By examining a single week\'s worth of data
- By only focusing on yearly statistics
- By assuming all crime trends follow a predictable cycle
- By analysing each type of temporal variation (e.g. seasonal, weekly) separately (Correct answer)

**What does a moving average help with when analysing crime trends?**

- It smooths out short-term fluctuations to highlight longer-term trends (Correct answer)
- It removes all variations in crime data
- It replaces the need for crime maps
- It predicts the exact time and location of future crimes

<a id="sec-map-change-over-time"></a>
<a id="how-to-map-change-over-time"></a>

## 15.5 How to map change over time

Time-series or seasonal charts are often the best way to show change in the frequency of crime over time. But it can also be useful to show maps of the patterns of crimes at different points in time. We might, for example, want to show the density of crime in an area for different periods in time.

Choosing how to divide up time into periods is an important step in this process, because in doing so we are converting a continuous variable (time) into a number of categories (periods of time). Whenever we convert a continuous variable to a categorical one we inevitably lose information. For example, if we decided to categorise the maximum temperature every day as being either 'hot' or 'cold', we would lose a lot of information about whether a particular day was moderately hot, very hot, etc. The same is true of time, since by splitting time into periods (hours, days, weeks, etc.) we lose information about variations within each period. This is inevitable, since we can't produce infinite maps showing all the infinite moments in time, but it is the reason why choosing periods carefully is important.

When choosing a period over which to count crime, it is important not to just use default periods like the day from 00:00 to 23:59 just because that is the standard definition of a day. As we saw in [Section 15.4](#sec-repeating-time-patterns), the peaks of many types of crime like assaults cross over the boundaries between days because the peak frequency is late in the evening. For this reason it may be better to, for example, define a day as a period from 05:00 to 04:59 and count the number of crimes within each day according to that definition. This takes advantage of the fact that very few crimes concentrate in the early hours of the morning.

Sometimes, it will be easy to choose periods because they will be dictated by the purpose for which you're creating the map. In this section we will create separate maps showing the density of aggravated assaults in a part of Chicago for each of the standard Chicago Police shifts of 06:00 to 13:59, 14:00 to 21:59 and 22:00 to 05:59 (bearing in mind that the actual hours some officers work may differ slightly).

To do this, we will estimate the density of assaults separately for each shift period, then combine the three density layers and plot them on small-multiple maps. First, we create a new object containing data for the Chicago Police districts we are interested in with a column showing which police shift each assault occurred in.

We can construct this column using the `case_when()` function from dplyr. `case_when()` allows us to specify any number of tests that we can apply to our data -- when a test is passed the function assigns the corresponding label to that row (the label is separated from the test by a tilde character `~`). `case_when()` is like `case_match()`, but for when we need to test for more-complicated things than just whether a variable has a particular value.

Add this code to the end of your R script file, starting a new section for mapping change over time. Remember to run the code.

<a id="lst-mapping-time-prepare-assaults-by-shift"></a>

<figure>
<pre><code>chapter_15a.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># MAP CHANGE OVER TIME ---------------------------------------------------------</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="co"># Calculate number of assaults by shift</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>assaults_by_shift <span class="ot">&lt;-</span> assaults <span class="sc">|&gt;</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="co"># Restrict counts to just the central area of Chicago</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="fu">filter</span>(district <span class="sc">%in%</span> <span class="fu">c</span>(<span class="dv">1</span>, <span class="dv">12</span>, <span class="dv">18</span>)) <span class="sc">|&gt;</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>  <span class="fu">mutate</span>(</span>
<span id="cb2-8"><a href="#cb2-8"></a>    <span class="at">shift =</span> <span class="fu">case_when</span>(</span>
<span id="cb2-9"><a href="#cb2-9"></a>      <span class="fu">between</span>(<span class="fu">hour</span>(date), <span class="dv">6</span>, <span class="dv">13</span>) <span class="sc">~</span> <span class="st">&quot;06:00 to 13:59&quot;</span>,</span>
<span id="cb2-10"><a href="#cb2-10"></a>      <span class="fu">between</span>(<span class="fu">hour</span>(date), <span class="dv">14</span>, <span class="dv">21</span>) <span class="sc">~</span> <span class="st">&quot;14:00 to 21:59&quot;</span>,</span>
<span id="cb2-11"><a href="#cb2-11"></a>      <span class="fu">hour</span>(date) <span class="sc">&gt;=</span> <span class="dv">22</span> <span class="sc">|</span> <span class="fu">hour</span>(date) <span class="sc">&lt;</span> <span class="dv">6</span> <span class="sc">~</span> <span class="st">&quot;22:00 to 05:59&quot;</span>,</span>
<span id="cb2-12"><a href="#cb2-12"></a>      <span class="cn">TRUE</span> <span class="sc">~</span> <span class="cn">NA</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>    )</span>
<span id="cb2-14"><a href="#cb2-14"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  <span class="co"># Convert the data to an SF object</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;longitude&quot;</span>, <span class="st">&quot;latitude&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:4326&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>  <span class="co"># Transform it to a coordinate reference system based on metres</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:26916&quot;</span>)</span></code></pre></div>
<figcaption>Code 15.23</figcaption>
</figure>

TipWhy did we include `TRUE ~ NA` in `case_when()`?

<a id="callout-8"></a>

`case_when()` uses a series of true/false tests to create a variable, usually based on the values of other columns in the data. To make sure that every row in the dataset is matched by at least one of the tests, it is common practice to include a final test that is always true. The easiest way to do this is to simply create a test with the fixed value `TRUE`, since `TRUE` is always true!

This catch-all test must be the last test within the `case_when()` function, because `case_when()` runs the tests in the order in which they are given and stops testing a given row in the data as soon as a test produces a true value.

In this case, we will set the label for this last test to be `NA` to catch any rows that have missing values of `date` or aren't matched by any of our tests. Since our tests between them cover all the hours of the day, there shouldn't be any rows that are not matched by at least one test, but including a catch-all test makes it easier to catch any problems with our code.

There's lots more to learn about the `case_when()` function: you can find out more by looking at the [`case_when()` page on the dplyr package website](https://dplyr.tidyverse.org/reference/case_when.html).

<a id="lst-mapping-time-preview-assaults-by-shift"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">head</span>(assaults_by_shift)</span></code></pre></div>
<figcaption>Code 15.24</figcaption>
</figure>

    Simple feature collection with 6 features and 4 fields
    Geometry type: POINT
    Dimension:     XY
    Bounding box:  xmin: 444951.9 ymin: 4635831 xmax: 449271.4 ymax: 4641406
    Projected CRS: NAD83 / UTM zone 16N
    # A tibble: 6 × 5
      date                loc_cat    district shift                  geometry
      <dttm>              <chr>         <dbl> <chr>               <POINT [m]>
    1 2010-01-01 00:30:00 hotel             1 22:00 to 05… (448202.2 4635831)
    2 2010-01-01 01:45:00 street           18 22:00 to 05…   (446518 4641406)
    3 2010-01-01 01:48:00 hotel             1 22:00 to 05… (448202.2 4635831)
    4 2010-01-01 02:00:00 government       18 22:00 to 05… (449271.4 4637966)
    5 2010-01-01 02:59:00 leisure          12 22:00 to 05… (444951.9 4637265)
    6 2010-01-01 05:00:00 residence        18 22:00 to 05… (447278.5 4639968)

The next step is to produce a kernel density (KDE) layer for assaults occurring in each shift. In [Section 6.2](../06_mapping_crime_patterns/index.llms.md#sec-kde) we learned how to do this using the sfhotspot package. We could run the `hotspot_kde()` function from that package three times to create the KDE layers for each shift, but there is a simpler way to apply the same function to different parts of a dataset using the `group_modify()` function from `dplyr`.

Normally, when we use a function to modify a dataset, that function is applied to the dataset as a whole. With `group_modify()`, we can apply a function to different parts of a dataset separately but still get the result as a single tibble with a column showing which group each row relates to (which is what we need to produce a map).

`group_modify()` needs two inputs. The first is a *grouped* dataset. We have practised using the `group_by()` function to specify which column in a dataset represents the group each row belongs to. The second input is the function we want to use to modify each group. We will provide this function in a compact format called a *lambda function*. You do not need to understand all the details of how lambda functions work, but you should note two things:

1.  A lambda function starts with a backslash followed by parentheses containing names for its inputs, such as `\(x, ...)`.
2.  Inside the lambda function, `x` represents the data in each group. The `...` accepts an additional input supplied by `group_modify()` that we do not need to use here.

So this code:

<a id="lst-mapping-time-group-modify-example"></a>

<figure>
<pre><code>Hypothetical code</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>some_data <span class="sc">|&gt;</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>  <span class="fu">group_by</span>(some_variable) <span class="sc">|&gt;</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">group_modify</span>(\(x, ...) <span class="fu">hotspot_kde</span>(x))</span></code></pre></div>
<figcaption>Code 15.25</figcaption>
</figure>

means 'take the dataset `some_data`, group it according to the values in the `some_variable` column and apply the `hotspot_kde()` function separately to each group'. The only thing left for us to do then is to use `ungroup()` to remove the grouping from the result produced by `group_modify()` and convert that result back to an SF object using `st_as_sf()`. Don't worry about specifying any arguments to `st_as_sf()` -- R will extract information such as the coordinate reference system from the `geometry` column of the data automatically.

To compare the KDE layers accurately, they must all use the same grid. We will create a grid covering the three central police districts and supply it to every call to `hotspot_kde()`. Add this code to `chapter_15a.R` just after the code that creates the `assaults_by_shift` object. Remember to run the code.

<a id="lst-mapping-time-estimate-kde-by-shift"></a>

<figure>
<pre><code>chapter_15a.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Create a grid to be used for every shift-specific KDE layer</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>grid <span class="ot">&lt;-</span> <span class="fu">hotspot_grid</span>(cpd_central, <span class="at">cell_size =</span> <span class="dv">200</span>)</span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Estimate density of assaults for each CPD shift</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>kde_by_shift <span class="ot">&lt;-</span> assaults_by_shift <span class="sc">|&gt;</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="co"># Group dataset by which shift the assaults occurred in</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>  <span class="fu">group_by</span>(shift) <span class="sc">|&gt;</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="co"># Separately estimate density of assaults for each shift</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="fu">group_modify</span>(</span>
<span id="cb2-10"><a href="#cb2-10"></a>    \(x, ...) <span class="fu">hotspot_kde</span>(x, <span class="at">grid =</span> grid, <span class="at">bandwidth_adjust =</span> <span class="fl">0.5</span>, <span class="at">quiet =</span> <span class="cn">TRUE</span>)</span>
<span id="cb2-11"><a href="#cb2-11"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="co"># Ungroup the dataset</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">ungroup</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="co"># Convert the result to an SF object (because although `hotspot_kde()` returns</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  <span class="co"># an SF object, `group_modify()` silently converts it to a tibble)</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="fu">st_as_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>  <span class="co"># Clip the result to the boundary of the three central police districts</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="fu">hotspot_clip</span>(cpd_central, <span class="at">quiet =</span> <span class="cn">TRUE</span>)</span></code></pre></div>
<figcaption>Code 15.26</figcaption>
</figure>

TipHow do lambda functions work?

<a id="callout-9"></a>

We can create our own functions in R by using the `function()` function. For example, if we wanted to create our own version of the `head()` function that printed the first 10 rows of a dataset -- rather than the default six rows printed by `head()` -- we could create a function called `head10()`:

<a id="lst-mapping-time-named-function-example"></a>

<figure>
<pre><code>Hypothetical code</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>head10 <span class="ot">&lt;-</span> <span class="cf">function</span>(x) {</span>
<span id="cb2-2"><a href="#cb2-2"></a>  <span class="fu">head</span>(x, <span class="at">n =</span> <span class="dv">10</span>)</span>
<span id="cb2-3"><a href="#cb2-3"></a>}</span>
<span id="cb2-4"><a href="#cb2-4"></a></span>
<span id="cb2-5"><a href="#cb2-5"></a><span class="fu">head10</span>(some_data)</span></code></pre></div>
<figcaption>Code 15.27</figcaption>
</figure>

When we call the new `head10()` function on a dataset, R will take whatever data we provide to that function and run all the code inside the braces `{}` using that data. We can use this new function anywhere in our code *after* we've created it. In this example, `x` is the name used for the data inside the function. This is important because it means our custom function will work regardless of what a particular dataset is called.

We could include lots of lines of code inside our new function, but in this case there is just one -- `head(x, n = 10)`. When we want to create a function that consists of a single line of code, we can dispense with the braces and put the whole function on one line:

<a id="lst-mapping-time-one-line-function-example"></a>

<figure>
<pre><code>Hypothetical code</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>head10 <span class="ot">&lt;-</span> <span class="cf">function</span>(x) <span class="fu">head</span>(x, <span class="at">n =</span> <span class="dv">10</span>)</span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="fu">head10</span>(some_data)</span></code></pre></div>
<figcaption>Code 15.28</figcaption>
</figure>

For a single-line function, modern versions of R allow us to replace `function` with a backslash. This compact form is called a *lambda function*:

<a id="lst-mapping-time-lambda-function-example"></a>

<figure>
<pre><code>Hypothetical code</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>head10 <span class="ot">&lt;-</span> \(x) <span class="fu">head</span>(x, <span class="at">n =</span> <span class="dv">10</span>)</span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="fu">head10</span>(some_data)</span></code></pre></div>
<figcaption>Code 15.29</figcaption>
</figure>

Creating a function and giving it a name is useful if we want to use it several times. But we only need to use the function supplied to `group_modify()` once, so we can place the lambda function directly inside `group_modify()` without naming it. In our KDE code, `\(x, ...)` gives the group data the name `x`; `...` accepts the additional grouping information supplied by `group_modify()` that we do not need to use; and we pass `x` to `hotspot_kde()`.

There is a lot more you could learn about creating your own functions in R. If you are interested, you might want to [work through this lesson on Creating Functions](https://swcarpentry.github.io/r-novice-inflammation/02-func-R.html).

If we look at the result produced by this code, we can see that it looks like the output produced by `hotspot_kde()` except there is an extra column that we can use to distinguish the KDE value for each cell for each of the three shifts.

<a id="lst-mapping-time-preview-kde-by-shift"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">head</span>(kde_by_shift)</span></code></pre></div>
<figcaption>Code 15.30</figcaption>
</figure>

    Simple feature collection with 6 features and 3 fields
    Geometry type: POLYGON
    Dimension:     XY
    Bounding box:  xmin: 447714.3 ymin: 4632011 xmax: 448876.3 ymax: 4632111
    Projected CRS: NAD83 / UTM zone 16N
    # A tibble: 6 × 4
      shift              n   kde                                            geometry
      <chr>          <dbl> <dbl>                                       <POLYGON [m]>
    1 06:00 to 13:59     0  33.4 ((447876.3 4632111, 447876.3 4632012, 447874.3 463…
    2 06:00 to 13:59     0  40.3 ((447876.3 4632111, 448076.3 4632111, 448076.3 463…
    3 06:00 to 13:59     0  49.4 ((448076.3 4632111, 448276.3 4632111, 448276.3 463…
    4 06:00 to 13:59     1  55.1 ((448276.3 4632111, 448476.3 4632111, 448476.3 463…
    5 06:00 to 13:59     0  56.6 ((448476.3 4632111, 448676.3 4632111, 448676.3 463…
    6 06:00 to 13:59     0  53.6 ((448676.3 4632111, 448876.3 4632111, 448876.3 463…

Now we have a KDE layer for each shift, we can create three maps for the three shifts. The key thing we need to do is tell R that we want to create multiple maps, with a separate map for each shift. We do that using `facet_grid()` in a similar way as we did in [Section 15.4.1](#sec-small-multiple).

Normally when we use `hotspot_map()` to create a KDE map, in the background `hotspot_map()` identifies that the object we're trying to map is a KDE layer and automatically sets up the map with that in mind. Unfortunately, that won't work if we pass `kde_by_shift` to `hotspot_map()` because `kde_by_shift` isn't the direct output from `hotspot_kde()`, it's the output from `hotspot_kde()` that's then been passed through `group_modify()`, `ungroup()` and `st_as_sf()`. The information `hotspot_map()` needs to identify a KDE layer is lost along the way, so we will need to specify more arguments in `hotspot_map()` to give it the correct appearance, and add some extra functions to the stack as well. The extra code in [Code 15.31](#lst-mapping-time-map-kde-by-shift) is explained in the accompanying notes.

<a id="lst-mapping-time-map-kde-by-shift"></a>

<figure>
<pre><code>R Console</code></pre>
<a id="annotated-cell-85"></a>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r code-annotation-code number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Add density map of assaults by shift</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="fu">hotspot_map</span>(</span>
<span id="cb2-3"><a href="#cb2-3"></a>  kde_by_shift,</span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">aes</span>(<span class="at">fill =</span> kde),</span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="at">colour =</span> <span class="cn">NA</span>,</span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>,</span>
<span id="cb2-7"><a href="#cb2-7"></a>  <span class="at">caption =</span> <span class="st">&quot;Crime data from Chicago Police Department&quot;</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>) <span class="sc">+</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="co"># Add district boundaries</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> cpd_central, <span class="at">colour =</span> <span class="st">&quot;grey33&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="co"># Specify a separate map for each shift</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="fu">facet_grid</span>(<span class="at">cols =</span> <span class="fu">vars</span>(shift)) <span class="sc">+</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="co"># Add scale to control fill colour of KDE cells</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="fu">scale_fill_distiller</span>(</span>
<span id="cb2-15"><a href="#cb2-15"></a>    <span class="at">direction =</span> <span class="dv">1</span>,</span>
<span id="cb2-16"><a href="#cb2-16"></a>    <span class="at">breaks =</span> <span class="fu">range</span>(<span class="fu">pull</span>(kde_by_shift, kde)),</span>
<span id="cb2-17"><a href="#cb2-17"></a>    <span class="at">labels =</span> <span class="fu">c</span>(<span class="st">&quot;low&quot;</span>, <span class="st">&quot;high&quot;</span>),</span>
<span id="cb2-18"><a href="#cb2-18"></a>  ) <span class="sc">+</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>  <span class="co"># Add labels</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-21"><a href="#cb2-21"></a>    <span class="at">title =</span> <span class="st">&quot;Aggravated assaults in downtown Chicago, 2010–2019&quot;</span>,</span>
<span id="cb2-22"><a href="#cb2-22"></a>    <span class="at">fill =</span> <span class="st">&quot;density of aggravated assaults&quot;</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>  ) <span class="sc">+</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-25"><a href="#cb2-25"></a>    <span class="at">legend.position =</span> <span class="st">&quot;bottom&quot;</span>,</span>
<span id="cb2-26"><a href="#cb2-26"></a>    <span class="at">legend.title =</span> <span class="fu">element_text</span>(<span class="at">hjust =</span> <span class="dv">1</span>)</span>
<span id="cb2-27"><a href="#cb2-27"></a>  )</span></code></pre></div>
<figcaption>Code 15.31</figcaption>
</figure>

<a id="map-chicago-assault-density-by-shift"></a>

<figure>
<figure>
<p>Figure: Three side-by-side density maps of aggravated assaults in downtown Chicago, pooled across 2010 to 2019. Panels show six in the morning to two in the afternoon, two to ten in the evening, and ten at night to six in the morning. Darker blue means higher density. The strongest eastern concentration lies further north in the overnight panel; smaller concentrations occur west and south. A shared scale supports comparison.</p>
</figure>
<figcaption>Map 15.2</figcaption>
</figure>

1.  As we learned in [Section 6.6](../06_mapping_crime_patterns/index.llms.md#sec-other-layers), the `aes()` function is used to specify which column in the data should control each of the aesthetics on a map or chart. For KDE objects, normally `hotspot_map()` handles this for us, but in this case we provide the same information manually by specifying `aes()` as the second argument to `hotspot_map()` and setting `fill = kde` to tell R that the `kde` column in the data should control the fill colour of the KDE cells.
2.  The `colour = NA` argument is used to remove the outline around each KDE cell, so that only the fill colour is visible. Again, this is something that `hotspot_map()` does automatically for KDE objects but which we need to specify manually here.
3.  As we learned in [Section 7.6](../07_map_context/index.llms.md#sec-map-colour), the `scale_fill_distiller()` function is used to control the colour scale that represents the KDE values. The `direction = 1` argument means that the colours will be ordered from light to dark, `range(pull(kde_by_shift, kde))` specifies that the legend should have labels corresponding to the minimum and maximum KDE values in the data, and `labels = c("low", "high")` sets the label text.

On this map we can see that some places have a relatively high density of assaults throughout all three shifts, but others only have a high density at certain times. We can perhaps make this clearer by highlighting the grid cells with the highest estimated density of assaults during each shift. We can do this using the `slice_max()` function from dplyr, which allows us to extract the rows in a dataset with the highest values of a particular variable. In this case we will use `slice_max()` together with `group_by()` to get the rows with the highest values *separately for each shift* rather than those with the highest values across all three shifts combined.

Add [Code 15.32](#lst-mapping-time-map-highest-kde-by-shift) to the end of `chapter_15a.R` and run it.

<a id="lst-mapping-time-map-highest-kde-by-shift"></a>

<figure>
<pre><code>chapter_15a.R</code></pre>
<a id="annotated-cell-86"></a>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r code-annotation-code number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Create new dataset containing just the cells in each shift with the highest</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="co"># KDE values</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>kde_shift_highest <span class="ot">&lt;-</span> kde_by_shift <span class="sc">|&gt;</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">group_by</span>(shift) <span class="sc">|&gt;</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="fu">slice_max</span>(<span class="at">order_by =</span> kde, <span class="at">n =</span> <span class="dv">10</span>)</span>
<span id="cb2-6"><a href="#cb2-6"></a></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="co"># Add density map of assaults by shift</span></span>
<span id="cb2-8"><a href="#cb2-8"></a><span class="fu">hotspot_map</span>(</span>
<span id="cb2-9"><a href="#cb2-9"></a>  kde_by_shift,</span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="fu">aes</span>(<span class="at">fill =</span> kde),</span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="at">colour =</span> <span class="cn">NA</span>,</span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>,</span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="at">caption =</span> <span class="st">&quot;Crime data from Chicago Police Department&quot;</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>) <span class="sc">+</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  <span class="co"># Highlight the cells with the highest density in each shift</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="fu">geom_sf</span>(</span>
<span id="cb2-17"><a href="#cb2-17"></a>    <span class="at">data =</span> kde_shift_highest,</span>
<span id="cb2-18"><a href="#cb2-18"></a>    <span class="at">alpha =</span> <span class="fl">0.75</span>,</span>
<span id="cb2-19"><a href="#cb2-19"></a>    <span class="at">colour =</span> <span class="st">&quot;red2&quot;</span>,</span>
<span id="cb2-20"><a href="#cb2-20"></a>    <span class="at">fill =</span> <span class="cn">NA</span>,</span>
<span id="cb2-21"><a href="#cb2-21"></a>    <span class="at">linewidth =</span> <span class="dv">1</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  ) <span class="sc">+</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>  <span class="co"># Add district boundaries</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> cpd_central, <span class="at">colour =</span> <span class="st">&quot;grey33&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-25"><a href="#cb2-25"></a>  <span class="co"># Add scale to control fill colour of KDE cells</span></span>
<span id="cb2-26"><a href="#cb2-26"></a>  <span class="fu">scale_fill_distiller</span>(</span>
<span id="cb2-27"><a href="#cb2-27"></a>    <span class="at">direction =</span> <span class="dv">1</span>,</span>
<span id="cb2-28"><a href="#cb2-28"></a>    <span class="at">breaks =</span> <span class="fu">range</span>(<span class="fu">pull</span>(kde_by_shift, kde)),</span>
<span id="cb2-29"><a href="#cb2-29"></a>    <span class="at">labels =</span> <span class="fu">c</span>(<span class="st">&quot;low&quot;</span>, <span class="st">&quot;high&quot;</span>),</span>
<span id="cb2-30"><a href="#cb2-30"></a>  ) <span class="sc">+</span></span>
<span id="cb2-31"><a href="#cb2-31"></a>  <span class="co"># Specify a separate map for each shift</span></span>
<span id="cb2-32"><a href="#cb2-32"></a>  <span class="fu">facet_grid</span>(<span class="at">cols =</span> <span class="fu">vars</span>(shift)) <span class="sc">+</span></span>
<span id="cb2-33"><a href="#cb2-33"></a>  <span class="co"># Add labels</span></span>
<span id="cb2-34"><a href="#cb2-34"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-35"><a href="#cb2-35"></a>    <span class="at">title =</span> <span class="st">&quot;Aggravated assaults in downtown Chicago, 2010–2019&quot;</span>,</span>
<span id="cb2-36"><a href="#cb2-36"></a>    <span class="at">fill =</span> <span class="st">&quot;density of aggravated assaults&quot;</span></span>
<span id="cb2-37"><a href="#cb2-37"></a>  ) <span class="sc">+</span></span>
<span id="cb2-38"><a href="#cb2-38"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-39"><a href="#cb2-39"></a>    <span class="at">legend.position =</span> <span class="st">&quot;bottom&quot;</span>,</span>
<span id="cb2-40"><a href="#cb2-40"></a>    <span class="at">legend.title =</span> <span class="fu">element_text</span>(<span class="at">hjust =</span> <span class="dv">1</span>)</span>
<span id="cb2-41"><a href="#cb2-41"></a>  )</span></code></pre></div>
<figcaption>Code 15.32</figcaption>
</figure>

<a id="map-chicago-highest-assault-density-by-shift"></a>

<figure>
<figure>
<p>Figure: Three side-by-side Chicago aggravated-assault density maps use the same blue scale and daytime, evening and overnight periods. Red outlines identify the ten highest-density grid cells in each panel. The outlined eastern concentration lies further north overnight than during daytime or evening, making the change easier to locate against the fixed district boundaries.</p>
</figure>
<figcaption>Map 15.3</figcaption>
</figure>

This map makes it very clear that, between 2010 and 2019, the grid cells with the highest densities of aggravated assaults were very similar in the daytime and evening shifts, in both cases being concentrated in the downtown area known as The Loop. For the overnight shift, however, the cells with the highest densities were on the other side of the Chicago River in the River North neighbourhood. A map like this might be particularly useful if the resources available to respond to a crime problem were very limited and so could only be deployed in the places where the problem was worst -- this is often the case because crime-prevention resources *are* often very limited.

QuizMapping temporal change

**What is one way to effectively compare crime patterns over different time periods on a map?**

- Using a series of small-multiple maps, each representing a different time period (Correct answer)
- Using a single map with all time periods combined into one dataset
- Ignoring temporal differences and only focusing on spatial patterns
- Only mapping crime data from the most recent year

**What is the primary purpose of the `group_modify()` function in R?**

- To filter out specific groups in a grouped data frame
- To summarise grouped data into a single-row output per group
- To apply the same function to each group in a grouped data frame and return a modified data frame (Correct answer)
- To convert a grouped data frame into a list

**What is the `facet_grid()` function from the ggplot2 package used for?**

- To change the colour scheme of a ggplot visualisation
- To split a single plot into multiple panels based on a categorical variable (Correct answer)
- To overlay multiple datasets on a single plot
- To adjust the width and height of a single plot

Save `chapter_15a.R` by pressing . Your complete `chapter_15a.R` script should now look like this:

<a id="lst-mapping-time-complete-chapter-15a-script"></a>

<figure>
<pre><code>chapter_15a.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This script creates charts and maps showing how aggravated assaults in</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="co"># Chicago varied over time between 2010 and 2019</span></span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Load packages</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, httr2, sf, sfhotspot, slider, tidyverse)</span>
<span id="cb2-6"><a href="#cb2-6"></a></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="co"># LOAD DATA --------------------------------------------------------------------</span></span>
<span id="cb2-8"><a href="#cb2-8"></a></span>
<span id="cb2-9"><a href="#cb2-9"></a><span class="co"># Download the original data</span></span>
<span id="cb2-10"><a href="#cb2-10"></a><span class="fu">request</span>(</span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/chicago_aggravated_assaults.csv.gz&quot;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">req_perform</span>(</span>
<span id="cb2-14"><a href="#cb2-14"></a>    <span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;chicago_aggravated_assaults.csv.gz&quot;</span>)</span>
<span id="cb2-15"><a href="#cb2-15"></a>  )</span>
<span id="cb2-16"><a href="#cb2-16"></a></span>
<span id="cb2-17"><a href="#cb2-17"></a><span class="fu">request</span>(</span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/chicago_police_districts.kml&quot;</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;chicago_police_districts.kml&quot;</span>))</span>
<span id="cb2-21"><a href="#cb2-21"></a></span>
<span id="cb2-22"><a href="#cb2-22"></a><span class="co"># Load Chicago aggravated assault data</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>assaults <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;chicago_aggravated_assaults.csv.gz&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  <span class="fu">read_csv</span>(<span class="at">show_col_types =</span> <span class="cn">FALSE</span>)</span>
<span id="cb2-25"><a href="#cb2-25"></a></span>
<span id="cb2-26"><a href="#cb2-26"></a><span class="co"># Load dataset of Chicago Police Department (CPD) district boundaries</span></span>
<span id="cb2-27"><a href="#cb2-27"></a>cpd_districts <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;chicago_police_districts.kml&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-28"><a href="#cb2-28"></a>  <span class="fu">read_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-29"><a href="#cb2-29"></a>  janitor<span class="sc">::</span><span class="fu">clean_names</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-30"><a href="#cb2-30"></a>  <span class="co"># Transform this object to use a suitable local coordinate reference system</span></span>
<span id="cb2-31"><a href="#cb2-31"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:26916&quot;</span>)</span>
<span id="cb2-32"><a href="#cb2-32"></a></span>
<span id="cb2-33"><a href="#cb2-33"></a><span class="co"># Create a separate dataset holding just the boundaries of the three CPD</span></span>
<span id="cb2-34"><a href="#cb2-34"></a><span class="co"># districts covering the downtown area</span></span>
<span id="cb2-35"><a href="#cb2-35"></a>cpd_central <span class="ot">&lt;-</span> <span class="fu">filter</span>(cpd_districts, name <span class="sc">%in%</span> <span class="fu">c</span>(<span class="st">&quot;1&quot;</span>, <span class="st">&quot;12&quot;</span>, <span class="st">&quot;18&quot;</span>))</span>
<span id="cb2-36"><a href="#cb2-36"></a></span>
<span id="cb2-37"><a href="#cb2-37"></a><span class="co"># SHOW CHANGE OVER TIME --------------------------------------------------------</span></span>
<span id="cb2-38"><a href="#cb2-38"></a></span>
<span id="cb2-39"><a href="#cb2-39"></a><span class="co"># Count number of aggravated assaults each week</span></span>
<span id="cb2-40"><a href="#cb2-40"></a>assault_weekly_counts <span class="ot">&lt;-</span> assaults <span class="sc">|&gt;</span></span>
<span id="cb2-41"><a href="#cb2-41"></a>  <span class="co"># Convert offence dates so that it appears each offence happened on the first</span></span>
<span id="cb2-42"><a href="#cb2-42"></a>  <span class="co"># day (Sunday) of the week</span></span>
<span id="cb2-43"><a href="#cb2-43"></a>  <span class="fu">mutate</span>(<span class="at">week_date =</span> <span class="fu">floor_date</span>(<span class="fu">as_date</span>(date), <span class="at">unit =</span> <span class="st">&quot;week&quot;</span>)) <span class="sc">|&gt;</span></span>
<span id="cb2-44"><a href="#cb2-44"></a>  <span class="co"># Count the number of assaults each week</span></span>
<span id="cb2-45"><a href="#cb2-45"></a>  <span class="fu">count</span>(week_date, <span class="at">name =</span> <span class="st">&quot;count&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-46"><a href="#cb2-46"></a>  <span class="co"># The code `(n() - 1)` gives us the row number of the second-to-last row in</span></span>
<span id="cb2-47"><a href="#cb2-47"></a>  <span class="co"># the data because `n()` returns the number of rows in the data. Note the</span></span>
<span id="cb2-48"><a href="#cb2-48"></a>  <span class="co"># parentheses!</span></span>
<span id="cb2-49"><a href="#cb2-49"></a>  <span class="fu">slice</span>(<span class="dv">2</span><span class="sc">:</span>(<span class="fu">n</span>() <span class="sc">-</span> <span class="dv">1</span>))</span>
<span id="cb2-50"><a href="#cb2-50"></a></span>
<span id="cb2-51"><a href="#cb2-51"></a><span class="co"># Create plot of weekly assault counts with moving average</span></span>
<span id="cb2-52"><a href="#cb2-52"></a>assault_weekly_counts <span class="sc">|&gt;</span></span>
<span id="cb2-53"><a href="#cb2-53"></a>  <span class="co"># Calculate moving average</span></span>
<span id="cb2-54"><a href="#cb2-54"></a>  <span class="fu">mutate</span>(<span class="at">moving_avg =</span> <span class="fu">slide_dbl</span>(count, mean, <span class="at">.before =</span> <span class="dv">3</span>, <span class="at">.complete =</span> <span class="cn">TRUE</span>)) <span class="sc">|&gt;</span></span>
<span id="cb2-55"><a href="#cb2-55"></a>  <span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb2-56"><a href="#cb2-56"></a>  <span class="co"># Specify which columns in the data will control which parts of the chart</span></span>
<span id="cb2-57"><a href="#cb2-57"></a>  <span class="fu">aes</span>(<span class="at">x =</span> week_date) <span class="sc">+</span></span>
<span id="cb2-58"><a href="#cb2-58"></a>  <span class="co"># Add points showing weekly counts of assaults</span></span>
<span id="cb2-59"><a href="#cb2-59"></a>  <span class="fu">geom_point</span>(<span class="fu">aes</span>(<span class="at">y =</span> count), <span class="at">colour =</span> <span class="st">&quot;grey75&quot;</span>, <span class="at">size =</span> <span class="fl">0.75</span>) <span class="sc">+</span></span>
<span id="cb2-60"><a href="#cb2-60"></a>  <span class="co"># Add line showing moving average</span></span>
<span id="cb2-61"><a href="#cb2-61"></a>  <span class="fu">geom_line</span>(<span class="fu">aes</span>(<span class="at">y =</span> moving_avg), <span class="at">na.rm =</span> <span class="cn">TRUE</span>) <span class="sc">+</span></span>
<span id="cb2-62"><a href="#cb2-62"></a>  <span class="co"># Specify how dates should be shown on the x axis</span></span>
<span id="cb2-63"><a href="#cb2-63"></a>  <span class="fu">scale_x_date</span>(<span class="at">date_breaks =</span> <span class="st">&quot;1 year&quot;</span>, <span class="at">date_labels =</span> <span class="st">&quot;%Y&quot;</span>, <span class="at">expand =</span> <span class="fu">c</span>(<span class="dv">0</span>, <span class="dv">0</span>)) <span class="sc">+</span></span>
<span id="cb2-64"><a href="#cb2-64"></a>  <span class="co"># Make sure y axis starts at zero</span></span>
<span id="cb2-65"><a href="#cb2-65"></a>  <span class="fu">scale_y_continuous</span>(<span class="at">limits =</span> <span class="fu">c</span>(<span class="dv">0</span>, <span class="cn">NA</span>), <span class="at">expand =</span> <span class="fu">c</span>(<span class="dv">0</span>, <span class="dv">0</span>), <span class="at">position =</span> <span class="st">&quot;right&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-66"><a href="#cb2-66"></a>  <span class="co"># Add labels</span></span>
<span id="cb2-67"><a href="#cb2-67"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-68"><a href="#cb2-68"></a>    <span class="at">title =</span> <span class="st">&quot;Trend in aggravated assaults in Chicago&quot;</span>,</span>
<span id="cb2-69"><a href="#cb2-69"></a>    <span class="at">subtitle =</span> <span class="st">&quot;points show weekly counts, line shows four-week moving average&quot;</span>,</span>
<span id="cb2-70"><a href="#cb2-70"></a>    <span class="at">caption =</span> <span class="st">&quot;Data from Chicago Police Department&quot;</span>,</span>
<span id="cb2-71"><a href="#cb2-71"></a>    <span class="at">x =</span> <span class="cn">NULL</span>,</span>
<span id="cb2-72"><a href="#cb2-72"></a>    <span class="at">y =</span> <span class="st">&quot;weekly count of aggravated assaults&quot;</span></span>
<span id="cb2-73"><a href="#cb2-73"></a>  ) <span class="sc">+</span></span>
<span id="cb2-74"><a href="#cb2-74"></a>  <span class="fu">theme_minimal</span>() <span class="sc">+</span></span>
<span id="cb2-75"><a href="#cb2-75"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-76"><a href="#cb2-76"></a>    <span class="at">panel.grid.minor.x =</span> <span class="fu">element_blank</span>(),</span>
<span id="cb2-77"><a href="#cb2-77"></a>    <span class="at">plot.caption =</span> <span class="fu">element_text</span>(<span class="at">colour =</span> <span class="st">&quot;grey40&quot;</span>),</span>
<span id="cb2-78"><a href="#cb2-78"></a>    <span class="at">plot.caption.position =</span> <span class="st">&quot;plot&quot;</span></span>
<span id="cb2-79"><a href="#cb2-79"></a>  )</span>
<span id="cb2-80"><a href="#cb2-80"></a></span>
<span id="cb2-81"><a href="#cb2-81"></a><span class="co"># Create a seasonal plot of aggravated assaults</span></span>
<span id="cb2-82"><a href="#cb2-82"></a>assault_weekly_counts <span class="sc">|&gt;</span></span>
<span id="cb2-83"><a href="#cb2-83"></a>  <span class="fu">mutate</span>(</span>
<span id="cb2-84"><a href="#cb2-84"></a>    <span class="co"># Create an eight-week moving average</span></span>
<span id="cb2-85"><a href="#cb2-85"></a>    <span class="at">moving_avg =</span> <span class="fu">slide_dbl</span>(count, mean, <span class="at">.before =</span> <span class="dv">7</span>, <span class="at">.complete =</span> <span class="cn">TRUE</span>),</span>
<span id="cb2-86"><a href="#cb2-86"></a>    <span class="co"># Create a new column showing just the year</span></span>
<span id="cb2-87"><a href="#cb2-87"></a>    <span class="at">year =</span> <span class="fu">year</span>(week_date),</span>
<span id="cb2-88"><a href="#cb2-88"></a>    <span class="co"># By only specifying the `month` and `day` arguments to `make_date()` we</span></span>
<span id="cb2-89"><a href="#cb2-89"></a>    <span class="co"># will create a date in 1970 (the year that R uses by default), but that</span></span>
<span id="cb2-90"><a href="#cb2-90"></a>    <span class="co"># doesn&#39;t matter because we are not going to show the year on the chart</span></span>
<span id="cb2-91"><a href="#cb2-91"></a>    <span class="at">pseudo_date =</span> <span class="fu">make_date</span>(<span class="at">month =</span> <span class="fu">month</span>(week_date), <span class="at">day =</span> <span class="fu">mday</span>(week_date))</span>
<span id="cb2-92"><a href="#cb2-92"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-93"><a href="#cb2-93"></a>  <span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb2-94"><a href="#cb2-94"></a>  <span class="co"># Specify which columns in the data should control which parts of the chart</span></span>
<span id="cb2-95"><a href="#cb2-95"></a>  <span class="fu">aes</span>(<span class="at">x =</span> pseudo_date, <span class="at">y =</span> moving_avg, <span class="at">colour =</span> year, <span class="at">group =</span> year) <span class="sc">+</span></span>
<span id="cb2-96"><a href="#cb2-96"></a>  <span class="co"># Add lines</span></span>
<span id="cb2-97"><a href="#cb2-97"></a>  <span class="fu">geom_line</span>(<span class="at">na.rm =</span> <span class="cn">TRUE</span>) <span class="sc">+</span></span>
<span id="cb2-98"><a href="#cb2-98"></a>  <span class="co"># Specify how dates should be shown on the x axis</span></span>
<span id="cb2-99"><a href="#cb2-99"></a>  <span class="fu">scale_x_date</span>(<span class="at">date_breaks =</span> <span class="st">&quot;1 month&quot;</span>, <span class="at">date_labels =</span> <span class="st">&quot;%b&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-100"><a href="#cb2-100"></a>  <span class="co"># Make sure y axis starts at zero</span></span>
<span id="cb2-101"><a href="#cb2-101"></a>  <span class="fu">scale_y_continuous</span>(<span class="at">limits =</span> <span class="fu">c</span>(<span class="dv">0</span>, <span class="cn">NA</span>)) <span class="sc">+</span></span>
<span id="cb2-102"><a href="#cb2-102"></a>  <span class="co"># Specify that the legend should be labelled with whole numbers</span></span>
<span id="cb2-103"><a href="#cb2-103"></a>  <span class="fu">scale_colour_continuous</span>(<span class="at">breaks =</span> <span class="fu">c</span>(<span class="dv">2010</span>, <span class="dv">2013</span>, <span class="dv">2016</span>, <span class="dv">2019</span>)) <span class="sc">+</span></span>
<span id="cb2-104"><a href="#cb2-104"></a>  <span class="co"># Add labels</span></span>
<span id="cb2-105"><a href="#cb2-105"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-106"><a href="#cb2-106"></a>    <span class="at">x =</span> <span class="cn">NULL</span>,</span>
<span id="cb2-107"><a href="#cb2-107"></a>    <span class="at">y =</span> <span class="st">&quot;moving average of weekly count of aggravated assaults&quot;</span>,</span>
<span id="cb2-108"><a href="#cb2-108"></a>    <span class="at">colour =</span> <span class="cn">NULL</span></span>
<span id="cb2-109"><a href="#cb2-109"></a>  ) <span class="sc">+</span></span>
<span id="cb2-110"><a href="#cb2-110"></a>  <span class="fu">theme_minimal</span>() <span class="sc">+</span></span>
<span id="cb2-111"><a href="#cb2-111"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-112"><a href="#cb2-112"></a>    <span class="at">panel.grid.minor.x =</span> <span class="fu">element_blank</span>()</span>
<span id="cb2-113"><a href="#cb2-113"></a>  )</span>
<span id="cb2-114"><a href="#cb2-114"></a></span>
<span id="cb2-115"><a href="#cb2-115"></a><span class="co"># Create counts of assaults by hours of the day and week</span></span>
<span id="cb2-116"><a href="#cb2-116"></a>assault_hourly_counts <span class="ot">&lt;-</span> assaults <span class="sc">|&gt;</span></span>
<span id="cb2-117"><a href="#cb2-117"></a>  <span class="co"># Extract day of the week and hour of the day from the date column</span></span>
<span id="cb2-118"><a href="#cb2-118"></a>  <span class="fu">mutate</span>(<span class="at">wday =</span> <span class="fu">wday</span>(date, <span class="at">label =</span> <span class="cn">TRUE</span>), <span class="at">hour =</span> <span class="fu">hour</span>(date)) <span class="sc">|&gt;</span></span>
<span id="cb2-119"><a href="#cb2-119"></a>  <span class="co"># Count crimes for each hour of each day of the week</span></span>
<span id="cb2-120"><a href="#cb2-120"></a>  <span class="fu">count</span>(wday, hour, <span class="at">name =</span> <span class="st">&quot;count&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-121"><a href="#cb2-121"></a>  <span class="co"># By only setting the `hour` argument to `make_datetime()` we will create a</span></span>
<span id="cb2-122"><a href="#cb2-122"></a>  <span class="co"># date-time on 1 January 1970, but that doesn&#39;t matter because we will not</span></span>
<span id="cb2-123"><a href="#cb2-123"></a>  <span class="co"># show the date on the chart</span></span>
<span id="cb2-124"><a href="#cb2-124"></a>  <span class="fu">mutate</span>(<span class="at">pseudo_date =</span> <span class="fu">make_datetime</span>(<span class="at">hour =</span> hour))</span>
<span id="cb2-125"><a href="#cb2-125"></a></span>
<span id="cb2-126"><a href="#cb2-126"></a><span class="co"># Create chart of assaults by hour of the day for each day of the week</span></span>
<span id="cb2-127"><a href="#cb2-127"></a>assault_hourly_counts <span class="sc">|&gt;</span></span>
<span id="cb2-128"><a href="#cb2-128"></a>  <span class="co"># Create a new column specifying if each day is a weekday or weekend</span></span>
<span id="cb2-129"><a href="#cb2-129"></a>  <span class="fu">mutate</span>(<span class="at">weekend =</span> <span class="fu">if_else</span>(wday <span class="sc">%in%</span> <span class="fu">c</span>(<span class="st">&quot;Sat&quot;</span>, <span class="st">&quot;Sun&quot;</span>), <span class="st">&quot;Sat–Sun&quot;</span>, <span class="st">&quot;Mon–Fri&quot;</span>)) <span class="sc">|&gt;</span></span>
<span id="cb2-130"><a href="#cb2-130"></a>  <span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb2-131"><a href="#cb2-131"></a>  <span class="co"># Specify which columns in the data should control each part of the chart</span></span>
<span id="cb2-132"><a href="#cb2-132"></a>  <span class="fu">aes</span>(<span class="at">x =</span> pseudo_date, <span class="at">y =</span> count, <span class="at">colour =</span> wday) <span class="sc">+</span></span>
<span id="cb2-133"><a href="#cb2-133"></a>  <span class="co"># Add lines</span></span>
<span id="cb2-134"><a href="#cb2-134"></a>  <span class="fu">geom_line</span>(<span class="at">linewidth =</span> <span class="dv">1</span>) <span class="sc">+</span></span>
<span id="cb2-135"><a href="#cb2-135"></a>  <span class="co"># Assign the facets to rows so that we can compare the same time on different</span></span>
<span id="cb2-136"><a href="#cb2-136"></a>  <span class="co"># days more easily (change `rows` to `cols` to see the alternative)</span></span>
<span id="cb2-137"><a href="#cb2-137"></a>  <span class="fu">facet_grid</span>(<span class="at">rows =</span> <span class="fu">vars</span>(weekend)) <span class="sc">+</span></span>
<span id="cb2-138"><a href="#cb2-138"></a>  <span class="co"># Specify how dates should be shown on the x axis</span></span>
<span id="cb2-139"><a href="#cb2-139"></a>  <span class="fu">scale_x_datetime</span>(<span class="at">date_breaks =</span> <span class="st">&quot;2 hours&quot;</span>, <span class="at">date_labels =</span> <span class="st">&quot;%H:%M&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-140"><a href="#cb2-140"></a>  <span class="co"># Make sure y axis starts at zero and labels have thousands separators</span></span>
<span id="cb2-141"><a href="#cb2-141"></a>  <span class="fu">scale_y_continuous</span>(<span class="at">limits =</span> <span class="fu">c</span>(<span class="dv">0</span>, <span class="cn">NA</span>), <span class="at">labels =</span> scales<span class="sc">::</span><span class="fu">comma_format</span>()) <span class="sc">+</span></span>
<span id="cb2-142"><a href="#cb2-142"></a>  <span class="co"># Specify a qualitative colour scheme should be used</span></span>
<span id="cb2-143"><a href="#cb2-143"></a>  <span class="fu">scale_colour_brewer</span>(<span class="at">type =</span> <span class="st">&quot;qual&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-144"><a href="#cb2-144"></a>  <span class="co"># Add labels</span></span>
<span id="cb2-145"><a href="#cb2-145"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-146"><a href="#cb2-146"></a>    <span class="at">x =</span> <span class="cn">NULL</span>,</span>
<span id="cb2-147"><a href="#cb2-147"></a>    <span class="at">y =</span> <span class="st">&quot;hourly total of aggravated assaults, 2010–2019&quot;</span>,</span>
<span id="cb2-148"><a href="#cb2-148"></a>    <span class="at">fill =</span> <span class="cn">NULL</span></span>
<span id="cb2-149"><a href="#cb2-149"></a>  ) <span class="sc">+</span></span>
<span id="cb2-150"><a href="#cb2-150"></a>  <span class="fu">theme_minimal</span>()</span>
<span id="cb2-151"><a href="#cb2-151"></a></span>
<span id="cb2-152"><a href="#cb2-152"></a><span class="co"># MAP CHANGE OVER TIME ---------------------------------------------------------</span></span>
<span id="cb2-153"><a href="#cb2-153"></a></span>
<span id="cb2-154"><a href="#cb2-154"></a><span class="co"># Calculate number of assaults by shift</span></span>
<span id="cb2-155"><a href="#cb2-155"></a>assaults_by_shift <span class="ot">&lt;-</span> assaults <span class="sc">|&gt;</span></span>
<span id="cb2-156"><a href="#cb2-156"></a>  <span class="co"># Restrict counts to just the central area of Chicago</span></span>
<span id="cb2-157"><a href="#cb2-157"></a>  <span class="fu">filter</span>(district <span class="sc">%in%</span> <span class="fu">c</span>(<span class="dv">1</span>, <span class="dv">12</span>, <span class="dv">18</span>)) <span class="sc">|&gt;</span></span>
<span id="cb2-158"><a href="#cb2-158"></a>  <span class="fu">mutate</span>(</span>
<span id="cb2-159"><a href="#cb2-159"></a>    <span class="at">shift =</span> <span class="fu">case_when</span>(</span>
<span id="cb2-160"><a href="#cb2-160"></a>      <span class="fu">between</span>(<span class="fu">hour</span>(date), <span class="dv">6</span>, <span class="dv">13</span>) <span class="sc">~</span> <span class="st">&quot;06:00 to 13:59&quot;</span>,</span>
<span id="cb2-161"><a href="#cb2-161"></a>      <span class="fu">between</span>(<span class="fu">hour</span>(date), <span class="dv">14</span>, <span class="dv">21</span>) <span class="sc">~</span> <span class="st">&quot;14:00 to 21:59&quot;</span>,</span>
<span id="cb2-162"><a href="#cb2-162"></a>      <span class="fu">hour</span>(date) <span class="sc">&gt;=</span> <span class="dv">22</span> <span class="sc">|</span> <span class="fu">hour</span>(date) <span class="sc">&lt;</span> <span class="dv">6</span> <span class="sc">~</span> <span class="st">&quot;22:00 to 05:59&quot;</span>,</span>
<span id="cb2-163"><a href="#cb2-163"></a>      <span class="cn">TRUE</span> <span class="sc">~</span> <span class="cn">NA</span></span>
<span id="cb2-164"><a href="#cb2-164"></a>    )</span>
<span id="cb2-165"><a href="#cb2-165"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-166"><a href="#cb2-166"></a>  <span class="co"># Convert the data to an SF object</span></span>
<span id="cb2-167"><a href="#cb2-167"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;longitude&quot;</span>, <span class="st">&quot;latitude&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:4326&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-168"><a href="#cb2-168"></a>  <span class="co"># Transform it to a coordinate reference system based on metres</span></span>
<span id="cb2-169"><a href="#cb2-169"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:26916&quot;</span>)</span>
<span id="cb2-170"><a href="#cb2-170"></a></span>
<span id="cb2-171"><a href="#cb2-171"></a><span class="co"># Create a grid to be used for every shift-specific KDE layer</span></span>
<span id="cb2-172"><a href="#cb2-172"></a>grid <span class="ot">&lt;-</span> <span class="fu">hotspot_grid</span>(cpd_central, <span class="at">cell_size =</span> <span class="dv">200</span>)</span>
<span id="cb2-173"><a href="#cb2-173"></a></span>
<span id="cb2-174"><a href="#cb2-174"></a><span class="co"># Estimate density of assaults for each CPD shift</span></span>
<span id="cb2-175"><a href="#cb2-175"></a>kde_by_shift <span class="ot">&lt;-</span> assaults_by_shift <span class="sc">|&gt;</span></span>
<span id="cb2-176"><a href="#cb2-176"></a>  <span class="co"># Group dataset by which shift the assaults occurred in</span></span>
<span id="cb2-177"><a href="#cb2-177"></a>  <span class="fu">group_by</span>(shift) <span class="sc">|&gt;</span></span>
<span id="cb2-178"><a href="#cb2-178"></a>  <span class="co"># Separately estimate density of assaults for each shift</span></span>
<span id="cb2-179"><a href="#cb2-179"></a>  <span class="fu">group_modify</span>(</span>
<span id="cb2-180"><a href="#cb2-180"></a>    \(x, ...) <span class="fu">hotspot_kde</span>(x, <span class="at">grid =</span> grid, <span class="at">bandwidth_adjust =</span> <span class="fl">0.5</span>, <span class="at">quiet =</span> <span class="cn">TRUE</span>)</span>
<span id="cb2-181"><a href="#cb2-181"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-182"><a href="#cb2-182"></a>  <span class="co"># Ungroup the dataset</span></span>
<span id="cb2-183"><a href="#cb2-183"></a>  <span class="fu">ungroup</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-184"><a href="#cb2-184"></a>  <span class="co"># Convert the result to an SF object (because although `hotspot_kde()` returns</span></span>
<span id="cb2-185"><a href="#cb2-185"></a>  <span class="co"># an SF object, `group_modify()` silently converts it to a tibble)</span></span>
<span id="cb2-186"><a href="#cb2-186"></a>  <span class="fu">st_as_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-187"><a href="#cb2-187"></a>  <span class="co"># Clip the result to the boundary of the three central police districts</span></span>
<span id="cb2-188"><a href="#cb2-188"></a>  <span class="fu">hotspot_clip</span>(cpd_central, <span class="at">quiet =</span> <span class="cn">TRUE</span>)</span>
<span id="cb2-189"><a href="#cb2-189"></a></span>
<span id="cb2-190"><a href="#cb2-190"></a><span class="co"># Create new dataset containing just the cells in each shift with the highest</span></span>
<span id="cb2-191"><a href="#cb2-191"></a><span class="co"># KDE values</span></span>
<span id="cb2-192"><a href="#cb2-192"></a>kde_shift_highest <span class="ot">&lt;-</span> kde_by_shift <span class="sc">|&gt;</span></span>
<span id="cb2-193"><a href="#cb2-193"></a>  <span class="fu">group_by</span>(shift) <span class="sc">|&gt;</span></span>
<span id="cb2-194"><a href="#cb2-194"></a>  <span class="fu">slice_max</span>(<span class="at">order_by =</span> kde, <span class="at">n =</span> <span class="dv">10</span>)</span>
<span id="cb2-195"><a href="#cb2-195"></a></span>
<span id="cb2-196"><a href="#cb2-196"></a><span class="co"># Add density map of assaults by shift</span></span>
<span id="cb2-197"><a href="#cb2-197"></a><span class="fu">hotspot_map</span>(</span>
<span id="cb2-198"><a href="#cb2-198"></a>  kde_by_shift,</span>
<span id="cb2-199"><a href="#cb2-199"></a>  <span class="fu">aes</span>(<span class="at">fill =</span> kde),</span>
<span id="cb2-200"><a href="#cb2-200"></a>  <span class="at">colour =</span> <span class="cn">NA</span>,</span>
<span id="cb2-201"><a href="#cb2-201"></a>  <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>,</span>
<span id="cb2-202"><a href="#cb2-202"></a>  <span class="at">caption =</span> <span class="st">&quot;Crime data from Chicago Police Department&quot;</span></span>
<span id="cb2-203"><a href="#cb2-203"></a>) <span class="sc">+</span></span>
<span id="cb2-204"><a href="#cb2-204"></a>  <span class="co"># Highlight the cells with the highest density in each shift</span></span>
<span id="cb2-205"><a href="#cb2-205"></a>  <span class="fu">geom_sf</span>(</span>
<span id="cb2-206"><a href="#cb2-206"></a>    <span class="at">data =</span> kde_shift_highest,</span>
<span id="cb2-207"><a href="#cb2-207"></a>    <span class="at">alpha =</span> <span class="fl">0.75</span>,</span>
<span id="cb2-208"><a href="#cb2-208"></a>    <span class="at">colour =</span> <span class="st">&quot;red2&quot;</span>,</span>
<span id="cb2-209"><a href="#cb2-209"></a>    <span class="at">fill =</span> <span class="cn">NA</span>,</span>
<span id="cb2-210"><a href="#cb2-210"></a>    <span class="at">linewidth =</span> <span class="dv">1</span></span>
<span id="cb2-211"><a href="#cb2-211"></a>  ) <span class="sc">+</span></span>
<span id="cb2-212"><a href="#cb2-212"></a>  <span class="co"># Add district boundaries</span></span>
<span id="cb2-213"><a href="#cb2-213"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> cpd_central, <span class="at">colour =</span> <span class="st">&quot;grey33&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-214"><a href="#cb2-214"></a>  <span class="co"># Add scale to control fill colour of KDE cells</span></span>
<span id="cb2-215"><a href="#cb2-215"></a>  <span class="fu">scale_fill_distiller</span>(</span>
<span id="cb2-216"><a href="#cb2-216"></a>    <span class="at">direction =</span> <span class="dv">1</span>,</span>
<span id="cb2-217"><a href="#cb2-217"></a>    <span class="at">breaks =</span> <span class="fu">range</span>(<span class="fu">pull</span>(kde_by_shift, kde)),</span>
<span id="cb2-218"><a href="#cb2-218"></a>    <span class="at">labels =</span> <span class="fu">c</span>(<span class="st">&quot;low&quot;</span>, <span class="st">&quot;high&quot;</span>),</span>
<span id="cb2-219"><a href="#cb2-219"></a>  ) <span class="sc">+</span></span>
<span id="cb2-220"><a href="#cb2-220"></a>  <span class="co"># Specify a separate map for each shift</span></span>
<span id="cb2-221"><a href="#cb2-221"></a>  <span class="fu">facet_grid</span>(<span class="at">cols =</span> <span class="fu">vars</span>(shift)) <span class="sc">+</span></span>
<span id="cb2-222"><a href="#cb2-222"></a>  <span class="co"># Add labels</span></span>
<span id="cb2-223"><a href="#cb2-223"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-224"><a href="#cb2-224"></a>    <span class="at">title =</span> <span class="st">&quot;Aggravated assaults in downtown Chicago, 2010–2019&quot;</span>,</span>
<span id="cb2-225"><a href="#cb2-225"></a>    <span class="at">fill =</span> <span class="st">&quot;density of aggravated assaults&quot;</span></span>
<span id="cb2-226"><a href="#cb2-226"></a>  ) <span class="sc">+</span></span>
<span id="cb2-227"><a href="#cb2-227"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-228"><a href="#cb2-228"></a>    <span class="at">legend.position =</span> <span class="st">&quot;bottom&quot;</span>,</span>
<span id="cb2-229"><a href="#cb2-229"></a>    <span class="at">legend.title =</span> <span class="fu">element_text</span>(<span class="at">hjust =</span> <span class="dv">1</span>)</span>
<span id="cb2-230"><a href="#cb2-230"></a>  )</span></code></pre></div>
<figcaption>Code 15.33</figcaption>
</figure>

<a id="making-animated-maps"></a>

## 15.6 Making animated maps

The small-multiple map we have produced of aggravated-assault hotspots in Chicago is useful, especially for policing because it uses periods based on police shifts. But aggregating crimes into only three temporal periods inevitably throws away a lot of information about when crime happens. For example, at what time of night does the area of highest assault density move across the river from The Loop to River North?

We could produce a series of small-multiple maps showing shorter periods (meaning more small multiples). For example, we could show one small-multiple map for each hour of the day. However, this would make each map very small and it would be hard to see the details of locations on each map.

One alternative is to produce an animated map with each frame in the animation representing the map for each hour. We can do this using the [gganimate package](https://gganimate.com/).

The first step in producing an animated map is to create a KDE layer for each hour of the day. The code for this is the same as for the code we have already used to produce the KDE layers for each shift, except that we create a variable for hour of the day rather than police shift. Because an animated map of hours of the day needs 24 KDE layers, in this case it is particularly useful to use `group_modify()` to avoid having to create 24 different objects and then binding them together.

Since the code to make animated maps is quite long, and our script file is fairly long already, let's start a new script file to store the code needed to make an animated map. Start a new R session by clicking the **Restart R** (**⟳**) button in the **Console** panel, then create `chapter_15b.R` in the `R` folder of your `crime_mapping` workspace.

Copy this code into that file and run the code. There is quite a lot of code here, but it builds on the code from [Section 15.5](#sec-map-change-over-time).

ImportantThis code will take a while to run

This code estimates the density of crime in each grid cell 24 times (once for each hour of the day) so it is likely the code will take a few minutes to run. How long it takes to run will depend on the speed of your computer.

<a id="lst-mapping-time-prepare-hourly-kde-code"></a>

<figure>
<pre><code>chapter_15b.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This script creates an animated map showing how the density of aggravated</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="co"># assaults in downtown Chicago varied by hour between 2010 and 2019</span></span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Load packages</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(gganimate, here, httr2, sf, sfhotspot, tidyverse)</span>
<span id="cb2-6"><a href="#cb2-6"></a></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="co"># LOAD DATA --------------------------------------------------------------------</span></span>
<span id="cb2-8"><a href="#cb2-8"></a></span>
<span id="cb2-9"><a href="#cb2-9"></a><span class="co"># Download the original data</span></span>
<span id="cb2-10"><a href="#cb2-10"></a><span class="fu">request</span>(</span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/chicago_aggravated_assaults.csv.gz&quot;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">req_perform</span>(</span>
<span id="cb2-14"><a href="#cb2-14"></a>    <span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;chicago_aggravated_assaults.csv.gz&quot;</span>)</span>
<span id="cb2-15"><a href="#cb2-15"></a>  )</span>
<span id="cb2-16"><a href="#cb2-16"></a></span>
<span id="cb2-17"><a href="#cb2-17"></a><span class="fu">request</span>(</span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/chicago_police_districts.kml&quot;</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;chicago_police_districts.kml&quot;</span>))</span>
<span id="cb2-21"><a href="#cb2-21"></a></span>
<span id="cb2-22"><a href="#cb2-22"></a><span class="co"># Load Chicago aggravated assault data</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>assaults <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;chicago_aggravated_assaults.csv.gz&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  <span class="fu">read_csv</span>(<span class="at">show_col_types =</span> <span class="cn">FALSE</span>)</span>
<span id="cb2-25"><a href="#cb2-25"></a></span>
<span id="cb2-26"><a href="#cb2-26"></a><span class="co"># Load dataset of Chicago Police Department (CPD) district boundaries</span></span>
<span id="cb2-27"><a href="#cb2-27"></a>cpd_districts <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;chicago_police_districts.kml&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-28"><a href="#cb2-28"></a>  <span class="fu">read_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-29"><a href="#cb2-29"></a>  janitor<span class="sc">::</span><span class="fu">clean_names</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-30"><a href="#cb2-30"></a>  <span class="co"># Transform this object to use a suitable local coordinate reference system</span></span>
<span id="cb2-31"><a href="#cb2-31"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:26916&quot;</span>)</span>
<span id="cb2-32"><a href="#cb2-32"></a></span>
<span id="cb2-33"><a href="#cb2-33"></a><span class="co"># Create a separate dataset holding just the boundaries of the three CPD</span></span>
<span id="cb2-34"><a href="#cb2-34"></a><span class="co"># districts covering the downtown area</span></span>
<span id="cb2-35"><a href="#cb2-35"></a>cpd_central <span class="ot">&lt;-</span> <span class="fu">filter</span>(cpd_districts, name <span class="sc">%in%</span> <span class="fu">c</span>(<span class="st">&quot;1&quot;</span>, <span class="st">&quot;12&quot;</span>, <span class="st">&quot;18&quot;</span>))</span>
<span id="cb2-36"><a href="#cb2-36"></a></span>
<span id="cb2-37"><a href="#cb2-37"></a></span>
<span id="cb2-38"><a href="#cb2-38"></a><span class="co"># WRANGLE DATA -----------------------------------------------------------------</span></span>
<span id="cb2-39"><a href="#cb2-39"></a></span>
<span id="cb2-40"><a href="#cb2-40"></a><span class="co"># Create a version of the dataset with a column showing which hour the assault</span></span>
<span id="cb2-41"><a href="#cb2-41"></a><span class="co"># occurred in</span></span>
<span id="cb2-42"><a href="#cb2-42"></a>assaults_by_hour <span class="ot">&lt;-</span> assaults <span class="sc">|&gt;</span></span>
<span id="cb2-43"><a href="#cb2-43"></a>  <span class="co"># Keep only the CPD districts in downtown Chicago we are interested in</span></span>
<span id="cb2-44"><a href="#cb2-44"></a>  <span class="fu">filter</span>(district <span class="sc">%in%</span> <span class="fu">c</span>(<span class="dv">1</span>, <span class="dv">12</span>, <span class="dv">18</span>)) <span class="sc">|&gt;</span></span>
<span id="cb2-45"><a href="#cb2-45"></a>  <span class="co"># Create nicely formatted labels to represent each hour</span></span>
<span id="cb2-46"><a href="#cb2-46"></a>  <span class="fu">mutate</span>(</span>
<span id="cb2-47"><a href="#cb2-47"></a>    <span class="at">hour_name =</span> <span class="fu">str_pad</span>(<span class="fu">hour</span>(date), <span class="at">width =</span> <span class="dv">2</span>, <span class="at">pad =</span> <span class="st">&quot;0&quot;</span>),</span>
<span id="cb2-48"><a href="#cb2-48"></a>    <span class="at">hour_name =</span> <span class="fu">str_glue</span>(<span class="st">&quot;{hour_name}:00 to {hour_name}:59&quot;</span>)</span>
<span id="cb2-49"><a href="#cb2-49"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-50"><a href="#cb2-50"></a>  <span class="co"># Convert the data to an SF object</span></span>
<span id="cb2-51"><a href="#cb2-51"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;longitude&quot;</span>, <span class="st">&quot;latitude&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:4326&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-52"><a href="#cb2-52"></a>  <span class="co"># Convert the data to a suitable coordinate system for Chicago</span></span>
<span id="cb2-53"><a href="#cb2-53"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:26916&quot;</span>)</span>
<span id="cb2-54"><a href="#cb2-54"></a></span>
<span id="cb2-55"><a href="#cb2-55"></a><span class="co"># Create a grid to be used by all the KDE layers, otherwise `hotspot_kde()` will</span></span>
<span id="cb2-56"><a href="#cb2-56"></a><span class="co"># generate each grid based on the convex hull of the assaults occurring in each</span></span>
<span id="cb2-57"><a href="#cb2-57"></a><span class="co"># hour and each grid will be slightly different (which would make the animation</span></span>
<span id="cb2-58"><a href="#cb2-58"></a><span class="co"># flicker)</span></span>
<span id="cb2-59"><a href="#cb2-59"></a>grid <span class="ot">&lt;-</span> <span class="fu">hotspot_grid</span>(cpd_central, <span class="at">cell_size =</span> <span class="dv">200</span>)</span>
<span id="cb2-60"><a href="#cb2-60"></a></span>
<span id="cb2-61"><a href="#cb2-61"></a><span class="co"># Calculate KDE layer for each hour of the day</span></span>
<span id="cb2-62"><a href="#cb2-62"></a>hour_layers <span class="ot">&lt;-</span> assaults_by_hour <span class="sc">|&gt;</span></span>
<span id="cb2-63"><a href="#cb2-63"></a>  <span class="fu">group_by</span>(hour_name) <span class="sc">|&gt;</span></span>
<span id="cb2-64"><a href="#cb2-64"></a>  <span class="fu">group_modify</span>(</span>
<span id="cb2-65"><a href="#cb2-65"></a>    \(x, ...) <span class="fu">hotspot_kde</span>(x, <span class="at">grid =</span> grid, <span class="at">bandwidth_adjust =</span> <span class="fl">0.5</span>, <span class="at">quiet =</span> <span class="cn">TRUE</span>)</span>
<span id="cb2-66"><a href="#cb2-66"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-67"><a href="#cb2-67"></a>  <span class="fu">ungroup</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-68"><a href="#cb2-68"></a>  <span class="fu">st_as_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-69"><a href="#cb2-69"></a>  <span class="fu">hotspot_clip</span>(cpd_central, <span class="at">quiet =</span> <span class="cn">TRUE</span>)</span>
<span id="cb2-70"><a href="#cb2-70"></a></span>
<span id="cb2-71"><a href="#cb2-71"></a><span class="co"># Extract only the 10 cells with the highest density in each hour</span></span>
<span id="cb2-72"><a href="#cb2-72"></a>hour_highest <span class="ot">&lt;-</span> hour_layers <span class="sc">|&gt;</span></span>
<span id="cb2-73"><a href="#cb2-73"></a>  <span class="fu">group_by</span>(hour_name) <span class="sc">|&gt;</span></span>
<span id="cb2-74"><a href="#cb2-74"></a>  <span class="fu">slice_max</span>(<span class="at">order_by =</span> kde, <span class="at">n =</span> <span class="dv">10</span>)</span></code></pre></div>
<figcaption>Code 15.34</figcaption>
</figure>

    <httr2_response>
    GET https://mpjashby.github.io/crimemappingdata/chicago_aggravated_assaults.csv.gz
    Status: 200 OK
    Content-Type: application/gzip
    Body: On disk '/Users/mattashby/Documents/Crime Mapping Book/data/raw/chicago_aggravated_assaults.csv.gz' (1444320 bytes)

    <httr2_response>
    GET https://mpjashby.github.io/crimemappingdata/chicago_police_districts.kml
    Status: 200 OK
    Content-Type: application/vnd.google-earth.kml+xml
    Body: On disk '/Users/mattashby/Documents/Crime Mapping Book/data/raw/chicago_police_districts.kml' (967244 bytes)

To create an animated map using the `hour_layers` and `hour_highest` objects, we use the `transition_states()` function from the gganimate package. `transition_states()` works in a similar way to `facet_grid()`, in that when added to a `ggplot()` stack it splits the chart or map up into a separate map for each value of one of the variables in the data (in this case, the hour of the day). The only difference is that while `facet_grid()` arranges those separate maps next to one another, `transition_states()` arranges them into an animation.

Add this code to your script file and run it.

<a id="lst-mapping-time-build-animated-assault-map"></a>

<figure>
<pre><code>chapter_15b.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># CREATE AND SAVE ANIMATION ----------------------------------------------------</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a>chicago_downtown_kde_map <span class="ot">&lt;-</span> <span class="fu">hotspot_map</span>(</span>
<span id="cb2-4"><a href="#cb2-4"></a>  hour_layers,</span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>,</span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="at">caption =</span> <span class="st">&quot;Crime data from Chicago Police Department&quot;</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>) <span class="sc">+</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="co"># Add layer showing cells with highest density of assaults</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> hour_highest, <span class="at">alpha =</span> <span class="fl">0.75</span>, <span class="at">colour =</span> <span class="st">&quot;red2&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="co"># Add CPD district boundaries</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> cpd_central, <span class="at">colour =</span> <span class="st">&quot;grey33&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="co"># Specify that each hour should be a separate frame in an animation</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">transition_states</span>(<span class="at">states =</span> hour_name) <span class="sc">+</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="co"># Add labels</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-16"><a href="#cb2-16"></a>    <span class="at">title =</span> <span class="st">&quot;Aggravated assaults in downtown Chicago, 2010–2019&quot;</span>,</span>
<span id="cb2-17"><a href="#cb2-17"></a>    <span class="at">subtitle =</span> <span class="st">&quot;Areas with most aggravated assaults:</span><span class="sc">\n</span><span class="st">{closest_state}&quot;</span>,</span>
<span id="cb2-18"><a href="#cb2-18"></a>    <span class="at">fill =</span> <span class="st">&quot;density of</span><span class="sc">\n</span><span class="st">aggravated</span><span class="sc">\n</span><span class="st">assaults&quot;</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>  )</span></code></pre></div>
<figcaption>Code 15.35</figcaption>
</figure>

There is one other feature of gganimate we have used in the code used to make this map. You might have noticed that in the map `subtitle` is the code `{closest_state}`. This is a special code that gganimate will replace with the current value of the variable in the data that is used to control which facet appears in each frame of the animation. So for this map, `{closest_state}` will be replaced in the animation with the value of the `hour_name` variable in the data for each frame in the animation.

One difference between animated maps and the static maps we created in [Section 15.5](#sec-map-change-over-time) is that most of the controls that influence how a map is animated are not contained in a function we add to the `ggplot()` stack, but are instead included in the separate `animate()` function. `animate()` takes a `ggplot()` stack that includes the `transition_states()` function and converts it into the final animation. Among other things, `animate()` controls the type of file the animation will be saved in (by default, an animated GIF), the height and width of the plot and so on.

One important element that is controlled by `animate()` is the speed of the animation. Controlling the length of the animation is important because if the animation is too quick, it will be hard for readers to see where the hotspots in each hour are. The `fps` (*frames per second*) argument can be used to control how quickly the animation moves between each state (in this case, each hour). For a fixed number of frames, a lower value of `fps` makes the animation slower and longer, while a higher value makes it faster and shorter. The default is 10 frames per second, so using `fps = 2` makes the animation five times longer than the default.

We can save an animated map to a file by using `animate()` together with the `anim_save()` function. `anim_save()` saves the animation created by `animate()` in a file. For example, if we stored the map created in [Code 15.35](#lst-mapping-time-build-animated-assault-map) in an object called `chicago_downtown_kde_map`, we could save it to an animated GIF file.

<a id="lst-mapping-time-save-animated-assault-map"></a>

<figure>
<pre><code>chapter_15b.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">anim_save</span>(</span>
<span id="cb2-2"><a href="#cb2-2"></a>  <span class="at">filename =</span> <span class="fu">here</span>(<span class="st">&quot;output&quot;</span>, <span class="st">&quot;chicago_downtown_agg_assaults.gif&quot;</span>),</span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="at">animation =</span> <span class="fu">animate</span>(</span>
<span id="cb2-4"><a href="#cb2-4"></a>    <span class="at">plot =</span> chicago_downtown_kde_map,</span>
<span id="cb2-5"><a href="#cb2-5"></a>    <span class="at">fps =</span> <span class="dv">2</span>,</span>
<span id="cb2-6"><a href="#cb2-6"></a>    <span class="at">height =</span> <span class="dv">800</span>,</span>
<span id="cb2-7"><a href="#cb2-7"></a>    <span class="at">width =</span> <span class="dv">800</span>,</span>
<span id="cb2-8"><a href="#cb2-8"></a>    <span class="at">units =</span> <span class="st">&quot;px&quot;</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>  )</span>
<span id="cb2-10"><a href="#cb2-10"></a>)</span></code></pre></div>
<figcaption>Code 15.36</figcaption>
</figure>

QuizAnimated maps

**What kind of crime data benefits most from being shown on an animated map?**

- Crimes that do not have clear temporal patterns
- Crimes with clear time-based patterns (Correct answer)
- Crimes that only occur indoors
- Crimes that have no spatial component

**Which of these considerations is particularly important when making animated maps?**

- The speed of the animation (Correct answer)
- The number of colours used in the background
- The exact GPS coordinates of each crime
- The type of crime, but not when it happened

**What is an alternative to using an animated map for temporal crime analysis?**

- A single static crime map
- Ignoring time in crime analysis
- A series of maps showing different time periods (Correct answer)
- Using a bar chart instead

Save `chapter_15b.R` by pressing . Your complete `chapter_15b.R` script should now look like this:

<a id="lst-mapping-time-complete-chapter-15b-script"></a>

<figure>
<pre><code>chapter_15b.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This script creates an animated map showing how the density of aggravated</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="co"># assaults in downtown Chicago varied by hour between 2010 and 2019</span></span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Load packages</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(gganimate, here, httr2, sf, sfhotspot, tidyverse)</span>
<span id="cb2-6"><a href="#cb2-6"></a></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="co"># LOAD DATA --------------------------------------------------------------------</span></span>
<span id="cb2-8"><a href="#cb2-8"></a></span>
<span id="cb2-9"><a href="#cb2-9"></a><span class="co"># Download the original data</span></span>
<span id="cb2-10"><a href="#cb2-10"></a><span class="fu">request</span>(</span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/chicago_aggravated_assaults.csv.gz&quot;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">req_perform</span>(</span>
<span id="cb2-14"><a href="#cb2-14"></a>    <span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;chicago_aggravated_assaults.csv.gz&quot;</span>)</span>
<span id="cb2-15"><a href="#cb2-15"></a>  )</span>
<span id="cb2-16"><a href="#cb2-16"></a></span>
<span id="cb2-17"><a href="#cb2-17"></a><span class="fu">request</span>(</span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/chicago_police_districts.kml&quot;</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;chicago_police_districts.kml&quot;</span>))</span>
<span id="cb2-21"><a href="#cb2-21"></a></span>
<span id="cb2-22"><a href="#cb2-22"></a><span class="co"># Load Chicago aggravated assault data</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>assaults <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;chicago_aggravated_assaults.csv.gz&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  <span class="fu">read_csv</span>(<span class="at">show_col_types =</span> <span class="cn">FALSE</span>)</span>
<span id="cb2-25"><a href="#cb2-25"></a></span>
<span id="cb2-26"><a href="#cb2-26"></a><span class="co"># Load dataset of Chicago Police Department (CPD) district boundaries</span></span>
<span id="cb2-27"><a href="#cb2-27"></a>cpd_districts <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;chicago_police_districts.kml&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-28"><a href="#cb2-28"></a>  <span class="fu">read_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-29"><a href="#cb2-29"></a>  janitor<span class="sc">::</span><span class="fu">clean_names</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-30"><a href="#cb2-30"></a>  <span class="co"># Transform this object to use a suitable local coordinate reference system</span></span>
<span id="cb2-31"><a href="#cb2-31"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:26916&quot;</span>)</span>
<span id="cb2-32"><a href="#cb2-32"></a></span>
<span id="cb2-33"><a href="#cb2-33"></a><span class="co"># Create a separate dataset holding just the boundaries of the three CPD</span></span>
<span id="cb2-34"><a href="#cb2-34"></a><span class="co"># districts covering the downtown area</span></span>
<span id="cb2-35"><a href="#cb2-35"></a>cpd_central <span class="ot">&lt;-</span> <span class="fu">filter</span>(cpd_districts, name <span class="sc">%in%</span> <span class="fu">c</span>(<span class="st">&quot;1&quot;</span>, <span class="st">&quot;12&quot;</span>, <span class="st">&quot;18&quot;</span>))</span>
<span id="cb2-36"><a href="#cb2-36"></a></span>
<span id="cb2-37"><a href="#cb2-37"></a></span>
<span id="cb2-38"><a href="#cb2-38"></a><span class="co"># WRANGLE DATA -----------------------------------------------------------------</span></span>
<span id="cb2-39"><a href="#cb2-39"></a></span>
<span id="cb2-40"><a href="#cb2-40"></a><span class="co"># Create a version of the dataset with a column showing which hour the assault</span></span>
<span id="cb2-41"><a href="#cb2-41"></a><span class="co"># occurred in</span></span>
<span id="cb2-42"><a href="#cb2-42"></a>assaults_by_hour <span class="ot">&lt;-</span> assaults <span class="sc">|&gt;</span></span>
<span id="cb2-43"><a href="#cb2-43"></a>  <span class="co"># Keep only the CPD districts in downtown Chicago we are interested in</span></span>
<span id="cb2-44"><a href="#cb2-44"></a>  <span class="fu">filter</span>(district <span class="sc">%in%</span> <span class="fu">c</span>(<span class="dv">1</span>, <span class="dv">12</span>, <span class="dv">18</span>)) <span class="sc">|&gt;</span></span>
<span id="cb2-45"><a href="#cb2-45"></a>  <span class="co"># Create nicely formatted labels to represent each hour</span></span>
<span id="cb2-46"><a href="#cb2-46"></a>  <span class="fu">mutate</span>(</span>
<span id="cb2-47"><a href="#cb2-47"></a>    <span class="at">hour_name =</span> <span class="fu">str_pad</span>(<span class="fu">hour</span>(date), <span class="at">width =</span> <span class="dv">2</span>, <span class="at">pad =</span> <span class="st">&quot;0&quot;</span>),</span>
<span id="cb2-48"><a href="#cb2-48"></a>    <span class="at">hour_name =</span> <span class="fu">str_glue</span>(<span class="st">&quot;{hour_name}:00 to {hour_name}:59&quot;</span>)</span>
<span id="cb2-49"><a href="#cb2-49"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-50"><a href="#cb2-50"></a>  <span class="co"># Convert the data to an SF object</span></span>
<span id="cb2-51"><a href="#cb2-51"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;longitude&quot;</span>, <span class="st">&quot;latitude&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:4326&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-52"><a href="#cb2-52"></a>  <span class="co"># Convert the data to a suitable coordinate system for Chicago</span></span>
<span id="cb2-53"><a href="#cb2-53"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:26916&quot;</span>)</span>
<span id="cb2-54"><a href="#cb2-54"></a></span>
<span id="cb2-55"><a href="#cb2-55"></a><span class="co"># Create a grid to be used by all the KDE layers, otherwise `hotspot_kde()` will</span></span>
<span id="cb2-56"><a href="#cb2-56"></a><span class="co"># generate each grid based on the convex hull of the assaults occurring in each</span></span>
<span id="cb2-57"><a href="#cb2-57"></a><span class="co"># hour and each grid will be slightly different (which would make the animation</span></span>
<span id="cb2-58"><a href="#cb2-58"></a><span class="co"># flicker)</span></span>
<span id="cb2-59"><a href="#cb2-59"></a>grid <span class="ot">&lt;-</span> <span class="fu">hotspot_grid</span>(cpd_central, <span class="at">cell_size =</span> <span class="dv">200</span>)</span>
<span id="cb2-60"><a href="#cb2-60"></a></span>
<span id="cb2-61"><a href="#cb2-61"></a><span class="co"># Calculate KDE layer for each hour of the day</span></span>
<span id="cb2-62"><a href="#cb2-62"></a>hour_layers <span class="ot">&lt;-</span> assaults_by_hour <span class="sc">|&gt;</span></span>
<span id="cb2-63"><a href="#cb2-63"></a>  <span class="fu">group_by</span>(hour_name) <span class="sc">|&gt;</span></span>
<span id="cb2-64"><a href="#cb2-64"></a>  <span class="fu">group_modify</span>(</span>
<span id="cb2-65"><a href="#cb2-65"></a>    \(x, ...) <span class="fu">hotspot_kde</span>(x, <span class="at">grid =</span> grid, <span class="at">bandwidth_adjust =</span> <span class="fl">0.5</span>, <span class="at">quiet =</span> <span class="cn">TRUE</span>)</span>
<span id="cb2-66"><a href="#cb2-66"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-67"><a href="#cb2-67"></a>  <span class="fu">ungroup</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-68"><a href="#cb2-68"></a>  <span class="fu">st_as_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-69"><a href="#cb2-69"></a>  <span class="fu">hotspot_clip</span>(cpd_central, <span class="at">quiet =</span> <span class="cn">TRUE</span>)</span>
<span id="cb2-70"><a href="#cb2-70"></a></span>
<span id="cb2-71"><a href="#cb2-71"></a><span class="co"># Extract only the 10 cells with the highest density in each hour</span></span>
<span id="cb2-72"><a href="#cb2-72"></a>hour_highest <span class="ot">&lt;-</span> hour_layers <span class="sc">|&gt;</span></span>
<span id="cb2-73"><a href="#cb2-73"></a>  <span class="fu">group_by</span>(hour_name) <span class="sc">|&gt;</span></span>
<span id="cb2-74"><a href="#cb2-74"></a>  <span class="fu">slice_max</span>(<span class="at">order_by =</span> kde, <span class="at">n =</span> <span class="dv">10</span>)</span>
<span id="cb2-75"><a href="#cb2-75"></a></span>
<span id="cb2-76"><a href="#cb2-76"></a><span class="co"># CREATE AND SAVE ANIMATION ----------------------------------------------------</span></span>
<span id="cb2-77"><a href="#cb2-77"></a></span>
<span id="cb2-78"><a href="#cb2-78"></a>chicago_downtown_kde_map <span class="ot">&lt;-</span> <span class="fu">hotspot_map</span>(</span>
<span id="cb2-79"><a href="#cb2-79"></a>  hour_layers,</span>
<span id="cb2-80"><a href="#cb2-80"></a>  <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>,</span>
<span id="cb2-81"><a href="#cb2-81"></a>  <span class="at">caption =</span> <span class="st">&quot;Crime data from Chicago Police Department&quot;</span></span>
<span id="cb2-82"><a href="#cb2-82"></a>) <span class="sc">+</span></span>
<span id="cb2-83"><a href="#cb2-83"></a>  <span class="co"># Add layer showing cells with highest density of assaults</span></span>
<span id="cb2-84"><a href="#cb2-84"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> hour_highest, <span class="at">alpha =</span> <span class="fl">0.75</span>, <span class="at">colour =</span> <span class="st">&quot;red2&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-85"><a href="#cb2-85"></a>  <span class="co"># Add CPD district boundaries</span></span>
<span id="cb2-86"><a href="#cb2-86"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> cpd_central, <span class="at">colour =</span> <span class="st">&quot;grey33&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-87"><a href="#cb2-87"></a>  <span class="co"># Specify that each hour should be a separate frame in an animation</span></span>
<span id="cb2-88"><a href="#cb2-88"></a>  <span class="fu">transition_states</span>(<span class="at">states =</span> hour_name) <span class="sc">+</span></span>
<span id="cb2-89"><a href="#cb2-89"></a>  <span class="co"># Add labels</span></span>
<span id="cb2-90"><a href="#cb2-90"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-91"><a href="#cb2-91"></a>    <span class="at">title =</span> <span class="st">&quot;Aggravated assaults in downtown Chicago, 2010–2019&quot;</span>,</span>
<span id="cb2-92"><a href="#cb2-92"></a>    <span class="at">subtitle =</span> <span class="st">&quot;Areas with most aggravated assaults:</span><span class="sc">\n</span><span class="st">{closest_state}&quot;</span>,</span>
<span id="cb2-93"><a href="#cb2-93"></a>    <span class="at">fill =</span> <span class="st">&quot;density of</span><span class="sc">\n</span><span class="st">aggravated</span><span class="sc">\n</span><span class="st">assaults&quot;</span></span>
<span id="cb2-94"><a href="#cb2-94"></a>  )</span>
<span id="cb2-95"><a href="#cb2-95"></a></span>
<span id="cb2-96"><a href="#cb2-96"></a><span class="fu">anim_save</span>(</span>
<span id="cb2-97"><a href="#cb2-97"></a>  <span class="at">filename =</span> <span class="fu">here</span>(<span class="st">&quot;output&quot;</span>, <span class="st">&quot;chicago_downtown_agg_assaults.gif&quot;</span>),</span>
<span id="cb2-98"><a href="#cb2-98"></a>  <span class="at">animation =</span> <span class="fu">animate</span>(</span>
<span id="cb2-99"><a href="#cb2-99"></a>    <span class="at">plot =</span> chicago_downtown_kde_map,</span>
<span id="cb2-100"><a href="#cb2-100"></a>    <span class="at">fps =</span> <span class="dv">2</span>,</span>
<span id="cb2-101"><a href="#cb2-101"></a>    <span class="at">height =</span> <span class="dv">800</span>,</span>
<span id="cb2-102"><a href="#cb2-102"></a>    <span class="at">width =</span> <span class="dv">800</span>,</span>
<span id="cb2-103"><a href="#cb2-103"></a>    <span class="at">units =</span> <span class="st">&quot;px&quot;</span></span>
<span id="cb2-104"><a href="#cb2-104"></a>  )</span>
<span id="cb2-105"><a href="#cb2-105"></a>)</span></code></pre></div>
<figcaption>Code 15.37</figcaption>
</figure>

<a id="in-summary"></a>

## 15.7 In summary

In this chapter we have learned how to incorporate change over time into our analysis of where crime happens. This is important because the distribution of crime across different places often varies at different times. Being aware of the importance of time when we make maps means we can do things like create small-multiple or animated maps for different time periods, which we could use to make sure that scarce crime-prevention resources are used at the right time as well as in the right place.

We have practised how to:

- parse dates and date-times and extract the components needed for analysis;
- choose temporal units that preserve important patterns in crime;
- use moving averages to distinguish longer-term trends from short-term variation;
- create time-series, seasonal and hourly charts;
- use common grids and scales to compare spatial patterns across time periods; and
- create and save an animated map with gganimate.

You can learn more about:

- using the different functions in the lubridate package to [Do more with dates and times in R](https://lubridate.tidyverse.org/articles/lubridate.html),
- calculating moving averages and other [sliding-window summaries with slider](https://slider.r-lib.org/), and
- animating different types of map and chart in different ways in [Getting Started with gganimate](https://gganimate.com/articles/gganimate.html).

QuizCheck your knowledge: Revision questions

Answer these questions to check you have understood the main points covered in this chapter. Write between 50 and 100 words to answer each question.

1.  Why is it difficult for computers to deal with dates, and how does R solve this problem?
2.  How can we (a) extract and (b) manipulate date and time components in R?
3.  What are some challenges in visualising crime trends over time, and how can they be addressed?
4.  How can seasonal variations in crime be identified and visualised?
5.  Why is it important to consider both spatial and temporal dimensions when analysing crime?

[Artwork by Allison Horst](https://allisonhorst.com/)
