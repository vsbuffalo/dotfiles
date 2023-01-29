all: ../../src/bin/git

DIR := $(shell realpath ~/src)

git-2.9.5.tar.gz:
	wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.9.5.tar.gz

git-2.9.5: git-2.9.5.tar.gz
	tar xvf $<

../../src/bin/git: git-2.9.5
	#echo $(DIR)/git
	(cd $<; ./configure --prefix=$(DIR) && make && make install)

