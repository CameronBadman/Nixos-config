# NixOS Configuration

This repository contains my personal NixOS system configuration with a modular structure for easy management and replication.

## Initial Setup

1. Enable wpa_supplicant for WiFi:

```bash
sudo systemctl enable wpa_supplicant
```

2. Configure your WiFi credentials:
   - Navigate to `modules/core/networking`
   - Add your SSID and PSK in the appropriate configuration section

## Directory Structure

```
.
├── programs/          # Package configurations
│   ├── editors/      # Text editors (neovim, etc.)
│   ├── terminal/     # Terminal emulators and tools
│   ├── containers/   # Docker, kubernetes
│   ├── languages/    # Programming languages and LSP
│   └── media/        # Browsers and media tools
├── desktop/          # Desktop environment (Hyprland)
└── modules/          # Core system modules
    └── core/         # Core system configurations
```

## Package Management

### Adding New Packages

- Navigate to the appropriate directory in `programs/`
- Add package to the relevant `default.nix` list for default configuration
- For custom configurations, create a new .nix file (e.g., `neovim.nix`)

### Updating GitHub-sourced Packages

1. Remove the SHA hash value in the configuration
2. Replace with empty quotes `""`
3. Run `nixos-rebuild`
4. The build will fail and provide the correct hash
5. Replace the empty quotes with the new hash
6. Run `nixos-rebuild` again

## Desktop Environment

Hyprland configuration can be found in the `desktop` directory. Customize window management, keybindings, and appearance settings here.

## Additional Notes

- Each directory in `programs/` supports both default package installation and custom configurations
- Custom configurations are automatically imported from .nix files in their respective directories
- The modular structure allows for easy addition and removal of components

## Usage

To rebuild your system after making changes:

```bash
sudo nixos-rebuild switch
```

For development/testing:

```bash
sudo nixos-rebuild test
```
