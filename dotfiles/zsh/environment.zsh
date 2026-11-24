# shellcheck shell=bash
# Zsh environment configuration
# Source: dotfiles/zsh/environment.zsh

# Enable strict mode for better error handling
setopt ERR_EXIT
setopt ERR_RETURN
setopt NO_UNSET
setopt PIPE_FAIL

# Enable globbing
setopt GLOB_DOTS
setopt EXTENDED_GLOB

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY

# Completion configuration
setopt AUTO_LIST
setopt AUTO_MENU
setopt LIST_AMBIGUOUS
setopt MENU_COMPLETE
setopt COMPLETE_IN_WORD

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_MINUS
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME

# Misc
setopt NO_CASE_SENSITIVE
setopt NUMERIC_GLOB_SORT
setopt RC_EXPAND_PARAM

# Load mise shell integration
eval "$(mise activate zsh)"

# Set default editor
export EDITOR="nvim"
export VISUAL="nvim"

# Set default pager
export PAGER="less"
export LESS="-R -F -X"

# Set default man pager
export MANPAGER="less -R"

# Set default bat options
export BAT_THEME="Monokai Extended"
export BAT_CONFIG_DIR="$HOME/.config/bat"

# Set default delta options
export DELTA_PAGER="less -R -X"

# Set default fzf options
export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}'"
export FZF_ALT_C_OPTS="--preview 'ls -la {}'"

# Set default ripgrep options
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"
