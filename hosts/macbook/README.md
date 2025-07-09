# macOS Setup Instructions

This guide covers setting up the macOS configuration using nix-darwin and the dotfiles flake.

## Prerequisites

### Install Nix (Choose One)

**Option A: Determinate Systems Installer (Recommended)**
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```
For detailed instructions, see: https://docs.determinate.systems/getting-started/individuals#install

**Option B: Standard Nix Installer**
```bash
sh <(curl -L https://nixos.org/nix/install)
```

## Initial Setup

### 1. Clone the dotfiles repository
```bash
git clone <your-dotfiles-repo-url>
cd dotfiles
```

### 2. Install nix-darwin
Follow the installation instructions at: https://github.com/nix-darwin/nix-darwin

### 3. First-time flake application
```bash
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#macbook
```

### 4. Set up Fish shell
After the initial setup, you need to configure Fish as your default shell:

```bash
# Add Nix fish to approved shells
echo $(which fish) | sudo tee -a /etc/shells

# Change your default shell to fish
chsh -s $(which fish)
```

## Regular Updates

### Apply configuration changes
After making changes to the flake or configuration files:

```bash
darwin-rebuild switch --flake .#macbook
```

### Update flake inputs
To update all flake inputs to their latest versions:

```bash
nix flake update
darwin-rebuild switch --flake .#macbook
```

## Configuration Details

- **Primary user**: `mikhaini`
- **System packages**: Window management (yabai, skhd), development tools
- **Home Manager**: User-level packages and dotfiles
- **Platform-specific**: macOS-optimized package selection

## Notes

- Nix settings are managed by Determinate Systems (if using their installer)
- Garbage collection is handled automatically by Determinate Systems
- Shell configuration is managed by nix-darwin but requires manual `chsh` setup
- This configuration is designed to be safe for company-managed laptops

## Troubleshooting

### Shell not changing
If `chsh` gives you a "non-standard shell" error:
1. Ensure fish is in `/etc/shells`: `grep fish /etc/shells`
2. Check fish path: `which fish`
3. Re-run the shell setup commands above

### Configuration not applying
1. Check for flake syntax errors: `nix flake check`
2. Ensure you're in the dotfiles directory
3. Try rebuilding with verbose output: `darwin-rebuild switch --flake .#macbook --verbose`