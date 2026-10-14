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

## To review later

- Zsh
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
