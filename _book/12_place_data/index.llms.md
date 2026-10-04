Source: https://books.lesscrime.info/learncrimemapping/2026/12_place_data/index.html

<a id="quarto-document-content"></a>
<a id="title-block-header"></a>
<a id="using-data-about-places"></a>

# `<a id="sec-place-data"></a>`{=html}12  Using data about places

Figure: Students add transit routes, houses and a purple park to a neighbourhood map.

Understanding the spatial context of crime is essential for effective crime mapping and analysis. This chapter explores how to make crime maps more informative by incorporating additional data about places. It covers sources of spatial data, including open data repositories and OpenStreetMap, and explains how to use shapefiles to add context to crime patterns.

TipBefore you start

1.  Open Positron or -- if you already have Positron open -- start a new R session by clicking the **Restart R** (**⟳**) button in the **Console** panel. This makes sure no code you ran previously will interfere with the work you do in this chapter.
2.  Make sure you are working in the crime mapping project workspace you created in [Section 1.5](../01_getting_started/index.llms.md#sec-create-project). In the top-right corner of the Positron window, you should see a folder icon and the words `crime_mapping`. If not, click the **File** menu, then **Open Folder ...** and choose the `crime_mapping` folder.

<a id="introduction"></a>

## 12.1 Introduction

The purpose of most crime maps is to help people make decisions, be they professionals working out how best to respond to crime problems or citizens holding local leaders to account. We can make it easier for people to make decisions by putting crime data into a relevant context. We have already started to do this by adding base maps, titles, legends and so on to our maps.

Since crime is concentrated in a few places, readers of our crime maps will often be interested in understanding what features of the environment are related to specific concentrations of crime in particular places. Where patterns of crime are related to particular facilities -- such as late-night violence being driven by the presence of bars selling alcohol -- it can be useful to highlight specific features on our maps.

As an example, imagine you are the manager responsible for security on the metro network in Medellin, Colombia. There are several mountains within Medellin, so the city metro network consists of both railway lines in the valley and cable cars up the mountains. The security manager for the metro company will certainly analyse violence on the company's stations and vehicles, but may also be interested in which stations are in neighbourhoods that themselves have high levels of violence.

To help with this, you might produce a map showing the density of homicides recorded by local police.

<a id="map-medellin-homicide-density"></a>

<figure>
<p>Figure: Density map of recorded homicides in Medellín from 2010 to 2019. Darker red indicates higher density, strongest in the city centre, with comuna boundaries outlined. The title names Parque Berrío and Prado stations, but neither stations nor metro lines are drawn, so their relationship to the hotspot cannot yet be seen.</p>
<figcaption>Map 12.1</figcaption>
</figure>

This is an acceptable crime map: it shows the data in a reasonable way, places the data layer at the top of the visual hierarchy and provides suitable context in the title, legend etc. But it is a much less useful map than it could be because it doesn't show where the metro stations are and this information is not included in the base map at this scale. A much better map would add extra layers of data showing the metro stations and the lines connecting them.

<a id="map-medellin-homicides-and-metro"></a>

<figure>
<p>Figure: Medellín homicide-density map for 2010 to 2019 with metro lines, cable lines and labelled stations added. Parque Berrío and Prado stations lie close to the darkest red central concentration. Other stations extend north and south beyond it, allowing the claim in the title to be checked visually.</p>
<figcaption>Map 12.2</figcaption>
</figure>

From this second map, it is much easier to see that Parque Berrío and Prado stations are closest to an area with relatively high numbers of homicides.

In this chapter, you will produce a more-detailed map of the La Candelaria neighbourhood that compares homicide density with bus-stop locations and metro lines:

<a id="map-la-candelaria-homicides-and-transport"></a>

<figure>
<p>Figure: Map of La Candelaria, Medellín, showing recorded homicide density from 2010 to 2019. Darker blue cells mark higher density inside a thick grey boundary. Hollow circles mark bus stops and a blue line marks the metro. The strongest density is in the northern part, while bus stops are spread more widely, including the south.</p>
<figcaption>Map 12.3</figcaption>
</figure>

In this chapter, we will learn how to:

- find and correctly cite open spatial data;
- download, extract and load data supplied as a shapefile;
- identify OpenStreetMap tags for features of interest;
- download OpenStreetMap data using `osmdata`;
- choose a suitable projected coordinate reference system; and
- add contextual place data to a crime map.

To get started, open a new R script file in Positron and save it as `chapter_12.R` in the `R` folder of the workspace you created in [Section 1.5](../01_getting_started/index.llms.md#sec-create-project). Add a note to the top of this file explaining that the code will create a map of homicides in Medellin, Colombia, then add the code needed to load the packages we will use in this chapter:

<a id="lst-place-data-script-12-packages"></a>

<figure>
<pre><code>chapter_12.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This script produces a map of the density of homicides in the La Candelaria</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="co"># area of Medellin, Colombia, together with bus stops in or near the area</span></span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Load packages</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, httr2, osmdata, sf, sfhotspot, tidyverse)</span></code></pre></div>
<figcaption>Code 12.1</figcaption>
</figure>

Run this line of code to load the packages. You will note that as well as the packages we have used in previous chapters, this code loads a new package -- osmdata -- that we will learn about in this chapter. If you want to remind yourself about the packages we have already used, see [Chapter 3](../03_data_wrangling/index.llms.md) for here, httr2 and tidyverse, [Chapter 5](../05_your_second_crime_map/index.llms.md) for sf, and [Chapter 6](../06_mapping_crime_patterns/index.llms.md) for sfhotspot.

Remember to run each block of code that you add to the script by pressing .

As we learned in [Chapter 11](../11_writing_reports/index.llms.md), the Medellin homicide CSV file uses semicolons to separate columns, so we must load it with `read_csv2()` rather than `read_csv()`. We will first download the original file into `data/raw`, then load that local copy.

<a id="lst-place-data-script-12-homicides"></a>

<figure>
<pre><code>chapter_12.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># LOAD DATA --------------------------------------------------------------------</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="do">## Load Medellin homicide data ----</span></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Download the original data</span></span>
<span id="cb2-5"><a href="#cb2-5"></a><span class="fu">request</span>(</span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/medellin_homicides.csv&quot;</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;medellin_homicides.csv&quot;</span>))</span>
<span id="cb2-9"><a href="#cb2-9"></a><span class="co"># Note: this dataset uses &#39;;&#39; as the column separator</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>medellin_homicides <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;medellin_homicides.csv&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="fu">read_csv2</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="co"># Remove rows with missing coordinates</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">drop_na</span>(longitud, latitud) <span class="sc">|&gt;</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="co"># Convert the data to an SF object</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;longitud&quot;</span>, <span class="st">&quot;latitud&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:4326&quot;</span>)</span></code></pre></div>
<figcaption>Code 12.2</figcaption>
</figure>

    <httr2_response>
    GET https://mpjashby.github.io/crimemappingdata/medellin_homicides.csv
    Status: 200 OK
    Content-Type: text/csv
    Body: On disk '/Users/mattashby/Documents/Crime Mapping Book/data/raw/medellin_homicides.csv' (702486 bytes)

    ℹ Using "','" as decimal and "'.'" as grouping mark. Use `read_delim()` for more control.

    Rows: 9360 Columns: 6
    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: ";"
    chr  (2): sexo, modalidad
    dbl  (3): longitud, latitud, edad
    dttm (1): fecha_hecho

    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

In the rest of this chapter we will use data from different sources to better understand clusters of homicides in the La Candelaria neighbourhood of downtown Medellin.

<a id="finding-data"></a>

## 12.2 Finding data

If you are producing crime maps on behalf of a particular organisation such as a police agency or a body responsible for managing a place, it is likely that they will hold spatial data that is relevant to the local area. For example, many city governments will hold records of local businesses. It will sometimes be necessary to track down which department or individual holds this data, and it may also be necessary to convert data into formats that are useful for spatial analysis or to tidy the data as we did in [Chapter 10](../10_messy_data/index.llms.md).

Some organisations may also have agreements to share data with others. For example, both universities and public agencies such as police forces in the United Kingdom have agreements with the national mapping agency [Ordnance Survey](https://www.ordnancesurvey.co.uk/) to share a wide variety of spatial data. If you are producing maps on behalf of an organisation, it will often be useful to ask what data they hold that might be relevant, or ask for a specific dataset you think would help improve a map.

<a id="sec-place-data-open-data"></a>
<a id="open-data"></a>

### 12.2.1 Open data

*Open data* is data that is released by organisations or individuals that can be freely used by others. Organisations such as local governments increasingly release data about their areas as open data -- almost all of the crime and other data we have seen so far in this book is open data released by different local and national governments.

Open data is extremely useful because you can skip the often lengthy and painful process of getting access to data and wrangling it into a format you can use. This means you can move on much more quickly to analysing data, reaching conclusions and making decisions. Watch this video to find out more about the value of open data.

Media: Video explaining the value of open data [(open media)](https://www.youtube.com/embed/bwX5MAZ6zKI)

TranscriptVideo transcript: The Potential of Open Data

<a id="callout-2"></a>

Video by Open Data NZ, licensed under [Creative Commons Attribution-ShareAlike 4.0](https://creativecommons.org/licenses/by-sa/4.0/). This transcript is provided under the same licence.

Data, a collection of information in its most basic form. Its potential to change the way we see ourselves, our world, and our future. But only if it's open. Made available to access, analyze, and inform action. Open data is information collected by government, business, and organizations. Added together and made anonymous, it's safe to be released. To use, reuse, and distribute. You already know it as things like geospatial data, weather data, and government census data.

You can use open data to simply get from A to B. Or you can use open data for more far reaching reasons, like making government more transparent, helping voters, journalists, and politicians to better understand. And improve our society. Open data crowdsources expertise, pulling information from all around the world, to help researchers fight disease, and relief workers coordinate disaster response. Open data drives innovation helping build new business and more strategic investment. Creating new jobs, even new industries, and stronger economies.

We live in an increasingly connected world. Right now we've opened only a fraction of the data that could benefit us. Just as the world transformed with the birth of the internet, imagine the potential of opening up more data. Allowing us to see our world from new perspectives. Driving innovation education and discovery. Open data. Open potential.

Open data is published in a wide variety of formats and distributed in different ways. Some data might only be distributed by an organisation sending you a DVD or memory stick (yes, even in 2026). Most of the time, however, data will be released online.

Many cities now maintain open-data websites that act as a repository for all their open data. For example, the City of Bristol in England publishes the [Open Data Bristol website](https://opendata.bristol.gov.uk/). Anyone can use this website to download data on everything from population estimates to politicians' expenses. Many of these datasets can be useful for crime mapping. For example, you can download the locations of [CCTV cameras](https://opendata.bristol.gov.uk/datasets/bcc::council-cctv-cameras/about) (useful in criminal investigations), or the [locations of children's centres](https://opendata.bristol.gov.uk/datasets/bcc::childrens-centres/about) (helpful if a crime-prevention strategy includes visits to such facilities).

Different local governments may use different terms for the same types of information, so it sometimes takes some trial and error to find if a particular dataset is available. Some data might also be held by organisations other than the main local government agency for a particular place. For example, data on the locations of electricity substations (useful if you are trying to prevent metal thefts from infrastructure networks) might be held by a power company. All this means that tracking down a particular dataset might require some detective work.

To try to make this process easier, some countries have established national open-data portals such as [Open Data in Canada](https://open.canada.ca/), [Open Government Data Platform India](https://data.gov.in/), [data.gov.uk in the United Kingdom](https://data.gov.uk/) and [data.gov in the United States](https://www.data.gov/). There are also international repositories such as the [African Development Bank Data Portal](https://dataportal.opendataforafrica.org/), [openAfrica](https://open.africa/) and [Data Portals](https://dataportals.org/), which seeks to list all the open data portals run by different governments and other organisations.

<a id="sec-place-data-citing-data"></a>
<a id="citing-data"></a>

### 12.2.2 Citing data

Organisations that provide data often do so on condition that users of the data follow certain rules. For example, you can use data on the Open Data Bristol website as long as you follow the conditions of the [Open Government Licence](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/). The most-common requirement of an open-data licence is that anyone using the data acknowledges the data source in any maps, reports or other outputs they produce. In the case of the Open Government Licence, users of the data are required to add a declaration to any outputs declaring:

> Contains public sector information licensed under the Open Government Licence v3.0.

Complying with open-data licences is a legal requirement, so it is important to make sure you understand what obligations you are accepting when you use a particular dataset. You can typically find the conditions for using a dataset on the website that you download the data from. In [Section 7.8.2](../07_map_context/index.llms.md#sec-captions) we learned that we can add data attribution statements like this to maps with the `caption` argument to the `hotspot_map()` function.

QuizOpen data

**Which one of these statements about open data is true?**

- We can use open data for any purpose -- there is no need to acknowledge the source of the data
- We can use open data, but only for non-commercial purposes
- We can use open data for any purpose as long as we comply with the requirements of the licence the data is released under (Correct answer)
- We can download open data but we cannot use it for any project that will be published online

<a id="sec-place-shapefiles"></a>
<a id="shapefiles"></a>

## 12.3 Shapefiles

In this course we have used spatial data provided in different formats including geopackages (`.gpkg`) and geoJSON (`.geojson`) files, as well as creating spatial objects from tabular data in formats like CSV and Excel files (to read up on different functions for opening different types of data file, see [Appendix A](../appendices/read_functions.llms.md)). But there is one important spatial-data format that we haven't yet learned to use: the *shapefile*.

The shapefile format was created by Esri, the company that makes the ArcGIS suite of mapping software. It was perhaps the first spatial format that could be read by a wide variety of mapping software, which meant that lots of providers of spatial data began to provide data in shapefile format. Shapefiles are limited in various ways that mean they are unlikely to be a good choice for storing your own data, but it is important to know how to use them because many spatial datasets are still provided as shapefiles for historical reasons.

One of the complications of using shapefiles (and why they're not a good choice for storing your own data) is that different parts of the data are stored in separate files. So while the coordinates of the points, lines or polygons are stored in a file with a `.shp` extension, the non-spatial attributes of each spatial feature (such as the date on which a crime occurred or the name of a neighbourhood) are stored in a separate file with a `.dbf` extension and details of the coordinate reference system are stored in a `.prj` file -- a single dataset might be held in up to 16 separate files on a computer. All the files that make up a shapefile have the same file name, differing only in the file extension (e.g. `.shp`, `.dbf`, etc.). For example, if a `.shp` file is called `robberies.shp` then it will be accompanied by a file called `robberies.dbf` and one called `robberies.prj`, as well as a `robberies.shx` index file and possibly several others. All these separate files make it more-complicated to manage shapefiles than other spatial file formats such as the geopackage.

Because storing spatial data in a shapefile requires multiple different files, shapefile data is usually distributed in a `.zip` file that contains all the component files. This means that to access a shapefile we will have to add a step to our usual routine for downloading and opening a data file. To minimise the hassle associated with using shapefiles, in general we will:

1.  download the `.zip` file if we don't have a local copy already,
2.  create a named directory inside the `data/processed` directory (which we created in [Chapter 1](../01_getting_started/index.llms.md)) for the extracted files,
3.  unzip the `.zip` file into that directory, and
4.  load the shapefile data from the project directory.

For example, the routes of metro lines in Medellin are available in shapefile format at:

    https://mpjashby.github.io/crimemappingdata/medellin_metro_lines.zip

To load the data from this file, we can use the process outlined above. Add [Code 12.3](#lst-place-data-script-12-metro) to your `chapter_12.R` script file. Read through its accompanying notes to understand what each part of the code does.

<a id="lst-place-data-script-12-metro"></a>

<figure>
<pre><code>chapter_12.R</code></pre>
<a id="annotated-cell-4"></a>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r code-annotation-code number-lines code-with-copy code-annotated"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="do">## Load metro lines ----</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="co"># Download zip file</span></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="dv">1</span>metro_lines_file <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;medellin_metro_lines.zip&quot;</span>)</span>
<span id="cb2-5"><a href="#cb2-5"></a><span class="fu">request</span>(</span>
<span id="cb2-6"><a href="#cb2-6"></a><span class="dv">2</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/medellin_metro_lines.zip&quot;</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> metro_lines_file)</span>
<span id="cb2-10"><a href="#cb2-10"></a></span>
<span id="cb2-11"><a href="#cb2-11"></a><span class="co"># Unzip the files into a named directory</span></span>
<span id="cb2-12"><a href="#cb2-12"></a><span class="dv">3</span>metro_lines_dir <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;processed&quot;</span>, <span class="st">&quot;medellin_metro_lines&quot;</span>)</span>
<span id="cb2-13"><a href="#cb2-13"></a><span class="dv">4</span><span class="fu">unzip</span>(metro_lines_file, <span class="at">exdir =</span> metro_lines_dir)</span>
<span id="cb2-14"><a href="#cb2-14"></a></span>
<span id="cb2-15"><a href="#cb2-15"></a><span class="co"># Load the data</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>metro_lines <span class="ot">&lt;-</span> <span class="fu">here</span>(metro_lines_dir, <span class="st">&quot;medellin_metro_lines.shp&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-17"><a href="#cb2-17"></a><span class="dv">5</span>  <span class="fu">read_sf</span>()</span></code></pre></div>
<figcaption>Code 12.3</figcaption>
</figure>

1
: Use `here()` to create a path for the downloaded ZIP file inside `data/raw`. Keeping the original download means we can always return to it if necessary.

2
: Download the ZIP file using the same `httr2` workflow we have used for other datasets.

3
: Use `here()` to create a path for a named directory inside `data/processed`. The extracted files are processed copies of the original ZIP file, so they should not be stored in `data/raw`.

4
: Unzip the files into the processed-data directory. `unzip()` creates the directory if it does not already exist.

5
: Load the correct file (see below) from the processed-data directory into an R object.

<!-- -->

    <httr2_response>
    GET https://mpjashby.github.io/crimemappingdata/medellin_metro_lines.zip
    Status: 200 OK
    Content-Type: application/x-zip-compressed
    Body: On disk '/Users/mattashby/Documents/Crime Mapping Book/data/raw/medellin_metro_lines.zip' (13031 bytes)

Important

Note that although a shapefile consists of several different files, we only need to load the file with the extension `.shp` -- the `read_sf()` function will find all the data it needs from the other files.

Once we have loaded a shapefile into R using `read_sf()`, we can treat it in the same way as any other spatial dataset -- it is only loading shapefiles that is different from other spatial data formats.

One question you might have when reading [Code 12.3](#lst-place-data-script-12-metro) is how did we know that the shapefile we wanted to load was called `medellin_metro_lines.shp`? To find out the name of the file we want to load, we need a bit of temporary code (if you want to remind yourself about the difference between permanent and temporary code, look back at [Section 2.2](../02_your_first_crime_map/index.llms.md#sec-permanent-code)).

We can find out the name of files within a zip file using the `unzip()` function together with the argument `list = TRUE`. This produces a list of files that are inside the zip file, rather than actually unzipping any files. For example, run this code in the R Console to see a list of files in the zip file we downloaded.

<a id="lst-place-data-list-metro-archive-files"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">unzip</span>(metro_lines_file, <span class="at">list =</span> <span class="cn">TRUE</span>)</span></code></pre></div>
<figcaption>Code 12.4</figcaption>
</figure>

                          Name Length                Date
    1 medellin_metro_lines.dbf   2299 2023-02-06 22:46:00
    2 medellin_metro_lines.prj    145 2023-02-06 22:46:00
    3 medellin_metro_lines.shp  16076 2023-02-06 22:46:00
    4 medellin_metro_lines.shx    172 2023-02-06 22:46:00

From this, you can see that the file with the extension `.shp` (which is what we need to load) is called `medellin_metro_lines.shp`. We use `here()` to combine that file name with the `metro_lines_dir` path we created in [Code 12.3](#lst-place-data-script-12-metro).

QuizShapefiles

**What is a shapefile?**

- A single file that contains both spatial and non-spatial data
- A file format used exclusively by OpenStreetMap
- A collection of files that store spatial data (Correct answer)
- A data format that only supports point features

**Why do shapefiles often come in `.zip` format?**

- They contain multiple files that need to be kept together (Correct answer)
- They are too large to be stored as individual files
- They require a password for access
- They can only be read in GIS software

**Once a shapefile is downloaded and unzipped, which function is used to read it?**

- read.csv()
- read_sf() (Correct answer)
- load_shapefile()
- import_shp()

<a id="sec-place-openstreetmap"></a>
<a id="data-from-openstreetmap"></a>

## 12.4 Data from OpenStreetMap

[](https://www.openstreetmap.org/)

Often we can get map data from the organisation we are working for, or from open-data portals run by governments or international organisations. But sometimes they won't hold the information we need.

Fortunately, there is another source of data: OpenStreetMap (OSM). This is a global resource of map data created by volunteers (and started at UCL), using a mixture of open data from governments, data contributed by charities and data collected by the volunteers themselves. Watch this video to learn a bit more about OpenStreetMap.

Media: Video introducing OpenStreetMap and how its map data are created [(open media)](https://www.youtube.com/embed/d6n29CU2-Sg)

TranscriptVideo transcript: OpenStreetMap: The map that saves lives

<a id="callout-6"></a>

OpenStreetMap is the Wikipedia of maps and so it's a map that citizens contribute to. It's a map that appears on the website OpenStreetMap.org but then you can edit it. What OpenStreetMap really is, it's a citizen generated database of geographical information. This is very different to the way Google organizes itself, they have a set of map products. Google's business is more about places where there is commercially valuable information, where there is revenue to be had.

They never publish the raw data that makes up the map, the coordinates of the streets for example, all of that data is kept locked away in Google's case, because that's their commercial advantage. Organizations like the Ordnance Survey, here in the UK, they have always had raw map data which they will license to other organizations, at great cost. So OpenStreetMap was formed here in the UK actually out of frustration. It was a surprise to the people who started the project actually there are a lot of people out there that really wanted Open License map data so badly that they are willing to do this crazy thing of going out in the street with the GPS unit trying to build a map from scratch.

We are trying to empty our minds of other maps because you don't want to be accused of copying, we were trying to create a brand new map which was open licensed, but we're gonna fill in streets and gather the street names and all that very basic data, and then over time here in London we've seen all all the streets mapped out in a lot of detail, but that's just London of course and we've seen the coverage of the map spreading but you get these wonderful blossoms of detail appearing as just one person gets interested in it.

Unfortunately we do have an uneven level of coverage, this is one of the challenges of working with OpenStreetMap data, there's no guarantee that a particular level of detail has been reached everywhere. We are consumers of maps in order primarily to find out where patients are and where their greatest needs are, and if we find that an area of tremendous vulnerability and where there's a lot of humanitarian and medical need and interest, that there isn't sufficient base mapping well there's nothing stopping us from contributing it.

The canonical example of humanitarian OpenStreetMap work was in Haiti after the earthquake, when there was an incredible rash of volunteer mapping that happened, and it created an extraordinary detailed map of the Capital Area Port-au-Prince. Everyone was sitting at home watching the news, watching the disastrous earthquake in Haiti and I think a lot of the OSM community sort of naturally felt curious to see how much data we had, how is the map looking in Haiti? it was looking very bare, we had a few roads in place, and so we were thinking, well maybe we should try and boost the coverage of of the cities where this disaster has struck.

People just started contributing to the map in that area. This is a process of remote mapping so looking at the aerial imagery that we have available to us. When we had our patients coming to the cholera centers and they tell us where they're from because of the OpenStreetMap work that had been done, we were able actually correlate those neighborhoods that they gave us as their origins to actual places and figure out where more patients were coming from and where for example there were water outages, which we were then able to help correct.

So in that sense the map actually helped to save lives. Humanitarian OSM work has been done in the Haitian earthquake, the ebola disaster that just happened, the Nepal earthquake, the Philippines typhoon and all of these places increasingly as time goes on, it's the default map and it's happening with volunteers all over the world. But it's still very much also about on the ground surveys, so we are encouraging the community to go out and look at the real world with their own eyes and that's how you can really create a unique valuable data set that really has a sense of ownership with the community living in a local area.

So increasingly we're starting to encourage our field teams to collect that geographical data about their activities and put it on OpenStreetMap. We generally ask permission you know, do you mind if we put your village on the map? Invariably what people say 'yes we'd like to be on the map, we'd like for people to know that we exist.' Every month we have a mapathon in London which attracts 75 to 100 people and they sit down and they trace some area, last month we were doing Chad.

We bring 100 people and some pizzas, and maybe a few bottles of beer or wine and everyone sits down and looks at the satellite imagery and traces the things that are necessary. We need you to trace the houses here, we need the road network there, we need the water courses but it's actually contributing meaningfully in real time to actual humanitarian operations. In a way OpenStreetMap could be thought of delivering real power to developers and powering an ecosystem of different third parties doing really interesting stuff with OpenStreetMap data.

And there's still lots of niches for people to organise that data. There are several companies that actually make quite a good living organizing and presenting the OpenStreetMap data very usefully so I don't think having all this data out there in an open format is going to destroy business opportunities, quite the contrary I think it's going to create them.

We have already used OSM data in this course: all of the base maps we have used when we create maps with `hotspot_map()` are based on data from OpenStreetMap. But we have very little control over which information is and is not included in base maps. Sometimes we need more control over the data, and that means downloading data direct from OSM.

We can download OSM data into R using the `osmdata` package. This package allows us to choose particular features from the billions of features worldwide that are included in the OSM database. To choose features, we must:

1.  specify the area we want to download data for using the `opq()` function,
2.  specify what type of features we want to download using the `add_osm_feature()` function,
3.  download the data using the `osmdata_sf()` function, and
4.  extract the type of spatial object (points, lines or polygons) that we are interested in.

Imagine that in your analysis of homicides in Medellin, you have been asked to consider the question of whether homicides are clustered near to bus stops. To answer this question, we need to know the locations of bus stops in the area we are interested in. This information is not published as open data by the Medellin city authorities. Fortunately we can extract bus-stop locations from OpenStreetMap using the `osmdata` package.

To do this, we first need to calculate the *bounding box* of the La Candelaria neighbourhood that we are interested in. A bounding box is the smallest rectangle that a particular spatial shape will fit inside. For example, the red rectangle on this map shows the bounding box of the city of Medellin (shown in blue).

<a id="map-medellin-bounding-box"></a>

<figure>
<p>Figure: Street map with Medellín outlined in blue and its bounding box outlined in red. The rectangle touches the northern, southern, eastern and western extremes of the irregular city boundary but also includes land outside it, particularly near its corners.</p>
<figcaption>Map 12.4</figcaption>
</figure>

You can calculate the bounding box of an SF object using the `st_bbox()` function from the sf package. In this case we want the bounding box of the La Candelaria neighbourhood, so we will need to load a dataset that includes the boundary of that neighbourhood. Add this code to the `chapter_12.R` script file and run it.

<a id="lst-place-data-script-12-boundaries"></a>

<figure>
<pre><code>chapter_12.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="do">## Load neighbourhood boundary ----</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="fu">request</span>(</span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/medellin_comunas.gpkg&quot;</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;medellin_comunas.gpkg&quot;</span>))</span>
<span id="cb2-6"><a href="#cb2-6"></a>medellin_comunas <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;medellin_comunas.gpkg&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>  <span class="fu">read_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  janitor<span class="sc">::</span><span class="fu">clean_names</span>()</span></code></pre></div>
<figcaption>Code 12.5</figcaption>
</figure>

    <httr2_response>
    GET https://mpjashby.github.io/crimemappingdata/medellin_comunas.gpkg
    Status: 200 OK
    Content-Type: application/octet-stream
    Body: On disk '/Users/mattashby/Documents/Crime Mapping Book/data/raw/medellin_comunas.gpkg' (1613824 bytes)

We can now calculate the bounding box of the neighbourhood we are interested in. Add this code to the `chapter_12.R` script file and run it.

<a id="lst-place-data-script-12-bbox"></a>

<figure>
<pre><code>chapter_12.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># GET OSM DATA -----------------------------------------------------------------</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="co"># Calculate neighbourhood bounding box</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>la_candelaria_bbox <span class="ot">&lt;-</span> medellin_comunas <span class="sc">|&gt;</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="fu">filter</span>(nombre <span class="sc">==</span> <span class="st">&quot;LA CANDELARIA&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="fu">st_bbox</span>()</span></code></pre></div>
<figcaption>Code 12.6</figcaption>
</figure>

ImportantOpenStreetMap requires lon/lat data

All the functions in the osmdata package expect coordinates (such as the corners of a bounding box) to be provided as longitudes and latitudes. If you provide data using any other coordinate reference system you will see an error saying:

    Error in `httr2::req_perform()`:
    ! HTTP 400 Bad Request.

If your data is in a projected coordinate system, make sure you use `st_transform()` to transform the data to use the WGS84 system, EPSG:4326.

The bounding box is the first thing we need to know in order to get data from OpenStreetMap. The second thing we need to know is what search terms to use in the `add_osm_feature()` function to return the locations of bus stops. OpenStreetMap has hundreds of feature categories, all in the format `key=value`. Sometimes we will only need to search for a particular key (category of feature), such as the [`highway` key](https://wiki.openstreetmap.org/wiki/Key:highway) that contains all the features that show roads (from motorways to winding lanes leading to farms in the countryside), tracks and paths. In other cases, we will want to search for a particular value (a type of feature within a category), such as searching for the value [`natural=water`](https://wiki.openstreetmap.org/wiki/Tag:natural%3Dwater) to search for lakes, rivers, etc.

The best place to find out how a feature you are interested in is recorded in the OSM database is to look at the [OpenStreetMap Wiki](https://wiki.openstreetmap.org/wiki/Map_features). Bus stops are recorded in OSM using the tag `highway=bus_stop`.

Now that we know the bounding box of the area we are interested in and the tag for the type of feature we want, we can download the data from OpenStreetMap.

<a id="lst-place-data-script-12-osm"></a>

<figure>
<pre><code>chapter_12.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Define the bounding box of the area we want to search</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>bus_stops <span class="ot">&lt;-</span> <span class="fu">opq</span>(la_candelaria_bbox) <span class="sc">|&gt;</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="co"># Define the features we want</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">add_osm_feature</span>(<span class="at">key =</span> <span class="st">&quot;highway&quot;</span>, <span class="at">value =</span> <span class="st">&quot;bus_stop&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="co"># Download those features for that area</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="fu">osmdata_sf</span>()</span></code></pre></div>
<figcaption>Code 12.7</figcaption>
</figure>

TipOverpass API errors

The Overpass API used by `osmdata_sf()` is a shared online service. If you see an error such as `HTTP 429 Too Many Requests`, wait a few minutes and then try running the query again. This error usually means the service is temporarily busy, rather than that there is a problem with your code.

The `bus_stops` object returned by `osmdata_sf()` is a *list* of objects. If you type the name of the object in the R Console and press , you will see a summary of the contents of the `bus_stops` object:

<a id="lst-place-data-inspect-bus-stop-object"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>bus_stops</span></code></pre></div>
<figcaption>Code 12.8</figcaption>
</figure>

    Object of class 'osmdata' with:
                     $bbox : 6.22450932830104,-75.5802925457919,6.26512401936258,-75.5538503495463
            $overpass_call : The call submitted to the overpass API
                     $meta : metadata including timestamp and version numbers
               $osm_points : 'sf' Simple Features Collection with 62 points
                $osm_lines : NULL
             $osm_polygons : 'sf' Simple Features Collection with 0 polygons
           $osm_multilines : NULL
        $osm_multipolygons : NULL

You can see that the object `bus_stops` has a fairly complex structure, but nested within it is an object called `osm_points` that is an SF object with 62 rows and another SF object called `osm_polygons`. Even within a particular type of feature, some places might be represented as points (e.g. a point placed at a bus stop) while others are represented as polygons (e.g. the outline of a bus station).

We can use the `pluck()` function from the `purrr` package (part of the tidyverse) to extract the parts of the `bus_stops` object that we want. To see the first few rows of the SF object `osm_points`, we can run this code in the R Console:

<a id="lst-place-data-inspect-bus-stop-points"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>bus_stops <span class="sc">|&gt;</span> <span class="fu">pluck</span>(<span class="st">&quot;osm_points&quot;</span>) <span class="sc">|&gt;</span> <span class="fu">glimpse</span>()</span></code></pre></div>
<figcaption>Code 12.9</figcaption>
</figure>

    Rows: 62
    Columns: 25
    $ osm_id               <chr> "847830985", "1561073855", "2300293115", "2418112…
    $ name                 <chr> "Las estatuas", "La Alpujarra", "Barrio Colombia"…
    $ access               <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ alt_name             <chr> NA, NA, "Estación Barrio Colombia", NA, NA, NA, N…
    $ bench                <chr> "no", NA, "yes", NA, NA, "no", "no", "no", "no", …
    $ bin                  <chr> "yes", NA, "yes", NA, NA, NA, NA, NA, NA, "no", N…
    $ bus                  <chr> "yes", NA, "yes", NA, "yes", "yes", "yes", "yes",…
    $ `check_date:shelter` <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ covered              <chr> NA, NA, NA, NA, NA, "no", "no", "no", "no", "no",…
    $ highway              <chr> "bus_stop", "bus_stop", "bus_stop", "bus_stop", "…
    $ lit                  <chr> NA, NA, "yes", NA, NA, NA, NA, NA, NA, NA, NA, NA…
    $ local_ref            <chr> NA, "La Alpujarra", NA, NA, NA, NA, NA, NA, NA, N…
    $ `name:en`            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "…
    $ `name:signed`        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ network              <chr> NA, NA, "Metroplus", NA, "Metroplus", NA, NA, NA,…
    $ note                 <chr> NA, NA, NA, NA, "Sentido Norte Sur", NA, NA, NA, …
    $ operator             <chr> NA, NA, "Metro de Medellín", NA, "Metro de Medell…
    $ panoramax            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ public_transport     <chr> "platform", NA, "platform", NA, "platform", "plat…
    $ `ref:signed`         <chr> "no", NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    $ shelter              <chr> "yes", "no", "yes", NA, "yes", "no", "no", "no", …
    $ source               <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
    $ tactile_paving       <chr> "no", NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
    $ wheelchair           <chr> NA, NA, "yes", NA, "yes", NA, NA, NA, NA, NA, NA,…
    $ geometry             <POINT [°]> POINT (-75.57696 6.260205), POINT (-75.5734…

We can see from this that `osmdata_sf()` has returned a number of different data fields for each bus stop in the area we are interested in. Most of the fields are blank, but there is a `name` column and a `geometry` column that we can use to plot the locations of the bus stops.

Now that we have the locations of bus stops in or near La Candelaria, let's map them and compare them to the locations of homicides. To do that, we can create a kernel density layer of homicides, as we learned to do in [Chapter 6](../06_mapping_crime_patterns/index.llms.md).

We will transform the data to EPSG:3115, a projected CRS for Medellín whose coordinates are measured in metres. This makes it easy to specify a 100-metre cell size when we create the density grid. See [Section 6.2.1](../06_mapping_crime_patterns/index.llms.md#sec-choosing-projected-crs) for how to choose a suitable projected CRS.

Add this code to the `chapter_12.R` file and run it.

<a id="lst-place-data-script-12-wrangle"></a>

<figure>
<pre><code>chapter_12.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="do">## WRANGLE DATA ----------------------------------------------------------------</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="co"># Create neighbourhood boundary</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>la_candelaria <span class="ot">&lt;-</span> medellin_comunas <span class="sc">|&gt;</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="fu">filter</span>(nombre <span class="sc">==</span> <span class="st">&quot;LA CANDELARIA&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="co"># Transform the data to a local coordinate reference system</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:3115&quot;</span>)</span>
<span id="cb2-8"><a href="#cb2-8"></a></span>
<span id="cb2-9"><a href="#cb2-9"></a><span class="co"># Estimate homicide density</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>homicide_density <span class="ot">&lt;-</span> medellin_homicides <span class="sc">|&gt;</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="co"># Use the same CRS as `la_candelaria`</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:3115&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="co"># Extract only those homicides occurring within the La Candelaria</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="co"># neighbourhood (otherwise `hotspot_kde()` will be very slow)</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  <span class="fu">hotspot_clip</span>(la_candelaria) <span class="sc">|&gt;</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="co"># Estimate density of homicides</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>  <span class="fu">hotspot_kde</span>(</span>
<span id="cb2-18"><a href="#cb2-18"></a>    <span class="at">grid =</span> <span class="fu">hotspot_grid</span>(la_candelaria, <span class="at">cell_size =</span> <span class="dv">100</span>),</span>
<span id="cb2-19"><a href="#cb2-19"></a>    <span class="at">bandwidth_adjust =</span> <span class="fl">0.33</span>,</span>
<span id="cb2-20"><a href="#cb2-20"></a>    <span class="at">quiet =</span> <span class="cn">TRUE</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  <span class="co"># Clip the result to the neighbourhood boundary</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>  <span class="fu">hotspot_clip</span>(la_candelaria)</span></code></pre></div>
<figcaption>Code 12.10</figcaption>
</figure>

    Removed 8,021 rows (86.4% of original rows) from `data`
    Removed 61 rows (6.9% of original rows) from `data`

Note that since we have used `hotspot_clip()` twice, this code produces two messages to explain how many rows have been removed from the data. The first message tells us that when we clipped the dataset of homicides in the whole city to the boundary of the La Candelaria neighbourhood, most of the rows were removed from the dataset. This makes sense because La Candelaria is a small area of the city, so most homicides in Medellin occur outside that neighbourhood. The second message tells us that when we clipped the kernel density estimate to the neighbourhood boundary, a small proportion of rows were removed from that dataset. This also makes sense because the convex hull produced by `hotspot_grid()` will not be a perfect fit for the neighbourhood boundary. We could suppress these messages with the `quiet = TRUE` argument to `hotspot_clip()` if we wanted to.

We now have everything we need to map homicides in La Candelaria in relation to bus stops. Let's add to our script file the code needed to create a density map.

<a id="lst-place-data-script-12-map"></a>

<figure>
<pre><code>chapter_12.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>la_candelaria_metro_lines <span class="ot">&lt;-</span> metro_lines <span class="sc">|&gt;</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>  <span class="fu">st_transform</span>(<span class="fu">st_crs</span>(la_candelaria)) <span class="sc">|&gt;</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">hotspot_clip</span>(la_candelaria, <span class="at">quiet =</span> <span class="cn">TRUE</span>)</span>
<span id="cb2-4"><a href="#cb2-4"></a></span>
<span id="cb2-5"><a href="#cb2-5"></a><span class="co"># PLOT MAP ---------------------------------------------------------------------</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>place_data_map <span class="ot">&lt;-</span> <span class="fu">hotspot_map</span>(</span>
<span id="cb2-7"><a href="#cb2-7"></a>  homicide_density,</span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>,</span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="at">caption =</span> <span class="fu">str_glue</span>(</span>
<span id="cb2-10"><a href="#cb2-10"></a>    <span class="st">&quot;Map data: © OpenStreetMap contributors</span><span class="sc">\n</span><span class="st">&quot;</span>,</span>
<span id="cb2-11"><a href="#cb2-11"></a>    <span class="st">&quot;Homicide data: Alcaldía de Medellín (CC-BY-SA)&quot;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  )</span>
<span id="cb2-13"><a href="#cb2-13"></a>) <span class="sc">+</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="co"># Add metro lines within the neighbourhood</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  <span class="fu">geom_sf</span>(</span>
<span id="cb2-16"><a href="#cb2-16"></a>    <span class="fu">aes</span>(<span class="at">colour =</span> <span class="st">&quot;Metro line&quot;</span>),</span>
<span id="cb2-17"><a href="#cb2-17"></a>    <span class="at">data =</span> la_candelaria_metro_lines,</span>
<span id="cb2-18"><a href="#cb2-18"></a>    <span class="at">linewidth =</span> <span class="dv">1</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>  ) <span class="sc">+</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  <span class="co"># Add neighbourhood boundary</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> la_candelaria, <span class="at">colour =</span> <span class="st">&quot;grey40&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>, <span class="at">linewidth =</span> <span class="fl">1.5</span>) <span class="sc">+</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  <span class="co"># Add bus stop locations</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>  <span class="fu">geom_sf</span>(</span>
<span id="cb2-24"><a href="#cb2-24"></a>    <span class="fu">aes</span>(<span class="at">shape =</span> <span class="st">&quot;Bus stop&quot;</span>),</span>
<span id="cb2-25"><a href="#cb2-25"></a>    <span class="at">data =</span> <span class="fu">pluck</span>(bus_stops, <span class="st">&quot;osm_points&quot;</span>),</span>
<span id="cb2-26"><a href="#cb2-26"></a>    <span class="at">colour =</span> <span class="st">&quot;black&quot;</span>,</span>
<span id="cb2-27"><a href="#cb2-27"></a>    <span class="at">fill =</span> <span class="st">&quot;white&quot;</span>,</span>
<span id="cb2-28"><a href="#cb2-28"></a>    <span class="at">size =</span> <span class="dv">2</span></span>
<span id="cb2-29"><a href="#cb2-29"></a>  ) <span class="sc">+</span></span>
<span id="cb2-30"><a href="#cb2-30"></a>  <span class="fu">scale_colour_manual</span>(<span class="at">values =</span> <span class="fu">c</span>(<span class="st">&quot;Metro line&quot;</span> <span class="ot">=</span> <span class="st">&quot;darkblue&quot;</span>)) <span class="sc">+</span></span>
<span id="cb2-31"><a href="#cb2-31"></a>  <span class="fu">scale_shape_manual</span>(<span class="at">values =</span> <span class="fu">c</span>(<span class="st">&quot;Bus stop&quot;</span> <span class="ot">=</span> <span class="dv">21</span>)) <span class="sc">+</span></span>
<span id="cb2-32"><a href="#cb2-32"></a>  <span class="co"># Add plot labels</span></span>
<span id="cb2-33"><a href="#cb2-33"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-34"><a href="#cb2-34"></a>    <span class="at">title =</span> <span class="st">&quot;Homicides do not appear to cluster around bus stops&quot;</span>,</span>
<span id="cb2-35"><a href="#cb2-35"></a>    <span class="at">subtitle =</span> <span class="st">&quot;La Candelaria, Medellin&quot;</span>,</span>
<span id="cb2-36"><a href="#cb2-36"></a>    <span class="at">colour =</span> <span class="cn">NULL</span>,</span>
<span id="cb2-37"><a href="#cb2-37"></a>    <span class="at">shape =</span> <span class="cn">NULL</span></span>
<span id="cb2-38"><a href="#cb2-38"></a>  )</span>
<span id="cb2-39"><a href="#cb2-39"></a></span>
<span id="cb2-40"><a href="#cb2-40"></a>place_data_map</span></code></pre></div>
<figcaption>Code 12.11</figcaption>
</figure>

<a id="map-la-candelaria-homicides-and-places"></a>

<figure>
<figure>
<p>Figure: Map of La Candelaria, Medellín, showing recorded homicide density from 2010 to 2019. Darker blue cells mark higher density inside a thick grey boundary. Hollow circles mark bus stops and a blue line marks the metro. The strongest density is in the northern part, while bus stops are spread more widely, including the south.</p>
</figure>
<figcaption>Map 12.5</figcaption>
</figure>

Most of this code should be familiar to you from previous chapters -- if you would like to refresh your memory on the code needed to produce a kernel density map, look back to [Chapter 6](../06_mapping_crime_patterns/index.llms.md). Before adding the metro lines, we use `hotspot_clip()` to keep only the portions inside La Candelaria. This prevents the map from expanding to show the entire metro network when we are interested in only one neighbourhood.

From this map, it looks like homicides do not cluster particularly around bus stops. This would probably be welcome information for the city's public transport managers.

ImportantOpenStreetMap data must be properly cited

Just as with other sources of map data, you are legally required to follow the [OpenStreetMap attribution guidelines](https://osmfoundation.org/wiki/Licence/Attribution_Guidelines) if you use OSM data. The code in [Code 12.11](#lst-place-data-script-12-map), for example, cites data from two sources:

- "© OpenStreetMap contributors" acknowledges that both the base map and the bus-stop locations were obtained from OpenStreetMap.
- "Homicide data: Alcaldía de Medellín (CC-BY-SA)" acknowledges that the Medellin homicide data were released by the Mayor of Medellin under the [Creative Commons Attribution Share-alike](https://opendefinition.org/licenses/cc-by-sa/) (CC-BY-SA) licence.

QuizOpenStreetMap data

**What type of data can be obtained from OpenStreetMap?**

- Only road networks
- Only administrative boundaries
- A variety of geographic features including roads, buildings, and landmarks (Correct answer)
- Only satellite imagery

**Which R package is used to retrieve data from OpenStreetMap?**

- openstreetmapr
- osmdata (Correct answer)
- osmr
- sf

**What does the `opq()` function do in the osmdata package?**

- Converts between coordinate reference systems
- Filters out duplicate points in a dataset
- Creates a map visualization
- Specifies a geographic area for an OpenStreetMap query (Correct answer)

<a id="in-summary"></a>

## 12.5 In summary

In this chapter we have learned how to find open data, including data from OpenStreetMap, and add it to our maps to help readers better understand crime patterns. We will be able to use these skills to add data to future maps that we make so that readers can gain more insight into crime patterns or other phenomena that we might be analysing.

We have practised how to:

- find and correctly cite open spatial data;
- download, extract and load a shapefile while preserving the original download;
- identify suitable OpenStreetMap tags and query them using `osmdata`;
- choose a suitable projected coordinate reference system; and
- combine crime and contextual place data in an informative map.

Your complete `chapter_12.R` script should now look like this:

<a id="lst-place-data-show-chapter-12-script"></a>

<figure>
<pre><code>chapter_12.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This script produces a map of the density of homicides in the La Candelaria</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="co"># area of Medellin, Colombia, together with bus stops in or near the area</span></span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Load packages</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, httr2, osmdata, sf, sfhotspot, tidyverse)</span>
<span id="cb2-6"><a href="#cb2-6"></a></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="co"># LOAD DATA --------------------------------------------------------------------</span></span>
<span id="cb2-8"><a href="#cb2-8"></a></span>
<span id="cb2-9"><a href="#cb2-9"></a><span class="do">## Load Medellin homicide data ----</span></span>
<span id="cb2-10"><a href="#cb2-10"></a><span class="co"># Download the original data</span></span>
<span id="cb2-11"><a href="#cb2-11"></a><span class="fu">request</span>(</span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/medellin_homicides.csv&quot;</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;medellin_homicides.csv&quot;</span>))</span>
<span id="cb2-15"><a href="#cb2-15"></a></span>
<span id="cb2-16"><a href="#cb2-16"></a><span class="co"># Note: this dataset uses &#39;;&#39; as the column separator</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>medellin_homicides <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;medellin_homicides.csv&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="fu">read_csv2</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>  <span class="co"># Remove rows with missing coordinates</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  <span class="fu">drop_na</span>(longitud, latitud) <span class="sc">|&gt;</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>  <span class="co"># Convert the data to an SF object</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;longitud&quot;</span>, <span class="st">&quot;latitud&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:4326&quot;</span>)</span>
<span id="cb2-23"><a href="#cb2-23"></a></span>
<span id="cb2-24"><a href="#cb2-24"></a><span class="do">## Load metro lines ----</span></span>
<span id="cb2-25"><a href="#cb2-25"></a></span>
<span id="cb2-26"><a href="#cb2-26"></a><span class="co"># Download zip file</span></span>
<span id="cb2-27"><a href="#cb2-27"></a>metro_lines_file <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;medellin_metro_lines.zip&quot;</span>)</span>
<span id="cb2-28"><a href="#cb2-28"></a><span class="fu">request</span>(</span>
<span id="cb2-29"><a href="#cb2-29"></a></span>
<span id="cb2-30"><a href="#cb2-30"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/medellin_metro_lines.zip&quot;</span></span>
<span id="cb2-31"><a href="#cb2-31"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-32"><a href="#cb2-32"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> metro_lines_file)</span>
<span id="cb2-33"><a href="#cb2-33"></a></span>
<span id="cb2-34"><a href="#cb2-34"></a><span class="co"># Unzip the files into a named directory</span></span>
<span id="cb2-35"><a href="#cb2-35"></a>metro_lines_dir <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;processed&quot;</span>, <span class="st">&quot;medellin_metro_lines&quot;</span>)</span>
<span id="cb2-36"><a href="#cb2-36"></a><span class="fu">unzip</span>(metro_lines_file, <span class="at">exdir =</span> metro_lines_dir)</span>
<span id="cb2-37"><a href="#cb2-37"></a><span class="co"># Load the data</span></span>
<span id="cb2-38"><a href="#cb2-38"></a>metro_lines <span class="ot">&lt;-</span> <span class="fu">here</span>(metro_lines_dir, <span class="st">&quot;medellin_metro_lines.shp&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-39"><a href="#cb2-39"></a>  <span class="fu">read_sf</span>()</span>
<span id="cb2-40"><a href="#cb2-40"></a></span>
<span id="cb2-41"><a href="#cb2-41"></a><span class="do">## Load neighbourhood boundary ----</span></span>
<span id="cb2-42"><a href="#cb2-42"></a><span class="fu">request</span>(</span>
<span id="cb2-43"><a href="#cb2-43"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/medellin_comunas.gpkg&quot;</span></span>
<span id="cb2-44"><a href="#cb2-44"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-45"><a href="#cb2-45"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;medellin_comunas.gpkg&quot;</span>))</span>
<span id="cb2-46"><a href="#cb2-46"></a></span>
<span id="cb2-47"><a href="#cb2-47"></a>medellin_comunas <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;medellin_comunas.gpkg&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-48"><a href="#cb2-48"></a>  <span class="fu">read_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-49"><a href="#cb2-49"></a>  janitor<span class="sc">::</span><span class="fu">clean_names</span>()</span>
<span id="cb2-50"><a href="#cb2-50"></a></span>
<span id="cb2-51"><a href="#cb2-51"></a><span class="co"># GET OSM DATA -----------------------------------------------------------------</span></span>
<span id="cb2-52"><a href="#cb2-52"></a></span>
<span id="cb2-53"><a href="#cb2-53"></a><span class="co"># Calculate neighbourhood bounding box</span></span>
<span id="cb2-54"><a href="#cb2-54"></a>la_candelaria_bbox <span class="ot">&lt;-</span> medellin_comunas <span class="sc">|&gt;</span></span>
<span id="cb2-55"><a href="#cb2-55"></a>  <span class="fu">filter</span>(nombre <span class="sc">==</span> <span class="st">&quot;LA CANDELARIA&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-56"><a href="#cb2-56"></a>  <span class="fu">st_bbox</span>()</span>
<span id="cb2-57"><a href="#cb2-57"></a></span>
<span id="cb2-58"><a href="#cb2-58"></a><span class="co"># Define the bounding box of the area we want to search</span></span>
<span id="cb2-59"><a href="#cb2-59"></a>bus_stops <span class="ot">&lt;-</span> <span class="fu">opq</span>(la_candelaria_bbox) <span class="sc">|&gt;</span></span>
<span id="cb2-60"><a href="#cb2-60"></a>  <span class="co"># Define the features we want</span></span>
<span id="cb2-61"><a href="#cb2-61"></a>  <span class="fu">add_osm_feature</span>(<span class="at">key =</span> <span class="st">&quot;highway&quot;</span>, <span class="at">value =</span> <span class="st">&quot;bus_stop&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-62"><a href="#cb2-62"></a>  <span class="co"># Download those features for that area</span></span>
<span id="cb2-63"><a href="#cb2-63"></a>  <span class="fu">osmdata_sf</span>()</span>
<span id="cb2-64"><a href="#cb2-64"></a></span>
<span id="cb2-65"><a href="#cb2-65"></a><span class="do">## WRANGLE DATA ----------------------------------------------------------------</span></span>
<span id="cb2-66"><a href="#cb2-66"></a></span>
<span id="cb2-67"><a href="#cb2-67"></a><span class="co"># Create neighbourhood boundary</span></span>
<span id="cb2-68"><a href="#cb2-68"></a>la_candelaria <span class="ot">&lt;-</span> medellin_comunas <span class="sc">|&gt;</span></span>
<span id="cb2-69"><a href="#cb2-69"></a>  <span class="fu">filter</span>(nombre <span class="sc">==</span> <span class="st">&quot;LA CANDELARIA&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-70"><a href="#cb2-70"></a>  <span class="co"># Transform the data to a local coordinate reference system</span></span>
<span id="cb2-71"><a href="#cb2-71"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:3115&quot;</span>)</span>
<span id="cb2-72"><a href="#cb2-72"></a></span>
<span id="cb2-73"><a href="#cb2-73"></a><span class="co"># Estimate homicide density</span></span>
<span id="cb2-74"><a href="#cb2-74"></a>homicide_density <span class="ot">&lt;-</span> medellin_homicides <span class="sc">|&gt;</span></span>
<span id="cb2-75"><a href="#cb2-75"></a>  <span class="co"># Use the same CRS as `la_candelaria`</span></span>
<span id="cb2-76"><a href="#cb2-76"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:3115&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-77"><a href="#cb2-77"></a>  <span class="co"># Extract only those homicides occurring within the La Candelaria</span></span>
<span id="cb2-78"><a href="#cb2-78"></a>  <span class="co"># neighbourhood (otherwise `hotspot_kde()` will be very slow)</span></span>
<span id="cb2-79"><a href="#cb2-79"></a>  <span class="fu">hotspot_clip</span>(la_candelaria) <span class="sc">|&gt;</span></span>
<span id="cb2-80"><a href="#cb2-80"></a>  <span class="co"># Estimate density of homicides</span></span>
<span id="cb2-81"><a href="#cb2-81"></a>  <span class="fu">hotspot_kde</span>(</span>
<span id="cb2-82"><a href="#cb2-82"></a>    <span class="at">grid =</span> <span class="fu">hotspot_grid</span>(la_candelaria, <span class="at">cell_size =</span> <span class="dv">100</span>),</span>
<span id="cb2-83"><a href="#cb2-83"></a>    <span class="at">bandwidth_adjust =</span> <span class="fl">0.33</span>,</span>
<span id="cb2-84"><a href="#cb2-84"></a>    <span class="at">quiet =</span> <span class="cn">TRUE</span></span>
<span id="cb2-85"><a href="#cb2-85"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-86"><a href="#cb2-86"></a>  <span class="co"># Clip the result to the neighbourhood boundary</span></span>
<span id="cb2-87"><a href="#cb2-87"></a>  <span class="fu">hotspot_clip</span>(la_candelaria)</span>
<span id="cb2-88"><a href="#cb2-88"></a></span>
<span id="cb2-89"><a href="#cb2-89"></a>la_candelaria_metro_lines <span class="ot">&lt;-</span> metro_lines <span class="sc">|&gt;</span></span>
<span id="cb2-90"><a href="#cb2-90"></a>  <span class="fu">st_transform</span>(<span class="fu">st_crs</span>(la_candelaria)) <span class="sc">|&gt;</span></span>
<span id="cb2-91"><a href="#cb2-91"></a>  <span class="fu">hotspot_clip</span>(la_candelaria, <span class="at">quiet =</span> <span class="cn">TRUE</span>)</span>
<span id="cb2-92"><a href="#cb2-92"></a></span>
<span id="cb2-93"><a href="#cb2-93"></a><span class="co"># PLOT MAP ---------------------------------------------------------------------</span></span>
<span id="cb2-94"><a href="#cb2-94"></a>place_data_map <span class="ot">&lt;-</span> <span class="fu">hotspot_map</span>(</span>
<span id="cb2-95"><a href="#cb2-95"></a>  homicide_density,</span>
<span id="cb2-96"><a href="#cb2-96"></a>  <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>,</span>
<span id="cb2-97"><a href="#cb2-97"></a>  <span class="at">caption =</span> <span class="fu">str_glue</span>(</span>
<span id="cb2-98"><a href="#cb2-98"></a>    <span class="st">&quot;Map data: © OpenStreetMap contributors</span><span class="sc">\n</span><span class="st">&quot;</span>,</span>
<span id="cb2-99"><a href="#cb2-99"></a>    <span class="st">&quot;Homicide data: Alcaldía de Medellín (CC-BY-SA)&quot;</span></span>
<span id="cb2-100"><a href="#cb2-100"></a>  )</span>
<span id="cb2-101"><a href="#cb2-101"></a>) <span class="sc">+</span></span>
<span id="cb2-102"><a href="#cb2-102"></a>  <span class="co"># Add metro lines within the neighbourhood</span></span>
<span id="cb2-103"><a href="#cb2-103"></a>  <span class="fu">geom_sf</span>(</span>
<span id="cb2-104"><a href="#cb2-104"></a>    <span class="fu">aes</span>(<span class="at">colour =</span> <span class="st">&quot;Metro line&quot;</span>),</span>
<span id="cb2-105"><a href="#cb2-105"></a>    <span class="at">data =</span> la_candelaria_metro_lines,</span>
<span id="cb2-106"><a href="#cb2-106"></a>    <span class="at">linewidth =</span> <span class="dv">1</span></span>
<span id="cb2-107"><a href="#cb2-107"></a>  ) <span class="sc">+</span></span>
<span id="cb2-108"><a href="#cb2-108"></a>  <span class="co"># Add neighbourhood boundary</span></span>
<span id="cb2-109"><a href="#cb2-109"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> la_candelaria, <span class="at">colour =</span> <span class="st">&quot;grey40&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>, <span class="at">linewidth =</span> <span class="fl">1.5</span>) <span class="sc">+</span></span>
<span id="cb2-110"><a href="#cb2-110"></a>  <span class="co"># Add bus stop locations</span></span>
<span id="cb2-111"><a href="#cb2-111"></a>  <span class="fu">geom_sf</span>(</span>
<span id="cb2-112"><a href="#cb2-112"></a>    <span class="fu">aes</span>(<span class="at">shape =</span> <span class="st">&quot;Bus stop&quot;</span>),</span>
<span id="cb2-113"><a href="#cb2-113"></a>    <span class="at">data =</span> <span class="fu">pluck</span>(bus_stops, <span class="st">&quot;osm_points&quot;</span>),</span>
<span id="cb2-114"><a href="#cb2-114"></a>    <span class="at">colour =</span> <span class="st">&quot;black&quot;</span>,</span>
<span id="cb2-115"><a href="#cb2-115"></a>    <span class="at">fill =</span> <span class="st">&quot;white&quot;</span>,</span>
<span id="cb2-116"><a href="#cb2-116"></a>    <span class="at">size =</span> <span class="dv">2</span></span>
<span id="cb2-117"><a href="#cb2-117"></a>  ) <span class="sc">+</span></span>
<span id="cb2-118"><a href="#cb2-118"></a>  <span class="fu">scale_colour_manual</span>(<span class="at">values =</span> <span class="fu">c</span>(<span class="st">&quot;Metro line&quot;</span> <span class="ot">=</span> <span class="st">&quot;darkblue&quot;</span>)) <span class="sc">+</span></span>
<span id="cb2-119"><a href="#cb2-119"></a>  <span class="fu">scale_shape_manual</span>(<span class="at">values =</span> <span class="fu">c</span>(<span class="st">&quot;Bus stop&quot;</span> <span class="ot">=</span> <span class="dv">21</span>)) <span class="sc">+</span></span>
<span id="cb2-120"><a href="#cb2-120"></a>  <span class="co"># Add plot labels</span></span>
<span id="cb2-121"><a href="#cb2-121"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-122"><a href="#cb2-122"></a>    <span class="at">title =</span> <span class="st">&quot;Homicides do not appear to cluster around bus stops&quot;</span>,</span>
<span id="cb2-123"><a href="#cb2-123"></a>    <span class="at">subtitle =</span> <span class="st">&quot;La Candelaria, Medellin&quot;</span>,</span>
<span id="cb2-124"><a href="#cb2-124"></a>    <span class="at">colour =</span> <span class="cn">NULL</span>,</span>
<span id="cb2-125"><a href="#cb2-125"></a>    <span class="at">shape =</span> <span class="cn">NULL</span></span>
<span id="cb2-126"><a href="#cb2-126"></a>  )</span>
<span id="cb2-127"><a href="#cb2-127"></a></span>
<span id="cb2-128"><a href="#cb2-128"></a>place_data_map</span></code></pre></div>
<figcaption>Code 12.12</figcaption>
</figure>

Save `chapter_12.R` by pressing .

To check that the analysis is reproducible, restart R using the **Restart R** (**⟳**) button in Positron's **Console** panel, then run the script from beginning to end.

Keep the script in the `R` folder, the original downloads in `data/raw` and the extracted shapefile components in `data/processed`.

To find out more about the skills we have worked on in this chapter, you may want to read:

- [a paper exploring how open crime data can be used in researching crime](https://discovery.ucl.ac.uk/id/eprint/1455360/), and
- [a more-detailed introduction to the `osmdata` package written by Mark Padgham and Robin Lovelace](https://docs.ropensci.org/osmdata/articles/osmdata.html).

QuizRevision questions

Answer these questions to check you have understood the main points covered in this chapter. Write between 50 and 100 words to answer each question.

1.  Why is it important to incorporate additional spatial data when creating crime maps?
2.  What are the key differences between open data and proprietary data sources?
3.  What are shapefiles, and what challenges do they present when working with spatial data?
4.  How does OpenStreetMap (OSM) work as a data source, and what steps are involved in retrieving spatial data from OSM using R?
5.  Why is it necessary to check the terms of use and provide attribution when using open data sources?

The OpenStreetMap logo is a trademark of the OpenStreetMap Foundation and is used with their permission. This chapter is not endorsed by or affiliated with the OpenStreetMap Foundation.
