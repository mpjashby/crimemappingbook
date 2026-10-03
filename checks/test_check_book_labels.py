import unittest
from check_book_labels import check_sources


class LabelChecks(unittest.TestCase):
    def check(self, text, path="02_your_first_crime_map/index.qmd"):
        return check_sources({path: text})[0]

    def test_missing_execution_label_is_detected_even_when_hidden(self):
        errors = self.check('```{r}\n#| echo: false\nplot(1:3)\n```\n')
        self.assertTrue(any("execution label" in error for error in errors))

    def test_hidden_listing_is_detected(self):
        errors = self.check('```{r}\n#| label: hidden-map\n#| echo: false\n#| lst-label: lst-hidden-map\n#| lst-cap: ""\nplot(1:3)\n```\n')
        self.assertTrue(any("hidden code" in error for error in errors))

    def test_document_defaults_hide_setup(self):
        self.assertEqual(self.check('---\nexecute:\n  include: false\n  echo: false\n---\n```{r}\n#| label: setup\nx <- 1\n```\n'), [])

    def test_examples_and_r_comments_are_not_headings(self):
        text = '````markdown\n### Example heading\n```{r}\nx <- 1\n```\n````\n```{r}\n#| label: setup\n#| include: false\n### An R comment\n```\n'
        self.assertEqual(self.check(text), [])

    def test_commented_cell_has_execution_label_but_no_listing(self):
        text = '<!--\n```{r}\n#| label: old-example\nx <- 1\n```\n-->\n'
        self.assertEqual(self.check(text), [])

    def test_mermaid_diagram_needs_a_label_but_no_listing(self):
        self.assertEqual(self.check('```{mermaid}\n%%| label: workflow\nflowchart TD\nA --> B\n```\n'), [])
        self.assertTrue(any("execution label" in error for error in self.check('```{mermaid}\nflowchart TD\nA --> B\n```\n')))

    def test_real_heading_needs_identifier(self):
        self.assertTrue(any("level-3 heading" in error for error in self.check('### Loading data\n')))

    def test_duplicate_book_anchors_are_detected_across_chapters(self):
        errors, _ = check_sources({"01_getting_started/index.qmd": "### First {#sec-loading}\n", "02_your_first_crime_map/index.qmd": "### Second {#sec-loading}\n"})
        self.assertTrue(any("Duplicate book" in error for error in errors))

    def test_visible_listing_and_chart_require_metadata(self):
        errors = self.check('```{r}\n#| label: fig-assaults\nplot(1:3)\n```\n')
        for expected in ("lst-label", "blank lst-cap", "fig-cap", "alternative text"):
            self.assertTrue(any(expected in error for error in errors), expected)

    def test_supporting_reports_keep_their_own_caption_conventions(self):
        self.assertEqual(self.check('```{r}\n#| label: fig-example\n#| fig-cap: "Existing caption"\nplot(1:3)\n```\n', "resources/reports/example.qmd"), [])


if __name__ == '__main__':
    unittest.main()
