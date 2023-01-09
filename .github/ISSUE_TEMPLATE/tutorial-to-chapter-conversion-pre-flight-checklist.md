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
- [ ] Add instructions for opening corresponding tutorial.
- [ ] Remove code from `setup` chunk that copies CSS files.
- [ ] Remove exercise setup chunks and empty exercise chunks.
- [ ] Remove quizzes.
- [ ] Check for any references to `Run Code` button.
- [ ] Convert pre-filled exercise chunks and exercise solution chunks to R code.
- [ ] Convert video URLs to use the quarto shortcode `{{< video https://example.com/ab1sc >}}`.
- [ ] Add reference to chapter file in top-level `_quarto.yml` file.
