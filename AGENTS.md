# AGENTS.md

# Crime Mapping Book

This repository contains the source for the *Learn Crime Mapping with R* online textbook, written in Quarto. The final textbook lives at <https://books.lesscrime.info/learncrimemapping/>. The book is the main resource that second-year undergraduate students use while taking a one-semester course called SECU005 Crime Mapping. The book is updated each year and the purpose of this project is to update the book for 2026.

The primary purpose of this file is to provide guidance to AI coding agents working within the repository. It describes the long-term design principles for the book. Individual user prompts should take precedence where they conflict with these instructions.

---

# Project goals

The book should:

- teach crime mapping and spatial analysis using R;
- be suitable for undergraduate students with little or no previous programming experience;
- encourage reproducible analytical workflows;
- follow current best practice in the R and Quarto ecosystems;
- meet modern accessibility standards;
- remain maintainable for several years, even though the book is updated each year to make sure it is still current.

When suggesting changes, prefer improvements that support these goals.

---

# Target audience

Readers are primarily second-year undergraduate students studying Crime and Security Science.

Assume that many readers:

- have no experience in R programming, although some but **not all** will have some experience in Python;
- have limited experience installing software;
- have little understanding of file systems;
- have little experience debugging code.

Write explanations accordingly.

---

# Teaching philosophy

When editing or reviewing material:

- explain *why*, not only *how*;
- introduce one new concept at a time;
- minimise unnecessary cognitive load;
- reinforce good habits repeatedly;
- avoid unnecessary jargon;
- assume students will copy examples before they fully understand them.

Good pedagogy is preferred over technical completeness.

---

# Software

The book uses:

- Positron
- R
- Quarto

Do not introduce RStudio-specific instructions unless explicitly requested.

Previous editions of the book used RStudio instead of Positron, so check carefully for outdated references to RStudio projects, menus, screenshots or terminology.

---

# Reproducibility

Prefer workflows that:

- use paths that make use of Positron's workspace feature;
- encourage well-organised project directories;
- download data into the local project before reading it;
- never edit original downloaded data files;
- avoid hard-coded absolute file paths.

Students should be encouraged to keep analytical work organised from the beginning.

---

# R style

Prefer:

- tidyverse packages where appropriate;
- readable code over concise code;
- explicit code rather than clever code;
- examples that beginners can understand.

Avoid introducing advanced programming concepts earlier than necessary.

---

# Quarto

Prefer current Quarto best practice.

When editing Quarto files:

- preserve cross references;
- preserve executable code chunks;
- preserve chunk options unless there is a good reason to change them;
- avoid breaking book navigation;
- maintain consistent heading structure.

---


# Accessibility

Accessibility is a first-class design goal.

Whenever modifying content, consider:

- heading hierarchy;
- descriptive alt text;
- informative link text;
- colour contrast;
- keyboard accessibility;
- clear language;
- appropriate table structure;
- avoiding unnecessary visual complexity.

Where images are introduced, consider whether their alt text should also be updated. All images must have alt text or be marked as decorative.

The book should mee the Web Accessibility Initiative (WAI) AA accessibility standard.

---

# Python comparisons

Occasionally suggest optional comparisons with Python where these would genuinely help readers.

Such comparisons should:

- be brief;
- be clearly optional;
- avoid distracting readers who only use R.

Python comparisons always be placed in a callout that is collapsed by default and has a relevant title. Python comparisons should never be in the main text.

---

# Consistency

Maintain consistency across the entire book.

When making a change, consider whether similar wording, examples or instructions should also be updated elsewhere in the repository.

Point out inconsistencies even if they are outside the current file.

---

# Review expectations

When reviewing chapters, consider:

1. technical accuracy;
2. pedagogy;
3. accessibility;
4. reproducibility;
5. consistency;
6. maintainability;
7. modern R and Quarto practice.

Do not limit comments to proofreading.

Look for opportunities to improve the overall learning experience.

---

# Editing principles

Unless explicitly requested:

- do not substantially increase chapter length without a clear educational benefit;
- preserve the author's writing style where possible;
- avoid unnecessary rewrites;
- explain the rationale for significant suggested changes;
- prefer incremental improvements over wholesale restructuring.

---

# Repository-wide changes

If a repeated issue is identified:

- mention where else it may occur;
- suggest a repository-wide search pattern if appropriate;
- avoid making assumptions without inspecting the relevant files.

---

# General behaviour

Treat this repository as a long-lived teaching resource rather than a software project.

Optimise for clarity, maintainability, accessibility and student learning outcomes rather than brevity or novelty.

You should be relucant to make changes to the content directly unless you have asked for approval first, but you should proactively suggest changes that you think would help achieve the above design goals.


---

# Resources

A GitHub issue template exists at <https://github.com/mpjashby/crimemappingbook/blob/main/.github/ISSUE_TEMPLATE/chapter-update-checklist-2026.md> that holds a checklist of things that I want to check about each chapter. Use this template to structure (but not limit) your suggestions for each chapter.