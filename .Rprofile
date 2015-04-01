## Minimal .Rprofile
if (interactive()) {
  if (!suppressMessages(require(devtools)))
    warning("devtools cannot be loaded...")
}

options(repos=c("http://cran.cnr.Berkeley.edu","http://cran.stat.ucla.edu"),
        devtools.name="Vince Buffalo",
        devtools.desc.author="'Vince Buffalo <vsbuffaloAAAAA@gmail.com> [aut, cre]'",
        devtools.desc.license="BSD",
        #browserNLdisabled = TRUE,
        menu.graphics=FALSE)


.reset <- function() system(sprintf("kill -WINCH %d", Sys.getpid()))

#.paste <- function() scan(pipe("pbpaste"),what=character())
