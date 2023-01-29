## Bootloaders

These are little manual install instructions for stuff like:

  - test code that needs to go on your `$PATH` variable 
  - scientific code without installers
  - stuff you need on servers but can't install system wide (and aren't in conda, etc.)

Be sure to add extend your path the bin directory `~/src/bin/`, which is where
these makefiles copy binaries to. Add it with:

    # this source bin is for compiled source and/or
    # bootloaders/ recipes
    export PATH=$HOME/src/bin:$PATH

## Making Bootloaders and Running Shell Scripts

Run like:

    make -f linux-nvim.make

or for scripts:

    bash packer.sh
