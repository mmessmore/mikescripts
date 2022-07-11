# My random scripts for ~/bin

Universally applicable scripts live in the top level.

OS-based scripts exist in directories named after `uname -s`.

Run `make` to install.

## All the places
  - [tmx](./tmx) makes `tmux` act more like `screen -x`.  I like to be able
    to reattach but independently switch windows.  That lets me have
    two terminals up at the same time and independently flip between
    them, or attach from another host, etc.

## Arch
  - I use 100 package managers with fairly consistent interfaces: `yum`, `apt`,
    `pip`, etc etc.  So this just wraps `pacman` to let me use it "normally"
    because I can never remember all the command line flags and I'm too lazy to
    learn. The `-y` option has it use `yay` so it also handles running
    `sudo` where appropriate.  You may want to adjust your sudo rules to
    allow you to run pacman and/or yay without a prompt.
