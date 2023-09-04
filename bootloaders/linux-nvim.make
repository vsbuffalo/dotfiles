all: ~/.local/bin/nvim ~/.local/share/nvim

src/nvim-linux64.tar.gz:
	@mkdir src/
	wget -P src/ https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz

src/nvim-linux64/bin/nvim: src/nvim-linux64.tar.gz
	tar -xzvf $< -C src/

~/.local/bin/nvim: src/nvim-linux64/bin/nvim 
	mkdir -p ~/.local/bin/
	cp $< $@

~/.local/share/nvim: src/nvim-linux64/share/nvim 
	mkdir -p ~/.local/share/
	cp $< $@
