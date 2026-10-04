Source: https://books.lesscrime.info/learncrimemapping/2026/07_map_context/index.html

<a id="quarto-document-content"></a>
<a id="title-block-header"></a>
<a id="giving-a-map-context"></a>

# `<a id="sec-map-context"></a>`{=html}7  Giving a map context

Figure: Students examine a map with colour swatches, north arrow and scale bar.

In [Chapter 5](../05_your_second_crime_map/index.llms.md) and [Chapter 6](../06_mapping_crime_patterns/index.llms.md) we've learned how to make maps of crime data. In this chapter we'll learn to make those maps more useful by adding context using titles, legends and other supporting elements. In particular we'll focus on the important of *visual hierarchy* in guiding a reader's attention to the most important parts of a map. We'll also learn how to save a finished map as a file so that it can be shared with others.

TipBefore you start

1.  Open Positron or -- if you already have Positron open -- start a new R session by clicking the **Restart R** (**⟳**) button in the **Console** panel. This makes sure no code you ran previously will interfere with the work you do in this chapter.
2.  Make sure you are working in the crime mapping project workspace you created in [Section 1.5](../01_getting_started/index.llms.md#sec-create-project). In the top-right corner of the Positron window, you should see a folder icon and the words `crime_mapping`. If not, click the **File** menu, then **Open Folder ...** and choose the `crime_mapping` folder.

<a id="introduction"></a>

## 7.1 Introduction

In this chapter we will create this map of shootings in the Bronx (one of the five boroughs of New York City) in 2019.

<a id="map-bronx-shootings-introduction"></a>

<figure>
<figure>
<p>Figure: Density map of recorded shootings in the Bronx in 2019. Darker orange indicates higher estimated density, concentrated in the south-west; the eastern precincts are mostly pale. Precinct boundaries and numbers locate the shaded concentrations on a pale street map. A legend and scale bar support interpretation.</p>
</figure>
<figcaption>Map 7.1</figcaption>
</figure>

You can see that this map includes contextual elements such as a title, a legend and a scale bar. In this chapter we will learn how to add each of these elements to a map, and (just as importantly) when you shouldn't use them.

In this chapter, we will learn how to:

- make design decisions based on a map's purpose and audience;
- use visual hierarchy to guide a reader's attention;
- add and format titles, subtitles and captions;
- make legends easier to understand;
- add scale bars and north arrows when they are useful; and
- save a finished map as a file.

The process we will use has five main stages:

Load

download data from the internet and load it into an R session

Wrangle

data into the format we need

Model

data using kernel density estimation

Visualise

density on a map, including supporting elements

Save

the completed map

<a id="map-choices"></a>

## 7.2 Map choices

Among the most important decisions you make when you are creating a map is what information to include and what to leave out. Watch this video to learn more about why this is important and how you can make those decisions.

Media: Video explaining how a map\'s purpose and audience should determine what information it includes [(open media)](https://www.youtube.com/embed/8FbywcgBpa4)

TranscriptVideo transcript: Deciding what to include on a map

<a id="callout-2"></a>

**Partial transcript:** The supplied captions begin at 1:46, with the third question. The opening part of the video is missing from this transcript.

The third question we need to ask ourselves is: what information do readers already know? This military map of London created by the Soviet army in the 1980s was designed for use by the that army in the event of an invasion. The people making this map would've known that their readers would be familiar with things like the specialist symbols you can see on this map. Using those symbols means that the map makers could squeeze in a lot of information that might not have been possible if the map was intended for a more general audience.

Understanding what readers already know also helps us decide what not to include on a map. If our intended audience can be expected to already know an area well we might be able to leave out things that we would otherwise have included. Leaving things out might actually make a map better, if it means it's easier for the audience to focus on the main message of the map. But it depends on the needs of each map audience.

The next question to ask ourselves is: in what context are people going to use this map? It's particularly important to think about whether a map will be static -- for example if it is going to be printed out or distributed as a PDF -- or dynamic -- for example a map on a website. Dynamic maps can be zoomed in and out, and users can often choose to add or remove layers of information, whereas if you are making a static map you need to choose the best scale and which features to include when you make the map.

If your map is going to be printed out, you also need to think about whether it will still convey all the necessary information if someone photocopies the map in black and white. The final question to ask yourself when creating a map is: how could this map lead the audience to a wrong conclusion? Maps are powerful tools for communicating information about the world, so it's important to make sure our maps aren't misleading.

For example this map shows hotspots of violent crime in London. You can see that some of the hotspots are very small and some are more diffuse. Humans tend to interpret larger areas of colour on maps as being more important, which could be misleading if a large diffuse hotspot actually had fewer violent crimes than a smaller but more intense hotspot. To prevent this, when I made this map I numbered the hotspots so that readers could clearly see which places had the most violent crime.

So, in summary, every time you make a map you should first think about: What will people use the map for? What information do readers need? What information to readers already know? In what context are people going to use this map? How could this map lead the audience to a wrong conclusion?

QuizMap choices

**Which statement best summarizes the key points of the video?**

- Map design is mostly about choosing the right colours and symbols
- Map makers must consider their audience, the purpose of the map, and how it will be used (Correct answer)
- The most detailed maps are always the most effective
- Maps should include as much information as possible to avoid confusion

**What is one potential benefit of leaving out information on a map?**

- It makes the map more colourful
- It makes the map less useful
- It allows for more artistic expression
- It ensures the audience focuses on the main message (Correct answer)

**What is one way that maps can unintentionally mislead their audience?**

- By using symbols that are too small
- By including too much detail
- By making large areas of colour seem more important than they actually are (Correct answer)
- By leaving out street names

The most important thing to remember when designing a map is the purpose for which it will be used. Research on how people use maps has repeatedly shown that the task a reader wants to complete strongly influences how they process the information on a map. You can read more about this in [Cartography, visual perception and cognitive psychology](https://doi.org/10.4324/9781315736822-5) by Amy Griffin.

As explained in the video, when you create a crime map you should ask yourself:

- *What will readers be using this map for?*
- *What information do readers need?*
- *What do readers already know?*
- *In what context are people going to use this map?*
- *How could this map lead the audience to a wrong conclusion?*

Maps are powerful communication tools. The choices made by a map maker can deliberately or inadvertently mislead readers. Watch this video to learn more about how maps can be misleading.

Media: Video explaining how choices made by map makers can mislead readers [(open media)](https://www.youtube.com/embed/G0_MBrJnRq0)

TranscriptVideo transcript: Do Maps Lie?

<a id="callout-4"></a>

\[Music\] do maps lie we all know the phrase lies Dam lies and statistics and we know that data can be used and abused but what about Maps can they be weapons of deception or tools of tyranny of course they can Maps can mislead due to honest Mistakes by the author or they can mislead us on purpose let's take as an example the issue of mapping house prices in London many would argue prices are far too high but do the maps agree as an example let's look at two

different maps of London house prices both Maps use the same data but with very different results Jim wants to show that things aren't actually that bad and that prices aren't that high in this case he could use an equal interval classification like in this map where prices don't look too high in most of the city most areas show an average house price in the lowest statistical category this helps make the argument that prices aren't actually that high but Anna wants to show how outof control prices are in London compared to the

rest of the country so she's made a map which shows areas of London which have an average house price below the UK average and areas which are above the national average as we can see this makes London look very expensive and this more closely fits the national narrative on the topic but neither of these examples are 100% correct though the second one is perhaps much more powerful even though it uses the same data as the first if we wanted to produce something more meaningful which represented the underlying data in a

more conventional way a map like this would be more useful so do maps lie well kind of they can be designed to deliberately mislead us or influence us one way or another about a particular issue and this is the point Maps aren't neutral map makers can lie it always helps to look at a map with a critical eye next time you look at a map ask yourself the following questions before deciding what it shows who made it why did they make it what does it actually tell us

\[Music\]

QuizDo maps lie?

**According to the video, why should we critically evaluate maps?**

- Maps are always based on outdated data
- Maps are neutral and require interpretation
- Maps can be created to deliberately influence or mislead viewers (Correct answer)
- Maps are only useful for navigation, not analysis

**What is the main difference between Jim's and Anna's maps of London house prices?**

- Jim uses outdated data, while Anna uses current data
- Jim uses an equal interval classification, while Anna compares London prices to the UK average (Correct answer)
- Jim's map shows rental prices, while Anna's map shows purchase prices
- Jim's map focuses on urban areas, while Anna's map focuses on rural areas

**What three questions should you ask when evaluating a map?**

- Where was it made? Who paid for it? What colours are used?
- Is the data current? How is it classified? Is it geographically accurate?
- What software was used? What is the scale? How many layers does it have?
- Who made it? Why did they make it? What does it tell us? (Correct answer)

Whenever you make a map, think about your own biases -- are your own views on a topic likely to influence the results of your analysis? One way to test your own assumptions about a topic is to test them against other potential assumptions using an approach to crime analysis called hypothesis testing. To find out more about this approach, read [*Improving the explanatory content of analysis products using hypothesis testing*](https://doi.org/10.1093/police/pas007) by Spencer Chainey.

<a id="sec-visual-hierarchy"></a>
<a id="visual-hierarchy"></a>

## 7.3 Visual hierarchy

Maps are among the most complex types of data visualisation. Even if we have chosen wisely what to include and what to leave out, there is likely to be lots of information on our map. For all but the simplest maps, there is a risk that readers -- especially those in a hurry -- might be overwhelmed or misled by competing pieces of information, such as different data layers.

To help readers understand what parts of a map they should focus most of their attention on and which are of less importance, we can establish a visual hierarchy. Watch this video to learn more about visual hierarchies in mapping.

Media: Video explaining how visual hierarchy guides a map reader\'s attention [(open media)](https://www.youtube.com/embed/YHE0W86tnHM)

TranscriptVideo transcript: The visual hierarchy of maps

<a id="callout-6"></a>

Maps can contain a lot of information, so it's important to guide readers' attention to the most important elements. In this video, I'm going to explain how to do that by establishing what's called visual hierarchy. The basic idea here is very simple: how much attention readers give to different elements on a map depends on the visual appearance of that element and the ones surrounding it. As an example, I'll use this map of personal robberies in San Francisco.

On this basic version of the map there are two layers: one showing hotspots of robbery, and a base map that helps readers understand where those hotspots are. On any map the most important layer is the one showing the data we are interested in. Because that layer is the most important, it should also be what's most visually prominent. In this case, I've achieved that by using a strong colour for the robbery layer while choosing a base map that uses shades of grey.

Since brighter, more saturated colours -- or colours that have a greater contrast from the background -- are more visually prominent than shades of grey, this helps the robbery hotspots stand out from the background map. Colour is just one way that we can influence the visual prominence of elements on our map. We can see this if we add some supporting elements to this map, such as a title and the names of local police districts.

Now there are several different types of text on the map, it will be useful to help our readers understand which is most important. You can see here that I have used text size to make the map title more prominent than the text on the map itself, which is in-turn more prominent than the copyright statements at the bottom. I've also made some of the text a lighter shade of grey, which makes it less visually prominent by reducing the contrast between the text and the background.

Another way to increase or decrease the visual prominence of a map element is to use isolation. Elements that are isolated from their surroundings, such as text that is surrounded by a box of a contrasting colour, or points that are surrounded by a thick line, are more visually prominent than the same element without that isolation. Similarly, if an item is semi-transparent, that will tend to reduce its visual prominence. It can be useful to combine attributes such as size, colour, isolation and transparency to create multiple levels of visual prominence on a map, helping to guide readers to the content we think is most important.

Whenever we are making decisions about how to represent different features on a map, it's really important to make sure that the data layer or layers is the most visually prominent, since that is the layer readers need to focus on most to make decisions. All the supporting elements on a map -- administrative boundaries, base maps, labels, copyright information and so on -- should be less visually prominent than the data layer to avoid distracting from it.

So in summary, Creating a visual hierarchy helps guide readers through the maps that we make We can establish visual hierarchy using combinations of size, colour, is isolation and transparency We should always make sure that the data layer is the most visually prominent part of our maps

QuizVisual hierarchy

**What is the main goal of establishing a visual hierarchy in maps?**

- To make all elements of the map equally visible
- To make maps look more colourful
- To guide readers' attention to the most important elements (Correct answer)
- To eliminate unnecessary details from the map

**How does isolation affect the prominence of an element on a map?**

- Isolated elements become less visible
- Isolated elements become more visually prominent (Correct answer)
- Isolation only affects text, not other visual elements
- Isolation does not impact visual prominence

**How does text size contribute to visual hierarchy?**

- Larger text makes elements more prominent than smaller text (Correct answer)
- All text should be the same size for consistency
- Smaller text is always easier to read
- Text size has no impact on visual hierarchy

We have used some of the principles of visual hierarchy in the maps we have already made. For example, in the density map of bike thefts in Vancouver, we used strong colours to represent the data and shades of grey for the base map. This helped readers intuitively understand that they should focus most attention on the data.

<a id="supporting-elements"></a>

## 7.4 Supporting elements

We can often make our maps much more useful by adding supporting elements that explain the map content, give context or provide extra information. Supporting elements include titles, captions, legends, base maps, scale bars and north arrows.

We will not need to include every supporting element on every map. The hierarchy will depend on the map's purpose, but the data, title and legend will usually be among the most-prominent elements. Other elements should be designed so that they provide useful context without distracting from the main message.

    place in hierarchy map element       how often needed
  -------------------- ----------------- ------------------
                   1st data layers       always
                   2nd title             virtually always
                   3rd legend            usually
                   4th base map          almost always
                   5th author and date   virtually always
                  =6th scale             sometimes
                  =6th north arrow       sometimes
                   7th grid              rarely

  : Visual hierarchy of elements in a crime map

The table is a useful starting point rather than a rule that applies to every map. Elements that are often needed are not necessarily high in the visual hierarchy. For example, the author's name is important for readers who need to judge the reliability of a map or get in touch to ask questions, but it should not distract readers from the map's main message.

QuizSupporting elements

**What is the main purpose of supporting elements on a map?**

- Every map should contain every available supporting element
- The north arrow should always be the most-prominent item
- Supporting elements should help readers without distracting from the main message (Correct answer)
- Supporting elements should all have the same visual prominence

**How should you use the hierarchy shown in the table?**

- It is a fixed rule that every map must follow
- It is a useful starting point that should be adapted to the map\'s purpose (Correct answer)
- It determines the order in which R runs the code
- It applies only to maps designed for navigation

<a id="sec-creating-storing-map"></a>
<a id="creating-and-storing-a-map"></a>

## 7.5 Creating and storing a map

Since we will be adding various elements to a map in this chapter, we will first create a map and save it as an R object. Any map produced using the `hotspot_map()` function can be saved as an object using the assignment operator `<-`. Just as for the result of any other R function, if we save it to an object the result will not be printed to the screen, but we can easily see the plot by simply typing the object name in the R console.

Create a new R script for the permanent code used in this chapter:

1.  Click the **File** menu in Positron, then click **New File ...**.
2.  Type `chapter_07.R` in the box marked **Select File Type or Enter File Name...**, then press ReturnReturn.
3.  Save the file in the `R` folder inside your `crime_mapping` workspace.

The script first downloads the original files into `data/raw`, then loads and prepares the local copies. Keeping the original files in `data/raw` means that you can repeat the analysis without depending on the websites remaining available. We will transform both spatial datasets to EPSG:6538, a projected CRS designed for New York whose coordinates are measured in metres. See [Section 6.2.1](../06_mapping_crime_patterns/index.llms.md#sec-choosing-projected-crs) for how to choose a suitable projected CRS for a particular dataset. Paste this code into `chapter_07.R` and run it by pressing to select all the code, then .

<a id="lst-map-context-initial-script"></a>

<figure>
<pre><code>chapter_07.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This script adds contextual elements to a density map of shootings in the</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="co"># Bronx in 2019, then saves the finished map as a PDF.</span></span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Load packages</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(ggspatial, here, httr2, sf, sfhotspot, tidyverse)</span>
<span id="cb2-6"><a href="#cb2-6"></a></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="co"># Download the raw data</span></span>
<span id="cb2-8"><a href="#cb2-8"></a><span class="fu">request</span>(</span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/bronx_shootings.csv&quot;</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;bronx_shootings.csv&quot;</span>))</span>
<span id="cb2-12"><a href="#cb2-12"></a></span>
<span id="cb2-13"><a href="#cb2-13"></a><span class="fu">request</span>(</span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/nyc_precincts.gpkg&quot;</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nyc_precincts.gpkg&quot;</span>))</span>
<span id="cb2-17"><a href="#cb2-17"></a></span>
<span id="cb2-18"><a href="#cb2-18"></a><span class="co"># Load shootings data and transform it to use an appropriate coordinate system</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>shootings <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;bronx_shootings.csv&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  <span class="fu">read_csv</span>(<span class="at">show_col_types =</span> <span class="cn">FALSE</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;longitude&quot;</span>, <span class="st">&quot;latitude&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:4326&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:6538&quot;</span>)</span>
<span id="cb2-23"><a href="#cb2-23"></a></span>
<span id="cb2-24"><a href="#cb2-24"></a><span class="co"># Load NYC police precincts data</span></span>
<span id="cb2-25"><a href="#cb2-25"></a>precincts <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nyc_precincts.gpkg&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-26"><a href="#cb2-26"></a>  <span class="fu">read_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-27"><a href="#cb2-27"></a>  janitor<span class="sc">::</span><span class="fu">clean_names</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-28"><a href="#cb2-28"></a>  <span class="co"># Filter just those precincts that are in the Bronx (40th to 52nd)</span></span>
<span id="cb2-29"><a href="#cb2-29"></a>  <span class="fu">filter</span>(precinct <span class="sc">%in%</span> <span class="dv">40</span><span class="sc">:</span><span class="dv">52</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-30"><a href="#cb2-30"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:6538&quot;</span>)</span>
<span id="cb2-31"><a href="#cb2-31"></a></span>
<span id="cb2-32"><a href="#cb2-32"></a><span class="co"># Estimate density of shootings and clip the result to the Bronx precincts</span></span>
<span id="cb2-33"><a href="#cb2-33"></a>shootings_kde <span class="ot">&lt;-</span> shootings <span class="sc">|&gt;</span></span>
<span id="cb2-34"><a href="#cb2-34"></a>  <span class="fu">hotspot_kde</span>(</span>
<span id="cb2-35"><a href="#cb2-35"></a>    <span class="at">grid =</span> <span class="fu">hotspot_grid</span>(precincts, <span class="at">cell_size =</span> <span class="dv">200</span>),</span>
<span id="cb2-36"><a href="#cb2-36"></a>    <span class="at">bandwidth_adjust =</span> <span class="fl">0.33</span>,</span>
<span id="cb2-37"><a href="#cb2-37"></a>    <span class="at">quiet =</span> <span class="cn">TRUE</span></span>
<span id="cb2-38"><a href="#cb2-38"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-39"><a href="#cb2-39"></a>  <span class="fu">hotspot_clip</span>(precincts, <span class="at">quiet =</span> <span class="cn">TRUE</span>)</span>
<span id="cb2-40"><a href="#cb2-40"></a></span>
<span id="cb2-41"><a href="#cb2-41"></a><span class="co"># Create a basic map object</span></span>
<span id="cb2-42"><a href="#cb2-42"></a>shootings_map <span class="ot">&lt;-</span> <span class="fu">hotspot_map</span>(shootings_kde, <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-43"><a href="#cb2-43"></a>  <span class="co"># Add precinct boundaries</span></span>
<span id="cb2-44"><a href="#cb2-44"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> precincts, <span class="at">colour =</span> <span class="st">&quot;grey33&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-45"><a href="#cb2-45"></a>  <span class="co"># Add precinct labels</span></span>
<span id="cb2-46"><a href="#cb2-46"></a>  <span class="fu">geom_sf_label</span>(</span>
<span id="cb2-47"><a href="#cb2-47"></a>    <span class="fu">aes</span>(<span class="at">label =</span> scales<span class="sc">::</span><span class="fu">ordinal</span>(precinct)),</span>
<span id="cb2-48"><a href="#cb2-48"></a>    <span class="at">data =</span> precincts,</span>
<span id="cb2-49"><a href="#cb2-49"></a>    <span class="at">alpha =</span> <span class="fl">0.5</span>,</span>
<span id="cb2-50"><a href="#cb2-50"></a>    <span class="at">colour =</span> <span class="st">&quot;grey33&quot;</span>,</span>
<span id="cb2-51"><a href="#cb2-51"></a>    <span class="at">fill =</span> <span class="st">&quot;white&quot;</span>,</span>
<span id="cb2-52"><a href="#cb2-52"></a>    <span class="at">size =</span> <span class="fl">2.5</span>,</span>
<span id="cb2-53"><a href="#cb2-53"></a>    <span class="at">linewidth =</span> <span class="cn">NA</span></span>
<span id="cb2-54"><a href="#cb2-54"></a>  )</span></code></pre></div>
<figcaption>Code 7.1</figcaption>
</figure>

There's quite a lot of code here, so if you want to refresh your memory about some of it, you can look back to:

- [Section 3.2](../03_data_wrangling/index.llms.md#sec-read-data) about downloading data from the internet and loading data into R from CSV files;
- [Section 5.4](../05_your_second_crime_map/index.llms.md#sec-spatial-data) about loading data into R from spatial data files;
- [Section 2.4](../02_your_first_crime_map/index.llms.md#sec-processing-spatial-data) about converting tabular data to SF format and transforming between coordinate systems;
- [Section 3.4](../03_data_wrangling/index.llms.md#sec-filter-data) about filtering data; and
- [Chapter 6](../06_mapping_crime_patterns/index.llms.md) about estimating the density of crime and clipping the result to a specific area.
- [Section 6.6](../06_mapping_crime_patterns/index.llms.md#sec-other-layers) about adding layers to a map using `geom_sf()` and `geom_sf_label()`.

To view the map in Positron, type the name of the map object into the R Console and press as usual.

<a id="lst-map-context-show-basic-map"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>shootings_map</span></code></pre></div>
<figcaption>Code 7.2</figcaption>
</figure>

<a id="map-bronx-shooting-density-basic"></a>

<figure>
<figure>
<p>Figure: Basic density map of recorded shootings in the Bronx in 2019. Darker blue cells indicate higher estimated density, concentrated in the south-west, while eastern areas are much paler. Police-precinct boundaries and ordinal precinct numbers locate the concentrations over a pale street map; the legend still shows numeric density values.</p>
</figure>
<figcaption>Map 7.2</figcaption>
</figure>

The code used to create this map is very similar to the code we used in [Section 6.2](../06_mapping_crime_patterns/index.llms.md#sec-kde) to make a map of bike theft in Vancouver, although there are a few differences.

<a id="sec-map-context-formatting-numbers-using-the-scales-package"></a>
<a id="formatting-numbers-using-the-scales-package"></a>

### 7.5.1 Formatting numbers using the scales package

[](https://scales.r-lib.org)

The only other difference from the Vancouver map is that we have used the `ordinal()` function from the [scales package](https://scales.r-lib.org) to convert the precinct numbers to ordinal numbers (1st, 2nd, 3rd, etc.) for the map labels. This is because police precincts in New York City are usually referred to using ordinal numbers (e.g. "the 1st Precinct" rather than "Precinct 1") and it will be easier for people to read the map if it uses terms they are familiar with.

ImportantDon't always use ordinal numbers for labels

We are using ordinal numbers (1st, 2nd, etc.) for the labels because that is how police precinct numbers are usually expressed in New York City. That does not mean that we should always wrap map labels in the `ordinal()` function. How we present map labels -- and every other type of information on a map -- depends on what is best for the audience we are making the map for.

There are many other functions in the scales package that format numbers in different ways, including `comma()` to add thousands separators to numbers and `dollar()` to format numbers as values in dollars or other currencies. There is a [full list of scales functions on the package website](https://scales.r-lib.org/reference/).

We now have a basic map of shootings in the Bronx. This map isn't good enough on its own, but we can use it to learn how to add supporting elements to a map.

<a id="sec-map-colour"></a>
<a id="using-colour-to-show-density"></a>

## 7.6 Using colour to show density

In [Chapter 6](../06_mapping_crime_patterns/index.llms.md) we learned how to use functions from the sfhotspot package to create a kernel density layer using `hotspot_kde()` and influence its appearance, for example using `hotspot_grid()` to control the grid, `hotspot_isoband()` to calculate isobands and `hotspot_clip()` to clip the result to a specific area.

The final way we can control the appearance of our density layer is to change the colour scheme used to represent density. To do this, we can use another type of function from the ggplot2 package: *scales*. Functions in the `scale_*()` family of functions allow us to control how the mapping between a column in the data and an aesthetic (colour, size, etc.) is represented visually. For example, which colour scheme is used to represent the density of thefts on our map.

By default, `hotspot_map()` uses a sequential blue colour scheme to represent density, but we can change this to any other colour scheme we like. There are many `scale_*()` functions, but the `scale_fill_distiller()` function produces several different colour scales that are specifically designed to be effective on maps.

Colour schemes can be divided into three types:

- *sequential* colour schemes are useful for showing values that vary from low to high,
- *diverging* colour schemes are useful for showing values relative to a meaningful central point, and
- *qualitative* colour schemes are useful for showing separate categories that can appear in any order and still be meaningful.

In crime mapping we're usually interested in showing how crime varies from low to high, so we need to use a *sequential* colour palette. There are 18 colour-blind-friendly sequential colour schemes (or *palettes*) available in `scale_fill_distiller()`, each with a name:

<figure>
<p>Figure: Eighteen labelled sequential colour palettes arranged left to right in four rows, each progressing from pale shades on the left to dark shades on the right. Row one: Blues, BuGn, BuPu, GnBu, Greens. Row two: Greys, Oranges, OrRd, PuBu, PuBuGn. Row three: PuRd, Purples, RdPu, Reds, YlGn. Row four: YlGnBu, YlOrBr, YlOrRd. Some strips use a single hue and others change hue as they darken. In the names, Bu means blue, Gn green, Pu purple, Or orange, Rd red and Yl yellow. For example, YlGnBu progresses from pale yellow through green to dark blue, Blues stays within blue shades, and Greys progresses from pale grey to black. These strips show colour order; the map scale settings determine which end represents higher values.</p>
</figure>

ImportantChoosing the right type of colour scale

It is important to **only use the right type of colour scale in the right circumstances**, since using the wrong type of scale could end up misleading people reading your map. For example, a diverging colour scale gives the strong impression that the central point in the scale is meaningful.

In some circumstances this might be useful, for example if you wanted to show areas in which crime had increased in shades of one colour and areas in which crime had decreased in shades of another colour. In that case, a diverging scale would be appropriate because the central point represents something meaningful: no change in crime. If the central point is not meaningful, use a sequential colour scheme instead.

If you want to represent a categorical variable, you should use a categorical colour scale unless the categories have a natural order. For example, if you wanted to show ethnic groups on a map you would use a categorical colour scale, since there is no one order of ethnic groups that is any more meaningful than any other. If you wanted to represent days of the week with colour, then you might want to use a sequential colour scheme since the days of the week have a meaningful order.

By default, `scale_fill_distiller()` sets the *lowest* values to have the darkest colour. This does not work well for density maps, since most people tend to interpret sequential colour schemes as if the palest or least-saturated colours represent the lowest values and the darkest or most-saturated colours represent the highest values. If we design maps that meet that expectation, people will generally find them easier to interpret. Fortunately we can do that by setting the argument `direction = 1`.

<a id="map-bronx-shootings-colour-direction"></a>

<figure>
<figure>
<p>Figure: Two side-by-side density maps of Bronx shootings compare the same data with opposite blue scale directions. On the left, minus one makes low-density areas dark and hotspots pale; on the right, one makes hotspots dark and low-density areas pale. The south-west concentration is easier to recognise with the conventional darker-means-higher direction.</p>
</figure>
<figcaption>Map 7.3</figcaption>
</figure>

You can think of all the functions that we can add to `hotspot_map()` as being like a stack of pancakes, with each new function being placed on the top of the stack. To change the colour of our map, we just add `scale_fill_distiller()` to the existing stack. Run this code in the R Console:

<a id="lst-map-context-map-exercise8"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Plot density map</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>shootings_map <span class="sc">+</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">scale_fill_distiller</span>(<span class="at">palette =</span> <span class="st">&quot;Oranges&quot;</span>, <span class="at">direction =</span> <span class="dv">1</span>)</span></code></pre></div>
<figcaption>Code 7.3</figcaption>
</figure>

<a id="map-bronx-shooting-density-orange"></a>

<figure>
<pre><code>Scale for fill is already present.
Adding another scale for fill, which will replace the existing scale.</code></pre>
<figure>
<p>Figure: Density map of recorded shootings in the Bronx in 2019. Darker orange indicates higher estimated density, concentrated in the south-west; the eastern precincts are mostly pale. Precinct boundaries and numbers locate the shaded concentrations on a pale street map. The legend still uses numeric density values.</p>
</figure>
<figcaption>Map 7.4</figcaption>
</figure>

You'll note that when we add `scale_fill_distiller()` to an existing map created by `hotspot_map()`, R prints a message saying `Scale for fill is already present` because we are replacing the scale automatically chosen by `hotspot_map()` with the scale we have specified. As long as you have deliberately chosen to replace the default scale, it's safe to ignore this message.

You might also notice that the legend on [Map 7.4](#map-bronx-shooting-density-orange) is different, in that the legend now includes raw KDE values. Most of the people viewing crime maps will not be able to interpret raw KDE values, so it's usually better to replace these. We can do this using the `breaks` and `labels` arguments to `scale_fill_distiller()`. The `breaks` argument specifies the values at which we want to place labels on the colour bar, while the `labels` argument specifies what those labels should say. It's important to make sure the number of values we supply to the `breaks` argument is the same as the number of labels we've given to the `labels` argument (otherwise R will produce an error).

In this case, we want to add two labels ("higher" and "lower"), one at either end of the colour bar. We could look at the `kde` column of the `shootings_kde` object to find the minimum and maximum values, but that would introduce the risk of accidentally entering the wrong values. Instead, we can use `pull()` to extract the `kde` column from the `shootings_kde` object and then use `range()` to find its minimum and maximum values. Putting this together gives `breaks = range(pull(shootings_kde, "kde"))`. Read the code from the inside out: take the `shootings_kde` object, pull out the `kde` column, then calculate the range of values in that column.

Run this code to see how the legend labels change.

<a id="lst-map-context-draw-bronx-shooting-density-legend"></a>

<figure>
<div class="sourceCode" id="cb1"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb1-1"><a href="#cb1-1"></a><span class="co"># Plot density map</span></span>
<span id="cb1-2"><a href="#cb1-2"></a>shootings_map <span class="sc">+</span></span>
<span id="cb1-3"><a href="#cb1-3"></a>  <span class="fu">scale_fill_distiller</span>(</span>
<span id="cb1-4"><a href="#cb1-4"></a>    <span class="at">palette =</span> <span class="st">&quot;Oranges&quot;</span>,</span>
<span id="cb1-5"><a href="#cb1-5"></a>    <span class="at">direction =</span> <span class="dv">1</span>,</span>
<span id="cb1-6"><a href="#cb1-6"></a>    <span class="co"># Specify label positions as the minimum and maximum KDE values</span></span>
<span id="cb1-7"><a href="#cb1-7"></a>    <span class="at">breaks =</span> <span class="fu">range</span>(<span class="fu">pull</span>(shootings_kde, <span class="st">&quot;kde&quot;</span>)),</span>
<span id="cb1-8"><a href="#cb1-8"></a>    <span class="at">labels =</span> <span class="fu">c</span>(<span class="st">&quot;lower&quot;</span>, <span class="st">&quot;higher&quot;</span>)</span>
<span id="cb1-9"><a href="#cb1-9"></a>  )</span></code></pre></div>
<figcaption>Code 7.4</figcaption>
</figure>

<a id="map-bronx-shooting-density-legend"></a>

<figure>
<pre><code>Scale for fill is already present.
Adding another scale for fill, which will replace the existing scale.</code></pre>
<figure>
<p>Figure: Density map of recorded shootings in the Bronx in 2019. Darker orange indicates higher estimated density, concentrated in the south-west; the eastern precincts are mostly pale. Precinct boundaries and numbers locate the shaded concentrations on a pale street map. The legend endpoints are now labelled lower and higher instead of numeric values.</p>
</figure>
<figcaption>Map 7.5</figcaption>
</figure>

Changing the colour scheme of a density map is optional -- if you are happy with the default blue colour scheme, you do not need to change it. However, if you do want to change the colour scheme, it is important that you use one of the colour-blind-friendly sequential palettes, such as those available in `scale_fill_distiller()`.

<a id="sec-base-maps"></a>
<a id="base-maps"></a>

## 7.7 Base maps

The most-important layer on a map is always the data layer: the layer that shows the information about crime that we want to communicate. But a data layer on its own is often not that useful unless people using the map can show where in the world the data is located. To help with this, it is often useful to add a *base map* underneath the data layer, so that we can see where the data layer is located in the real world. For example, if we are mapping crime in a city, it is often useful to have a street map of the city underneath the crime data, so that we can see which streets and neighbourhoods are affected by crime.

`hotspot_map()` automatically adds a base map underneath the data layer we give to it, for example the density layer in [Map 7.5](#map-bronx-shooting-density-legend). It also automatically sets the data layer to be semi-transparent, so that users can see the base map underneath the data layer. However, we can customise this base map in various ways.

Base maps are composed of tiles, each showing information about a small square on the surface of the Earth. Tiles are available at many different [zoom levels](https://wiki.openstreetmap.org/wiki/Zoom_levels), from level 1 that is useful for mapping the whole world in one map, to level 20 that can be used to map a single building. We can see some of the different zoom levels available by looking at these maps, which show the same area around the UCL Jill Dando Institute with base maps at different zoom levels.

<a id="map-base-map-zoom-comparison"></a>

<figure>
<figure>
<p>Figure: Nine street maps of the same area around the UCL Jill Dando Institute at zoom levels 8 to 16. Lower zoom levels are pixelated, while higher levels show progressively more local detail.</p>
</figure>
<figcaption>Map 7.6</figcaption>
</figure>

Choosing the right zoom level is a matter of balancing the level of detail in the map and the clarity of the image. In [Map 7.6](#map-base-map-zoom-comparison), zoom levels less than 12 tend to have pixelated images because they do not contain enough detail, while zoom levels greater than 13 contain too much detail and so the information is hard to read. But if this map covered a smaller or larger area, a different zoom level might be better.

We won't normally need to worry about the zoom level of the base map, since `hotspot_map()` automatically chooses a zoom level that is appropriate for the area covered by the data layer. However, if we wanted to add more detail to the base map we could control the zoom level manually with the `basemap_zoom` argument.

`hotspot_map()` also gives us access to several different *styles* of base map. The default style (seen in [Map 7.6](#map-base-map-zoom-comparison)) is called 'osm' because it is the default style used by OpenStreetMap, the organisation that provides the map data. We can specify which style of base map we want using the `basemap_type` argument to `hotspot_map()`.

<a id="map-base-map-style-comparison"></a>

<figure>
<figure>
<p>Figure: Ten small maps compare available base-map styles, including OpenStreetMap, cycling, transport, landscape, outdoors, watercolour, light and dark designs.</p>
</figure>
<figcaption>Map 7.7</figcaption>
</figure>

One final note about base maps. You might have noticed that when we produce a map with a base map using `hotspot_map()`, some text is added to the bottom of the map saying something like:

> Map tiles ©: CARTO; data © OpenStreetMap contributors

This is called an attribution statement, and it's usually a legal requirement when using base map tiles downloaded from the internet. Fortunately, `hotspot_map()` adds this statement automatically when required.

QuizBase maps

**What is the purpose of adding a base map to a crime map in R?**

- To provide information about socio-economic conditions in different places.
- To provide context on the locations of concentrations of crime. (Correct answer)
- To stop the map from appearing too visually cluttered
- To make a map more visually attractive.

**Why might you need to be careful in choosing the right base map when creating a crime map?**

- To ensure that it does not distract from the crime data. (Correct answer)
- To fit the base map to the full extent of the dataset.
- To remove all geographic details and focus only on crime locations.
- To add unnecessary elements to the map.

<a id="sec-titles"></a>
<a id="supporting-maps-with-words"></a>

## 7.8 Supporting maps with words

<a id="sec-map-context-titles"></a>
<a id="titles"></a>

### 7.8.1 Titles

A map title is one of the most important ways to add context to a map. Titles can either be *descriptive* or *declarative*. Descriptive titles simply state what data are shown on the map. For example, we might give our map the title "Shootings in the Bronx, 2019". Declarative titles, on the other hand, state what you think the main conclusion should be that readers remember about the map. For example, we might use the title "Shootings are focused in the South Bronx".

Declarative titles are usually more useful than descriptive titles because they help the reader to interpret the map. But writing a good declarative title is harder than writing a descriptive title, because it requires you to think about what is the main point that you want to make with the map. To help you come up with a good declarative title, you might want to try several different titles so that you can choose the one that communicates your message most clearly.

We can add a title to our map using the `labs()` (short for 'labels') function from the ggplot2 package. We can use `labs()` to add labels to various different parts of a map or plot, but for now we will just use the argument `title` to set the title.

To see how this works, run [Code 7.5](#lst-map-context-add-title) in the R Console. Since we have stored the rest of the `hotspot_map()` stack in the `shootings_map` object, this code is equivalent to adding `labs()` to the end of the original stack.

<a id="lst-map-context-add-title"></a>

<figure>
<pre><code>RConsole</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>shootings_map <span class="sc">+</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>  <span class="fu">labs</span>(<span class="at">title =</span> <span class="st">&quot;Shootings are focused in the South Bronx&quot;</span>)</span></code></pre></div>
<figcaption>Code 7.5</figcaption>
</figure>

<a id="map-bronx-shootings-title"></a>

<figure>
<figure>
<p>Figure: Density map of recorded shootings in the Bronx in 2019. Darker orange indicates higher estimated density, concentrated in the south-west; the eastern precincts are mostly pale. Precinct boundaries and numbers locate the shaded concentrations on a pale street map. The added title states that shootings are focused in the South Bronx.</p>
</figure>
<figcaption>Map 7.8</figcaption>
</figure>

Sometimes our preferred title might be too long to fit on a map. In this case, we can break the title across two or more lines. We can do this manually by adding the characters `\n` (the character code for a new line) at the point where we want the text to start a new line. Alternatively, we can use the `str_wrap()` function from the stringr package to wrap the text automatically into lines of a given maximum length, specified using the `width` argument.

When you use a declarative title for your map, it is often useful to provide a *subtitle* containing descriptive information. Adding a subtitle is very easy using the `subtitle` argument to the `labs()` function.

<a id="lst-map-context-add-subtitle"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>shootings_map <span class="sc">+</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-3"><a href="#cb2-3"></a>    <span class="at">title =</span> <span class="st">&quot;Shootings are focused in the South Bronx&quot;</span>,</span>
<span id="cb2-4"><a href="#cb2-4"></a>    <span class="at">subtitle =</span> <span class="st">&quot;Fatal and non-fatal shootings recorded by NYC Police, 2019&quot;</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  )</span></code></pre></div>
<figcaption>Code 7.6</figcaption>
</figure>

<a id="map-bronx-shootings-subtitle"></a>

<figure>
<figure>
<p>Figure: Density map of recorded shootings in the Bronx in 2019. Darker orange indicates higher estimated density, concentrated in the south-west; the eastern precincts are mostly pale. Precinct boundaries and numbers locate the shaded concentrations on a pale street map. A subtitle now specifies police-recorded shootings and the year, making the title claim more precise.</p>
</figure>
<figcaption>Map 7.9</figcaption>
</figure>

<a id="sec-captions"></a>
<a id="using-captions-to-add-author-and-other-information"></a>

### 7.8.2 Using captions to add author and other information

The `title` and `subtitle` arguments to the `labs()` function add information to the top of the map. That's appropriate for information that we want to be particularly important, such as a declarative title that summarises the main point of the map. But we will often also need to add other information to that map that is important enough that we want to include it, but which we do not need to be as visually prominent. For example, we will usually want to specify who produced a particular map, what date it was produced, and where the data came from.

We could do this with the `caption` argument to the `labs()` function, which adds text *below* the map and in a smaller font size. However, `hotspot_map()` already adds a caption automatically, to fulfil the legal requirement to acknowledge the source of data used for the base map. If we used the `caption` argument of the `labs()` function, that automatically generated caption would be lost.

Instead, we can use the `caption` argument to the `hotspot_map()` function. When we do that, `hotspot_map()` will combine the caption we provide with the automatically generated caption, so that both appear below the map.

Run this code in the R Console. Note that we're going to store the result in a new object called `shootings_map_captioned` so that we can use it later.

<a id="lst-map-context-add-caption"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>shootings_map_captioned <span class="ot">&lt;-</span> <span class="fu">hotspot_map</span>(</span>
<span id="cb2-2"><a href="#cb2-2"></a>  shootings_kde,</span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>,</span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="at">caption =</span> <span class="fu">str_glue</span>(</span>
<span id="cb2-5"><a href="#cb2-5"></a>    <span class="st">&quot;Author: Joe Bloggs, Date produced: {lubridate::today()},</span><span class="sc">\n</span><span class="st">&quot;</span>,</span>
<span id="cb2-6"><a href="#cb2-6"></a>    <span class="st">&quot;Data: NYC Open Data, https://data.cityofnewyork.us/d/833y-fsy8&quot;</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>  )</span>
<span id="cb2-8"><a href="#cb2-8"></a>) <span class="sc">+</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="co"># Add precinct boundaries</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> precincts, <span class="at">colour =</span> <span class="st">&quot;grey33&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="co"># Add precinct labels</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="fu">geom_sf_label</span>(</span>
<span id="cb2-13"><a href="#cb2-13"></a>    <span class="fu">aes</span>(<span class="at">label =</span> scales<span class="sc">::</span><span class="fu">ordinal</span>(precinct)),</span>
<span id="cb2-14"><a href="#cb2-14"></a>    <span class="at">data =</span> precincts,</span>
<span id="cb2-15"><a href="#cb2-15"></a>    <span class="at">alpha =</span> <span class="fl">0.5</span>,</span>
<span id="cb2-16"><a href="#cb2-16"></a>    <span class="at">colour =</span> <span class="st">&quot;grey33&quot;</span>,</span>
<span id="cb2-17"><a href="#cb2-17"></a>    <span class="at">fill =</span> <span class="st">&quot;white&quot;</span>,</span>
<span id="cb2-18"><a href="#cb2-18"></a>    <span class="at">size =</span> <span class="fl">2.5</span>,</span>
<span id="cb2-19"><a href="#cb2-19"></a>    <span class="at">linewidth =</span> <span class="cn">NA</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  ) <span class="sc">+</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-22"><a href="#cb2-22"></a>    <span class="at">title =</span> <span class="st">&quot;Shootings are focused in the South Bronx&quot;</span>,</span>
<span id="cb2-23"><a href="#cb2-23"></a>    <span class="at">subtitle =</span> <span class="st">&quot;Fatal and non-fatal shootings recorded by NYC Police, 2019&quot;</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  )</span></code></pre></div>
<figcaption>Code 7.7</figcaption>
</figure>

ImportantCreate your maps using a single stack

In this chapter we will store the map we are creating in an object several times as we go through the process of explaining how to add context to a map. When you write your own code, you should not do this. Instead, you should create the map from start to finish in a single block of code. Doing that will make sure your code is easy to read and that you don't have to keep track of more objects than necessary. For an example of this, see the final section of this chapter.

The code for the caption also uses the `str_glue()` function from the `stringr` package. `str_glue()` glues together any number of character strings separated by commas -- in this case, we have split the caption into two separate character strings (on separate lines) so that the lines of code do not become too long to easily read.

`str_glue()` can also include the values of R objects and the results of R functions that are placed inside braces (`{}`). So the code `{lubridate::today()}` runs the `today()` function from the lubridate package and glues the result (the current date) into the text.

<a id="sec-map-context-changing-the-legend-title"></a>
<a id="changing-the-legend-title"></a>

### 7.8.3 Changing the legend title

Legends are important for all but the simplest crime maps because they help readers to interpret the points, lines and polygons used to represent data on a particular map. Except for point maps containing only a small number of crimes (such as the map of homicide in downtown Atlanta that we produced in [Chapter 2](../02_your_first_crime_map/index.llms.md)), crime maps will almost always need a legend to help users interpret them.

Producing a legend manually could be quite complicated, but fortunately `hotspot_map()` produces legends automatically. But we might sometimes want to change the default legend title to provide more or different information.

We can change the default legend title by once again using the `labs()` function. Since we want to change the title of the legend, you might reasonably think that we would do this using something like `labs(legend = "density")` but unfortunately that code would do nothing at all. Instead, we have to set the legend title using the aesthetic (colour, size, shape, etc.) that the legend represents. This makes it possible to specify multiple titles if there are separate legends for different layers that use different aesthetics. For example if a map used lines of different colours to show streets of different types and filled polygons to show the density of crime, it would be possible to have separate legends explaining each aesthetic. In this case, we've specified that the `kde` column in the data should control the *fill* aesthetic, so we can set the title for that legend using `fill = "title we want"`. We'll do that in the next map below.

<a id="sec-map-context-changing-the-appearance-of-titles-and-captions"></a>
<a id="changing-the-appearance-of-titles-and-captions"></a>

### 7.8.4 Changing the appearance of titles and captions

We have added a title, subtitle and caption to our map, but you might not be happy with their appearance. You might want, for example, to move the caption further down the visual hierarchy by making the text smaller and/or a lighter colour, or add some space between the subtitle and the map itself.

We can exercise almost complete control over the supporting elements of maps made with `hotspot_map()` using the `theme()` function from ggplot2.

Important`theme()` doesn't affect data elements

One important thing to remember about `theme()` is that it only controls the non-data elements of a map -- nothing you do with the `theme()` function will have any effect on the data elements of a map (in this case, the layer showing the density of shootings). To change the appearance of data layers within `hotspot_map()` maps, use the `geom_*()` and `scale_*()` families of functions as we learned in [Chapter 5](../05_your_second_crime_map/index.llms.md) and [Chapter 6](../06_mapping_crime_patterns/index.llms.md).

The `theme()` function has a lot of potential arguments. If you need help using the `theme()` function (or any function in R) you can view a manual page (including a list of arguments) for the function by:

- typing a question mark followed by the function name without parentheses (e.g. `?theme`) into the R Console;
- typing the function name without parentheses into the search box in Positron's **Help** panel; or
- clicking the function name in your R script, then pressing F1F1 on your keyboard.

Try opening the manual page for `theme()` now to see the list of possible arguments it can take. Fortunately, we will not need most of these arguments most of the time -- ggplot2 has default values built in for every value that can be changed using `theme()`, and these defaults will be reasonable in almost all cases.

To reduce the visual prominence of the map caption, we can change the value of the `plot.caption` argument to `theme()`. Since the caption is a text element (rather than a polygon, line, etc.), we can use the helper function `element_text()` to do this. [Code 7.8](#lst-map-context-format-caption) changes the colour of the caption text to grey and makes the text smaller relative to the default using the helper function `rel()` (for relative sizing) -- `0.8` means the text will be 80% as big as it would have been by default. The caption remains dark enough to read against the white background.

Let's have a look at the effect of changing the caption's appearance using `theme()`:

<a id="lst-map-context-format-caption"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>shootings_map_captioned <span class="sc">+</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>  <span class="fu">theme</span>(<span class="at">plot.caption =</span> <span class="fu">element_text</span>(<span class="at">colour =</span> <span class="st">&quot;grey45&quot;</span>, <span class="at">size =</span> <span class="fu">rel</span>(<span class="fl">0.8</span>)))</span></code></pre></div>
<figcaption>Code 7.8</figcaption>
</figure>

<a id="map-bronx-shootings-source-formatting"></a>

<figure>
<figure>
<p>Figure: Density map of recorded shootings in the Bronx in 2019. Darker orange indicates higher estimated density, concentrated in the south-west; the eastern precincts are mostly pale. Precinct boundaries and numbers locate the shaded concentrations on a pale street map. The source caption is smaller, grey and left-aligned, reducing its prominence relative to the map title.</p>
</figure>
<figcaption>Map 7.10</figcaption>
</figure>

The helper function `element_text()` has arguments to control the appearance of text in different ways. As well as `colour` (or `color`, either is fine) and `size`:

- `family` controls the font used, e.g. Times New Roman or Helvetica;
- `face` controls the style of the font, i.e. 'plain', 'italic', 'bold' or 'bold.italic';
- `hjust` controls the horizontal justification of the text, where 0 means left aligned, 0.5 means centred and 1 means right aligned;
- `vjust` controls the vertical justification;
- `angle` controls the angle (in degrees) of the text (0 means horizontal); and
- `lineheight` controls the space between lines if you have created a value that has more than one line (e.g. using `\n` or `str_wrap()`).

The `margin` argument controls the space around the text. It is easiest to specify the value of `margin` using the helper function `margin()` designed for that purpose. You specify the top, right, bottom and left margin separately in that order -- to remember the order, think '**tr**ou**bl**e'. By default, margins are specified in points (the same units that are commonly used to specify font sizes).

Now that we have finished setting the text elements for our map, we can save it as a new object that we can use as the basis for the other objects we want to add. Make sure you run [Code 7.9](#lst-map-context-store-titled-map), since the remaining examples use the object it creates.

<a id="lst-map-context-store-titled-map"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>shootings_map_titled <span class="ot">&lt;-</span> shootings_map_captioned <span class="sc">+</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-3"><a href="#cb2-3"></a>    <span class="co"># Make the plot subtitle smaller and adjust the margin around it</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>    <span class="at">plot.subtitle =</span> <span class="fu">element_text</span>(<span class="at">size =</span> <span class="fu">rel</span>(<span class="fl">0.8</span>), <span class="at">margin =</span> <span class="fu">margin</span>(<span class="dv">3</span>, <span class="dv">0</span>, <span class="dv">6</span>, <span class="dv">0</span>)),</span>
<span id="cb2-5"><a href="#cb2-5"></a>    <span class="co"># Make the map caption smaller, left-aligned and grey</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>    <span class="at">plot.caption =</span> <span class="fu">element_text</span>(<span class="at">colour =</span> <span class="st">&quot;grey45&quot;</span>, <span class="at">size =</span> <span class="fu">rel</span>(<span class="fl">0.8</span>), <span class="at">hjust =</span> <span class="dv">0</span>)</span>
<span id="cb2-7"><a href="#cb2-7"></a>  )</span></code></pre></div>
<figcaption>Code 7.9</figcaption>
</figure>

QuizTitles, subtitles and captions

**What is the main purpose of adding a title to a map in R?**

- To make the map look more professional.
- To provide a reference for the map\'s source
- To display additional geographic information
- To explain the main conclusion that the audience should draw from the map (Correct answer)

**Which R function is used to add a title to a map created with ggplot2?**

- ggtitle()
- labs() (Correct answer)
- title()
- ggmap()

**Which of the following is an example of a declarative title for a crime map?**

- Residential burglary in Philadelphia, 2024
- Philadelphia crime map
- Residential burglary in Philadelphia is concentrated in Kensington (Correct answer)
- Where residential burglaries are most concentrated in Philadelphia

**Why is it important to acknowledge the source of data used in crime maps?**

- It meets legal requirements. (Correct answer)
- It helps reduce the size of the data.
- It improves the accuracy of the map.
- It ensures the map looks visually appealing.

**What is the role of a legend on a map?**

- To display the map's title.
- To explain the meaning of different symbols or colours on the map. (Correct answer)
- To display the coordinates of map locations.
- To add grid lines to the map.

**Why might we replace raw KDE values in the legend with the labels "lower" and "higher"?**

- Raw KDE values are always incorrect.
- The labels change the density estimates.
- Labels such as lower and higher communicate the main pattern more clearly. (Correct answer)
- Every continuous legend must have exactly two labels.

<a id="sec-scale-bars"></a>
<a id="scales-and-north-arrows"></a>

## 7.9 Scales and north arrows

The final elements we can add to our map are a scale bar and a north arrow, which can both be added using functions from the `ggspatial` package. If you check the `chapter_07.R` code file, you will see that you have already loaded this package.

<a id="sec-map-context-scale-bars"></a>
<a id="scale-bars"></a>

### 7.9.1 Scale bars

To add a scale bar, we can add a call to the `annotation_scale()` function to our existing map object.

<a id="lst-map-context-add-default-scale-bar"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>shootings_map_titled <span class="sc">+</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>  <span class="co"># Add scale bar</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">annotation_scale</span>()</span></code></pre></div>
<figcaption>Code 7.10</figcaption>
</figure>

<a id="map-bronx-shootings-default-scale-bar"></a>

<figure>
<figure>
<p>Figure: Density map of recorded shootings in the Bronx in 2019. Darker orange indicates higher estimated density, concentrated in the south-west; the eastern precincts are mostly pale. Precinct boundaries and numbers locate the shaded concentrations on a pale street map. The default scale bar sits at the bottom-left over the southern concentration, partly obscuring the data.</p>
</figure>
<figcaption>Map 7.11</figcaption>
</figure>

The default scale bar is a little too visually dominant for the low place it should have in the visual hierarchy of our map, and the default placement in the bottom-left corner happens to overlap with the highest density of shootings. We can change the scale bar using arguments to the `annotation_scale()` function:

- `width_hint = 1 / 5` changes the approximate proportion of the map width across which the scale bar stretches;
- `style = "ticks"` changes the scale bar to the less visually prominent line-and-tick-marks style; and
- `location = "br"` moves the scale bar to the bottom-right corner of the map.

<a id="lst-map-context-format-scale-bar"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>shootings_map_titled <span class="sc">+</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>  <span class="co"># Add scale bar</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">annotation_scale</span>(<span class="at">width_hint =</span> <span class="dv">1</span> <span class="sc">/</span> <span class="dv">5</span>, <span class="at">style =</span> <span class="st">&quot;ticks&quot;</span>, <span class="at">location =</span> <span class="st">&quot;br&quot;</span>)</span></code></pre></div>
<figcaption>Code 7.11</figcaption>
</figure>

<a id="map-bronx-shootings-tick-scale-bar"></a>

<figure>
<figure>
<p>Figure: Density map of recorded shootings in the Bronx in 2019. Darker orange indicates higher estimated density, concentrated in the south-west; the eastern precincts are mostly pale. Precinct boundaries and numbers locate the shaded concentrations on a pale street map. A compact tick-style scale bar has moved to the bottom-right, away from the strongest concentration.</p>
</figure>
<figcaption>Map 7.12</figcaption>
</figure>

<a id="sec-north-arrows"></a>
<a id="north-arrows"></a>

### 7.9.2 North arrows

We can add a north arrow using the `annotation_north_arrow()` function. The default arrow is too obtrusive to fit its position in the visual hierarchy, so we will change its appearance using the arguments:

- `location = "tr"` to move the north arrow to the top-right corner, since we have put the scale bar in the bottom-right where the north arrow would be placed by default;
- `height = unit(1.5, "lines")` to make the arrow smaller; and
- `style = north_arrow_minimal(text_size = 8)` to use a simpler arrow and reduce the font size (measured in points) of the N symbol.

<a id="lst-map-context-add-north-arrow"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>shootings_map_titled <span class="sc">+</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>  <span class="co"># Add scale bar</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">annotation_scale</span>(<span class="at">width_hint =</span> <span class="dv">1</span> <span class="sc">/</span> <span class="dv">5</span>, <span class="at">style =</span> <span class="st">&quot;ticks&quot;</span>, <span class="at">location =</span> <span class="st">&quot;br&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="co"># Add north arrow</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="fu">annotation_north_arrow</span>(</span>
<span id="cb2-6"><a href="#cb2-6"></a>    <span class="at">location =</span> <span class="st">&quot;tr&quot;</span>,</span>
<span id="cb2-7"><a href="#cb2-7"></a>    <span class="at">height =</span> <span class="fu">unit</span>(<span class="fl">1.5</span>, <span class="st">&quot;lines&quot;</span>),</span>
<span id="cb2-8"><a href="#cb2-8"></a>    <span class="at">style =</span> <span class="fu">north_arrow_minimal</span>(<span class="at">text_size =</span> <span class="dv">8</span>)</span>
<span id="cb2-9"><a href="#cb2-9"></a>  )</span></code></pre></div>
<figcaption>Code 7.12</figcaption>
</figure>

<a id="map-bronx-shootings-north-arrow"></a>

<figure>
<figure>
<p>Figure: Density map of recorded shootings in the Bronx in 2019. Darker orange indicates higher estimated density, concentrated in the south-west; the eastern precincts are mostly pale. Precinct boundaries and numbers locate the shaded concentrations on a pale street map. A compact scale bar sits at the bottom-right and a small north arrow at the top-right.</p>
</figure>
<figcaption>Map 7.13</figcaption>
</figure>

ImportantNot all maps need north arrows

If a map is going to be used for navigation (e.g. a road map or a nautical chart), it is vital that the map includes a north arrow. But if the map is going to be used to understand concentrations of crime in an area, a north arrow is much less important.

You may choose to omit a north arrow from your crime maps. However, you *must* include one if north is not at the top of the map. People expect north to be at the top, so if your map does not follow this convention it is important to make the orientation clear.

Most of the crime maps in the rest of this book do not have north arrows, because those maps follow the convention of having north at the top of the map.

QuizScale bars and north arrows

**Which of the following is a recommended practice when adding a north arrow or scale bar to a crime map?**

- They should be placed in the centre of the map to ensure the map is balanced.
- They should be made as large as possible to dominate the map.
- They should be placed in a corner where they do not interfere with the map's data. (Correct answer)
- They should be included in every map, regardless of the map's scale or orientation.

**What is the purpose of a scale bar in a crime map?**

- To show the geographical boundaries of the map.
- To provide a reference for the actual size of features on the map. (Correct answer)
- To indicate the direction of the map.
- To highlight the most significant data points.

**When should a north arrow be included on a crime map?**

- Only when the map has multiple layers.
- Always, as it is necessary for orientation in every map.
- Only for maps showing detailed geographical features.
- When north is not at the top of the map. (Correct answer)

We will include the scale bar in the finished map because it helps readers judge distances. We will omit the north arrow because north is already at the top and this map is not intended for navigation.

We now have the complete code needed to make the full map. Copy this code into the `chapter_07.R` file, replacing the existing `hotspot_map()` stack.

<a id="lst-map-context-build-complete-map"></a>

<figure>
<pre><code>chapter_07.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Create the map</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>shootings_map <span class="ot">&lt;-</span> <span class="fu">hotspot_map</span>(</span>
<span id="cb2-3"><a href="#cb2-3"></a>  shootings_kde,</span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>,</span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="at">caption =</span> <span class="fu">str_glue</span>(</span>
<span id="cb2-6"><a href="#cb2-6"></a>    <span class="st">&quot;Author: Joe Bloggs, Date produced: {lubridate::today()},</span><span class="sc">\n</span><span class="st">&quot;</span>,</span>
<span id="cb2-7"><a href="#cb2-7"></a>    <span class="st">&quot;Data: NYC Open Data, https://data.cityofnewyork.us/d/833y-fsy8&quot;</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  )</span>
<span id="cb2-9"><a href="#cb2-9"></a>) <span class="sc">+</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="co"># Add precinct boundaries</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> precincts, <span class="at">colour =</span> <span class="st">&quot;grey33&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="co"># Add precinct labels</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">geom_sf_label</span>(</span>
<span id="cb2-14"><a href="#cb2-14"></a>    <span class="fu">aes</span>(<span class="at">label =</span> scales<span class="sc">::</span><span class="fu">ordinal</span>(precinct)),</span>
<span id="cb2-15"><a href="#cb2-15"></a>    <span class="at">data =</span> precincts,</span>
<span id="cb2-16"><a href="#cb2-16"></a>    <span class="at">alpha =</span> <span class="fl">0.5</span>,</span>
<span id="cb2-17"><a href="#cb2-17"></a>    <span class="at">colour =</span> <span class="st">&quot;grey33&quot;</span>,</span>
<span id="cb2-18"><a href="#cb2-18"></a>    <span class="at">fill =</span> <span class="st">&quot;white&quot;</span>,</span>
<span id="cb2-19"><a href="#cb2-19"></a>    <span class="at">size =</span> <span class="fl">2.5</span>,</span>
<span id="cb2-20"><a href="#cb2-20"></a>    <span class="at">linewidth =</span> <span class="cn">NA</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>  ) <span class="sc">+</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  <span class="co"># Add scale bar</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>  <span class="fu">annotation_scale</span>(<span class="at">width_hint =</span> <span class="dv">1</span> <span class="sc">/</span> <span class="dv">5</span>, <span class="at">style =</span> <span class="st">&quot;ticks&quot;</span>, <span class="at">location =</span> <span class="st">&quot;br&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-25"><a href="#cb2-25"></a>    <span class="at">title =</span> <span class="st">&quot;Shootings are focused in the South Bronx&quot;</span>,</span>
<span id="cb2-26"><a href="#cb2-26"></a>    <span class="at">subtitle =</span> <span class="st">&quot;Fatal and non-fatal shootings recorded by NYC Police, 2019&quot;</span>,</span>
<span id="cb2-27"><a href="#cb2-27"></a>    <span class="at">fill =</span> <span class="st">&quot;kernel density</span><span class="sc">\n</span><span class="st">of shootings&quot;</span></span>
<span id="cb2-28"><a href="#cb2-28"></a>  ) <span class="sc">+</span></span>
<span id="cb2-29"><a href="#cb2-29"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-30"><a href="#cb2-30"></a>    <span class="co"># Make the plot subtitle smaller and adjust the margin around it</span></span>
<span id="cb2-31"><a href="#cb2-31"></a>    <span class="at">plot.subtitle =</span> <span class="fu">element_text</span>(<span class="at">size =</span> <span class="fu">rel</span>(<span class="fl">0.8</span>), <span class="at">margin =</span> <span class="fu">margin</span>(<span class="dv">3</span>, <span class="dv">0</span>, <span class="dv">6</span>, <span class="dv">0</span>)),</span>
<span id="cb2-32"><a href="#cb2-32"></a>    <span class="co"># Make the map caption smaller, left-aligned and grey</span></span>
<span id="cb2-33"><a href="#cb2-33"></a>    <span class="at">plot.caption =</span> <span class="fu">element_text</span>(<span class="at">colour =</span> <span class="st">&quot;grey45&quot;</span>, <span class="at">size =</span> <span class="fu">rel</span>(<span class="fl">0.8</span>), <span class="at">hjust =</span> <span class="dv">0</span>)</span>
<span id="cb2-34"><a href="#cb2-34"></a>  )</span></code></pre></div>
<figcaption>Code 7.13</figcaption>
</figure>

This code looks quite complicated, but you can understand each part of it using the comments included in the code.

<a id="sec-saving-maps"></a>
<a id="saving-maps"></a>

## 7.10 Saving maps

Until now, the maps we have produced have appeared in Positron's **Plots** panel. But it is often useful to save a map as an image file so that you can share it with others or embed it into a report or presentation. You can save plots created with `hotspot_map()` using the `ggsave()` function.

`ggsave()` can create image files in many different formats, including PNG, JPEG and PDF. `ggsave()` will determine which type of file to create according to the file extension of the file name that you specify. So `ggsave("bronx_shootings_2019.pdf", plot = shootings_map)` produces a PDF file, while `ggsave("bronx_shootings_2019.jpg", plot = shootings_map)` produces a JPEG image file.

You can specify the size of the image that will be saved using the `height` and `width` arguments. Note that for historical reasons these values are in *inches* by default, but you can change this to either centimetres (using `units = "cm"`), millimetres (using `units = "mm"`) or pixels (using `units = "px"`).

To share our map with others, let's save it as a square PDF. Add this code to the end of `chapter_07.R`.

<a id="lst-map-context-save-map"></a>

<figure>
<pre><code>chapter_07.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Save the map</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="fu">ggsave</span>(</span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">here</span>(<span class="st">&quot;output&quot;</span>, <span class="st">&quot;bronx_shootings_2019.pdf&quot;</span>),</span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="at">plot =</span> shootings_map,</span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="at">width =</span> <span class="dv">210</span>,</span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="at">height =</span> <span class="dv">210</span>,</span>
<span id="cb2-7"><a href="#cb2-7"></a>  <span class="at">units =</span> <span class="st">&quot;mm&quot;</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>)</span></code></pre></div>
<figcaption>Code 7.14</figcaption>
</figure>

The `here()` function creates the path to the `output` folder inside your crime mapping workspace. You can find `bronx_shootings_2019.pdf` in Positron's **Explorer** panel and open it to check the saved map.

QuizSaving maps

**How does `ggsave()` determine the type of file to create?**

- The value of the plot argument
- The values of width and height
- The extension at the end of the file name (Correct answer)
- The name of the R script

**Why do we use `here("output", "bronx_shootings_2019.pdf")`?**

- It saves the map in the data/raw folder
- It creates a reproducible path to the project\'s output folder (Correct answer)
- It uploads the map to the internet
- It changes the map to use a geographic coordinate system

<a id="in-summary"></a>

## 7.11 In summary

In this chapter we explored how good map design begins with the map's purpose and audience. Visual hierarchy helps readers identify the main message, while supporting elements provide the context needed to interpret the map. Remember that this map shows shootings recorded by the police: patterns can also reflect reporting and recording practices, and a density map does not explain why events happened.

We have practised how to:

- make map-design decisions based on purpose and audience;
- establish a clear visual hierarchy;
- add and format titles, subtitles and source captions;
- make legends clearer and less visually dominant;
- add scale bars and north arrows when appropriate; and
- save a completed map in the `output` folder.

Your complete script should now look like this:

<a id="lst-map-context-complete-script"></a>

<figure>
<pre><code>chapter_07.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This script adds contextual elements to a density map of shootings in the</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="co"># Bronx in 2019, then saves the finished map as a PDF.</span></span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Load packages</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(ggspatial, here, httr2, sf, sfhotspot, tidyverse)</span>
<span id="cb2-6"><a href="#cb2-6"></a></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="co"># Download the raw data</span></span>
<span id="cb2-8"><a href="#cb2-8"></a><span class="fu">request</span>(</span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/bronx_shootings.csv&quot;</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;bronx_shootings.csv&quot;</span>))</span>
<span id="cb2-12"><a href="#cb2-12"></a></span>
<span id="cb2-13"><a href="#cb2-13"></a><span class="fu">request</span>(</span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/nyc_precincts.gpkg&quot;</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nyc_precincts.gpkg&quot;</span>))</span>
<span id="cb2-17"><a href="#cb2-17"></a></span>
<span id="cb2-18"><a href="#cb2-18"></a><span class="co"># Load shootings data and transform it to use an appropriate coordinate system</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>shootings <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;bronx_shootings.csv&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  <span class="fu">read_csv</span>(<span class="at">show_col_types =</span> <span class="cn">FALSE</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;longitude&quot;</span>, <span class="st">&quot;latitude&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:4326&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:6538&quot;</span>)</span>
<span id="cb2-23"><a href="#cb2-23"></a></span>
<span id="cb2-24"><a href="#cb2-24"></a><span class="co"># Load NYC police precincts data</span></span>
<span id="cb2-25"><a href="#cb2-25"></a>precincts <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nyc_precincts.gpkg&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-26"><a href="#cb2-26"></a>  <span class="fu">read_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-27"><a href="#cb2-27"></a>  janitor<span class="sc">::</span><span class="fu">clean_names</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-28"><a href="#cb2-28"></a>  <span class="co"># Filter just those precincts that are in the Bronx (40th to 52nd)</span></span>
<span id="cb2-29"><a href="#cb2-29"></a>  <span class="fu">filter</span>(precinct <span class="sc">%in%</span> <span class="dv">40</span><span class="sc">:</span><span class="dv">52</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-30"><a href="#cb2-30"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:6538&quot;</span>)</span>
<span id="cb2-31"><a href="#cb2-31"></a></span>
<span id="cb2-32"><a href="#cb2-32"></a><span class="co"># Estimate density of shootings and clip the result to the Bronx precincts</span></span>
<span id="cb2-33"><a href="#cb2-33"></a>shootings_kde <span class="ot">&lt;-</span> shootings <span class="sc">|&gt;</span></span>
<span id="cb2-34"><a href="#cb2-34"></a>  <span class="fu">hotspot_kde</span>(</span>
<span id="cb2-35"><a href="#cb2-35"></a>    <span class="at">grid =</span> <span class="fu">hotspot_grid</span>(precincts, <span class="at">cell_size =</span> <span class="dv">200</span>),</span>
<span id="cb2-36"><a href="#cb2-36"></a>    <span class="at">bandwidth_adjust =</span> <span class="fl">0.33</span>,</span>
<span id="cb2-37"><a href="#cb2-37"></a>    <span class="at">quiet =</span> <span class="cn">TRUE</span></span>
<span id="cb2-38"><a href="#cb2-38"></a>  ) <span class="sc">|&gt;</span></span>
<span id="cb2-39"><a href="#cb2-39"></a>  <span class="fu">hotspot_clip</span>(precincts, <span class="at">quiet =</span> <span class="cn">TRUE</span>)</span>
<span id="cb2-40"><a href="#cb2-40"></a></span>
<span id="cb2-41"><a href="#cb2-41"></a><span class="co"># Create the map</span></span>
<span id="cb2-42"><a href="#cb2-42"></a>shootings_map <span class="ot">&lt;-</span> <span class="fu">hotspot_map</span>(</span>
<span id="cb2-43"><a href="#cb2-43"></a>  shootings_kde,</span>
<span id="cb2-44"><a href="#cb2-44"></a>  <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>,</span>
<span id="cb2-45"><a href="#cb2-45"></a>  <span class="at">caption =</span> <span class="fu">str_glue</span>(</span>
<span id="cb2-46"><a href="#cb2-46"></a>    <span class="st">&quot;Author: Joe Bloggs, Date produced: {lubridate::today()},</span><span class="sc">\n</span><span class="st">&quot;</span>,</span>
<span id="cb2-47"><a href="#cb2-47"></a>    <span class="st">&quot;Data: NYC Open Data, https://data.cityofnewyork.us/d/833y-fsy8&quot;</span></span>
<span id="cb2-48"><a href="#cb2-48"></a>  )</span>
<span id="cb2-49"><a href="#cb2-49"></a>) <span class="sc">+</span></span>
<span id="cb2-50"><a href="#cb2-50"></a>  <span class="co"># Add precinct boundaries</span></span>
<span id="cb2-51"><a href="#cb2-51"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> precincts, <span class="at">colour =</span> <span class="st">&quot;grey33&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-52"><a href="#cb2-52"></a>  <span class="co"># Add precinct labels</span></span>
<span id="cb2-53"><a href="#cb2-53"></a>  <span class="fu">geom_sf_label</span>(</span>
<span id="cb2-54"><a href="#cb2-54"></a>    <span class="fu">aes</span>(<span class="at">label =</span> scales<span class="sc">::</span><span class="fu">ordinal</span>(precinct)),</span>
<span id="cb2-55"><a href="#cb2-55"></a>    <span class="at">data =</span> precincts,</span>
<span id="cb2-56"><a href="#cb2-56"></a>    <span class="at">alpha =</span> <span class="fl">0.5</span>,</span>
<span id="cb2-57"><a href="#cb2-57"></a>    <span class="at">colour =</span> <span class="st">&quot;grey33&quot;</span>,</span>
<span id="cb2-58"><a href="#cb2-58"></a>    <span class="at">fill =</span> <span class="st">&quot;white&quot;</span>,</span>
<span id="cb2-59"><a href="#cb2-59"></a>    <span class="at">size =</span> <span class="fl">2.5</span>,</span>
<span id="cb2-60"><a href="#cb2-60"></a>    <span class="at">linewidth =</span> <span class="cn">NA</span></span>
<span id="cb2-61"><a href="#cb2-61"></a>  ) <span class="sc">+</span></span>
<span id="cb2-62"><a href="#cb2-62"></a>  <span class="co"># Add scale bar</span></span>
<span id="cb2-63"><a href="#cb2-63"></a>  <span class="fu">annotation_scale</span>(<span class="at">width_hint =</span> <span class="dv">1</span> <span class="sc">/</span> <span class="dv">5</span>, <span class="at">style =</span> <span class="st">&quot;ticks&quot;</span>, <span class="at">location =</span> <span class="st">&quot;br&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-64"><a href="#cb2-64"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-65"><a href="#cb2-65"></a>    <span class="at">title =</span> <span class="st">&quot;Shootings are focused in the South Bronx&quot;</span>,</span>
<span id="cb2-66"><a href="#cb2-66"></a>    <span class="at">subtitle =</span> <span class="st">&quot;Fatal and non-fatal shootings recorded by NYC Police, 2019&quot;</span>,</span>
<span id="cb2-67"><a href="#cb2-67"></a>    <span class="at">fill =</span> <span class="st">&quot;kernel density</span><span class="sc">\n</span><span class="st">of shootings&quot;</span></span>
<span id="cb2-68"><a href="#cb2-68"></a>  ) <span class="sc">+</span></span>
<span id="cb2-69"><a href="#cb2-69"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-70"><a href="#cb2-70"></a>    <span class="co"># Make the plot subtitle smaller and adjust the margin around it</span></span>
<span id="cb2-71"><a href="#cb2-71"></a>    <span class="at">plot.subtitle =</span> <span class="fu">element_text</span>(<span class="at">size =</span> <span class="fu">rel</span>(<span class="fl">0.8</span>), <span class="at">margin =</span> <span class="fu">margin</span>(<span class="dv">3</span>, <span class="dv">0</span>, <span class="dv">6</span>, <span class="dv">0</span>)),</span>
<span id="cb2-72"><a href="#cb2-72"></a>    <span class="co"># Make the map caption smaller, left-aligned and grey</span></span>
<span id="cb2-73"><a href="#cb2-73"></a>    <span class="at">plot.caption =</span> <span class="fu">element_text</span>(<span class="at">colour =</span> <span class="st">&quot;grey45&quot;</span>, <span class="at">size =</span> <span class="fu">rel</span>(<span class="fl">0.8</span>), <span class="at">hjust =</span> <span class="dv">0</span>)</span>
<span id="cb2-74"><a href="#cb2-74"></a>  )</span>
<span id="cb2-75"><a href="#cb2-75"></a></span>
<span id="cb2-76"><a href="#cb2-76"></a><span class="co"># Save the map</span></span>
<span id="cb2-77"><a href="#cb2-77"></a></span>
<span id="cb2-78"><a href="#cb2-78"></a><span class="fu">ggsave</span>(</span>
<span id="cb2-79"><a href="#cb2-79"></a>  <span class="fu">here</span>(<span class="st">&quot;output&quot;</span>, <span class="st">&quot;bronx_shootings_2019.pdf&quot;</span>),</span>
<span id="cb2-80"><a href="#cb2-80"></a>  <span class="at">plot =</span> shootings_map,</span>
<span id="cb2-81"><a href="#cb2-81"></a>  <span class="at">width =</span> <span class="dv">210</span>,</span>
<span id="cb2-82"><a href="#cb2-82"></a>  <span class="at">height =</span> <span class="dv">210</span>,</span>
<span id="cb2-83"><a href="#cb2-83"></a>  <span class="at">units =</span> <span class="st">&quot;mm&quot;</span></span>
<span id="cb2-84"><a href="#cb2-84"></a>)</span></code></pre></div>
<figcaption>Code 7.15</figcaption>
</figure>

The script is in a logical order: it loads packages, downloads and prepares the data, estimates and clips density, creates the map, then saves the output. It includes the permanent code needed to repeat the analysis from the beginning.

Save `chapter_07.R` by pressing .

To check that the analysis is reproducible, restart R using the **Restart R** (**⟳**) button in Positron's **Console** panel, then run the script from beginning to end.

Keep the script in the `R` folder, the downloaded source files in `data/raw` and the finished map in `output`.

**We've now reached the end of the journey we started in [Chapter 3](../03_data_wrangling/index.llms.md) of learning all the skills needed to produce a good map of where a type of crime is concentrated.** We have practised how to:

- load data from a variety of sources, select columns and filter rows ([Chapter 3](../03_data_wrangling/index.llms.md));
- create new columns in datasets, change existing columns and summarise groups of rows ([Chapter 4](../04_transforming_data/index.llms.md));
- convert data to objects that can be used for mapping and use those objects to make a map ([Chapter 5](../05_your_second_crime_map/index.llms.md));
- estimate the density of crime in different places and show that on a map ([Chapter 6](../06_mapping_crime_patterns/index.llms.md)); and
- add context to a map using titles, legends, scale bars and north arrows (this chapter).

From this point onwards, you will need to combine most or all of these skills for almost every map that you make. To help you make sure all your maps are good maps, you can use the checklist for producing a good map in [Appendix B](../appendices/map_checklist.llms.md).

You can find out more about the topics we have covered in this chapter:

- For a short summary of research into how people read maps and what that tells us about how to design a map, see [Cartography, visual perception and cognitive psychology](https://doi.org/10.4324/9781315736822-5) by Amy Griffin.
- For a more-detailed explanation of how visual hierarchy can be applied to maps, see [Visual Hierarchy and Layout](https://gistbok-ltb.ucgis.org/current/print/concept/CV-03-007).
- For more examples of how maps can mislead, read [How to lie with maps](https://www.ft.com/content/65b5df0e-49ff-11e8-8ee8-cae73aab7ccb) by Alan Smith. UCL students can access the Financial Times through the library.

QuizRevision questions

Answer these questions to check you have understood the main points covered in this chapter. Write between 50 and 100 words to answer each question.

1.  What is visual hierarchy in mapping, and why is it important to establish one when designing a map? Provide an example of how visual hierarchy affects map readability.
2.  Why is it important to add titles, legends, and other supporting elements to a crime map? How do these elements enhance the map's usefulness and clarity?
3.  What is the difference between a descriptive and a declarative map title? Provide an example of each for a map showing crime patterns.
4.  Why is it important to acknowledge data sources and authorship on your map? How can the `caption` argument in `labs()` be used to include this information?
5.  What factors should you consider when deciding whether to include a scale bar or north arrow on your map? How do these elements contribute to the map's context?
