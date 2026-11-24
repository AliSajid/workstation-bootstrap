# Zsh Migration Plan: Oh My Zsh → Zinit

## Objective

Transform the current zsh configuration from Oh My Zsh to a Zinit-based system, integrating with the mise bootstrap/dotfiles system for internal testability and reproducibility.

## Design Principles

- **Canonical username**: `asimami` is the canonical macOS username
- **Portable paths**: Use `$HOME`, `~`, and application-supported portable paths
- **No hard-coded paths**: Avoid `/Users/aimami`, `/Users/asimami`, `/opt/homebrew`, `/usr/local`
- **Secrets excluded**: Never store credentials or authentication state
- **Idempotent**: Safe to run multiple times
- **Testable**: Integration with mise bootstrap/dotfiles system for validation

## Current State

### Oh My Zsh Configuration

**Location**: `migration_data/zsh-config/zsh_combined.txt`

**Key components**:
- Oh My Zsh framework
- Plugins: `git`, `z`, `python`, `rust`, `terraform`, `ssh-agent`, `aliases`, `brew`, `macos`, `starship`, `mise`
- Custom aliases and functions
- Starship prompt configuration
- Mise integration for tool activation

### Target State

**Location**: `dotfiles/.zshrc`

**Key components**:
- Zinit package manager
- Same plugin set as Oh My Zsh (with Zinit equivalents)
- Mise integration for tool activation
- Starship prompt configuration
- Custom aliases and functions
- Cargo environment setup in `.zshenv`

## Migration Steps

### Step 1: Install Zinit

Add Zinit installation to the mise bootstrap process:

```bash
# In mise.toml, add to [env] section or create a bootstrap task
mkdir -p ~/.zinit
git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
```

**Integration with mise**:
- Add to `mise.toml` under `[bootstrap.packages]` or create a dedicated task
- Ensure idempotent: check if `~/.zinit/bin/zinit` exists before cloning

### Step 2: Migrate Oh My Zsh Plugins to Zinit

Map each Oh My Zsh plugin to its Zinit equivalent:

| Oh My Zsh Plugin | Zinit Equivalent | Notes |
|------------------|------------------|-------|
| `git` | `zinit ice depth=1; zinit light zdharma-continuum/git` | Basic git aliases |
| `z` | `zinit ice depth=1; zinit light zdharma-continuum/z` | Directory navigation |
| `python` | `zinit ice depth=1; zinit light zdharma-continuum/python` | Python completions |
| `rust` | `zinit ice depth=1; zinit light zdharma-continuum/rust` | Rust completions |
| `terraform` | `zinit ice depth=1; zinit light zdharma-continuum/terraform` | Terraform completions |
| `ssh-agent` | `zinit ice depth=1; zinit light zdharma-continuum/ssh-agent` | SSH agent management |
| `aliases` | Custom aliases in `.zshrc` | Keep existing aliases |
| `brew` | `zinit ice depth=1; zinit light zdharma-continuum/brew` | Homebrew completions |
| `macos` | `zinit ice depth=1; zinit light zdharma-continuum/macos` | macOS-specific aliases |
| `starship` | `zinit ice depth=1; zinit light starship/starship` | Starship prompt |
| `mise` | `zinit ice depth=1; zinit light asdf-vm/asdf` | Tool version management |

**Note**: Some plugins may not have direct Zinit equivalents. Keep custom implementations.

### Step 3: Migrate Custom Configuration

**Aliases and functions**:
- Extract from `migration_data/zsh-config/zsh_combined.txt`
- Place in `dotfiles/.zshrc` under `# Custom aliases and functions`
- Keep existing functionality and behavior

**Starship configuration**:
- Extract from `migration_data/zsh-config/zsh_combined.txt`
- Place in `dotfiles/.zshrc` under `# Starship prompt configuration`
- Keep existing prompt settings

