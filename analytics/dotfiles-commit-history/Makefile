ARCHIVED_REPO := https://github.com/vsbuffalo/dotfiles_archived
TMP := .tmp
DATA := data
FIGS := figures

ARCHIVED_DIR := $(TMP)/dotfiles_archived
CURRENT_LOG := $(DATA)/commits_current.csv
ARCHIVED_LOG := $(DATA)/commits_archived.csv
FILE_CHANGES := $(DATA)/file_changes.csv

.PHONY: all clean

all: $(FIGS)/commit_history.png $(FIGS)/commit_sequence_annotated.png

$(DATA) $(FIGS) $(TMP):
	mkdir -p $@

$(ARCHIVED_DIR): | $(TMP)
	git clone --quiet $(ARCHIVED_REPO) $@

$(ARCHIVED_LOG): $(ARCHIVED_DIR) | $(DATA)
	git -C $(ARCHIVED_DIR) log --format='%aI,%s' --all > $@

$(CURRENT_LOG): | $(DATA)
	git -C ../.. log --format='%aI,%s' --all > $@

$(FILE_CHANGES): extract.py categories.json $(ARCHIVED_DIR) | $(DATA)
	python3 $< categories.json ../.. $(ARCHIVED_DIR) $@

$(FIGS)/commit_history.png: plot.py $(CURRENT_LOG) $(ARCHIVED_LOG) | $(FIGS)
	uv run --with matplotlib --with polars --with numpy $< $(CURRENT_LOG) $(ARCHIVED_LOG) $@

$(FIGS)/commit_sequence_annotated.png: plot_sequence.py categories.json $(FILE_CHANGES) | $(FIGS)
	uv run --with matplotlib --with polars  --with numpy $< $(FILE_CHANGES) categories.json $@ --annotate

clean:
	rm -rf $(TMP) $(DATA) $(FIGS)
