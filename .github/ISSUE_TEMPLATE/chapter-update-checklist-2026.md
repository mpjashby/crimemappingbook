---
name: Chapter update checklist 2026
about: Checklist for updating each chapter for the 2026 edition
title: Update Chapter [CHAP] for 2026
labels: chapter update checklist
assignees: mpjashby

---

### LLM-assisted checks
- [ ] Check 'Before you start' callout gives current Positron instructions.
- [ ] `Cmd+F` "`RStudio`"
- [ ] Replace RStudio-specific instructions, e.g. menu names, shortcuts
- [ ] Replace RStudio screenshots
- [ ] Add bullet-point list of skills to be learned in this chapter.
- [ ] Add flow diagram showing process of producing code.
- [ ] Add instructions for putting code in a specific named file for each analysis.
- [ ] Use kbd shortcodes e.g. `press {{< kbd win=Ctrl-Enter mac=Command-Return >}}` for button presses.
- [ ] Replace use of or reference to `st_intersection()` with `hotspot_clip()` or use `st_join()` if columns from `y` are needed.
- [ ] Check chapter begins with the finished map, chart or other intended output where appropriate.
- [ ] Run every executable code chunk and fix any errors.
- [ ] Add accurate alt text to every `<img>` element.
- [ ] Add `fig-alt` to figures produced directly by executable R chunks.
- [ ] Check chunk attributes are provided in Quarto not Rmarkdown style -- `Cmd+F` "`{r `" to check.
- [ ] Reduce unnecessarily large image files using `harmonise_image_sizes()`.
- [ ] Play every embedded video and check that it remains available.
- [ ] Add `aria-label=""` description to each video.
- [ ] Replace or re-record videos that show obsolete software or instructions.
- [ ] Check every further-reading link.
- [ ] Add or update a multiple-choice quiz at the end of each substantive section.
- [ ] Add or update further reading.
- [ ] Check chapter ends with an up-to-date summary.
- [ ] Add bullet-point list of skills learned in this chapter.
- [ ] Check chapter ends with a complete script where students are expected to produce one
- [ ] Use `title=""` attribute for callout titles -- `Cmd+F` "`#### `" to check.
- [ ] Change artwork citation URL to `https://allisonhorst.com/`.
- [ ] Remove commented out obsolete sections.
- [ ] Spell check.

### Manual checks (not LLM-assisted)
- [ ] Run accessibility checker `quarto preview 01_getting_started/index.qmd --profile accessibility`
- [ ] Render without freeze `quarto render --cache-refresh` to capture changes in external dependencies/resources
- [ ] Check chapter in rendered desktop layout.
- [ ] Check chapter at narrow browser width.
- [ ] Commit the revised chapter and its associated files.
