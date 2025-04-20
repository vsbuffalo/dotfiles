CORES := $(shell sysctl -n hw.ncpu 2>/dev/null || nproc)
CMDSTAN_HOME := $(HOME)/src/cmdstan
LOCAL_BIN := $(HOME)/.local/bin

all: update-submodules build symlink-bin

update-submodules:
	cd $(CMDSTAN_HOME) && git pull && git submodule update --init --recursive

build:
	cd $(CMDSTAN_HOME) && make build -j$(CORES)

symlink-bin:
	mkdir -p $(LOCAL_BIN)
	ln -sf $(CMDSTAN_HOME)/bin/stanc $(LOCAL_BIN)/stanc
	ln -sf $(CMDSTAN_HOME)/bin/stansummary $(LOCAL_BIN)/stansummary
	ln -sf $(CMDSTAN_HOME)/bin/diagnose $(LOCAL_BIN)/diagnose

clean:
	cd $(CMDSTAN_HOME) && make clean-all

