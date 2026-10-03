"""Regression checks for missing alternatives in the book's different image forms."""
import unittest

from check_image_alternatives import ImageParser, check_source


class ImageAlternativesTests(unittest.TestCase):
    def test_missing_html_alternative(self):
        errors, _ = check_source('chapter.qmd', '<img src="map.png">')
        self.assertTrue(errors)

    def test_empty_alternative_needs_decoration(self):
        errors, _ = check_source('chapter.qmd', '<img src="map.png" alt="">')
        self.assertTrue(errors)
        errors, _ = check_source('chapter.qmd', '<img src="art.png" alt="" role="presentation">')
        self.assertFalse(errors)

    def test_named_link_preserves_decorative_logo(self):
        errors, _ = check_source('chapter.qmd', '<a aria-label="Visit the sf website"><img src="sf.png" alt=""></a>')
        self.assertFalse(errors)

    def test_markdown_fig_alt_overrides_caption(self):
        errors, _ = check_source('chapter.qmd', '![Caption](map.png){fig-alt=""}')
        self.assertTrue(errors)
        errors, _ = check_source('chapter.qmd', '![Caption](map.png){fig-alt="Dark cells concentrate near the northern boundary."}')
        self.assertFalse(errors)

    def test_named_markdown_link_preserves_decorative_logo(self):
        errors, _ = check_source('chapter.qmd', '[![](logo.png){alt=""}](https://example.com){aria-label="Visit the package website"}\n')
        self.assertFalse(errors)

    def test_literal_examples_and_comments_are_excluded(self):
        text = '<!-- <img src="old.png"> -->\n````markdown\n![](example.png)\n```{r}\n#| label: fig-example\nplot(1)\n```\n````\n'
        errors, counts = check_source('chapter.qmd', text)
        self.assertFalse(errors)
        self.assertFalse(counts)

    def test_inventory_catches_removed_generated_alternative(self):
        text = '```{r}\n#| label: draw-map\n#| fig-alt: "Northern cells have higher density."\nmap\n```\n'
        self.assertFalse(check_source('chapter.qmd', text, ['draw-map'])[0])
        self.assertTrue(check_source('chapter.qmd', text.replace('#| fig-alt: "Northern cells have higher density."\n', ''), ['draw-map'])[0])
        self.assertTrue(check_source('chapter.qmd', '', ['draw-map'])[0])

    def test_each_generated_panel_needs_its_own_nonempty_alternative(self):
        text = '```{r}\n#| label: fig-panels\n#| fig-alt: ["Grey background.", "White background."]\nplot(1)\nplot(2)\n```\n'
        self.assertFalse(check_source('chapter.qmd', text)[0])
        self.assertTrue(check_source('chapter.qmd', text.replace('"White background."', '""'))[0])

    def test_new_numbered_figure_needs_alternative(self):
        errors, _ = check_source('chapter.qmd', '```{r}\n#| label: fig-new\nplot(1)\n```\n')
        self.assertTrue(errors)

    def test_workflow_diagram_needs_description(self):
        self.assertTrue(check_source('chapter.qmd', '::::: {.process}\nDownload\n:::::')[0])
        self.assertFalse(check_source('chapter.qmd', '::::: {.process role="img" aria-label="Download, load, wrangle and visualise data in that order."}\nDownload\n:::::')[0])

    def test_mermaid_needs_native_accessibility_metadata(self):
        text = '```{mermaid}\n%%| label: workflow\n%%| fig-alt: "Load and map data."\nflowchart TD\nA --> B\n```\n'
        self.assertTrue(check_source('chapter.qmd', text)[0])
        text = text.replace('flowchart TD\n', 'flowchart TD\naccTitle: Workflow\naccDescr: Load and map data.\n')
        self.assertFalse(check_source('chapter.qmd', text)[0])

    def test_rendered_svg_needs_accessible_name(self):
        parser = ImageParser()
        parser.feed('<svg role="img"></svg>')
        self.assertTrue(parser.errors)
        parser = ImageParser()
        parser.feed('<svg role="img" aria-label="Flow diagram of the analysis steps."></svg>')
        self.assertFalse(parser.errors)
        parser = ImageParser()
        parser.feed('<svg role="graphics-document document"></svg>')
        self.assertTrue(parser.errors)


if __name__ == '__main__':
    unittest.main()
