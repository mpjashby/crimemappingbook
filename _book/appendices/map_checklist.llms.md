Source: https://books.lesscrime.info/learncrimemapping/appendices/map_checklist.html

<a id="quarto-document-content"></a>
<a id="title-block-header"></a>
<a id="appendix-b-checklist-making-a-good-crime-map"></a>

# `<a id="sec-good-map-checklist"></a>`{=html}Appendix B --- Checklist: Making a good crime map

Whenever you make a crime map, use this checklist to make sure your map is likely to be useful to the people you are making it for.

<a id="have-you-chosen-the-best-type-of-map-for-this-particular-purpose"></a>

#### 1. Have you chosen the best type of map *for this particular purpose*?

Different maps are used for different purposes:

- To understand *patterns* or concentrations of crime, use a density map ([Chapter 6](../06_mapping_crime_patterns/index.llms.md)) or hotspot map ([Chapter 13](../13_mapping_hotspots/index.llms.md)).
- To understand crime *rates*, use a choropleth map ([Chapter 9](../09_mapping_areas/index.llms.md)) or a dual kernel density map ([Chapter 13](../13_mapping_hotspots/index.llms.md)).
- To show the exact locations of a *small number* of incidents, use a point map ([Chapter 5](../05_your_second_crime_map/index.llms.md)).
- To show events in a crime series, use a crime-series map ([Chapter 16](../16_crime_series/index.llms.md)).
- To show how patterns of crime have changed over time, use small-multiple or animated maps ([Chapter 15](../15_mapping_time/index.llms.md)).

<a id="does-the-map-have-an-appropriate-visual-hierarchy"></a>

#### 2. Does the map have an appropriate visual hierarchy?

The crime events or patterns you are trying to communicate should always be the most visually prominent element on a map, to help readers focus on what is most important. The rest of the elements on the map should follow the visual hierarchy set out in [Section 7.3](../07_map_context/index.llms.md#sec-visual-hierarchy).

<a id="is-everything-on-the-map-clearly-legible"></a>

#### 3. Is everything on the map clearly legible?

Make sure that all the elements of your map are clearly legible, and that there is enough contrast between text and background to make the text easy to read.

<a id="is-the-language-used-in-the-map-text-appropriate-for-the-audience"></a>

#### 4. Is the language used in the map text appropriate for the audience?

All the text on a map should use language that can be easily understood by the audience that specific map is being made for. Many map users are busy people who need to make decisions quickly, so it's important that they can easily grasp what information a map is communicating. In particular, make sure you avoid using cartographic jargon such as 'kernel density' or 'choropleth' -- most people don't know these terms.

<a id="does-the-map-include-layers-of-of-supporting-information"></a>

#### 5. Does the map include layers of of supporting information?

Maps will generally communicate more effectively if the audience understands where in a city or neighbourhood crime points or hotspots are. Effective maps almost always have an appropriate *base map* ([Section 7.7](../07_map_context/index.llms.md#sec-base-maps)) underneath the data layer(s). Make sure the base map helps the audience focus on the points or patterns the map is about by not being so colourful or complicated that it is distracting. Remember that any filled layers on top of a base map might need to be semi-transparent so that the audience can see both the data and the base map underneath.

Many maps also benefit from including extra layers of data such as relevant boundaries ([Section 6.6](../06_mapping_crime_patterns/index.llms.md#sec-other-layers)) for administrative or other areas. It may also be useful to highlight of facilities that are relevant to a particular crime or other issue ([Chapter 12](../12_place_data/index.llms.md)).

<a id="does-the-map-have-a-declarative-title"></a>

#### 6. Does the map have a declarative title?

Maps should have a title that summarises in a single sentence the point you think it is most important that the audience understands. A declarative title like this is almost always better than a descriptive title ([Section 7.8](../07_map_context/index.llms.md#sec-titles)).

<a id="does-the-legend-explain-how-to-interpret-data-driven-elements-of-the-map"></a>

#### 7. Does the legend explain how to interpret data-driven elements of the map?

Most maps need a legend (or even more than one), unless each point on the map is labelled directly. Make sure the title of each legend explains how to interpret each of the data-driven elements of the map. For example, if the map uses colour to show concentrations of a particular type of crime, make sure the legend title explains this.

<a id="does-the-map-comply-with-any-legal-requirements"></a>

#### 8. Does the map comply with any legal requirements?

Many sources of data that you might use to make maps impose a legal requirement that any maps made using that data must include an acknowledgement of the data source ([Section 7.8.2](../07_map_context/index.llms.md#sec-captions)). Usually the best place to add data attribution statements is the map caption, since while this information is legally required it does not need to be high on the visual hierarchy.

<a id="does-the-map-convey-information-using-the-least-ink-possible"></a>

#### 9. Does the map convey information using the least ink possible?

Maps often contain a lot of information, so it is easy for a map to become cluttered and that make the main message harder to understand. Convey each piece of information using the minimum 'ink' possible, e.g. by removing unnecessary borders around boxes. Make sure every piece of information you add to a map is going to help the audience understand the main message -- if it doesn't help, don't put it on the map.

<a id="does-the-map-say-who-made-it"></a>

#### 10. Does the map say who made it?

Understanding who made a document is an important part of working out whether to trust the contents. For example if you read a news story or an academic journal article, you might look at the name of the author as part of deciding how trustworthy the contents is likely to be. The same is true for a map, so a map should generally include the name of either the individual or organisation that made the map ([Section 7.8.2](../07_map_context/index.llms.md#sec-captions)). This is generally not necessary, though, if the map is going to be included in a report or larger document by the same authors.

<a id="does-the-map-state-when-it-was-made"></a>

#### 11. Does the map state when it was made?

Data changes over time, so it is often important to make it clear when the map was made and/or what period of time the map data relates to. This might be included in the sub-title of the map, or in the caption.

<a id="does-the-map-need-a-scale-bar"></a>

#### 12. Does the map need a scale bar?

Not all maps need a scale bar ([Section 7.9](../07_map_context/index.llms.md#sec-scale-bars)), but you should include a scale bar if the audience is likely to need to understand distances between places on the map. This might be important if, for example, the audience might need to understand how large a crime hotspot is. If you do include a scale bar, make sure it is low on the visual hierarchy so that it does not distract from the main message of the map.

<a id="does-the-map-need-a-north-arrow"></a>

#### 13. Does the map need a north arrow?

Most crime maps don't need a north arrow ([Section 7.9.2](../07_map_context/index.llms.md#sec-north-arrows)), since it's unlikely that the audience will be using a crime map for navigation. Crime maps *do* need a north arrow, however, if navigation is important to the purpose of the map or if the map does not follow the convention of having north at the top of the map. If a north arrow is included, it should be low on the visual hierarchy.

<a id="have-you-checked-your-spelling"></a>

#### 14. Have you checked your spelling?

Check all the text on the map for spelling and grammar mistakes.
