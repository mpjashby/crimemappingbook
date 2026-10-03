# Numbered listing reference audit

This follow-up to issue 76 replaces positional references to code with Quarto listing cross-references. Source locations describe the time of replacement.

## Changes

| Source | Original wording | Replacement | Decision |
| --- | --- | --- | --- |
| 11_writing_reports/index.qmd:144 | Previously unnumbered displayed teaching example | lst-reports-markdown-example | Give the displayed teaching example a numbered listing without altering its code |
| 11_writing_reports/index.qmd:505 | Previously unnumbered displayed teaching example | lst-reports-inline-date-example | Give the displayed teaching example a numbered listing without altering its code |
| 11_writing_reports/index.qmd:528 | Previously unnumbered displayed teaching example | lst-reports-count-homicides-example | Give the displayed teaching example a numbered listing without altering its code |
| 11_writing_reports/index.qmd:559 | Previously unnumbered displayed teaching example | lst-reports-visible-code-example | Give the displayed teaching example a numbered listing without altering its code |
| 11_writing_reports/index.qmd:589 | Previously unnumbered displayed teaching example | lst-reports-hidden-code-example | Give the displayed teaching example a numbered listing without altering its code |
| 11_writing_reports/index.qmd:630 | Previously unnumbered displayed teaching example | lst-reports-setup-example | Give the displayed teaching example a numbered listing without altering its code |
| 11_writing_reports/index.qmd:746 | Previously unnumbered displayed teaching example | lst-reports-figure-reference-example | Give the displayed teaching example a numbered listing without altering its code |
| 01_getting_started/index.qmd:320 | paste the following code to the right of the prompt arrow | paste @lst-getting-started-enable-air-formatting to the right of the prompt arrow | Clear destination from the surrounding text |
| 02_your_first_crime_map/index.qmd:177 | Copy the code below and paste it | Copy @lst-your-first-crime-map-script-02a-packages and paste it | Clear destination from the surrounding text |
| 02_your_first_crime_map/index.qmd:306 | Check the code matches what is written above | Check the code matches @lst-your-first-crime-map-head-homicides | Clear destination from the surrounding text |
| 02_your_first_crime_map/index.qmd:629 | changing various parts of the code above | changing various parts of @lst-your-first-crime-map-script-02a-map | Clear destination from the surrounding text |
| 03_data_wrangling/index.qmd:100 | If we typed the following code into the R Console | If we typed @lst-data-wrangling-calculate-square-root into the R Console | Clear destination from the surrounding text |
| 03_data_wrangling/index.qmd:354 | Add the following code, then place the cursor | Add @lst-data-wrangling-script-03b-download, then place the cursor | Clear destination from the surrounding text |
| 03_data_wrangling/index.qmd:599 | When you run the code above, the result | When you run @lst-data-wrangling-filter-convenience-store-assaults, the result | Clear destination from the surrounding text |
| 04_transforming_data/index.qmd:246 | the same thing as in the code above | the same thing as in @lst-transforming-data-count-rows-with-summarise | Clear destination from the surrounding text |
| 04_transforming_data/index.qmd:431 | look at the code and the list below that explains what each line does | look at @lst-transforming-data-weekday-counts-pipeline and its numbered explanations | Clear destination from the surrounding text |
| 04_transforming_data/index.qmd:431 | in the explanation below the code | in the explanations accompanying @lst-transforming-data-weekday-counts-pipeline | Clear destination from the surrounding text |
| 05_your_second_crime_map/index.qmd:450 | The file paths above can be read | The file paths in @lst-your-second-crime-map-macos-absolute-path-example and @lst-your-second-crime-map-windows-absolute-path-example can be read | Clear destination from the surrounding text |
| 05_your_second_crime_map/index.qmd:452 | The two file paths shown above are called | The file paths in @lst-your-second-crime-map-macos-absolute-path-example and @lst-your-second-crime-map-windows-absolute-path-example are called | Clear destination from the surrounding text |
| 05_your_second_crime_map/index.qmd:452 | either of the file paths above | either of those file paths | Clear destination from the surrounding text |
| 05_your_second_crime_map/index.qmd:535 | Add the code above to the `chapter_05.R` file | Add @lst-your-second-crime-map-script-05-clean-names to the `chapter_05.R` file | Clear destination from the surrounding text |
| 06_mapping_crime_patterns/index.qmd:881 | Add the following code after the pipeline that loads | Add @lst-mapping-crime-patterns-script-06-load-boundaries after the pipeline that loads | Clear destination from the surrounding text |
| 07_map_context/index.qmd:943 | run the following code in the R Console | run @lst-map-context-add-title in the R Console | Clear destination from the surrounding text |
| 07_map_context/index.qmd:1077 | The following code changes the colour of the caption text | @lst-map-context-format-caption changes the colour of the caption text | Clear destination from the surrounding text |
| 07_map_context/index.qmd:1111 | Make sure you run this code, since we will need it for the rest of the code below. | Make sure you run @lst-map-context-store-titled-map, since the remaining examples use the object it creates. | Clear destination from the surrounding text |
| 08_handling_bugs/index.qmd:583 | re-run the code above -- it should now run | re-run @lst-handling-bugs-filter-misspelt-offence-column -- it should now run | Clear destination from the surrounding text |
| 08_handling_bugs/index.qmd:587 | Fix the typo and re-run the code above in Positron. | Fix the typo and re-run @lst-handling-bugs-filter-misspelt-offence-column in Positron. | Clear destination from the surrounding text |
| 08_handling_bugs/index.qmd:610 | Re-run the code above, but comment out | Re-run @lst-handling-bugs-isolate-fraud-filter, but comment out | Clear destination from the surrounding text |
| 08_handling_bugs/index.qmd:642 | The following code runs without an error: | @lst-handling-bugs-filter-impersonation-frauds runs without an error: | Clear destination from the surrounding text |
| 08_handling_bugs/index.qmd:666 | the following pipeline omits the step | the pipeline in @lst-handling-bugs-transform-nonspatial-data-error omits the step | Clear destination from the surrounding text |
| 08_handling_bugs/index.qmd:745 | then paste the following code into it: | then paste @lst-handling-bugs-show-chapter-08-error-script into it: | Clear destination from the surrounding text |
| 08_handling_bugs/index.qmd:860 | Even though we have removed most of the previous code, this shorter code still produces the same error message. | Even though we have removed most of @lst-handling-bugs-script-08-error-highlighted, the shorter code in @lst-handling-bugs-show-minimal-bronx-error still produces the same error message. | Clear destination from the surrounding text |
| 08_handling_bugs/index.qmd:922 | the three-line minimal working example above | the three-line minimal working example in @lst-handling-bugs-script-08-minimal | Clear destination from the surrounding text |
| 08_handling_bugs/index.qmd:1163 | On line 3 of the code below, | On line 3 of @lst-handling-bugs-show-ai-code-error, | Clear destination from the surrounding text |
| 08_handling_bugs/index.qmd:1165 | on line 3 of the code below, | on line 3 of @lst-handling-bugs-show-ai-code-error, | Clear destination from the surrounding text |
| 08_handling_bugs/index.qmd:1243 | The corrected complete script from the reprex exercise is shown below. | The corrected complete script from the reprex exercise is shown in @lst-handling-bugs-complete-script. | Clear destination from the surrounding text |
| 08_handling_bugs/index.qmd:688 | We used this technique above to find that `filter()` | We used this technique in @lst-handling-bugs-inspect-fraud-filter to find that `filter()` | Clear destination from the surrounding text |
| 09_mapping_areas/index.qmd:486 | Paste the following code into `chapter_09b.R` | Paste @lst-mapping-areas-script-09b-prepare into `chapter_09b.R` | Clear destination from the surrounding text |
| 09_mapping_areas/index.qmd:712 | in the code below we'll call it `murder_colours` | in @lst-mapping-areas-script-09b-count-palette we'll call it `murder_colours` | Clear destination from the surrounding text |
| 09_mapping_areas/index.qmd:1028 | in place of the previous code that joined together the `districts` and `murders` datasets | in place of @lst-mapping-areas-script-09b-initial-join, which joined together the `districts` and `murders` datasets | Clear destination from the surrounding text |
| 09_mapping_areas/index.qmd:1067 | the code from our previous interactive map | the code from our interactive map in @lst-mapping-areas-script-09b-count-map | Clear destination from the surrounding text |
| 11_writing_reports/index.qmd:176 | the unformatted Markdown text in the example above | the unformatted Markdown text in @lst-reports-markdown-example | Clear destination from the surrounding text |
| 11_writing_reports/index.qmd:521 | the inline R code above _must_ | the inline R code in @lst-reports-inline-date-example _must_ | Clear destination from the surrounding text |
| 11_writing_reports/index.qmd:586 | If we change the code in our previous example | If we change the code in @lst-reports-visible-code-example | Clear destination from the surrounding text |
| 11_writing_reports/index.qmd:628 | Add the following setup chunk to `chapter_11.qmd`. | Add the setup chunk in @lst-reports-setup-example to `chapter_11.qmd`. | Clear destination from the surrounding text |
| 11_writing_reports/index.qmd:774 | For example, in the code above you can see | For example, in @lst-reports-figure-reference-example you can see | Clear destination from the surrounding text |
| 11_writing_reports/index.qmd:774 | Just above that code chunk, the figure produced by that chunk is referenced | In the same listing, just before the code chunk, the figure produced by that chunk is referenced | Clear destination from the surrounding text |
| 12_place_data/index.qmd:368 | reading the code above is how did we know | reading @lst-place-data-script-12-metro is how did we know | Clear destination from the surrounding text |
| 12_place_data/index.qmd:381 | the `metro_lines_dir` path we created above | the `metro_lines_dir` path we created in @lst-place-data-script-12-metro | Clear destination from the surrounding text |
| 12_place_data/index.qmd:723 | The code in the exercise above, for example, cites | The code in @lst-place-data-script-12-map, for example, cites | Clear destination from the surrounding text |
| 14_no_maps/index.qmd:662 | Looking at the code below, | Looking at @lst-no-maps-script-14a-table, | Clear destination from the surrounding text |
| 14_no_maps/index.qmd:944 | some aspects of the code above that we haven't already covered | some aspects of @lst-bar-chart-ggplot that we haven't already covered | Clear destination from the surrounding text |
| 15_mapping_time/index.qmd:1029 | In the code above, we use `aes()` | In @lst-mapping-time-plot-assault-moving-average, we use `aes()` | Clear destination from the surrounding text |
| 15_mapping_time/index.qmd:1491 | The extra code is explained in the notes immediately below the next chunk of code. | The extra code in @lst-mapping-time-map-kde-by-shift is explained in the accompanying notes. | Clear destination from the surrounding text |
| 15_mapping_time/index.qmd:1541 | Add the following complete code to the end of `chapter_15a.R` | Add @lst-mapping-time-map-highest-kde-by-shift to the end of `chapter_15a.R` | Clear destination from the surrounding text |
| 15_mapping_time/index.qmd:1889 | the map created above in an object | the map created in @lst-mapping-time-build-animated-assault-map in an object | Clear destination from the surrounding text |
| 16_crime_series/index.qmd:822 | The complete script below contains everything | The complete script in @lst-crime-series-show-chapter-16-script contains everything | Clear destination from the surrounding text |
| setup.qmd:201 | Copy and paste the following code to the right of the `>` symbol | Copy and paste @lst-setup-install-book-packages to the right of the `>` symbol | Clear destination from the surrounding text |
| 08_handling_bugs/index.qmd:359 | the `frauds` dataset we loaded earlier | the `frauds` dataset we loaded in @lst-handling-bugs-load-fraud-examples | Clear destination from the surrounding text |
| 08_handling_bugs/index.qmd:587 | you can see the US spelling in the line of code above the line that is causing the error | you can see the US spelling in the `select()` call in @lst-handling-bugs-filter-misspelt-offence-column | Clear destination from the surrounding text |
| 09_mapping_areas/index.qmd:680 | Fortunately, you can use the following code as a template for creating interactive choropleth maps in future. | Fortunately, you can use @lst-mapping-areas-script-09b-count-palette as a template for creating interactive choropleth maps in future. | Clear destination from the surrounding text |
| 12_place_data/index.qmd:327 | Add this code to your `chapter_12.R` script file. Read through the notes below this code | Add @lst-place-data-script-12-metro to your `chapter_12.R` script file. Read through its accompanying notes | Clear destination from the surrounding text |
| 13_mapping_hotspots/index.qmd:974 | Read the two notes below this code, which explain | Read the two notes accompanying @lst-mapping-hotspots-script-13c-prepare, which explain | Clear destination from the surrounding text |
| 14_no_maps/index.qmd:897 | Look through this code and the explanations below it. | Look through @lst-bar-chart-ggplot and its accompanying explanations. | Clear destination from the surrounding text |
| 15_mapping_time/index.qmd:977 | Add this code to the `chapter_15a.R` file and run it. You can see we are also adding some other functions to the `ggplot()` stack, which are explained in the notes below the code. | Add @lst-mapping-time-plot-assault-moving-average to the `chapter_15a.R` file and run it. You can see we are also adding some other functions to the `ggplot()` stack, which are explained in the accompanying notes. | Clear destination from the surrounding text |
| 16_crime_series/index.qmd:300 | The extra code is explained in the notes below the code chunk. | The extra code in @lst-crime-series-draw-hungerford-shootings-straight-lines is explained in the accompanying notes. | Clear destination from the surrounding text |
| 11_writing_reports/index.qmd:624 | You might have noticed in the code above that instead | You might have noticed in @lst-reports-hidden-code-example that instead | Author chose the earlier complete report example for case 1 |
| 08_handling_bugs/index.qmd:823 | That means we can remove:  1. The comments (lines 1, 4, 10, 14, 18, 21 and 29, above). 2. The code that wrangles the shootings data in ways that don't affect this particular error (lines 7, 9 and 11--12). 3. The code that loads and wrangles the precinct boundaries (lines 15--19). 4. The code that fine-tunes the appearance of the map (lines 25--27 and 30--38).  We cannot remove the code that loads necessary packages (line 2), loads the data (lines 5--6) or produces the basic unformatted map (lines 22--24 and 28), because if we remove any of those lines then you will see the error message either changes to a different error message, or disappears. | That means we can remove these parts of @lst-handling-bugs-script-08-error-highlighted:  1. The comments. 2. The code that wrangles the shootings data in ways that don't affect this particular error. 3. The code that loads and wrangles the precinct boundaries. 4. The code that fine-tunes the appearance of the map.  We cannot remove the code that loads necessary packages, loads the shootings data and converts it to an SF object, or produces the basic unformatted map. These are the highlighted lines in @lst-handling-bugs-script-08-error-highlighted. If we remove any of those lines, the error message either changes to a different error message or disappears. | Author approved case 2: listing reference and purpose-based descriptions instead of stale line numbers |
| 13_mapping_hotspots/index.qmd:380 | some of the buildings returned by the code above | some of the buildings returned by @lst-mapping-hotspots-script-13a-buildings | Author chose the fetching listing for case 3 |
| 11_writing_reports/index.qmd:547 | For example, we could label the chunk above by adding `#\| label: count-all-crimes`. | For example, the chunk in @lst-reports-count-homicides-example already has the label `count-homicides`, specified by `#\| label: count-homicides`. | Author approved case 4: explain the existing label without changing the code |

