# 2026 lectures

This directory is an independent Quarto project. Render from this directory:

```sh
quarto render 01_introduction/index.qmd
```

The HTML embeds images, fonts and presentation resources for offline use.
The 2025 sources and stylesheet are unchanged.

- `_quarto.yml`: shared Reveal.js settings for this year's lectures.
- `_brand.yml`: local snapshot of the book's UCL palette with lecture typography.
- `ucl-presentation.scss`: slide layouts and existing authoring helpers.
- `fonts.css` and `fonts/`: local UCL Sans Regular, SemiBold, Bold and Italic,
  copied from the UCL Sans package in Downloads. Retain UCL's font usage terms.
- `*_logo.png` and `ucl-logo*.png`: shared organisation and software logos.
- `title-slide.html` and `accessibility.html`: shared title template and accessibility support.
- `01_introduction/index.qmd`: Week 1 source; `index.html` is its rendered slides.
- `01_introduction/assets/`: lecture-specific images and illustration prompts.

Opening slides use the `ucl-title` class, a dark purple background and the
inverted logo. Both styles use the same fixed logo element and dimensions.
Lecture 1 supplies its title, subtitle and delivery date in YAML; the
`title-slide.html` template partial renders these with the illustration and alt text supplied in
each lecture’s YAML metadata.
Ordinary slides use the full-colour logo on white.
Palette values are also declared in the SCSS defaults because this installed
Quarto version does not expose the named palette variables at that layer.
Keep those values aligned with this directory's `_brand.yml`.

Assessment dates supplied for this edition are 3 November 2026,
15 December 2026 and 14 January 2027. Other timetable details and screenshots
are carried forward and should be reviewed before teaching.

The 2026 lecture sources, rendered slides and supporting assets are tracked in Git.
They are not currently linked from the textbook.


Week 1 explicitly sets `format.revealjs.embed-resources: true`. Upload only
`01_introduction/index.html` to Moodle; its images, fonts, styles and slide
scripts are embedded. Links to Moodle, the textbook and Positron remain links.
