Source: https://books.lesscrime.info/learncrimemapping/2026/08_handling_bugs/index.html

<a id="quarto-document-content"></a>
<a id="title-block-header"></a>
<a id="handling-bugs-in-your-code"></a>

# `<a id="sec-bugs"></a>`{=html}8  Handling bugs in your code

Figure: Students inspect and repair a disconnected link in an analytical workflow.

In this chapter, we will learn how to identify and fix bugs in R code. We will learn how to interpret messages, warnings and errors, and how to distinguish between different types of error. The chapter also introduces a systematic debugging process that you can use to find and fix problems. We will practise diagnosing problems in code and asking others for help when we need it.

TipBefore you start

1.  Open Positron or -- if you already have Positron open -- start a new R session by clicking the **Restart R** (**⟳**) button in the **Console** panel. This makes sure no code you ran previously will interfere with the work you do in this chapter.
2.  Make sure you are working in the crime mapping project workspace you created in [Section 1.5](../01_getting_started/index.llms.md#sec-create-project). In the top-right corner of the Positron window, you should see a folder icon and the words `crime_mapping`. If not, click the **File** menu, then **Open Folder ...** and choose the `crime_mapping` folder.

<a id="introduction"></a>

## 8.1 Introduction

In this chapter we will learn how to deal with bugs in the R code that we write. Bugs in code are inevitable. Everyone who writes code makes mistakes. But even when no-one has made a mistake, there are lots of other reasons why code that previously worked well eventually does not. Learning how to identify and fix bugs is part of the process of learning to code.

In this chapter, we will learn how to:

- distinguish messages, warnings and errors;
- recognise syntax errors, runtime errors and logic errors;
- find the smallest piece of code that produces a problem;
- inspect the data used and produced by each step in an analysis;
- use R manual pages to understand functions;
- recognise and resolve conflicts between functions with the same name;
- create a reproducible example when asking for help; and
- assess suggestions from online sources and generative AI critically.

TipBut can't I just use AI to fix my code?

Whether an AI tool such as ChatGPT or Gemini can fix your code depends on the nature of the problem, the information you provide and the features available to you. AI tools can solve many problems well, but they can also produce plausible suggestions that are wrong.

It's not always possible to rely on AI to fix problems with our code, and even when it is possible, it is still useful to understand the solution the AI is suggesting. We'll explore using AI to help us fix bugs in our code in [Section 8.6](#sec-ai-debugging).

<a id="sec-preventing-bugs"></a>
<a id="preventing-bugs"></a>

## 8.2 Preventing bugs

The easiest bug to fix is one that never reaches your code. Good working habits cannot prevent every mistake, but they make mistakes less likely and make the remaining bugs much easier to find.

- **Keep files organised.** Work inside the `crime_mapping` workspace, store original data in `data/raw`, processed data in `data/processed`, scripts in `R` and analytical output in `output` (see [Section 1.5](../01_getting_started/index.llms.md#sec-create-project) to remind yourself about this if necessary). Use relative paths rather than paths that work only on your computer (see [Section 5.4](../05_your_second_crime_map/index.llms.md#sec-spatial-data)).
- **Give files informative names.** Use lower-case letters, numbers and underscores, and add padded numbers where several scripts must run in order. See [Section 5.2](../05_your_second_crime_map/index.llms.md#sec-file-names).
- **Give objects meaningful names.** Use lower-case snake case and choose a name that describes what the object contains. Do not reuse the names of functions or overwrite an existing object with unrelated contents. See [Section 3.2.2](../03_data_wrangling/index.llms.md#sec-naming-objects).
- **Write readable scripts.** Use comments to explain the purpose of a script and its main stages, and use blank lines or section headings to separate distinct tasks. See [Section 5.5](../05_your_second_crime_map/index.llms.md#sec-comments).
- **Use consistent formatting.** Air formats R code automatically when you save it, making inconsistent spacing and indentation easier to avoid. If Air cannot format a file, check first for an incomplete expression or syntax error. See the Air setup in [Section 1.5](../01_getting_started/index.llms.md#sec-create-project).
- **Keep the complete analysis in a script.** Permanent code belongs in a named script, while temporary inspection code belongs in the Console. Restart R and run the complete script from beginning to end before relying on its results. See [Section 2.2](../02_your_first_crime_map/index.llms.md#sec-permanent-code).

These practices do not merely make code look tidy. They reduce ambiguity and complexity in your code, both of which are common underlying causes of code bugs. When files, objects and stages have predictable names and structure, unexpected code stands out and the source of a problem is easier to isolate.

QuizPreventing bugs

**Which habit makes an analysis easier to check and reproduce?**

- Run each permanent line directly in the Console and do not save it
- Use a different naming style for each object so that names stand out
- Keep permanent code in a named script and run the complete script from a new R session (Correct answer)
- Store downloaded data in the same folder as R scripts

**Why does consistent formatting help with debugging?**

- It prevents every possible bug
- It makes unusual or incomplete code easier to notice (Correct answer)
- It allows R to guess what incomplete code should do
- It automatically corrects logic errors

In this chapter we will look at examples of errors using a dataset of frauds in Kansas City in the United States. To get started, download the file and load it into R:

<a id="lst-handling-bugs-load-fraud-examples"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Load packages</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, httr2, tidyverse)</span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Download the data and store the original file</span></span>
<span id="cb2-5"><a href="#cb2-5"></a><span class="fu">request</span>(</span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="st">&quot;https://mpjashby.github.io/crimemappingdata/kansas_city_frauds.csv.gz&quot;</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>) <span class="sc">|&gt;</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="fu">req_perform</span>(<span class="at">path =</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;kansas_city_frauds.csv.gz&quot;</span>))</span>
<span id="cb2-9"><a href="#cb2-9"></a></span>
<span id="cb2-10"><a href="#cb2-10"></a><span class="co"># Load the local file</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>frauds <span class="ot">&lt;-</span> <span class="fu">read_csv</span>(<span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;kansas_city_frauds.csv.gz&quot;</span>))</span></code></pre></div>
<figcaption>Code 8.1</figcaption>
</figure>

TipWhy did we run this code in the R Console?

<a id="callout-4"></a>

Normally when we load packages and data, we do it in an R script file. We do that because this code is needed as part of the complete script that produces a particular map. In this chapter we won't be creating a map, just looking at examples of errors, so we won't need to keep any of the code for later.

This is what the first few lines of the dataset look like:

  ------------------------------------------------------------------------------------------------------------------
        uid offense_code   offense_type                                 date                    longitude   latitude
  --------- -------------- -------------------------------------------- --------------------- ----------- ----------
    9362175 26B            credit card/automated teller machine fraud   2015-02-14 11:05:00      -94.5715    39.1086

    9362176 26B            credit card/automated teller machine fraud   2015-02-14 11:05:00      -94.5715    39.1086

    9362201 26A            false pretenses/swindle/confidence game      2015-02-14 13:30:00      -94.6568    39.2453

    9362202 26A            false pretenses/swindle/confidence game      2015-02-14 13:30:00      -94.6568    39.2453

    9362213 26C            impersonation                                2015-02-14 15:00:00      -94.5886    38.9956

    9362214 26C            impersonation                                2015-02-14 15:00:00      -94.5886    38.9956
  ------------------------------------------------------------------------------------------------------------------

  : Example rows from the Kansas City fraud dataset

In this chapter we will go through the process of debugging -- identifying, understanding and fixing errors in your code. Sometimes fixing issues with your code can feel like a bit of a roller coaster, but (like most things) it becomes much easier with practice, and if you approach errors in a systematic way.

Figure: Cartoon of ten monsters moving through stages of debugging, in two rows. Initial confidence gives way to confusion, restarting, frustration, a meltdown and exhaustion. A light bulb marks renewed hope, typing resumes, and the final monster celebrates with I love coding. The sequence normalises setbacks before a problem is solved.

<a id="errors-warnings-and-messages"></a>

## 8.3 Errors, warnings and messages

When something is not quite right, or just when there is an issue in your code that you should be aware of, R has three ways of communicating with you: messages, warnings and errors (these are collectively sometimes called *conditions*).

<a id="sec-handling-bugs-messages"></a>
<a id="messages"></a>

### 8.3.1 Messages

*Messages* are usually for information only and typically don't require you to take any action. For example, the `ggsave()` function issues a message to tell you the dimensions of the saved image.

<a id="lst-handling-bugs-crimedata-example"></a>

<figure>
<pre><code>Do not run this code</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">ggsave</span>(<span class="st">&quot;example_plot.png&quot;</span>, <span class="at">plot =</span> <span class="fu">ggplot</span>())</span></code></pre></div>
<figcaption>Code 8.2</figcaption>
</figure>

    Saving 7 x 5 in image

Messages appear in the **Console** panel along with other output from R. When R prints a message about your code, any code underneath the code that generated the message will still run. For example, if you run these three lines of code (the second of which prints a message, using the `message()` function), the line after the message will run as expected:

<a id="lst-handling-bugs-messages-still-run"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="dv">2</span> <span class="sc">*</span> <span class="dv">2</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="fu">message</span>(<span class="st">&quot;This is a message. Make sure you understand it.&quot;</span>)</span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="dv">2</span> <span class="sc">/</span> <span class="dv">2</span></span></code></pre></div>
<figcaption>Code 8.3</figcaption>
</figure>

    [1] 4

    This is a message. Make sure you understand it.

    [1] 1

<a id="sec-handling-bugs-warnings"></a>
<a id="warnings"></a>

### 8.3.2 Warnings

*Warnings* are generated when there is a potential problem with your code, but the problem was not serious enough to stop your code running entirely. For example, applying `st_centroid()` to polygons with attribute columns consistently produces the warning `st_centroid assumes attributes are constant over geometries`. The function still creates the centroid points, but warns that it has copied each polygon's attribute values to the corresponding point.

Warnings are important and you should take time to read and understand them, but it is *possible* that, having done so, it will be safe to take no action. *Whether* it is safe to take no action will often depend on exactly what you are trying to do. If you created the centroids only to position labels, copying attributes such as an area name may be exactly what you intended, so no action is needed. However, an attribute such as population describes the whole polygon rather than its centre point. You would need to consider whether treating that value as an attribute of the centroid could make the subsequent analysis misleading.

ImportantIt is not safe to simply ignore warnings

**It is not safe to ignore warnings** unless you are sure why they occurred and certain that you don't need to take any action. If your code produces a warning, it is not safe to 'leave it until later' and carry on writing the rest of your code: work out straight away if you need to take any action.

One particularly dangerous scenario is where your code produces warnings but still produces what looks like a reasonable result. In these circumstances it can be tempting to ignore the warnings and assume that everything is fine, since the code still produced roughly what you were expecting. However, it's possible that the plausible answer is nevertheless wrong because of whatever problem is generating the warning in R. Do not assume that warnings are safe to ignore just because they don't stop your code running.

As with messages, warnings will not stop your code running. This means that if the warning signalled a genuine problem with your code, the results of the lines underneath the warning might not be reliable. That is why it is important to understand warnings when you see them.

<a id="sec-handling-bugs-errors"></a>
<a id="errors"></a>

### 8.3.3 Errors

*Errors* are generated when R cannot complete the current operation. An error might occur, for example, because `read_csv()` could not open a requested file. Errors are generally used for more-serious issues that prevent an operation from running successfully, so an error occurring stops the code being run at that point. When you run a complete script that has an error in it, R will stop running the script at the point where the error occurred. That means any code above the error will still have run, but code below the error will not have done.

<a id="types-of-code-bugs"></a>

## 8.4 Types of code bugs

Much like their animal namesakes, bugs in code come in many different varieties. We can divide bugs into three categories to make them easier to think about: *syntax errors*, *runtime errors* and *logic errors*.

<a id="sec-handling-bugs-syntax-errors"></a>
<a id="syntax-errors"></a>

### 8.4.1 Syntax errors

Syntax errors happen when R cannot interpret your code because of a mistake in how it has been typed. For example, if you forget to put a comma between the arguments of a function, you will get this error:

<a id="lst-handling-bugs-show-syntax-error"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">c</span>(<span class="st">&quot;A&quot;</span> <span class="st">&quot;B&quot;</span>)</span></code></pre></div>
<figcaption>Code 8.4</figcaption>
</figure>

    Error in parse(text = input): <text>:1:7: unexpected string constant
    1: c("A" "B"
              ^

This error is caused by a missing comma between the two arguments `"A"` and `"B"` -- the code should have been `c("A", "B")`.

When you run a complete script, R first checks whether the script can be interpreted as valid R code. A syntax error can therefore stop the script before any of it runs. When you run one expression at a time in Positron, code above a later syntax error may still run. Positron will often underline syntax errors in the **Editor**. Another indication there is a syntax error in your code is that a syntax error will usually mean the Air formatter is unable to format a script. Syntax errors are often caused by missing commas, quote marks or closing parentheses. Since syntax errors stop your script from running entirely, it's usually immediately apparent that a syntax error has occurred. Syntax errors are usually quite quick to fix, since they are usually caused by typos.

<a id="sec-handling-bugs-runtime-errors"></a>
<a id="runtime-errors"></a>

### 8.4.2 Runtime errors

Runtime errors happen when R can read the code (i.e. there are no syntax errors) but cannot complete the steps that the code sets out. For example, R can read the code `3 * "A"` (`*` in R means 'multiply by'). But R cannot multiply the number `3` by the character value `"A"` -- trying to multiply a number by a letter makes no sense.

<a id="lst-handling-bugs-show-runtime-error"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="dv">3</span> <span class="sc">*</span> <span class="st">&quot;A&quot;</span></span></code></pre></div>
<figcaption>Code 8.5</figcaption>
</figure>

    Error in `3 * "A"`:
    ! non-numeric argument to binary operator

TipWhat is a 'binary operator', and what are its arguments?

<a id="callout-6"></a>

The phrase "non-numeric argument to binary operator" might be a bit confusing. A binary operator is an operator that takes two arguments, such as `+`, `-`, `*` or `/`. Operators in R don't look like functions, but they act a lot like them. But whereas the arguments to a function are specified within parentheses, the arguments to a binary operator are specified on either side of the operator. In this case, the two arguments to the `*` operator are `3` and `"A"`. The error message is telling us that one of the arguments is not numeric, so R cannot complete the calculation.

Trying to load data from a missing file, trying to refer to a non-existent column name or trying to use a function on the wrong type of object are other issues that can cause runtime errors.

When R runs a complete script file, it checks the syntax before evaluating the expressions in that script. But since every step in your code depends on the steps before it, R cannot tell whether a particular expression may cause a runtime error until the expressions before it have run successfully. That's why these are called *runtime* errors -- they only happen when your code is run. If your code contains multiple issues that will cause runtime errors, R will typically only tell you about the first one because it cannot reach any later errors until the first has been fixed. That makes runtime errors harder to manage than syntax errors.

<a id="sec-handling-bugs-logic-errors"></a>
<a id="logic-errors"></a>

### 8.4.3 Logic errors

There is a saying in programming that a computer will do exactly what you tell it to do, but that that may not be the same as what you *wanted* it to do. A logic error happens when the code runs but produces a result that is incorrect in some way. For example, we might inadvertently write code that accidentally filters out some rows in a dataset that we actually needed to keep. There is no way for R to know that you didn't intend to filter out those rows, so it will happily follow your instructions even though they will lead to the wrong result. For that reason, logic errors often don't cause an R error message. They are often only visible because they cause unexpected results later on in a script.

Logic errors are often the hardest bugs to find because there may be no error messages in the R console and the output produced by a script can look plausible, even if it's wrong. To identify logic errors, you must inspect the data produced at each important stage and compare the result with what you expected. Simple checks using functions such as `head()`, `nrow()`, `count()` and `summary()` can expose unexpected results before they affect later parts of an analysis.

Now that we have explored messages, warnings and errors, we need to find out how to deal with them when they happen.

QuizMessages, warnings and errors

**Which of the following terms is used in R to describe the way of communicating something for information only?**

- A message (Correct answer)
- A warning
- An error
- A condition

**Which of these statements is true?**

- It is generally okay not to worry about warnings produced by R code -- in most cases you won\'t need to take any action anyway
- While you will often not need to take any action in response to a warning produced by your R code, it is still important to understand what caused the warning just in case you need to take action (Correct answer)

**What type of bug occurs when code runs but produces the wrong result?**

- A syntax error
- A runtime error
- A logic error (Correct answer)
- A message

**What is the difference between a syntax error and a runtime error?**

- A syntax error stops R interpreting the code, while a runtime error occurs when R cannot complete an operation (Correct answer)
- A syntax error produces an incorrect result, while a runtime error always produces a warning
- A syntax error occurs only in the Console, while a runtime error occurs only in scripts
- There is no difference between syntax errors and runtime errors

<a id="sec-finding-bugs"></a>
<a id="tracking-down-bugs"></a>

## 8.5 Tracking down bugs

If an error or warning has a simple cause, such as trying to multiply a number by a character value, you can just fix the problem and re-run the code. Or if your code only has one line, it will probably be obvious where any problem lies.

For problems that are more difficult to handle, you will need to follow a step-by-step process to find and fix them. Think of this as like being a mechanic fixing a car -- first you work out what the problem is, then you fix it.

To identify the cause of bugs in our code we will use a four-step process:

Understand

messages, warnings and unexpected results

Isolate

the smallest piece of code that produces the problem

Inspect

the data used and produced by that code

Get help

using a reproducible example

Sometimes it won't be necessary to go through all the steps because the problem will be easy to fix, but it's still useful to follow the process from the start until we reach a solution.

<a id="sec-handling-bugs-step-1-understand-the-problem"></a>
<a id="step-1-understand-the-problem"></a>

### 8.5.1 Step 1: Understand the problem

The first step in diagnosing a problem with our code is to reproduce it, then read *and understand* any errors, warnings or messages produced. For simple bugs this will often be enough to solve the problem. For example, if you were to try to run this code with the `frauds` dataset we loaded in [Code 8.1](#lst-handling-bugs-load-fraud-examples):

<a id="lst-handling-bugs-select-missing-column-error"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">select</span>(frauds, offense_category)</span></code></pre></div>
<figcaption>Code 8.6</figcaption>
</figure>

You would see that R produced an error message saying something like:

    Error in `select()`:
    ! Can't select columns that don't exist.
    ✖ Column `offense_category` doesn't exist.

In this case it is fairly easy to identify that the error message is telling us that one of the columns we have tried to select does not exist. Maybe we misremembered the name of the column. To find out what the correct column name is, the easiest thing to do is to print the first few rows of the object in the R Console:

<a id="lst-handling-bugs-head-frauds"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">head</span>(frauds)</span></code></pre></div>
<figcaption>Code 8.7</figcaption>
</figure>

    # A tibble: 6 × 6
          uid offense_code offense_type       date                longitude latitude
        <dbl> <chr>        <chr>              <dttm>                  <dbl>    <dbl>
    1 9362175 26B          credit card/autom… 2015-02-14 11:05:00     -94.6     39.1
    2 9362176 26B          credit card/autom… 2015-02-14 11:05:00     -94.6     39.1
    3 9362201 26A          false pretenses/s… 2015-02-14 13:30:00     -94.7     39.2
    4 9362202 26A          false pretenses/s… 2015-02-14 13:30:00     -94.7     39.2
    5 9362213 26C          impersonation      2015-02-14 15:00:00     -94.6     39.0
    6 9362214 26C          impersonation      2015-02-14 15:00:00     -94.6     39.0

From this, we can see that the column we want to select is called `offense_type`, not `offense_category`.

In other cases, error messages will be harder to interpret. Imagine we wanted to break a long string of text into multiple lines. To do that we might use the `str_wrap()` function, which we previously used to format text in [Chapter 7](../07_map_context/index.llms.md). But if we run this code, we get a runtime error:

<a id="lst-handling-bugs-wrap-text-invalid-argument"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">str_wrap</span>(<span class="st">&quot;A line of text that we want to break into shorter lines&quot;</span>, <span class="at">length =</span> <span class="dv">20</span>)</span></code></pre></div>
<figcaption>Code 8.8</figcaption>
</figure>

    Error in `str_wrap()`:
    ! unused argument (length = 20)

From the error message, it looks like there's nothing wrong with the string of text, but that there is an issue with the argument `length = 20`. One possibility is that we've got the name of this argument wrong. To understand the problem, we can check the manual page for the `str_wrap()` function. Functions provided by R and R packages normally have a manual page that explains what the function does, what arguments it takes and what value it returns. You can get a lot of help in understanding each function by referring to its manual page. You can access the manual page for a function in Positron by:

- typing a question mark followed by the function name (e.g. `?str_wrap`) into the R Console;
- typing the function name into the search box in the **Help** panel; or
- placing the cursor on the function name in your R code and pressing on your keyboard.

Any of these options opens the manual page in Positron's **Help** panel. For example, you can load the manual page for `str_wrap()` from the stringr package by typing `?str_wrap` in the R Console.

All manual pages have the same format.

Description
: This section gives a short description of what the function does. If multiple related functions are described in a single manual page, this section will explain the differences between them.

Usage
: This section shows how to write a call to the function, including the names and default values of its arguments. For example, the manual page for `str_wrap()` shows that the default value of the `width` argument is `width = 80`.

Arguments
: This section gives a list of arguments and the values they can take. It is particularly important to note the type of value expected. For example, the `st_transform()` function from the sf package expects a spatial object, such as an SF object, as its first argument -- if you provide a non-spatial object such as a tibble, this will cause an error.

Value
: This section explains the type of value that the function will return, and whether this value might be of a different type depending on the values of particular arguments.

Examples
: This section gives more examples of how the function can be used.

Checking the manual page for a function can often help you understand why a particular piece of code is not working. In this case, we can see that `str_wrap()` doesn't have a `length` argument, which is why our code produced an error. The correct argument name is `width`, so we can fix the code by changing `length = 20` to `width = 20`.

<a id="lst-handling-bugs-wrap-text-correct-argument"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">str_wrap</span>(<span class="st">&quot;A line of text that we want to break into shorter lines&quot;</span>, <span class="at">width =</span> <span class="dv">20</span>)</span></code></pre></div>
<figcaption>Code 8.9</figcaption>
</figure>

    [1] "A line of text that\nwe want to break\ninto shorter lines"

<a id="sec-function-conflicts"></a>
<a id="conflicts-between-function-names"></a>

#### 8.5.1.1 Conflicts between function names

Checking a manual page is only useful if it describes the function that R is actually using. R packages are written by people working in many different areas, so packages sometimes contain functions with the same name. Those functions might do similar things, or they might do completely different things.

For example, dplyr contains a function called `select()` that selects columns from a data frame. The MASS package also contains a function called `select()`, but it is used for a different purpose and has different arguments. If both packages are loaded, R will normally use the function from the package that was loaded most recently.

Imagine that we loaded the tidyverse first and MASS second:

<a id="lst-handling-bugs-load-mass-after-tidyverse"></a>

<figure>
<pre><code>Do not run this code</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(tidyverse, MASS)</span></code></pre></div>
<figcaption>Code 8.10</figcaption>
</figure>

Since MASS was loaded last, a call to `select()` will now use the function of that name from MASS, not the function from the dplyr package loaded by tidyverse. Code intended to select the `offense_type` column would then produce an error like this:

<a id="lst-handling-bugs-select-function-conflict"></a>

<figure>
<pre><code>Do not run this code</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">select</span>(frauds, offense_type)</span></code></pre></div>
<figcaption>Code 8.11</figcaption>
</figure>

    Error in `MASS::select()`:
    ! unused argument (offense_type)

The error says that `offense_type` is an unused argument because the `select()` function from the MASS package does not have an argument for selecting columns. This is why an error about an argument can sometimes mean that R is using a different function from the one you intended.

The tidyverse packages contain several functions that share names with functions in other packages. For example, dplyr and the stats package both contain a function called `filter()`. We usually want `dplyr::filter()` when working with data frames, because `stats::filter()` is designed for time-series data and is only useful in that context.

The guiding principle in this book is to load packages in alphabetical order, **then load tidyverse last**:

<a id="lst-handling-bugs-load-tidyverse-after-mass"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(MASS, tidyverse)</span></code></pre></div>
<figcaption>Code 8.12</figcaption>
</figure>

Loading tidyverse last means that calls to `select()` and `filter()` will normally use the dplyr versions that we need for data wrangling.

If changing the package-loading order is not appropriate, or if you need to use both versions of a function in the same script, use `::` to specify the package explicitly. For example, `dplyr::select(frauds, offense_type)` always uses the dplyr function, regardless of the order in which packages were loaded.

ImportantLoad tidyverse last

One way to minimise how confusing package conflicts can be is to always load packages in a consistent order. I strongly recommend loading packages in alphabetical order, *then* loading the tidyverse package *last*.

TipUsing the conflicted package

<a id="callout-9"></a>

The conflicted package provides another way to manage function-name conflicts. It produces an error if you use the name of a function provided by more than one loaded package, unless you have specified which version you prefer.

Load conflicted before calling `pacman::p_load()`, then use `conflict_prefer()` after loading the other packages:

<a id="lst-handling-bugs-resolve-function-conflicts"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">library</span>(conflicted)</span>
<span id="cb2-2"><a href="#cb2-2"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(MASS, tidyverse)</span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="fu">conflict_prefer</span>(<span class="st">&quot;select&quot;</span>, <span class="st">&quot;dplyr&quot;</span>)</span>
<span id="cb2-5"><a href="#cb2-5"></a><span class="fu">conflict_prefer</span>(<span class="st">&quot;filter&quot;</span>, <span class="st">&quot;dplyr&quot;</span>)</span></code></pre></div>
<figcaption>Code 8.13</figcaption>
</figure>

In the rest of the script, unqualified calls to `select()` and `filter()` will use the dplyr functions. You can learn more in the [conflicted package documentation](https://conflicted.r-lib.org/).

QuizPackage conflicts

**If you load two packages in R that both contain a function with the same name, which function will R use by default?**

- The function that is from the tidyverse suite of packages.
- The function from the package that was loaded first
- The function from the package that was loaded last (Correct answer)
- Neither function will run because R will produce an error.

TipWhat should I do if an error mentions `rlang::last_trace()`?

<a id="callout-11"></a>

Some errors produced by tidyverse packages suggest running `rlang::last_trace()`. This command shows the sequence of function calls that led to the error. The output can be long, so first look for a line that refers to your script or to a function you called. You do not need to understand the internal package functions listed in the trace.

<a id="sec-handling-bugs-step-2-isolate-the-code-that-produces-the-problem"></a>
<a id="step-2-isolate-the-code-that-produces-the-problem"></a>

### 8.5.2 Step 2: Isolate the code that produces the problem

If Step 1 isn't enough to resolve the issue, the second task is to work out exactly which function or other piece of code has caused the problem. For example, take this data-wrangling code that is designed to reduce the size of a dataset and sort it in date order:

<a id="lst-handling-bugs-filter-misspelt-offence-column"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>frauds <span class="sc">|&gt;</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>  <span class="fu">select</span>(offense_type, date, longitude, latitude) <span class="sc">|&gt;</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">filter</span>(offence_type <span class="sc">==</span> <span class="st">&quot;impersonation&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">arrange</span>(date)</span></code></pre></div>
<figcaption>Code 8.14</figcaption>
</figure>

    Error in `filter()`:
    ℹ In argument: `offence_type == "impersonation"`.
    Caused by error:
    ! object 'offence_type' not found

This code produces a structured error message. The first line tells us that the error occurred in `filter()`, the information line identifies the argument that caused the problem and the final line describes the immediate cause:

    ! object 'offence_type' not found

This suggests the error is on line 3 of the code, since that is the only line containing a reference to `offence_type`. To check this, we can *comment out* that line by placing a `#` symbol at the start of the line. One easy way to do that is to click anywhere on the line and then type . Do this and re-run [Code 8.14](#lst-handling-bugs-filter-misspelt-offence-column) -- it should now run without a problem.

Now we know the problem is on the line `filter(offence_type == "impersonation")`, we can look at that line in more detail. Can you spot the problem with that line?

The error message in this case has been caused by a typo -- the code `offence_type == "impersonation"` uses the British spelling of the word 'offence' but in the dataset the variable is spelled using the American English 'offense' (you can see the US spelling in the `select()` call in [Code 8.14](#lst-handling-bugs-filter-misspelt-offence-column)). Fix the typo and re-run [Code 8.14](#lst-handling-bugs-filter-misspelt-offence-column) in Positron.

Sometimes a bug is introduced on one line but only becomes visible later. Consider this separate example, in which `select()` removes a column that is needed by `arrange()` later in the pipeline:

<a id="lst-handling-bugs-isolate-fraud-filter"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>frauds <span class="sc">|&gt;</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>  <span class="fu">select</span>(offense_code, longitude, latitude) <span class="sc">|&gt;</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">filter</span>(offense_code <span class="sc">==</span> <span class="st">&quot;26A&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">arrange</span>(date)</span></code></pre></div>
<figcaption>Code 8.15</figcaption>
</figure>

    Error in `arrange()`:
    ℹ In argument: `..1 = date`.
    Caused by error:
    ! `..1` must be a vector, not a function.

The message seems to tell us that the error occurs in `arrange()`. But looking at that line of code, there is nothing obviously wrong. `arrange()` is a function in a package that we've loaded (`arrange()` is in the dplyr package, which was loaded automatically when we loaded the tidyverse package), and `date` is a column in the original `frauds` dataset. So why is R producing an error message? We could look at the manual page by typing `?arrange` in the R Console, but let's imagine we've done that already and it didn't help.

A useful next step in these circumstances is to look at the *inputs* a function is receiving. This can be important because while the error message suggests the problem is in `arrange()`, it's possible that the *cause* of the error is some problem with a previous part of our code and that `arrange()` is just the first function to notice the problem. In cases like that, an error message can be technically correct but somewhat misleading.

A good way to identify which line of a code pipeline is causing the problem is to comment out all the lines except the first one, then run the code and see if it produces an error. If no error appears and the result produced by that line looks reasonable, then we continue to uncomment one line at a time until we find the problem.

Re-run [Code 8.15](#lst-handling-bugs-isolate-fraud-filter), but comment out all the lines except the first one by putting `#` at the start of each line. Remember to remove the `|>` from the end of the last *uncommented* line of code, since otherwise you will find the code does not run as expected. Your code should now look like this:

<a id="lst-handling-bugs-inspect-fraud-selection"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>frauds</span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="co"># select(offense_code, longitude, latitude) |&gt;</span></span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="co"># filter(offense_code == &quot;26A&quot;) |&gt;</span></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># arrange(date)</span></span></code></pre></div>
<figcaption>Code 8.16</figcaption>
</figure>

If you run this code, it will simply print the first few lines of the dataset. Remove the `#` comment symbol from the second line of the code and run it again, remembering to replace the pipe operator (`|>`) at the end of line 1 and remove the `|>` at the end of line 2.

<a id="lst-handling-bugs-inspect-fraud-filter"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>frauds <span class="sc">|&gt;</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>  <span class="fu">select</span>(offense_code, longitude, latitude)</span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="co"># filter(offense_code == &quot;26A&quot;) |&gt;</span></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># arrange(date)</span></span></code></pre></div>
<figcaption>Code 8.17</figcaption>
</figure>

Again, the code does not produce an error -- but the result now has only three columns. Checking the output at this stage shows that the `date` column has been removed. Add `date` to the list of columns that are included in `select()` before continuing.

Uncommenting one line at a time is useful for runtime errors, but it is equally important to look for unexpected output. [Code 8.18](#lst-handling-bugs-filter-impersonation-frauds) runs without an error:

<a id="lst-handling-bugs-filter-impersonation-frauds"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>frauds <span class="sc">|&gt;</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>  <span class="fu">select</span>(offense_code, date, longitude, latitude) <span class="sc">|&gt;</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">filter</span>(offense_code <span class="sc">==</span> <span class="st">&quot;26E&quot;</span>)</span></code></pre></div>
<figcaption>Code 8.18</figcaption>
</figure>

    # A tibble: 0 × 4
    # ℹ 4 variables: offense_code <chr>, date <dttm>, longitude <dbl>,
    #   latitude <dbl>

There is no error message, but there are no rows left in the result. This is a logic error because we expected the result to contain frauds. There are no rows for which `offense_code` has the value `"26E"`. If we use `count()` to list the unique values of `offense_code`, we can see that the only values are "26A", "26B", and "26C":

<a id="lst-handling-bugs-count-fraud-offence-codes"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">count</span>(frauds, offense_code)</span></code></pre></div>
<figcaption>Code 8.19</figcaption>
</figure>

    # A tibble: 3 × 2
      offense_code     n
      <chr>        <int>
    1 26A              2
    2 26B              2
    3 26C              2

Uncommenting one line at a time until you find an error or unexpected output is a useful way to isolate problems, but it will not always work. In particular, it will not identify code that is missing entirely. For example, the pipeline in [Code 8.20](#lst-handling-bugs-transform-nonspatial-data-error) omits the step that changes the tibble into an SF object before using `st_transform()`:

<a id="lst-handling-bugs-transform-nonspatial-data-error"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>frauds <span class="sc">|&gt;</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>  <span class="fu">select</span>(offense_code, longitude, latitude) <span class="sc">|&gt;</span></span>
<span id="cb2-3"><a href="#cb2-3"></a>  <span class="fu">filter</span>(offense_code <span class="sc">==</span> <span class="st">&quot;26A&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  sf<span class="sc">::</span><span class="fu">st_transform</span>(<span class="st">&quot;EPSG:3603&quot;</span>)</span></code></pre></div>
<figcaption>Code 8.20</figcaption>
</figure>

    Error in `UseMethod()`:
    ! no applicable method for 'st_transform' applied to an object of class "c('tbl_df', 'tbl', 'data.frame')"

In these cases it is particularly useful to check every argument that you have used in a function, using its manual page as described in Step 1.

<a id="sec-handling-bugs-step-3-inspect-the-data-used-and-produced-by-each-step"></a>
<a id="step-3-inspect-the-data-used-and-produced-by-each-step"></a>

### 8.5.3 Step 3: Inspect the data used and produced by each step

Not all runtime errors are caused by problems with the code itself. Some bugs are caused by a mismatch between the structure your data actually has and the structure you thought it had when you wrote the code. We have already seen this in the code that referred to a column called `offense_category` in a dataset without that column.

Bugs caused by a mismatch between the data you think you have and the data you actually have can be particularly frustrating because you cannot identify them by looking only at your code. Look at both the data used as input and the data produced by each important step. We used this technique in [Code 8.17](#lst-handling-bugs-inspect-fraud-filter) to find that `filter()` had removed every row because the value we specified was not present.

Finding data problems is one of the reasons why we have used the `head()` function so often, starting in [Section 3.2.2](../03_data_wrangling/index.llms.md#sec-naming-objects) to look at the data at each step in writing a block of code. Looking at the results of a particular block of code before moving on to writing the next block can often save you from frustrating errors later on.

`head()` only shows the first few rows of a dataset, so it will not reveal every possible problem. You can use the `view()` function instead to open a complete version of the dataset in Positron's **Data Explorer**. The Data Explorer lets you inspect values, sort and temporarily filter rows, and see summaries for each column. These changes affect only the view and do not alter the object in R.

There are many other functions available for inspecting data. For a large dataset, functions such as `count()`, `distinct()`, `glimpse()` and `summary()` are often more useful than trying to inspect every row. You can use `slice_sample(frauds, n = 10)` to inspect ten random rows or `slice_sample(frauds, prop = 0.1)` to inspect 10% of the rows. However, a random sample can miss rare values, including the value causing a bug, so do not assume that a sample represents every part of the data.

QuizFinding and understanding bugs

**What is a useful way to find where a bug was introduced?**

- Change several arguments at once so that one of them is likely to work
- Inspect only the final result because intermediate results do not matter
- Run the code one stage at a time and inspect the result after each stage (Correct answer)
- Ignore a result with zero rows if R did not produce an error

**What can a function's manual page help you check?**

- Only the name of the package containing the function
- The inputs a function expects, its arguments and the value it returns (Correct answer)
- A guarantee that the function is suitable for your analysis
- A list of every bug that the function can produce

<a id="sec-reprex"></a>
<a id="step-4-get-help-using-a-reproducible-example"></a>

### 8.5.4 Step 4: Get help using a reproducible example

If you cannot fix a bug using the techniques we have already covered, it may be time to get some help from someone else. R has a large online community and generative AI tools can provide a lot of help, but people and bots can only help if they have enough information.

Figure: A person wearing a \'code hero\' cape and holding a laptop says \'I\'m doing a thing all on my own\', while labelled hot-air balloons and a trampoline show the maintainers, teachers, bloggers, mentors, friends, developers, contributors, support and community helping them.

One of the things that makes it much more likely that you will find useful help with your problem is if you phrase your plea for help in a way that makes it easier to help you. We can do this by providing a *reproducible example* of our problem (also sometimes called a *reprex* or a *minimum working example*).

Producing a reprex makes it much easier for someone (or an AI tool) to understand your issue. Asking why some code did not work without showing the code and data is like asking why your attempts to bake a cake failed without providing a copy of the recipe. A reprex provides the equivalent of the recipe and the result, allowing someone else to investigate the same problem.

To make a reprex, we have to do three things:

1.  Remove everything from the code that does not contribute to the problem. Keep only the code needed to produce the same error or unexpected result -- this is why a reproducible example is sometimes called a *minimal* working example.
2.  Make sure someone can run the example on their computer. This might involve using a dataset built into an R package or creating a small example dataset that has the same relevant structure as your data.
3.  Remove confidential, personal or otherwise sensitive information. Never share sensitive crime data, passwords, API keys or other credentials in a reprex.

To practise making a reproducible example, we will create a new R script that we know will produce an error. Click **File**, then **New File ...** and choose **R File**. Save the file as `chapter_08.R` in the `R` folder of your crime mapping workspace, then paste [Code 8.21](#lst-handling-bugs-show-chapter-08-error-script) into it:

<a id="lst-handling-bugs-show-chapter-08-error-script"></a>

<figure>
<div class="sourceCode" id="cb1"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb1-1"><a href="#cb1-1"></a><span class="co"># Load packages</span></span>
<span id="cb1-2"><a href="#cb1-2"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, sf, sfhotspot, tidyverse)</span>
<span id="cb1-3"><a href="#cb1-3"></a><span class="co"># Load Bronx shootings dataset and wrangle it</span></span>
<span id="cb1-4"><a href="#cb1-4"></a>bronx_shootings <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;bronx_shootings.csv&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb1-5"><a href="#cb1-5"></a>  <span class="fu">read_csv</span>() <span class="sc">|&gt;</span></span>
<span id="cb1-6"><a href="#cb1-6"></a>  janitor<span class="sc">::</span><span class="fu">clean_names</span>() <span class="sc">|&gt;</span></span>
<span id="cb1-7"><a href="#cb1-7"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;longitude&quot;</span>, <span class="st">&quot;latitude&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:4326&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb1-8"><a href="#cb1-8"></a>  <span class="fu">rename</span>(<span class="at">shooting_date =</span> occur_date, <span class="at">fatal =</span> murder) <span class="sc">|&gt;</span></span>
<span id="cb1-9"><a href="#cb1-9"></a>  <span class="co"># Keep only fatal shootings</span></span>
<span id="cb1-10"><a href="#cb1-10"></a>  <span class="fu">filter</span>(fatal <span class="sc">==</span> <span class="cn">TRUE</span>) <span class="sc">|&gt;</span></span>
<span id="cb1-11"><a href="#cb1-11"></a>  <span class="fu">select</span>(shooting_date, incident_key)</span>
<span id="cb1-12"><a href="#cb1-12"></a></span>
<span id="cb1-13"><a href="#cb1-13"></a><span class="co"># Load NYPD precincts and filter to keep just those from the Bronx</span></span>
<span id="cb1-14"><a href="#cb1-14"></a>bronx_precincts <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nyc_precincts.gpkg&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb1-15"><a href="#cb1-15"></a>  <span class="fu">read_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb1-16"><a href="#cb1-16"></a>  janitor<span class="sc">::</span><span class="fu">clean_names</span>() <span class="sc">|&gt;</span></span>
<span id="cb1-17"><a href="#cb1-17"></a>  <span class="co"># Filter just those precincts that are in the Bronx (40th to 52nd)</span></span>
<span id="cb1-18"><a href="#cb1-18"></a>  <span class="fu">filter</span>(precinct <span class="sc">%in%</span> <span class="dv">40</span><span class="sc">:</span><span class="dv">52</span>)</span>
<span id="cb1-19"><a href="#cb1-19"></a></span>
<span id="cb1-20"><a href="#cb1-20"></a><span class="co"># Map shootings</span></span>
<span id="cb1-21"><a href="#cb1-21"></a>bronx_shootings <span class="sc">+</span></span>
<span id="cb1-22"><a href="#cb1-22"></a>  <span class="fu">hotspot_map</span>(</span>
<span id="cb1-23"><a href="#cb1-23"></a></span>
<span id="cb1-24"><a href="#cb1-24"></a>    <span class="at">basemap_type =</span> <span class="st">&quot;none&quot;</span>,</span>
<span id="cb1-25"><a href="#cb1-25"></a>    <span class="at">caption =</span> <span class="st">&quot;Shootings data: NYC Open Data&quot;</span>,</span>
<span id="cb1-26"><a href="#cb1-26"></a>    <span class="at">alpha =</span> <span class="fl">0.5</span>,</span>
<span id="cb1-27"><a href="#cb1-27"></a>    <span class="at">colour =</span> <span class="st">&quot;red2&quot;</span></span>
<span id="cb1-28"><a href="#cb1-28"></a>  ) <span class="sc">+</span></span>
<span id="cb1-29"><a href="#cb1-29"></a>  <span class="co"># Add precinct boundaries</span></span>
<span id="cb1-30"><a href="#cb1-30"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> bronx_precincts, <span class="at">colour =</span> <span class="st">&quot;grey50&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb1-31"><a href="#cb1-31"></a>  <span class="fu">labs</span>(</span>
<span id="cb1-32"><a href="#cb1-32"></a>    <span class="at">title =</span> <span class="st">&quot;Fatal shootings in the Bronx&quot;</span>,</span>
<span id="cb1-33"><a href="#cb1-33"></a>    <span class="at">subtitle =</span> <span class="st">&quot;January to December 2019&quot;</span></span>
<span id="cb1-34"><a href="#cb1-34"></a>  ) <span class="sc">+</span></span>
<span id="cb1-35"><a href="#cb1-35"></a>  <span class="fu">theme</span>(</span>
<span id="cb1-36"><a href="#cb1-36"></a>    <span class="at">plot.title =</span> <span class="fu">element_text</span>(<span class="at">colour =</span> <span class="st">&quot;grey30&quot;</span>, <span class="at">face =</span> <span class="st">&quot;bold&quot;</span>, <span class="at">hjust =</span> <span class="fl">0.5</span>),</span>
<span id="cb1-37"><a href="#cb1-37"></a>    <span class="at">plot.subtitle =</span> <span class="fu">element_text</span>(<span class="at">hjust =</span> <span class="fl">0.5</span>)</span>
<span id="cb1-38"><a href="#cb1-38"></a>  )</span></code></pre></div>
<figcaption>Code 8.21</figcaption>
</figure>

When you run this code, you should see some messages and then this error:

    Rows: 267 Columns: 5
    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: ","
    dbl  (3): incident_key, longitude, latitude
    lgl  (1): murder
    date (1): occur_date

    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

    Error in `UseMethod()`:
    ! no applicable method for 'hotspot_map' applied to an object of class "character"

As you can see, this error is not easy to decipher (although it does suggest the problem is related to the `hotspot_map()` function), so we might need help to deal with it.

<a id="reproducible-code"></a>

#### 8.5.4.1 Reproducible code

The first step in producing a reprex is to remove every line from our code that isn't necessary to produce the error. To do that, we start with the *last* line of code and remove it, then re-run the code. If the code produces *the same error*, we know that the error wasn't caused or affected by anything on the line that we have removed. In that case, we don't need to include that line of code in the reprex. On the other hand, if the error message disappears and the code runs successfully, *or* the error message changes to a different error, we know that the line of code we removed influenced the error in some way. In that case, we need to include that line of code in the reprex.

Following this process line by line, it is actually possible to remove a lot of the original code and still produce the same error. In fact, we only need to keep seven lines of the original code:

<a id="lst-handling-bugs-script-08-error-highlighted"></a>

<figure>
<pre><code>chapter_08.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Load packages</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, sf, sfhotspot, tidyverse) </span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="co"># Load Bronx shootings dataset and wrangle it</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>bronx_shootings <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;bronx_shootings.csv&quot;</span>) <span class="sc">|&gt;</span> </span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="fu">read_csv</span>() <span class="sc">|&gt;</span> </span>
<span id="cb2-7"><a href="#cb2-7"></a>  janitor<span class="sc">::</span><span class="fu">clean_names</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;longitude&quot;</span>, <span class="st">&quot;latitude&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:4326&quot;</span>) <span class="sc">|&gt;</span> </span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="fu">rename</span>(<span class="at">shooting_date =</span> occur_date, <span class="at">fatal =</span> murder) <span class="sc">|&gt;</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="co"># Keep only fatal shootings</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="fu">filter</span>(fatal <span class="sc">==</span> <span class="cn">TRUE</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-12"><a href="#cb2-12"></a>  <span class="fu">select</span>(shooting_date, incident_key)</span>
<span id="cb2-13"><a href="#cb2-13"></a></span>
<span id="cb2-14"><a href="#cb2-14"></a><span class="co"># Load NYPD precincts and filter to keep just those from the Bronx</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>bronx_precincts <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nyc_precincts.gpkg&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>  <span class="fu">read_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>  janitor<span class="sc">::</span><span class="fu">clean_names</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="co"># Filter just those precincts that are in the Bronx (40th to 52nd)</span></span>
<span id="cb2-19"><a href="#cb2-19"></a>  <span class="fu">filter</span>(precinct <span class="sc">%in%</span> <span class="dv">40</span><span class="sc">:</span><span class="dv">52</span>)</span>
<span id="cb2-20"><a href="#cb2-20"></a></span>
<span id="cb2-21"><a href="#cb2-21"></a><span class="co"># Map shootings</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>bronx_shootings <span class="sc">+</span> </span>
<span id="cb2-23"><a href="#cb2-23"></a>  <span class="fu">hotspot_map</span>(</span>
<span id="cb2-24"><a href="#cb2-24"></a>    </span>
<span id="cb2-25"><a href="#cb2-25"></a>    <span class="at">basemap_type =</span> <span class="st">&quot;none&quot;</span>, </span>
<span id="cb2-26"><a href="#cb2-26"></a>    <span class="at">caption =</span> <span class="st">&quot;Shootings data: NYC Open Data&quot;</span>,</span>
<span id="cb2-27"><a href="#cb2-27"></a>    <span class="at">alpha =</span> <span class="fl">0.5</span>,</span>
<span id="cb2-28"><a href="#cb2-28"></a>    <span class="at">colour =</span> <span class="st">&quot;red2&quot;</span></span>
<span id="cb2-29"><a href="#cb2-29"></a>  ) <span class="sc">+</span> </span>
<span id="cb2-30"><a href="#cb2-30"></a>  <span class="co"># Add precinct boundaries</span></span>
<span id="cb2-31"><a href="#cb2-31"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> bronx_precincts, <span class="at">colour =</span> <span class="st">&quot;grey50&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-32"><a href="#cb2-32"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-33"><a href="#cb2-33"></a>    <span class="at">title =</span> <span class="st">&quot;Fatal shootings in the Bronx&quot;</span>,</span>
<span id="cb2-34"><a href="#cb2-34"></a>    <span class="at">subtitle =</span> <span class="st">&quot;January to December 2019&quot;</span></span>
<span id="cb2-35"><a href="#cb2-35"></a>  ) <span class="sc">+</span></span>
<span id="cb2-36"><a href="#cb2-36"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-37"><a href="#cb2-37"></a>    <span class="at">plot.title =</span> <span class="fu">element_text</span>(<span class="at">colour =</span> <span class="st">&quot;grey30&quot;</span>, <span class="at">face =</span> <span class="st">&quot;bold&quot;</span>, <span class="at">hjust =</span> <span class="fl">0.5</span>),</span>
<span id="cb2-38"><a href="#cb2-38"></a>    <span class="at">plot.subtitle =</span> <span class="fu">element_text</span>(<span class="at">hjust =</span> <span class="fl">0.5</span>)</span>
<span id="cb2-39"><a href="#cb2-39"></a>  )</span></code></pre></div>
<figcaption>Code 8.22</figcaption>
</figure>

That means we can remove these parts of [Code 8.22](#lst-handling-bugs-script-08-error-highlighted):

1.  The comments.
2.  The code that wrangles the shootings data in ways that don't affect this particular error.
3.  The code that loads and wrangles the precinct boundaries.
4.  The code that fine-tunes the appearance of the map.

We cannot remove the code that loads necessary packages, loads the shootings data and converts it to an SF object, or produces the basic unformatted map. These are the highlighted lines in [Code 8.22](#lst-handling-bugs-script-08-error-highlighted). If we remove any of those lines, the error message either changes to a different error message or disappears.

Removing the lines we don't need to reproduce the error leaves `chapter_08.R` looking like this. Note that we've also removed tailing `|>` and `+` operators that no longer connect to another line of code.

<a id="lst-handling-bugs-show-minimal-bronx-error"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, sf, sfhotspot, tidyverse)</span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a>bronx_shootings <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;bronx_shootings.csv&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">read_csv</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;longitude&quot;</span>, <span class="st">&quot;latitude&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:4326&quot;</span>)</span>
<span id="cb2-6"><a href="#cb2-6"></a></span>
<span id="cb2-7"><a href="#cb2-7"></a>bronx_shootings <span class="sc">+</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="fu">hotspot_map</span>(<span class="at">basemap_type =</span> <span class="st">&quot;none&quot;</span>)</span></code></pre></div>
<figcaption>Code 8.23</figcaption>
</figure>

    Error in `UseMethod()`:
    ! no applicable method for 'hotspot_map' applied to an object of class "character"

ImportantIf the error message changes, keep that line of code

If we forgot to remove an operator at the end of a shortened expression, the code could produce a different error. The purpose of producing a reprex is to find the minimum code that still produces *the same problem* we are interested in. If you remove a line and the problem changes, put that line back -- the fact that the error message changed means that line of code has some relevance to reproducing the error you're interested in.

Even though we have removed most of [Code 8.22](#lst-handling-bugs-script-08-error-highlighted), the shorter code in [Code 8.23](#lst-handling-bugs-show-minimal-bronx-error) still produces the same error message. The bug must therefore be in one of the few remaining expressions. This makes the problem much easier to understand than it was in the original script.

TipBut wouldn't this map look very different?

<a id="callout-14"></a>

If this shortened code ran successfully rather than producing an error, the resulting map would look very different to the original map we wanted. But in this context that does not matter, because what we are interested in is isolating the lines of code that produce the specific error we want to find and fix.

<a id="reproducible-data"></a>

#### 8.5.4.2 Reproducible data

Our shortened code would make a useful example except for one thing: the data file `bronx_shootings.csv` only exists on your computer (because we downloaded it in [Section 7.5](../07_map_context/index.llms.md#sec-creating-storing-map)). Someone trying to run the code elsewhere would instead get an error saying that the file could not be found.

You might not be able to share the original data that your code uses, for example if it is sensitive or too large to share. Fortunately, many R packages include small datasets for learning and testing. You can see a list of the datasets available in loaded packages by typing `data()` in the R Console.

To use one of these datasets, refer to its name as you would any other R object. The sfhotspot package comes with some small datasets specifically designed for testing the package functions, so since the issue might well be related to `hotspot_map()` we will use one of the sfhotspot example datasets (called `memphis_robberies_jan`) in place of the Bronx shooting data we used originally.

The data are on a different topic, but that does not matter because we're only interested in the diagnosing the error. We can inspect `memphis_robberies_jan` using `head()` as usual.

<a id="lst-handling-bugs-head-memphis-robberies-jan"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="fu">head</span>(memphis_robberies_jan)</span></code></pre></div>
<figcaption>Code 8.24</figcaption>
</figure>

    Simple feature collection with 6 features and 3 fields
    Geometry type: POINT
    Dimension:     XY
    Bounding box:  xmin: -90.018 ymin: 35.058 xmax: -89.86 ymax: 35.201
    Geodetic CRS:  WGS 84
    # A tibble: 6 × 4
           uid offense_type     date                        geometry
         <int> <fct>            <dttm>                   <POINT [°]>
    1 15213800 personal robbery 2019-01-01 01:30:00 (-89.942 35.149)
    2 15214030 personal robbery 2019-01-01 20:00:00  (-89.86 35.059)
    3 15214042 personal robbery 2019-01-01 21:58:00 (-89.929 35.058)
    4 15214050 personal robbery 2019-01-01 22:30:00 (-90.018 35.201)
    5 15214118 personal robbery 2019-01-02 09:38:00   (-89.96 35.14)
    6 15214242 personal robbery 2019-01-02 18:50:00 (-89.953 35.159)

We can see that the `memphis_robberies_jan` dataset is already an SF object, containing point locations, so we will be able to use it instead of the `bronx_shootings` object that is created in the original code. Since `memphis_robberies_jan` is already an SF object, we can also remove the `st_as_sf()` function from the code (and no longer need to load the sf package). Since `memphis_robberies_jan` is already available in the sfhotspot package, we can also remove the `read_csv()` function that loads the Bronx shootings data from a file (which means we don't need to load the here package, either).

Let's try substituting the `memphis_robberies_jan` dataset for the `bronx_shootings` dataset in our shortened code and check that the error message is still the same:

<a id="lst-handling-bugs-script-08-minimal"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(sfhotspot, tidyverse)</span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a>memphis_robberies_jan <span class="sc">+</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">hotspot_map</span>(<span class="at">basemap_type =</span> <span class="st">&quot;none&quot;</span>)</span></code></pre></div>
<figcaption>Code 8.25</figcaption>
</figure>

    Error in `UseMethod()`:
    ! no applicable method for 'hotspot_map' applied to an object of class "character"

We have reduced the original script to three lines and made the example reproducible using a widely available dataset. The shorter code still produces the same error but is much easier to read.

Most of the time, the act of producing a reprex will be enough for us to find and fix the error without any external help. Can you see the problem with our code that is making this error happen? If not, we will reveal it at the end of this chapter.

<a id="checking-your-reprex-is-reproducible"></a>

#### 8.5.4.3 Checking your reprex is reproducible

Now that you have the minimum code needed to reproduce the error, it's almost time to share it with people who can help you. But before you do that, it's worth checking that the code is truly reproducible. To do this we will use the reprex package, which is part of the tidyverse suite of packages you already have installed.

Figure: Two-part cartoon labelled reprex: make reproducible examples, help them help you. On the left, monsters exchange confused cries while trying to provide support. On the right, one hands over a small reprex and receives thanks, illustrating how a clear example makes help easier.

[](https://reprex.tidyverse.org/)

Make sure the `chapter_08.R` file now only contains the three-line minimal working example in [Code 8.25](#lst-handling-bugs-script-08-minimal), then save the file. Now run this command in the R Console:

<a id="lst-handling-bugs-create-script-reprex"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>reprex<span class="sc">::</span><span class="fu">reprex</span>(<span class="at">input =</span> <span class="fu">here</span>(<span class="st">&quot;R&quot;</span>, <span class="st">&quot;chapter_08.R&quot;</span>))</span></code></pre></div>
<figcaption>Code 8.26</figcaption>
</figure>

The reprex package runs the example in a separate R session (to avoid conflicts with your current workspace) and produces a preview containing both the code and its output. In this case, the output from the reprex tool will look like this:

<a id="lst-handling-bugs-save-script-reprex"></a>

<figure>
<div class="sourceCode" id="cb1"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb1-1"><a href="#cb1-1"></a><span class="co"># THIS CODE MUST BE RUN MANUALLY BEFORE THE CHAPTER IS RENDERED, OTHERWISE THE</span></span>
<span id="cb1-2"><a href="#cb1-2"></a><span class="co"># `include` DIRECTIVE BELOW WON&#39;T WORK</span></span>
<span id="cb1-3"><a href="#cb1-3"></a></span>
<span id="cb1-4"><a href="#cb1-4"></a>reprex<span class="sc">::</span><span class="fu">reprex</span>(</span>
<span id="cb1-5"><a href="#cb1-5"></a>  <span class="at">input =</span> here<span class="sc">::</span><span class="fu">here</span>(<span class="st">&quot;R&quot;</span>, <span class="st">&quot;chapter_08_minimal.R&quot;</span>),</span>
<span id="cb1-6"><a href="#cb1-6"></a>  <span class="at">html_preview =</span> <span class="cn">FALSE</span>,</span>
<span id="cb1-7"><a href="#cb1-7"></a>  <span class="at">advertise =</span> <span class="cn">FALSE</span></span>
<span id="cb1-8"><a href="#cb1-8"></a>)</span></code></pre></div>
<figcaption>Code 8.27</figcaption>
</figure>

``` {.sourceCode .numberSource .r .number-lines .code-with-copy}
pacman::p_load(sfhotspot, tidyverse)

memphis_robberies_jan +
  hotspot_map(basemap_type = "none")
#> Error in `UseMethod()`:
#> ! no applicable method for 'hotspot_map' applied to an object of class "character"
```

You can see that the reprex tool produces a file that contains all the R code in the original script and the output from each line of code as a comment. This makes it easy for anyone (or any tool) that we send this output to to see exactly what code we ran and what output it produced, without needing to run the code themselves. We can also see that the error message is still the same as before.

ImportantCheck for sensitive information before sharing

Read the complete reprex before sharing it. Check the code, data, file paths, output and error message for personal information, confidential crime data, usernames, credentials or any other information that should not be public.

QuizReproducible examples and asking for help

**What should a reprex contain?**

- The complete analysis and the original confidential dataset
- The smallest code and non-sensitive data needed to reproduce the same problem (Correct answer)
- Only a screenshot of the error message
- Every package installed on your computer

**What makes a request for debugging help easier to answer?**

- Post the question on as many websites as possible
- Use a title such as \'R problem\' so that it applies broadly
- Explain the expected result and include a checked reprex (Correct answer)
- Remove the error message because it might distract readers

For more information on writing reproducible examples, see:

- Watch the webinar [Creating reproducible examples with reprex](https://reprex.tidyverse.org/articles/learn-reprex.html) by Jenny Bryan.
- Read the [Reprex do's and don'ts](https://reprex.tidyverse.org/articles/reprex-dos-and-donts.html) on the reprex package website.

<a id="sec-ai-debugging"></a>
<a id="using-generative-ai-to-help-with-debugging"></a>

## 8.6 Using generative AI to help with debugging

Now we've created a reprex, the next step is to share it with someone who can help. If you are being taught R by an instructor, use the support routes provided for your course first. But in many cases, the easiest way to get help will be by using a generative AI tool based on a large language model (LLM).

One useful application for tools such as ChatGPT, Gemini and Claude that are based on LLMs is helping to write and debug code. Having access to an AI tool doesn't mean that you don't need to know how to code. No AI tool is perfect, so you need to know enough to check that its suggestions are correct for your data and analytical goal. But LLMs can be very helpful in many circumstances.

There are many different LLM services available, and they are constantly changing. Some are free to use, while others require a paid subscription. Some are designed for general-purpose use, while others are specifically designed for coding. Some are designed to be used in a web browser, while others can be integrated directly into software such as Positron.

Most people's starting point with AI tools will be a web-based chat bot service such as ChatGPT or Microsoft Copilot. These services are designed to be easy to use. They can only use the code, files or connected sources that you make available to them. Some services can run code or inspect uploaded files, but these capabilities vary by service, account and configuration.

Much more useful for helping write and debug code are AI tools that are specifically designed for that purpose. There are many of these available, such as Open AI Codex, Claude Code and GitHub Copilot. Once set up, these tools have access to the code and data in a project, so they can base their answers on much more information. The way all LLM tools work means that the more information you provide, the more likely it is that the tool will give you a useful answer, so these tools can be much more helpful than a general-purpose chat bot. The main limitation of these tools is that they are not free (some are very expensive!) and that they often require some technical skill to set up and use.

TipEligible students can use GitHub Copilot without paying

Verified students can apply for GitHub Copilot Student. The features and usage allowances may change, so check the [current GitHub instructions for student access](https://docs.github.com/en/copilot/how-tos/copilot-on-github/set-up-copilot/enable-copilot/set-up-for-students) before signing up.

The rest of this section focuses on using a web-based chat bot service to help with debugging, since this is likely to be the most familiar option. The same principles apply to other LLM services, but the details of how you use them will differ.

<a id="sec-handling-bugs-protecting-sensitive-information"></a>
<a id="protecting-sensitive-information"></a>

### 8.6.1 Protecting sensitive information

Never submit sensitive crime data, personal information, passwords, API keys or other credentials to a generative-AI service. The service might send information to an external provider or retain it according to terms that you have not checked. If you are not certain that sharing particular information is authorised, do not share it.

Crime mapping can influence decisions about people and places, so analytical accuracy matters. If you use an LLM to support debugging, you remain responsible for understanding the code, checking the results and ensuring that the analysis is appropriate.

AI tools are more likely to provide a useful answer if you give them the same information that would make a good question for a person:

- what you were trying to achieve;
- the smallest code that produces the problem (i.e. a reprex);
- the exact text of the error, warning or unexpected result;
- what you expected to happen; and
- relevant package versions, if you know them.

For example, a useful prompt might be:

> I am learning R. I want this code to make a basic map, but it produces the error pasted below. Explain the cause in beginner-friendly language, then suggest one change for me to test. Do not rewrite the whole script.
>
> ``` {.sourceCode .numberSource .r .number-lines .code-with-copy}
> pacman::p_load(sfhotspot, tidyverse)
>
> memphis_robberies_jan +
>   hotspot_map(basemap_type = "none")
> #> Error in `UseMethod()`:
> #> ! no applicable method for 'hotspot_map' applied to an object of class 
> "character"
> ```

Asking for an explanation and one change helps you remain in control of the debugging process. Read the explanation, check it against the relevant R manual page, make the change yourself and then inspect the result. Do not accept code merely because it looks convincing or runs without an error: it could still contain a logic error.

<a id="sec-handling-bugs-why-ai-suggestions-can-be-wrong"></a>
<a id="why-ai-suggestions-can-be-wrong"></a>

### 8.6.2 Why AI suggestions can be wrong

LLMs generate responses from patterns learned from large collections of text and code. They can produce plausible explanations and code without verifying that these are correct for your data, package versions or analytical goal. Different services -- or the same service on different occasions -- can also return different responses to the same prompt.

Treat an AI suggestion in the same way as advice from an unfamiliar online tutorial. Make sure you understand it, check the relevant documentation, change one thing at a time and verify the result from a new R session.

QuizUsing generative AI for debugging

**What is the safest way to ask an LLM for debugging help?**

- Ask the LLM to replace the complete analysis without explaining its changes
- Provide a non-sensitive reprex, the expected result and the exact problem (Correct answer)
- Upload the original crime dataset so that the LLM has maximum context
- Accept any suggestion that runs without an error

**Why must you verify code suggested by an LLM?**

- An LLM checks every suggestion against the current package documentation
- Code that runs cannot contain a logic error
- An LLM can produce a plausible suggestion that is wrong for your analysis (Correct answer)
- Different LLMs always return the same answer to a prompt

Figure: Cartoon of a frustrated green monster sitting beside its yellow hat and saying, I just need a minute. An R logo with a concerned face stands nearby against repeated Error messages, illustrating the value of taking a break when debugging.

<a id="sec-handling-bugs-why-ai-suggestions-can-be-out-of-date"></a>
<a id="why-ai-suggestions-can-be-out-of-date"></a>

### 8.6.3 Why AI suggestions can be out of date

AI tools are trained on large collections of text and code, for example blog posts and forum discussions about how to fix problems with R code. However, some of the information that these tools have learned is now out of date. R and its packages change over time, so advice that was correct when it was written may no longer be correct. This can cause problems with your code, either now or if you adapt the code in the future. [Appendix D](../appendices/functions_to_avoid.llms.md) explains some obsolete R functions that you should avoid using if you see them suggested by AI tools or elsewhere.

Before answering the following questions, read [Appendix D](../appendices/functions_to_avoid.llms.md). Use that appendix to check why each function is discouraged and which alternative is recommended.

QuizSome R functions to avoid

**Why should you avoid using the `attach()` function?**

- It deletes all the objects in your R environment
- It makes it impossible for you to share your code with anyone else
- It makes it hard to keep track of which values are stored in which dataset (Correct answer)
- It has been superseded by the if_else() function

**What function should you generally use instead of `%>%`?**

- pluck()
- mod()
- pull()
- \|\> (Correct answer)

**What happens if you try to run the code `as.numeric("100 degrees")`?**

- The numeric value 100 is returned
- The value NA is returned (Correct answer)
- The text value \"100\" is returned
- R crashes

For more detailed guidance, read [Twelve quick tips for AI-assisted coding in science](https://doi.org/10.1371/journal.pcbi.1014428).

<a id="what-caused-the-error-in-our-reproducible-example"></a>

## What caused the error in our reproducible example?

The error in our reproducible example was very simple, but quite difficult to spot. On line 3 of [Code 8.28](#lst-handling-bugs-show-ai-code-error), we try to add the `hotspot_map()` function to the `memphis_robberies_jan` object using the `+` operator when what we wanted to do was pass the `memphis_robberies_jan` object to the `hotspot_map()` function using the `|>` operator. R does not know how to add a dataset to a function in this way, so it produced an error message.

If you replaced `+` with `|>` on line 3 of [Code 8.28](#lst-handling-bugs-show-ai-code-error), the code would now run normally. Since we have removed almost all of our original code to make a reproducible example, the resulting map looks nothing like what we wanted. This does not matter -- when we are producing a reprex we only care about reliably producing *the same* error. Now that we have fixed the error, we could go back and fix the original code to produce the map we wanted.

<a id="lst-handling-bugs-show-ai-code-error"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(sfhotspot, tidyverse)</span>
<span id="cb2-2"><a href="#cb2-2"></a></span>
<span id="cb2-3"><a href="#cb2-3"></a>memphis_robberies_jan <span class="sc">+</span> <span class="co"># &lt;---- THE `+` OPERATOR HERE SHOULD BE A `|&gt;` OPERATOR</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>  <span class="fu">hotspot_map</span>(<span class="at">basemap_type =</span> <span class="st">&quot;none&quot;</span>)</span></code></pre></div>
<figcaption>Code 8.28</figcaption>
</figure>

The mistake in this code is easy to make because what `+` does to add a layer to a map created with `hotspot_map()` is similar to what `|>` does to pass the result of one function to the next function in a data-wrangling pipeline. Remember that we use `+` to combine layers using functions from the ggplot2 package, and `|>` to pass an object to a function.

<a id="how-to-fix-some-common-errors"></a>

## 8.7 How to fix some common errors

There are some mistakes that it is common for people to make when writing code. As you get more experience in writing R code and dealing with error messages, you are likely to start to recognise some simple errors (especially those caused by typos) and know how to fix them quickly. One useful way to quickly find help on common errors is to check if the error appears in the list of common errors and how to fix them at [Appendix C](../appendices/common_errors.llms.md).

Before answering the following questions, read [Appendix C](../appendices/common_errors.llms.md) and use it to identify the likely cause of each error message.

QuizFixing common errors

**What might cause the error message `could not find function "blah"`?**

- You have loaded packages in the wrong order
- You have mis-typed the name of the blah object
- You have not loaded the package that contains the blah() function (Correct answer)
- You have tried to use a generic function with a type of object the function does not know how to use

**What might cause the error message `non-numeric argument to binary operator`?**

- You have tried to use a function as if it is an object
- You have tried to use a mathematical operator such as + or - with a non-numeric value such as a character value (Correct answer)
- You have used an argument name in a function that does not understand it
- You have either mis-typed the function name or the package containing that function is not loaded

<a id="in-summary"></a>

## 8.8 In summary

In this chapter, we practised how to find and fix a wide range of bugs in R code. Remember that bugs are inevitable in all programming. Often you can prevent bugs with good coding practice, but it's also important to know how to find and fix them when they occur.

We have practised how to:

- distinguish messages, warnings and errors;
- recognise syntax errors, runtime errors and logic errors;
- reproduce and isolate a problem systematically;
- inspect intermediate data and compare results with what you expected;
- use manual pages and common-error guidance;
- recognise and resolve conflicts between functions with the same name;
- create and check a non-sensitive reprex; and
- assess debugging suggestions from people, online resources and generative AI critically.

You can use the checklist in [Appendix E](../appendices/handling_errors.llms.md) whenever you encounter a problem in your code.

The corrected complete script from the reprex exercise is shown in [Code 8.29](#lst-handling-bugs-complete-script). Replace the contents of `chapter_08.R` with this script. It uses the pipe operator to pass `bronx_shootings` to `hotspot_map()`.

<a id="lst-handling-bugs-complete-script"></a>

<figure>
<pre><code>chapter_08.R</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode numberSource numberSource r number-lines code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># Load packages</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>pacman<span class="sc">::</span><span class="fu">p_load</span>(here, sf, sfhotspot, tidyverse)</span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="co"># Load Bronx shootings dataset and wrangle it</span></span>
<span id="cb2-4"><a href="#cb2-4"></a>bronx_shootings <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;bronx_shootings.csv&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-5"><a href="#cb2-5"></a>  <span class="fu">read_csv</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-6"><a href="#cb2-6"></a>  janitor<span class="sc">::</span><span class="fu">clean_names</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-7"><a href="#cb2-7"></a>  <span class="fu">st_as_sf</span>(<span class="at">coords =</span> <span class="fu">c</span>(<span class="st">&quot;longitude&quot;</span>, <span class="st">&quot;latitude&quot;</span>), <span class="at">crs =</span> <span class="st">&quot;EPSG:4326&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-8"><a href="#cb2-8"></a>  <span class="fu">rename</span>(<span class="at">shooting_date =</span> occur_date, <span class="at">fatal =</span> murder) <span class="sc">|&gt;</span></span>
<span id="cb2-9"><a href="#cb2-9"></a>  <span class="co"># Keep only fatal shootings</span></span>
<span id="cb2-10"><a href="#cb2-10"></a>  <span class="fu">filter</span>(fatal <span class="sc">==</span> <span class="cn">TRUE</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-11"><a href="#cb2-11"></a>  <span class="fu">select</span>(shooting_date, incident_key)</span>
<span id="cb2-12"><a href="#cb2-12"></a></span>
<span id="cb2-13"><a href="#cb2-13"></a><span class="co"># Load NYPD precincts and filter to keep just those from the Bronx</span></span>
<span id="cb2-14"><a href="#cb2-14"></a>bronx_precincts <span class="ot">&lt;-</span> <span class="fu">here</span>(<span class="st">&quot;data&quot;</span>, <span class="st">&quot;raw&quot;</span>, <span class="st">&quot;nyc_precincts.gpkg&quot;</span>) <span class="sc">|&gt;</span></span>
<span id="cb2-15"><a href="#cb2-15"></a>  <span class="fu">read_sf</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-16"><a href="#cb2-16"></a>  janitor<span class="sc">::</span><span class="fu">clean_names</span>() <span class="sc">|&gt;</span></span>
<span id="cb2-17"><a href="#cb2-17"></a>  <span class="co"># Filter just those precincts that are in the Bronx (40th to 52nd)</span></span>
<span id="cb2-18"><a href="#cb2-18"></a>  <span class="fu">filter</span>(precinct <span class="sc">%in%</span> <span class="dv">40</span><span class="sc">:</span><span class="dv">52</span>)</span>
<span id="cb2-19"><a href="#cb2-19"></a></span>
<span id="cb2-20"><a href="#cb2-20"></a><span class="co"># Map shootings</span></span>
<span id="cb2-21"><a href="#cb2-21"></a>bronx_shootings <span class="sc">|&gt;</span></span>
<span id="cb2-22"><a href="#cb2-22"></a>  <span class="fu">hotspot_map</span>(</span>
<span id="cb2-23"><a href="#cb2-23"></a></span>
<span id="cb2-24"><a href="#cb2-24"></a>    <span class="at">basemap_type =</span> <span class="st">&quot;none&quot;</span>,</span>
<span id="cb2-25"><a href="#cb2-25"></a>    <span class="at">caption =</span> <span class="st">&quot;Shootings data: NYC Open Data&quot;</span>,</span>
<span id="cb2-26"><a href="#cb2-26"></a>    <span class="at">alpha =</span> <span class="fl">0.5</span>,</span>
<span id="cb2-27"><a href="#cb2-27"></a>    <span class="at">colour =</span> <span class="st">&quot;red2&quot;</span></span>
<span id="cb2-28"><a href="#cb2-28"></a>  ) <span class="sc">+</span></span>
<span id="cb2-29"><a href="#cb2-29"></a>  <span class="co"># Add precinct boundaries</span></span>
<span id="cb2-30"><a href="#cb2-30"></a>  <span class="fu">geom_sf</span>(<span class="at">data =</span> bronx_precincts, <span class="at">colour =</span> <span class="st">&quot;grey50&quot;</span>, <span class="at">fill =</span> <span class="cn">NA</span>) <span class="sc">+</span></span>
<span id="cb2-31"><a href="#cb2-31"></a>  <span class="fu">labs</span>(</span>
<span id="cb2-32"><a href="#cb2-32"></a>    <span class="at">title =</span> <span class="st">&quot;Fatal shootings in the Bronx&quot;</span>,</span>
<span id="cb2-33"><a href="#cb2-33"></a>    <span class="at">subtitle =</span> <span class="st">&quot;January to December 2019&quot;</span></span>
<span id="cb2-34"><a href="#cb2-34"></a>  ) <span class="sc">+</span></span>
<span id="cb2-35"><a href="#cb2-35"></a>  <span class="fu">theme</span>(</span>
<span id="cb2-36"><a href="#cb2-36"></a>    <span class="at">plot.title =</span> <span class="fu">element_text</span>(<span class="at">colour =</span> <span class="st">&quot;grey30&quot;</span>, <span class="at">face =</span> <span class="st">&quot;bold&quot;</span>, <span class="at">hjust =</span> <span class="fl">0.5</span>),</span>
<span id="cb2-37"><a href="#cb2-37"></a>    <span class="at">plot.subtitle =</span> <span class="fu">element_text</span>(<span class="at">hjust =</span> <span class="fl">0.5</span>)</span>
<span id="cb2-38"><a href="#cb2-38"></a>  )</span></code></pre></div>
<figcaption>Code 8.29</figcaption>
</figure>

Save `chapter_08.R` by pressing .

To check that the analysis is reproducible, restart R using the **Restart R** (**⟳**) button in Positron's **Console** panel, then run the script from beginning to end.

QuizRevision questions

Answer these questions to check you have understood the main points covered in this chapter. Write between 50 and 100 words to answer each question.

1.  What are the key differences between messages, warnings, and errors in R? Provide an example of each and explain how they affect the execution of code.
2.  Explain the differences between syntax errors, runtime errors and logic errors in R. Why can logic errors be particularly difficult to identify?
3.  Why is it important to check each line of code when debugging a block of R code? Describe a method for systematically isolating problematic lines.
4.  What role do R manual pages play in understanding and fixing errors? How can you access these pages, and what key sections should you focus on?
5.  Why is it dangerous to ignore warnings in your R code? Provide an example of how a warning could indicate a significant problem with your analysis.
6.  What are function-name conflicts in R? Explain how package-loading order and explicit namespaces can be used to resolve them.
7.  What information should you include in a reprex or an AI prompt when asking for debugging help? Explain how you would protect sensitive information and verify any suggested code.

[Artwork by Allison Horst](https://allisonhorst.com/)
