# Migration notes

## Source machine

The previous Mac used:

- macOS username: `aimami`
- home directory: `/Users/aimami`

## Target machine

The new workstation uses:

- macOS username: `asimami`
- home directory: `/Users/asimami`

The repository must not encode either home-directory path.
Use `$HOME`, `~`, or paths relative to the repository instead.

## Deliberately not migrated

- Nix / Determinate infrastructure
- institutional management software
- arbitrary `launchctl` state
- application caches
- generated development environments
- stale Homebrew services
- hard-coded `/Users/aimami` paths
- application preference databases unless explicitly selected later

## Migrated as configuration

- Git configuration
- global Git ignore
- small workstation package baseline
- mise shell activation
- verification task
- Git configuration dependencies: `delta` (pager), `git-lfs`
  (required filter), `gnupg` (provides `gpg` for commit signing),
  and `hk` (git hooks via `mise x hk`).
  These are required by the already-migrated `dotfiles/gitconfig`, so
  the baseline installs them even though they were not in the original
  six-package baseline.
- Zsh configuration (`dotfiles/.zshrc`, `dotfiles/.zshenv`), deployed
  as symlinks via the native `[dotfiles]` resource. See "Zsh" below.

## Zsh

The previous Mac used Oh My Zsh. The new configuration migrates to
**zinit** (light-mode) and drops the Oh My Zsh framework. This is a
deliberate framework change, not a raw copy of the old `.zshrc`.

### Deployment and ownership

- `dotfiles/.zshrc` and `dotfiles/.zshenv` are the single source of
  truth and are deployed as symlinks by the native `[dotfiles]`
  resource (`mode = "symlink"`).
- `zinit` itself is installed by `[bootstrap.repos]`
  (`~/.zinit` from `zdharma-continuum/zinit`, ref `main`), which runs
  before dotfiles in the bootstrap order. The `.zshrc` also self-bootstraps
  zinit so the shell works even before mise has cloned it.
- `zshrc = "activate"` was removed from `[bootstrap.mise_shell_activate]`
  because the whole `.zshrc` is now a managed dotfile; mise activation is
  baked into `dotfiles/.zshrc` instead (`eval "$(mise activate zsh)"`,
  guarded). `zprofile = "shims"` is kept.

### Plugin mapping

- Oh My Zsh plugins are loaded through the `omzplugins/` prefix without
  sourcing the full framework: `git`, `z`, `python`, `rust`, `terraform`,
  `ssh-agent`, `brew`, `macos`.
- Dropped: `aliases` (ported inline), `starship` (now via `eval`),
  `mise` (now via `eval`).
- Custom plugins via zinit: `zsh-users/zsh-autosuggestions`,
  `zsh-users/zsh-syntax-highlighting` (loaded last), `mroth/evalcache`.
- `zstyle :omz:plugins:ssh-agent agent-forwarding yes` is set before the
  ssh-agent plugin loads.
- Completion order: omzplugins → `fpath` + `compinit` → syntax
  highlighting last.

### Removed old-machine paths

- `fpath` entries under `/Users/asimami/.granted/...` and the
  `alias assume="source assume"` line (granted tooling, not portable).
- `PATH` entries for `llvm`, `/usr/local/sbin`, and `texlive`
  (machine-specific, not part of the baseline).
- The `ZSH_COMPDUMP` line referenced an undefined `$ZDOTDIR`; removed.
- The hard-coded `/Users/aimami/.bun/_bun` and
  `/Users/aimami/.local/share/mise/.../terragrunt` lines were removed;
  mise activation now provides terragrunt completions.

### Portable PATH

`$GOPATH/bin:$HOME/.local/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$HOME/bin:$PATH`,
with `GOPATH=$HOME/experiments/go` and `ANDROID_HOME=$HOME/Library/Android/sdk`.
The legacy Android `tools`/`tools/bin` entries are kept for compatibility.

### Deferred

- `dotfiles/gitconfig` and `dotfiles/gitignore_global` are not yet
  deployed via `[dotfiles]` because the target already has regular files
  at those locations; deploying them as symlinks would clobber existing
  state. Revisit when the target is clean or the files are reconciled.

## To review later

- WezTerm
- Neovim
- SSH configuration
- GPG configuration
- macOS preferences
- LaunchAgents
- larger Homebrew application inventory
- mise-managed development tools
- fonts
- repositories

## Migration rule

The old Mac is an archaeological source, not the specification.

Classify old state as:

1. intentional workstation configuration;
2. project-specific configuration;
3. credential/secret material;
4. generated state;
5. institutional/application-managed state; or
6. obsolete state.

Only the first category belongs here by default.
