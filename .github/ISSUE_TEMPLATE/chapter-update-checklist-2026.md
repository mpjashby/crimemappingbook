---
name: Chapter update checklist 2026
about: Checklist for updating each chapter for the 2026 edition
title: Update Chapter [CHAP] for 2026
labels: chapter update checklist
assignees: mpjashby

---

- [ ] Check 'Before you start' callout gives current instructions.
- [ ] `Cmd+F` 'RStudio'
- [ ] Replace RStudio-specific instructions, e.g. menu names, shortcuts
- [ ] Replace RStudio screenshots
- [ ] Use Positron instructions for restarting R
- [ ] Use kbd shortcode e.g. `press {{< kbd win=Ctrl-Enter mac=Command-Return >}}`
- [ ] Check chapter begins with the finished map, chart or other intended output where appropriate
- [ ] Run every executable code chunk and fix any errors
- [ ] Add accurate alt text to every `<img>` element
- [ ] Add `fig-alt` to figures produced directly by executable R chunks
- [ ] Check chunk attributes are provided in Quarto not Rmarkdown style
- [ ] Reduce unnecessarily large image files using `harmonise_image_sizes()`
- [ ] Remove generated image files that are no longer used
- [ ] Play every embedded video and check that it remains available
- [ ] Add `aria-label=""` description to each video
- [ ] Replace or re-record videos that show obsolete software or instructions
- [ ] Check every further-reading link
- [ ] Add Python comparisons as collapsed callouts
- [ ] Add or update a multiple-choice quiz at the end of each substantive section
- [ ] Add or update further reading
- [ ] Check chapter ends with an up-to-date summary
- [ ] Check chapter ends with a complete script where students are expected to produce one
- [ ] Remove commented out obsolete sections
- [ ] Spell check
- [ ] Run accessibility checker `quarto preview 01_getting_started/index.qmd --profile accessibility`
- [ ] Render without freeze `quarto render --cache-refresh` to capture changes in external dependencies/resources
- [ ] Check chapter in rendered desktop layout.
- [ ] Check chapter at narrow browser width.
- [ ] Commit the revised chapter and its associated files.
