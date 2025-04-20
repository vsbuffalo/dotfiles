safe_install <- function(pkg, ...) {
    if (!pkg %in% rownames(installed.packages())) {
        tryCatch(
            {
                install.packages(pkg, ...)
                if (!pkg %in% rownames(installed.packages())) {
                    stop("❌ Package ", pkg, " failed to install (no error thrown, but it's not installed).")
                }
            },
            error = function(e) {
                stop("❌ Critical failure installing ", pkg, ": ", conditionMessage(e))
            }
        )
    }
}

# data.table doesn't play well with pak, so we install it first
safe_install("data.table", type = "source")

# First, install pak (modern package installer)
safe_install("pak")

# Core packages for dev, etc.
essential_packages <- c(
    # Project management & workflow
    "usethis", # Project setup & development workflow helpers
    "renv", # Project dependency management
    "here", # Project-relative file paths
    "fs", # File system operations

    # Modern data manipulation
    "tidyverse", # Collection of data science packages

    # Documentation & reproducibility
    "rmarkdown", # Document generation
    "quarto", # Next-gen R Markdown
    "knitr", # Dynamic report generation

    # Development tools
    "devtools", # Package development utilities
    "testthat", # Unit testing
    "roxygen2", # Documentation generation
    "lintr", # Code linting
    "styler", # Code formatting
    "targets", # Pipeline toolkit for reproducible workflows

    # IDE tools
    "languageserver", # R Language Server for modern IDEs
    "jsonlite",
    "httpgd"
)

# Use pak for faster parallel installation
pak::pak(essential_packages)