**Cargo environment**:
- Add to `dotfiles/.zshenv`:
  ```bash
  export PATH="$HOME/.cargo/bin:$PATH"
  ```

### Step 4: Integrate with Mise Bootstrap

**Update `mise.toml`**:
```toml
[env]
ZDOTDIR="$HOME/.config/zsh"

[tasks]
# Add zsh configuration validation task
"zsh-validate" = """
  zsh -n ~/.config/zsh/.zshrc
  zsh -n ~/.config/zsh/.zshenv
  echo "Zsh configuration syntax is valid"
"""

# Add zsh completion test task
"zsh-completions" = """
  autoload -U compinit && compinit
  zsh -f ~/.config/zsh/.zshrc
  echo "Zsh completions loaded successfully"
"""
```

**Dotfiles symlinks**:
```toml
[dotfiles]
files = [
  ".zshrc",
  ".zshenv",
]
```

### Step 5: Create Migration Script

Create `scripts/migrate-zsh.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Zsh Migration Script: Oh My Zsh → Zinit

echo "Starting Zsh migration..."

# Step 1: Install Zinit
if [[ ! -f ~/.zinit/bin/zinit ]]; then
  echo "Installing Zinit..."
  mkdir -p ~/.zinit
  git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
else
  echo "Zinit already installed"
fi

# Step 2: Backup current zsh configuration
if [[ -f ~/.zshrc ]]; then
  echo "Backing up current zsh configuration..."
  cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
fi

# Step 3: Copy new zsh configuration
echo "Copying new zsh configuration..."
cp dotfiles/.zshrc ~/.config/zsh/.zshrc
cp dotfiles/.zshenv ~/.config/zsh/.zshenv

# Step 4: Validate configuration
echo "Validating zsh configuration..."
zsh -n ~/.config/zsh/.zshrc
zsh -n ~/.config/zsh/.zshenv

echo "Zsh migration completed successfully!"
echo "Please restart your terminal or run: exec zsh"
```

### Step 6: Update Documentation

**Update `README.md`**:
- Add section on zsh configuration
- Document migration process
- Add validation commands

**Add to `docs/migration.md`**:
- Record migration decisions
- Document any issues encountered
- Note any deferred items

## Integration with Mise Bootstrap

### Bootstrap Process

1. **Install Zinit** (if not already installed)
2. **Copy dotfiles** to `~/.config/zsh/`
3. **Validate syntax** using `mise run zsh-validate`
4. **Test completions** using `mise run zsh-completions`

### Testability

- **Syntax validation**: `zsh -n` checks for syntax errors
- **Completions test**: `zsh -f` tests without reading history
- **Bootstrap dry-run**: `mise bootstrap --dry-run` validates configuration
- **Regression tests**: Compare behavior before/after migration

## Validation Checklist

- [ ] Zinit installed and functional
- [ ] All Oh My Zsh plugins migrated to Zinit
- [ ] Custom aliases and functions preserved
- [ ] Starship prompt configuration preserved
- [ ] Cargo environment added to `.zshenv`
- [ ] Mise integration working
- [ ] Syntax validation passes
- [ ] Completions load successfully
- [ ] Bootstrap process idempotent
- [ ] Documentation updated
- [ ] Migration script tested

## Rollback Plan

If migration fails:

1. Restore backup: `cp ~/.zshrc.backup.* ~/.zshrc`
2. Revert to Oh My Zsh configuration
3. Document issue in `docs/migration.md`
4. Re-run migration with adjusted steps

## Notes

- **Testing**: Test on a fresh Mac or in a VM before deploying to main machine
- **Gradual migration**: Consider migrating plugins one at a time to isolate issues
- **Monitoring**: Monitor for unexpected behavior after migration
- **Feedback**: Document any issues or improvements in `docs/migration.md`

## References

- Zinit documentation: https://zdharma-continuum.github.io/zinit/
- Mise dotfiles: https://mise.jdx.dev/dotfiles.html
- Oh My Zsh plugins: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
