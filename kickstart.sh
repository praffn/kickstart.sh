# KICKSTART!
# Instantaneously turn your mac into
# a productive developer machine 🙌
#
# Heavily inspired by thoughbot's laptop script:
# https://github.com/thoughtbot/laptop

######
# UTIL
######
positive_prompt() {
  read -r -p "$1 [Y/n] " response
  case "$response" in
    n|N)
      return 1
    ;;
    *)
      return 0
    ;;
  esac
}

negative_prompt() {
  read -r -p "$1 [y/N] " response
  case "$response" in
    y|Y)
      return 0
    ;;
    *)
      return 1
    ;;
  esac
}

######
# ZSH
######
update_shell() {
  local shell_path;
  shell_path="$(which zsh)"

  echo "Changing shell to zsh..."
  if ! grep "$shell_path" /etc/shells > /dev/null 2>&1 ; then
    echo "Adding '$shell_path' to /etc/shells"
    sudo sh -c "echo $shell_path >> /etc/shells"
  fi
  chsh -s "$shell_path"
}

case "$SHELL" in
  */zsh)
    if [ "$(which zsh)" != '/bin/zsh' ] ; then
      update_shell
    fi
    ;;
  *)
    update_shell
    ;;
esac

######
# HOMEBREW
######
if ! command -v brew >/dev/null; then
  echo "Installing Homebrew ..."
    curl -fsS \
      'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby
    export PATH="/usr/local/bin:$PATH"
fi

if brew list | grep -Fq brew-cask; then
  fancy_echo "Uninstalling old Homebrew-Cask ..."
  brew uninstall --force brew-cask
fi

######
# INSTALL ALL THE STUFF 
######
brew update
brew install git

if positive_prompt "Install latest Node (with nvm)?" ; then
  if [ ! -d $HOME/.nvm ] ; then
    echo "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  fi
  source $NVM_DIR/nvm.sh
  nvm install node
  nvm use node
fi

if positive_prompt "Install Java tools?" ; then
  brew cask install java
  brew install gradle
fi

if positive_prompt "Install Chrome?" ; then
  brew cask install google-chrome
fi

if negative_prompt "Install Firefox?" ; then
  brew cask install firefox
fi

if positive_prompt "Install iTerm2?" ; then
  brew cask install iterm2
fi

if positive_prompt "Install praffn's favorite tools?" ; then
  brew cask install adobe-creative-cloud
  brew cask install spectacle
  brew cask install visual-studio-code
  brew cask install transmission
  brew cask install dropbox
  brew cask install spotify
fi