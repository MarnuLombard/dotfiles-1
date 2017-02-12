#!/usr/bin/env bash

switch_to_homebrew_bash() {
  if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
    echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
    chsh -s /usr/local/bin/bash;
    e_note "Now using bash from Homebrew"
  fi;
}

symlink() {
  from="$1"
  to="$2"
  e_arrow "Linking '$from' to '$to'"
  rm -f "$to"
  ln -s "$from" "$to"
}

susymlink() {
  from="$1"
  to="$2"
  e_arrow "Linking '$from' to '$to'"
  sudo rm -f "$to"
  sudo ln -s "$from" "$to"
}

symlink_host_file() {
  e_header "Linking hosts file"
  e_arrow "Saving original file to /etc/hosts.orig"
  sudo cp -f /etc/hosts /etc/hosts.orig
  susymlink "$dotfiles/etc/hosts" "/etc/hosts"
}

symlink_dotfiles() {
  dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

  # Link `bin/` directory
  # It's a `.bin` because I don't like seeing it
  e_header "Symlinking cusom ~/.bin directory"
  symlink "$dotfiles/bin" "$HOME/.bin"

  # Link dotfiles
  e_header "Symlinking dotfiles"
  for location in $(find home -name '*.sh'); do
    file="${location##*/}"
    file="${file%.sh}"
    symlink "$dotfiles/$location" "$HOME/.$file"
  done

  # Vim config
  e_header "Symlinking VIM config"
  symlink "$dotfiles/vim" "$HOME/.vim"
  touch "$HOME/.vimlocal"
}
