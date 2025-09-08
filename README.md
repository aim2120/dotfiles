# Personal Dotfiles with Chezmoi

This repository contains my personal dotfiles managed by [chezmoi](https://www.chezmoi.io/), featuring encrypted secrets, shell configurations, and development tools setup for macOS.

## Features

- **Shell Configuration**: Comprehensive Zsh setup with Oh My Zsh and Powerlevel10k theme
- **Package Management**: Automated Homebrew package installation via Brewfile
- **Secret Management**: Age-encrypted sensitive files and configuration
- **Development Tools**: Pre-configured setups for Git, Xcode, Swift development
- **API Integrations**: Environment setup for Bitwarden, DataDog, GitLab, Jira, and more
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

## Quick Start

1. **Initialize chezmoi with this repository**:

   ```bash
   chezmoi init --apply https://github.com/aim2120/dotfiles.git
   ```

2. **Create the chezmoi configuration file** at `~/.config/chezmoi/chezmoi.toml`:

   ```toml
   [data]

   [data.bitwarden]
   session = "your_bw_session_key"

   [data.datadog]
   api_key = "your_datadog_api_key"
   app_key = "your_datadog_app_key"

   [data.zephyr]
   api_token = "your_zephyr_scale_api_token"

   [data.gitlab]
   personal_access_token = "your_gitlab_pat"
   api_url = "https://gitlab.example.com/api/v4"

   [data.github]
   personal_access_token = "your_github_pat"

   [data.artifactory]
   username = "your_artifactory_username"
   password = "your_artifactory_password"
   url = "https://your-artifactory-url"

   [data.splunk]
   token = "your_splunk_token"

   [data.xcodes]
   username = "your_apple_id"
   password = "your_apple_id_password"
   ```

3. **Set up the age encryption key**: The setup script will automatically decrypt the age key on first run.

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

The following variables must be defined in your chezmoi configuration (`~/.config/chezmoi/chezmoi.toml`):

### API Keys and Tokens

- `bitwarden.session` - Bitwarden CLI session key
- `datadog.api_key` - DataDog API key
- `datadog.app_key` - DataDog application key
- `zephyr.api_token` - Zephyr Scale API token
- `splunk.token` - Splunk HEC token

### Git Platform Tokens

- `gitlab.personal_access_token` - GitLab personal access token
- `gitlab.api_url` - GitLab API URL (e.g., `https://gitlab.example.com/api/v4`)
- `github.personal_access_token` - GitHub personal access token

### Artifactory Credentials

- `artifactory.username` - Artifactory username
- `artifactory.password` - Artifactory password
- `artifactory.url` - Artifactory instance URL

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

1. Add the variable to your `chezmoi.toml` configuration
2. Use `{{ .category.variable_name }}` in template files
3. Apply changes with `chezmoi apply`

## Security Notes

- All sensitive files are encrypted using age encryption
- SSH keys and credentials are never stored in plain text
- The age private key should be securely backed up
- Template variables in `chezmoi.toml` are stored locally only

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

1. Check your `~/.config/chezmoi/chezmoi.toml` file
2. Ensure all required variables are defined
3. Verify the variable names match the template files

### Shell Configuration Issues

After applying changes, restart your shell:

```bash
exec zsh
```
