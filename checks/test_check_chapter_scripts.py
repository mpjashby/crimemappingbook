"""Regression tests for the consistency check's failure cases.

These mutate disposable book copies, never the real chapters or scripts.
Run: python3 -m unittest discover -s checks -p 'test_*.py'
"""

import copy
import json
from pathlib import Path
import shutil
import tempfile
import unittest

from check_chapter_scripts import Book, code_and_comments

ROOT = Path(__file__).resolve().parents[1]


class ConsistencyCheckTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.manifest = json.loads((ROOT / "checks/chapter-scripts.json").read_text())
        for script in self.manifest["scripts"]:
            target = self.root / script
            target.parent.mkdir(exist_ok=True)
            shutil.copyfile(ROOT / script, target)
        for chapter in ROOT.glob("[0-9][0-9]_*/index.qmd"):
            target = self.root / chapter.relative_to(ROOT)
            target.parent.mkdir()
            shutil.copyfile(chapter, target)

    def check(self):
        return Book(self.root, self.manifest).check()

    def change(self, filename, before, after):
        path = self.root / filename
        text = path.read_text()
        self.assertIn(before, text)
        path.write_text(text.replace(before, after, 1))

    def test_current_book_and_intentionally_broken_examples_match(self):
        self.assertEqual(self.check(), [])
        for script in ("chapter_08_error.R", "chapter_08_minimal.R", "chapter_08_minimal_reprex.R"):
            self.assertIn(" +\n", (self.root / "R" / script).read_text())

    def test_detects_script_code_drift(self):
        self.change("R/chapter_02a.R", 'size = 4', 'size = 5')
        self.assertTrue(any("R/chapter_02a.R: code differs" in error for error in self.check()))

    def test_detects_comment_drift(self):
        self.change("R/chapter_13a.R", "# Calculate bounding box", "# Bounding box")
        errors = self.check()
        self.assertTrue(any("R/chapter_13a.R: comments differs" in error for error in errors))
        self.assertFalse(any("R/chapter_13a.R: code differs" in error for error in errors))

    def test_chapter_edit_propagates_to_copied_scripts(self):
        self.change("03_data_wrangling/index.qmd",
                    '#| label: script-03a-packages\n#| filename: "chapter_03a.R"\n\n# Load packages',
                    '#| label: script-03a-packages\n#| filename: "chapter_03a.R"\n\n# Load the packages')
        errors = self.check()
        for script in ("03a", "04a"):
            self.assertTrue(any(f"R/chapter_{script}.R: comments differs" in error for error in errors))

    def test_detects_checkpoint_drift(self):
        path = self.root / "02_your_first_crime_map/index.qmd"
        text = path.read_text()
        before, after = text.split('#| label: script-02a-checkpoint', 1)
        path.write_text(before + '#| label: script-02a-checkpoint' + after.replace('"EPSG:26967"', '"EPSG:4326"', 1))
        self.assertTrue(any("script-02a-checkpoint): code differs" in error for error in self.check()))

    def test_intermediate_pipeline_is_not_added_to_final_script(self):
        self.change("05_your_second_crime_map/index.qmd", 'janitor::clean_names() # <3>',
                    'janitor::clean_names(case = "lower_camel") # <3>')
        self.assertEqual(self.check(), [])

    def test_detects_new_script_and_unmapped_saved_chunk(self):
        (self.root / "R/chapter_99.R").write_text("sqrt(4)\n")
        path = self.root / "02_your_first_crime_map/index.qmd"
        path.write_text(path.read_text() + '\n```{r}\n#| filename: "chapter_02a.R"\nsqrt(4)\n```\n')
        errors = self.check()
        self.assertTrue(any("Unmapped script: R/chapter_99.R" in error for error in errors))
        self.assertTrue(any("Unmapped saved-code chunk" in error for error in errors))

    def test_cannot_verify_a_script_using_its_own_include(self):
        manifest = copy.deepcopy(self.manifest)
        manifest["scripts"]["R/chapter_07.R"]["parts"] = [
            {"chapter": "07_map_context/index.qmd", "chunk": "complete-script"}]
        with self.assertRaisesRegex(ValueError, "instead of independent chapter code"):
            Book(self.root, manifest).check()

    def test_presentation_markers_and_blank_lines_are_ignored(self):
        self.change("13_mapping_hotspots/index.qmd", "invisible() #<1>", "invisible() # <9>")
        self.change("R/chapter_13c.R", "# LOAD DATA", "\n\n# LOAD DATA")
        self.assertEqual(self.check(), [])

    def test_hashes_in_strings_remain_code(self):
        code, comments = code_and_comments('colour = "#CC0000" # Set colour\n')
        self.assertEqual(code, ['colour = "#CC0000"'])
        self.assertEqual(comments, [(1, "# Set colour")])
        self.change("R/chapter_10.R", '"#CC0000"', '"#000000"')
        self.assertTrue(any("R/chapter_10.R: code differs" in error for error in self.check()))


if __name__ == "__main__":
    unittest.main()
