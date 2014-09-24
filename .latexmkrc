# Latexmkrc Settings
# a lot borrowed from: http://dlpeterson.com/2013/08/latex-workflow/

# .bbl files assumed to be regeneratable, safe as long as the .bib file is available
$bibtex_use = 2;
# User biber instead of bibtex
$biber = 'biber --debug %O %S';
# Default pdf viewer
$pdf_previewer = 'open -a Preview';
