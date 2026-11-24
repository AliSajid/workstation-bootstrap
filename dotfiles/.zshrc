# Zsh configuration migrated to zinit with mise integration
# This file is managed by workstation-bootstrap repository

# Initialize zinit
if [[ ! -f ${HOME}/.zinit/bin/zinit.zsh ]]; then
    command mkdir -p ${HOME}/.zinit
    command git clone https://github.com/zdharma-continuum/zinit.git ${HOME}/.zinit/bin
fi

source ${HOME}/.zinit/bin/zinit.zsh

# Load mise shell integration
eval "$(mise activate zsh)"

# Zinit plugin definitions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zdharma-continuum/history-search-multi-word
zinit light zdharma-continuum/just
zinit light zdharma-continuum/interactive-cd
zinit light zdharma-continuum/click
zinit light zdharma-continuum/diff-so-fancy
zinit light zdharma-continuum/command-not-found
zinit light zdharma-continuum/autosuggest
zinit light zdharma-continuum/extract
zinit light zdharma-continuum/fzf
zinit light zdharma-continuum/fzf-completions
zinit light zdharma-continuum/fzf-key-bindings

# Load Oh My Zsh plugins (migrated to zinit)
zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# Custom aliases and functions
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias mkdir='mkdir -p'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias gba='git branch -a'

# Development aliases
alias c='clear'
alias h='history'
alias j='jobs -l'
alias mkdir='mkdir -p'

# Environment variables
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LESS='-R'

# FZF configuration
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}'"
export FZF_ALT_C_OPTS="--preview 'ls -la {}'"

# Powerlevel10k configuration
[[ ! -f ${HOME}/.p10k.zsh ]] || source ${HOME}/.p10k.zsh

# Custom functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

zsh_eof
echo "Created new zsh configuration at ~/.zshrc"