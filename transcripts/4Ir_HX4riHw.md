<!--
Video: A quick tour of Positron
Creator: Posit PBC
Source: https://www.youtube.com/watch?v=4Ir_HX4riHw
Caption source: 4Ir_HX4riHw.srt (English captions supplied by the author)
Prepared: 2026-10-03
Editorial changes: joined caption lines into paragraphs; corrected obvious
place/software-name recognition errors and removed scripted [PAUSE] markers.
Status: draft; not yet checked against audio or reviewed for visual descriptions.
Keep the original SRT unchanged for review and timestamps.
-->

**This transcript covers the complete video. For this chapter, you only need to watch or read the first three minutes, up to the introduction of Positron Assistant.**

Hi. I'm Sara, a data science educator at Posit. In this video, I'll give you a brief tour of Positron, Posit's next-generation data science IDE.

Positron is designed specifically for doing data science. It combines a modern coding environment with tools tailored for working with data. Positron supports both R and Python and makes it easy to switch between the languages.

If you've used RStudio or VS Code, you'll notice some familiar elements. Positron is informed by our experience building RStudio and is a fork of VS Code.

You can download Positron for Mac, Windows, or Linux on the Positron website. Next, let's take a look at some of Positron's key features.

When you first open up Positron, it'll look something like this. The first step is to open a folder. You can either open an existing folder or a new folder. Opening a folder will create a workspace and set the working directory similar to opening up a project in RStudio. I'm going to open an existing folder.

Let's take a look at the layout of Positron. All the way in the left hand side, the activity bar gives access to features like the file explorer, Positron Assistant, and extensions. Primary sidebar changes depending on what you've selected in the activity bar. So right now, it's showing our files because we have the file explorer selected.

In the center, we have the editor where we write our code. At the bottom, you can find the console and the terminal.

And over on the right hand side, you have the secondary sidebar. This is where plots will show up, where we see our loaded variables, explore database connections, and look at documentation.

Positron supports multiple R and Python interpreters. The active interpreter is shown over here in the upper right hand corner. You can click on the interpreter picker to switch between R and Python or between R and Python versions.

You'll notice that when I selected R, the console is now an R console. You can also switch between languages or versions in the console. The active interpreter will be highlighted.

Loaded variables will show up in the variables pane on the right hand side. You can inspect variables by expanding them.

For data frames, you'll notice this table icon. Clicking on that will launch the data explorer, which gives you a spreadsheet style view of the data.

You can use the Data Explorer to get a high level overview of your data. You can see the distribution of values in each of the columns as well as filter by condition. You can also sort by a column and view missing data percentages and summary statistics all without writing additional code.

Positron Assistant is an AI tool that provides LLM integration within Positron.

You can access Positron Assistant from the activity bar. Use Positron Assistant to generate code, debug, or get suggestions for next steps. Positron Assistant can access context from the console, variables pane, and plots pane. But you can also manually attach files or folders to give it additional context.

Positron Assistant has three chat modes. Ask, Edit, and Agent.

Use ask mode when you want to ask questions, get help with debugging, or use Assistant to generate code.

For example, we could ask it what we should do in our analysis of the diamonds data. It can reference our Quarto document and see what we've already done and suggest next steps.

On edit mode, Assistant will suggest code changes.

So let's say I have another file and I'm getting an error. On edit mode, I can ask Positron Assistant to help fix the problem. And notice that it now knows that read_diamonds.py is the current file.

Assistant identifies the issue and supplies a fix that I can accept or undo.

On agent mode, Assistant can figure out the next steps needed for your request and autonomously carry out those steps.

On your behalf, Positron Assistant could execute code in the console, create and modify files, and identify the next steps based on the results of the previous steps.

For example, we could ask it to move this code that's in read_diamonds.py into a new Quarto file.

Positron Assistant creates a new Quarto document and moves my code over.

Note that Positron Assistant is currently a preview feature.

Just like in RStudio, you can pull up documentation for R or Python functions directly within the IDE. For either R or Python, you can either use question mark or help.

Pull up the documentation in the help pane. You can also use F1 key. This allows you to easily reference documentation without leaving Positron.

There's a lot more you can do with Positron, but I hope this gave you a sense of what's possible. Use the following link to download Positron and get started.
