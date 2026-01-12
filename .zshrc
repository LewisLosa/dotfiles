typeset -U path cdpath fpath manpath
for profile in ${(z)NIX_PROFILES}; do
  fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
done

HELPDIR="/nix/store/6mrkwprlk3j91bl80ngl1mjz0n3sknk2-zsh-5.9/share/zsh/$ZSH_VERSION/help"

export ZPLUG_HOME=/home/eyups/.zplug

source /nix/store/cd5rma0z79dqsyh0h7cfvd1z1mn6ifp9-zplug-2.4.2/share/zplug/init.zsh

zplug "zsh-users/zsh-autosuggestions"
zplug "romkatv/powerlevel10k", as:theme, depth:1




if ! zplug check; then
  zplug install
fi

zplug load

# Add plugin directories to PATH and fpath
plugin_dirs=(
  powerlevel10k-config
)
for plugin_dir in "${plugin_dirs[@]}"; do
  path+="/home/eyups/.zsh/plugins/$plugin_dir"
  fpath+="/home/eyups/.zsh/plugins/$plugin_dir"
done
unset plugin_dir plugin_dirs


autoload -U compinit && compinit
source /nix/store/9vjgzqbj1i9qqznrqvh4g6k5kvd89y4v-zsh-autosuggestions-0.7.1/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history)


# Source plugins
plugins=(
  powerlevel10k-config/p10k.zsh
)
for plugin in "${plugins[@]}"; do
  [[ -f "/home/eyups/.zsh/plugins/$plugin" ]] && source "/home/eyups/.zsh/plugins/$plugin"
done
unset plugin plugins

# History options should be set in .zshrc and after oh-my-zsh sourcing.
# See https://github.com/nix-community/home-manager/issues/177.
HISTSIZE="10000"
SAVEHIST="10000"

HISTFILE="/home/eyups/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK

# Enabled history options
enabled_opts=(
  HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY
)
for opt in "${enabled_opts[@]}"; do
  setopt "$opt"
done
unset opt enabled_opts

# Disabled history options
disabled_opts=(
  APPEND_HISTORY EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS
  HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS
)
for opt in "${disabled_opts[@]}"; do
  unsetopt "$opt"
done
unset opt disabled_opts

microfetch
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)" &> /dev/null
  ssh-add ~/.ssh/id_ed25519 &> /dev/null
fi

if test -n "$KITTY_INSTALLATION_DIR"; then
  export KITTY_SHELL_INTEGRATION="no-rc"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi

alias -- ..='cd ..'
source /nix/store/6aqwmp96p7gcmlsq1clvfhyh1s7afc0f-zsh-syntax-highlighting-0.8.0/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS+=()


