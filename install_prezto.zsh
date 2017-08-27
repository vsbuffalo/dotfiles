#!/bin/zsh
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/dotfiles/prezto/runcoms/^README.md(.N); do
  [[ $(basename $rcfile) == "zshrc" ]] || (echo -n "  linking $rcfile  " && ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}")
done

echo -n "  linking dotfiles/.zshrc  " && ln -s ~/dotfiles/.zshrc ~/.zshrc

exit 0
