# Issue 76: cross-reference audit

This records replacements and deliberate exceptions for the 2026 book. Source line numbers describe the location at the time of replacement.

## Implemented replacements

| Source | Original wording | Replacement | Reason |
| --- | --- | --- | --- |
| 08_handling_bugs/index.qmd:1007 | ## Using generative AI to help with debugging | ## Using generative AI to help with debugging {#sec-ai-debugging} | Add a stable destination identifier |
| 07_map_context/index.qmd:380 | ## Creating and storing a map | ## Creating and storing a map {#sec-creating-storing-map} | Add a stable destination identifier |
| 09_mapping_areas/index.qmd:474 | ## Making an interactive map | ## Making an interactive map {#sec-interactive-maps} | Add a stable destination identifier |
| 10_messy_data/index.qmd:665 | ## Tidying the content of cells | ## Tidying the content of cells {#sec-tidying-cell-content} | Add a stable destination identifier |
| 10_messy_data/index.qmd:1239 | ## Geocoding locations | ## Geocoding locations {#sec-geocoding} | Add a stable destination identifier |
| 13_mapping_hotspots/index.qmd:573 | ## Finding hotspots using Gi* | ## Finding hotspots using Gi* {#sec-gi-hotspots} | Add a stable destination identifier |
| 14_no_maps/index.qmd:785 | ## Making charts with ggplot2 and ggauto | ## Making charts with ggplot2 and ggauto {#sec-making-charts} | Add a stable destination identifier |
| 15_mapping_time/index.qmd:1033 | ## Showing repeating patterns over time | ## Showing repeating patterns over time {#sec-repeating-time-patterns} | Add a stable destination identifier |
| 15_mapping_time/index.qmd:1297 | ## How to map change over time | ## How to map change over time {#sec-map-change-over-time} | Add a stable destination identifier |
| 16_crime_series/index.qmd:588 | ## Multiple maps | ## Multiple maps {#sec-crime-series-multiple-maps} | Add a stable destination identifier |
| 01_getting_started/index.qmd:235 | more on that in the next chapter | see @sec-your-first-crime-map-viewing-the-data | Clear destination from the surrounding text |
| 01_getting_started/index.qmd:340 | In the next chapter we will produce our first crime map in R. | In @sec-first-map we will produce our first crime map in R. | Clear destination from the surrounding text |
| 01_getting_started/index.qmd:252 | in chapter @sec-bugs | in @sec-bugs | Clear destination from the surrounding text |
| 02_your_first_crime_map/index.qmd:124 | For example, in the next section we will see some permanent code that loads some crime data. | For example, in @sec-load-data we will see some permanent code that loads some crime data. | Clear destination from the surrounding text |
| 02_your_first_crime_map/index.qmd:239 | We will come back to the pipe operator later, because it is important but can be hard to understand. | We will explore the pipe operator in @sec-pipe-operator, because it is important but can be hard to understand. | Clear destination from the surrounding text |
| 02_your_first_crime_map/index.qmd:239 | we will come back to the details later. | see @sec-pipe-operator when you are ready to explore the details. | Clear destination from the surrounding text |
| 02_your_first_crime_map/index.qmd:756 | In the following chapters, we will build the data-wrangling skills needed to work with larger datasets before returning to crime mapping in more detail. | In @sec-wrangling-data and @sec-transforming-data, we will build the data-wrangling skills needed to work with larger datasets before returning to crime mapping in @sec-second-map. | Clear destination from the surrounding text |
| 03_data_wrangling/index.qmd:30 | **Over the next five chapters, we will learn all the skills needed to make a good crime map in R.** | **From @sec-wrangling-data to @sec-map-context, we will learn all the skills needed to make a good crime map in R.** | Clear destination from the surrounding text |
| 03_data_wrangling/index.qmd:475 | the `agg_assault_data` we loaded in the previous section | the `agg_assault_data` we loaded in @sec-data-wrangling-loading-excel-data | Clear destination from the surrounding text |
| 03_data_wrangling/index.qmd:488 | In a previous section, we mentioned that | In @sec-data-wrangling-functions, we mentioned that | Clear destination from the surrounding text |
| 04_transforming_data/index.qmd:42 | extend copies of the Chapter 3 scripts | extend copies of the scripts from @sec-wrangling-data | Clear destination from the surrounding text |
| 04_transforming_data/index.qmd:46 | load data using the Chapter 3 code | load data using the code from Loading and selecting data | Plain text in an accessible diagram description; hyperlinks cannot render inside aria-label |
| 04_transforming_data/index.qmd:52 | using the code from Chapter 3 | using the code from @sec-wrangling-data | Clear destination from the surrounding text |
| 05_your_second_crime_map/index.qmd:422 | In the previous section, we downloaded the Vancouver theft data | In @sec-your-second-crime-map-reading-spatial-data, we downloaded the Vancouver theft data | Clear destination from the surrounding text |
| 05_your_second_crime_map/index.qmd:538 | the `pacman::p_load()` function as we have done in previous chapters. | the `pacman::p_load()` function introduced in @sec-loading-packages. | Clear destination from the surrounding text |
| 05_your_second_crime_map/index.qmd:1053 | This creates a blank canvas for the next chapter. | This creates a blank canvas for @sec-mapping-patterns. | Clear destination from the surrounding text |
| 05_your_second_crime_map/index.qmd:1020 | In chapter @sec-mapping-patterns | In @sec-mapping-patterns | Clear destination from the surrounding text |
| 06_mapping_crime_patterns/index.qmd:108 | In Chapter 5 you created | In @sec-second-map you created | Clear destination from the surrounding text |
| 06_mapping_crime_patterns/index.qmd:863 | As we did for the theft data in Chapter 5 | As we did for the theft data in @sec-your-second-crime-map-reading-spatial-data | Clear destination from the surrounding text |
| 07_map_context/index.qmd:500 | the code we used in one of the previous chapters to make a map of bike theft in Vancouver | the code we used in @sec-kde to make a map of bike theft in Vancouver | Clear destination from the surrounding text |
| 08_handling_bugs/index.qmd:32 | We'll come back to using AI to help us fix bugs in our code later in this chapter. | We'll explore using AI to help us fix bugs in our code in @sec-ai-debugging. | Clear destination from the surrounding text |
| 08_handling_bugs/index.qmd:690 | we have used the `head()` function so often in previous chapters | we have used the `head()` function so often, starting in @sec-naming-objects | Clear destination from the surrounding text |
| 08_handling_bugs/index.qmd:872 | because we downloaded it in a previous chapter | because we downloaded it in @sec-creating-storing-map | Clear destination from the surrounding text |
| 09_mapping_areas/index.qmd:25 | In previous chapters we have produced maps based on the locations of individual crimes, either showing the individual locations directly on a point map or showing patterns derived from the individual points on a density map. | In @sec-second-map we produced a point map showing the locations of individual crimes, and in @sec-kde we produced a density map showing patterns derived from those individual points. | Clear destination from the surrounding text |
| 09_mapping_areas/index.qmd:457 | But in the next section, we will learn how to make interactive crime maps. | But in @sec-interactive-maps, we will learn how to make interactive crime maps. | Clear destination from the surrounding text |
| 10_messy_data/index.qmd:602 | In the next section, we'll learn how to tidy the content of individual cells. | In @sec-tidying-cell-content, we'll learn how to tidy the content of individual cells. | Clear destination from the surrounding text |
| 10_messy_data/index.qmd:927 | In the geocoding example later in this chapter | In the example in @sec-geocoding | Clear destination from the surrounding text |
| 10_messy_data/index.qmd:1125 | which we will learn more about in the next section | which we will learn more about in @sec-geocoding | Clear destination from the surrounding text |
| 13_mapping_hotspots/index.qmd:463 | You might recall from earlier in this chapter that | You might recall from @sec-mapping-hotspots-calculating-dual-kernel-density that | Clear destination from the surrounding text |
| 13_mapping_hotspots/index.qmd:974 | the same robbery data as in the previous section | the same robbery data as in @sec-gi-hotspots | Clear destination from the surrounding text |
| 14_no_maps/index.qmd:449 | The table we created in the last section | The table we created in @sec-no-maps-making-data-wider-for-presentation | Clear destination from the surrounding text |
| 14_no_maps/index.qmd:735 | In the next section, we will learn to create a bar chart in R | In @sec-making-charts, we will learn to create a bar chart in R | Clear destination from the surrounding text |
| 14_no_maps/index.qmd:1138 | functions like `scale_fill_distiller()` in previous chapters | functions like `scale_fill_distiller()` in @sec-map-colour | Clear destination from the surrounding text |
| 14_no_maps/index.qmd:1398 | As we explored in previous chapters, density estimation | As we explored in @sec-mapping-crime-patterns-fine-tuning-cell-size-and-bandwidth, density estimation | Clear destination from the surrounding text |
| 15_mapping_time/index.qmd:1303 | As we saw in the previous section, the peaks | As we saw in @sec-repeating-time-patterns, the peaks | Clear destination from the surrounding text |
| 15_mapping_time/index.qmd:1364 | In a previous chapter we learned how to do this using the sfhotspot package. | In @sec-kde we learned how to do this using the sfhotspot package. | Clear destination from the surrounding text |
| 15_mapping_time/index.qmd:1676 | all of it is code we have seen earlier in this chapter. | it builds on the code from @sec-map-change-over-time. | Clear destination from the surrounding text |
| 16_crime_series/index.qmd:453 | We will deal with this in the next section. | We will deal with this in @sec-crime-series-multiple-maps. | Clear destination from the surrounding text |
| 16_crime_series/index.qmd:459 | The purpose of those changes will become clear in the next section. | The purpose of those changes will become clear in @sec-crime-series-multiple-maps. | Clear destination from the surrounding text |
| 16_crime_series/index.qmd:539 | in the next section we will learn how to solve | in @sec-crime-series-multiple-maps we will learn how to solve | Clear destination from the surrounding text |
| 16_crime_series/index.qmd:693 | the `hungerford_map_overall` object in the previous section | the `hungerford_map_overall` object in @sec-crime-series-adding-arrows-and-curves | Clear destination from the surrounding text |
| 16_crime_series/index.qmd:341 | This map is not particularly useful -- we will return to that in a minute. | This map is not particularly useful -- we will improve it in @sec-crime-series-extending-the-map-area and @sec-crime-series-adding-arrows-and-curves. | Clear destination from the surrounding text |
| 07_map_context/index.qmd:6 | In previous chapters we've learned how to make maps of crime data. | In @sec-second-map and @sec-mapping-patterns we've learned how to make maps of crime data. | Author approved A |
| 11_writing_reports/index.qmd:6 | In previous chapters we've learned how to make crime maps, | In @sec-second-map and @sec-mapping-patterns we've learned how to make crime maps, | Author approved A |
| 14_no_maps/index.qmd:789 | In previous chapters, all the visualisations we have created have been maps made with `hotspot_map()` and refined with functions from the ggplot2 package. | In @sec-other-layers and @sec-map-context, we created maps with `hotspot_map()` and refined them with functions from the ggplot2 package. | Author approved A |
| 15_mapping_time/index.qmd:1885 | other maps we have created in previous chapters | the static maps we created in @sec-map-change-over-time | Author approved A |
| 10_messy_data/index.qmd:527 | We still need to clean up the footnote numbers that appear in some of the values, but we will deal with that later in this chapter. | Some values still contain footnote numbers. We will learn techniques for cleaning text in @sec-tidying-cell-content. | Author approved C; later examples do not clean these specific footnotes |
| 16_crime_series/index.qmd:359 | We have used the `scale_fill_distiller()` and `scale_fill_gradient()` functions in previous chapters to control how columns in the data are represented as colours on the map. | We used the `scale_fill_distiller()` function in @sec-map-colour to control how columns in the data are represented as colours on the map. | Author approved D; scale_fill_gradient() is not explicitly taught |
| 04_transforming_data/index.qmd:369 | There are corresponding write functions for other types of data (which we will come back to when we learn how to handle spatial data), | There are corresponding write functions for other types of data, | Author approved E; no later teaching section found |
| 04_transforming_data/index.qmd:102 | the `date` variable (which may sometimes be useful, as shown in the next section) | the `date` variable | Author approved F; the next section does not demonstrate this |
| 02_your_first_crime_map/index.qmd:602 | In future chapters we'll learn much more about how to make customised maps, | In @sec-other-layers and @sec-map-context we'll learn much more about how to make customised maps, | Clear destination from the surrounding text |
| 06_mapping_crime_patterns/index.qmd:371 | sfhotspot also has other useful functions that we will use in future chapters. | sfhotspot also has other useful functions that we will use in @sec-mapping-hotspots. | Clear destination from the surrounding text |
| 16_crime_series/index.qmd:596 | In @sec-small-multiple we created small-multiple maps with `facet_grid()`, | In @sec-map-change-over-time we created small-multiple maps with `facet_grid()`, | Correct an existing link to charts so it points to the actual small-multiple map example |

