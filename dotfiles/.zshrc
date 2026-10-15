# shellcheck shell=zsh
# Personal zsh configuration.
#
# Framework: zinit (light-mode). Oh My Zsh plugins are loaded through the
# omzplugins/ prefix without sourcing the full Oh My Zsh framework.
#
# This file is deployed as a symlink by mise ([dotfiles]); it is the single
# source of truth for interactive shell setup.

# --- zinit ---------------------------------------------------------------
# Self-bootstrap so the shell works even before mise has cloned zinit.
if [[ ! -d "$HOME/.zinit" ]]; then
  command git clone --depth 1 https://github.com/zdharma-continuum/zinit "$HOME/.zinit"
fi
source "$HOME/.zinit/bin/zinit.zsh"

# --- Oh My Zsh plugins (via zinit) ---------------------------------------
# ssh-agent forwarding must be configured before the plugin loads.
zstyle :omz:plugins:ssh-agent agent-forwarding yes

zinit light-mode for \
  omzplugins/git \
  omzplugins/z \
  omzplugins/python \
  omzplugins/rust \
  omzplugins/terraform \
  omzplugins/ssh-agent \
  omzplugins/brew \
  omzplugins/macos

# --- Editor --------------------------------------------------------------
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# --- Paths ---------------------------------------------------------------
export GOPATH="$HOME/experiments/go"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$GOPATH/bin:$HOME/.local/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$HOME/bin:$PATH"

# --- Environment ---------------------------------------------------------
export RUSTC_WRAPPER=sccache
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export NVIM_APPNAME="nvim-kickstart"
export XDG_CONFIG_HOME="$HOME/.config"

if [[ -d "$ANDROID_HOME/ndk" ]]; then
  export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 "$ANDROID_HOME/ndk")"
fi

# --- Aliases -------------------------------------------------------------
alias vim="NVIM_APPNAME='nvim-kickstart' nvim"
alias vimdiff="NVIM_APPNAME='nvim-kickstart' nvim -d"
alias ctags='$(brew --prefix)/bin/ctags'
alias R='$(brew --prefix)/bin/arf'
alias r='$(brew --prefix)/bin/arf'
alias cat='$(brew --prefix)/bin/bat'
alias man='$(brew --prefix)/bin/tldr'
alias ping='$(brew --prefix)/bin/prettyping'
alias find='$(brew --prefix)/bin/fd'
alias cp="cp -iv"
alias rm="rm -rv"
alias top='$(brew --prefix)/bin/btm'
alias l='$(brew --prefix)/bin/eza'
alias ls='$(brew --prefix)/bin/eza'
alias ll='$(brew --prefix)/bin/eza -lhb'
alias la='$(brew --prefix)/bin/eza -lahb'
alias nvimc="NVIM_APPNAME='nvim-nvchad' nvim"
alias dirs="dirs -p"

function git_develop_branch() {
  echo next
}

# --- GPG / SSH agent (Yubikey) ------------------------------------------
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# --- Completions ---------------------------------------------------------
fpath=(~/.zsh/Completion $fpath)
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
autoload -U +X bashcompinit && bashcompinit

# --- FZF -----------------------------------------------------------------
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# --- Prompt --------------------------------------------------------------
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# --- mise ----------------------------------------------------------------
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# --- Interactive plugins (loaded last) -----------------------------------
zinit light-mode for \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-syntax-highlighting

zinit light-mode mroth/evalcache
