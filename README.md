# Personal Dotfiles with Chezmoi

This repository contains my personal dotfiles managed by [chezmoi](https://www.chezmoi.io/), featuring encrypted secrets, shell configurations, and development tools setup for macOS.

## Features

- **Shell Configuration**: Comprehensive Zsh setup with Oh My Zsh and Powerlevel10k theme
- **Package Management**: Automated Homebrew package installation via Brewfile
- **Secret Management**: Age-encrypted sensitive files and configuration
- **Development Tools**: Pre-configured setups for Git, Xcode, Swift development
- **API Integrations**: Environment setup for Bitwarden and more
- **SSH Configuration**: Encrypted SSH keys and configurations

## Prerequisites

1. **macOS** (this setup is macOS-focused)
2. **Homebrew**: Install from [brew.sh](https://brew.sh)
3. **chezmoi**: Install via Homebrew
   ```bash
   brew install chezmoi
   ```
4. **age**: Install for encryption (included in Brewfile)
   ```bash
   brew install age
   ```
5. **git-lfs**: Install git-lfs
   ```bash
   brew install git-lfs
   ```

## Quick Start

1. **Initialize chezmoi with this repository**:

   ```bash
   chezmoi init --apply https://github.com/aim2120/dotfiles.git [--branch=<branch>]
   ```

   Pull large files in the chezmoi repo:

   ```bash
   cd .local/share/chezmoi
   git lfs update
   ```

   Then go back to the home directory:

   ```bash
   cd ~
   ```

2. **Create the chezmoi data file** at `~/.chezmoidata.yaml` (find this in Bitwarden)

3. **Set up the age encryption key** at `~/.config/chezmoi/key.txt` (find this on old machine or in Bitwarden)

4. **Apply the configuration**:

   ```bash
   chezmoi apply
   ```

5. **Install Homebrew packages**:

   ```bash
   brew bundle --global
   ```

6. **Change repo to SSH origin**: This will allow for new changes to be committed in the future.
   ```bash
   git remote set-url origin git@github.com:aim2120/dotfiles.git
   ```

## Required Template Variables

The following variables must be defined in your chezmoi data file (`~/.chezmoidata.yaml`):

### API Keys and Tokens

- `bitwarden.session` - Bitwarden CLI session key

### Git Platform Tokens

- `github.personal_access_token` - GitHub personal access token

### Apple Developer Tools

- `xcodes.username` - Apple ID for Xcodes tool
- `xcodes.password` - Apple ID password for Xcodes tool

## Key Components

### Shell Environment

- **Zsh**: Primary shell with extensive configuration
- **Oh My Zsh**: Framework with plugins and themes
- **Powerlevel10k**: Advanced Zsh theme with git integration
- **Custom Functions**: Located in `~/.bash_functions/`

### Development Tools

- **Swift**: Swift-format configuration
- **Git**: Custom gitconfig and gitignore
- **Xcode**: Development environment setup
- **Version Managers**: mise (formerly rtx) for tool version management

### Encrypted Files

The following files are encrypted using age:

- SSH private keys
- Binary executables in `private_bin/`
- Secret configuration files
- Service-specific credentials

### Package Management

The `Brewfile` includes:

- Development tools (Git, Docker, etc.)
- Languages and runtimes (Python, Node.js, etc.)
- macOS applications via Homebrew Cask
- Custom taps for specialized tools

## Usage

### Daily Operations

```bash
# Update dotfiles from repository
chezmoi update

# Edit a file in the source directory
chezmoi edit ~/.zshrc

# Apply changes
chezmoi apply

# Check what would change
chezmoi diff
```

### Managing Secrets

```bash
# Edit encrypted files
chezmoi edit --apply ~/.ssh/id_ed25519

# Add a new encrypted file
chezmoi add --encrypt ~/.config/new-secret
```

### Adding New Template Variables

1. Add the variable to your `~/.chezmoidata.yaml` file
2. Use `{{ .category.variable_name }}` in template files
3. Apply changes with `chezmoi apply`

## Security Notes

- All sensitive files are encrypted using age encryption
- SSH keys and credentials are never stored in plain text
- The age private key should be securely backed up
- Template variables in `~/.chezmoidata.yaml` are stored locally only

## Troubleshooting

### Age Decryption Issues

If you encounter age decryption errors:

```bash
# Verify your age key exists
ls ~/.config/chezmoi/key.txt

# Re-run the setup script
chezmoi apply
```

### Template Variable Errors

If chezmoi reports missing template variables:

1. Check your `~/.chezmoidata.yaml` file
2. Ensure all required variables are defined
3. Verify the variable names match the template files

### Shell Configuration Issues

After applying changes, restart your shell:

```bash
exec zsh
```
