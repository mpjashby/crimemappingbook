Source: https://books.lesscrime.info/learncrimemapping/2026/16_crime_series/index.html

<a id="quarto-document-content"></a>
<a id="title-block-header"></a>
<a id="mapping-crime-series"></a>

# `<a id="sec-crime-series"></a>`{=html}16  Mapping crime series

Figure: Students examine linked case locations connected across a neighbourhood map.

In this chapter we will learn to map *crime series*, a sequence of crimes committed by the same individual or group. Using a historical case study, we will learn how to visualise crime series by mapping linked cases.

TipBefore you start

1.  Open Positron or -- if you already have Positron open -- start a new R session by clicking the **Restart R** (**⟳**) button in the **Console** panel. This makes sure no code you ran previously will interfere with the work you do in this chapter.
2.  Make sure you are working in the crime mapping project workspace you created in [Section 1.5](../01_getting_started/index.llms.md#sec-create-project). In the top-right corner of the Positron window, you should see a folder icon and the words `crime_mapping`. If not, click the **File** menu, then **Open Folder ...** and choose the `crime_mapping` folder.

<a id="introduction"></a>

## 16.1 Introduction

Up until now we've mapped each crime in a dataset as a separate event. This is very common in crime mapping, and is useful for many purposes. But a large proportion of crimes are committed by a relatively small proportion of all the people who commit crime. These persistent or repeat offenders commit crimes frequently, maybe several times a day in the case of some people. One type of repeat offending is the *crime series*, in which an offender or group of offenders commits the same or related crimes in different places over time. If we are trying to understand a crime series, it is important to map the sequence of events, rather than treating each crime as a separate event. In this chapter we will learn how to map crime series.

<a id="sec-crime-series-case-linkage"></a>
<a id="case-linkage"></a>

### 16.1.1 Case linkage

One of the difficulties in studying serial offending is in identifying which offences are committed by the same offender. *Case linkage* is the process of identifying crime series by looking for similarities in the method used by an offender (e.g. entering a house by breaking a lock on a side door out of sight from the street) or by evidence left at the scene (such as fingerprints or DNA). Case linkage is typically an imperfect process -- investigators might believe that two offences were committed by the same person, but in most cases they are unlikely to know for sure unless the offender has been caught (and sometimes not even then).

Watch this video to learn a bit more about crime linkage.

Media: Video explaining how investigators use case linkage to identify crimes that may have been committed by the same offender [(open media)](https://www.youtube.com/embed/XPOtaFRYrQs?t=13)

TranscriptVideo transcript: What Is Crime Linkage?

<a id="callout-2"></a>

**This transcript starts at 0:13, matching the starting point of the video above.**

Crime linkage is the practice of identifying which different offenses were committed by the same offender. For example, if you have a whole lot of unsolved burglaries, you want to find out which offenses are attributable to the same person. That is because you might have some information about the perpetrator from one crime, for example, a shoe print that points to a male with a certain shoe size and weight. See if you could identify which other offenses you think are linked to that same person.

Perhaps some of those have other information about the burglar, such as a witness seeing that he has a tattoo on one hand. And in this way, you can put together more and more pieces of the puzzle. You now have good reasons to believe that the offender who is responsible for this particular series is of a certain gender, weight, has a certain shoe size, which might point to his approximate height, and he has a tattoo on one hand.

If you allocate one of those pieces to the wrong puzzle, i.e., to the wrong series of offenses, you unnecessarily hinder the investigation. So, it's important to link the right offenses to the right person. Crimes can be linked through the perpetrator's MO, or modus operandi, which is how he carries out his crimes. This can refer to the kind of targets he selects and what he does to those targets. For example, Jack the Ripper's MO was to attack prostitutes in London's Whitechapel area in the East End during darkness and to cut their insides.

If another prostitute was poisoned to death in a different part of London during the day, that would not be consistent with Jack's MO, and we might therefore regard that as being the crime of another person. People are creatures of habit, and if we find a way of doing something that works, we tend to stick with that way of doing it as we have learned that it is effective. A skilled burglar who knows how to pick locks is unlikely to kick the door down.

He is much more likely to continue picking locks as that gets him through doors quietly. So we're looking for commonalities in decisions taken by the offender, how and whom he targets and how and whom he attacks for example. We also need to take into account progression. A prolific offender might gain at least experience but perhaps also additional skills during the commission of each crime. When he makes a mistake on one occasion for example that nearly got him caught, he might take care to avoid that or prepare for it next time round.

As we're looking for both consistency across time but also progression, it is important to identify in which order the offenses took place. Criminals also tend to become increasingly confident as they continue in their offending without getting caught. So they might be willing to take more and more risks. Of course, the most reliable factor to use when linking crime is forensics so that when you find an offender's DNA at every burgled property, you can safely assume he has been there.

MO is another way of linking crimes but it is not as reliable as geography which I will introduce next. Thank you for watching. I hope you found this content useful. You can get access to each episode's transcript with key learning points, timestamps and references if you get yourself onto my mailing list. Just go to the main website on police science doctor.com and on the bottom of each page you will find a sign up form for notifications of new content.

Just enter your first name, your preferred email address and the type of organization you work for. You will not get any spam. This is just for me to let you know about new content and for you to get access to all the transcripts.

QuizCase linkage

**What is the primary goal of case linkage?**

- To determine the time a crime was committed
- To identify which offences were committed by the same offender (Correct answer)
- To analyse the psychological state of the offender
- To predict where future crimes will occur

**Which of the following is an example of an offender's modus operandi (MO)?**

- The specific methods the offender uses to carry out their crimes (Correct answer)
- The DNA evidence left behind at the crime scene
- The legal defence strategy used by the offender in court
- The geographical location where the crimes occur

**According to the video, what is the most reliable factor to use when linking crimes?**

- The offender's modus operandi
- The geographical locations of the crimes
- Forensic evidence, such as DNA (Correct answer)
- The type of victim the offender targets

<a id="sec-crime-series-the-case-used-in-this-chapter"></a>
<a id="the-case-used-in-this-chapter"></a>

### 16.1.2 The case used in this chapter

Due to the inherent uncertainty of case linkage, there is little publicly available data on the locations of serial crimes. The available data tend to focus on serial murders, since murder is the crime that is most likely to be solved (in most developed countries, a very high proportion of murders are solved). To minimise the likelihood of anyone reading this book having been directly affected by -- or knowing anyone affected by -- the cases we use in this chapter, we will use a historical example.

The [Hungerford massacre](https://en.wikipedia.org/wiki/Hungerford_massacre) occurred in southern England in August 1987, when a marauding attacker (also known as a spree offender) killed 16 people and shot many others in the space of about 90 minutes. We will use a dataset called `hungerford_shootings` that contains the names of each victim and the approximate location at which they were shot (recorded as eastings and northings in the British National Grid). This data is taken from the [official report into the massacre](https://www.jesip.org.uk/uploads/media/incident_reports_and_inquiries/Hungerford%20Shootings.pdf). Each row represents a shooting location, so some rows contain more than one victim. The `order` column shows the sequence of locations rather than numbering individual victims. These are the first few rows of the dataset (the dagger symbol † shows that the victim was killed, rather than non-fatally injured):

  ----------------------------------------------------------------------------------------------
  victims                                                             order   easting   northing
  ----------------------------------------------------------------- ------- --------- ----------
  Susan GODFREY†                                                          1    423168     167694

  Kakaub DEAN                                                             2    429455     167904

  Roland MASON†, Sheila MASON†, Marjorie JACKSON, Lisa MILDENHALL         3    433849     168176

  Kenneth CLEMENTS†                                                       4    434044     168133

  Roger BRERETON†, Linda CHAPMAN, Alison CHAPMAN                          5    433897     168165
  ----------------------------------------------------------------------------------------------

In this chapter we will learn how to create this composite map of the locations of the shootings in this crime series.

<a id="map-hungerford-shooting-sequence"></a>

<figure>
<p>Figure: Two vertically arranged maps show the sequence of the Hungerford shootings in August 1987. The upper overview locates the first two shootings west of the town; the taller lower street map separates locations three to sixteen within Hungerford. Brown numbered labels and curved arrows show order, while each map has its own scale bar. A text description of the sequence is available with the introductory map.</p>
<figcaption>Map 16.1</figcaption>
</figure>

<a id="desc-hungerford-sequence"></a>
NoteMap description: the Hungerford shooting sequence

<a id="callout-4"></a>

The two maps use different scales. In the upper map, location 1 is furthest west in Wiltshire. An arrow runs east to location 2, then onwards to the tightly packed locations in Hungerford. The scale bar represents 2 kilometres.

The lower map enlarges locations 3 to 16 in the town, with a 300-metre scale bar. Starting in the north, arrows link 3 to 4 to the east, then turn west through 5 and 6. The sequence runs south through 7, 8 and 9, then north-west through 10, 11 and 12. It then moves south along the western side through 13, 14 and 15, east to 16 and back north towards the earlier locations. The numbers indicate the order of shooting locations, rather than the number of victims. Arrows connect recorded locations; they do not identify every street travelled along.

In this chapter, we will learn how to:

- prepare an ordered sequence of events for mapping using `arrange()` and `lag()`;
- connect event locations using curved lines and directional arrows;
- expand the area displayed on a map;
- add labels that are automatically offset from the points they relate to;
- create overview and detailed maps of the same events; and
- combine multiple maps into one output using the patchwork package.

Create a new R script file in Positron and save it as `chapter_16.R` in the `R` folder of the workspace you created in [Section 1.5](../01_getting_started/index.llms.md#sec-create-project). Add this code to download the original data into `data/raw`, load the local copy and prepare to make the map. Run the code by pressing .

<a id="lst-crime-series-script-16-prepare"></a>

<figure>
<pre><code>chapter_16.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This script creates a combination of maps showing the sequence of shootings</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="co"># during the Hungerford massacre in 1987</span></span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Load data --------------------------------------------------------------------</span></span>
<span id="cb2-5"><a href="#cb2-5"></a></span>
<span id="cb2-6"><a href="#cb2-6"></a><span class="co"># Load packages</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(ggrepel, ggspatial, here, httr2, patchwork, tidyverse)</span>
<span id="cb2-8"><a href="#cb2-8"></a></span>
<span id="cb2-9"><a href="#cb2-9"></a><span class="co"># Download the original shootings data</span></span>
<span id="cb2-10"><a href="#cb2-10"></a><span class="fu">request</span>(</span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/hungerford_shootings.csv&quot;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;hungerford_shootings.csv&quot;</span>))</span>
<span id="cb2-14"><a href="#cb2-14"></a></span>
<span id="cb2-15"><a href="#cb2-15"></a><span class="co"># Load the local copy of the shootings data</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>hungerford_shootings <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;hungerford_shootings.csv&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>  <span class="fu">read_csv</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="fu">arrange</span>(order)</span></code></pre></div>
<figcaption>Code 16.1</figcaption>
</figure>

    <httr2_response>
    GET https://mpjashby.github.io/crimemappingdata/hungerford_shootings.csv
    Status: 200 OK
    Content-Type: text/csv
    Body: On disk '/Users/mattashby/Documents/Crime Mapping Book/data/raw/hungerford_shootings.csv' (798 bytes)

    Rows: 16 Columns: 4
    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: ","
    chr (1): victims
    dbl (3): order, easting, northing

    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

You might notice this code loads some packages we haven't worked with before. We'll introduce these packages in this chapter.

<a id="mapping-linked-cases"></a>

## 16.2 Mapping linked cases

Mapping crime series can be useful for several reasons. For example, a map of a crime series might help the jurors in a criminal trial to better understand the sequence of events that the suspect is accused of. This can be especially helpful if the sequence is complicated or especially long.

At the moment, the `hungerford_shootings` dataset contains the *point* location of each event and the order in which they occurred. To show a sequence of events on a map, we need to link each event with those that happened immediately before and after it.

  ----------------------------------------------------------------------------------------------
  victims                                                             order   easting   northing
  ----------------------------------------------------------------- ------- --------- ----------
  Susan GODFREY†                                                          1    423168     167694

  Kakaub DEAN                                                             2    429455     167904

  Roland MASON†, Sheila MASON†, Marjorie JACKSON, Lisa MILDENHALL         3    433849     168176

  Kenneth CLEMENTS†                                                       4    434044     168133

  Roger BRERETON†, Linda CHAPMAN, Alison CHAPMAN                          5    433897     168165
  ----------------------------------------------------------------------------------------------

One way to do that is to draw lines on the map connecting each incident in turn. To do this, we will create a dataset where each row contains *two* pairs of coordinates: one representing the location of a particular shooting and the other representing the location of the *previous* shooting. To do that, we will:

1.  Take the `hungerford_shootings` dataset and rename the existing columns holding the coordinates so that it is clear those coordinates are for the *end* of each line between points. To do this we will use the `rename()` function from the dplyr package.
2.  Sort the rows using the `order` column. This is essential because `lag()` uses the current row order when it retrieves the previous value.
3.  Add two new columns to each row that show the coordinates of the row in the dataset immediately above the current row (i.e. the row that represents the location before the current location). We will do this with the `lag()` function, also from dplyr.
4.  Use these two pairs of coordinates to plot lines on a map.

<a id="lst-crime-series-script-16-lines"></a>

<figure>
<pre><code>chapter_16.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Prepare data -----------------------------------------------------------------</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="co"># Create dataset of lines joining shootings in sequence</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>hungerford_lines <span class="ot">&lt;-</span> hungerford_shootings <span class="sc">|&gt;</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="co"># Arrange the rows in order of the sequence of shootings</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="fu">arrange</span>(order) <span class="sc">|&gt;</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>  <span class="co"># Make it clear the coordinates refer to the coordinates we want to use for</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="co"># the *end* of each line, to distinguish them from the second set of</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="co"># coordinates we&#39;ll create next</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="fu">rename</span>(<span class="at">x_end =</span> easting, <span class="at">y_end =</span> northing) <span class="sc">|&gt;</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="co"># Copy the coordinates from the row above each row to create a second set of</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="co"># coordinates for the *start* of each line</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">mutate</span>(<span class="at">x_start =</span> <span class="fu">lag</span>(x_end), <span class="at">y_start =</span> <span class="fu">lag</span>(y_end)) <span class="sc">|&gt;</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="co"># Remove the first row, which now contains missing values for `y_start` and</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  <span class="co"># `x_start`, and which we don&#39;t need</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="fu">drop_na</span>(x_start, y_start)</span></code></pre></div>
<figcaption>Code 16.2</figcaption>
</figure>

<a id="lst-crime-series-head-hungerford-lines"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">head</span>(hungerford_lines)</span></code></pre></div>
<figcaption>Code 16.3</figcaption>
</figure>

    # A tibble: 6 × 6
      victims                                    order  x_end  y_end x_start y_start
      <chr>                                      <dbl>  <dbl>  <dbl>   <dbl>   <dbl>
    1 "Kakaub DEAN"                                  2 429455 167904  423168  167694
    2 "Roland MASON†\nSheila MASON†\nMarjorie J…     3 433849 168176  429455  167904
    3 "Kenneth CLEMENTS†"                            4 434044 168133  433849  168176
    4 "Roger BRERETON†\nLinda CHAPMAN\nAlison C…     5 433897 168165  434044  168133
    5 "Abdur KHAN†\nAlan LEPETIT\nHazel HASLETT…     6 433821 168176  433897  168165
    6 "Betty TOLLADAY"                               7 433954 168032  433821  168176

TipWhy does this code include `drop_na()`?

<a id="callout-5"></a>

You might notice that the values in the first row of the `x_start` and `y_start` columns in the `hungerford_lines` object are `NA` values. This is because these columns have been created using the `lag()` function, which gets the value from the same column in the row immediately above. The first row doesn't have a row immediately above it, so `lag()` returns `NA`. Since the first row does not represent a link between shootings in any case, we can remove it with `drop_na()`.

This method for creating lines between points is one of several ways we could achieve the same result. For example, we could create lines connecting the points and store them as SF objects. However, the code to do that is more complicated and would give us slightly less control over the appearance of the lines.

Using this method means the points and lines we want to put on our map are not SF objects, so we cannot use `geom_sf()` to add them to the map. Instead, we will add the points representing shooting locations to the map using `geom_point()` and add the lines between points using `geom_segment()`, both from the ggplot2 package. Since `hotspot_map()` only works for SF objects, we cannot use `hotspot_map()` in this case, either. That means we have to do some things manually that would normally be done for us automatically. The extra code in [Code 16.4](#lst-crime-series-draw-hungerford-shootings-straight-lines) is explained in the accompanying notes.

Run this code in the R Console.

<a id="lst-crime-series-draw-hungerford-shootings-straight-lines"></a>

<figure>
<pre><code>R Console</code></pre>
<a id="annotated-cell-14"></a>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r code-annotation-code number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Plot a basic map</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="co"># Add base map</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">annotation_map_tile</span>(<span class="at">type =</span> <span class="st">&quot;cartolight&quot;</span>, <span class="at">zoomin =</span> <span class="dv">0</span>, <span class="at">progress =</span> <span class="st">&quot;none&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="co"># Add lines between points</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="fu">geom_segment</span>(</span>
<span id="cb2-7"><a href="#cb2-7"></a>    <span class="fu">aes</span>(<span class="at">x =</span> x_start, <span class="at">y =</span> y_start, <span class="at">xend =</span> x_end, <span class="at">yend =</span> y_end),</span>
<span id="cb2-8"><a href="#cb2-8"></a>    <span class="at">data =</span> hungerford_lines</span>
<span id="cb2-9"><a href="#cb2-9"></a>  ) <span class="sc">+</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="co"># Add points</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="fu">geom_point</span>(<span class="fu">aes</span>(<span class="at">x =</span> easting, <span class="at">y =</span> northing), <span class="at">data =</span> hungerford_shootings) <span class="sc">+</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="co"># Since our layers are not an SF object, tell `ggplot()` what coordinate</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="co"># system to use</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="fu">coord_sf</span>(<span class="at">crs =</span> <span class="st">&quot;EPSG:27700&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  <span class="co"># Add base map attribution statement</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="fu">labs</span>(<span class="at">caption =</span> <span class="st">&quot;Map tiles ©: CARTO; data © OpenStreetMap contributors&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>  <span class="fu">theme_void</span>()</span></code></pre></div>
<figcaption>Code 16.4</figcaption>
</figure>

<a id="map-hungerford-shootings-straight-lines"></a>

<figure>
<figure>
<p>Figure: Wide, very shallow map of the Hungerford shooting locations in August 1987. Black dots are joined by straight black lines. Two outlying locations stretch the map westwards, leaving the town locations tightly packed at the eastern end; direction and event order are not labelled.</p>
</figure>
<figcaption>Map 16.2</figcaption>
</figure>

1.  When we make a map using `hotspot_map()`, in the background that function uses the `annotation_map_tile()` function (from the ggspatial package) to add a base map to the map. Since we're not using `hotspot_map()`, we have to do this ourselves.
2.  Since we aren't using SF objects, we need to tell `ggplot()` how to translate the coordinates in our data to locations on the map. We do this with the `coord_sf()` function.
3.  `hotspot_map()` automatically adds a caption to the map to acknowledge the source of the base map tiles used on a particular map (see [Section 7.7](../07_map_context/index.llms.md#sec-base-maps)), so here we have to do this ourselves.
4.  We use `theme_void()` to remove information that is often useful for a chart but not for a map, such as labels along the x- and y-axes showing coordinates.

This map is not particularly useful -- we will improve it in [Section 16.2.1](#sec-crime-series-extending-the-map-area) and [Section 16.2.2](#sec-crime-series-adding-arrows-and-curves).

If you look at this code, you'll see that we've included the function `coord_sf()` in our `ggplot()` stack. In all the previous maps that we have made, we have used `geom_sf()` to plot geographic data on our maps. `geom_sf()` understands how to translate coordinates specified using different coordinate systems to locations on the surface of each map. Other functions in the `geom_*()` family of functions do not know how to do this automatically, so we must specify the coordinate system by adding the `coord_sf()` function to the stack. We only need to use one argument to `coord_sf()`: the `crs` argument to specify the coordinate system that our data uses. In this case, we know that the coordinates in the `hungerford_shootings` and `hungerford_lines` objects are specified using the British National Grid, which has the EPSG code EPSG:27700.

[Map 16.2](#map-hungerford-shootings-straight-lines) shows the sequence of events, but there are at least four ways that we can make it better.

1.  It would be useful to be able to see a larger area around the shooting locations, to see more of the town surrounding the area in which the crimes occurred.
2.  We don't know which order to move through the sequence of lines. We can deal with this by adding arrows to show the direction in which the sequence progressed.
3.  The straight lines make it look like the offender travelled across fields between locations, which is probably not true. Since we do not have data on what routes the offender took, we can replace the straight lines with curves to indicate that the exact route is unknown.
4.  Because the first two shootings occurred outside the town, the map has to cover a large area and this makes it harder to see the sequence of events in the town itself.

<a id="sec-crime-series-extending-the-map-area"></a>
<a id="extending-the-map-area"></a>

### 16.2.1 Extending the map area

By default, `ggplot()` works out the limits of the area shown on the map based on the area covered by the data we add to each stack with functions from the `geom_*()` family of functions. Usually this works well, but in this case the distribution of the shootings means that the map shows only a small slice of the town of Hungerford and the surrounding area. It would be useful for readers to be able to see a larger area, to be able to better identify where the shootings occurred.

We can increase the size of the area shown on the plot in two ways. We could use the `fixed_plot_aspect()` function from the ggspatial package to control the aspect ratio of the plot (i.e. how tall it is relative to how wide it is). With some trial and error, we could use this to determine the best aspect ratio for showing the data on this map. However, this only allows us to control the overall size of the plot, not the amount of space around the data in each direction.

For more-specific control over what area is shown, we can use the `scale_x_continuous()` and `scale_y_continuous()` functions from the ggplot2 package. We used the `scale_fill_distiller()` function in [Section 7.6](../07_map_context/index.llms.md#sec-map-colour) to control how columns in the data are represented as colours on the map. The `scale_x_continuous()` and `scale_y_continuous()` functions are similar, in that they control the horizontal (X) and vertical (Y) axes on the map. We don't need to use most of the capabilities of these because `ggplot()` sets reasonable default values. The only argument we need to set is the `expand` argument, which controls how far the map should extend around the area covered by the data.

The easiest way to set the correct values for the `expand` argument is to use the `expansion()` helper function. We can use this to specify how much extra area around the data we want to include on the map. For example, `expansion(2)` means that the axis of the map should cover the area covered by the data and twice that distance either side of the data.

Run this code in the R Console.

<a id="lst-crime-series-draw-hungerford-shootings-expanded-extent"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Plot a basic map</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="co"># Add base map</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">annotation_map_tile</span>(<span class="at">type =</span> <span class="st">&quot;cartolight&quot;</span>, <span class="at">zoomin =</span> <span class="dv">0</span>, <span class="at">progress =</span> <span class="st">&quot;none&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="co"># Add lines between points</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="fu">geom_segment</span>(</span>
<span id="cb2-7"><a href="#cb2-7"></a>    <span class="fu">aes</span>(<span class="at">x =</span> x_start, <span class="at">y =</span> y_start, <span class="at">xend =</span> x_end, <span class="at">yend =</span> y_end),</span>
<span id="cb2-8"><a href="#cb2-8"></a>    <span class="at">data =</span> hungerford_lines</span>
<span id="cb2-9"><a href="#cb2-9"></a>  ) <span class="sc">+</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="co"># Add points</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="fu">geom_point</span>(<span class="fu">aes</span>(<span class="at">x =</span> easting, <span class="at">y =</span> northing), <span class="at">data =</span> hungerford_shootings) <span class="sc">+</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="co"># Expand the map to show a larger area above/below the data</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">scale_y_continuous</span>(<span class="at">expand =</span> <span class="fu">expansion</span>(<span class="dv">2</span>)) <span class="sc">+</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="co"># Specify coordinate system</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  <span class="fu">coord_sf</span>(<span class="at">crs =</span> <span class="st">&quot;EPSG:27700&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="co"># Add base map attribution statement</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>  <span class="fu">labs</span>(<span class="at">caption =</span> <span class="st">&quot;Map tiles ©: CARTO; data © OpenStreetMap contributors&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="fu">theme_void</span>()</span></code></pre></div>
<figcaption>Code 16.5</figcaption>
</figure>

<a id="map-hungerford-shootings-expanded-extent"></a>

<figure>
<figure>
<p>Figure: Overview map of the Hungerford shooting locations in August 1987, with more space above and below the dots. Straight black lines join consecutive locations from two western outliers into the town at the eastern end. The added vertical space improves the map proportions but does not separate the crowded town locations.</p>
</figure>
<figcaption>Map 16.3</figcaption>
</figure>

Important`scale_x_continuous()` vs `scale_y_continuous()`

The `scale_y_continuous()` function specifically controls the vertical (Y) axis of the map, so it only adds space above and below the data on the map. If we wanted to add space to the left and right of the data, we would need to use the `scale_x_continuous()` function. But in this case, since the map is already very wide relative to its height, we will not make the map any wider.

<a id="sec-crime-series-adding-arrows-and-curves"></a>
<a id="adding-arrows-and-curves"></a>

### 16.2.2 Adding arrows and curves

To add an arrow to the end of each line segment we can use the `arrow()` helper function from the `ggplot2` package to specify the `arrow` argument of the `geom_segment()` function in our `ggplot()` stack. Here, we make the arrowhead smaller than the default by setting `length = unit(3, "mm")` and choose the style of the arrowhead with `type = "closed"`.

To prevent the arrowheads from obscuring the points, we will give the points a thin white border by specifying `shape = 21` (a circle with a separate border) and `colour = "white"`, as well as making the points slightly bigger with `size = 3`.

Run this code in the R Console.

<a id="lst-crime-series-draw-hungerford-shootings-arrowheads"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>  <span class="co"># Add base map</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">annotation_map_tile</span>(<span class="at">type =</span> <span class="st">&quot;cartolight&quot;</span>, <span class="at">zoomin =</span> <span class="dv">0</span>, <span class="at">progress =</span> <span class="st">&quot;none&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="co"># Add lines between points</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="fu">geom_segment</span>(</span>
<span id="cb2-6"><a href="#cb2-6"></a>    <span class="fu">aes</span>(<span class="at">x =</span> x_start, <span class="at">y =</span> y_start, <span class="at">xend =</span> x_end, <span class="at">yend =</span> y_end),</span>
<span id="cb2-7"><a href="#cb2-7"></a>    <span class="at">data =</span> hungerford_lines,</span>
<span id="cb2-8"><a href="#cb2-8"></a>    <span class="at">arrow =</span> <span class="fu">arrow</span>(<span class="at">length =</span> <span class="fu">unit</span>(<span class="dv">3</span>, <span class="st">&quot;mm&quot;</span>), <span class="at">type =</span> <span class="st">&quot;closed&quot;</span>),</span>
<span id="cb2-9"><a href="#cb2-9"></a>    <span class="at">colour =</span> <span class="st">&quot;darkorange4&quot;</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  ) <span class="sc">+</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="co"># Add points</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="fu">geom_point</span>(</span>
<span id="cb2-13"><a href="#cb2-13"></a>    <span class="fu">aes</span>(<span class="at">x =</span> easting, <span class="at">y =</span> northing),</span>
<span id="cb2-14"><a href="#cb2-14"></a>    <span class="at">data =</span> hungerford_shootings,</span>
<span id="cb2-15"><a href="#cb2-15"></a>    <span class="at">shape =</span> <span class="dv">21</span>,</span>
<span id="cb2-16"><a href="#cb2-16"></a>    <span class="at">colour =</span> <span class="st">&quot;white&quot;</span>,</span>
<span id="cb2-17"><a href="#cb2-17"></a>    <span class="at">fill =</span> <span class="st">&quot;darkorange4&quot;</span>,</span>
<span id="cb2-18"><a href="#cb2-18"></a>    <span class="at">size =</span> <span class="dv">3</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>  ) <span class="sc">+</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  <span class="co"># Expand the map to show a larger area above/below the data</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>  <span class="fu">scale_y_continuous</span>(<span class="at">expand =</span> <span class="fu">expansion</span>(<span class="dv">2</span>)) <span class="sc">+</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  <span class="co"># Specify coordinate system</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>  <span class="fu">coord_sf</span>(<span class="at">crs =</span> <span class="st">&quot;EPSG:27700&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  <span class="co"># Add base map attribution statement</span></span>
<span id="cb2-25"><a href="#cb2-25"></a>  <span class="fu">labs</span>(<span class="at">caption =</span> <span class="st">&quot;Map tiles ©: CARTO; data © OpenStreetMap contributors&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-26"><a href="#cb2-26"></a>  <span class="fu">theme_void</span>()</span></code></pre></div>
<figcaption>Code 16.6</figcaption>
</figure>

<a id="map-hungerford-shootings-arrowheads"></a>

<figure>
<figure>
<p>Figure: Overview map of the Hungerford shooting locations in August 1987. Brown dots are joined by brown straight lines with arrowheads, showing travel eastwards from two outlying locations towards the town. The town dots still overlap, so arrowheads clarify direction without making every event distinguishable.</p>
</figure>
<figcaption>Map 16.4</figcaption>
</figure>

This makes it easier to see that the shootings started at the point on the left of the map, but makes the problem of understanding the sequence of events in the town itself even worse. We will deal with this in [Section 16.3](#sec-crime-series-multiple-maps).

In [Map 16.4](#map-hungerford-shootings-arrowheads), we used the `geom_segment()` function to add the lines to our map. If we change this to `geom_curve()` the lines will become curved rather than straight. By specifying `curvature = -0.2` we get a slightly straighter line than the default, and a left-hand curve because the value of `curvature` is negative. These curves show only the sequence in which the locations were visited. They do not show the route travelled between locations, which is not recorded in the data.

The other change we can make at this point is to add a layer of labels showing the order in which the shootings occurred. We don't want the labels to overlap the points, so instead of adding labels with the `geom_label()` function from the ggplot2 package we will use `geom_label_repel()` from the ggrepel package that we learned about in [Section 14.5](../14_no_maps/index.llms.md#sec-chart-continuous). `geom_label_repel()` creates labels that are automatically offset from the points they relate to. For now, we will just label the first two locations.

At this point we can also make some minor changes to the map: adding a title and scale bar, putting a border around the map, and temporarily removing the base map attribution statement. The purpose of those changes will become clear in [Section 16.3](#sec-crime-series-multiple-maps).

Add this code to the `chapter_16.R` script file and run it.

<a id="lst-crime-series-script-16-overview"></a>

<figure>
<pre><code>chapter_16.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Make component maps ----------------------------------------------------------</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="co"># Create map showing overall locations of shootings</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>hungerford_map_overall <span class="ot">&lt;-</span> <span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="co"># Plot base map</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="fu">annotation_map_tile</span>(<span class="at">type =</span> <span class="st">&quot;cartolight&quot;</span>, <span class="at">zoomin =</span> <span class="dv">0</span>, <span class="at">progress =</span> <span class="st">&quot;none&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>  <span class="co"># Plot lines between points</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="fu">geom_curve</span>(</span>
<span id="cb2-9"><a href="#cb2-9"></a>    <span class="fu">aes</span>(<span class="at">x =</span> x_start, <span class="at">y =</span> y_start, <span class="at">xend =</span> x_end, <span class="at">yend =</span> y_end),</span>
<span id="cb2-10"><a href="#cb2-10"></a>    <span class="at">data =</span> hungerford_lines,</span>
<span id="cb2-11"><a href="#cb2-11"></a>    <span class="at">arrow =</span> <span class="fu">arrow</span>(<span class="at">length =</span> <span class="fu">unit</span>(<span class="dv">3</span>, <span class="st">&quot;mm&quot;</span>), <span class="at">type =</span> <span class="st">&quot;closed&quot;</span>),</span>
<span id="cb2-12"><a href="#cb2-12"></a>    <span class="at">curvature =</span> <span class="sc">-</span><span class="fl">0.2</span>,</span>
<span id="cb2-13"><a href="#cb2-13"></a>    <span class="at">colour =</span> <span class="st">&quot;darkorange4&quot;</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  ) <span class="sc">+</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  <span class="co"># Add points</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="fu">geom_point</span>(</span>
<span id="cb2-17"><a href="#cb2-17"></a>    <span class="fu">aes</span>(<span class="at">x =</span> easting, <span class="at">y =</span> northing),</span>
<span id="cb2-18"><a href="#cb2-18"></a>    <span class="at">data =</span> hungerford_shootings,</span>
<span id="cb2-19"><a href="#cb2-19"></a>    <span class="at">shape =</span> <span class="dv">21</span>,</span>
<span id="cb2-20"><a href="#cb2-20"></a>    <span class="at">colour =</span> <span class="st">&quot;white&quot;</span>,</span>
<span id="cb2-21"><a href="#cb2-21"></a>    <span class="at">fill =</span> <span class="st">&quot;darkorange4&quot;</span>,</span>
<span id="cb2-22"><a href="#cb2-22"></a>    <span class="at">size =</span> <span class="dv">3</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>  ) <span class="sc">+</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  <span class="co"># Add labels</span></span>
<span id="cb2-25"><a href="#cb2-25"></a>  <span class="fu">geom_label_repel</span>(</span>
<span id="cb2-26"><a href="#cb2-26"></a>    <span class="fu">aes</span>(<span class="at">x =</span> easting, <span class="at">y =</span> northing, <span class="at">label =</span> order),</span>
<span id="cb2-27"><a href="#cb2-27"></a>    <span class="at">data =</span> <span class="fu">filter</span>(hungerford_shootings, order <span class="sc">%in%</span> <span class="dv">1</span><span class="sc">:</span><span class="dv">2</span>),</span>
<span id="cb2-28"><a href="#cb2-28"></a>    <span class="at">colour =</span> <span class="st">&quot;white&quot;</span>,</span>
<span id="cb2-29"><a href="#cb2-29"></a>    <span class="at">fill =</span> <span class="st">&quot;darkorange4&quot;</span>,</span>
<span id="cb2-30"><a href="#cb2-30"></a>    <span class="at">fontface =</span> <span class="st">&quot;bold&quot;</span>,</span>
<span id="cb2-31"><a href="#cb2-31"></a>    <span class="at">linewidth =</span> <span class="dv">0</span></span>
<span id="cb2-32"><a href="#cb2-32"></a>  ) <span class="sc">+</span></span>
<span id="cb2-33"><a href="#cb2-33"></a>  <span class="co"># Add scale bar</span></span>
<span id="cb2-34"><a href="#cb2-34"></a>  <span class="fu">annotation_scale</span>(<span class="at">style =</span> <span class="st">&quot;ticks&quot;</span>, <span class="at">line_col =</span> <span class="st">&quot;grey40&quot;</span>, <span class="at">text_col =</span> <span class="st">&quot;grey40&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-35"><a href="#cb2-35"></a>  <span class="co"># Expand the map to show a larger area above/below the data</span></span>
<span id="cb2-36"><a href="#cb2-36"></a>  <span class="fu">scale_y_continuous</span>(<span class="at">expand =</span> <span class="fu">expansion</span>(<span class="dv">2</span>)) <span class="sc">+</span></span>
<span id="cb2-37"><a href="#cb2-37"></a>  <span class="co"># Specify coordinate system</span></span>
<span id="cb2-38"><a href="#cb2-38"></a>  <span class="fu">coord_sf</span>(<span class="at">crs =</span> <span class="st">&quot;EPSG:27700&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-39"><a href="#cb2-39"></a>  <span class="co"># Add title</span></span>
<span id="cb2-40"><a href="#cb2-40"></a>  <span class="fu">labs</span>(<span class="at">title =</span> <span class="st">&quot;Shootings in Wiltshire&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-41"><a href="#cb2-41"></a>  <span class="fu">theme_void</span>() <span class="sc">+</span></span>
<span id="cb2-42"><a href="#cb2-42"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-43"><a href="#cb2-43"></a>    <span class="at">panel.border =</span> <span class="fu">element_rect</span>(<span class="at">colour =</span> <span class="st">&quot;grey20&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>),</span>
<span id="cb2-44"><a href="#cb2-44"></a>    <span class="at">plot.title =</span> <span class="fu">element_text</span>(<span class="at">margin =</span> <span class="fu">margin</span>(<span class="at">b =</span> <span class="sc">-</span><span class="dv">18</span>))</span>
<span id="cb2-45"><a href="#cb2-45"></a>  )</span></code></pre></div>
<figcaption>Code 16.7</figcaption>
</figure>

Since we have saved this latest map to an object called `hungerford_map_overall`, we need to run the object name in the R Console in order to print the map in Positron's **Plots** pane.

<a id="lst-crime-series-draw-hungerford-shootings-overview"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>hungerford_map_overall</span></code></pre></div>
<figcaption>Code 16.8</figcaption>
</figure>

<a id="map-hungerford-shootings-overview"></a>

<figure>
<figure>
<p>Figure: Overview map of the Hungerford shootings in August 1987. Numbered brown labels and curved arrows run from location one in the west to location two further east, then to the tightly grouped town locations at the eastern end. The long distances between the first locations make the town sequence hard to read at this scale.</p>
</figure>
<figcaption>Map 16.5</figcaption>
</figure>

Now we have added arrowheads and curved lines, in [Section 16.3](#sec-crime-series-multiple-maps) we will learn how to solve the problem of the events in the town itself being unclear on the map.

QuizMapping crime series

**How can we show the sequence of locations in a crime series?**

- By adding street names to each location
- By removing locations that are too close together
- By connecting each point to the previous crime location (Correct answer)
- By only mapping the final crime in the series

**Why might we want to extend the area shown on a crime series map?**

- To include more contextual information about the surrounding environment (Correct answer)
- To make the map appear more colourful
- To reduce the number of crime points displayed
- To increase the complexity of the visualisation

**Which function in R can be used to prevent label overlap on crime maps?**

- theme_void()
- geom_label_repel() (Correct answer)
- position_dodge()
- geom_text()

<a id="sec-crime-series-multiple-maps"></a>
<a id="multiple-maps"></a>

## 16.3 Multiple maps

Figure: Cartoon labelled patchwork: combine and arrange your ggplots. Monsters build a display with plots P1 and P2 side by side above a wider P3. A plan shows the expression (P1 + P2) / P3, linking the operators to the resulting layout.

Our existing map is difficult to understand because we have a mix of some events very close together (including several on the same street) and some that occurred further away. This means the closer events overlap on the map, especially now that we have made the points larger to distinguish them from the lines linking each event.

[](https://patchwork.data-imaginist.com/)

To deal with this problem we can display two maps: an *overview map* showing the whole area covered by the points and a *detail map* showing only the events in the town of Hungerford itself. In [Section 15.5](../15_mapping_time/index.llms.md#sec-map-change-over-time) we created small-multiple maps with `facet_grid()`, but what we want to do here is slightly different. In this case the maps show the same data at different scales, rather than different data for the same area. To combine these maps, we need to use the [patchwork package](https://patchwork.data-imaginist.com/), which can combine multiple maps or charts made using `ggplot()` into a single output.

We have already saved the overview map as `hungerford_map_overall`. We can create a detail map showing only the shootings in Hungerford itself by removing the first two points from `hungerford_shootings` (since they represent shootings outside the town itself). We can do this for all the existing layers using the `slice()` function from the dplyr package.

We will use the `plot.margin` argument to the `theme()` function to add a small amount of space at the top (and outside the border of) of this map. When we put the two maps together, that space will help separate the two maps. We will also get the map to cover a slightly larger area than it would by default by using the `scale_x_continuous()` and `scale_y_continuous()` functions.

Add this code to your script file and run it.

<a id="lst-crime-series-script-16-town"></a>

<figure>
<pre><code>chapter_16.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Create detail map showing shootings in Hungerford town</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>hungerford_map_town <span class="ot">&lt;-</span> <span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">annotation_map_tile</span>(<span class="at">type =</span> <span class="st">&quot;cartolight&quot;</span>, <span class="at">zoomin =</span> <span class="dv">0</span>, <span class="at">progress =</span> <span class="st">&quot;none&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="co"># Add lines between points</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="fu">geom_curve</span>(</span>
<span id="cb2-6"><a href="#cb2-6"></a>    <span class="fu">aes</span>(<span class="at">x =</span> x_start, <span class="at">y =</span> y_start, <span class="at">xend =</span> x_end, <span class="at">yend =</span> y_end),</span>
<span id="cb2-7"><a href="#cb2-7"></a>    <span class="at">data =</span> <span class="fu">slice</span>(hungerford_lines, <span class="dv">3</span><span class="sc">:</span><span class="fu">n</span>()),</span>
<span id="cb2-8"><a href="#cb2-8"></a>    <span class="at">arrow =</span> <span class="fu">arrow</span>(<span class="at">length =</span> <span class="fu">unit</span>(<span class="dv">3</span>, <span class="st">&quot;mm&quot;</span>), <span class="at">type =</span> <span class="st">&quot;closed&quot;</span>),</span>
<span id="cb2-9"><a href="#cb2-9"></a>    <span class="at">curvature =</span> <span class="sc">-</span><span class="fl">0.2</span>,</span>
<span id="cb2-10"><a href="#cb2-10"></a>    <span class="at">colour =</span> <span class="st">&quot;darkorange4&quot;</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  ) <span class="sc">+</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="co"># Add points</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">geom_point</span>(</span>
<span id="cb2-14"><a href="#cb2-14"></a>    <span class="fu">aes</span>(<span class="at">x =</span> easting, <span class="at">y =</span> northing),</span>
<span id="cb2-15"><a href="#cb2-15"></a>    <span class="at">data =</span> <span class="fu">slice</span>(hungerford_shootings, <span class="dv">3</span><span class="sc">:</span><span class="fu">n</span>()),</span>
<span id="cb2-16"><a href="#cb2-16"></a>    <span class="at">shape =</span> <span class="dv">21</span>,</span>
<span id="cb2-17"><a href="#cb2-17"></a>    <span class="at">colour =</span> <span class="st">&quot;white&quot;</span>,</span>
<span id="cb2-18"><a href="#cb2-18"></a>    <span class="at">fill =</span> <span class="st">&quot;darkorange4&quot;</span>,</span>
<span id="cb2-19"><a href="#cb2-19"></a>    <span class="at">size =</span> <span class="dv">3</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  ) <span class="sc">+</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>  <span class="co"># Add labels</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  <span class="fu">geom_label_repel</span>(</span>
<span id="cb2-23"><a href="#cb2-23"></a>    <span class="fu">aes</span>(<span class="at">x =</span> easting, <span class="at">y =</span> northing, <span class="at">label =</span> order),</span>
<span id="cb2-24"><a href="#cb2-24"></a>    <span class="at">data =</span> <span class="fu">slice</span>(hungerford_shootings, <span class="dv">3</span><span class="sc">:</span><span class="fu">n</span>()),</span>
<span id="cb2-25"><a href="#cb2-25"></a>    <span class="at">colour =</span> <span class="st">&quot;white&quot;</span>,</span>
<span id="cb2-26"><a href="#cb2-26"></a>    <span class="at">fill =</span> <span class="st">&quot;darkorange4&quot;</span>,</span>
<span id="cb2-27"><a href="#cb2-27"></a>    <span class="at">fontface =</span> <span class="st">&quot;bold&quot;</span>,</span>
<span id="cb2-28"><a href="#cb2-28"></a>    <span class="at">linewidth =</span> <span class="dv">0</span></span>
<span id="cb2-29"><a href="#cb2-29"></a>  ) <span class="sc">+</span></span>
<span id="cb2-30"><a href="#cb2-30"></a>  <span class="co"># Add scale bar</span></span>
<span id="cb2-31"><a href="#cb2-31"></a>  <span class="fu">annotation_scale</span>(<span class="at">style =</span> <span class="st">&quot;ticks&quot;</span>, <span class="at">line_col =</span> <span class="st">&quot;grey40&quot;</span>, <span class="at">text_col =</span> <span class="st">&quot;grey40&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-32"><a href="#cb2-32"></a>  <span class="co"># Expand the map to show a larger area around the data</span></span>
<span id="cb2-33"><a href="#cb2-33"></a>  <span class="fu">scale_x_continuous</span>(<span class="at">expand =</span> <span class="fu">expansion</span>(<span class="fl">0.3</span>)) <span class="sc">+</span></span>
<span id="cb2-34"><a href="#cb2-34"></a>  <span class="fu">scale_y_continuous</span>(<span class="at">expand =</span> <span class="fu">expansion</span>(<span class="fl">0.3</span>)) <span class="sc">+</span></span>
<span id="cb2-35"><a href="#cb2-35"></a>  <span class="co"># Specify coordinate system</span></span>
<span id="cb2-36"><a href="#cb2-36"></a>  <span class="fu">coord_sf</span>(<span class="at">crs =</span> <span class="st">&quot;EPSG:27700&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-37"><a href="#cb2-37"></a>  <span class="fu">labs</span>(<span class="at">title =</span> <span class="st">&quot;Shootings in Hungerford town&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-38"><a href="#cb2-38"></a>  <span class="fu">theme_void</span>() <span class="sc">+</span></span>
<span id="cb2-39"><a href="#cb2-39"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-40"><a href="#cb2-40"></a>    <span class="at">panel.border =</span> <span class="fu">element_rect</span>(<span class="at">colour =</span> <span class="st">&quot;grey20&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>),</span>
<span id="cb2-41"><a href="#cb2-41"></a>    <span class="at">plot.margin =</span> <span class="fu">margin</span>(<span class="at">t =</span> <span class="dv">12</span>)</span>
<span id="cb2-42"><a href="#cb2-42"></a>  )</span></code></pre></div>
<figcaption>Code 16.9</figcaption>
</figure>

<a id="lst-crime-series-draw-hungerford-shootings-town"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>hungerford_map_town</span></code></pre></div>
<figcaption>Code 16.10</figcaption>
</figure>

<a id="map-hungerford-shootings-town"></a>

<figure>
<figure>
<p>Figure: Street map of Hungerford showing shooting locations three to sixteen in August 1987. Brown numbered labels and curved arrows trace movements among northern streets, south through the town and back towards the centre. Labels three, five and six are close together; a larger map scale separates the later locations that overlapped in the overview.</p>
</figure>
<figcaption>Map 16.6</figcaption>
</figure>

Now we have two maps, we can use patchwork to combine them. The patchwork package uses mathematical operators to combine multiple ggplot2 objects. To place two plots beside one another, we would use the `|` operator. In this case we want to place one plot on top of another, so we use the `/` operator. You can combine plots in more-complicated ways by combining these operators, together with parentheses.

To position the town detail map (stored in `hungerford_map_town`) below the overview map (stored in `hungerford_map_overall`), we can use this code:

<a id="lst-crime-series-draw-hungerford-shootings-combined"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>hungerford_map_overall <span class="sc">/</span> hungerford_map_town</span></code></pre></div>
<figcaption>Code 16.11</figcaption>
</figure>

<a id="map-hungerford-shootings-combined"></a>

<figure>
<figure>
<p>Figure: Two vertically arranged maps show the sequence of the Hungerford shootings in August 1987. The upper overview locates the first two shootings west of the town; the taller lower street map separates locations three to sixteen within Hungerford. Brown numbered labels and curved arrows show order, while each map has its own scale bar. A text description of the sequence is available with the introductory map.</p>
</figure>
<figcaption>Map 16.7</figcaption>
</figure>

When we created the `hungerford_map_overall` object in [Section 16.2.2](#sec-crime-series-adding-arrows-and-curves), we gave the map title a *negative* margin using the `plot.title` argument to the `theme()` function. This had the effect of moving the title downwards onto the map to save space, since the top-left corner of the map was empty. We also added a scale bar, since when you present two related maps of different scales next to one another, it is useful to show the scales of both maps to help readers relate them to one another. You can see in [Map 16.7](#map-hungerford-shootings-combined), for example, the very different scales of the two maps.

We can add shared titles and captions to combined maps created with patchwork using the `plot_annotation()` function. We will add an overall title for the combined maps, as well as adding back the base map attribution statement, since it applies to both maps so there is no need to take up space by adding it to each map individually.

`plot_annotation()` also has a `theme` argument, which we can use to change the appearance of the shared title and caption just as we use `theme()` to change the appearance of elements on single maps. Finally, we can use `ggsave()` to save the combined map to an image file, as we learned to do in [Section 7.10](../07_map_context/index.llms.md#sec-saving-maps).

Add this code to the script file and run it.

<a id="lst-crime-series-script-16-combine"></a>

<figure>
<pre><code>chapter_16.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Combine maps and add titles --------------------------------------------------</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a>hungerford_map <span class="ot">&lt;-</span> (hungerford_map_overall <span class="sc">/</span> hungerford_map_town) <span class="sc">+</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">plot_annotation</span>(</span>
<span id="cb2-5"><a href="#cb2-5"></a>    <span class="at">title =</span> <span class="st">&quot;Shootings during the Hungerford massacre&quot;</span>,</span>
<span id="cb2-6"><a href="#cb2-6"></a>    <span class="at">caption =</span> <span class="fu">str_glue</span>(</span>
<span id="cb2-7"><a href="#cb2-7"></a>      <span class="st">&quot;Data from the official report into the shootings</span><span class="sc">\n</span><span class="st">Map tiles ©: CARTO; &quot;</span>,</span>
<span id="cb2-8"><a href="#cb2-8"></a>      <span class="st">&quot;data © OpenStreetMap contributors&quot;</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>    ),</span>
<span id="cb2-10"><a href="#cb2-10"></a>    <span class="at">theme =</span> <span class="fu">theme</span>(</span>
<span id="cb2-11"><a href="#cb2-11"></a>      <span class="at">plot.caption =</span> <span class="fu">element_text</span>(<span class="at">colour =</span> <span class="st">&quot;grey40&quot;</span>, <span class="at">hjust =</span> <span class="dv">0</span>),</span>
<span id="cb2-12"><a href="#cb2-12"></a>      <span class="at">plot.title =</span> <span class="fu">element_text</span>(<span class="at">colour =</span> <span class="st">&quot;grey50&quot;</span>, <span class="at">face =</span> <span class="st">&quot;bold&quot;</span>, <span class="at">size =</span> <span class="dv">14</span>)</span>
<span id="cb2-13"><a href="#cb2-13"></a>    )</span>
<span id="cb2-14"><a href="#cb2-14"></a>  )</span>
<span id="cb2-15"><a href="#cb2-15"></a></span>
<span id="cb2-16"><a href="#cb2-16"></a><span class="fu">ggsave</span>(</span>
<span id="cb2-17"><a href="#cb2-17"></a>  <span class="fu">here</span>(<span class="st">&quot;output&quot;</span>, <span class="st">&quot;hungerford_map.jpg&quot;</span>),</span>
<span id="cb2-18"><a href="#cb2-18"></a>  hungerford_map,</span>
<span id="cb2-19"><a href="#cb2-19"></a>  <span class="at">width =</span> <span class="dv">900</span> <span class="sc">/</span> <span class="dv">150</span>,</span>
<span id="cb2-20"><a href="#cb2-20"></a>  <span class="at">height =</span> <span class="dv">900</span> <span class="sc">/</span> <span class="dv">150</span>,</span>
<span id="cb2-21"><a href="#cb2-21"></a>  <span class="at">dpi =</span> <span class="dv">150</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>)</span></code></pre></div>
<figcaption>Code 16.12</figcaption>
</figure>

There are various other improvements that we could make to this map based on the mapping skills we have already learned during this course. For example, we could add the locations of buildings or particular facilities using data from OpenStreetMap. What information we choose to present on the map will depend on what information we think it is important to communicate to our audience.

The connecting curves should be interpreted cautiously. Their accuracy depends on the events being correctly linked and ordered, and they do not show the route travelled between locations.

QuizCombining maps

**Why is it useful to combine an overview map with a detail map?**

- To show two unrelated datasets without explaining the connection
- To show the overall spatial pattern while preserving detail in a smaller area (Correct answer)
- To avoid including scale information on either map
- To make every point appear at the same scale

**Which patchwork operator places one plot above another?**

- The \| operator
- The / operator (Correct answer)
- The + operator
- The \* operator

**Why should both component maps include scale information?**

- Because patchwork requires every plot to contain one
- Because both maps always cover the same area
- Because the maps use different scales and readers need to interpret distance on each one (Correct answer)
- Because scale bars identify the order of the events

<a id="putting-it-all-together"></a>

## 16.4 Putting it all together

In this chapter, we practised how to:

- sort linked events into the correct order before mapping them;
- use `lag()` to associate each location with the previous location;
- connect locations using curves and directional arrows;
- expand the area displayed on a map;
- add labels that are automatically offset from their points with `geom_label_repel()`;
- create overview and detailed maps; and
- combine multiple maps using the patchwork package.

When we are mapping crime data, it is important to remember that the rows in the data we are using often represent traumatic events that have happened to people. In this chapter, every row in the data represents one or more people who were killed or injured during the massacre. The people killed were Marcus Barnard, Roger Brereton, Francis Butler, Kenneth Clements, Victor Gibbs, Myrtle Gibbs, Susan Godfrey, Sandra Hill, Abdur Khan, Roland Mason, Sheila Mason, Ian Playle, Dorothy Ryan, Eric Vardy, Douglas Wainwright and George White.

Figure: Black-and-white photograph of uniformed pallbearers carrying a flower-topped coffin at the funeral of police constable Roger Brereton, who was killed in the Hungerford massacre. Other mourners and uniformed officers stand nearby.

The complete script in [Code 16.13](#lst-crime-series-show-chapter-16-script) contains everything needed to download the original data and make and save the composite map. Save `chapter_16.R` by pressing .

To check that the analysis is reproducible, restart R using the **Restart R** (**⟳**) button in Positron's **Console** panel, then run the script from beginning to end.

<a id="lst-crime-series-show-chapter-16-script"></a>

<figure>
<pre><code>chapter_16.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This script creates a combination of maps showing the sequence of shootings</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="co"># during the Hungerford massacre in 1987</span></span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Load data --------------------------------------------------------------------</span></span>
<span id="cb2-5"><a href="#cb2-5"></a></span>
<span id="cb2-6"><a href="#cb2-6"></a><span class="co"># Load packages</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(ggrepel, ggspatial, here, httr2, patchwork, tidyverse)</span>
<span id="cb2-8"><a href="#cb2-8"></a></span>
<span id="cb2-9"><a href="#cb2-9"></a><span class="co"># Download the original shootings data</span></span>
<span id="cb2-10"><a href="#cb2-10"></a><span class="fu">request</span>(</span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/hungerford_shootings.csv&quot;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;hungerford_shootings.csv&quot;</span>))</span>
<span id="cb2-14"><a href="#cb2-14"></a></span>
<span id="cb2-15"><a href="#cb2-15"></a><span class="co"># Load the local copy of the shootings data</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>hungerford_shootings <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;hungerford_shootings.csv&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>  <span class="fu">read_csv</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="fu">arrange</span>(order)</span>
<span id="cb2-19"><a href="#cb2-19"></a></span>
<span id="cb2-20"><a href="#cb2-20"></a></span>
<span id="cb2-21"><a href="#cb2-21"></a><span class="co"># Prepare data -----------------------------------------------------------------</span></span>
<span id="cb2-22"><a href="#cb2-22"></a></span>
<span id="cb2-23"><a href="#cb2-23"></a><span class="co"># Create dataset of lines joining shootings in sequence</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>hungerford_lines <span class="ot">&lt;-</span> hungerford_shootings <span class="sc">|&gt;</span></span>
<span id="cb2-25"><a href="#cb2-25"></a>  <span class="co"># Arrange the rows in order of the sequence of shootings</span></span>
<span id="cb2-26"><a href="#cb2-26"></a>  <span class="fu">arrange</span>(order) <span class="sc">|&gt;</span></span>
<span id="cb2-27"><a href="#cb2-27"></a>  <span class="co"># Make it clear the coordinates refer to the coordinates we want to use for</span></span>
<span id="cb2-28"><a href="#cb2-28"></a>  <span class="co"># the *end* of each line, to distinguish them from the second set of</span></span>
<span id="cb2-29"><a href="#cb2-29"></a>  <span class="co"># coordinates we&#39;ll create next</span></span>
<span id="cb2-30"><a href="#cb2-30"></a>  <span class="fu">rename</span>(<span class="at">x_end =</span> easting, <span class="at">y_end =</span> northing) <span class="sc">|&gt;</span></span>
<span id="cb2-31"><a href="#cb2-31"></a>  <span class="co"># Copy the coordinates from the row above each row to create a second set of</span></span>
<span id="cb2-32"><a href="#cb2-32"></a>  <span class="co"># coordinates for the *start* of each line</span></span>
<span id="cb2-33"><a href="#cb2-33"></a>  <span class="fu">mutate</span>(<span class="at">x_start =</span> <span class="fu">lag</span>(x_end), <span class="at">y_start =</span> <span class="fu">lag</span>(y_end)) <span class="sc">|&gt;</span></span>
<span id="cb2-34"><a href="#cb2-34"></a>  <span class="co"># Remove the first row, which now contains missing values for `y_start` and</span></span>
<span id="cb2-35"><a href="#cb2-35"></a>  <span class="co"># `x_start`, and which we don&#39;t need</span></span>
<span id="cb2-36"><a href="#cb2-36"></a>  <span class="fu">drop_na</span>(x_start, y_start)</span>
<span id="cb2-37"><a href="#cb2-37"></a></span>
<span id="cb2-38"><a href="#cb2-38"></a></span>
<span id="cb2-39"><a href="#cb2-39"></a><span class="co"># Make component maps ----------------------------------------------------------</span></span>
<span id="cb2-40"><a href="#cb2-40"></a></span>
<span id="cb2-41"><a href="#cb2-41"></a><span class="co"># Create map showing overall locations of shootings</span></span>
<span id="cb2-42"><a href="#cb2-42"></a>hungerford_map_overall <span class="ot">&lt;-</span> <span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb2-43"><a href="#cb2-43"></a>  <span class="co"># Plot base map</span></span>
<span id="cb2-44"><a href="#cb2-44"></a>  <span class="fu">annotation_map_tile</span>(<span class="at">type =</span> <span class="st">&quot;cartolight&quot;</span>, <span class="at">zoomin =</span> <span class="dv">0</span>, <span class="at">progress =</span> <span class="st">&quot;none&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-45"><a href="#cb2-45"></a>  <span class="co"># Plot lines between points</span></span>
<span id="cb2-46"><a href="#cb2-46"></a>  <span class="fu">geom_curve</span>(</span>
<span id="cb2-47"><a href="#cb2-47"></a>    <span class="fu">aes</span>(<span class="at">x =</span> x_start, <span class="at">y =</span> y_start, <span class="at">xend =</span> x_end, <span class="at">yend =</span> y_end),</span>
<span id="cb2-48"><a href="#cb2-48"></a>    <span class="at">data =</span> hungerford_lines,</span>
<span id="cb2-49"><a href="#cb2-49"></a>    <span class="at">arrow =</span> <span class="fu">arrow</span>(<span class="at">length =</span> <span class="fu">unit</span>(<span class="dv">3</span>, <span class="st">&quot;mm&quot;</span>), <span class="at">type =</span> <span class="st">&quot;closed&quot;</span>),</span>
<span id="cb2-50"><a href="#cb2-50"></a>    <span class="at">curvature =</span> <span class="sc">-</span><span class="fl">0.2</span>,</span>
<span id="cb2-51"><a href="#cb2-51"></a>    <span class="at">colour =</span> <span class="st">&quot;darkorange4&quot;</span></span>
<span id="cb2-52"><a href="#cb2-52"></a>  ) <span class="sc">+</span></span>
<span id="cb2-53"><a href="#cb2-53"></a>  <span class="co"># Add points</span></span>
<span id="cb2-54"><a href="#cb2-54"></a>  <span class="fu">geom_point</span>(</span>
<span id="cb2-55"><a href="#cb2-55"></a>    <span class="fu">aes</span>(<span class="at">x =</span> easting, <span class="at">y =</span> northing),</span>
<span id="cb2-56"><a href="#cb2-56"></a>    <span class="at">data =</span> hungerford_shootings,</span>
<span id="cb2-57"><a href="#cb2-57"></a>    <span class="at">shape =</span> <span class="dv">21</span>,</span>
<span id="cb2-58"><a href="#cb2-58"></a>    <span class="at">colour =</span> <span class="st">&quot;white&quot;</span>,</span>
<span id="cb2-59"><a href="#cb2-59"></a>    <span class="at">fill =</span> <span class="st">&quot;darkorange4&quot;</span>,</span>
<span id="cb2-60"><a href="#cb2-60"></a>    <span class="at">size =</span> <span class="dv">3</span></span>
<span id="cb2-61"><a href="#cb2-61"></a>  ) <span class="sc">+</span></span>
<span id="cb2-62"><a href="#cb2-62"></a>  <span class="co"># Add labels</span></span>
<span id="cb2-63"><a href="#cb2-63"></a>  <span class="fu">geom_label_repel</span>(</span>
<span id="cb2-64"><a href="#cb2-64"></a>    <span class="fu">aes</span>(<span class="at">x =</span> easting, <span class="at">y =</span> northing, <span class="at">label =</span> order),</span>
<span id="cb2-65"><a href="#cb2-65"></a>    <span class="at">data =</span> <span class="fu">filter</span>(hungerford_shootings, order <span class="sc">%in%</span> <span class="dv">1</span><span class="sc">:</span><span class="dv">2</span>),</span>
<span id="cb2-66"><a href="#cb2-66"></a>    <span class="at">colour =</span> <span class="st">&quot;white&quot;</span>,</span>
<span id="cb2-67"><a href="#cb2-67"></a>    <span class="at">fill =</span> <span class="st">&quot;darkorange4&quot;</span>,</span>
<span id="cb2-68"><a href="#cb2-68"></a>    <span class="at">fontface =</span> <span class="st">&quot;bold&quot;</span>,</span>
<span id="cb2-69"><a href="#cb2-69"></a>    <span class="at">linewidth =</span> <span class="dv">0</span></span>
<span id="cb2-70"><a href="#cb2-70"></a>  ) <span class="sc">+</span></span>
<span id="cb2-71"><a href="#cb2-71"></a>  <span class="co"># Add scale bar</span></span>
<span id="cb2-72"><a href="#cb2-72"></a>  <span class="fu">annotation_scale</span>(<span class="at">style =</span> <span class="st">&quot;ticks&quot;</span>, <span class="at">line_col =</span> <span class="st">&quot;grey40&quot;</span>, <span class="at">text_col =</span> <span class="st">&quot;grey40&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-73"><a href="#cb2-73"></a>  <span class="co"># Expand the map to show a larger area above/below the data</span></span>
<span id="cb2-74"><a href="#cb2-74"></a>  <span class="fu">scale_y_continuous</span>(<span class="at">expand =</span> <span class="fu">expansion</span>(<span class="dv">2</span>)) <span class="sc">+</span></span>
<span id="cb2-75"><a href="#cb2-75"></a>  <span class="co"># Specify coordinate system</span></span>
<span id="cb2-76"><a href="#cb2-76"></a>  <span class="fu">coord_sf</span>(<span class="at">crs =</span> <span class="st">&quot;EPSG:27700&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-77"><a href="#cb2-77"></a>  <span class="co"># Add title</span></span>
<span id="cb2-78"><a href="#cb2-78"></a>  <span class="fu">labs</span>(<span class="at">title =</span> <span class="st">&quot;Shootings in Wiltshire&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-79"><a href="#cb2-79"></a>  <span class="fu">theme_void</span>() <span class="sc">+</span></span>
<span id="cb2-80"><a href="#cb2-80"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-81"><a href="#cb2-81"></a>    <span class="at">panel.border =</span> <span class="fu">element_rect</span>(<span class="at">colour =</span> <span class="st">&quot;grey20&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>),</span>
<span id="cb2-82"><a href="#cb2-82"></a>    <span class="at">plot.title =</span> <span class="fu">element_text</span>(<span class="at">margin =</span> <span class="fu">margin</span>(<span class="at">b =</span> <span class="sc">-</span><span class="dv">18</span>))</span>
<span id="cb2-83"><a href="#cb2-83"></a>  )</span>
<span id="cb2-84"><a href="#cb2-84"></a></span>
<span id="cb2-85"><a href="#cb2-85"></a><span class="co"># Create detail map showing shootings in Hungerford town</span></span>
<span id="cb2-86"><a href="#cb2-86"></a>hungerford_map_town <span class="ot">&lt;-</span> <span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb2-87"><a href="#cb2-87"></a>  <span class="fu">annotation_map_tile</span>(<span class="at">type =</span> <span class="st">&quot;cartolight&quot;</span>, <span class="at">zoomin =</span> <span class="dv">0</span>, <span class="at">progress =</span> <span class="st">&quot;none&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-88"><a href="#cb2-88"></a>  <span class="co"># Add lines between points</span></span>
<span id="cb2-89"><a href="#cb2-89"></a>  <span class="fu">geom_curve</span>(</span>
<span id="cb2-90"><a href="#cb2-90"></a>    <span class="fu">aes</span>(<span class="at">x =</span> x_start, <span class="at">y =</span> y_start, <span class="at">xend =</span> x_end, <span class="at">yend =</span> y_end),</span>
<span id="cb2-91"><a href="#cb2-91"></a>    <span class="at">data =</span> <span class="fu">slice</span>(hungerford_lines, <span class="dv">3</span><span class="sc">:</span><span class="fu">n</span>()),</span>
<span id="cb2-92"><a href="#cb2-92"></a>    <span class="at">arrow =</span> <span class="fu">arrow</span>(<span class="at">length =</span> <span class="fu">unit</span>(<span class="dv">3</span>, <span class="st">&quot;mm&quot;</span>), <span class="at">type =</span> <span class="st">&quot;closed&quot;</span>),</span>
<span id="cb2-93"><a href="#cb2-93"></a>    <span class="at">curvature =</span> <span class="sc">-</span><span class="fl">0.2</span>,</span>
<span id="cb2-94"><a href="#cb2-94"></a>    <span class="at">colour =</span> <span class="st">&quot;darkorange4&quot;</span></span>
<span id="cb2-95"><a href="#cb2-95"></a>  ) <span class="sc">+</span></span>
<span id="cb2-96"><a href="#cb2-96"></a>  <span class="co"># Add points</span></span>
<span id="cb2-97"><a href="#cb2-97"></a>  <span class="fu">geom_point</span>(</span>
<span id="cb2-98"><a href="#cb2-98"></a>    <span class="fu">aes</span>(<span class="at">x =</span> easting, <span class="at">y =</span> northing),</span>
<span id="cb2-99"><a href="#cb2-99"></a>    <span class="at">data =</span> <span class="fu">slice</span>(hungerford_shootings, <span class="dv">3</span><span class="sc">:</span><span class="fu">n</span>()),</span>
<span id="cb2-100"><a href="#cb2-100"></a>    <span class="at">shape =</span> <span class="dv">21</span>,</span>
<span id="cb2-101"><a href="#cb2-101"></a>    <span class="at">colour =</span> <span class="st">&quot;white&quot;</span>,</span>
<span id="cb2-102"><a href="#cb2-102"></a>    <span class="at">fill =</span> <span class="st">&quot;darkorange4&quot;</span>,</span>
<span id="cb2-103"><a href="#cb2-103"></a>    <span class="at">size =</span> <span class="dv">3</span></span>
<span id="cb2-104"><a href="#cb2-104"></a>  ) <span class="sc">+</span></span>
<span id="cb2-105"><a href="#cb2-105"></a>  <span class="co"># Add labels</span></span>
<span id="cb2-106"><a href="#cb2-106"></a>  <span class="fu">geom_label_repel</span>(</span>
<span id="cb2-107"><a href="#cb2-107"></a>    <span class="fu">aes</span>(<span class="at">x =</span> easting, <span class="at">y =</span> northing, <span class="at">label =</span> order),</span>
<span id="cb2-108"><a href="#cb2-108"></a>    <span class="at">data =</span> <span class="fu">slice</span>(hungerford_shootings, <span class="dv">3</span><span class="sc">:</span><span class="fu">n</span>()),</span>
<span id="cb2-109"><a href="#cb2-109"></a>    <span class="at">colour =</span> <span class="st">&quot;white&quot;</span>,</span>
<span id="cb2-110"><a href="#cb2-110"></a>    <span class="at">fill =</span> <span class="st">&quot;darkorange4&quot;</span>,</span>
<span id="cb2-111"><a href="#cb2-111"></a>    <span class="at">fontface =</span> <span class="st">&quot;bold&quot;</span>,</span>
<span id="cb2-112"><a href="#cb2-112"></a>    <span class="at">linewidth =</span> <span class="dv">0</span></span>
<span id="cb2-113"><a href="#cb2-113"></a>  ) <span class="sc">+</span></span>
<span id="cb2-114"><a href="#cb2-114"></a>  <span class="co"># Add scale bar</span></span>
<span id="cb2-115"><a href="#cb2-115"></a>  <span class="fu">annotation_scale</span>(<span class="at">style =</span> <span class="st">&quot;ticks&quot;</span>, <span class="at">line_col =</span> <span class="st">&quot;grey40&quot;</span>, <span class="at">text_col =</span> <span class="st">&quot;grey40&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-116"><a href="#cb2-116"></a>  <span class="co"># Expand the map to show a larger area around the data</span></span>
<span id="cb2-117"><a href="#cb2-117"></a>  <span class="fu">scale_x_continuous</span>(<span class="at">expand =</span> <span class="fu">expansion</span>(<span class="fl">0.3</span>)) <span class="sc">+</span></span>
<span id="cb2-118"><a href="#cb2-118"></a>  <span class="fu">scale_y_continuous</span>(<span class="at">expand =</span> <span class="fu">expansion</span>(<span class="fl">0.3</span>)) <span class="sc">+</span></span>
<span id="cb2-119"><a href="#cb2-119"></a>  <span class="co"># Specify coordinate system</span></span>
<span id="cb2-120"><a href="#cb2-120"></a>  <span class="fu">coord_sf</span>(<span class="at">crs =</span> <span class="st">&quot;EPSG:27700&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-121"><a href="#cb2-121"></a>  <span class="fu">labs</span>(<span class="at">title =</span> <span class="st">&quot;Shootings in Hungerford town&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-122"><a href="#cb2-122"></a>  <span class="fu">theme_void</span>() <span class="sc">+</span></span>
<span id="cb2-123"><a href="#cb2-123"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-124"><a href="#cb2-124"></a>    <span class="at">panel.border =</span> <span class="fu">element_rect</span>(<span class="at">colour =</span> <span class="st">&quot;grey20&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>),</span>
<span id="cb2-125"><a href="#cb2-125"></a>    <span class="at">plot.margin =</span> <span class="fu">margin</span>(<span class="at">t =</span> <span class="dv">12</span>)</span>
<span id="cb2-126"><a href="#cb2-126"></a>  )</span>
<span id="cb2-127"><a href="#cb2-127"></a></span>
<span id="cb2-128"><a href="#cb2-128"></a></span>
<span id="cb2-129"><a href="#cb2-129"></a><span class="co"># Combine maps and add titles --------------------------------------------------</span></span>
<span id="cb2-130"><a href="#cb2-130"></a></span>
<span id="cb2-131"><a href="#cb2-131"></a>hungerford_map <span class="ot">&lt;-</span> (hungerford_map_overall <span class="sc">/</span> hungerford_map_town) <span class="sc">+</span></span>
<span id="cb2-132"><a href="#cb2-132"></a>  <span class="fu">plot_annotation</span>(</span>
<span id="cb2-133"><a href="#cb2-133"></a>    <span class="at">title =</span> <span class="st">&quot;Shootings during the Hungerford massacre&quot;</span>,</span>
<span id="cb2-134"><a href="#cb2-134"></a>    <span class="at">caption =</span> <span class="fu">str_glue</span>(</span>
<span id="cb2-135"><a href="#cb2-135"></a>      <span class="st">&quot;Data from the official report into the shootings</span><span class="sc">\n</span><span class="st">Map tiles ©: CARTO; &quot;</span>,</span>
<span id="cb2-136"><a href="#cb2-136"></a>      <span class="st">&quot;data © OpenStreetMap contributors&quot;</span></span>
<span id="cb2-137"><a href="#cb2-137"></a>    ),</span>
<span id="cb2-138"><a href="#cb2-138"></a>    <span class="at">theme =</span> <span class="fu">theme</span>(</span>
<span id="cb2-139"><a href="#cb2-139"></a>      <span class="at">plot.caption =</span> <span class="fu">element_text</span>(<span class="at">colour =</span> <span class="st">&quot;grey40&quot;</span>, <span class="at">hjust =</span> <span class="dv">0</span>),</span>
<span id="cb2-140"><a href="#cb2-140"></a>      <span class="at">plot.title =</span> <span class="fu">element_text</span>(<span class="at">colour =</span> <span class="st">&quot;grey50&quot;</span>, <span class="at">face =</span> <span class="st">&quot;bold&quot;</span>, <span class="at">size =</span> <span class="dv">14</span>)</span>
<span id="cb2-141"><a href="#cb2-141"></a>    )</span>
<span id="cb2-142"><a href="#cb2-142"></a>  )</span>
<span id="cb2-143"><a href="#cb2-143"></a></span>
<span id="cb2-144"><a href="#cb2-144"></a><span class="fu">ggsave</span>(</span>
<span id="cb2-145"><a href="#cb2-145"></a>  <span class="fu">here</span>(<span class="st">&quot;output&quot;</span>, <span class="st">&quot;hungerford_map.jpg&quot;</span>),</span>
<span id="cb2-146"><a href="#cb2-146"></a>  hungerford_map,</span>
<span id="cb2-147"><a href="#cb2-147"></a>  <span class="at">width =</span> <span class="dv">900</span> <span class="sc">/</span> <span class="dv">150</span>,</span>
<span id="cb2-148"><a href="#cb2-148"></a>  <span class="at">height =</span> <span class="dv">900</span> <span class="sc">/</span> <span class="dv">150</span>,</span>
<span id="cb2-149"><a href="#cb2-149"></a>  <span class="at">dpi =</span> <span class="dv">150</span></span>
<span id="cb2-150"><a href="#cb2-150"></a>)</span></code></pre></div>
<figcaption>Code 16.13</figcaption>
</figure>

<a id="further-reading"></a>

## 16.5 Further reading

- The [Crime Linkage International NetworK](https://more.bham.ac.uk/c-link/) provides information about research and practice in behavioural case linkage.
- The official [patchwork documentation](https://patchwork.data-imaginist.com/) includes further examples of arranging and annotating multiple plots.

[Photograph of PC Roger Brereton's funeral](https://www.getreading.co.uk/news/berkshire-history/gallery/30-years-hungerford-massacre-13495555) from Berkshire Live, [artwork by Allison Horst](https://allisonhorst.com/).

QuizCheck your knowledge: Revision questions

Answer these questions to check you have understood the main points covered in this chapter. Write between 50 and 100 words to answer each question.

1.  What is a crime series, and in what circumstances might mapping a series provide information that would not be visible if each crime were considered separately?
2.  What challenges do investigators face when trying to determine whether crimes are linked?
3.  Why is it useful to visualise a crime series on a map? Give some examples of when a map of a crime series might be useful.
4.  Explain the role of arrows and labels in mapping crime series. How do these elements help improve the clarity of crime maps?
5.  Describe the steps taken to prepare a dataset for mapping a crime series in R. Why is it necessary to create a dataset of linked points?
