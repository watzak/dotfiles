# dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Contents

- **zsh**: Zsh shell configuration (`.zshrc`)
- **tmux**: Tmux terminal multiplexer configuration
- **wezterm**: WezTerm terminal emulator configuration

## Requirements

### Core
- GNU Stow (install with `sudo apt-get install stow` on Debian/Ubuntu)

### Tmux Dependencies
- `entr` - File watcher for tmux-autoreload plugin
- TPM (Tmux Plugin Manager) - Installed during setup

Install on Debian/Ubuntu:
```bash
sudo apt-get install stow entr
```

## Installation

### Initial Setup

1. Clone this repository:
```bash
cd ~/master
git clone <your-repo-url> dotfiles
```

2. Install GNU Stow if not already installed:
```bash
sudo apt-get install stow
```

3. Create symlinks for all packages:
```bash
cd ~/master/dotfiles
stow -t ~ zsh tmux wezterm
```

Or install packages individually:
```bash
stow -t ~ zsh      # Only zsh config
stow -t ~ tmux     # Only tmux config
stow -t ~ wezterm  # Only wezterm config
```

### Restoring on a New Machine

```bash
cd ~/master
git clone <your-repo-url> dotfiles
cd dotfiles
stow -t ~ zsh tmux wezterm
```

#### Setting up Tmux Plugins

After stowing tmux config, you need to set up TPM and install plugins:

1. Install required dependencies:
```bash
sudo apt-get install entr  # Required for tmux-autoreload
```

2. Install TPM (Tmux Plugin Manager):
```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

3. Start tmux and install plugins:
```bash
tmux
# Then press: Ctrl+A followed by Shift+I (capital I)
# Wait for plugins to install
```

4. To manually save/restore sessions:
   - Save: `Ctrl+A` then `Shift+S`
   - Restore: `Ctrl+A` then `Shift+R`

## Usage

### Adding New Config Files

To add a new configuration file or directory:

1. Create the package directory structure mirroring your home directory:
```bash
mkdir -p <package>/<path-from-home>
```

2. Move your config files into the package:
```bash
mv ~/.myconfig dotfiles/<package>/.myconfig
```

3. Create symlinks:
```bash
cd ~/master/dotfiles
stow -t ~ <package>
```

4. Commit and push:
```bash
git add .
git commit -m "Add <package> configuration"
git push
```

### Removing Symlinks

To remove symlinks for a package:
```bash
cd ~/master/dotfiles
stow -D -t ~ <package>
```

### Restowing (Useful After Updates)

If you've modified the dotfiles structure:
```bash
cd ~/master/dotfiles
stow -R -t ~ <package>
```

## Notes

- **Tmux Plugins**: The `plugins/` directory is excluded via `.gitignore`. Plugins are managed by [TPM](https://github.com/tmux-plugins/tpm) and need to be installed separately (see setup instructions above). This keeps the repo lightweight.
- **Backup Files**: Original configs are backed up to `~/.config-backup/` during initial setup.
- **Live Updates**: Since configs are symlinked, any changes you make to the files are immediately reflected in the git repository. Remember to commit and push your changes!
- **Plugin Dependencies**: Some tmux plugins require system packages (e.g., `entr` for tmux-autoreload). Install them as needed.

## Structure

```
dotfiles/
├── zsh/
│   └── .zshrc
├── tmux/
│   └── .config/
│       └── tmux/
│           ├── tmux.conf
│           ├── scripts/
│           └── .gitignore
└── wezterm/
    └── .config/
        └── wezterm/
            ├── wezterm.lua
            ├── utils/
            └── animations/
```

## Troubleshooting

### Conflicts

If stow reports conflicts, you may have existing files. Back them up first:
```bash
mv ~/.zshrc ~/.zshrc.backup
```

Then try stowing again.

### Verify Symlinks

Check if symlinks are correctly created:
```bash
ls -lh ~/.zshrc
ls -lh ~/.config/tmux
ls -lh ~/.config/wezterm
```

Each should show a symlink arrow (`->`) pointing to the dotfiles directory.

### Tmux Plugin Issues

If you get errors like "Command not found: entr" or tmux-resurrect not working:

1. Install missing dependencies:
```bash
sudo apt-get install entr
```

2. Ensure TPM is installed:
```bash
ls ~/.config/tmux/plugins/tpm || git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

3. Reload tmux config and install plugins:
```bash
# Inside tmux: Ctrl+A then :
# Then type: source-file ~/.config/tmux/tmux.conf
# Then press: Ctrl+A then Shift+I to install plugins
```
