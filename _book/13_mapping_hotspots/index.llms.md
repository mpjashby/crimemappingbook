Source: https://books.lesscrime.info/learncrimemapping/13_mapping_hotspots/index.html

<a id="quarto-document-content"></a>
<a id="title-block-header"></a>
<a id="mapping-hotspots"></a>

# `<a id="sec-mapping-hotspots"></a>`{=html}13  Mapping hotspots

Figure: Students inspect distinct clusters of purple dots on a map.

In this chapter we will learn three techniques for better understanding hotspots of crime. We will learn what a crime hotspot is and how to use R to identify hotspots and plot them on maps. We will also learn how to better understand spatial concentrations in crime risk using dual kernel density estimation.

TipBefore you start

1.  Open Positron or -- if you already have Positron open -- start a new R session by clicking the **Restart R** (**⟳**) button in the **Console** panel. This makes sure no code you ran previously will interfere with the work you do in this chapter.
2.  Make sure you are working in the crime mapping project workspace you created in [Section 1.5](../01_getting_started/index.llms.md#sec-create-project). In the top-right corner of the Positron window, you should see a folder icon and the words `crime_mapping`. If not, click the **File** menu, then **Open Folder ...** and choose the `crime_mapping` folder.

<a id="what-is-a-hotspot"></a>

## 13.1 What is a hotspot?

Crime is heavily concentrated in several different ways. A small number of offenders commit a large proportion of crime (even though most people commit minor offences occasionally) and a small number of people are repeatedly victimised. For most types of crime, a large proportion of crime occurs in a small number of places. **A hotspot is a specific location or small area where an unusual amount of criminal activity occurs**.

Crime hotspots can occur in several different forms. Watch this video to understand why hotspots are important in understanding and responding to crime.

Media: Video explaining why crime hotspots are important [(open media)](https://www.youtube.com/embed/ug-ZhvvQjmw)

TranscriptVideo transcript: Hot Spots of Crime and Crime Prevention

<a id="callout-2"></a>

Text on screen: Vera Institute of Justice Vera Voices Podcast Series Neil A. Weiner, Research Speaker Series, presents: David Weisburd, PhD, Distinguished Professor George Mason University and Director, Institute of Criminology, The Hebrew University Hot Spots of Crime and Crime Prevention with David Weisburd, PhD, Distinguished Professor George Mason University and Director, Institute of Criminology, The Hebrew University Hot spots of crime are a new unit of analysis, if you like, in trying to understand crime problems and do something about them.

Most of the time criminologists or crime prevention specialists have thought about doing something about the crime problem, they focus on two units: one, either the individual. Most of what we do about the crime problem, up to now at least, has been focused on individuals; how we can stop them from recidivating. But also on large macrounits of geography, like communities or neighborhoods or beats or precincts. Hot spots of crime refers to something very different, on a much smaller microgeographic level.

A hot spot can be a single street segment. It could be a small group of street segments. But still very much smaller, in geographic terms, than traditional units of "places," if you like, that have interested criminologists or others concerned about the crime problem. The question of why they're important, one simple way of saying that, is that we looked at the distribution of crime across geography. We've found that crime is extraordinarily concentrated at small, microgeographic hot spots.

For example, in Seattle, Washington, over a 14-year period, for every year, 50 percent of the crime is found at less than 5 percent of the street segments in the city. These findings have been replicated in a whole series of studies. Crime is very concentrated at place. Also in Seattle, 86 street segments out of almost 30,000 have about a third of all juvenile crime incidents. Well, this concentration of crime at these hot spots presents a great advantage.

We can deal with a lot of crime by dealing with a relatively few places in the city. The question of why we should put more emphasis on crime hot spots has to do, in part, with the issue of concentration that I noted already. If a lot of crime is concentrated at a very small group of places, we can have a big effect on the crime problem by concentrating on those places. But it's not just that crime is concentrated at a small number of places.

When we look at the data, we find that crime is relatively stable over time at those places. Now, compare that to individual offending, where we know that people start out in their mid-teens and late teens, committing crimes, then they go to relatively large rates of criminal activity in their early 20s. And then they start to age out of crime. So, crime is relatively unstable across the life course for individuals. We've looked at 14 years of data in Seattle, and what we've found is that 1 percent of the street segments produce about 23 percent of the crime, and they stay hot throughout that period.

So, they're chronic hot spots. They're stable. Now, I should note as well that these hot spots have characteristics that make them hot. There are reasons why crime comes to those places. Sometimes it's because it's a place where they; with a train stop or a bus stop or other places where people are getting on and off with lots of victims around. We've found that, for example, where there are large groups of employees on a block there tends to be more crime.

Well, that also means we have a sense of why crime is occurring there, but we can also try to develop strategies to do something about it. There is a series of studies, many of them randomized experiments, that show that if the police focus on crime hot spots, that crime will go down in those places. Now, the simplest response to that is often, "Well, they might go down there, but won't you just push crime around the corner?" Well, interestingly enough, the evidence we have says that's not gonna happen.

At least, you're not gonna have enough crime pushed around the corner to make the crime prevention efforts carried out at those places not worthwhile. In that group of studies that we know of, in which police have concentrated on crime hot spots, we found not only that crime goes down at the hot spots, but when the crime does change in the areas immediately surrounding, it doesn't go up. It goes down. In other words, you don't have displacement of crime; you have what we call a diffusion of crime control benefits.

In other words, if you crack down on hot spots, more likely than not, the areas around the hot spots will get better. Well, if that's the case, then certainly hot spots policing makes very good sense. This is a strategy that can work, and can work without displacement. And that's why the National Academy of Sciences, in their report on police practices and policies, concluded that the strongest evidence we have about effective policing is about hot spots policing.

Up till now, most of the approaches that we've brought against hot spots have been law enforcement approaches in which the police and police strategies have predominated. But work we've been doing suggests that maybe we ought to think a bit more broadly. We've looked at the causes of criminal activity at these hot spots. We often find that there are, let's call them social causes. Or, at least they're causes that can be addressed not only by the police and; but also by other criminal justice agencies and, perhaps, non-criminal justice agencies.

We've found that social characteristics of places (poverty, elements of young people hanging out in the streets, etcetera) that those have a strong effect on whether a place is a crime hot spot. I think we might want to think in the long term about how we can change these small places so that the social features are less conducive to crime, including poverty, including family issues, children, etcetera. I would say that the importance of this, and the importance of hot spots here, is that, for the most part, crime prevention specialists have said, "We can't do something about poverty in the whole city.

We can't change the nature of juvenile activities in the whole city." But you know what? If there's a relatively small group of places that are hot spots, maybe we can change those places. And maybe by changing those places, we can do something about the crime problem. And if we take those kinds of approaches, by the way, we'll also do something else very important. We imprison an enormous number of people in the United States.

Imprisonment comes from law enforcement. When the police are around, one of the things they might do is arrest people. They have a tendency towards law enforcement. With that in mind, to the extent that we can deal with these hot spots without law enforcement, we can get crime prevention benefits without the disabilities or the problems associated with arrest and imprisonment. Vera Institute of Justice, Vera Voices Podcast Series Neil A. Weiner, Research Speaker Series, presents: David Weisburd, PhD, Distinguished Professor George Mason University and Director, Institute of Criminology, The Hebrew University www.vera.org, Research Department, www.vera.org/research

Some places are *chronic* hotspots -- they have more crime than surrounding areas over a sustained period (which may appear to be permanent). Chronic hotspots are often generated by a facility that draws vulnerable people into an area, such as a tourist attraction that draws crowds of people who are vulnerable to pickpocketing. Other places are *acute* hotspots, in which crime increases in a place that previously experienced no or few crimes. This may be the result of some change in the environment or how it's managed, such as new management that ignores drug dealing at a bar that the previous owners would have not tolerated.

When analysing hotspots, it is best to focus on *small* areas such as an apartment block, a shopping centre, a park or a single street. Focusing on smaller areas is important because resources to respond to crime are almost always limited, so it is important that those resources are directed where the problem is worst.

Analysing larger areas, such as a neighbourhood or a police sector, is much more difficult because larger areas are always made up of many smaller areas, each of which might be quite different from one another. This means that the factors causing one street to be a hotspot might be quite different from the factors that make another street in the same district into a hotspot. Conflating different problems with different causes makes it much harder to find effective ways to reduce crime in any one place.

These difficulties can be avoided (at least partly) by keeping hotspots small: in an urban area, a useful rule of thumb is that you should be able to stand in the middle of a hotspot and see the whole hotspot area.

Being able to identify hotspots using crime mapping is important because it forms a vital first step in many place-focused responses to crime. As an example of this, watch this video about how police in Philadelphia worked with researchers to use crime mapping to identify where to deploy foot patrols to reduce crime.

Media: Video explaining how hotspot mapping was used to plan police foot patrols in Philadelphia [(open media)](https://www.youtube.com/embed/0NUQsK0vnnM)

TranscriptVideo transcript: Philadelphia Foot Patrol Experiment

<a id="callout-3"></a>

\[Music\] I came on at a period of time when foot patrol was a big part of what we did as cops I'm going back over 45 years now well we got highly motorized and we were reactive and moving from 911 call to 911 call foot patrol became something was pretty much limited to commercial corridors in many cities if they had foot patrol at all I think if you talk to some of my colleagues at this level I was the one who introduced the idea and one of whom Deputy bethl who

will tell you he was very reluctant I didn't think it was going to work you know uh you know I knew commissioner Ramy was making that part of a strategy uh had no experience other than putting my foot beads in my business Carters uh actually immersing them in the neighborhood I just didn't think it was the best strategy at the time now the first time we did it uh we didn't have Temple involved in it we just kind of put it out there and we did

it my sense was that foot patrol was an effective strategy not just the feel-good strategy but how do you really know so the next year when we decided to do it that's when we got Temple involved to actually take a look at areas of the city small areas of the city where crime was occurring in open space with a large class graduating from the police academy we had the opportunity to conduct a city-wide evaluation for the police department we designed the Philadelphia foot patrol experiment as a randomized

controlled field experiment we used crime mapping techniques to identify the top 1% of violent crime intersections in the city this map was provided to the police department who drew small concise foot beats around the main areas where they wanted to Target from these 120 areas we randomly selected 60 to be the places where we would place the foot beats for the summer and these aren't commercial corridors I mean these are little neighborhoods these are places where we've got you drug trafficking other types of disorder just crime that occurs

in public space could be theft forato what have you the other 60 we didn't take away resources we just didn't add any resources so we responded to the crime like we always responded to the crime \[Music\] it yielded results that I never expected even in my wild the streams after 3 months violent crime was 23% lower in the foot patrol sites compared to the equivalent control locations there was also a reduction in vehicle crime the commanders who initially were naysayers some of whom wanted know parts of it you

started to see that change where subsequent to that first year and they saw the results they they started to see them on their own districtwide level and the impact that the footbeats had particularly when we reduced them to manageable sizes man I got to tell you it was a good feeling to see them clamoring for future foot beats and not wanting to give them \[Music\] up but when you're out there on foot and you're walking and you're interacting and you see two people sitting on the

porch and you're able to stop and actually have a conversation when you see kids that uh live in that neighborhood and you know the good kids from the ones that tend to get in trouble you know who they are these are relationships and connections that you just simply don't get when you're driving 40 m an hour down the street what I will find that many of my commanders will say when they get those foot beats they really really are prepared um though they have some issues to catch up with because they

have not been in the car those easy getting them in the car running from job to job man that that that part is the easier part but they've walked those blocks in some of the toughest neighborhoods and they've got to know residents in those tough neighborhoods and they start to realize whoa these are they're good people on these \[Music\] blocks \[Music\] once you partner with a university it's one thing like the commissioner always says to to believe that you're doing something effective it's another thing when you research proves it and it makes

you really feel good about not only your tactics but the fact that you're on the right track and that you're you're developing something meaningful well I think evidence-based policing is really the future I think it's it makes sense and I think that now having Partnerships with researchers and academics is really adding an entirely new dimension to policing it was a collaboration from the very beginning you know it was everybody checked their Eagles at the door and we all wanted the same things um and so I

think it was probably one of the one of the most uh one of the best projects I've been involved with in my \[Music\] career \[Music\] oh

In this chapter we will learn how to make maps that could be useful in identifying and responding to hotspots of crime. Among other maps, we will create this map showing hotspots of robbery in Nottingham, England.

<a id="map-nottingham-robbery-introduction"></a>

<figure>
<p>Figure: Map of statistically significant robbery hotspots in Nottingham in 2022. Only cells with more robberies than expected by chance are coloured; darker blue-purple cells have higher estimated robbery density. The largest and darkest concentration is near the city centre, with smaller scattered groups to the north and south. Ward boundaries and a pale street map provide context.</p>
<figcaption>Map 13.1</figcaption>
</figure>

In this chapter, we will learn how to:

- understand what crime hotspots are and why analysts usually study them at small geographic scales;
- distinguish crime density from crime risk;
- identify a suitable population at risk for a particular type of crime;
- estimate and map crime risk using dual kernel density estimation;
- distinguish apparent concentrations from statistically significant hotspots; and
- identify and map significant spatial clusters using the Getis-Ord Gi\* statistic.

You will complete two analyses in this chapter. Save the dual-KDE analysis in `chapter_13a.R` and the Gi\* analysis in `chapter_13b.R`, both inside the `R` folder of the workspace you created in [Section 1.5](../01_getting_started/index.llms.md#sec-create-project). Remember to run each block of code that you add to a script by pressing .

QuizCrime hotspots

**Which one of these statements is true?**

- Crime is extremely geographically concentrated -- we can expect half of crime to be concentrated in about 1% of micro places
- Crime is very geographically concentrated -- we can expect half of crime to be concentrated in about 5% of micro places (Correct answer)
- Crime is slightly geographically concentrated -- we can expect half of crime to be concentrated in about one quarter of micro places
- Crime is usually not geographically concentrated at micro places

<a id="showing-the-density-of-risk"></a>

## 13.2 Showing the density of risk

In [Chapter 9](../09_mapping_areas/index.llms.md) we learned how to produce maps showing the *incidence rate* of crime by dividing the number of crimes by a measure of the population at risk of being targeted. We will often only have population estimates for areas, such as census estimates of the number of people living in an area. But for some crimes we have access to estimates of the people (or, more often, objects) at risk of being a target of a particular crime. In these cases, we can produce better maps of the risk of crime in different areas by producing a *dual KDE* map that shows the density of crime *risk* in different places.

To create a dual KDE map, we must estimate the density of crime and compare it to an estimate the density of the population at risk. Since an incidence rate is calculated as the number of crimes divided by the number of people or objects at risk, we can calculate the density of risk by dividing the density of crime estimated for each cell in the grid by the density of population estimated for the same cell. The `hotspot_dual_kde()` function from the sfhotspot package does this for us.

To illustrate making a dual KDE map, we will use reports of burglaries in three wards in Nottingham in 2020. Since the essential element of the crime of burglary in England is that an offender enters a *building* as a trespasser in order to steal something, the best measure of the population at risk of burglary is the number of *buildings* in each area (the definition of burglary is more complicated than this, but we don't need to worry about that here).

TipWhat's the difference between theft, burglary and robbery?

<a id="callout-5"></a>

Definitions of crime vary between countries. But theft (sometimes called *larceny*) is usually defined as the act of dishonestly taking property belonging to another person while intending to keep (not just borrow) the property or treat it as the offender's own. Shoplifting, bike theft, car theft and pickpocketing are all types of theft.

Burglary and robbery are both special types of theft. A burglary is a theft committed inside a building that the offender does not have the owner's permission to be in. The most obvious type of burglary is when an offender breaks into a victim's home and steals valuables from inside. But burglary can also be committed in non-residential buildings: some types of business are frequent targets of burglary.

A robbery is a theft in which the offender uses violence or the threat of violence against the victim. It is important to remember that burglary and robbery are separate crimes. Since robbery requires (the threat of) violence against a person, robbery risk is usually described in terms of the number of robberies for a certain number of *people*. Burglary, on the other hand, can only take place in a building, so burglary risk is usually described in terms of the number of burglaries for a certain number of *premises*.

Burglary is a good example of why the routine activities approach to thinking about crime that we introduced in [Chapter 1](../01_getting_started/index.llms.md) emphasises thinking about *targets* of crime rather than focusing only on crime *victims*. In the case of burglary, one person might be the owner of a large number of buildings (e.g. a farm with lots of out-buildings) or lots of people might own a single building (such as a house converted into flats). By thinking about the targets that are attacked by offenders, we can identify that burglary rates should be calculated based on buildings rather than, for example, residential population. Note that if our crime data only included *residential* burglaries then we would want to use *residential* buildings as our denominator, but in this case we have data for all burglaries, both residential and non-residential.

<a id="sec-mapping-hotspots-data-wrangling"></a>
<a id="data-wrangling"></a>

### 13.2.1 Data wrangling

Before we can create our dual KDE layer, we have to complete some data wrangling. We will extract the boundaries for the wards of interest from a dataset of boundaries for all wards in Nottingham using `filter()` as we have done previously. To extract only the burglaries occurring in those three wards from a dataset of all burglaries in Nottingham, we will use `hotspot_clip()`. We will also transform both datasets to use the British National Grid (EPSG:27700), a projected CRS whose coordinates are measured in metres. Using a projected CRS makes it easy to specify a grid-cell size in metres. See [Section 6.2.1](../06_mapping_crime_patterns/index.llms.md#sec-choosing-projected-crs) for how to choose an appropriate projected CRS.

Open `chapter_13a.R` in the `R` folder of your `crime_mapping` workspace. Add this code to download the original datasets into `data/raw`, load the local copies and prepare them for analysis.

<a id="lst-mapping-hotspots-script-13a-prepare"></a>

<figure>
<pre><code>chapter_13a.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This script produces a dual kernel-density map of burglary risk in three</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="co"># wards in Nottingham, England</span></span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Load packages</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, httr2, osmdata, sf, sfhotspot, tidyverse)</span>
<span id="cb2-6"><a href="#cb2-6"></a></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="co"># LOAD DATA --------------------------------------------------------------------</span></span>
<span id="cb2-8"><a href="#cb2-8"></a></span>
<span id="cb2-9"><a href="#cb2-9"></a><span class="co"># Download the original data</span></span>
<span id="cb2-10"><a href="#cb2-10"></a><span class="fu">request</span>(</span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/nottingham_wards.gpkg&quot;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_wards.gpkg&quot;</span>))</span>
<span id="cb2-14"><a href="#cb2-14"></a></span>
<span id="cb2-15"><a href="#cb2-15"></a><span class="fu">request</span>(</span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/nottingham_burglary.csv.gz&quot;</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_burglary.csv.gz&quot;</span>))</span>
<span id="cb2-19"><a href="#cb2-19"></a></span>
<span id="cb2-20"><a href="#cb2-20"></a><span class="co"># Load dataset of wards in Nottingham and choose the ones we want</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>wards <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_wards.gpkg&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  <span class="fu">read_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:27700&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  <span class="fu">filter</span>(ward_name <span class="sc">%in%</span> <span class="fu">c</span>(<span class="st">&quot;Castle&quot;</span>, <span class="st">&quot;Lenton &amp; Wollaton East&quot;</span>, <span class="st">&quot;Meadows&quot;</span>))</span>
<span id="cb2-25"><a href="#cb2-25"></a></span>
<span id="cb2-26"><a href="#cb2-26"></a><span class="co"># Load dataset of burglaries and keep only those in the wards of interest</span></span>
<span id="cb2-27"><a href="#cb2-27"></a>burglaries <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_burglary.csv.gz&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-28"><a href="#cb2-28"></a>  <span class="fu">read_csv</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-29"><a href="#cb2-29"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;longitude&quot;</span>, <span class="st">&quot;latitude&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:4326&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-30"><a href="#cb2-30"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:27700&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-31"><a href="#cb2-31"></a>  <span class="fu">hotspot_clip</span>(wards)</span></code></pre></div>
<figcaption>Code 13.1</figcaption>
</figure>

We do not have a source of open data for all the buildings in Nottingham, so we will use the osmdata package to get the locations of buildings from OpenStreetMap (OSM). You may remember from [Chapter 12](../12_place_data/index.llms.md) that to do this we need to know which key (and possibly value) the OSM database uses for storing the locations of buildings. The OSM feature key for a building is 'building' and it is not necessary to specify a value (since we want to capture all types of building). The osmdata package expects data to use the WGS84 coordinate reference system, so we must also make sure any data sources we use are projected using that system (EPSG:4326).

Add this code to your R script and run it. The first time you run the code, it downloads building data from OpenStreetMap and saves a copy in `data/processed`. On later runs, it loads that saved copy so the analysis is faster and does not change if OpenStreetMap is updated.

<a id="lst-mapping-hotspots-script-13a-buildings"></a>

<figure>
<pre><code>chapter_13a.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># GET BUILDING DATA ------------------------------------------------------------</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a>buildings_file <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;processed&quot;</span>, <span class="st">&quot;nottingham_buildings.rds&quot;</span>)</span>
<span id="cb2-4"><a href="#cb2-4"></a></span>
<span id="cb2-5"><a href="#cb2-5"></a><span class="cf">if</span> (<span class="fu">file.exists</span>(buildings_file)) {</span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="co"># If buildings data has already been downloaded, load it from the saved copy</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>  nottingham_buildings <span class="ot">&lt;-</span> <span class="fu">read_rds</span>(buildings_file)</span>
<span id="cb2-8"><a href="#cb2-8"></a>} <span class="cf">else</span> {</span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="co"># If buildings data has not been downloaded, get it from OpenStreetMap and</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="co"># save a copy</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  nottingham_buildings <span class="ot">&lt;-</span> wards <span class="sc">|&gt;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>    <span class="co"># Transform ward boundaries to CRS needed by `opq()`</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>    <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:4326&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>    <span class="co"># Calculate bounding box</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>    <span class="fu">st_bbox</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>    <span class="co"># Set up OSM query</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>    <span class="fu">opq</span>(<span class="at">timeout =</span> <span class="dv">120</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>    <span class="co"># Add type of feature to fetch</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>    <span class="fu">add_osm_feature</span>(<span class="at">key =</span> <span class="st">&quot;building&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>    <span class="co"># Fetch features from OSM database</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>    <span class="fu">osmdata_sf</span>()</span>
<span id="cb2-22"><a href="#cb2-22"></a></span>
<span id="cb2-23"><a href="#cb2-23"></a>  <span class="fu">write_rds</span>(nottingham_buildings, buildings_file)</span>
<span id="cb2-24"><a href="#cb2-24"></a>}</span></code></pre></div>
<figcaption>Code 13.2</figcaption>
</figure>

TipOverpass API errors

The Overpass API used by `osmdata_sf()` is a shared online service. If you see an error such as `HTTP 429 Too Many Requests` or `HTTP 504 Gateway Timeout`, wait a few minutes and run the query again. Once the query succeeds, the saved copy means you will not need to contact the service again for this analysis.

NoteWhat does `if (file.exists(...))` do?

<a id="callout-7"></a>

Almost all programming languages have a way of only executing code in certain circumstances. This is usually in the form of an `if` statement. If the condition in the parentheses after `if` is true, the code inside the first pair of curly braces is run. If the condition in the parentheses after `if` is false, the code inside the second pair of curly braces (after the word `else`) is run.

In this case, the code in the parentheses (`file.exists(...)`) checks whether a file already exists on the computer the code is running on. If it does, the code inside the parentheses evaluates to `TRUE` and the code inside the first pair of curly braces is run to load the data in the existing file into R. If the file does not exist, the code inside the parentheses evaluates to `FALSE` and the code inside the second pair of curly braces is run to download the data from OpenStreetMap and save a copy.

There are many other ways to use `if` statements in R, but we won't need to use any of them in this book. If you are interested in learning more about `if` statements, see the [*R for Data Science*](https://r4ds.had.co.nz/flow-control.html) book by Hadley Wickham and Garrett Grolemund.

<a id="lst-mapping-hotspots-inspect-building-geometries"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>nottingham_buildings</span></code></pre></div>
<figcaption>Code 13.3</figcaption>
</figure>

    Object of class 'osmdata' with:
                     $bbox : 52.9173362670705,-1.21712477980417,52.9596833099217,-1.13020878819132
            $overpass_call : The call submitted to the overpass API
                     $meta : metadata including timestamp and version numbers
               $osm_points : 'sf' Simple Features Collection with 169510 points
                $osm_lines : 'sf' Simple Features Collection with 48 linestrings
             $osm_polygons : 'sf' Simple Features Collection with 31690 polygons
           $osm_multilines : 'sf' Simple Features Collection with 2 multilinestrings
        $osm_multipolygons : 'sf' Simple Features Collection with 73 multipolygons

Looking at the `nottingham_buildings` object, we can see that OSM contains data on buildings stored as points, polygons and multipolygons (we can ignore the few linestrings tagged as buildings, since it doesn't make sense for a building to be represented as a line rather than a point or a polygon).

TipWhat is a multipolygon?

<a id="callout-8"></a>

OpenStreetMap stores features in several different ways. The most basic types are points, lines and polygons. But there are also multipolygons (and multilines). These are features that represent complex structures such as clusters of buildings that are separate structures but are related to each other. For example, a hospital with several buildings might be represented in OpenStreetMap as a single multipolygon feature. A multipolygon might also be used to represent complex building shapes such as buildings with a courtyard or light well in the middle.

Let's create a simple map of the results produced by `osmdata_sf()`, comparing them to the buildings shown on a base map to check that OSM has reasonable coverage of the buildings in these three wards. This code uses the `pluck()` function from the purrr package (part of the tidyverse) to extract the different elements from the `nottingham_buildings` object.

<a id="lst-mapping-hotspots-draw-nottingham-building-geometries"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Initiate map and add building features stored as points</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="fu">hotspot_map</span>(</span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">pluck</span>(nottingham_buildings, <span class="st">&quot;osm_points&quot;</span>),</span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>,</span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="at">colour =</span> <span class="st">&quot;green&quot;</span>,</span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="at">size =</span> <span class="fl">0.1</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>) <span class="sc">+</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="co"># Add building features stored as polygons</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="fu">geom_sf</span>(</span>
<span id="cb2-10"><a href="#cb2-10"></a>    <span class="at">data =</span> <span class="fu">pluck</span>(nottingham_buildings, <span class="st">&quot;osm_polygons&quot;</span>),</span>
<span id="cb2-11"><a href="#cb2-11"></a>    <span class="at">colour =</span> <span class="cn">NA</span>,</span>
<span id="cb2-12"><a href="#cb2-12"></a>    <span class="at">fill =</span> <span class="st">&quot;blue&quot;</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  ) <span class="sc">+</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="co"># Add building features stored as multi-polygons</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  <span class="fu">geom_sf</span>(</span>
<span id="cb2-16"><a href="#cb2-16"></a>    <span class="at">data =</span> <span class="fu">pluck</span>(nottingham_buildings, <span class="st">&quot;osm_multipolygons&quot;</span>),</span>
<span id="cb2-17"><a href="#cb2-17"></a>    <span class="at">colour =</span> <span class="cn">NA</span>,</span>
<span id="cb2-18"><a href="#cb2-18"></a>    <span class="at">fill =</span> <span class="st">&quot;darkred&quot;</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>  ) <span class="sc">+</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  <span class="co"># Add ward boundaries so we can see how complete OSM data is within those</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>  <span class="co"># wards</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> wards, <span class="at">colour =</span> <span class="st">&quot;red&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>, <span class="at">linewidth =</span> <span class="fl">1.25</span>)</span></code></pre></div>
<figcaption>Code 13.4</figcaption>
</figure>

<a id="map-nottingham-building-geometries"></a>

<figure>
<figure>
<p>Figure: Map of buildings in three south-west Nottingham wards. Red outlines mark ward boundaries; small point symbols and blue and green building shapes compare OpenStreetMap points, polygons and multipolygons. Dense building coverage varies across the wards, illustrating why geometry types must be checked before calculating building density.</p>
</figure>
<figcaption>Map 13.2</figcaption>
</figure>

Important`osmdata_sf()` returns data for a bounding box

Remember that `osmdata_sf()` gets OSM data for the area covered by the *bounding box* of the input feature, not the feature boundaries. This means some of the buildings returned by [Code 13.2](#lst-mapping-hotspots-script-13a-buildings) will be outside the wards we are interested in. We will deal with that shortly.

It looks like almost all the streets in the three wards we are interested in are lined with buildings in the OSM data, which is what we would expect of streets in an urban area. There are some streets without buildings in the top-left of the map, but these streets are outside our three wards so this does not matter.

We can also see from this map that the 169,510 point features in the OSM data (shown as green dots on the map) typically represent the corners of buildings that are also represented as polygons, so we know we can ignore the points layer within the OSM data.

Since the `hotspot_dual_kde()` function works on points, we need to merge the polygon and multipolygon layers, then convert the combined layer to points by calculating the centroid of each building. We will transform the building data to use the British National Grid before calculating centroids. Calculating centroids in an appropriate projected coordinate system is more reliable than calculating them from longitude and latitude coordinates.

Since we are only interested in buildings in three particular wards, we can also remove any buildings outside those wards using `hotspot_clip()`. Both the building centroids and the `wards` object will use the British National Grid.

Add this code to the `chapter_13a.R` file and run it.

<a id="lst-mapping-hotspots-script-13a-centroids"></a>

<figure>
<pre><code>chapter_13a.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># WRANGLE DATA -----------------------------------------------------------------</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="co"># Extract polygon/multipolygon layers and combine them into a single object</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>nottingham_building_centroids <span class="ot">&lt;-</span> <span class="fu">bind_rows</span>(</span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="fu">pluck</span>(nottingham_buildings, <span class="st">&quot;osm_polygons&quot;</span>),</span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="fu">pluck</span>(nottingham_buildings, <span class="st">&quot;osm_multipolygons&quot;</span>)</span>
<span id="cb2-7"><a href="#cb2-7"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="co"># Transform to the same CRS as the `wards` object</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:27700&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="co"># Convert polygons to points</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="fu">st_centroid</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="co"># Remove any points outside the wards of interest</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">hotspot_clip</span>(wards)</span></code></pre></div>
<figcaption>Code 13.5</figcaption>
</figure>

    Warning: st_centroid assumes attributes are constant over geometries

    Removed 18,559 rows (58.4% of original rows) from `data`

TipWhat does the warning `st_centroid assumes …` mean?

<a id="callout-10"></a>

You might have seen a warning saying `st_centroid assumes attributes are constant over geometries of x`. You will see this warning when you use the `st_centroid()` function. It is there to remind you that columns in the original data (which the SF package refers to as the *attributes* associated with each spatial feature) refer to the polygon as a whole, but in the object produced by `st_centroid()` it will appear that the columns relate to the centroid point. In many cases this will not be a problem, but it could expose you to the ecological fallacy so it is sometimes useful to be reminded.

<a id="sec-mapping-hotspots-calculating-dual-kernel-density"></a>
<a id="calculating-dual-kernel-density"></a>

### 13.2.2 Calculating dual kernel density

We now have the object `burglaries` that contains the locations of each burglary in the three Nottingham wards that we are interested in, and the object `nottingham_building_centroids` that contains the centroids of each building in those three wards. We can use these layers to estimate the density of burglaries and buildings, then combine these to estimate the density of burglary risk.

`hotspot_dual_kde()` works in the same way as `hotspot_kde()`, except that it requires two datasets. In this case, that means one dataset of crime locations and one dataset of building locations. `hotspot_dual_kde()` will set the cell size and bandwidth automatically, but we can set them manually using the `cell_size`, `bandwidth_adjust` and `grid` arguments in the same way we have done for `hotspot_kde()`. In this case, we will use the `hotspot_grid()` helper function to create a grid based on the boundaries of the wards we are interested in. All the spatial objects we are going to use here have coordinates specified using the British National Grid because we have already transformed them, so we do not need to do any transformation here.

<a id="lst-mapping-hotspots-script-13a-density"></a>

<figure>
<pre><code>chapter_13a.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Estimate density of burglary risk</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>burglary_risk <span class="ot">&lt;-</span> <span class="fu">hotspot_dual_kde</span>(</span>
<span id="cb2-3"><a href="#cb2-3"></a>  burglaries,</span>
<span id="cb2-4"><a href="#cb2-4"></a>  nottingham_building_centroids,</span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="at">bandwidth_adjust =</span> <span class="fl">0.25</span>,</span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="at">grid =</span> <span class="fu">hotspot_grid</span>(wards, <span class="at">cell_size =</span> <span class="dv">100</span>),</span>
<span id="cb2-7"><a href="#cb2-7"></a>  <span class="at">quiet =</span> <span class="cn">TRUE</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="fu">hotspot_clip</span>(wards)</span></code></pre></div>
<figcaption>Code 13.6</figcaption>
</figure>

    Removed 100 rows (6.2% of original rows) from `data`

The `burglary_risk` object looks like this:

<a id="lst-mapping-hotspots-head-burglary-risk"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">head</span>(burglary_risk)</span></code></pre></div>
<figcaption>Code 13.7</figcaption>
</figure>

    Simple feature collection with 6 features and 2 fields
    Geometry type: POLYGON
    Dimension:     XY
    Bounding box:  xmin: 454960.4 ymin: 335859 xmax: 455261.5 ymax: 336009
    Projected CRS: OSGB36 / British National Grid
    # A tibble: 6 × 3
          n   kde                                                           geometry
      <dbl> <dbl>                                                      <POLYGON [m]>
    1     0   NaN ((455061.5 335909, 455061.5 335881.3, 455039.5 335909, 455061.5 3…
    2     0   NaN ((455061.5 335909, 455148.6 335909, 455079.1 335859, 455061.5 335…
    3     0   NaN ((454961.5 336009, 454961.5 336007.6, 454960.4 336009, 454961.5 3…
    4     0   NaN ((454961.5 336009, 455061.5 336009, 455061.5 335909, 455039.5 335…
    5     0     0 ((455061.5 336009, 455161.5 336009, 455161.5 335918.3, 455148.6 3…
    6     0     0 ((455161.5 336009, 455261.5 336009, 455261.5 335990.2, 455161.5 3…

NoteWhat does `NaN` mean?

<a id="callout-11"></a>

You might recall from [Section 13.2.2](#sec-mapping-hotspots-calculating-dual-kernel-density) that by default, the value of the `kde` column in the object produced by `hotspot_dual_kde()` is calculated by dividing the density of burglary in each grid cell by the density of buildings in the same grid cell. There are two cases where this will produce a result that is not a finite number:

- If, for a particular cell, the density of burglaries and density of buildings are both zero, dividing one by the other will produce the result `NaN`, for 'not a number'.
- If the density of burglaries is greater than zero but the density of buildings is exactly zero, the result will be `Inf`, for 'infinite'.

Fortunately, `hotspot_map()` will deal with these non-finite values, so we don't need to worry about them.

We can plot the estimate of the density of burglary risk using `hotspot_map()`. By controlling for the density of buildings, this map shows us where building owners *on average* face the highest risk of being burgled. This might be useful in working out, for example, which building owners should be offered visits from a crime-prevention advisor or funding to install crime-prevention measures.

Add this code to your script file and run it to produce a map:

<a id="lst-mapping-hotspots-script-13a-map"></a>

<figure>
<pre><code>chapter_13a.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># PLOT MAP ---------------------------------------------------------------------</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="fu">hotspot_map</span>(</span>
<span id="cb2-4"><a href="#cb2-4"></a>  burglary_risk,</span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>,</span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="at">caption =</span> <span class="fu">str_glue</span>(</span>
<span id="cb2-7"><a href="#cb2-7"></a>    <span class="st">&quot;Contains public sector information licensed under the Open &quot;</span>,</span>
<span id="cb2-8"><a href="#cb2-8"></a>    <span class="st">&quot;Government Licence v3.0&quot;</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>  )</span>
<span id="cb2-10"><a href="#cb2-10"></a>) <span class="sc">+</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="co"># Add ward boundaries</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> wards, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-14"><a href="#cb2-14"></a>    <span class="at">title =</span> <span class="st">&quot;Burglary risk in south-west Nottingham&quot;</span>,</span>
<span id="cb2-15"><a href="#cb2-15"></a>    <span class="at">subtitle =</span> <span class="fu">str_glue</span>(</span>
<span id="cb2-16"><a href="#cb2-16"></a>      <span class="st">&quot;dual kernel density of burglary risk in Castle, Lenton &amp; Wollaton &quot;</span>,</span>
<span id="cb2-17"><a href="#cb2-17"></a>      <span class="st">&quot;East and Meadows wards&quot;</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>    ),</span>
<span id="cb2-19"><a href="#cb2-19"></a>    <span class="at">fill =</span> <span class="st">&quot;density of burglary risk, 2020&quot;</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  ) <span class="sc">+</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-22"><a href="#cb2-22"></a>    <span class="at">legend.position =</span> <span class="st">&quot;bottom&quot;</span>,</span>
<span id="cb2-23"><a href="#cb2-23"></a>    <span class="at">plot.caption =</span> <span class="fu">element_text</span>(<span class="at">colour =</span> <span class="st">&quot;grey40&quot;</span>),</span>
<span id="cb2-24"><a href="#cb2-24"></a>    <span class="at">plot.subtitle =</span> <span class="fu">element_text</span>(<span class="at">margin =</span> <span class="fu">margin</span>(<span class="at">t =</span> <span class="dv">6</span>, <span class="at">b =</span> <span class="dv">6</span>)),</span>
<span id="cb2-25"><a href="#cb2-25"></a>    <span class="at">plot.title =</span> <span class="fu">element_text</span>(<span class="at">colour =</span> <span class="st">&quot;grey50&quot;</span>, <span class="at">face =</span> <span class="st">&quot;bold&quot;</span>, <span class="at">size =</span> <span class="dv">16</span>)</span>
<span id="cb2-26"><a href="#cb2-26"></a>  )</span></code></pre></div>
<figcaption>Code 13.8</figcaption>
</figure>

<a id="map-nottingham-burglary-risk"></a>

<figure>
<figure>
<p>Figure: Map of estimated burglary risk in Castle, Lenton and Wollaton East, and Meadows wards, Nottingham, in 2020. Darker blue means a higher ratio of burglary density to building density. The darkest broad patch lies in the north-east of the mapped wards, with smaller darker patches further west. Black ward outlines locate the surface.</p>
</figure>
<figcaption>Map 13.3</figcaption>
</figure>

Save `chapter_13a.R` by pressing .

To check that the analysis is reproducible, restart R using the **Restart R** (**⟳**) button in Positron's **Console** panel, then run the script from beginning to end.

Keep the script in the `R` folder, the original downloads in `data/raw` and the saved OpenStreetMap data in `data/processed`.

Your complete `chapter_13a.R` dual-KDE script should now look like this:

<a id="lst-mapping-hotspots-show-chapter-13a-script"></a>

<figure>
<pre><code>chapter_13a.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This script produces a dual kernel-density map of burglary risk in three</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="co"># wards in Nottingham, England</span></span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Load packages</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, httr2, osmdata, sf, sfhotspot, tidyverse)</span>
<span id="cb2-6"><a href="#cb2-6"></a></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="co"># LOAD DATA --------------------------------------------------------------------</span></span>
<span id="cb2-8"><a href="#cb2-8"></a></span>
<span id="cb2-9"><a href="#cb2-9"></a><span class="co"># Download the original data</span></span>
<span id="cb2-10"><a href="#cb2-10"></a><span class="fu">request</span>(</span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/nottingham_wards.gpkg&quot;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_wards.gpkg&quot;</span>))</span>
<span id="cb2-14"><a href="#cb2-14"></a></span>
<span id="cb2-15"><a href="#cb2-15"></a><span class="fu">request</span>(</span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/nottingham_burglary.csv.gz&quot;</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_burglary.csv.gz&quot;</span>))</span>
<span id="cb2-19"><a href="#cb2-19"></a></span>
<span id="cb2-20"><a href="#cb2-20"></a><span class="co"># Load dataset of wards in Nottingham and choose the ones we want</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>wards <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_wards.gpkg&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  <span class="fu">read_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:27700&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  <span class="fu">filter</span>(ward_name <span class="sc">%in%</span> <span class="fu">c</span>(<span class="st">&quot;Castle&quot;</span>, <span class="st">&quot;Lenton &amp; Wollaton East&quot;</span>, <span class="st">&quot;Meadows&quot;</span>))</span>
<span id="cb2-25"><a href="#cb2-25"></a></span>
<span id="cb2-26"><a href="#cb2-26"></a><span class="co"># Load dataset of burglaries and keep only those in the wards of interest</span></span>
<span id="cb2-27"><a href="#cb2-27"></a>burglaries <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_burglary.csv.gz&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-28"><a href="#cb2-28"></a>  <span class="fu">read_csv</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-29"><a href="#cb2-29"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;longitude&quot;</span>, <span class="st">&quot;latitude&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:4326&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-30"><a href="#cb2-30"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:27700&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-31"><a href="#cb2-31"></a>  <span class="fu">hotspot_clip</span>(wards)</span>
<span id="cb2-32"><a href="#cb2-32"></a></span>
<span id="cb2-33"><a href="#cb2-33"></a><span class="co"># GET BUILDING DATA ------------------------------------------------------------</span></span>
<span id="cb2-34"><a href="#cb2-34"></a></span>
<span id="cb2-35"><a href="#cb2-35"></a>buildings_file <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;processed&quot;</span>, <span class="st">&quot;nottingham_buildings.rds&quot;</span>)</span>
<span id="cb2-36"><a href="#cb2-36"></a></span>
<span id="cb2-37"><a href="#cb2-37"></a><span class="cf">if</span> (<span class="fu">file.exists</span>(buildings_file)) {</span>
<span id="cb2-38"><a href="#cb2-38"></a>  <span class="co"># If buildings data has already been downloaded, load it from the saved copy</span></span>
<span id="cb2-39"><a href="#cb2-39"></a>  nottingham_buildings <span class="ot">&lt;-</span> <span class="fu">read_rds</span>(buildings_file)</span>
<span id="cb2-40"><a href="#cb2-40"></a>} <span class="cf">else</span> {</span>
<span id="cb2-41"><a href="#cb2-41"></a>  <span class="co"># If buildings data has not been downloaded, get it from OpenStreetMap and</span></span>
<span id="cb2-42"><a href="#cb2-42"></a>  <span class="co"># save a copy</span></span>
<span id="cb2-43"><a href="#cb2-43"></a>  nottingham_buildings <span class="ot">&lt;-</span> wards <span class="sc">|&gt;</span></span>
<span id="cb2-44"><a href="#cb2-44"></a>    <span class="co"># Transform ward boundaries to CRS needed by `opq()`</span></span>
<span id="cb2-45"><a href="#cb2-45"></a>    <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:4326&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-46"><a href="#cb2-46"></a>    <span class="co"># Calculate bounding box</span></span>
<span id="cb2-47"><a href="#cb2-47"></a>    <span class="fu">st_bbox</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-48"><a href="#cb2-48"></a>    <span class="co"># Set up OSM query</span></span>
<span id="cb2-49"><a href="#cb2-49"></a>    <span class="fu">opq</span>(<span class="at">timeout =</span> <span class="dv">120</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-50"><a href="#cb2-50"></a>    <span class="co"># Add type of feature to fetch</span></span>
<span id="cb2-51"><a href="#cb2-51"></a>    <span class="fu">add_osm_feature</span>(<span class="at">key =</span> <span class="st">&quot;building&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-52"><a href="#cb2-52"></a>    <span class="co"># Fetch features from OSM database</span></span>
<span id="cb2-53"><a href="#cb2-53"></a>    <span class="fu">osmdata_sf</span>()</span>
<span id="cb2-54"><a href="#cb2-54"></a></span>
<span id="cb2-55"><a href="#cb2-55"></a>  <span class="fu">write_rds</span>(nottingham_buildings, buildings_file)</span>
<span id="cb2-56"><a href="#cb2-56"></a>}</span>
<span id="cb2-57"><a href="#cb2-57"></a></span>
<span id="cb2-58"><a href="#cb2-58"></a><span class="co"># WRANGLE DATA -----------------------------------------------------------------</span></span>
<span id="cb2-59"><a href="#cb2-59"></a></span>
<span id="cb2-60"><a href="#cb2-60"></a><span class="co"># Extract polygon/multipolygon layers and combine them into a single object</span></span>
<span id="cb2-61"><a href="#cb2-61"></a>nottingham_building_centroids <span class="ot">&lt;-</span> <span class="fu">bind_rows</span>(</span>
<span id="cb2-62"><a href="#cb2-62"></a>  <span class="fu">pluck</span>(nottingham_buildings, <span class="st">&quot;osm_polygons&quot;</span>),</span>
<span id="cb2-63"><a href="#cb2-63"></a>  <span class="fu">pluck</span>(nottingham_buildings, <span class="st">&quot;osm_multipolygons&quot;</span>)</span>
<span id="cb2-64"><a href="#cb2-64"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-65"><a href="#cb2-65"></a>  <span class="co"># Transform to the same CRS as the `wards` object</span></span>
<span id="cb2-66"><a href="#cb2-66"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:27700&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-67"><a href="#cb2-67"></a>  <span class="co"># Convert polygons to points</span></span>
<span id="cb2-68"><a href="#cb2-68"></a>  <span class="fu">st_centroid</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-69"><a href="#cb2-69"></a>  <span class="co"># Remove any points outside the wards of interest</span></span>
<span id="cb2-70"><a href="#cb2-70"></a>  <span class="fu">hotspot_clip</span>(wards)</span>
<span id="cb2-71"><a href="#cb2-71"></a></span>
<span id="cb2-72"><a href="#cb2-72"></a><span class="co"># Estimate density of burglary risk</span></span>
<span id="cb2-73"><a href="#cb2-73"></a>burglary_risk <span class="ot">&lt;-</span> <span class="fu">hotspot_dual_kde</span>(</span>
<span id="cb2-74"><a href="#cb2-74"></a>  burglaries,</span>
<span id="cb2-75"><a href="#cb2-75"></a>  nottingham_building_centroids,</span>
<span id="cb2-76"><a href="#cb2-76"></a>  <span class="at">bandwidth_adjust =</span> <span class="fl">0.25</span>,</span>
<span id="cb2-77"><a href="#cb2-77"></a>  <span class="at">grid =</span> <span class="fu">hotspot_grid</span>(wards, <span class="at">cell_size =</span> <span class="dv">100</span>),</span>
<span id="cb2-78"><a href="#cb2-78"></a>  <span class="at">quiet =</span> <span class="cn">TRUE</span></span>
<span id="cb2-79"><a href="#cb2-79"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-80"><a href="#cb2-80"></a>  <span class="fu">hotspot_clip</span>(wards)</span>
<span id="cb2-81"><a href="#cb2-81"></a></span>
<span id="cb2-82"><a href="#cb2-82"></a><span class="co"># PLOT MAP ---------------------------------------------------------------------</span></span>
<span id="cb2-83"><a href="#cb2-83"></a></span>
<span id="cb2-84"><a href="#cb2-84"></a><span class="fu">hotspot_map</span>(</span>
<span id="cb2-85"><a href="#cb2-85"></a>  burglary_risk,</span>
<span id="cb2-86"><a href="#cb2-86"></a>  <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>,</span>
<span id="cb2-87"><a href="#cb2-87"></a>  <span class="at">caption =</span> <span class="fu">str_glue</span>(</span>
<span id="cb2-88"><a href="#cb2-88"></a>    <span class="st">&quot;Contains public sector information licensed under the Open &quot;</span>,</span>
<span id="cb2-89"><a href="#cb2-89"></a>    <span class="st">&quot;Government Licence v3.0&quot;</span></span>
<span id="cb2-90"><a href="#cb2-90"></a>  )</span>
<span id="cb2-91"><a href="#cb2-91"></a>) <span class="sc">+</span></span>
<span id="cb2-92"><a href="#cb2-92"></a>  <span class="co"># Add ward boundaries</span></span>
<span id="cb2-93"><a href="#cb2-93"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> wards, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-94"><a href="#cb2-94"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-95"><a href="#cb2-95"></a>    <span class="at">title =</span> <span class="st">&quot;Burglary risk in south-west Nottingham&quot;</span>,</span>
<span id="cb2-96"><a href="#cb2-96"></a>    <span class="at">subtitle =</span> <span class="fu">str_glue</span>(</span>
<span id="cb2-97"><a href="#cb2-97"></a>      <span class="st">&quot;dual kernel density of burglary risk in Castle, Lenton &amp; Wollaton &quot;</span>,</span>
<span id="cb2-98"><a href="#cb2-98"></a>      <span class="st">&quot;East and Meadows wards&quot;</span></span>
<span id="cb2-99"><a href="#cb2-99"></a>    ),</span>
<span id="cb2-100"><a href="#cb2-100"></a>    <span class="at">fill =</span> <span class="st">&quot;density of burglary risk, 2020&quot;</span></span>
<span id="cb2-101"><a href="#cb2-101"></a>  ) <span class="sc">+</span></span>
<span id="cb2-102"><a href="#cb2-102"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-103"><a href="#cb2-103"></a>    <span class="at">legend.position =</span> <span class="st">&quot;bottom&quot;</span>,</span>
<span id="cb2-104"><a href="#cb2-104"></a>    <span class="at">plot.caption =</span> <span class="fu">element_text</span>(<span class="at">colour =</span> <span class="st">&quot;grey40&quot;</span>),</span>
<span id="cb2-105"><a href="#cb2-105"></a>    <span class="at">plot.subtitle =</span> <span class="fu">element_text</span>(<span class="at">margin =</span> <span class="fu">margin</span>(<span class="at">t =</span> <span class="dv">6</span>, <span class="at">b =</span> <span class="dv">6</span>)),</span>
<span id="cb2-106"><a href="#cb2-106"></a>    <span class="at">plot.title =</span> <span class="fu">element_text</span>(<span class="at">colour =</span> <span class="st">&quot;grey50&quot;</span>, <span class="at">face =</span> <span class="st">&quot;bold&quot;</span>, <span class="at">size =</span> <span class="dv">16</span>)</span>
<span id="cb2-107"><a href="#cb2-107"></a>  )</span></code></pre></div>
<figcaption>Code 13.9</figcaption>
</figure>

QuizDual kernel density

**Which *one* of these statements is true?**

- hotspot_dual_kde() can transform longitude and latitude coordinates automatically, but a suitable projected CRS makes it easier to specify distances in metres. (Correct answer)
- hotspot_dual_kde() can only work with longitude and latitude coordinates.
- hotspot_dual_kde() requires projected coordinates even when cell sizes and bandwidths are chosen automatically.
- The coordinate reference system never matters when using hotspot_dual_kde().

**Why do we usually clip the result of `hotspot_dual_kde()` using `hotspot_clip()`?**

- To make our maps look nicer.
- To transform the coordinate system our data uses from the system hotspot_dual_kde() uses to the one we need to produce a map.
- To eliminate any areas that we do not have data for, since displaying KDE values for such areas on a map might be misleading. (Correct answer)
- To make it easier to see the other layers on our map.

<a id="sec-gi-hotspots"></a>
<a id="finding-hotspots-using-gi"></a>

## 13.3 Finding hotspots using Gi\*

We have explored how to produce a better map of the density of crime in different areas. But how do we know which areas count as hotspots and which don't?

Each of the 16 density maps in [Map 13.4](#map-random-points-kde-patterns) shows density estimates based on 1,000 points placed completely at random on 16 different maps. There are no real patterns in the data except for statistical noise. Nevertheless, the KDE process makes it appear that there are patterns in the data.

<a id="map-random-points-kde-patterns"></a>

<figure>
<figure>
<p>Figure: Sixteen density surfaces arranged in a four-by-four grid, each calculated from independently generated random points. Darker orange patches appear in every panel but in different positions and shapes. These apparent concentrations show why the presence of a dark patch alone does not establish a statistically significant hotspot.</p>
</figure>
<figcaption>Map 13.4</figcaption>
</figure>

This is a problem because we might end up responding to an apparent problem that is nothing but an artefact of the random variation that we expect to see in many processes, including crime.

If the police and other agencies looked at these patterns and did nothing in response to them, it is likely that over time some of the areas with high density would become areas of low density, and *vice versa*. However, the harm caused by crime means it is very hard for agencies to justify sitting back and do nothing to respond to it -- many people would consider it immoral to do so. So police and other agencies are very likely to try to respond to crime patterns, even if those patterns might have occurred by chance. This is very frustrating, because if we were to go back and look at the same data in a few months time it is very likely that the apparent hotspots would have shifted to somewhere different, making all the effort spent in responding to crime seem worthless (which, if the apparent patterns were actually artefacts of the KDE process, it may have been).

You might be thinking it's better safe than sorry, and that police should respond to the apparent patterns just in case they represent real concentrations in crime. But police resources are always scarce, so responding to one problem in one place means not responding to another problem in another place. This is known as the *opportunity cost* of acting: if police focus their limited resources in one area, that comes at the cost of not being able to deploy those resources in other areas that might need it more.

We can try to avoid this problem of wasting resources responding to random variation in crime by determining whether the number of crimes in an area is more than the greatest number we would reasonably expect if there were no actual patterns in the data (if you have studied statistics before, you might recognise this as a description of a *null hypothesis*, but you don't need to have studied statistics to apply the techniques in this book).

To determine if the number of crimes in each area is greater than we would expect by chance, we can use the *Getis-Ord Gi\* statistic* (also called the *local G* statistic, spoken out-loud as the *G-I star statistic*). If the Gi\* statistic for an area is greater than a certain value, we can say that the number of crimes in that area is higher than we would expect if there were no patterns in the data. We will call areas with more crimes than we would expect by chance as *hotspots*.

We can calculate the Gi\* statistic using the `hotspot_gistar()` function from the sfhotspot package. This works in a similar way to the `hotspot_kde()` function, in that it takes an SF object of the locations of crimes and returns an SF object with a grid of cells, along with the Gi\* value for each grid cell. Like `hotspot_kde()`, `hotspot_gistar()` will choose default values for several ways in which we could fine-tune the calculation of the Gi\* statistic, but we could override these defaults if we wanted to.

Create a new file called `chapter_13b.R` in the `R` folder of your `crime_mapping` workspace as usual.

In this example, we will find the hotspots of robbery in Nottingham in 2020, based on a grid of 100-metre cells. We will store this in an object called `robbery`, transform it to use the British National Grid coordinate system (so we can specify the cell size in metres) and then use the resulting object to calculate the Gi\* values.

Add this code to the new script file and run it.

<a id="lst-mapping-hotspots-script-13b-hotspots"></a>

<figure>
<pre><code>chapter_13b.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This script produces a map of significant robbery hotspots in Nottingham,</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="co"># England</span></span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Load packages</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, httr2, sf, sfhotspot, tidyverse)</span>
<span id="cb2-6"><a href="#cb2-6"></a></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="co"># LOAD DATA --------------------------------------------------------------------</span></span>
<span id="cb2-8"><a href="#cb2-8"></a></span>
<span id="cb2-9"><a href="#cb2-9"></a><span class="co"># Download the original data</span></span>
<span id="cb2-10"><a href="#cb2-10"></a><span class="fu">request</span>(</span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/nottingham_robbery.csv.gz&quot;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_robbery.csv.gz&quot;</span>))</span>
<span id="cb2-14"><a href="#cb2-14"></a></span>
<span id="cb2-15"><a href="#cb2-15"></a><span class="fu">request</span>(</span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/nottingham_wards.gpkg&quot;</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_wards.gpkg&quot;</span>))</span>
<span id="cb2-19"><a href="#cb2-19"></a></span>
<span id="cb2-20"><a href="#cb2-20"></a><span class="co"># Load data and transform to British National Grid so distances are in metres</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>robbery <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_robbery.csv.gz&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  <span class="fu">read_csv</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;longitude&quot;</span>, <span class="st">&quot;latitude&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:4326&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:27700&quot;</span>)</span>
<span id="cb2-25"><a href="#cb2-25"></a>nottingham_wards <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_wards.gpkg&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-26"><a href="#cb2-26"></a>  <span class="fu">read_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-27"><a href="#cb2-27"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:27700&quot;</span>)</span>
<span id="cb2-28"><a href="#cb2-28"></a></span>
<span id="cb2-29"><a href="#cb2-29"></a></span>
<span id="cb2-30"><a href="#cb2-30"></a><span class="co"># FIND HOTSPOTS ----------------------------------------------------------------</span></span>
<span id="cb2-31"><a href="#cb2-31"></a></span>
<span id="cb2-32"><a href="#cb2-32"></a><span class="co"># Calculate Gi* statistic</span></span>
<span id="cb2-33"><a href="#cb2-33"></a>robbery_gistar <span class="ot">&lt;-</span> robbery <span class="sc">|&gt;</span></span>
<span id="cb2-34"><a href="#cb2-34"></a>  <span class="fu">hotspot_gistar</span>(<span class="at">cell_size =</span> <span class="dv">100</span>, <span class="at">bandwidth_adjust =</span> <span class="fl">0.25</span>, <span class="at">quiet =</span> <span class="cn">TRUE</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-35"><a href="#cb2-35"></a>  <span class="fu">filter</span>(gistar <span class="sc">&gt;</span> <span class="dv">0</span>, pvalue <span class="sc">&lt;</span> <span class="fl">0.05</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-36"><a href="#cb2-36"></a>  <span class="fu">hotspot_clip</span>(nottingham_wards)</span></code></pre></div>
<figcaption>Code 13.10</figcaption>
</figure>

    <httr2_response>
    GET https://mpjashby.github.io/crimemappingdata/nottingham_robbery.csv.gz
    Status: 200 OK
    Content-Type: application/gzip
    Body: On disk '/Users/mattashby/Documents/Crime Mapping Book/data/raw/nottingham_robbery.csv.gz' (6316 bytes)

    <httr2_response>
    GET https://mpjashby.github.io/crimemappingdata/nottingham_wards.gpkg
    Status: 200 OK
    Content-Type: application/octet-stream
    Body: On disk '/Users/mattashby/Documents/Crime Mapping Book/data/raw/nottingham_wards.gpkg' (118784 bytes)

    Rows: 555 Columns: 5
    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: ","
    chr  (2): location, lsoa_code
    dbl  (2): longitude, latitude
    date (1): month

    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

Instead of using `head()` to view the first few rows of the object we have just created, let's use the `slice_sample()` function from the dplyr package to return a random sample of rows from that object:

<a id="lst-mapping-hotspots-slice-sample-robbery-gistar-n-10"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">slice_sample</span>(robbery_gistar, <span class="at">n =</span> <span class="dv">10</span>)</span></code></pre></div>
<figcaption>Code 13.11</figcaption>
</figure>

    Simple feature collection with 10 features and 4 fields
    Geometry type: POLYGON
    Dimension:     XY
    Bounding box:  xmin: 453967.5 ymin: 339174.1 xmax: 458767.5 ymax: 342974.1
    Projected CRS: OSGB36 / British National Grid
    # A tibble: 10 × 5
           n   kde gistar   pvalue                                          geometry
       <dbl> <dbl>  <dbl>    <dbl>                                     <POLYGON [m]>
     1     0 15.4    3.65 2.66e- 3 ((457667.5 340174.1, 457767.5 340174.1, 457767.5…
     2     0  9.64   6.13 8.65e- 9 ((455067.5 340174.1, 455167.5 340174.1, 455167.5…
     3     0  4.44   2.82 4.84e- 2 ((455967.5 341974.1, 456067.5 341974.1, 456067.5…
     4     0  6.15   2.82 4.84e- 2 ((458667.5 339674.1, 458767.5 339674.1, 458767.5…
     5     0  9.12   3.65 2.66e- 3 ((456367.5 340974.1, 456467.5 340974.1, 456467.5…
     6     2 38.7   16.9  4.00e-63 ((457267.5 339974.1, 457367.5 339974.1, 457367.5…
     7     1 15.1    5.30 1.14e- 6 ((457667.5 339974.1, 457767.5 339974.1, 457767.5…
     8     0  4.56   3.65 2.66e- 3 ((453967.5 342974.1, 454067.5 342974.1, 454067.5…
     9     0  6.66   3.65 2.66e- 3 ((457467.5 339274.1, 457567.5 339274.1, 457567.5…
    10     0 16.1    4.47 7.65e- 5 ((456167.5 340974.1, 456267.5 340974.1, 456267.5…

The `robbery_gistar` object contains one row for each cell in a grid of cells covering the area of the robbery data. Each row has four columns:

- `n` shows the number of robberies that occurred in that grid cell,
- `kde` shows the density of robberies in that cell,
- `gistar` shows the Gi\* value for that cell, and
- `pvalue` shows the \\(p\\)-value for that cell.

The Gi\* statistic is an example of a more general group of statistics called \\(Z\\) *scores*. Statisticians and data analysts compare the \\(Z\\) scores produced by statistical procedures such as `hotspot_gistar()` to reference values to decide if a \\(Z\\) score is large enough to be treated as statistically significant, i.e. if it is large enough to conclude that it is larger than we would expect if there were no actual patterns in the data. Deciding on the right reference value to compare a \\(Z\\) score to can be difficult because of what's known as the multiple comparison problem (which we don't need to go into detail about). Fortunately, the values in the `pvalue` column have already been automatically adjusted to take account of the multiple comparison problem, so we can interpret the \\(p\\)-values instead of interpreting the Gi\* statistic directly.

ImportantClip data before calculating Gi\* values

Since Gi\* is a relative measure, if you want to produce a map that shows only a part of the area covered by your data (for example you have data for a county but want to produce a map showing only a town within that county), you should clip the data to the area of interest *before* calculating the Gi\* values, as well as clipping afterwards if necessary. This is because if you calculate the Gi\* values for a large area and then clip the results to a smaller area, the Gi\* values will be influenced by the large areas with no crime and all of the smaller area is likely to be identified as a hotspot.

By convention, \\(p\\)-values are considered to be significant if they are *less than 0.05*. So if \\(p\<0.05\\), we can say that the local concentration of robberies in a given grid cell and its neighbours is unlikely to have occurred by chance. Values of Gi\* greater than zero indicate cells with more robberies than expected and values of Gi\* less than zero indicate cells with fewer robberies than expected. We can combine these two values to find cells with significantly *more* robberies than expected by chance, which are those cells for which \\(Z\>0\\) and \\(p\<0.05\\).

By default, if we apply the function `hotspot_map()` to a result produced by `hotspot_gistar()`, the map will show only those grid cells with a Gi\* value that is significant (i.e. \\(p\<0.05\\)). However, the default settings also mean that the map will show cells that are significant hotspots (i.e. \\(Z\>0\\)) and cells that are significant coldspots (i.e. \\(Z\<0\\)). In crime mapping we are generally only interested in the hotspots rather than the coldspots. To show only significant hotspots, we can use the `hotspot_map()` argument `sign = "hot"`.

Add this complete map code to `chapter_13b.R` and run it to see what the significant robbery hotspots look like:

<a id="lst-mapping-hotspots-script-13b-map"></a>

<figure>
<pre><code>chapter_13b.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># PLOT MAP ---------------------------------------------------------------------</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="fu">hotspot_map</span>(</span>
<span id="cb2-4"><a href="#cb2-4"></a>  robbery_gistar,</span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>,</span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="at">sign =</span> <span class="st">&quot;hot&quot;</span>,</span>
<span id="cb2-7"><a href="#cb2-7"></a>  <span class="at">caption =</span> <span class="fu">str_glue</span>(</span>
<span id="cb2-8"><a href="#cb2-8"></a>    <span class="st">&quot;Contains public sector information licensed under the Open &quot;</span>,</span>
<span id="cb2-9"><a href="#cb2-9"></a>    <span class="st">&quot;Government Licence v3.0.&quot;</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  )</span>
<span id="cb2-11"><a href="#cb2-11"></a>) <span class="sc">+</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="co"># Add ward boundaries</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> nottingham_wards, <span class="at">colour =</span> <span class="st">&quot;grey70&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="fu">labs</span>(<span class="at">title =</span> <span class="st">&quot;Nottingham robbery hotspots&quot;</span>)</span></code></pre></div>
<figcaption>Code 13.12</figcaption>
</figure>

<a id="map-nottingham-significant-robbery-hotspots"></a>

<figure>
<figure>
<p>Figure: Map of statistically significant robbery hotspots in Nottingham in 2020. Coloured grid cells identify locations with more robberies than expected by chance; darker blue means higher robbery density. Cells cluster around the city centre, with smaller groups further north and south. Uncoloured areas are not identified as significant hotspots.</p>
</figure>
<figcaption>Map 13.5</figcaption>
</figure>

This map could be useful for police officers deciding where to conduct anti-robbery patrols, because it not only shows the areas with the highest density of robberies but only shows those areas if there are more robberies than we would expect by chance. This makes it more likely that officers won't waste time chasing apparent patterns that are actually the result of random variation.

Save `chapter_13b.R` by pressing . Your complete `chapter_13b.R` Gi\* script should now look like this:

<a id="lst-mapping-hotspots-show-chapter-13b-script"></a>

<figure>
<pre><code>chapter_13b.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This script produces a map of significant robbery hotspots in Nottingham,</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="co"># England</span></span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Load packages</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, httr2, sf, sfhotspot, tidyverse)</span>
<span id="cb2-6"><a href="#cb2-6"></a></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="co"># LOAD DATA --------------------------------------------------------------------</span></span>
<span id="cb2-8"><a href="#cb2-8"></a></span>
<span id="cb2-9"><a href="#cb2-9"></a><span class="co"># Download the original data</span></span>
<span id="cb2-10"><a href="#cb2-10"></a><span class="fu">request</span>(</span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/nottingham_robbery.csv.gz&quot;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_robbery.csv.gz&quot;</span>))</span>
<span id="cb2-14"><a href="#cb2-14"></a></span>
<span id="cb2-15"><a href="#cb2-15"></a><span class="fu">request</span>(</span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/nottingham_wards.gpkg&quot;</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_wards.gpkg&quot;</span>))</span>
<span id="cb2-19"><a href="#cb2-19"></a></span>
<span id="cb2-20"><a href="#cb2-20"></a><span class="co"># Load data and transform to British National Grid so distances are in metres</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>robbery <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_robbery.csv.gz&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  <span class="fu">read_csv</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;longitude&quot;</span>, <span class="st">&quot;latitude&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:4326&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:27700&quot;</span>)</span>
<span id="cb2-25"><a href="#cb2-25"></a>nottingham_wards <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_wards.gpkg&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-26"><a href="#cb2-26"></a>  <span class="fu">read_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-27"><a href="#cb2-27"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:27700&quot;</span>)</span>
<span id="cb2-28"><a href="#cb2-28"></a></span>
<span id="cb2-29"><a href="#cb2-29"></a></span>
<span id="cb2-30"><a href="#cb2-30"></a><span class="co"># FIND HOTSPOTS ----------------------------------------------------------------</span></span>
<span id="cb2-31"><a href="#cb2-31"></a></span>
<span id="cb2-32"><a href="#cb2-32"></a><span class="co"># Calculate Gi* statistic</span></span>
<span id="cb2-33"><a href="#cb2-33"></a>robbery_gistar <span class="ot">&lt;-</span> robbery <span class="sc">|&gt;</span></span>
<span id="cb2-34"><a href="#cb2-34"></a>  <span class="fu">hotspot_gistar</span>(<span class="at">cell_size =</span> <span class="dv">100</span>, <span class="at">bandwidth_adjust =</span> <span class="fl">0.25</span>, <span class="at">quiet =</span> <span class="cn">TRUE</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-35"><a href="#cb2-35"></a>  <span class="fu">filter</span>(gistar <span class="sc">&gt;</span> <span class="dv">0</span>, pvalue <span class="sc">&lt;</span> <span class="fl">0.05</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-36"><a href="#cb2-36"></a>  <span class="fu">hotspot_clip</span>(nottingham_wards)</span>
<span id="cb2-37"><a href="#cb2-37"></a></span>
<span id="cb2-38"><a href="#cb2-38"></a><span class="co"># PLOT MAP ---------------------------------------------------------------------</span></span>
<span id="cb2-39"><a href="#cb2-39"></a></span>
<span id="cb2-40"><a href="#cb2-40"></a><span class="fu">hotspot_map</span>(</span>
<span id="cb2-41"><a href="#cb2-41"></a>  robbery_gistar,</span>
<span id="cb2-42"><a href="#cb2-42"></a>  <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>,</span>
<span id="cb2-43"><a href="#cb2-43"></a>  <span class="at">sign =</span> <span class="st">&quot;hot&quot;</span>,</span>
<span id="cb2-44"><a href="#cb2-44"></a>  <span class="at">caption =</span> <span class="fu">str_glue</span>(</span>
<span id="cb2-45"><a href="#cb2-45"></a>    <span class="st">&quot;Contains public sector information licensed under the Open &quot;</span>,</span>
<span id="cb2-46"><a href="#cb2-46"></a>    <span class="st">&quot;Government Licence v3.0.&quot;</span></span>
<span id="cb2-47"><a href="#cb2-47"></a>  )</span>
<span id="cb2-48"><a href="#cb2-48"></a>) <span class="sc">+</span></span>
<span id="cb2-49"><a href="#cb2-49"></a>  <span class="co"># Add ward boundaries</span></span>
<span id="cb2-50"><a href="#cb2-50"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> nottingham_wards, <span class="at">colour =</span> <span class="st">&quot;grey70&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-51"><a href="#cb2-51"></a>  <span class="fu">labs</span>(<span class="at">title =</span> <span class="st">&quot;Nottingham robbery hotspots&quot;</span>)</span></code></pre></div>
<figcaption>Code 13.13</figcaption>
</figure>

Running the complete script produces this map:

<a id="map-nottingham-significant-robbery-hotspots-complete"></a>

<figure>

<figcaption>Map 13.6</figcaption>
</figure>

QuizGi\*

**`robbery_gi` is an object storing a result produced by the `hotspot_gistar()` function. Which of these pieces of code could be used to extract *only* those rows in the data with significant p-values?**

- filter(robbery_gi, pvalue \< 0.05) (Correct answer)
- filter(robbery_gi, pvalue \> 0.05)
- filter(robbery_gi, pvalue \<= 0.05)
- filter(robbery_gi, pvalue == 0.05)

**Which *one* of these statements is true about the output from `hotspot_gistar()`?**

- Cells with gistar \> 0 are always statistically significant hotspots.
- A significant hotspot has gistar \> 0 and pvalue \< 0.05. (Correct answer)
- A significant hotspot has gistar \< 0 and pvalue \> 0.05.
- The kde value alone tells us whether a cell is a statistically significant hotspot.

<a id="finding-clusters-using-dbscan"></a>

## 13.4 Finding clusters using DBSCAN

Gi\* maps are a useful way to show where there is more of a particular type of crime than we'd expect by chance. But since resources to respond to crime are almost always limited, it is often also useful to be able to rank clusters of crime so that we can see which should be prioritised for a response. One way to do this is to use a clustering algorithm called DBSCAN, which stands for 'Density-Based Spatial Clustering of Applications with Noise' (you don't need to remember that).

DBSCAN identifies clusters of crimes based on their spatial proximity to each other, finding places where crimes are more closely clustered together in space than a cut-off value that we specify. For example, this map shows the top clusters of robbery in Nottingham in 2020:

<a id="map-nottingham-robbery-dbscan-introduction"></a>

<figure>
<pre><code>Minimum points set automatically from the number of point coordinates.
ℹ `min_pts` = 24.
Neighbourhood distance set automatically from nearest-neighbour distances.
ℹ `eps` = 284.7 metres; `density_adjust` = 5.</code></pre>
<figure>
<p>Figure: Map of recorded robbery clusters in central Nottingham in 2020. Three red outlines enclose concentrations containing twenty-two, nine point four and six point five percent of all recorded robberies respectively. The largest share is in the eastern cluster; the two smaller clusters lie to its north-west and partly overlap.</p>
</figure>
<figcaption>Map 13.7</figcaption>
</figure>

We can use the `hotspot_dbscan()` function from the sfhotspot package to identify clusters using DBSCAN in R. In a similar way to how the results produced by `hotspot_kde()` are influenced by the choice of bandwidth and cell size (see [Section 6.2](../06_mapping_crime_patterns/index.llms.md#sec-kde)), the results produced by `hotspot_dbscan()` are influenced by two values (known as *parameters*) that we specify.

The first value that influences the results of `hotspot_dbscan()` is `min_pts`, the minimum number of nearby points required for a location to form the core of a cluster. Note that an area won't be identified as a cluster just because it includes the specified minimum number of points -- the points also have to be close enough together to be considered a cluster (more on that shortly). `min_pts` therefore provides a *minimum* cut-off value for the number of points in each cluster.

By default, `hotspot_dbscan()` chooses `min_pts` automatically based on the total number of points in the dataset. For very small datasets, the default value of `min_pts` is 5. As the dataset becomes larger, the automatically selected value for `min_pts` gradually increases, up to a maximum of 50. Increasing `min_pts` for larger datasets helps to avoid producing a very large number of clusters that each contain only a very-small proportion of all the crimes being studied.

Whether the automatically chosen value is reasonable depends on the type of crime you are mapping and the purpose of the analysis. If you were mapping relatively rare crimes, such as homicides in many cities, a cluster of 5 crimes might be important to identify. If you were mapping a frequent crime such as pickpocketing in central London or downtown New York City, you might only be interested in clusters containing many more crimes. Since the resources available to respond to crime are almost always limited, producing too many clusters is often unhelpful. You can override the automatically chosen value by supplying your own value for `min_pts`, so think carefully about the minimum number of crimes in a cluster that you or the audience for your analysis are likely to find useful.

These maps show the results produced by applying `hotspot_dbscan()` to the same Nottingham robbery data we used above. All that changes is each time is the value of `min_pts`. You can see that the number and size of the clusters produced varies quite substantially.

<a id="map-nottingham-dbscan-minimum-points"></a>

<figure>
<figure>
<p>Figure: Three side-by-side Nottingham robbery maps compare minimum point counts of five, ten and twenty. They identify eighteen, five and two clusters respectively, containing thirty-two, thirty-three and thirty-five percent of points. Increasing the threshold removes many small clusters and changes the outlines of those retained. Numbered labels rank the clusters.</p>
</figure>
<figcaption>Map 13.8</figcaption>
</figure>

You can see from this map that the clusters produced by DBSCAN don't necessarily include all the points in the input data. The points that are outside the identified clusters are those that are not sufficiently close together to be part of a cluster. You can also see that the clusters produced by DBSCAN can sometimes overlap.

The second parameter that affects the results produced by `hotspot_dbscan()` is called `eps`. This parameter controls how close together points must be to be treated as neighbours within a cluster. You can specify `eps` manually using the `eps` argument, but it's often easier to control it relative to the default value chosen by `hotspot_dbscan()`. By default, `hotspot_dbscan()` chooses a suitable value automatically based on the typical local density of points in the dataset. The `density_adjust` argument controls how dense the number of crimes in an area must be (relative to that typical density) in order for the area to be considered a cluster. The default value is `density_adjust = 2`, which means `hotspot_dbscan()` searches for clusters with approximately at least twice the typical local density of points. Setting larger values of `density_adjust` identifies only denser concentrations of points, while smaller values allow clusters to be less dense.

You can see the effect of varying the `density_adjust` argument on the results shown in these maps:

<a id="map-nottingham-dbscan-density-thresholds"></a>

<figure>
<figure>
<p>Figure: Three side-by-side Nottingham robbery maps compare density adjustments of one, two and four. They identify five, five and four clusters, containing forty-three, thirty-two and twenty-four percent of points respectively. Higher thresholds shrink the outlined clusters, retaining fewer points in the densest areas.</p>
</figure>
<figcaption>Map 13.9</figcaption>
</figure>

Higher values of `density_adjust` produce physically smaller hotspots that have higher densities of crime but collectively contain a smaller proportion of all crimes. It's important to note that the objective in clustering crime is rarely to produce clusters that jointly cover all the crimes in a dataset. In most applications of crime analysis, what matters more is producing clusters that show where interventions against crime are likely to achieve the most benefit while keeping the required effort manageable within the available resources.

While you should set `min_pts` based on your expert judgement of the minimum number of crimes that might be worthy of action, deciding on the best value of `density_adjust` is usually a matter of trial and error. As a starting point, it's often useful to produce a DBSCAN map using the default `density_adjust = 2` and look at the results, then vary `density_adjust` up or down depending on how useful you think the results are likely to be in supporting the purpose of your analysis. This inevitably involves some skill, which you will develop with time and experience. In particular, it is important (as in all data analysis) to understand the purpose for which you are conducting analysis, and how people are going to use the results of the analysis you produce.

Now that we have explored how to control the DBSCAN algorithm, let's create a DBSCAN map in R. We'll use the same robbery data as in [Section 13.3](#sec-gi-hotspots). Create a new file called `chapter_13c.R` and save it in the `R` folder of your `crime_mapping` workspace as usual. Now add the code needed to load the packages and data we need, so that it's possible to run this script independently of the other scripts in this chapter. Read the two notes accompanying [Code 13.14](#lst-mapping-hotspots-script-13c-prepare), which explain two minor differences between this code and most of the similar code we have used before.

<a id="lst-mapping-hotspots-script-13c-prepare"></a>

<figure>
<pre><code>chapter_13c.R</code></pre>
<a id="annotated-cell-11"></a>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r code-annotation-code number-lines code-with-copy code-annotated"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This script identifies clusters of robberies in Nottingham, England</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="co"># Load packages</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(ggspatial, here, httr2, sf, sfhotspot, tidyverse)</span>
<span id="cb2-5"><a href="#cb2-5"></a></span>
<span id="cb2-6"><a href="#cb2-6"></a></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="co"># LOAD DATA --------------------------------------------------------------------</span></span>
<span id="cb2-8"><a href="#cb2-8"></a></span>
<span id="cb2-9"><a href="#cb2-9"></a><span class="co"># Download the original data</span></span>
<span id="cb2-10"><a href="#cb2-10"></a><span class="fu">request</span>(</span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/nottingham_robbery.csv.gz&quot;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_robbery.csv.gz&quot;</span>)) <span class="sc">|&gt;</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="co"># Stop this command from producing an output in the R Console</span></span>
<span id="cb2-15"><a href="#cb2-15"></a><span class="dv">1</span>  <span class="fu">invisible</span>()</span>
<span id="cb2-16"><a href="#cb2-16"></a></span>
<span id="cb2-17"><a href="#cb2-17"></a><span class="co"># Load data and transform to British National Grid so distances are in metres</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>robbery <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_robbery.csv.gz&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-19"><a href="#cb2-19"></a><span class="dv">2</span>  <span class="fu">read_csv</span>(<span class="at">show_col_types =</span> <span class="cn">FALSE</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;longitude&quot;</span>, <span class="st">&quot;latitude&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:4326&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:27700&quot;</span>)</span></code></pre></div>
<figcaption>Code 13.14</figcaption>
</figure>

1
: The `invisible()` function is used to prevent the output of the `req_perform()` command from being printed in the R Console. This is because the output is not useful for our purposes, and we want to keep the R Console clean and focused on the results that are relevant to our analysis.

2
: The `show_col_types = FALSE` argument is used in the `read_csv()` function to suppress the printing of column types in the R Console. This is because we already know the column types from the previous analysis, and we want to keep the R Console clean and focused on the results that are relevant to our analysis.

`hotspot_dbscan()` operates in a similar way to the other hotspot functions we have already used. Let's start by keeping all the arguments at their default values. We will store the result in an object called `robbery_dbscan`.

<a id="lst-mapping-hotspots-script-13c-initial-clusters"></a>

<figure>
<pre><code>chapter_13c.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># FIND CLUSTERS ----------------------------------------------------------------</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="co"># Find clusters using DBSCAN</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>robbery_dbscan <span class="ot">&lt;-</span> <span class="fu">hotspot_dbscan</span>(robbery)</span></code></pre></div>
<figcaption>Code 13.15</figcaption>
</figure>

    Minimum points set automatically from the number of point coordinates.
    ℹ `min_pts` = 24.
    Neighbourhood distance set automatically from nearest-neighbour distances.
    ℹ `eps` = 450.1 metres; `density_adjust` = 2.

You can see that `hotspot_dbscan()` tells us the values of `min_pts` and `eps` that it has chosen automatically. Let's use `hotspot_map()` to produce a quick map of the clusters that have been identified.

<a id="lst-mapping-hotspots-draw-nottingham-robbery-clusters-default"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">hotspot_map</span>(robbery_dbscan, <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>)</span></code></pre></div>
<figcaption>Code 13.16</figcaption>
</figure>

<a id="map-nottingham-robbery-clusters-default"></a>

<figure>
<figure>
<p>Figure: Map of Nottingham robberies in 2020 clustered with default DBSCAN settings. One large blue region joins concentrations around the city centre into a single cluster; its dark shade represents the large number of included robberies. The broad outline hides differences between the local concentrations.</p>
</figure>
<figcaption>Map 13.10</figcaption>
</figure>

You can see from this map that by default, `hotspot_dbscan()` has identified 2 clusters. Let's inspect the `robbery_dbscan` object in the R Console:

<a id="lst-mapping-hotspots-inspect-robbery-clusters"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>robbery_dbscan</span></code></pre></div>
<figcaption>Code 13.17</figcaption>
</figure>

    Simple feature collection with 2 features and 5 fields
    Geometry type: POLYGON
    Dimension:     XY
    Bounding box:  xmin: 453164 ymin: 338736.8 xmax: 458594.1 ymax: 346086.7
    Projected CRS: OSGB36 / British National Grid
    # A tibble: 2 × 6
      cluster  rank     n   prop prop_area                                  geometry
    *   <int> <int> <int>  <dbl>     <dbl>                             <POLYGON [m]>
    1       1     1   279 0.503     0.112  ((454693.5 340441.6, 454686.2 340461.4, …
    2       2     2    34 0.0613    0.0247 ((453376.3 345084.3, 453355.8 345098.4, …

The `rank` column in the `robbery_dbscan` object shows the rank of each cluster, with the cluster containing the most robberies ranked 1, the cluster containing the second most robberies ranked 2, and so on. The `n` column shows the number of robberies in each cluster, while the `prop` column shows the proportion of all robberies in Nottingham in 2020 that are contained in each cluster.

You can see from the `prop` column that 50.3% of all robberies in Nottingham in 2020 have been included in the cluster with rank 1. You can also see from [Map 13.10](#map-nottingham-robbery-clusters-default) that that cluster covers quite a large section of the city. That's probably not very useful for police officers trying to decide where to patrol, or local officials deciding whether to focus crime-prevention initiatives. It will probably be more useful to identify smaller clusters that contain the the very highest densities of robbery, even if those clusters cover a smaller proportion of all robberies. To do that, we can increase the value of `density_adjust` to 5, which will identify clusters that are at least five times as dense as the typical local density of robberies in Nottingham in 2020.

Change the existing code that creates the `robbery_dbscan` object in `chapter_13c.R` to the following and run it:

<a id="lst-mapping-hotspots-script-13c-final-clusters"></a>

<figure>
<pre><code>chapter_13c.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Find clusters using DBSCAN</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a>robbery_dbscan <span class="ot">&lt;-</span> <span class="fu">hotspot_dbscan</span>(robbery, <span class="at">density_adjust =</span> <span class="dv">5</span>)</span></code></pre></div>
<figcaption>Code 13.18</figcaption>
</figure>

    Minimum points set automatically from the number of point coordinates.
    ℹ `min_pts` = 24.
    Neighbourhood distance set automatically from nearest-neighbour distances.
    ℹ `eps` = 284.7 metres; `density_adjust` = 5.

If we now inspect this object in the R Console, we'll see it contains 3 clusters and the highest-ranked cluster contains 22.2% of all the robberies. Let's plot that quickly using `hotspot_map()`:

<a id="lst-mapping-hotspots-draw-nottingham-robbery-clusters-higher-density"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">hotspot_map</span>(robbery_dbscan, <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>)</span></code></pre></div>
<figcaption>Code 13.19</figcaption>
</figure>

<a id="map-nottingham-robbery-clusters-higher-density"></a>

<figure>
<figure>
<p>Figure: Map of Nottingham robberies in 2020 with the density adjustment raised to five. Three smaller blue regions replace the single broad default cluster. The eastern cluster is darkest and contains the most robberies; two paler clusters lie to its north-west. Shading represents counts within clusters.</p>
</figure>
<figcaption>Map 13.11</figcaption>
</figure>

This time, we can see that the clusters cover a smaller area of the city, and tell us that any efforts to prevent robbery should be concentrated in the city centre.

There are several different ways we can represent DBSCAN clusters on a map. One option (which is what `hotspot_map()` does in [Map 13.11](#map-nottingham-robbery-clusters-higher-density)) is to shade each cluster according to how many crimes it contains. Another option (shown earlier in the maps that illustrate the effect of varying `min_pts` and `density_adjust`) is to show the outline of each cluster and label it, for example with the cluster rank (where the cluster with containing the most crimes is ranked 1, the cluster with the second most crimes is ranked 2, and so on).

This code produces a map that shows the outline of each cluster and the proportion of all robberies in Nottingham in 2020 that are contained within it. In particular, we use:

- the `col_fill` argument of `hotspot_map()` to "none" to specify that we don't want each polygon to have a fill colour, which means the clusters will be outlined, and
- the `col_label` argument of `hotspot_map()` to "prop" to specify that we want to label each cluster with the proportion of all robberies in Nottingham in 2020 that are contained within it.

Add this code to `chapter_13c.R` and run it:

<a id="lst-mapping-hotspots-script-13c-map"></a>

<figure>
<pre><code>chapter_13c.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># PLOT MAP ---------------------------------------------------------------------</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="fu">hotspot_map</span>(</span>
<span id="cb2-4"><a href="#cb2-4"></a>  robbery_dbscan,</span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="at">col_fill =</span> <span class="st">&quot;none&quot;</span>,</span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="at">col_label =</span> <span class="st">&quot;prop&quot;</span>,</span>
<span id="cb2-7"><a href="#cb2-7"></a>  <span class="at">colour =</span> <span class="st">&quot;red2&quot;</span>,</span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>,</span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="at">caption =</span> <span class="fu">str_glue</span>(</span>
<span id="cb2-10"><a href="#cb2-10"></a>    <span class="st">&quot;Contains public sector information licensed under the</span><span class="sc">\n</span><span class="st">Open &quot;</span>,</span>
<span id="cb2-11"><a href="#cb2-11"></a>    <span class="st">&quot;Government Licence v3.0.&quot;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  )</span>
<span id="cb2-13"><a href="#cb2-13"></a>) <span class="sc">+</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="fu">labs</span>(<span class="at">title =</span> <span class="st">&quot;Nottingham robbery clusters&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-16"><a href="#cb2-16"></a>    <span class="at">plot.title =</span> <span class="fu">element_text</span>(<span class="at">colour =</span> <span class="st">&quot;grey50&quot;</span>, <span class="at">face =</span> <span class="st">&quot;bold&quot;</span>, <span class="at">size =</span> <span class="dv">16</span>)</span>
<span id="cb2-17"><a href="#cb2-17"></a>  )</span></code></pre></div>
<figcaption>Code 13.20</figcaption>
</figure>

<a id="map-nottingham-robbery-cluster-proportions"></a>

<figure>
<figure>
<p>Figure: Map of recorded robbery clusters in central Nottingham in 2020. Three red outlines enclose concentrations containing twenty-two, nine point four and six point five percent of all recorded robberies respectively. The largest share is in the eastern cluster; the two smaller clusters lie to its north-west and partly overlap.</p>
</figure>
<figcaption>Map 13.12</figcaption>
</figure>

It's also possible to vary how the outline of each cluster is represented. The underlying DBSCAN algorithm assigns points to clusters, but it doesn't produce the polygons returned by `hotspot_dbscan()`. Instead, by default `hotspot_dbscan()` returns polygons that indicate the *concave hull* of all the points in each cluster. You might remember we learned about *convex* hulls in [Section 6.3](../06_mapping_crime_patterns/index.llms.md#sec-clipping-map-layers). A concave hull is similar to a convex hull, but it can be more irregular in shape and can follow the outline of the points in a cluster more closely. How closely the outline follows the points depends on another argument to `hotspot_dbscan()` called `hull_ratio`. The default value is `hull_ratio = 0.75`, which means the concave hull will follow the outline of the points in a cluster moderately closely. If you set `hull_ratio = 1`, the concave hull will be the same as the convex hull, which (depending on the arrangement of the points) is sometimes a much larger (but simpler) shape that doesn't follow the outline of the points in a cluster as closely. Most of the time you will probably not vary `hull_ratio`, but it's important to remember that the outline of the polygons returned by `hotspot_dbscan()` is not necessarily a precise representation of the outline of the points in a cluster. This is often a good thing, since crimes in future probably won't occur at exactly the same locations as crimes in the past, so a more generalised outline of a cluster is often more useful than a precise outline. But it also means that you shouldn't read too much into whether (for example) a particular location falls just inside or just outside the outline of a cluster.

Save `chapter_13c.R` by pressing . Your complete `chapter_13c.R` DBSCAN script should now look like this:

<a id="lst-mapping-hotspots-show-chapter-13c-script"></a>

<figure>
<pre><code>chapter_13c.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This script identifies clusters of robberies in Nottingham, England</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="co"># Load packages</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(ggspatial, here, httr2, sf, sfhotspot, tidyverse)</span>
<span id="cb2-5"><a href="#cb2-5"></a></span>
<span id="cb2-6"><a href="#cb2-6"></a></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="co"># LOAD DATA --------------------------------------------------------------------</span></span>
<span id="cb2-8"><a href="#cb2-8"></a></span>
<span id="cb2-9"><a href="#cb2-9"></a><span class="co"># Download the original data</span></span>
<span id="cb2-10"><a href="#cb2-10"></a><span class="fu">request</span>(</span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/nottingham_robbery.csv.gz&quot;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_robbery.csv.gz&quot;</span>)) <span class="sc">|&gt;</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="co"># Stop this command from producing an output in the R Console</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  <span class="fu">invisible</span>()</span>
<span id="cb2-16"><a href="#cb2-16"></a><span class="co"># Load data and transform to British National Grid so distances are in metres</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>robbery <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_robbery.csv.gz&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="fu">read_csv</span>(<span class="at">show_col_types =</span> <span class="cn">FALSE</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;longitude&quot;</span>, <span class="st">&quot;latitude&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:4326&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:27700&quot;</span>)</span>
<span id="cb2-21"><a href="#cb2-21"></a></span>
<span id="cb2-22"><a href="#cb2-22"></a><span class="co"># FIND CLUSTERS ----------------------------------------------------------------</span></span>
<span id="cb2-23"><a href="#cb2-23"></a></span>
<span id="cb2-24"><a href="#cb2-24"></a><span class="co"># Find clusters using DBSCAN</span></span>
<span id="cb2-25"><a href="#cb2-25"></a></span>
<span id="cb2-26"><a href="#cb2-26"></a>robbery_dbscan <span class="ot">&lt;-</span> <span class="fu">hotspot_dbscan</span>(robbery, <span class="at">density_adjust =</span> <span class="dv">5</span>)</span>
<span id="cb2-27"><a href="#cb2-27"></a></span>
<span id="cb2-28"><a href="#cb2-28"></a><span class="co"># PLOT MAP ---------------------------------------------------------------------</span></span>
<span id="cb2-29"><a href="#cb2-29"></a></span>
<span id="cb2-30"><a href="#cb2-30"></a><span class="fu">hotspot_map</span>(</span>
<span id="cb2-31"><a href="#cb2-31"></a>  robbery_dbscan,</span>
<span id="cb2-32"><a href="#cb2-32"></a>  <span class="at">col_fill =</span> <span class="st">&quot;none&quot;</span>,</span>
<span id="cb2-33"><a href="#cb2-33"></a>  <span class="at">col_label =</span> <span class="st">&quot;prop&quot;</span>,</span>
<span id="cb2-34"><a href="#cb2-34"></a>  <span class="at">colour =</span> <span class="st">&quot;red2&quot;</span>,</span>
<span id="cb2-35"><a href="#cb2-35"></a>  <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>,</span>
<span id="cb2-36"><a href="#cb2-36"></a>  <span class="at">caption =</span> <span class="fu">str_glue</span>(</span>
<span id="cb2-37"><a href="#cb2-37"></a>    <span class="st">&quot;Contains public sector information licensed under the</span><span class="sc">\n</span><span class="st">Open &quot;</span>,</span>
<span id="cb2-38"><a href="#cb2-38"></a>    <span class="st">&quot;Government Licence v3.0.&quot;</span></span>
<span id="cb2-39"><a href="#cb2-39"></a>  )</span>
<span id="cb2-40"><a href="#cb2-40"></a>) <span class="sc">+</span></span>
<span id="cb2-41"><a href="#cb2-41"></a>  <span class="fu">labs</span>(<span class="at">title =</span> <span class="st">&quot;Nottingham robbery clusters&quot;</span>) <span class="sc">+</span></span>
<span id="cb2-42"><a href="#cb2-42"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-43"><a href="#cb2-43"></a>    <span class="at">plot.title =</span> <span class="fu">element_text</span>(<span class="at">colour =</span> <span class="st">&quot;grey50&quot;</span>, <span class="at">face =</span> <span class="st">&quot;bold&quot;</span>, <span class="at">size =</span> <span class="dv">16</span>)</span>
<span id="cb2-44"><a href="#cb2-44"></a>  )</span></code></pre></div>
<figcaption>Code 13.21</figcaption>
</figure>

Running the complete script produces this map:

<a id="map-nottingham-robbery-concave-hulls"></a>

<figure>
<figure>
<p>Figure: Map of recorded robbery clusters in central Nottingham in 2020. Three red outlines enclose concentrations containing twenty-two, nine point four and six point five percent of all recorded robberies respectively. The largest share is in the eastern cluster; the two smaller clusters lie to its north-west and partly overlap. The outlines follow the point clusters more closely than rectangular bounding boxes would.</p>
</figure>
<figcaption>Map 13.13</figcaption>
</figure>

To check that the analysis is reproducible, restart R using the **Restart R** (**⟳**) button in Positron's **Console** panel, then run the script from beginning to end.

Keep the script in the `R` folder and the original downloads in `data/raw`.

QuizDBSCAN

**What does the `min_pts` argument of `hotspot_dbscan()` specify?**

- The maximum number of clusters that DBSCAN can identify
- The minimum number of nearby points required for a location to form the core of a cluster (Correct answer)
- The minimum distance that must separate two clusters
- The proportion of all points that must be included in clusters

**Compared with a lower value, what will a higher value of `density_adjust` usually produce?**

- Larger clusters that may collectively contain more of the input points
- More clusters, each containing exactly the value of min_pts
- Smaller, denser clusters that may collectively contain fewer of the input points (Correct answer)
- Clusters with more precise boundaries but otherwise identical contents

**What does the `prop` column in the output from `hotspot_dbscan()` represent?**

- The density of robberies inside the cluster
- The proportion of the study area covered by the cluster
- The proportion of all robberies in the input data contained in the cluster (Correct answer)
- The probability that the cluster occurred by chance

<a id="combining-hotspot-techniques"></a>

## 13.5 Combining hotspot techniques

In this chapter we've learned to use three techniques that we can use alongside KDE mapping ([Chapter 6](../06_mapping_crime_patterns/index.llms.md)) that we can use to understand patterns of crime. Each technique has its own strengths and weaknesses, and you can use them either on their own or in combination. For example, we can use Gi\* to identify areas with more crime than expected by chance, then use DBSCAN to identify the most dense clusters of crime within those areas. We can even show these two techniques on the same map.

Create a new file called `chapter_13d.R` in the `R` folder of your `crime_mapping` workspace as usual. Add all the code from the file `chapter_13b.R` to the new file except the code that creates the map itself. Now run the code in the new file to load all the data we will need and calculate the Gi\* values.

Next, we should add the code needed to identify clusters of robbery using DBSCAN. Add this code to the new file and run it:

<a id="lst-mapping-hotspots-script-13d-clusters"></a>

<figure>
<pre><code>chapter_13d.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Find clusters using DBSCAN</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a>robbery_dbscan <span class="ot">&lt;-</span> <span class="fu">hotspot_dbscan</span>(robbery, <span class="at">density_adjust =</span> <span class="dv">5</span>)</span></code></pre></div>
<figcaption>Code 13.22</figcaption>
</figure>

    Minimum points set automatically from the number of point coordinates.
    ℹ `min_pts` = 24.
    Neighbourhood distance set automatically from nearest-neighbour distances.
    ℹ `eps` = 284.7 metres; `density_adjust` = 5.

We now need to create a map that has two hotspot layers, one on top of the other. We can't add together two separate calls to `hotspot_map()` because that would mean the second call would add a basemap that would cover the first layer. Instead, we can use the `hotspot_map()` function to create a map of the Gi\* hotspots, then add a layer for the DBSCAN clusters using another function from the sfhotspot package: `hotspot_layer()`. This acts in a very similar way to `hotspot_map()`, except that it adds a layer to an existing map. Just like `hotspot_map()`, `hotspot_layer()` makes some choices about how to display a layer depending on what type of layer it is given. We can also control `hotspot_layer()` in a similar way to `hotspot_map()`. For example, we can use the `col_fill` and `col_label` arguments to control how the DBSCAN clusters are displayed on the map.

Add this code to your new file and run it:

<a id="lst-mapping-hotspots-script-13d-map"></a>

<figure>
<pre><code>chapter_13d.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># PLOT MAP ---------------------------------------------------------------------</span></span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="co"># Initiate map and add KDE layer for significant hotspots</span></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="fu">hotspot_map</span>(</span>
<span id="cb2-5"><a href="#cb2-5"></a>  robbery_gistar,</span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>,</span>
<span id="cb2-7"><a href="#cb2-7"></a>  <span class="at">sign =</span> <span class="st">&quot;hot&quot;</span>,</span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="at">caption =</span> <span class="fu">str_glue</span>(</span>
<span id="cb2-9"><a href="#cb2-9"></a>    <span class="st">&quot;Contains public sector information licensed under the Open &quot;</span>,</span>
<span id="cb2-10"><a href="#cb2-10"></a>    <span class="st">&quot;Government Licence v3.0.&quot;</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  )</span>
<span id="cb2-12"><a href="#cb2-12"></a>) <span class="sc">+</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="co"># Add clusters</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>  <span class="fu">hotspot_layer</span>(</span>
<span id="cb2-15"><a href="#cb2-15"></a>    robbery_dbscan,</span>
<span id="cb2-16"><a href="#cb2-16"></a>    <span class="at">col_fill =</span> <span class="st">&quot;none&quot;</span>,</span>
<span id="cb2-17"><a href="#cb2-17"></a>    <span class="at">col_label =</span> <span class="st">&quot;prop&quot;</span>,</span>
<span id="cb2-18"><a href="#cb2-18"></a>    <span class="at">colour =</span> <span class="st">&quot;red2&quot;</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>  ) <span class="sc">+</span></span>
<span id="cb2-20"><a href="#cb2-20"></a>  <span class="co"># Add ward boundaries</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> nottingham_wards, <span class="at">colour =</span> <span class="st">&quot;grey70&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  <span class="fu">labs</span>(<span class="at">title =</span> <span class="st">&quot;Nottingham robbery hotspots&quot;</span>)</span></code></pre></div>
<figcaption>Code 13.23</figcaption>
</figure>

<a id="map-nottingham-significant-robbery-clusters"></a>

<figure>
<figure>
<p>Figure: Map of recorded robbery clusters in central Nottingham in 2020. Three red outlines enclose concentrations containing twenty-two, nine point four and six point five percent of all recorded robberies respectively. The largest share is in the eastern cluster; the two smaller clusters lie to its north-west and partly overlap. Blue significant-hotspot cells show density within and beyond the cluster outlines, with ward boundaries in grey.</p>
</figure>
<figcaption>Map 13.14</figcaption>
</figure>

You can see that this map combines different techniques -- KDE, Gi\* and DBSCAN -- to help people understand patterns of robbery in this city.

Save `chapter_13d.R` by pressing . Your complete `chapter_13d.R` script should now look like this:

<a id="lst-mapping-hotspots-show-chapter-13d-script"></a>

<figure>
<pre><code>chapter_13d.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># This script produces a map of significant robbery hotspots in Nottingham,</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="co"># England</span></span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Load packages</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, httr2, sf, sfhotspot, tidyverse)</span>
<span id="cb2-6"><a href="#cb2-6"></a></span>
<span id="cb2-7"><a href="#cb2-7"></a><span class="co"># LOAD DATA --------------------------------------------------------------------</span></span>
<span id="cb2-8"><a href="#cb2-8"></a></span>
<span id="cb2-9"><a href="#cb2-9"></a><span class="co"># Download the original data</span></span>
<span id="cb2-10"><a href="#cb2-10"></a><span class="fu">request</span>(</span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/nottingham_robbery.csv.gz&quot;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-13"><a href="#cb2-13"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_robbery.csv.gz&quot;</span>))</span>
<span id="cb2-14"><a href="#cb2-14"></a></span>
<span id="cb2-15"><a href="#cb2-15"></a><span class="fu">request</span>(</span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/nottingham_wards.gpkg&quot;</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_wards.gpkg&quot;</span>))</span>
<span id="cb2-19"><a href="#cb2-19"></a></span>
<span id="cb2-20"><a href="#cb2-20"></a><span class="co"># Load data and transform to British National Grid so distances are in metres</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>robbery <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_robbery.csv.gz&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  <span class="fu">read_csv</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-23"><a href="#cb2-23"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;longitude&quot;</span>, <span class="st">&quot;latitude&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:4326&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-24"><a href="#cb2-24"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:27700&quot;</span>)</span>
<span id="cb2-25"><a href="#cb2-25"></a>nottingham_wards <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nottingham_wards.gpkg&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-26"><a href="#cb2-26"></a>  <span class="fu">read_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-27"><a href="#cb2-27"></a>  <span class="fu">st_transform</span>(<span class="st">&quot;EPSG:27700&quot;</span>)</span>
<span id="cb2-28"><a href="#cb2-28"></a></span>
<span id="cb2-29"><a href="#cb2-29"></a></span>
<span id="cb2-30"><a href="#cb2-30"></a><span class="co"># FIND HOTSPOTS ----------------------------------------------------------------</span></span>
<span id="cb2-31"><a href="#cb2-31"></a></span>
<span id="cb2-32"><a href="#cb2-32"></a><span class="co"># Calculate Gi* statistic</span></span>
<span id="cb2-33"><a href="#cb2-33"></a>robbery_gistar <span class="ot">&lt;-</span> robbery <span class="sc">|&gt;</span></span>
<span id="cb2-34"><a href="#cb2-34"></a>  <span class="fu">hotspot_gistar</span>(<span class="at">cell_size =</span> <span class="dv">100</span>, <span class="at">bandwidth_adjust =</span> <span class="fl">0.25</span>, <span class="at">quiet =</span> <span class="cn">TRUE</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-35"><a href="#cb2-35"></a>  <span class="fu">filter</span>(gistar <span class="sc">&gt;</span> <span class="dv">0</span>, pvalue <span class="sc">&lt;</span> <span class="fl">0.05</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-36"><a href="#cb2-36"></a>  <span class="fu">hotspot_clip</span>(nottingham_wards)</span>
<span id="cb2-37"><a href="#cb2-37"></a></span>
<span id="cb2-38"><a href="#cb2-38"></a><span class="co"># Find clusters using DBSCAN</span></span>
<span id="cb2-39"><a href="#cb2-39"></a></span>
<span id="cb2-40"><a href="#cb2-40"></a>robbery_dbscan <span class="ot">&lt;-</span> <span class="fu">hotspot_dbscan</span>(robbery, <span class="at">density_adjust =</span> <span class="dv">5</span>)</span>
<span id="cb2-41"><a href="#cb2-41"></a></span>
<span id="cb2-42"><a href="#cb2-42"></a><span class="co"># PLOT MAP ---------------------------------------------------------------------</span></span>
<span id="cb2-43"><a href="#cb2-43"></a></span>
<span id="cb2-44"><a href="#cb2-44"></a><span class="co"># Initiate map and add KDE layer for significant hotspots</span></span>
<span id="cb2-45"><a href="#cb2-45"></a><span class="fu">hotspot_map</span>(</span>
<span id="cb2-46"><a href="#cb2-46"></a>  robbery_gistar,</span>
<span id="cb2-47"><a href="#cb2-47"></a>  <span class="at">basemap_type =</span> <span class="st">&quot;cartolight&quot;</span>,</span>
<span id="cb2-48"><a href="#cb2-48"></a>  <span class="at">sign =</span> <span class="st">&quot;hot&quot;</span>,</span>
<span id="cb2-49"><a href="#cb2-49"></a>  <span class="at">caption =</span> <span class="fu">str_glue</span>(</span>
<span id="cb2-50"><a href="#cb2-50"></a>    <span class="st">&quot;Contains public sector information licensed under the Open &quot;</span>,</span>
<span id="cb2-51"><a href="#cb2-51"></a>    <span class="st">&quot;Government Licence v3.0.&quot;</span></span>
<span id="cb2-52"><a href="#cb2-52"></a>  )</span>
<span id="cb2-53"><a href="#cb2-53"></a>) <span class="sc">+</span></span>
<span id="cb2-54"><a href="#cb2-54"></a>  <span class="co"># Add clusters</span></span>
<span id="cb2-55"><a href="#cb2-55"></a>  <span class="fu">hotspot_layer</span>(</span>
<span id="cb2-56"><a href="#cb2-56"></a>    robbery_dbscan,</span>
<span id="cb2-57"><a href="#cb2-57"></a>    <span class="at">col_fill =</span> <span class="st">&quot;none&quot;</span>,</span>
<span id="cb2-58"><a href="#cb2-58"></a>    <span class="at">col_label =</span> <span class="st">&quot;prop&quot;</span>,</span>
<span id="cb2-59"><a href="#cb2-59"></a>    <span class="at">colour =</span> <span class="st">&quot;red2&quot;</span></span>
<span id="cb2-60"><a href="#cb2-60"></a>  ) <span class="sc">+</span></span>
<span id="cb2-61"><a href="#cb2-61"></a>  <span class="co"># Add ward boundaries</span></span>
<span id="cb2-62"><a href="#cb2-62"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> nottingham_wards, <span class="at">colour =</span> <span class="st">&quot;grey70&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-63"><a href="#cb2-63"></a>  <span class="fu">labs</span>(<span class="at">title =</span> <span class="st">&quot;Nottingham robbery hotspots&quot;</span>)</span></code></pre></div>
<figcaption>Code 13.24</figcaption>
</figure>

<a id="in-summary"></a>

## 13.6 In summary

In this chapter we have learned three more-advanced topics for understanding patterns of crime: dual-KDE maps to understand crime risks, Gi\* maps to understand where there is more crime than we'd expect by chance, and DBSCAN maps to understand where crime is concentrated most heavily. You can use these techniques either on their own or in combination, for example by adding DBSCAN cluster labels on top of a KDE surface that has been clipped using Gi\*.

We have practised how to:

- choose a suitable population at risk for a dual KDE;
- prepare crime and denominator data in an appropriate coordinate reference system;
- create and interpret a dual-KDE risk map;
- explain why an apparent pattern on a density map is not necessarily a hotspot;
- identify and map significant hotspots using Gi\* values and their associated \\(p\\)-values; and
- identify the most dense clusters of crime using DBSCAN.

To find out more about the ideas and skills covered in this chapter, you may want to read:

- [a practical guide to understanding and responding to crime hotspots](https://popcenter.asu.edu/content/tool-guides-crime-and-disorder-hot-spots),
- [a recent review of evidence on the concentration of crime at micro places](https://doi.org/10.1016/j.avb.2024.101979), and
- [the introduction to the `sfhotspot` package](https://pkgs.lesscrime.info/sfhotspot/articles/introduction.html).

QuizCheck your knowledge: Revision questions

Answer these questions to check you have understood the main points covered in this chapter. Write between 50 and 100 words to answer each question.

1.  What are crime hotspots, and why are they important in crime analysis?
2.  How do chronic and acute crime hotspots differ?
3.  Why should hotspot analysis focus on small geographic areas rather than larger administrative regions?
4.  What is dual kernel density estimation (dual KDE), and how does it improve crime hotspot analysis?
5.  How can crime hotspot maps be used to inform crime prevention strategies?
