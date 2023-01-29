all: ../../src/bin/nvim

nvim-linux64.tar.gz:
	wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz


nvim-linux64/bin/nvim: nvim-linux64.tar.gz
	tar xzvf nvim-linux64.tar.gz

nvim.appimage: 
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
	chmod u+x nvim.appimage

../../src/bin/nvim: nvim.appimage
	mkdir -p ../../src/bin/
	cp $< $@
