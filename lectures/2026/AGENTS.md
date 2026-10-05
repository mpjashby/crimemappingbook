# Converting lectures for 2026

These instructions apply to this directory and its children, alongside the
repository-root `AGENTS.md`. Follow this process when asked to convert an old
lecture to the 2026 format. The request authorises the conversion; propose
substantial changes to teaching content before making them. Preserve the
author's voice, learning objectives and lecture length wherever practical.

The [README](README.md) describes the project and distribution. Use
[Week 1](01_introduction/index.qmd) as the working example of the new format,
and inspect the current shared files before each conversion rather than relying
on remembered settings.

## 1. Inspect the old lecture and current context

- Check `git status --short` and preserve existing work. Do not overwrite,
  unstage or revert unrelated changes.
- Find the requested lecture's `.qmd` source in `../2025/` (or the year specified
  by the user). Read its YAML, slides, speaker notes, code chunks and asset
  references. Inspect the old rendered HTML and images when they clarify the
  intended appearance. Identify dependencies, including data and helper scripts.
- Read the corresponding 2026 textbook material. Compare terminology, chapter
  numbers, code, learning objectives and the expected student workflow.
- Use `../../.github/ISSUE_TEMPLATE/chapter-update-checklist-2026.md` to organise
  review under enhancements, outdated content, accessibility and functionality.
  Apply relevant checks to slides; do not automatically add chapter-length
  quizzes, scripts or other material to a lecture.
- Identify dates, assessment details, timetable information, software interfaces
  and links needing verification. Use user-supplied information or authoritative
  current sources; report unresolved details rather than inventing replacements.
  The README's assessment dates are edition-specific, not a permanent timetable.

## 2. Create the new lecture and reuse the shared design

- Create `NN_topic/index.qmd` and `NN_topic/assets/`, following
  `01_introduction/`. Leave previous years' sources, renders and styles intact.
- Copy the lecture content and only the assets it uses. Reference shared logos
  from the parent directory and lecture-specific assets from `assets/`. Keep
  paths relative and check references inside HTML, CSS and code as well as
  Markdown. Preserve credits and usage terms; retain prompts alongside generated
  illustrations where available.
- Use `_quarto.yml`, `_brand.yml`, `ucl-presentation.scss`, `fonts.css`,
  `title-slide.html` and `accessibility.html`. Remove obsolete per-lecture themes,
  fonts, logos and layout overrides that conflict with this design. Avoid copying
  the old stylesheet or generating a separate theme for each week.
- Start the YAML from Week 1, updating the lecture title, subtitle, delivery
  date, title illustration and `title-illustration-alt`. Preserve the dark purple
  title background and shared template partial. Inspect the template: the current
  title slide does not display the date even though Week 1 supplies date metadata.
- Carry across Week 1's explicit `format.revealjs` settings: embedded resources,
  `include-after-body: ../accessibility.html`, visible edge controls, no slide or
  background transitions, `center-title-slide: false` and
  `template-partials: [../title-slide.html]`. The project currently defaults to
  fade transitions and does not include the accessibility helper or title partial.
- Use level-two headings for slides and level-three headings for subsections.
  Preserve slide IDs, cross-references, speaker notes, code and chunk options
  unless there is a reason to change them. Check fenced divs and column nesting.
  Reuse existing layout classes and fragments sparingly.
- Keep white content slides, purple text and the shared fixed UCL logo. The
  title slide uses the inverted logo; repeated branding is decorative. Keep SCSS
  palette defaults aligned with `_brand.yml` if a shared change is necessary.
  Check all converted lectures after changing a shared file.

## 3. Review teaching content and technical accuracy

- Explain why as well as how, introduce one concept at a time, and assume no
  previous programming experience. Keep slides readable from the back of a room.
- Replace outdated RStudio instructions and screenshots with verified Positron
  equivalents, including workspaces, menus and shortcuts. Do not merely replace
  the application name in instructions whose behaviour has changed.
- Align examples with the current textbook: readable R, appropriate tidyverse
  tools, workspace-relative paths, locally downloaded data and untouched originals.
  Check applicable checklist items such as httr2 + here downloads and updated
  spatial functions against the corresponding chapter.
