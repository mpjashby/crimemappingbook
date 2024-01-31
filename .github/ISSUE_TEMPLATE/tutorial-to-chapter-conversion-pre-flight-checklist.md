---
name: Tutorial-to-chapter conversion pre-flight checklist
about: Checklist for checking the process of converting an interactive tutorial to
  a book chapter
title: 'Pre-flight conversion checklist: Chapter XX, YYYY'
labels: ''
assignees: ''

---

- [ ] Copy over `images/` directory.
- [ ] Add tutorial title as level-1 heading.
- [ ] Add tutorial description as bold-face text after title.
- [ ] Add instructions for opening corresponding tutorial:

````
::: {.box .load-tutorial}
To load the [interactive tutorial](../#how-to-use-this-book) for this chapter, copy and paste the following code into the RStudio console:

```r
crimemapping::tutorial("01_getting_started")
```

and press `Enter`.
:::
````

- [ ] Remove YAML header.
- [ ] Replace start of `setup` chunk with:

````r
```{r setup}
#| echo: false
#| include: false

source(here::here("mask_learnr_functions.R"))
```
````

- [ ] Remove `library(learnr)` from `setup` chunk
- [ ] Set `echo=FALSE` for any chunks with `-setup` in the chunk name.
- [ ] Remove `section-` prefix from jquery code for extra-detail boxes.
- [ ] Cmd+F for any references to `Run Code` button.
- [ ] Convert video URLs to use the quarto shortcode `{{< video https://example.com/ab1sc >}}`.
- [ ] Add reference to chapter file in top-level `_quarto.yml` file.
- [ ] Run `Build > Render Book`.
