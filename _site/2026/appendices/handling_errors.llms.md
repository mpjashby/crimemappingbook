Source: https://books.lesscrime.info/learncrimemapping/2026/appendices/handling_errors.html

<a id="quarto-document-content"></a>
<a id="title-block-header"></a>
<a id="appendix-e-checklist-handling-code-errors"></a>

# `<a id="sec-checklist-errors"></a>`{=html}Appendix E --- Checklist: handling code errors

When R code produces an error, warning or unexpected result, follow this detailed version of the four-step debugging process introduced in [Chapter 8](../08_handling_bugs/index.llms.md).

The chapter introduces four main steps: **understand**, **isolate**, **inspect** and **get help**. This checklist adds more detail to each step so that you can use it whenever you encounter a problem in your own code.

Before starting, remember the three main categories of bug:

- A syntax error means R cannot interpret the code, often because of a missing comma, quote mark or closing parenthesis.
- A runtime error means R can interpret the code but cannot complete the operation, for example because a file or column is missing.
- A logic error means the code runs but produces the wrong result. R might not display any error or warning, so compare the output with what you expected.

<a id="step-1-understand-the-problem"></a>
<a id="e.1-step-1-understand-the-problem"></a>

## E.1 Step 1: Understand the problem

1.  Reproduce the problem. Save the script, restart R and run the code again from the beginning. Note the first place where you see an error, warning or unexpected result.
2.  Read the complete output from R. Identify the function involved, any argument mentioned and the immediate cause. If there is no error or warning, describe how the result differs from what you expected.
3.  Classify the bug, if possible, as a syntax error, runtime error or logic error. Fix any obvious typo or incomplete expression.
4.  Check whether the message appears in [Appendix C](common_errors.llms.md). Read the manual page for the function involved and check the type of input it expects, every argument you supplied and the value it should return.

<a id="step-2-isolate-the-code-that-produces-the-problem"></a>
<a id="e.2-step-2-isolate-the-code-that-produces-the-problem"></a>

## E.2 Step 2: Isolate the code that produces the problem

1.  Make sure the code follows the good practices summarised in [Section 8.2](../08_handling_bugs/index.llms.md#sec-preventing-bugs). Save the script so that Air formats it, and keep each function in a pipeline on a separate line.
2.  Find the smallest piece of code that produces the same problem. Comment out later lines, then uncomment one line at a time and run the code after each change.
3.  If the error or result changes, restore the line you just removed. Change only one thing at a time so that you know which change affected the problem.

<a id="step-3-inspect-the-data-used-and-produced-by-each-step"></a>
<a id="e.3-step-3-inspect-the-data-used-and-produced-by-each-step"></a>

## E.3 Step 3: Inspect the data used and produced by each step

1.  Check the input and output at every important stage. Use functions such as `names()`, `nrow()`, `count()`, `glimpse()` and `summary()`, or open a dataset using `view()`.
2.  Check that objects have the columns, values and type you expect. Look for zero rows, unexpected missing values, incorrectly spelled categories and other results that R might not identify as errors.
3.  After making a change, verify the fix. Restart R and run the complete script from beginning to end. Inspect the final output rather than assuming that code without an error is correct.

<a id="step-4-get-help-using-a-reproducible-example"></a>
<a id="e.4-step-4-get-help-using-a-reproducible-example"></a>

## E.4 Step 4: Get help using a reproducible example

1.  If the problem remains, create a reproducible example as explained in [Section 8.5.4](../08_handling_bugs/index.llms.md#sec-reprex). Keep only the code and data needed to produce the same problem.
2.  Check the reprex in a new R session before sharing it. Include the exact error, warning or unexpected result and explain what you expected to happen.
3.  Remove confidential or personal information, sensitive crime data, passwords, API keys and other credentials before sharing the reprex with an instructor, colleague, online community or AI service.

You will be able to fix many bugs before reaching Step 4. Creating a reprex often reveals the cause even if you do not ultimately need to share it.

You can find more details about how to deal with bugs in your code in [Chapter 8](../08_handling_bugs/index.llms.md).
