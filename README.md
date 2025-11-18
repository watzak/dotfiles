# dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Contents

- **zsh**: Zsh shell configuration (`.zshrc`)
- **tmux**: Tmux terminal multiplexer configuration
- **wezterm**: WezTerm terminal emulator configuration

## Requirements

- GNU Stow (install with `sudo apt-get install stow` on Debian/Ubuntu)

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

- **Tmux Plugins**: The `plugins/` directory is excluded via `.gitignore`. Plugins are managed by [TPM](https://github.com/tmux-plugins/tpm) and will be automatically installed when you start tmux.
- **Backup Files**: Original configs are backed up to `~/.config-backup/` before symlinking.
- **Live Updates**: Since configs are symlinked, any changes you make to the files are immediately reflected in the git repository. Remember to commit and push your changes!

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