## Author decisions

- A approved: broad recaps in chapters 7 and 11 → Your second crime map / Mapping crime patterns; chapter 14 → Adding more layers / Giving a map context; chapter 15 → How to map change over time.
- B retained unchanged at the author’s request: chapter 6’s “Over the next few chapters” preview of ggplot2 refinement.
- C approved: replace the unsupported promise to clean this dataset’s footnote numbers with a link to general text-cleaning techniques.
- D approved: link the chapter 16 colour-scale recap to Using colour to show density and mention only the explicitly taught scale_fill_distiller().
- E approved: remove the promise of later instruction in spatial-data write functions; retain the general statement that such functions exist.
- F approved: remove the claim that the next section demonstrates dropping times from dates.

## Deliberate exceptions

- Chapter 1: “instructions in later chapters” and help in “subsequent chapters” describe general benefits and reassurance; neither has a single destination.
- Chapter 2: reassurance that unfamiliar code will be revisited is general teaching guidance. Specific promises about pipes and customising maps now link to their sections.
- Chapters 3 and 4: “future chapters” promises more practice with filter() and the pipe, rather than identifying a specific passage.
- Chapter 3: “steps you used earlier” means repeat the immediately preceding file-creation procedure; it does not name a chapter or section.
- Chapter 5 and chapter 12: broad references already accompanied by explicit cross-references in the same sentence or paragraph.
- Chapter 15 image alternative text: describes the image and its relationship to later static maps. Cross-reference markup cannot create a hyperlink inside an alt attribute.
- contents.qmd: existing chapter navigation already provides informative hyperlinks; displayed chapter numbers are outside the vague-reference replacement.
- External references (such as Chapter 1 of Spatial Data Science) retain their existing external hyperlinks.
- Immediate “above” and “below” instructions pointing to adjacent code, notes, tables or results remain local reading instructions.

## Validation

- Existing book-label checker passes.
- All fenced code blocks in the 15 edited chapters are unchanged against HEAD.
- All 232 prose section cross-references resolve to 149 unique source anchors.
- Fresh full-book execution stopped at a data download because mpjashby.github.io could not be resolved.
- A temporary copy uses existing frozen analytical outputs with the audited prose replacements applied to the frozen Markdown. This checks current cross-reference rendering without claiming fresh analytical execution.
- The complete 25-document HTML book renders successfully using frozen analytical outputs in the temporary copy.
- Checked all 282 rendered local cross-reference links across 30 HTML pages: destination files and fragment anchors exist, labels are resolved, and every newly introduced reference is present in the rendered output. Chapter references correctly link to the top of the destination page without a fragment.
- Source diff whitespace checks pass.
