# asimami-workstation

Declarative configuration for my personal macOS workstation.

This repository describes the workstation I intend to have. It is not an
archive of a particular Mac.

## Bootstrap

This repository assumes `mise` is already installed.

```sh
git clone <this-repository>
cd asimami-workstation
mise trust
mise bootstrap --dry-run
mise bootstrap
mise bootstrap status
mise run verify
```

For an unattended bootstrap:

```sh
mise bootstrap --yes
```

## Design principles

- `asimami` is the canonical macOS username.
- Configuration must not depend on `/Users/aimami` or `/Users/asimami`.
- Prefer `$HOME` and portable paths.
- Secrets and private credentials are never stored here.
- Project dependencies belong to projects.
- Machine-wide tools belong here.
- Generated environments should be recreated rather than copied.
- The old Mac is evidence for migration, not the desired state.
- Add configuration incrementally as real use exposes omissions.

## Current scope

The first iteration manages:

- a small workstation package baseline;
- Git configuration;
- the global Git ignore file;
- mise shell activation;
- a verification task.

Zsh, WezTerm, Neovim, SSH, macOS preferences, LaunchAgents, and the
larger Homebrew inventory will be added after review.