- Run executable examples and check their results, including code presented as
  non-executing examples that students may copy. Preserve intentional error
  demonstrations and explain them. Use a fresh execution/cache refresh where
  needed so old output cannot disguise failures.
- Review screenshots, chapter references, file names, URLs, spelling and dates.
  Keep optional Python comparisons brief and in titled, initially collapsed
  callouts, as required by the root instructions.
- Suggest significant pedagogical additions or unresolved inconsistencies for
  approval. Report related issues elsewhere with an inspected example or useful
  repository-wide search pattern.

## 4. Check accessibility in source and rendered slides

Aim for the repository's WAI AA accessibility standard. Automated checks are
useful evidence but do not establish conformance on their own.

- Give meaningful images accurate alt text describing their teaching purpose;
  use `fig-alt` for executable figures. Mark purely decorative images with empty
  alt text and, where appropriate, `role="presentation"`. Check the actual HTML
  output, including the title illustration and logos.
- Explain the important information in maps, charts and screenshots in adjacent
  text or notes accessible to students. Avoid images of text as the only source
  of essential instructions. Do not rely on colour alone for meaning.
- Check text contrast on both white and purple backgrounds, including links,
  code, captions and highlighted fragments. Check focus indicators and controls
  separately; brand colours are not automatically accessible in every combination.
- Use descriptive link text, a logical heading structure and real table headers.
  Keep reading order meaningful when columns are linearised. Check video labels,
  captions/transcripts and playback if media are included.
- Navigate the rendered deck using only the keyboard: advance and reverse slides
  and fragments, reach links and controls, follow links and return. Check visible
  focus on both backgrounds and that focus is not trapped or hidden.
- Check screen-reader reading order and whether progressive reveals hide essential
  information. Ensure a usable route to the full content, such as the rendered
  deck's reader view, and test it rather than assuming it is accessible.
- Check reduced-motion behaviour and avoid flashing or unnecessary animation.
  Inspect slides at narrow window sizes and with browser zoom, as well as in
  presentation mode. If a check requires human testing or unavailable tooling,
  record it as outstanding.
- Run an available browser accessibility audit on representative slides, including
  the title, tables, figures and revealed fragment states. Inspect findings and
  correct genuine problems. Do not assume the book's `--profile accessibility`
  works here: this is a separate Quarto project with its own configuration.

## 5. Render and inspect the deliverable

Run from `lectures/2026/`, substituting the actual lecture directory:

```sh
quarto render NN_topic/index.qmd
```

- Fix render errors and investigate warnings about missing files, resources,
  references or execution. Confirm the output is `NN_topic/index.html`.
- Open the rendered HTML in a browser and inspect every slide, including each
  fragment state. Check title layout, both logos, font loading, image proportions,
  tables, code and links. Look for clipped content, overlap with the logo or
  slide number, and illegible text. Prefer simplifying or splitting crowded
  slides to shrinking text.
- Verify the output embeds images, local fonts, styles and presentation scripts.
  Copy only `index.html` into an otherwise empty temporary directory and open it
  with the network disabled. Check the title and content slides, navigation and
  fonts. External website links still need internet access; identify any embedded
  media or other features that also require it.
- Re-render after fixes and repeat affected checks. Keep the `.qmd`, rendered
  `.html`, required assets and useful illustration prompts together in Git;
  exclude caches and temporary checking artefacts according to `.gitignore`.

## 6. Report completion and remaining checks

- Review the diff for accidental changes outside the requested scope and check
  that all referenced assets are present. Update the README if the shared
  authoring or distribution process has actually changed.
- Report the source and rendered HTML paths, substantive content changes, checks
  performed and their results. Clearly distinguish verified results from checks
  still requiring human review, including unconfirmed dates or screenshots.
- The Moodle deliverable is the single embedded `NN_topic/index.html`. Do not
  upload, publish, commit or create GitHub content unless requested. Follow the
  root disclosure-footer instruction for any authorised GitHub content.
