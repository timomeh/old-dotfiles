typeset -g ZSH_CACHE_DIR=${HOME}/dotfiles/zsh/cache
mkdir -p ${HOME}/dotfiles/zsh/cache

# Append history of multiple zsh sessions
setopt appendhistory

# Jump into a directory even without `cd`
setopt autocd

# beep bop error
setopt beep

# Print error, if filename generation has no matches
setopt nomatch

# Don't use extended globs
unsetopt extendedglob

# Don't directly notify background jobs
unsetopt notify

# Colorize autocompletion
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# Make autocompletion suggestions like a menu with selection
zstyle ':completion:*' menu select

# Initialize autocompletion
autoload -Uz compinit
compinit