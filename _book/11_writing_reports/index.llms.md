Source: https://books.lesscrime.info/learncrimemapping/11_writing_reports/index.html

<a id="quarto-document-content"></a>
<a id="title-block-header"></a>
<a id="writing-reports-in-r"></a>

# `<a id="sec-reports"></a>`{=html}11  Writing reports in R

Figure: Students assemble a wide report containing maps and charts with blank content blocks.

In [Chapter 5](../05_your_second_crime_map/index.llms.md) and [Chapter 6](../06_mapping_crime_patterns/index.llms.md) we've learned how to make crime maps, but almost every analysis also needs text, charts and other things to help the audience understand the main messages. In this chapter we will learn how to use a tool called Quarto to produce structured reports in Positron and export them to multiple formats, including HTML, Word and PDF.

TipBefore you start

1.  Open Positron or -- if you already have Positron open -- start a new R session by clicking the **Restart R** (**⟳**) button in the **Console** panel. This makes sure no code you ran previously will interfere with the work you do in this chapter.
2.  Make sure you are working in the crime mapping project workspace you created in [Section 1.5](../01_getting_started/index.llms.md#sec-create-project). In the top-right corner of the Positron window, you should see a folder icon and the words `crime_mapping`. If not, click the **File** menu, then **Open Folder ...** and choose the `crime_mapping` folder.

<a id="introduction"></a>

## 11.1 Introduction

We have practised producing useful maps in R so that people can use them to make decisions about understanding and responding to crime problems. But maps are only one part of most spatial analysis. In practice, maps are usually part of a larger report in which you as an analyst will explain what your maps show and perhaps make recommendations about what decisions people should make.

You are probably used to creating graphics in one piece of software (such as a map in R or a chart in Excel) and then importing or pasting those graphics into another program (such as Word) to include them in a written report. This way of working is often fine, but it has some important shortcomings. For example, if you want to make a change to a graphic (maybe to correct a typo), you then have to import it into your writing program again. More importantly, it can become hard to keep track of which version of a graphic you need to import and you may end up including the wrong version of a file.

Figure: Diagram with arrows leading from R, Python, Observable and Julia to Quarto, then from Quarto to HTML, PDF, Word and other document formats. It illustrates how one publishing system supports several programming languages and output formats.

The same problem applies to numbers that you might calculate in statistical software such as R. You might calculate a statistic such as the mean number of burglaries in local council wards, then paste the result into Word to include it in your report. But if you then realise later on that there is a problem with your data and re-run your code, it would be very easy (especially in a long report) to forget that you needed to update the mean value presented in the report. The risk of making errors like this is particularly high if you are asked to update an existing report based on new data. Perhaps the worst aspect of this problem is that you will never know for sure if the numbers in your final report are correct, unless you go back and check every one of them in whatever program you used to generate the numbers in the first place. So whenever you present your analysis you will have the nagging doubt that some of the results might be incorrect.

We can describe this risk of a report containing obsolete charts or incorrect statistics by saying that it is not *reproducible* -- if we were asked to go back and demonstrate each stage in producing the report to prove that we had done everything correctly, it would be very hard to do so. This is important because the reports that analysts write about crime are so often used to make decisions about how to respond to crime. An error in copying and pasting a number from R or Excel into Word could lead to police officers being deployed to the wrong place, or the wrong local council being given funding to install crime-prevention measures.

Watch this video to learn more about writing reproducible documents using what is known as *literate coding*.

Media: Video introducing literate coding and reproducible documents [(open media)](https://www.youtube.com/embed/42RFdADQdcI)

TranscriptVideo transcript: Coding Notebooks

<a id="callout-2"></a>

foreign a computational notebook is an authoring environment where code is interspersed with natural language many people call this style of computing literate coding using this method authors can render their reports dynamically as part of the code's execution as such a report is an expression that can take many forms some examples include PDF document a web page an interactive dashboard a Word document or a slide deck using a computational notebook we combine data inputs code and computational outputs with explanatory text to generate multimedia documents the outputs become the artifacts

documenting a body of work it is often recommended for reproducible workflows to do as much as possible with code in other words derive reports from code this practice decreases typographical errors avoids inherently idiosyncratic Mouse clicks such as copy and paste and orchestrates workflows as a reproducible process to accomplish this we use code notebooks to mingle pros and code chunks within the same document as such visualizations or other computational actions are derived from code chunks and displayed in line the combination of these elements are rendered dynamically into reports

if the data changes or the code is updated the code notebook is Rerun and the reports are re-rendered by intermingling code with natural language authors clearly explain data models and workflows as a process this reduces the dependencies on outside and undocumented steps another reproducible practice one example is a quarto notebook a visual computational notebook that evolved from the legacy of our markdown quarto notebooks support multiple computational languages python R Julia and observable Js Corto notebooks can be edited and composed within Visual Studio Jupiter notebooks command line

or the r Studio IDE in summary computational notebooks are reproducible authoring environments designed to be easy to read and easy to compose a quarto notebook is an open source practical application of the literate coding concept with minimal practice authors can use notebooks as a convenient and reproducible approach to documenting and executing workflows thank you

QuizReproducibility

**What is a key feature of a computational notebook?**

- It separates code and natural language into different documents.
- It intersperses code with natural language within the same document. (Correct answer)
- It only supports Python as a programming language.
- It primarily focuses on graphical user interfaces rather than code execution.

**Why is literate coding recommended for reproducible workflows?**

- It ensures that all steps, including steps done manually in external software, are documented
- It makes code execution optional in reports
- It minimizes dependencies on undocumented steps by showing all steps in the analysis clearly (Correct answer)
- It replaces all traditional forms of documentation with graphical representations

**Which of the following best describes Quarto notebooks?**

- They are a proprietary tool developed exclusively for use with the R programming language
- They can only be edited using Jupyter Notebook
- They do not allow mixing of prose and code chunks
- They evolved from R Markdown and support multiple programming languages (Correct answer)

In this chapter we will learn to use Quarto to write reports directly in Positron, integrating data, maps and statistics so that they remain up to date.

Reports made with Quarto can include lots of different calculations, graphics, etc. For example, the report [*Stop and Search in London*](https://discovery.ucl.ac.uk/id/eprint/10115766/1/2020-Q3.pdf) was created entirely in Quarto. This whole book is also written in Quarto. But in this chapter we'll keep things simple by producing a very short report that only includes one figure. You can [view the finished version of the report](../resources/reports/medellin_homicides_map.html) that we will use as an example in this chapter. The report combines a sentence of explanatory text, a map produced by R and an automatically numbered cross-reference.

In this chapter, we will learn how to:

- structure a report using Markdown;
- create and configure a Quarto document;
- add inline R code and R code chunks to Quarto documents;
- control which code and output appear in a finished report;
- label and cross-reference maps and tables; and
- render a reproducible report in different formats.

<a id="markdown"></a>

## 11.2 Markdown

*Markdown* is a way of formatting plain text so that a computer can convert it into different file formats. For example, Quarto can convert Markdown documents into Word, PDF, PowerPoint and many other formats.

a Markdown\
document

... can be\
processed into ...

Word

PDF

PowerPoint

other formats

Markdown is extremely simple. It uses plain-text characters to represent common text formatting such as titles, emphasised text and so on. For example, the Markdown text:

<a id="lst-reports-markdown-example"></a>

<figure>
<div class="sourceCode" id="cb1"><pre class="sourceCode numberSource numberSource lang-md number-lines code-with-copy"><code class="sourceCode"><span id="cb1-1"><a href="#cb1-1"></a># Introduction</span>
<span id="cb1-2"><a href="#cb1-2"></a></span>
<span id="cb1-3"><a href="#cb1-3"></a>In this chapter we will learn to use a tool called *Quarto* to write reports</span>
<span id="cb1-4"><a href="#cb1-4"></a>directly in Positron.</span></code></pre></div>
<figcaption>Code 11.1</figcaption>
</figure>

produces the output:

<a id="introduction-1"></a>

# Introduction

In this chapter we will learn to use a tool called *Quarto* to write reports directly in Positron.

In this example, the character `#` *followed by a space* at the start of a line means that line should be shown as a first-level heading and the asterisks (`*` -- we could also have used the underscore character `_`) around the word `Quarto` indicate that it should be emphasised (typically with *italic* text).

ImportantSpaces are important in Markdown headings

In Markdown we use the hash character `#` followed by a space to indicate that a line should be formatted as a top-level heading. The space after the `#` is important -- if you write `#Introduction` instead of `# Introduction` then Quarto will not recognise that line as representing a heading and it will not be formatted properly.

Markdown is designed to be easy to read and easy to write. It is perfectly possible, for example, to read the unformatted Markdown text in [Code 11.1](#lst-reports-markdown-example). Since Markdown files (which have the file extension `.md`) are plain text, it's also possible to open them on virtually any computer. Markdown is very widely used on the web -- using underscores to mark out italic text and asterisks to mark out bold text even works in messaging apps such as Telegram and WhatsApp.

In Markdown you describe the *structure* of a document, not its appearance. The appearance of the document (which fonts it uses, what margins the pages have and so on) is determined by the template Quarto uses to convert Markdown files into documents of different types. This can save you a lot of time, because you don't need to specify fonts and other formatting. Instead, you can concentrate on the structure of your argument rather than the details of formatting.

You can create your own templates for documents (for example if you want to create documents that match a particular corporate style), but in this course we will use Quarto's built-in formats.

ImportantUse Markdown to describe structure, not appearance

You should not try to fine-tune the visual appearance of a document produced from Markdown-formatted text by (for example) changing a second-level heading to a third-level heading because you want the heading text to be slightly smaller. Keeping the structure of your document (defined using Markdown) separate from its visual appearance has several benefits that are important, but not immediately obvious. For example, screen reading software used by blind or partially sighted people will read out the *structure* of a document rather than the visual appearance. So if, for example, you were to use Markdown syntax for `code text` to change the font in the headings in a Markdown document, it is possible that would make the document much harder for people using a screen reader to make sense of.

If you want to change the visual appearance of a piece of Markdown-formatted text, you should change the template that is used to convert that text into a Word document, PDF, web page, etc.

**Use Markdown to describe the structure of a document, not its appearance**.

<a id="sec-writing-reports-markdown-document-structure"></a>
<a id="markdown-document-structure"></a>

### 11.2.1 Markdown document structure

To create paragraphs in Markdown, you simply split text with a blank line. So this Markdown text:

``` {.sourceCode .numberSource .lang-md .number-lines .code-with-copy}
In this chapter we will learn to use a tool called _Quarto_ to write reports
directly in Positron. Markdown is a way of formatting plain text so that a
computer can convert it into different file formats.
```

produces the output:

In this chapter we will learn to use a tool called *Quarto* to write reports directly in Positron. Markdown is a way of formatting plain text so that a computer can convert it into different file formats.

because there is no blank line between the first and second sentences. We can split this into two paragraphs just by adding a blank line:

``` {.sourceCode .numberSource .lang-md .number-lines .code-with-copy}
In this chapter we will learn to use a tool called _Quarto_ to write reports
directly in Positron.

Markdown is a way of formatting plain text so that a computer can convert it
into different file formats.
```

which produces the output:

In this chapter we will learn to use a tool called *Quarto* to write reports directly in Positron.

Markdown is a way of formatting plain text so that a computer can convert it into different file formats.

<a id="headings"></a>

#### Headings

There are six levels of headings available in Markdown documents, although it is very unlikely that you will need all six. Headings are specified by adding one or more `#` characters to the start of the line, followed by a space:

``` {.sourceCode .numberSource .lang-md .number-lines .code-with-copy}
# First-level heading

## Second-level heading

### Third-level heading
```

produces:

<a id="first-level-heading"></a>

# First-level heading

<a id="second-level-heading"></a>

## Second-level heading

<a id="third-level-heading"></a>

### Third-level heading

Headings should have at least one blank line above and below them, so that they stand out from the surrounding code. I usually leave three blank lines before a second-level heading and two blank lines before other headings, with exactly one blank line after every type of heading.

<a id="lists"></a>

#### Lists

Markdown supports two types of list: ordered lists and unordered lists. You can make an ordered list by putting each list item on a new line and starting each line with a number followed by a full stop (`.`). You make an unordered list in the same way, but starting each line with an asterisk:

``` {.sourceCode .numberSource .lang-md .number-lines .code-with-copy}
1. A list of items
2. for which the ordering
3. of items is important

* A list of items
* for which the ordering
* of items is *not* important
```

produces:

1.  A list of items
2.  for which the ordering
3.  of items is important

- A list of items
- for which the ordering
- of items is *not* important

<a id="quotes"></a>

#### Quotes

If you want to insert a quote into your Markdown document, you can do that by putting a greater-than (`>`) symbol followed by a space at the start of each line of the quote:

``` {.sourceCode .numberSource .lang-md .number-lines .code-with-copy}
> In this chapter we will learn to use a tool called _Quarto_ to write reports
> directly in Positron.
```

produces

> In this chapter we will learn to use a tool called *Quarto* to write reports directly in Positron.

<a id="sec-writing-reports-inline-elements"></a>
<a id="inline-elements"></a>

### 11.2.2 Inline elements

As well as using Markdown to describe the structure of a document, you can use it to mark up particular text within a paragraph. We've already seen how to do this using `_to emphasise text_` (usually displayed in *italics*). We can also `**strongly emphasise**` text, which will usually appear in **bold**. Note that the `_`, `*` or `**` characters must be touching a word on exactly one side:

- `some _emphasised_ text` produces some *emphasised* text
- `some_emphasised_text` does not produce emphasised text
- `some _ emphasised _ text` does not produce emphasised text

We can add links to a document using the format `[link text](URL)`. For example, the text:

``` {.sourceCode .numberSource .lang-md .number-lines .code-with-copy}
[learn about the tidyverse](https://www.tidyverse.org/)
```

produces the link:

[learn about the tidyverse](https://www.tidyverse.org/)

There are several other Markdown codes for describing different elements within a document, including images, videos and segments of code. You can find out more about what's possible with Markdown on the [Markdown Basics page of the Quarto website](https://quarto.org/docs/authoring/markdown-basics.html).

<a id="sec-writing-reports-previewing-markdown-in-positron"></a>
<a id="previewing-markdown-in-positron"></a>

### 11.2.3 Previewing Markdown in Positron

Positron can preview a Markdown document while you work. To try this:

1.  Click the **File** menu, then click **New File ...**.
2.  Type `markdown_practice.md` in the box marked **Select File Type or Enter File Name...**, then press ReturnReturn.
3.  Save the file in the `output` directory of your `crime_mapping` workspace.
4.  Add some Markdown headings, paragraphs and lists using the syntax we have just learned.
5.  Click the **Preview** button at the top-left of the editor.

As you edit the file, you can see an updated preview at any time by clicking the **Preview** button again.

By default, Positron renders Markdown files into HTML files (web pages). You can also produce many other formats. One common format you might want to produce is a PDF file. To create PDF files with Positron, your computer has to have a version of software called *TeX* installed. If you've never heard of TeX, you can install it automatically using the tinytex R package. To install TeX, run this R code *once* in the R Console:

``` {.sourceCode .numberSource .r .number-lines .code-with-copy}
install.packages("tinytex")
tinytex::install_tinytex()
```

TeX should now be installed on your computer.

ImportantInstall TeX only once

Note that you only have to install TeX once on each computer you use, so you should not include `tinytex::install_tinytex()` in any code scripts that you write.

QuizMarkdown

**Which of the following is the correct way to create a first-level heading in Markdown?**

- \*\*Heading 1\*\*
- == Heading 1 ==
- \# Heading 1 (Correct answer)
- \## Heading 1

**How do you create an unordered list in Markdown?**

- Using numbers like 1. Item
- Using asterisks or dashes like \* Item (Correct answer)
- Using \*\* around the text
- Using brackets like \[Item\]

**What is the correct way to strongly emphasise text in Markdown?**

- \_strongly emphasised text\_
- -strongly emphasised text-
- #strongly emphasised text#
- \*\*strongly emphasised text\*\* (Correct answer)

<a id="quarto"></a>

## 11.3 Quarto

Markdown allows you to create static documents in Positron. But to create a report that includes maps, tables and other outputs from R, we need to use Quarto. Quarto is built into Positron, so you can create Quarto documents in much the same way as Markdown documents.

Quarto is a system that converts Markdown documents that contain chunks of code written in R or Python, runs the code and then integrates the Markdown text and the code results into one or more output files. Quarto can produce web pages, Word documents, PDF files, presentations, websites, e-books and other formats.

A Quarto file is just like a Markdown document except that it has the file extension `.qmd` rather than the extension `.md`. The `.qmd` extension tells Positron that a file will contain a mixture of text formatted with Markdown and code that produces tables, charts and so on.

In the rest of this chapter we will develop the code needed to create a report on homicides in Medellín, Colombia. To get started:

1.  Click the **File** menu in Positron, then click **New File ...**.
2.  Type `chapter_11.qmd` in the box marked **Select File Type or Enter File Name...**, then press ReturnReturn.
3.  Save the file in the `output` directory of your `crime_mapping` workspace.

Note that we are saving this file in the `output` directory, not the `R` directory. This is because Positron will save the outputs produced from a Quarto file in the same directory as the Quarto file itself.

Positron opens `.qmd` files in a source editor, where you can see the Markdown and code that make up the document. Keeping the source visible will help you understand exactly how the report is structured.

Quarto documents start with a *header* that provides some basic information about the document, such as the title. Replace the contents of `chapter_11.qmd` with this simple header:

``` {.sourceCode .numberSource .yaml .number-lines .code-with-copy}
---
title:  "Medellín homicides map"
author: "[specify your name]"
date:   "today"
---
```

The header is written in yet another programming language called [YAML](https://en.wikipedia.org/wiki/YAML). You don't need to know the details of YAML to write headers for Quarto documents. Two things you do need to know, though:

- The three dashes (`---`) are important, because they tell Quarto that the content inside the dashes is the document header. **These dashes must appear at the start of a line and be the only characters on that line.**
- Indentation matters in YAML. Every line takes the form `key: value` and in most cases the key must be at the very start of the line. Lines in YAML are not limited to 80 characters, so you should *not* break a single value (such as the document title) over multiple lines.

QuizQuarto

**What is the key difference between a Markdown (`.md`) and a Quarto (`.qmd`) file?**

- Markdown is only used for web pages
- Markdown does not support headings
- Quarto supports embedding executable code (Correct answer)
- Quarto is only used for PDF documents

**What is the main role of the YAML header in a Quarto document?**

- It contains the results of the analysis
- It specifies document metadata like title, author, and output format (Correct answer)
- It automatically saves the document
- It allows Markdown text to be rendered

**What is one benefit of using Quarto over traditional word processors like Microsoft Word?**

- It eliminates the need for writing text
- It automatically corrects mistakes
- It does not require learning new skills
- It allows integration of real-time R computations into the document (Correct answer)

<a id="sec-writing-reports-r-code-in-quarto"></a>
<a id="r-code-in-quarto"></a>

### 11.3.1 R code in Quarto

Quarto will process everything in a Quarto document after the header (marked with `---`) as Markdown text. The only exception is when you include sections of code in a Quarto document.

You can include R code inside a line of Markdown text (known as *inline* code) and the result of that code will be included in the document output. Inline R code begins with a backtick character (`` ` ``) followed by a lower-case `r` and a space, and ends with another backtick. For example, add the following sentence beneath the header in `chapter_11.qmd`:

<a id="lst-reports-inline-date-example"></a>

<figure>
<div class="sourceCode" id="cb1"><pre class="sourceCode numberSource numberSource lang-md number-lines code-with-copy"><code class="sourceCode"><span id="cb1-1"><a href="#cb1-1"></a>This report was written on `r format(Sys.Date(), &quot;%e %B %Y&quot;)`.</span></code></pre></div>
<figcaption>Code 11.2</figcaption>
</figure>

Which would produce the output:

This report was written on 3 October 2026

ImportantRemember spacing is important in Quarto

Where you do (and don't) put spaces matters a lot when writing a Quarto document. For example, the inline R code in [Code 11.2](#lst-reports-inline-date-example) *must* have a space after the `r` at the start of the code chunk but *must not* have a space between the `` ` `` and the `r`, otherwise Quarto will not recognise it as inline R code. So `` `r `` works, but `` ` r `` does not.

Putting R code inline is fine for simple pieces of code, but longer pieces of code included inline would become difficult to read (and therefore difficult to debug). Fortunately, we can put as much code as we like in a *code chunk*. To add an R code chunk to a Quarto document, type ```` ```{r} ```` (three backticks followed immediately by `{r}`) on a line on its own, add the R code on the following lines, then close the chunk with ```` ``` ```` (three more backticks) on a line on its own. Positron will highlight the chunk so that it stands out from the surrounding Markdown text.

We can use code chunks to run longer pieces of code that would be difficult to read if the code were inline. For example, if you wanted to load a data file of crime data, filter it for crimes occurring in a particular month and then count the number of rows, you could do the calculation in a code chunk and then include the result inline:

<a id="lst-reports-count-homicides-example"></a>

<figure>
<div class="sourceCode" id="cb1"><pre class="sourceCode numberSource numberSource default number-lines code-with-copy"><code class="sourceCode default"><span id="cb1-1"><a href="#cb1-1"></a>```{r}</span>
<span id="cb1-2"><a href="#cb1-2"></a>#| label: count-homicides</span>
<span id="cb1-3"><a href="#cb1-3"></a></span>
<span id="cb1-4"><a href="#cb1-4"></a># Count number of homicides in February 2019</span>
<span id="cb1-5"><a href="#cb1-5"></a>homicide_count &lt;- medellin_homicides |&gt;</span>
<span id="cb1-6"><a href="#cb1-6"></a>  filter(year(fecha_hecho) == 2019, month(fecha_hecho) == 2) |&gt;</span>
<span id="cb1-7"><a href="#cb1-7"></a>  nrow()</span>
<span id="cb1-8"><a href="#cb1-8"></a>```</span>
<span id="cb1-9"><a href="#cb1-9"></a></span>
<span id="cb1-10"><a href="#cb1-10"></a>There were `r scales::comma(homicide_count)` homicides recorded in February 2019.</span></code></pre></div>
<figcaption>Code 11.3</figcaption>
</figure>

If Positron does not highlight a code chunk, check that you saved the file with a `.qmd` extension and typed the opening and closing backticks correctly.

To help keep track of code chunks, we can label them. Add `#| label:` immediately below the opening line of the chunk, followed by a short label containing letters, numbers and dashes (`-`). For example, the chunk in [Code 11.3](#lst-reports-count-homicides-example) already has the label `count-homicides`, specified by `#| label: count-homicides`. Labels appear in error messages and make it easier to find which part of a document needs attention.

The package that converts Quarto documents into other formats is called knitr -- actually, it's a bit more complicated than that, but one of the nice things about Quarto is you don't need to worry about what's happening behind the scenes.

Figure: Diagram showing a Quarto source file passing through either knitr or Jupyter to become Markdown. Pandoc then converts the Markdown into HTML, PDF, Word or another output format. Arrows show the order of these rendering stages.

The default Quarto template is set up so that the final document that is produced from your Quarto file will include both the code that you include in any code chunks *and* the output that the code produces. For example, we can use code like this to get our Medellín homicides report started:

<a id="lst-reports-visible-code-example"></a>

<figure>
<pre><code>---
title: &quot;Medellín homicides map&quot;
author: &quot;John Smith&quot;
date: &quot;today&quot;
format: 
  html:
    embed-resources: true
---

```{r}
#| label: setup

# Load packages
pacman::p_load(here, httr2, sf, sfhotspot, tidyverse)

# Create the directory for the original downloaded data
dir.create(here(&quot;data&quot;, &quot;raw&quot;), recursive = TRUE, showWarnings = FALSE)

# Download the original data
request(
  &quot;https://mpjashby.github.io/crimemappingdata/medellin_homicides.csv&quot;
) |&gt;
  req_perform(path = here(&quot;data&quot;, &quot;raw&quot;, &quot;medellin_homicides.csv&quot;))

# Load data
medellin_homicides &lt;- here(&quot;data&quot;, &quot;raw&quot;, &quot;medellin_homicides.csv&quot;) |&gt;
  read_csv2() |&gt;
  # Remove rows with missing coordinates
  drop_na(longitud, latitud) |&gt;
  # Convert the data to an SF object
  st_as_sf(coords = c(&quot;longitud&quot;, &quot;latitud&quot;), crs = &quot;EPSG:4326&quot;)
```

```{r}
#| label: count-homicides

# Count number of homicides in February 2019
homicide_count &lt;- medellin_homicides |&gt;
  filter(year(fecha_hecho) == 2019, month(fecha_hecho) == 2) |&gt;
  nrow()
```

There were `r scales::comma(homicide_count)` homicides recorded in February 2019.</code></pre>
<figcaption>Code 11.4</figcaption>
</figure>

But that code produces the following output. That's probably not what you want because it has the raw R code in it as well as the output from that code:

Media: The default output from a Quarto file includes a copy of the R code in the file [(open media)](../resources/examples/quarto_show_code.html)

We can control the results of code chunks using *chunk options*, sometimes called *knitr options*. We put these on the first line of each code chunk, with each option on a separate line and each line starting with the characters `#|` (referred to as a *hash-pipe*). Note that for Quarto to recognise a line of code as a Quarto chunk option, the line must come immediately after the opening line of the code chunk (```` ```{r} ````) with no blank lines between them, and `#|` *must* be followed by a space.

To specify that the code in our R code chunks should not be printed in the final document, we can set the chunk option `#| echo: false`. To specify that both the R code and the *output* produced by that code (e.g. charts, tables, etc.) should not be shown, we can set the chunk option `#| include: false`.

If we change the code in [Code 11.4](#lst-reports-visible-code-example) to set `#| include: false` to suppress both code and output from the first code chunk and set `#| echo: false` for the second code chunk, the output becomes much more like the report we want:

<a id="lst-reports-hidden-code-example"></a>

<figure>
<pre><code>---
title: &quot;Medellín homicides map&quot;
author: &quot;John Smith&quot;
date: &quot;today&quot;
format: 
  html:
    embed-resources: true
---

```{r}
#| label: setup
#| include: false

# Load packages
pacman::p_load(here, httr2, sf, sfhotspot, tidyverse)

# Create the directory for the original downloaded data
dir.create(here(&quot;data&quot;, &quot;raw&quot;), recursive = TRUE, showWarnings = FALSE)

# Download the original data
request(
  &quot;https://mpjashby.github.io/crimemappingdata/medellin_homicides.csv&quot;
) |&gt;
  req_perform(path = here(&quot;data&quot;, &quot;raw&quot;, &quot;medellin_homicides.csv&quot;))

# Load data
medellin_homicides &lt;- here(&quot;data&quot;, &quot;raw&quot;, &quot;medellin_homicides.csv&quot;) |&gt;
  read_csv2() |&gt;
  # Remove rows with missing coordinates
  drop_na(longitud, latitud) |&gt;
  # Convert the data to an SF object
  st_as_sf(coords = c(&quot;longitud&quot;, &quot;latitud&quot;), crs = &quot;EPSG:4326&quot;)
```

```{r}
#| label: count-homicides
#| echo: false

# Count number of homicides in February 2019
homicide_count &lt;- medellin_homicides |&gt;
  filter(year(fecha_hecho) == 2019, month(fecha_hecho) == 2) |&gt;
  nrow()
```

There were `r scales::comma(homicide_count)` homicides recorded in February 2019.</code></pre>
<figcaption>Code 11.5</figcaption>
</figure>

Media: We can use chunk options to stop raw R code and output from appearing in a document [(open media)](../resources/examples/quarto_hide_code.html)

If a code chunk produces a chart or map, then we *do* want to show the output (although not the code), so in that case we should not set `#| include: false` -- we do not need to set `#| include: true` because it is the default.

Since we probably don't want any chunks in our code to include the code in our final document, we could end up setting the chunk option `#| echo: false` for every code chunk. In a long or complicated document, this would get tedious. Fortunately, we can set chunk options *globally* (i.e. for all chunks in a document) by setting them in the YAML document header. To do this, we add a key called `execute` to the header. Instead of giving the `execute` key a value such as `true` or `false`, we instead indent the *next* line of the header by *exactly* two spaces and then set the chunk option `echo: false`. If we wanted to set multiple global chunk options here, we would put each one on a new line, all of the lines indented by two spaces from the start of each document.

``` {.sourceCode .numberSource .yaml .number-lines .code-with-copy}
---
title: "Medellín homicides map"
author: "John Smith"
date:   "today"
execute:
  echo: false
---
```

You might have noticed in [Code 11.5](#lst-reports-hidden-code-example) that instead of using `read_csv()` to load the data from the file `medellin_homicides.csv`, we are using a function called `read_csv2()`. That's because the file uses semicolons (`;`) to separate the columns, rather than commas. This is a common convention in countries that use a comma as the decimal mark (most countries in Europe and South America, as well as some elsewhere).

If you use `read_csv()` to load a semicolon-delimited file, the values from all the columns on each row appear together in a single column. When you load a dataset and unexpectedly see it has been loaded as one column containing many semicolons, inspect the original file and consider using `read_csv2()` instead.

Add the setup chunk in [Code 11.6](#lst-reports-setup-example) to `chapter_11.qmd`.

<a id="lst-reports-setup-example"></a>

<figure>
<a id="annotated-cell-17"></a>
<div class="sourceCode" id="cb1"><pre class="sourceCode numberSource numberSource default code-annotation-code number-lines code-with-copy"><code class="sourceCode default"><span id="cb1-1"><a href="#cb1-1"></a>```{r}</span>
<span id="cb1-2"><a href="#cb1-2"></a>#| label: setup</span>
<span id="cb1-3"><a href="#cb1-3"></a>#| include: false</span>
<span id="cb1-4"><a href="#cb1-4"></a></span>
<span id="cb1-5"><a href="#cb1-5"></a># Load packages</span>
<span id="cb1-6"><a href="#cb1-6"></a>pacman::p_load(here, httr2, sf, sfhotspot, tidyverse)</span>
<span id="cb1-7"><a href="#cb1-7"></a></span>
<span id="cb1-8"><a href="#cb1-8"></a># Download the original data</span>
<span id="cb1-9"><a href="#cb1-9"></a>request(</span>
<span id="cb1-10"><a href="#cb1-10"></a>  &quot;https://mpjashby.github.io/crimemappingdata/medellin_homicides.csv&quot;</span>
<span id="cb1-11"><a href="#cb1-11"></a>) |&gt;</span>
<span id="cb1-12"><a href="#cb1-12"></a>  req_perform(path = here(&quot;data&quot;, &quot;raw&quot;, &quot;medellin_homicides.csv&quot;))</span>
<span id="cb1-13"><a href="#cb1-13"></a></span>
<span id="cb1-14"><a href="#cb1-14"></a>request(</span>
<span id="cb1-15"><a href="#cb1-15"></a>  &quot;https://mpjashby.github.io/crimemappingdata/medellin_comunas.gpkg&quot;</span>
<span id="cb1-16"><a href="#cb1-16"></a>) |&gt;</span>
<span id="cb1-17"><a href="#cb1-17"></a>  req_perform(path = here(&quot;data&quot;, &quot;raw&quot;, &quot;medellin_comunas.gpkg&quot;))</span>
<span id="cb1-18"><a href="#cb1-18"></a></span>
<span id="cb1-19"><a href="#cb1-19"></a># Load data</span>
<span id="cb1-20"><a href="#cb1-20"></a>medellin_homicides &lt;- here(&quot;data&quot;, &quot;raw&quot;, &quot;medellin_homicides.csv&quot;) |&gt;</span>
<span id="cb1-21"><a href="#cb1-21"></a>  read_csv2() |&gt;</span>
<span id="cb1-22"><a href="#cb1-22"></a>  # Remove rows with missing coordinates</span>
<span id="cb1-23"><a href="#cb1-23"></a>  drop_na(longitud, latitud) |&gt;</span>
<span id="cb1-24"><a href="#cb1-24"></a>  # Convert the data to an SF object</span>
<span id="cb1-25"><a href="#cb1-25"></a>  st_as_sf(coords = c(&quot;longitud&quot;, &quot;latitud&quot;), crs = &quot;EPSG:4326&quot;)</span>
<span id="cb1-26"><a href="#cb1-26"></a></span>
<span id="cb1-27"><a href="#cb1-27"></a>medellin_boundary &lt;- here(&quot;data&quot;, &quot;raw&quot;, &quot;medellin_comunas.gpkg&quot;) |&gt;</span>
<span id="cb1-28"><a href="#cb1-28"></a>  read_sf() |&gt;</span>
<span id="cb1-29"><a href="#cb1-29"></a>  janitor::clean_names() |&gt;</span>
<span id="cb1-30"><a href="#cb1-30"></a>  st_transform(&quot;EPSG:3115&quot;)</span>
<span id="cb1-31"><a href="#cb1-31"></a>```</span></code></pre></div>
<figcaption>Code 11.6</figcaption>
</figure>

1.  Some rows in this dataset have missing coordinates. `st_as_sf()` will produce an error if there are missing coordinates, so we use `drop_na()` to remove them first.
2.  Since the column names are called `longitud` and `latitud`, we know that we should use the WGS84 coordinate reference system, which has the CRS code EPSG:4326.

We transform the neighbourhood boundaries to EPSG:3115 because it is a suitable projected CRS for Medellín. See [Section 6.2.1](../06_mapping_crime_patterns/index.llms.md#sec-choosing-projected-crs) for how to select a projected CRS whose units make distance-based parameters easy to specify.

QuizLoading semicolon-delimited data

**Which function should you use to load a CSV file that uses semicolons to separate its columns?**

- read_sf() from the sf package
- read_csv() from the readr package
- read.csv2() from base R
- read_csv2() from the readr package (Correct answer)

**What does it usually mean if `read_csv()` loads every row into one column containing many semicolons?**

- The file contains no observations
- The file may use semicolons rather than commas as delimiters (Correct answer)
- The file must contain spatial polygons
- The file can only be opened in spreadsheet software

Some of the R code we write produces progress messages or warnings that we will not want to include in our Quarto documents. For example, `hotspot_kde()` normally prints progress messages while it estimates crime density. Those messages are useful to an analyst but would distract a reader of the finished report. When we need to run code that both:

1.  produces messages that we *do not* want to include in the final report, *and*
2.  produces output that we *do* want to include in the final report,

we can split the code into two separate code chunks, storing the result of the code in the first chunk in an object that we then refer to in the second chunk. The first chunk runs the code that produces the messages, but we set `#| include: false` so that neither the code nor the messages appear in the final report. The second chunk runs the code that produces the output we want to include in the report, and we do not set `#| include: false` for that chunk.

Add this code chunk to the `chapter_11.qmd` file. Note that for this chunk we are setting `#| include: false` to suppress the messages that would otherwise be produced by `hotspot_kde()`. Remember that there must be at least one blank line between each code chunk in Quarto documents.

```` {.sourceCode .numberSource .default .number-lines .code-with-copy}
```{r}
#| label: calculate-density
#| include: false

# Calculate crime density
medellin_homicide_density <- medellin_homicides |>
  st_transform("EPSG:3115") |>
  # `hotspot_kde()` prints progress messages by default, but `include: false`
  # prevents them from appearing in the finished report
  hotspot_kde(bandwidth_adjust = 0.33, cell_size = 500) |>
  hotspot_clip(medellin_boundary, quiet = TRUE)
```
````

ImportantThe include option may suppress important warnings

Using `#| include: false` can be useful to stop an output document being littered with R messages and warnings. However, it will also stop you seeing warnings that might be important in highlighting problems you need to fix. If code in a Quarto code chunk is not producing the results you expect, the first thing you should do is remove `#| include: false` from the chunk so that you can see any warnings or messages that you might need to act upon. Once the code is running as you want it to, you can add `#| include: false` back again.

<a id="sec-writing-reports-maps-charts-and-tables-in-quarto-documents"></a>
<a id="maps-charts-and-tables-in-quarto-documents"></a>

### 11.3.2 Maps, charts and tables in Quarto documents

Almost all the documents you produce in Quarto will include one or more maps, charts or tables. Quarto includes tools for providing captions for figures and tables, as well as the ability to refer to them elsewhere in a document.

Maps, charts and tables in Quarto documents are usually the output produced by a chunk of R code. For example, we might use `hotspot_map()` to make a map. To turn a code chunk into a figure we can reference, we need to add two chunk options at the start of the code chunk. We use the `#| label` chunk option to specify what text we will use throughout the rest of the document to refer to the figure or table produced by that code chunk. Note that chunk labels for figures and tables *must* begin with either `fig-` for figures (charts and maps) or `tbl-` for tables. For example, we might label a map with the label `#| label: fig-homicides-map` or a table with the label `#| label: tbl-robbery-counts`. Note that chunk labels can contain letters, numbers and dashes (`-`), but not spaces or other characters.

The second chunk option we should add is either the `#| fig-cap` chunk option (for charts and maps) or the `#| tbl-cap` argument, to create a caption for the chart, map or table. Note that captions should be enclosed in quotes, e.g. `#| tbl-cap: "This is the table caption"`.

Add this code to the `chapter_11.qmd` Quarto file:

<a id="lst-reports-figure-reference-example"></a>

<figure>
<div class="sourceCode" id="cb1"><pre class="sourceCode numberSource numberSource default number-lines code-with-copy"><code class="sourceCode default"><span id="cb1-1"><a href="#cb1-1"></a>@fig-homicides shows the density of homicides in Medellín, Colombia, from 2010 to 2019.</span>
<span id="cb1-2"><a href="#cb1-2"></a></span>
<span id="cb1-3"><a href="#cb1-3"></a>```{r}</span>
<span id="cb1-4"><a href="#cb1-4"></a>#| label: fig-homicides</span>
<span id="cb1-5"><a href="#cb1-5"></a>#| message: false</span>
<span id="cb1-6"><a href="#cb1-6"></a>#| fig-cap: &quot;Density of homicides in Medellín, 2010 to 2019&quot;</span>
<span id="cb1-7"><a href="#cb1-7"></a>#| fig-alt: &quot;Density map of recorded homicides in Medellín, Colombia, from 2010 to 2019. Darker blue indicates higher estimated density, with the strongest concentration in the central urban area and smaller concentrations to the north and west. Comuna boundaries are outlined over a pale street map; the shaded surface represents density rather than individual incidents.&quot;</span>
<span id="cb1-8"><a href="#cb1-8"></a></span>
<span id="cb1-9"><a href="#cb1-9"></a># Note we don&#39;t have to set `#| include: true` for this code chunk, because that</span>
<span id="cb1-10"><a href="#cb1-10"></a># is the default. We do, however, have to set `#| message: false` to suppress</span>
<span id="cb1-11"><a href="#cb1-11"></a># the message about a coordinate system already being present when we add the</span>
<span id="cb1-12"><a href="#cb1-12"></a># boundary layer to the map.</span>
<span id="cb1-13"><a href="#cb1-13"></a></span>
<span id="cb1-14"><a href="#cb1-14"></a># Plot a basic density map</span>
<span id="cb1-15"><a href="#cb1-15"></a>hotspot_map(</span>
<span id="cb1-16"><a href="#cb1-16"></a>  medellin_homicide_density,</span>
<span id="cb1-17"><a href="#cb1-17"></a>  basemap_type = &quot;cartolight&quot;,</span>
<span id="cb1-18"><a href="#cb1-18"></a>  caption = &quot;Homicide data: Alcaldía de Medellín (CC-BY-SA)&quot;</span>
<span id="cb1-19"><a href="#cb1-19"></a>) +</span>
<span id="cb1-20"><a href="#cb1-20"></a>  geom_sf(data = medellin_boundary, colour = &quot;grey25&quot;, fill = NA)</span>
<span id="cb1-21"><a href="#cb1-21"></a>```</span></code></pre></div>
<figcaption>Code 11.7</figcaption>
</figure>

Once we have set the label and the caption for a code chunk, we can use that label to insert cross-references into our document. For example, in [Code 11.7](#lst-reports-figure-reference-example) you can see that the code chunk that creates the map of homicides in Medellín has the chunk option `#| label: fig-homicides`. In the same listing, just before the code chunk, the figure produced by that chunk is referenced in the text using the code `@fig-homicides`. You can see in the output below that the cross-reference `@fig-homicides` has been changed to the text 'Figure 1', that the cross-reference is a hyperlink (to the part of the document containing the map) and that the map now has a caption that starts 'Figure 1'.

Media: An HTML file produced by Quarto that shows a figure with a caption and a cross-reference in the text. [(open media)](../resources/reports/medellin_homicides_map.html)

You might have noticed we also added the chunk option `#| fig-alt` to the code chunk that produces the map. This is because we are producing an HTML document, and HTML documents should be accessible to people who use assistive technology such as screen readers. The `#| fig-alt` chunk option allows us to provide a short description of the figure that will be read out by a screen reader. You can find out more about accessibility in Quarto documents on the [Quarto website](https://quarto.org/docs/publishing/accessibility.html).

QuizUsing code in Quarto documents

**What happens if you set the option `#| echo: false` in a Quarto code chunk?**

- The code is hidden, but the output is displayed (Correct answer)
- The output is hidden, but the code is displayed
- Both code and output are hidden
- The document fails to render

**Why is it useful to name code chunks in Quarto?**

- It speeds up code execution
- It automatically changes the output format
- It makes debugging easier (Correct answer)
- It is required for Quarto to run

**What happens if you set the option `#| include: false` in a Quarto code chunk?**

- The code is hidden, but the output is displayed
- The output is hidden, but the code is displayed
- Both code and output are hidden (Correct answer)
- The document fails to render

<a id="rendering-quarto"></a>

## 11.4 Rendering Quarto

Once you've written the text for your document and added the code needed to produce statistics, tables and figures, it's time to convert your Quarto file to a document in the format you need. This process is called *rendering* (or sometimes *knitting*) the document.

Figure: A round hedgehog in a yellow beanie, knitting a teal scarf. Behind them are different outputs from \"knitting\" documents in R, including PDF, Word, LaTeX, HTML, slides, e-books, dashboards and websites.

In Positron you can render a Quarto document by clicking the **Preview** button at the top-right of the editor. If you cannot see this button, check that you saved the file with a `.qmd` extension. By default, Quarto will produce an HTML file (a web page) and open it in Positron's Viewer.

You can control the output format by changing the `format:` value in the YAML header of your Quarto document. The default is `format: html`, but you can also use `format: pdf` to produce a PDF file, `format: docx` to produce a Word document, `format: epub` to produce an e-book or `format: pptx` to produce a PowerPoint presentation. There are [many other output formats available](https://quarto.org/docs/output-formats/all-formats.html).

TipUse HTML output if possible

If you have a choice of which format to produce a report in, I would suggest you choose HTML because it can do things (like include interactive maps made with leaflet) that Word and PDF format cannot, and can easily be read on mobile devices. Well-formatted HTML documents are also much more accessible to people who need assistive technology such as screen readers for blind and partially sighted people. If, for whatever reason, you cannot choose HTML, I recommend choosing PDF format since it is readable on almost all computers, even those that do not have Word installed on them. Only produce reports in Word format if you are specifically required to submit something in that format.

Whatever format you choose, the output file will be saved in the same folder as your `.qmd` file and will have the same file name but with a different file extension (`.html`, `.pdf`, `.docx`, etc.). If you render the document again, Quarto will overwrite the previous output file.

When you render a Quarto document, Quarto starts a fresh R session and runs all the code in the file so that it can combine the results with the document text. The document can use only packages loaded and objects created inside that document. Objects you created interactively in Positron's R Console are not available. This may be frustrating at first, but it reveals missing steps and helps keep the report reproducible.

Since rendering runs all the code in the document, that code may produce an error. The error will appear in the Terminal tab in Positron and will identify the code chunk in which the problem occurred. Meaningful chunk labels make these messages easier to follow. Read the message, find the named chunk and then use the techniques we learned in [Chapter 8](../08_handling_bugs/index.llms.md) to fix the issue.

<a id="sec-writing-reports-making-self-contained-html-documents"></a>
<a id="making-self-contained-html-documents"></a>

### 11.4.1 Making self-contained HTML documents

Web pages written in HTML typically make use of images, videos and other resources stored in separate files. In fact, the web page you're reading now makes use of resources stored in 51 separate files. This works well on the web, since it allows resources to be shared between lots of HTML files, which reduces how much data has to be stored and transmitted across networks. But it works less well when you want to send an HTML report to someone else over email, since it can be hard to keep track of all the external files associated with a particular HTML file.

To deal with this problem, we can tell Quarto that when it creates an HTML report, all the necessary data and other resources should be embedded inside the HTML file itself. This makes the HTML file larger, but easier to manage. To make HTML reports produced by Quarto self-contained in this way, we can change the `format` section of the header of a Quarto document from simply `format: html` to instead specify exactly what settings we want to be used to create that HTML file:

``` {.sourceCode .numberSource .yaml .number-lines .code-with-copy}
format:
  html:
    embed-resources: true
```

There are lots of other ways we can use the `format` section of the header in a Quarto document to fine-tune how the resulting document works. You can find out more [in the HTML section of the Quarto website](https://quarto.org/docs/output-formats/html-basics.html).

QuizRendering Quarto documents

**What happens when Quarto renders a document containing R code?**

- It copies objects from the current Console session into the report
- It starts a fresh R session and runs the code in the document (Correct answer)
- It converts every code chunk into an image
- It changes the source file into a Word document

**What does `embed-resources: true` do for an HTML report?**

- It prevents R code from running
- It saves all resources in a separate folder
- It stores resources inside the HTML file so it is easier to share (Correct answer)
- It makes the report editable in Microsoft Word

<a id="in-summary"></a>

## 11.5 In summary

In this chapter we have learned how to use Markdown to create structured text and integrate that text with code and results in a Quarto report. This makes our work reproducible and reduces the risk of mistakes caused by copying statistics and graphics into software such as Word.

It also means we can produce periodic reports with updated data very easily, since we can just choose the data we want the report to be based on using `filter()` at the start of our file and render the document. This can save a huge amount of time in producing reports such as performance bulletins or monthly summaries of crime in an area.

We have practised how to:

- structure reports using Markdown headings, paragraphs, lists and inline elements;
- configure a Quarto document using a YAML header;
- add inline R code and labelled code chunks;
- control code, messages and output using chunk options;
- label and cross-reference figures and tables; and
- render self-contained reports in different formats.

To consolidate these skills, make the following changes to the `chapter_11.qmd` report you have developed throughout this chapter:

1.  Render the file as a self-contained HTML report.
2.  Render the file in at least one other format, such as Word. If you have installed tinytex, compare the PDF and HTML versions.
3.  Restart R, then render the document again to check that it does not depend on objects in your previous R session.

Your complete `chapter_11.qmd` file should now look like this:

    ---
    title: "Medellín homicides map"
    author: "John Smith"
    date: "today"
    format:
      html:
        embed-resources: true
        fig-cap-location: top
    execute:
      echo: false
    ---

    ```{r}
    #| label: setup
    #| include: false

    # Load packages
    pacman::p_load(here, httr2, sf, sfhotspot, tidyverse)

    # Create the directory for the original downloaded data
    dir.create(here("data", "raw"), recursive = TRUE, showWarnings = FALSE)

    # Download the original data into the project
    request(
      "https://mpjashby.github.io/crimemappingdata/medellin_homicides.csv"
    ) |>
      req_perform(path = here("data", "raw", "medellin_homicides.csv"))

    request(
      "https://mpjashby.github.io/crimemappingdata/medellin_comunas.gpkg"
    ) |>
      req_perform(path = here("data", "raw", "medellin_comunas.gpkg"))

    # Load homicide data from the local copy
    medellin_homicides <- here("data", "raw", "medellin_homicides.csv") |>
      read_csv2() |>
      drop_na(longitud, latitud) |>
      st_as_sf(coords = c("longitud", "latitud"), crs = "EPSG:4326")

    medellin_boundary <- here("data", "raw", "medellin_comunas.gpkg") |>
      read_sf() |>
      janitor::clean_names() |>
      st_transform("EPSG:3115")
    ```

    ```{r}
    #| label: calculate-density
    #| include: false

    # Calculate crime density
    medellin_homicide_density <- medellin_homicides |>
      st_transform("EPSG:3115") |>
      # `hotspot_kde()` prints progress messages by default, but `include: false`
      # prevents them from appearing in the finished report
      hotspot_kde(bandwidth_adjust = 0.33, cell_size = 500) |>
      hotspot_clip(medellin_boundary, quiet = TRUE)
    ```

    @fig-homicides shows the density of homicides in Medellín, Colombia, from 2010 to 2019.

    ```{r}
    #| label: fig-homicides
    #| message: false
    #| fig-cap: "Density of homicides in Medellín, 2010 to 2019"
    #| fig-alt: "Density map of recorded homicides in Medellín, Colombia, from 2010 to 2019. Darker blue indicates higher estimated density, with the strongest concentration in the central urban area and smaller concentrations to the north and west. Comuna boundaries are outlined over a pale street map; the shaded surface represents density rather than individual incidents."

    # Note we don't have to set `#| include: true` for this code chunk, because that
    # is the default. We do, however, have to set `#| message: false` to suppress
    # the message about a coordinate system already being present when we add the
    # boundary layer to the map.

    # Plot a basic density map
    hotspot_map(
      medellin_homicide_density,
      basemap_type = "cartolight",
      caption = "Homicide data: Alcaldía de Medellín (CC-BY-SA)"
    ) +
      geom_sf(data = medellin_boundary, colour = "grey25", fill = NA)
    ```

Save `chapter_11.qmd` by pressing .

You can also download [a second complete example report](../resources/reports/medellin_homicides_table.qmd), which produces a table rather than a map, to practise these skills with a different output. This file uses the gt package to make a professional table, which we will learn more about in [Chapter 14](../14_no_maps/index.llms.md). You can find these examples and reusable templates in [Appendix F](../appendices/resources.llms.md).

There is a lot more you can do with Quarto. To find out more, refer to these resources.

- [R for Data Science chapter on Quarto](https://r4ds.hadley.nz/quarto.html).
- A [gallery of different documents, websites and presentations written with Quarto](https://quarto.org/docs/gallery/).
- The Quarto guides to [Markdown basics](https://quarto.org/docs/authoring/markdown-basics.html), [code-cell options](https://quarto.org/docs/computations/execution-options.html) and [cross-references](https://quarto.org/docs/authoring/cross-references.html).

QuizRevision questions

Answer these questions to check you have understood the main points covered in this chapter. Write between 50 and 100 words to answer each question.

1.  Why is reproducibility important in writing reports, and why does non-reproducible analysis risk providing decision makers with the wrong information?
2.  How does Markdown help structure a report, and what are some key Markdown formatting features?
3.  What role does the YAML header play in a Quarto document, and how can it be customized?
4.  What are chunk options in Quarto, and how do they affect the final output of a report?
5.  How does Quarto improve the workflow of integrating tables, charts, and maps into reports?

[Artwork by Allison Horst](https://allisonhorst.com/)