## Separate author decisions

1. Writing reports, read_csv2(): author chose the earlier complete report example. The reference points to the version that suppresses code in the rendered report, immediately before the YAML discussion.
2. Handling bugs, removal checklist: author approved linking to the highlighted script and describing removable code by purpose instead of retaining stale line numbers.
3. Mapping hotspots, bounding-box explanation: author chose the listing that fetches buildings, rather than the inspection or plotting listing.
4. Writing reports, example chunk label: author approved explaining the existing count-homicides label rather than asking students to add a different label.

## Deliberate exceptions

- Physical placement within code (comments above a statement, chunk options below an opening fence, or lines before/after an error) is an instruction about code structure, rather than a reference to another listing.
- Spatial placement within maps, diagrams, tables and the Positron interface remains unchanged.
- Inline quiz examples include the code in the question itself and do not need a separate destination.
- References to accompanying notes and explanations now identify the relevant listing; the notes themselves are not code listings.
- General references to previous scripts or earlier steps are retained where no individual chunk is being identified. Existing section links remain useful for wider concepts.
- References to an output preview remain output references; an embedded report preview is not a numbered code listing.
- Code comments, image alternative text, quoted example prompts, and supporting example reports retain their literal text.
- Chapter 6’s broad future-chapter preview remains unchanged, as requested in the first pass.

## Validation

- The existing book-label check passes.
- Code block content is unchanged compared with the source captured at the beginning of this follow-up task. The seven new listing wrappers sit outside existing fences, preserving all code and chunk options.
- All prose section/listing references have unique source targets.
- Render validation uses current prose and the existing frozen analytical outputs in an isolated temporary copy; the preceding task established that fresh data downloads cannot resolve their hostname in this environment. Unused teaching assets and downloadable raw data are excluded from that temporary validation copy to conserve disk space.
- The complete 25-document HTML book rendered successfully in the temporary copy.
- All 347 rendered local cross-reference links across 30 HTML pages resolve to existing files and anchors; every new listing reference is present in the HTML.
- The seven newly numbered report examples render as Code 11.1 through Code 11.7 with the expected hyperlink destinations.
- Source diff whitespace checks pass.
