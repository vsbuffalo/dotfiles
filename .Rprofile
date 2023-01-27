## Minimal .Rprofile
if (interactive()) {
  if (!suppressMessages(require(devtools)))
    warning("devtools cannot be loaded...")
}

options(repos="http://cran.us.r-project.org",
        devtools.name="Vince Buffalo",
        devtools.desc.author="'Vince Buffalo <vsbuffaloAAAAA@gmail.com> [aut, cre]'",
        devtools.desc.license="BSD",
        #browserNLdisabled = TRUE,
        menu.graphics=FALSE,
        # warn about partial matching, a Hadley trick.
        warnPartialMatchDollar = TRUE)



.reset <- function() system(sprintf("kill -WINCH %d", Sys.getpid()))

#.paste <- function() scan(pipe("pbpaste"),what=character())
