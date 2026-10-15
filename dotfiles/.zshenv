# shellcheck shell=zsh
# Environment setup for every zsh invocation (interactive and non-interactive).
# Keep interactive setup (plugins, aliases, prompt) in .zshrc.

# Rust toolchain environment, when present.
if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi
