Source: https://books.lesscrime.info/learncrimemapping/06_mapping_crime_patterns/index.html

<a id="quarto-document-content"></a>
<a id="title-block-header"></a>
<a id="mapping-crime-patterns"></a>

# `<a id="sec-mapping-patterns"></a>`{=html}6  Mapping crime patterns

Figure: Students compare point locations with broad purple density bands on a map.

This chapter introduces techniques for mapping concentrations of recorded crime using a technique called kernel density estimation (KDE). We will learn how to produce a clear density map that shows where crime is most concentrated.

TipBefore you start

1.  Open Positron or -- if you already have Positron open -- start a new R session by clicking the **Restart R** (**⟳**) button in the **Console** panel. This makes sure no code you ran previously will interfere with the work you do in this chapter.
2.  Make sure you are working in the crime mapping project workspace you created in [Section 1.5](../01_getting_started/index.llms.md#sec-create-project). In the top-right corner of the Positron window, you should see a folder icon and the words `crime_mapping`. If not, click the **File** menu, then **Open Folder ...** and choose the `crime_mapping` folder.

<a id="introduction"></a>

## 6.1 Introduction

In [Chapter 5](../05_your_second_crime_map/index.llms.md), we created a map showing bike thefts in the City of Vancouver. It was hard to see the overall pattern because many of the points representing theft locations overlapped. Dot maps can be useful when there are relatively few events or when exact locations matter, but density maps are often more effective for showing patterns in large point datasets. In this chapter we will learn how to estimate the density of recorded bike thefts and show it on a map.

By the end of the chapter, you will have produced this map:

<a id="map-vancouver-bicycle-theft-density-introduction"></a>

<figure>
<figure>
<p>Figure: Density map of recorded bicycle thefts in Vancouver in 2020. Darker blue indicates higher estimated density, strongest on the Downtown peninsula and around the north-central neighbourhoods south of False Creek. Density is lower towards the southern edge. Green neighbourhood boundaries and labels provide location context on a pale street map.</p>
</figure>
<figcaption>Map 6.1</figcaption>
</figure>

In this chapter, we will learn how to:

- estimate a density layer using `hotspot_kde()`;
- choose an appropriate projected coordinate reference system;
- adjust grid-cell size and bandwidth;
- choose an appropriate sequential colour scale;
- clip a density layer to the area covered by the data using `hotspot_clip()`; and
- add neighbourhood boundaries and labels.

The process we will use to produce the map has four main stages:

Load

download data from the internet and load it into an R session

Wrangle

data into the format we need

Model

data using kernel density estimation

Visualise

density on a map

In [Chapter 5](../05_your_second_crime_map/index.llms.md) you created `chapter_05.R`, which contains the code needed to download, load and prepare the Vancouver bike-theft data. We will make a copy of that script and add the code needed for this chapter:

1.  In Positron's **Explorer** panel, expand the `R` folder if necessary.
2.  Right-click `chapter_05.R` and choose **Copy**.
3.  Right-click the `R` folder and choose **Paste**.
4.  Right-click the copied file, choose **Rename**, type `chapter_06.R` and press .

Take care to copy the file rather than renaming the original. Keep `chapter_06.R` in the `R` folder throughout this chapter.

Update the comment at the top of `chapter_06.R` to explain that this script produces a density map of bicycle thefts in Vancouver in 2020.

Open `chapter_06.R` and remove the final line, which uses `hotspot_map()` to produce the previous dot map of bike thefts. During this chapter we will add new code to the `chapter_06.R` file to produce a map of crime density.

After you have removed the final line from the code, run the rest of the code in the file by selecting all the code and pressing on your keyboard.

<a id="sec-kde"></a>
<a id="mapping-crime-density"></a>

## 6.2 Mapping crime density

When we speak about the *density* of crime, we mean the relative concentration of points in each part of the area we are studying, i.e. how many points (in this case, representing bike thefts) are there in each part of the map *relative to all the other areas of the map*.

To estimate the density of points in different areas of the map, R uses a technique called *kernel density estimation* (KDE). To do this, R must:

1.  divide the map into a grid of cells, each the same size,
2.  count the number of points in each cell,
3.  for each cell, count the number of points in nearby cells, but give less weight to (i.e. systematically undercount) those cells that are further away,
4.  for each cell, total up the count of points in that cell and the (weighted) count of points in nearby cells -- this is the estimate of the density of points in that cell.

<figure>
<p>Figure: Four diagrams explaining kernel density estimation: create a grid, consider the event points around each cell, give closer events more influence than distant events, and store the resulting density estimate for every cell.</p>
</figure>

[](https://github.com/mpjashby/sfhotspot/)

There are several ways we can make density maps in R. In this course we will use the [sfhotspot package](https://pkgs.lesscrime.info/sfhotspot/) because it makes reasonable default decisions about how density maps should look, while still giving us control over their appearance if we want it. sfhotspot also has other useful functions that we will use in [Chapter 13](../13_mapping_hotspots/index.llms.md).

To create a density map using sfhotspot, we first use the `hotspot_kde()` function to convert a dataset of offence locations to an estimate of the density of offences for each cell in a grid. `hotspot_kde()` automatically chooses how big the cells in the grid should be (but we can set this ourselves if we want to).

Add this code to the script file for this chapter and then run that line of code:

<a id="lst-mapping-crime-patterns-script-06-initial-density"></a>

<figure>
<pre><code>chapter_06.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Estimate density of bike thefts</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>bike_theft_density <span class="ot">&lt;-</span> <span class="fu">hotspot_kde</span>(</span>
<span id="cb2-3"><a href="#cb2-3"></a>  bike_thefts,</span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="at">bandwidth_adjust =</span> <span class="fl">0.5</span>,</span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="at">quiet =</span> <span class="cn">TRUE</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>)</span></code></pre></div>
<figcaption>Code 6.1</figcaption>
</figure>

TipWhy did we specify `quiet = TRUE`?

<a id="callout-2"></a>

The `quiet = TRUE` argument to the `hotspot_*()` family of functions (including `hotspot_kde()`) stops the function from producing progress messages as we go along. If you experience any problems using the `hotspot_kde()` function, the best place to start in working out what has happened is to run the code again with the `quiet = TRUE` argument removed.

As usual, we can use the `head()` function to check what the resulting object looks like:

<a id="lst-mapping-crime-patterns-head-bike-theft-density"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">head</span>(bike_theft_density)</span></code></pre></div>
<figcaption>Code 6.2</figcaption>
</figure>

    Simple feature collection with 6 features and 2 fields
    Geometry type: POLYGON
    Dimension:     XY
    Bounding box:  xmin: 490447.2 ymin: 5450107 xmax: 491647.2 ymax: 5450307
    Projected CRS: WGS 84 / UTM zone 10N
    # A tibble: 6 × 3
          n   kde                                                           geometry
      <dbl> <dbl>                                                      <POLYGON [m]>
    1     0  2.76 ((490447.2 5450107, 490447.2 5450307, 490647.2 5450307, 490647.2 …
    2     0  2.24 ((490647.2 5450107, 490647.2 5450307, 490847.2 5450307, 490847.2 …
    3     0  2.04 ((490847.2 5450107, 490847.2 5450307, 491047.2 5450307, 491047.2 …
    4     0  2.63 ((491047.2 5450107, 491047.2 5450307, 491247.2 5450307, 491247.2 …
    5     0  3.24 ((491247.2 5450107, 491247.2 5450307, 491447.2 5450307, 491447.2 …
    6     0  3.13 ((491447.2 5450107, 491447.2 5450307, 491647.2 5450307, 491647.2 …

The `bike_theft_density` object created by `hotspot_kde()` contains three columns: `n` contains the count of bike thefts in each cell, `kde` contains the estimate of the density of thefts in each cell, and `geometry` contains the outline of each grid cell.

`hotspot_kde()` produces an object that `hotspot_map()` recognises and can use to automatically produce a density map. We will need to customise this map somewhat to make it useful, but for now we can use `hotspot_map()` to produce a basic density map of bike thefts in Vancouver:

<a id="lst-mapping-crime-patterns-draw-vancouver-bicycle-theft-density-basic"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">hotspot_map</span>(bike_theft_density)</span></code></pre></div>
<figcaption>Code 6.3</figcaption>
</figure>

<a id="map-vancouver-bicycle-theft-density-basic"></a>

<figure>
<figure>
<p>Figure: Grid-based density map of recorded bicycle thefts in Vancouver in 2020 over a coloured street map. Darker blue cells indicate higher estimated density, concentrated on the Downtown peninsula and just south of False Creek. Paler cells extend across the city, with lower density towards the south.</p>
</figure>
<figcaption>Map 6.2</figcaption>
</figure>

In this map, instead of seeing each crime as a separate point, we see the density of crime as the filled colour of cells in a grid. By comparing this density map to the point map we produced before, we can see that the density map makes the areas with the highest frequency of thefts slightly easier to identify (although we will improve it much further below).

You can also see that our map now has a legend, showing that higher densities of bike thefts are shown on the map in dark blue and lower densities are shown in light blue.

QuizDensity mapping

**What is a key advantage of using KDE over dot maps for crime data?**

- It helps make spatial patterns in data more apparent. (Correct answer)
- It shows the exact location of each crime point.
- It allows for interactive maps that users can click on.
- It removes crime data points from the map.

**Which R function is used to create a density layer from point data?**

- hotspot_map()
- hotspot_density()
- hotspot_kde() (Correct answer)
- st_point_to_kde()

<a id="sec-choosing-projected-crs"></a>
<a id="choosing-a-projected-coordinate-reference-system"></a>

### 6.2.1 Choosing a projected coordinate reference system

As we learned in [Chapter 5](../05_your_second_crime_map/index.llms.md), spatial data can use different coordinate reference systems (CRSs). Data that use a geographic CRS usually store locations as longitude and latitude measured in decimal degrees. Decimal degrees are difficult to use for parameters that represent distances: for example, a cell size of `0.002` degrees is much less intuitive than a cell size of 200 metres. A *projected* CRS designed for the part of the world we are analysing will often use familiar units such as metres, making distances easier to specify and interpret.

The `hotspot_kde()` function automatically transforms data to a suitable projected CRS in the background if necessary, so you do not need to transform longitude and latitude data before using that function. Other spatial functions do not always do this automatically, however, and we will sometimes want to choose a projected CRS ourselves.

The `suggest_crs()` function from the crsuggest package can identify projected CRSs designed for the area covered by a spatial dataset. Run this code in the R Console to see suitable CRSs for the Vancouver bike-theft data:

<a id="lst-mapping-crime-patterns-suggest-crs-bike-thefts"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>crsuggest<span class="sc">::</span><span class="fu">suggest_crs</span>(bike_thefts)</span></code></pre></div>
<figcaption>Code 6.4</figcaption>
</figure>

    # A tibble: 10 × 6
       crs_code crs_name                        crs_type crs_gcs crs_units crs_proj4
       <chr>    <chr>                           <chr>      <dbl> <chr>     <chr>    
     1 3153     NAD83(CSRS) / BC Albers         project…    4617 m         +proj=ae…
     2 3005     NAD83 / BC Albers               project…    4269 m         +proj=ae…
     3 26710    NAD27 / UTM zone 10N            project…    4267 m         +proj=ut…
     4 3157     NAD83(CSRS) / UTM zone 10N      project…    4617 m         +proj=ut…
     5 26910    NAD83 / UTM zone 10N            project…    4269 m         +proj=ut…
     6 32610    WGS 84 / UTM zone 10N           project…    4326 m         +proj=ut…
     7 32410    WGS 72BE / UTM zone 10N         project…    4324 m         +proj=ut…
     8 32210    WGS 72 / UTM zone 10N           project…    4322 m         +proj=ut…
     9 3979     NAD83(CSRS) / Canada Atlas Lam… project…    4617 m         +proj=lc…
    10 3978     NAD83 / Canada Atlas Lambert    project…    4269 m         +proj=lc…

`suggest_crs()` returns a table of possible coordinate systems. The `crs_code` column gives the EPSG code that we can use with `st_transform()`, while `crs_name` describes the coordinate system and `crs_units` shows the units it uses. In general, we can use the CRS in the first row as long as its units are metres. If it uses unfamiliar units, we can choose the first suggested CRS that uses metres instead.

The Vancouver data already use UTM zone 10N (`EPSG:32610`), an appropriate projected CRS whose coordinates are measured in metres, so we do not need to transform them. When a transformation is needed, we can pass the chosen code to `st_transform()`. For example, `bike_thefts |> st_transform("EPSG:3153")` would transform the Vancouver data to the first CRS suggested in the table.

<a id="sec-mapping-crime-patterns-fine-tuning-cell-size-and-bandwidth"></a>
<a id="fine-tuning-cell-size-and-bandwidth"></a>

### 6.2.2 Fine-tuning cell size and bandwidth

We can control the appearance of KDE maps in several ways. For example, we can vary the number of cells in the grid and the definition of what cells the kernel density estimation process should consider to be 'nearby' for the purposes of calculating weighted counts. Cells are considered to be 'nearby' to a particular cell if they are closer to that cell than a distance known as the KDE *bandwidth*.

By default, `hotspot_kde()` chooses the cell size and the bandwidth automatically. The panels in [Map 6.3](#map-vancouver-kde-cell-size-and-bandwidth) show how changing these defaults changes the appearance of our map (with the legend and axes removed to make the small maps clearer).

<a id="map-vancouver-kde-cell-size-and-bandwidth"></a>

<figure>
<figure>
<p>Figure: Fifteen Vancouver bicycle-theft density maps form five rows and three columns. Cell size increases left to right and bandwidth decreases top to bottom. Larger cells make the surface blockier; larger bandwidths merge concentrations into smooth broad patches; the smallest bandwidth fragments them. A description of the panel settings follows.</p>
</figure>
<figcaption>Map 6.3</figcaption>
</figure>

NoteMap description: cell size and bandwidth comparison

<a id="callout-4"></a>

All fifteen panels use the same Vancouver bicycle-theft locations. Columns use one, two and four times the default cell size, from left to right. Rows use four, two, one, one half and one quarter of the default bandwidth, from top to bottom.

Across a row, larger grid cells turn smooth-looking shapes into visible blocks. Down a column, reducing bandwidth separates a broad northern concentration into several smaller patches; at the smallest bandwidth, many isolated pale spots appear. Changing these settings changes how the same events are represented, rather than changing where the thefts occurred.

By looking at the maps on the right-hand side, you can see that reducing the number of grid cells leads to a map that looks blocky and lacks information. Looking at the maps towards the top of [Map 6.3](#map-vancouver-kde-cell-size-and-bandwidth), you can see that increasing the bandwidth relative to the default makes the density surface smoother. The smoother the surface, the less detail we can see about where crime is most concentrated, until on the top row we can see almost no information at all. On the other hand, if we reduce the bandwidth too much (the bottom row of maps), each estimate is influenced by only the closest events, so the surface becomes fragmented and it is more difficult to identify broader patterns.

In many cases, you will not need to change the cell size used in calculating the density of points on a map, but if you do then you can do this using the `cell_size` argument to `hotspot_kde()`. A cell size of about 200 metres is often a good choice for maps showing a whole city, such as our map of Vancouver. However, for larger cities you might want to use a larger cell size and for maps of neighbourhoods you will usually want to use a smaller cell size.

Although you can set the bandwidth manually using the `bandwidth` argument to `hotspot_kde()`, you will almost never want to do this. Instead, you can vary the bandwidth relative to the automatically chosen default bandwidth by using the `bandwidth_adjust` argument. For example, if you wanted to see more detail in your map by using a smaller bandwidth, you could use `bandwidth_adjust = 0.75` or `bandwidth_adjust = 3/4` to set the bandwidth to be three-quarters of the default bandwidth.

ImportantStart with `bandwidth_adjust = 0.5`

I recommend using a slightly smaller bandwidth than the default, so that your maps show a bit more detail. Try setting `bandwidth_adjust = 0.5` whenever you produce a density layer using `hotspot_kde()`, but remember to look at the map to see if you are happy with the result. If you are not happy, try varying the value of `bandwidth_adjust`. It is possible to set a value greater than 1, but it is very unlikely that this would produce the most-informative possible map.

QuizMaking density maps

**What R package do we use to make density maps using the `hotspot_kde()` function?**

- dplyr
- ggplot2
- sf
- sfhotspot (Correct answer)

**What is the `bandwidth_adjust` argument of the function `hotspot_kde()` used for?**

- Adjusting the bandwidth of the density layer, relative to the default bandwidth (Correct answer)
- Adjusting the cell size of the density layer, relative to the default cell size
- Adjusting the colour scheme used to represent density on the map
- Adjusting the bandwidth of the density layer, relative to a bandwidth of zero

**In what circumstances is it appropriate to use a diverging colour scale, e.g. one that goes from blue to white to red?**

- To represent variation in a variable from low to high
- To represent variation in a variable above and below a meaningful mid-point (Correct answer)
- To represent variation in a variable from high to low
- To represent categories in a categorical variable

**Why is it a bad idea to use a diverging colour scheme for crime density maps?**

- It highlights low-density areas more clearly.
- It can mislead the viewer by suggesting a central point of significance. (Correct answer)
- It makes the map look too colourful, which can be distracting.
- It hides the areas with the highest crime density.

<a id="sec-clipping-map-layers"></a>
<a id="clipping-map-layers"></a>

## 6.3 Clipping map layers

There is one limitation of the KDE layer on our map that we need to deal with. The area covered by the KDE layer is determined by the area covered by the point data that we provided to `hotspot_kde()`. More specifically, `hotspot_kde()` will calculate density values for every cell in the *convex hull* around the point data, i.e. for the smallest polygon that contains all the points in the data.

This can be a problem in some circumstances, because we do not necessarily have crime data for all the areas within the convex hull of the data, even though KDE values will be calculated for those areas. This could be misleading, since it will look like such areas have low crime density, when in fact we do not know what the density of crime in such areas is because they are outside the area for which we have crime data..

Fortunately, we can easily deal with this problem by *clipping* the KDE layer to the boundary of the area for which we have crime data. This means we will only show densities for cells for which we actually have data.

A. We only have data on bike thefts from the City of Vancouver, so all the bike thefts in the data necessarily occurred within the city. We do not know what the density of recorded bike theft outside the city is.

<a id="map-vancouver-clipping-stage-points"></a>

<figure>
Figure: Map of a sample of Vancouver bicycle-theft locations as grey dots inside a solid green city boundary. The dots are most tightly grouped towards the north; scattered points extend further south and west. The irregular boundary marks the area for which crime data are available.
<figcaption>Map 6.4</figcaption>
</figure>

B. The KDE function only knows the theft locations, not the area in which thefts could have occurred. So the convex hull created by the KDE layer will not necessarily match the area of the data.

<a id="map-vancouver-clipping-stage-convex-hull"></a>

<figure>
Figure: Dashed green convex hull around a sample of Vancouver bicycle-theft locations. Straight edges form the smallest convex polygon enclosing every grey point; the polygon fills gaps between outlying points, including areas where no incidents are plotted. The city boundary is not shown in this panel.
<figcaption>Map 6.5</figcaption>
</figure>

C. In this case, that means some areas (shaded) will be included in the KDE layer even though they are outside the area covered by the data, which could be misleading.

<a id="map-vancouver-clipping-stage-outside-boundary"></a>

<figure>
Figure: Map combining the solid green Vancouver city boundary and dashed convex hull around sampled bicycle-theft points. Green-filled areas, especially along the northern edge, lie inside the hull but outside the city. Estimating density there would suggest information about places not covered by the crime data.
<figcaption>Map 6.6</figcaption>
</figure>

D. To avoid suggesting we know the density of crimes in areas for which we do not have data, we should clip the KDE layer to the boundary of the area for which we have data.

<a id="map-vancouver-clipping-stage-clipped-density"></a>

<figure>
Figure: Density surface for sampled Vancouver bicycle thefts, clipped to the solid green city boundary. Darker green grid cells mark higher density in the north-central concentration. The dashed convex hull extends beyond the city in places, but the shaded density layer stops at the city boundary rather than covering those gaps.
<figcaption>Map 6.7</figcaption>
</figure>

You might see from these maps that there is another problem: some areas *within* the City of Vancouver are not covered by the KDE layer. We'll deal with that problem in [Chapter 7](../07_map_context/index.llms.md). But for now, to clip the KDE layer to the boundary of the area for which we have data, we need a new dataset that contains the boundary of the City of Vancouver. Fortunately this dataset is available online in a spatial format known as a [GeoJSON](https://en.wikipedia.org/wiki/GeoJSON) file. GeoJSON is a spatial file format, so we can load it in R using the `read_sf()` function from the sf package.

As we did for the theft data in [Section 5.4.1](../05_your_second_crime_map/index.llms.md#sec-your-second-crime-map-reading-spatial-data), we will first download the boundary data into `data/raw`, then read the local copy. This records where the data came from while keeping the analysis available if the website is temporarily unavailable later. Add this code immediately after the existing code that downloads the theft data but *above* the code that loads and wrangles the data.

<a id="lst-mapping-crime-patterns-script-06-download-boundaries"></a>

<figure>
<pre><code>chapter_06.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Download Vancouver neighbourhood boundaries</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="fu">request</span>(</span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/vancouver_neighbourhoods.geojson&quot;</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="fu">req_perform</span>(</span>
<span id="cb2-6"><a href="#cb2-6"></a>    <span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;vancouver_neighbourhoods.geojson&quot;</span>)</span>
<span id="cb2-7"><a href="#cb2-7"></a>  )</span></code></pre></div>
<figcaption>Code 6.5</figcaption>
</figure>

Add [Code 6.6](#lst-mapping-crime-patterns-script-06-load-boundaries) after the pipeline that loads and wrangles the bike-theft data and before the code that creates `bike_theft_density`:

<a id="lst-mapping-crime-patterns-script-06-load-boundaries"></a>

<figure>
<pre><code>chapter_06.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Load Vancouver neighbourhood boundaries</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>vancouver_nbhds <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;vancouver_neighbourhoods.geojson&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">read_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:32610&quot;</span>)</span></code></pre></div>
<figcaption>Code 6.6</figcaption>
</figure>

You might have noticed that as well as loading the boundary data with `read_sf()`, we have transformed the data to use the same coordinate system (EPSG:32610) as is used for the `bike_thefts` object. This is because we can only clip datasets that use the same coordinate system.

Before we clip the density layer to the city boundary, check that your file `chapter_06.R` looks like this:

<a id="lst-mapping-crime-patterns-script-06-checkpoint"></a>

<figure>
<pre><code>chapter_06.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This script produces a density map of bicycle thefts in Vancouver in 2020.</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="co"># Load packages</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, httr2, sf, sfhotspot, tidyverse)</span>
<span id="cb2-5"><a href="#cb2-5"></a></span>
<span id="cb2-6"><a href="#cb2-6"></a><span class="co"># Download the raw data to a local file</span></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="fu">request</span>(</span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/vancouver_thefts.csv.gz&quot;</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;vancouver_thefts.csv.gz&quot;</span>))</span>
<span id="cb2-11"><a href="#cb2-11"></a></span>
<span id="cb2-12"><a href="#cb2-12"></a><span class="co"># Download Vancouver neighbourhood boundaries</span></span>
<span id="cb2-13"><a href="#cb2-13"></a><span class="fu">request</span>(</span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/vancouver_neighbourhoods.geojson&quot;</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="fu">req_perform</span>(</span>
<span id="cb2-17"><a href="#cb2-17"></a>    <span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;vancouver_neighbourhoods.geojson&quot;</span>)</span>
<span id="cb2-18"><a href="#cb2-18"></a>  )</span>
<span id="cb2-19"><a href="#cb2-19"></a></span>
<span id="cb2-20"><a href="#cb2-20"></a><span class="co"># Load and wrangle bike theft data</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>thefts <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;vancouver_thefts.csv.gz&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  <span class="fu">read_csv</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>  janitor<span class="sc">::</span><span class="fu">clean_names</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;x&quot;</span>, <span class="st">&quot;y&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:32610&quot;</span>)</span>
<span id="cb2-25"><a href="#cb2-25"></a></span>
<span id="cb2-26"><a href="#cb2-26"></a>bike_thefts <span class="ot">&lt;-</span> <span class="fu">filter</span>(thefts, type <span class="sc">==</span> <span class="st">&quot;Theft of Bicycle&quot;</span>)</span>
<span id="cb2-27"><a href="#cb2-27"></a></span>
<span id="cb2-28"><a href="#cb2-28"></a><span class="co"># Load Vancouver neighbourhood boundaries</span></span>
<span id="cb2-29"><a href="#cb2-29"></a>vancouver_nbhds <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;vancouver_neighbourhoods.geojson&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-30"><a href="#cb2-30"></a>  <span class="fu">read_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-31"><a href="#cb2-31"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:32610&quot;</span>)</span>
<span id="cb2-32"><a href="#cb2-32"></a></span>
<span id="cb2-33"><a href="#cb2-33"></a><span class="co"># Estimate density of bike thefts</span></span>
<span id="cb2-34"><a href="#cb2-34"></a>bike_theft_density <span class="ot">&lt;-</span> <span class="fu">hotspot_kde</span>(</span>
<span id="cb2-35"><a href="#cb2-35"></a>  bike_thefts,</span>
<span id="cb2-36"><a href="#cb2-36"></a>  <span class="at">bandwidth_adjust =</span> <span class="fl">0.5</span>,</span>
<span id="cb2-37"><a href="#cb2-37"></a>  <span class="at">quiet =</span> <span class="cn">TRUE</span></span>
<span id="cb2-38"><a href="#cb2-38"></a>)</span></code></pre></div>
<figcaption>Code 6.7</figcaption>
</figure>

We can clip the KDE layer produced by `hotspot_kde()` to the boundary of the City of Vancouver using the `hotspot_clip()` function from sfhotspot. `hotspot_clip()` keeps the parts of the KDE cells that fall inside the area covered by the boundary layer and removes the rest.

We will now add the code needed to clip the KDE layer to the city boundary to `chapter_06.R`. Since we do not need the unclipped version of the KDE layer in the final map, we can combine `hotspot_kde()` and `hotspot_clip()` in one pipeline. Replace the code that creates `bike_theft_density` with this code:

<a id="lst-mapping-crime-patterns-script-06-initial-clip"></a>

<figure>
<pre><code>chapter_06.R</code></pre>
<a id="annotated-cell-7"></a>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r code-annotation-code number-lines code-with-copy code-annotated"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Estimate density of bike thefts and clip the result</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="dv">1</span>bike_theft_density_clip <span class="ot">&lt;-</span> bike_thefts <span class="sc">|&gt;</span></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="dv">2</span>  <span class="fu">hotspot_kde</span>(<span class="at">bandwidth_adjust =</span> <span class="fl">0.5</span>, <span class="at">quiet =</span> <span class="cn">TRUE</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="dv">3</span>  <span class="fu">hotspot_clip</span>(vancouver_nbhds)</span></code></pre></div>
<figcaption>Code 6.8</figcaption>
</figure>

1
: take the `bike_thefts` object, *and then*

2
: use it to estimate the density of thefts *and then*

3
: clip the resulting density object to the boundary stored in the `vancouver_nbhds` object.

<!-- -->

    Removed 397 rows (12.0% of original rows) from `data`

If you aren't comfortable yet with how the pipe operator works, you might want to refer back to [Section 4.6](../04_transforming_data/index.llms.md#sec-pipe-operator).

ImportantBoth layers must use the same coordinate system

`hotspot_clip()` requires both spatial layers to use the same coordinate system. If the layers use different coordinate systems, transform one of them with `st_transform()` so that it uses the same system as the other layer.

If you do not know which coordinate systems the layers use, you can use the `st_crs()` function to extract the coordinate system from one layer and pass that value as the second argument to `st_transform()`. For example:

``` {.sourceCode .numberSource .r .number-lines .code-with-copy}
st_transform(bike_theft_density, crs = st_crs(vancouver_nbhds))
```

QuizClipping map layers

**What is the purpose of the `hotspot_clip()` function?**

- To transform one dataset into another coordinate system.
- To clip a dataset to the boundary of another spatial layer. (Correct answer)
- To merge multiple spatial layers into one.
- To calculate the centroid of spatial objects.

**Why is it important to clip a KDE layer to a relevant boundary in crime mapping?**

- To remove unnecessary layers.
- To reduce the overall size of the dataset.
- To improve the map's aesthetic appearance.
- To avoid showing incorrect density estimates for areas without data. (Correct answer)

<a id="specifying-a-grid-for-kernel-density-estimation"></a>

## 6.4 Specifying a grid for kernel density estimation

By default, `hotspot_kde()` calculates density estimates (KDE values) for every grid cell within the area (the convex hull) covered by the crime data. This is fine when at least a few crimes have occurred in all the parts of the area for which we have data. But if crime is heavily concentrated in a few places and there are large areas with no crimes, the density layer will not cover the whole area for which we have data. You can see this in [Map 6.7](#map-vancouver-clipping-stage-clipped-density) -- some areas on the outskirts of the city are not covered by the convex hull of the `bike_thefts` data. When this is the case, it is important to extend the density layer manually to make it clear that the apparent low density of crime in some places is due to a genuine lack of recorded crime there, rather than because we do not have data for those places.

We can do this by providing `hotspot_kde()` with a grid of cells for which KDE values should be calculated, rather than letting `hotspot_kde()` create the grid automatically. The easiest way to do this is to use the `hotspot_grid()` function to create a grid that covers all the areas within a set boundary, such as a city boundary.

In the `chapter_06.R` file, replace the code that creates `bike_theft_density_clip` with this code:

<a id="lst-mapping-crime-patterns-script-06-final-density"></a>

<figure>
<pre><code>chapter_06.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Estimate density of bike thefts and clip the result</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>bike_theft_density_clip <span class="ot">&lt;-</span> bike_thefts <span class="sc">|&gt;</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">hotspot_kde</span>(</span>
<span id="cb2-4"><a href="#cb2-4"></a>    <span class="at">grid =</span> <span class="fu">hotspot_grid</span>(vancouver_nbhds, <span class="at">quiet =</span> <span class="cn">TRUE</span>),</span>
<span id="cb2-5"><a href="#cb2-5"></a>    <span class="at">bandwidth_adjust =</span> <span class="fl">0.5</span>,</span>
<span id="cb2-6"><a href="#cb2-6"></a>    <span class="at">quiet =</span> <span class="cn">TRUE</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="fu">hotspot_clip</span>(vancouver_nbhds)</span></code></pre></div>
<figcaption>Code 6.9</figcaption>
</figure>

    Removed 160 rows (4.9% of original rows) from `data`

You'll see below that the `bike_theft_density_clip` object now contains a grid that covers the whole of Vancouver and no areas outside Vancouver. This stops the density layer from possibly conveying misleading information.

<a id="isobands"></a>

## 6.5 Isobands

KDE maps are extremely useful because they allow us to visualise overall *patterns* of crime much more easily than if we simply plot crimes on a dot map. But the density layers produced by `hotspot_kde()` can sometimes be hard to interpret on a map. One alternative way to visualise density is to convert the density surface to *isobands*. Isobands are polygons that represent areas of equal crime density. You might have seen them on weather maps, where they are sometimes used to visualise areas that are expected to have the same temperature:

Figure: Weather map of surface temperatures across the contiguous United States. Labelled contour lines connect equal temperatures in degrees Fahrenheit, with coloured bands between them. The north is mostly cooler blue and purple, while the south is warmer green, yellow and orange. The example shows how contour lines and shaded bands represent a continuous surface.

We can convert the output produced by `hotspot_kde()` to isobands using the `hotspot_isoband()` function from sfhotspot. This function takes a KDE layer and converts it to a set of polygons that represent areas of equal density. We can then plot these polygons on a map instead of the KDE layer. For example, we can just add `hotspot_isoband()` to the end of the code pipeline we used to create the clipped KDE layer, and then plot the result.

<a id="lst-mapping-crime-patterns-map-isoband"></a>

<figure>
<pre><code>R Console</code></pre>
<a id="annotated-cell-24"></a>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r code-annotation-code number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Estimate density of bike thefts, clip result, and convert to isobands</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>bike_theft_density_isoband <span class="ot">&lt;-</span> bike_thefts <span class="sc">|&gt;</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">hotspot_kde</span>(<span class="at">bandwidth_adjust =</span> <span class="fl">0.5</span>, <span class="at">quiet =</span> <span class="cn">TRUE</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">hotspot_isoband</span>(<span class="at">breaks =</span> <span class="dv">7</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="fu">hotspot_clip</span>(vancouver_nbhds)</span>
<span id="cb2-6"><a href="#cb2-6"></a></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="co"># Plot density map</span></span>
<span id="cb2-8"><a href="#cb2-8"></a><span class="fu">hotspot_map</span>(bike_theft_density_isoband)</span></code></pre></div>
<figcaption>Code 6.10</figcaption>
</figure>

<a id="map-vancouver-bicycle-theft-density-isobands"></a>

<figure>
<figure>
<p>Figure: Density map of recorded bicycle thefts in Vancouver in 2020, using seven shaded bands instead of individual grid cells. Darker bands represent higher estimated density, concentrated around Downtown and the neighbourhoods south of False Creek. Curved band boundaries join places with similar density and are clipped to Vancouver.</p>
</figure>
<figcaption>Map 6.8</figcaption>
</figure>

1.  It is important to add `hotspot_isoband()` to the pipeline *before* `hotspot_clip()`, since otherwise `hotspot_isoband()` is likely to produce an error.

One potential drawback of using isobands is that they create the risk of the environmental fallacy: all the locations on the map within a particular isoband look on the map like they have exactly the same density of crime, when fact there will be some variation within each band because each band represents a *range* of values. How big this problem is depends on how wide the range of values is in each isoband. We can control this by specifying how many different bands the range of KDE values should be split into. By default, `hotspot_isoband()` splits the range of values into 5 bands, but we can change this using the `breaks` argument. For example, if we wanted to split the range of values into 10 bands, we could use `hotspot_isoband(breaks = 10)`.

Whether to visualise KDE values or generalise them into isobands first is up to you. Both are valid ways to visualise the density of a particular type of crime. You might want to experiment with both approaches to see which one better communicates the information you want to show on your map. In this book, we will generally visualise KDE layers rather than isobands to keep the code examples short, but you should feel free to experiment with both approaches.

<a id="sec-other-layers"></a>
<a id="adding-more-layers"></a>

## 6.6 Adding more layers

One way make our density map more useful would be to add the boundaries of different neighbourhoods in Vancouver so that users could see where the different areas of high crime are located. This would also have the benefit of showing the outline of the city (the area for which we have data).

[](https://ggplot2.tidyverse.org/)

To add more layers to our map we need to learn about another R package: ggplot2. In the background, `hotspot_map()` uses functions from the ggplot2 package to put together the different parts of a map. That means we can use other functions from the ggplot2 package to build upon the map that `hotspot_map()` produces. Over the next few chapters we will learn about several families of functions that ggplot2 provides so that we can fine-tune the appearance of a map.

TipWhy do we combine `hotspot_map()` with functions from ggplot2?

<a id="callout-9"></a>

The ggplot2 package is the most popular package for making visualisations of all types in R. ggplot2 gives us lots of control over how visualisations appear, but that high level of control can sometimes mean the code needed to produce a visualisation is long and complicated.

Since there are elements that are common to almost all maps, behind the scenes the `hotspot_map()` function uses ggplot2 (and another package called ggspatial) to produce a map quickly and easily. This means that we can use `hotspot_map()` to make maps quickly and easily, and then use functions from ggplot2 to fine-tune the appearance of those maps.

In the background, `hotspot_map()` sets up the basic combination of ggplot2 functions that are needed to produce a particular type of map. The combination of functions that is required depends on the type of map that we are making. For example, a density map requires a different combination of functions than a dot map. The `hotspot_map()` function takes care of this for us, so that we can focus on the parts of the map that we want to change. For example, when we run the code:

<a id="lst-mapping-crime-patterns-show-hotspot-map-stack"></a>

<figure>
<div class="sourceCode" id="cb1"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb1-1"><a href="#cb1-1"></a><span class="fu">hotspot_map</span>(bike_theft_density)</span></code></pre></div>
<figcaption>Code 6.11</figcaption>
</figure>

in the background `hotspot_map()` combines these functions from ggplot2:

<a id="lst-mapping-crime-patterns-show-equivalent-ggplot-stack"></a>

<figure>
<div class="sourceCode" id="cb1"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb1-1"><a href="#cb1-1"></a><span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb1-2"><a href="#cb1-2"></a>  ggspatial<span class="sc">::</span><span class="fu">annotation_map_tile</span>(<span class="at">zoomin =</span> <span class="dv">0</span>, <span class="at">progress =</span> <span class="st">&quot;none&quot;</span>) <span class="sc">+</span></span>
<span id="cb1-3"><a href="#cb1-3"></a>  <span class="fu">geom_sf</span>(<span class="fu">aes</span>(<span class="at">fill =</span> kde), <span class="at">data =</span> bike_theft_density, <span class="at">colour =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb1-4"><a href="#cb1-4"></a>  <span class="fu">scale_fill_distiller</span>(</span>
<span id="cb1-5"><a href="#cb1-5"></a>    <span class="at">type =</span> <span class="st">&quot;seq&quot;</span>,</span>
<span id="cb1-6"><a href="#cb1-6"></a>    <span class="at">palette =</span> <span class="st">&quot;Blues&quot;</span>,</span>
<span id="cb1-7"><a href="#cb1-7"></a>    <span class="at">direction =</span> <span class="dv">1</span>,</span>
<span id="cb1-8"><a href="#cb1-8"></a>    <span class="at">breaks =</span> <span class="fu">range</span>(<span class="fu">pull</span>(bike_theft_density, kde)),</span>
<span id="cb1-9"><a href="#cb1-9"></a>    <span class="at">labels =</span> <span class="fu">c</span>(<span class="st">&quot;low&quot;</span>, <span class="st">&quot;high&quot;</span>),</span>
<span id="cb1-10"><a href="#cb1-10"></a>    <span class="at">na.value =</span> <span class="st">&quot;transparent&quot;</span></span>
<span id="cb1-11"><a href="#cb1-11"></a>  ) <span class="sc">+</span></span>
<span id="cb1-12"><a href="#cb1-12"></a>  <span class="fu">labs</span>(</span>
<span id="cb1-13"><a href="#cb1-13"></a>    <span class="at">caption =</span> <span class="st">&quot;© OpenStreetMap contributors&quot;</span>,</span>
<span id="cb1-14"><a href="#cb1-14"></a>    <span class="at">fill =</span> <span class="st">&quot;density&quot;</span></span>
<span id="cb1-15"><a href="#cb1-15"></a>  ) <span class="sc">+</span></span>
<span id="cb1-16"><a href="#cb1-16"></a>  <span class="fu">theme_void</span>()</span></code></pre></div>
<figcaption>Code 6.12</figcaption>
</figure>

As you can see, the code `hotspot_map(bike_theft_density)` conceals quite a lot of complexity, so we can focus on other jobs. We will learn more about how ggplot2 works in [Chapter 14](../14_no_maps/index.llms.md), but for now we will just learn enough to be able to add more layers to our maps.

We can add functions from the ggplot2 package to `hotspot_map()` by using the `+` operator. This works in a very similar way to the pipe operator (`|>`) that we've already learned about -- it's just a quirk of ggplot2 that it uses `+` instead of `|>`. By convention, each function that we add to `hotspot_map()` to change the appearance of our map goes on a new line (this makes the code easier to read) and all but the first line is indented by two spaces. Positron does this indenting automatically if the previous line ends with a `+` symbol, since Positron then understands that there is more code to come on the next line.

The first family of functions we will learn about is the `geom_*()` family. The `geom_` functions are used to add *data* -- such as points, lines or polygons -- to a map. Since map data is usually stored in an SF object, we use the `geom_sf()` function to add a spatial dataset to a map.

Add this map-plotting code to the end of `chapter_06.R`:

<a id="lst-mapping-crime-patterns-script-06-boundary-map"></a>

<figure>
<pre><code>chapter_06.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Plot density map</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="fu">hotspot_map</span>(bike_theft_density_clip, <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="co"># Add neighbourhood boundaries</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> vancouver_nbhds, <span class="at">colour =</span> <span class="st">&quot;seagreen3&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>)</span></code></pre></div>
<figcaption>Code 6.13</figcaption>
</figure>

<a id="map-vancouver-bicycle-theft-density-boundaries"></a>

<figure>
<figure>
<p>Figure: Density map of recorded bicycle thefts in Vancouver in 2020 clipped to the city boundary. Darker blue indicates higher density around Downtown and south of False Creek; southern areas are paler. Green neighbourhood outlines have been added over the pale street map, but neighbourhood names are not yet labelled.</p>
</figure>
<figcaption>Map 6.9</figcaption>
</figure>

It would also be useful to add labels showing the names of the different neighbourhoods. The challenge with adding labels to maps is to make sure those labels are legible while not obscuring the data layer, so we'll have to do this carefully.

We can add labels to a map using the `geom_sf_label()` function from ggplot2. But to do that, we need to learn about another aspect of the ggplot2 ecosystem: specifying aspects of the appearance of a map based on columns in a dataset. You might remember that the `vancouver_nbhds` dataset contains a column called `name` that contains the names of the different neighbourhoods:

<a id="lst-mapping-crime-patterns-head-vancouver-nbhds"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">head</span>(vancouver_nbhds)</span></code></pre></div>
<figcaption>Code 6.14</figcaption>
</figure>

    Simple feature collection with 6 features and 3 fields
    Geometry type: POLYGON
    Dimension:     XY
    Bounding box:  xmin: 483843.3 ymin: 5449706 xmax: 498305.7 ymax: 5458628
    Projected CRS: WGS 84 / UTM zone 10N
    # A tibble: 6 × 4
      name                mapid geo_point_2d                                geometry
      <chr>               <chr> <list>                                 <POLYGON [m]>
    1 Dunbar-Southlands   DS    <dbl [2]>    ((487615.5 5455027, 487606.1 5453561, …
    2 Kerrisdale          KERR  <dbl [2]>    ((486957.9 5451434, 487209 5451413, 48…
    3 Killarney           KIL   <dbl [2]>    ((498283.7 5449706, 497087.9 5450130, …
    4 Kitsilano           KITS  <dbl [2]>    ((489985.4 5458071, 489543.7 5457840, …
    5 South Cambie        SC    <dbl [2]>    ((491556.7 5453913, 491543.2 5453419, …
    6 Victoria-Fraserview VF    <dbl [2]>    ((495860.2 5450158, 495741.3 5450160, …

We can use the values in the `name` column to specify the text of the labels we want to add to the map. To do this, we need to use the `aes()` function from ggplot2, which is used to specify *aesthetics*. We mentioned aesthetics briefly in [Section 5.6.1](../05_your_second_crime_map/index.llms.md#sec-aesthetics), but in that section we only covered specifying static aesthetics that applied equally to all the elements in a layer. For example, we used `colour = "red"` to set the colour of all the points in a layer. In this case, we need to control the appearance of the labels based on the values in a column in the dataset, so we need to use *dynamic* aesthetics. We can do that by using the `aes()` function to specify which column in the dataset we want to use for each aesthetic.

The `aes()` function takes as its arguments pairs of values (combined with an `=` symbol) where the first value is an aesthetic and the second value is the name of a column in the data. For example, to use the colour of points on a map to represent different types of crime that were stored in a column in the data called `type`, we could use `aes(colour = type)`. This is called *mapping* a column to an aesthetic.

ImportantWhen to specify values inside or outside `aes()`

When should you specify the values of aesthetics inside `aes()` and when should you do it outside `aes()`?

- If you want an aesthetic to have a constant value for all the points, lines or other shapes in a layer, control the aesthetic *outside* `aes()`. For example, you could use `hotspot_map(bike_thefts, colour = "mediumblue")` to make all the shapes in that layer blue.
- If you want to vary the appearance of shapes according to values in the data, you should control the aesthetic *inside* `aes()`. For example, you could use `geom_sf(aes(colour = month), data = bike_thefts)` to vary the colour of shapes in a layer according to values of the `month` column in a dataset.

If you specify a constant value for an aesthetic (e.g. `colour = "mediumblue"`) this will override any mapping for that aesthetic provided by the `aes()` function (e.g. `aes(colour = month)`). If you have used `aes()` to specify that an aesthetic should be controlled based on a column in the data but find that the aesthetic is not changing based on the data, check you have not also specified a constant value for that aesthetic.

`aes()` should normally be the first argument in a `geom_*()` function. If you want to specify the arguments in a different order then you must give the name of each argument, which means that for the `aes()` function you must specify `mapping = aes(...)` when `aes()` is not the first argument to whatever `geom_*()` function you are using.

[](https://stringr.tidyverse.org/)

Since we want the text of the labels to be the names of the neighbourhoods, we can use `aes(label = name)` to map the `name` column in the `vancouver_nbhds` dataset to the label aesthetic. This will make the text of each label equal to the value in the `name` column for that neighbourhood. However, some of the neighbourhood names are quite long, and so we will need to wrap the text of those labels onto multiple lines so that they do not overlap adjacent neighbourhoods. We can do this using the `str_wrap()` function from the [stringr package](https://stringr.tidyverse.org), which is part of the tidyverse. `str_wrap()` takes a string and wraps it onto multiple lines if it is longer than a specified width. We can use `str_wrap()` inside the `aes()` function to wrap the text of the labels based on the values in the `name` column. For example, we could use `aes(label = str_wrap(name, width = 10))` to wrap any neighbourhood names that are longer than 10 characters onto multiple lines.

Replace the existing `hotspot_map()` stack in the `chapter_06.R` file with this stack and then run that code. You will see that as well as specifying the label aesthetic using `aes()`, we have also specified several other aesthetics outside of `aes()` to make sure the labels are less visually prominent than the density layer (because the most-important element on a map is always the data layer).

<a id="lst-mapping-crime-patterns-script-06-final-map"></a>

<figure>
<pre><code>chapter_06.R</code></pre>
<a id="annotated-cell-30"></a>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r code-annotation-code number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Plot density map</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="fu">hotspot_map</span>(bike_theft_density_clip, <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="co"># Add neighbourhood boundaries</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> vancouver_nbhds, <span class="at">colour =</span> <span class="st">&quot;seagreen3&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="co"># Add neighbourhood names</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="fu">geom_sf_label</span>(</span>
<span id="cb2-7"><a href="#cb2-7"></a>    <span class="fu">aes</span>(<span class="at">label =</span> <span class="fu">str_wrap</span>(name, <span class="dv">10</span>)),</span>
<span id="cb2-8"><a href="#cb2-8"></a>    <span class="at">data =</span> vancouver_nbhds,</span>
<span id="cb2-9"><a href="#cb2-9"></a>    <span class="at">alpha =</span> <span class="fl">0.5</span>,</span>
<span id="cb2-10"><a href="#cb2-10"></a>    <span class="at">colour =</span> <span class="st">&quot;seagreen&quot;</span>,</span>
<span id="cb2-11"><a href="#cb2-11"></a>    <span class="at">fill =</span> <span class="st">&quot;white&quot;</span>,</span>
<span id="cb2-12"><a href="#cb2-12"></a>    <span class="at">lineheight =</span> <span class="dv">1</span>,</span>
<span id="cb2-13"><a href="#cb2-13"></a>    <span class="at">size =</span> <span class="fl">2.5</span>,</span>
<span id="cb2-14"><a href="#cb2-14"></a>    <span class="at">linewidth =</span> <span class="cn">NA</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  )</span></code></pre></div>
<figcaption>Code 6.15</figcaption>
</figure>

<a id="map-vancouver-bicycle-theft-density-labelled"></a>

<figure>
<figure>
<p>Figure: Density map of recorded bicycle thefts in Vancouver in 2020. Darker blue indicates higher estimated density, strongest on the Downtown peninsula and around the north-central neighbourhoods south of False Creek. Density is lower towards the southern edge. Green neighbourhood boundaries and labels provide location context on a pale street map.</p>
</figure>
<figcaption>Map 6.10</figcaption>
</figure>

1.  `alpha = 0.5` makes the label background semi-transparent so that we can see the density layer underneath it,
2.  `colour = "seagreen"` slightly reduces the prominence of the label text to avoid distracting attention from the density layer,
3.  `fill = "white"` makes the label background white so that it is legible against the base map and density layer, remembering that since we have set `alpha = 0.5` the background will be semi-transparent,
4.  `lineheight = 1` reduces the gap between lines in each label,
5.  `size = 2.5` slightly reduces the size of the label text,
6.  `linewidth = NA` removes the default border around the label background.

From this map, we can see that recorded bike theft in Vancouver is heavily concentrated in a handful of neighbourhoods, particularly Downtown and the West End. This map makes the broad pattern easier to see than the point map in [Chapter 5](../05_your_second_crime_map/index.llms.md), and shows how the concentrations relate to different areas of the city.

QuizAdding map layers

**Which function adds labels at the locations of spatial features?**

- geom_sf()
- geom_sf_label() (Correct answer)
- annotation_map_tile()
- hotspot_clip()

**What does `str_wrap(name, width = 10)` do to the neighbourhood labels?**

- It changes the neighbourhood names to lower case.
- It removes neighbourhood names longer than ten characters.
- It wraps longer neighbourhood names onto multiple lines. (Correct answer)
- It changes the order of the neighbourhoods.

TipTips for producing effective density maps

- Produce separate density layers for different types of crime. Combining offences can hide distinct spatial patterns and will make the result more strongly influenced by whichever offence is most numerous.
- Be cautious about mapping offences that are mainly found through police activity, such as drug or weapon possession. Their recorded locations can reflect where officers patrol as much as where offences occur.
- Remember that a KDE map shows concentrations of recorded events, not the risk that an event will happen to a person or place. Interpreting risk also requires information about the relevant population or opportunities and will be covered in [Chapter 13](../13_mapping_hotspots/index.llms.md).

<a id="in-summary"></a>

## 6.7 In summary

In this chapter we explored how KDE can make broad patterns in a large point dataset easier to see. A density map can help practitioners explore where recorded events are concentrated, but it should not determine decisions by itself: the result can also reflect reporting, opportunities, population and police activity.

We have practised how to:

- estimate density with `hotspot_kde()`;
- choose an appropriate projected coordinate reference system;
- adjust grid-cell size and bandwidth;
- map density using an appropriate sequential colour scale;
- clip a density layer with `hotspot_clip()`; and
- add boundaries and labels in the correct layer order.

Your complete script should now look like this:

<a id="lst-mapping-crime-patterns-show-chapter-06-script"></a>

<figure>
<pre><code>chapter_06.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This script produces a density map of bicycle thefts in Vancouver in 2020.</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="co"># Load packages</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, httr2, sf, sfhotspot, tidyverse)</span>
<span id="cb2-5"><a href="#cb2-5"></a></span>
<span id="cb2-6"><a href="#cb2-6"></a><span class="co"># Download the raw data to a local file</span></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="fu">request</span>(</span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/vancouver_thefts.csv.gz&quot;</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;vancouver_thefts.csv.gz&quot;</span>))</span>
<span id="cb2-11"><a href="#cb2-11"></a></span>
<span id="cb2-12"><a href="#cb2-12"></a><span class="co"># Download Vancouver neighbourhood boundaries</span></span>
<span id="cb2-13"><a href="#cb2-13"></a><span class="fu">request</span>(</span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/vancouver_neighbourhoods.geojson&quot;</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="fu">req_perform</span>(</span>
<span id="cb2-17"><a href="#cb2-17"></a>    <span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;vancouver_neighbourhoods.geojson&quot;</span>)</span>
<span id="cb2-18"><a href="#cb2-18"></a>  )</span>
<span id="cb2-19"><a href="#cb2-19"></a></span>
<span id="cb2-20"><a href="#cb2-20"></a><span class="co"># Load and wrangle bike theft data</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>thefts <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;vancouver_thefts.csv.gz&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  <span class="fu">read_csv</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>  janitor<span class="sc">::</span><span class="fu">clean_names</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;x&quot;</span>, <span class="st">&quot;y&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:32610&quot;</span>)</span>
<span id="cb2-25"><a href="#cb2-25"></a></span>
<span id="cb2-26"><a href="#cb2-26"></a>bike_thefts <span class="ot">&lt;-</span> <span class="fu">filter</span>(thefts, type <span class="sc">==</span> <span class="st">&quot;Theft of Bicycle&quot;</span>)</span>
<span id="cb2-27"><a href="#cb2-27"></a></span>
<span id="cb2-28"><a href="#cb2-28"></a><span class="co"># Load Vancouver neighbourhood boundaries</span></span>
<span id="cb2-29"><a href="#cb2-29"></a>vancouver_nbhds <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;vancouver_neighbourhoods.geojson&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-30"><a href="#cb2-30"></a>  <span class="fu">read_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-31"><a href="#cb2-31"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:32610&quot;</span>)</span>
<span id="cb2-32"><a href="#cb2-32"></a></span>
<span id="cb2-33"><a href="#cb2-33"></a><span class="co"># Estimate density of bike thefts and clip the result</span></span>
<span id="cb2-34"><a href="#cb2-34"></a>bike_theft_density_clip <span class="ot">&lt;-</span> bike_thefts <span class="sc">|&gt;</span></span>
<span id="cb2-35"><a href="#cb2-35"></a>  <span class="fu">hotspot_kde</span>(</span>
<span id="cb2-36"><a href="#cb2-36"></a>    <span class="at">grid =</span> <span class="fu">hotspot_grid</span>(vancouver_nbhds, <span class="at">quiet =</span> <span class="cn">TRUE</span>),</span>
<span id="cb2-37"><a href="#cb2-37"></a>    <span class="at">bandwidth_adjust =</span> <span class="fl">0.5</span>,</span>
<span id="cb2-38"><a href="#cb2-38"></a>    <span class="at">quiet =</span> <span class="cn">TRUE</span></span>
<span id="cb2-39"><a href="#cb2-39"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-40"><a href="#cb2-40"></a>  <span class="fu">hotspot_clip</span>(vancouver_nbhds)</span>
<span id="cb2-41"><a href="#cb2-41"></a></span>
<span id="cb2-42"><a href="#cb2-42"></a><span class="co"># Plot density map</span></span>
<span id="cb2-43"><a href="#cb2-43"></a><span class="fu">hotspot_map</span>(bike_theft_density_clip, <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-44"><a href="#cb2-44"></a>  <span class="co"># Add neighbourhood boundaries</span></span>
<span id="cb2-45"><a href="#cb2-45"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> vancouver_nbhds, <span class="at">colour =</span> <span class="st">&quot;seagreen3&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-46"><a href="#cb2-46"></a>  <span class="co"># Add neighbourhood names</span></span>
<span id="cb2-47"><a href="#cb2-47"></a>  <span class="fu">geom_sf_label</span>(</span>
<span id="cb2-48"><a href="#cb2-48"></a>    <span class="fu">aes</span>(<span class="at">label =</span> <span class="fu">str_wrap</span>(name, <span class="dv">10</span>)),</span>
<span id="cb2-49"><a href="#cb2-49"></a>    <span class="at">data =</span> vancouver_nbhds,</span>
<span id="cb2-50"><a href="#cb2-50"></a>    <span class="at">alpha =</span> <span class="fl">0.5</span>,</span>
<span id="cb2-51"><a href="#cb2-51"></a>    <span class="at">colour =</span> <span class="st">&quot;seagreen&quot;</span>,</span>
<span id="cb2-52"><a href="#cb2-52"></a>    <span class="at">fill =</span> <span class="st">&quot;white&quot;</span>,</span>
<span id="cb2-53"><a href="#cb2-53"></a>    <span class="at">lineheight =</span> <span class="dv">1</span>,</span>
<span id="cb2-54"><a href="#cb2-54"></a>    <span class="at">size =</span> <span class="fl">2.5</span>,</span>
<span id="cb2-55"><a href="#cb2-55"></a>    <span class="at">linewidth =</span> <span class="cn">NA</span></span>
<span id="cb2-56"><a href="#cb2-56"></a>  )</span></code></pre></div>
<figcaption>Code 6.16</figcaption>
</figure>

The script is in a logical order: it loads packages, downloads and prepares data, estimates and clips density, then produces the map. It includes only the permanent code needed to repeat the analysis, and comments identify each task.

Save `chapter_06.R` by pressing .

To check that the analysis is reproducible, restart R using the **Restart R** (**⟳**) button in Positron's **Console** panel, then run the script from beginning to end.

Keep the script in the `R` folder and the downloaded source files in `data/raw`.

You can learn more about:

- the arguments and output of [`hotspot_kde()`](https://pkgs.lesscrime.info/sfhotspot/reference/hotspot_kde.html) in the sfhotspot documentation;
- choosing and using colour schemes in [*Working with colours in R*](https://nrennie.rbind.io/blog/colours-in-r/); and
- exploring palettes using the [Color Palette Finder](https://r-graph-gallery.com/color-palette-finder).

QuizRevision questions

Answer these questions to check you have understood the main points covered in this chapter. Write between 50 and 100 words to answer each question.

1.  What is kernel density estimation (KDE), and why is it useful for mapping crime patterns? Explain the process briefly.
2.  Why can density maps be more effective than point maps for visualising patterns in large crime datasets?
3.  What are the main factors to consider when adjusting grid-cell size and bandwidth? How can these adjustments affect a KDE map?
4.  Why is it important to clip a density layer to the boundary of the area covered by the data, and which function should you use?
5.  How does the choice of colour scale affect the interpretation of a density map? When should you use sequential, diverging and qualitative colour schemes?

Isotherm map courtesy of the [University of Illinois WW2010 Project](http://ww2010.atmos.uiuc.edu/%28Gh%29/abt/usrgd/cntnt/prdct.rxml).
