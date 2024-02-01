# Since `learnr` tutorials are incompatible with Quarto -- and, according to the
# Quarto project roadmap, likely to remain so -- it isn't advisable to load the
# learnr package in a Quarto document. This file masks functions from the
# `learnr` package that would otherwise cause a missing-function error since the
# `learnr` package is not loaded. In each case the function simply swallows any
# arguments using `...` and then returns NULL invisibly.

quiz <- function(...) invisible(NULL)
question <- function(...) invisible(NULL)
answer <- function(...) invisible(NULL)
