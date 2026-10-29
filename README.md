# 🛠️ Dotfiles

A modular, robust, and idempotent one-stop dotfiles repository for macOS. Automatically provisions and symlinks configurations for **Neovim (LazyVim)**, **VS Code**, **Kitty**, **Zsh**, **Git**, and **Homebrew** with safe backups and automated secret prevention.

---

## 📑 Table of Contents

- [Overview & Philosophy](#-overview--philosophy)
- [Prerequisites](#-prerequisites)
- [Quick Start Installation](#-quick-start-installation)
- [Installer Options & Flags](#-installer-options--flags)
- [Repository Structure](#-repository-structure)
- [Component Breakdown](#-component-breakdown)
  - [Neovim (LazyVim)](#neovim-lazyvim)
  - [Visual Studio Code](#visual-studio-code)
  - [Terminal (Kitty)](#terminal-kitty)
  - [Shell (Zsh, Bash & Profiles)](#shell-zsh-bash--profiles)
  - [SSH & Git](#ssh--git)
- [Secret Management & Local Overrides](#-secret-management--local-overrides)
- [Day-to-Day Workflows & Syncing](#-day-to-day-workflows--syncing)
- [How-To Guides](#-how-to-guides)
  - [Adding a New Config File](#adding-a-new-config-file)
  - [Adding Homebrew Packages](#adding-homebrew-packages)
  - [Adding VS Code Extensions](#adding-vs-code-extensions)
  - [Restoring from a Backup](#restoring-from-a-backup)
- [Troubleshooting](#-troubleshooting)

---

## 💡 Overview & Philosophy

1. **Single Source of Truth:** Everything lives in `~/dev/dotfiles`. Files in your home directory (`~/.config/nvim`, `~/.zshrc`, etc.) are direct symbolic links. Any edit made in your editor is instantly tracked in Git without manual copying or syncing scripts.
2. **Safety First:** The installer never clobbers existing files. Any non-symlink file or folder is safely moved to a timestamped backup directory (`~/.dotfiles_backup/<timestamp>/`) before creating symlinks.
3. **Zero Secret Leakage:** Uses a strict **Two-Tier (Local Override)** model. Public configurations are version-controlled; private tokens, work relays, and machine credentials stay in local, untracked `*.local` files guarded by a `gitleaks` pre-commit hook.
4. **Idempotency:** Running `./install.sh` multiple times is completely safe. Already linked files are recognized and skipped.

---

## 📋 Prerequisites

Before running the installer on a brand new Mac:

1. **Command Line Tools:**
   ```bash
   xcode-select --install
   ```
2. **Homebrew** (if not already installed):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
3. **Clone the Repository:**
   ```bash
   git clone https://github.com/jonnylin13/dotfiles.git ~/dev/dotfiles
   cd ~/dev/dotfiles
   ```

---

## 🚀 Quick Start Installation

Run the central installer:

```bash
cd ~/dev/dotfiles
./install.sh
```

What the installer automatically executes:
- [x] Creates `~/.zshrc.local`, `~/.zshenv.local`, `~/.gitconfig.local`, and `~/.ssh/config.local` templates if missing.
- [x] Backs up any existing configuration files to `~/.dotfiles_backup/<timestamp>/`.
- [x] Symlinks all configuration files into your home directory.
- [x] Installs all packages specified in `Brewfile` via `brew bundle`.
- [x] Installs all extensions listed in `config/vscode/extensions.txt`.
- [x] Installs a `gitleaks` pre-commit hook in `.git/hooks/pre-commit` to prevent accidental credential commits.

---

## ⚙️ Installer Options & Flags

```bash
Usage: ./install.sh [options]

Options:
  --dry-run      Preview symlinks, backups, and actions without modifying the filesystem
  --skip-brew    Skip running Homebrew bundle (useful for quick dotfile-only relinks)
  --skip-vscode  Skip installing VS Code extensions
  --help, -h     Show this help message
```

### Example Commands:
- **Preview what will happen:**
  ```bash
  ./install.sh --dry-run
  ```
- **Re-link configurations without re-running brew or extensions:**
  ```bash
  ./install.sh --skip-brew --skip-vscode
  ```

---

## 📁 Repository Structure

```text
~/dev/dotfiles/
├── install.sh                  # One-stop installer entry point
├── Brewfile                    # Core CLI tools (neovim, ripgrep, gitleaks, etc.)
├── .gitignore                  # Blocks *.local, .env, keys, and OS artifacts
├── README.md                   # Comprehensive documentation
├── config/
│   ├── nvim/                   # Complete Neovim setup (LazyVim) -> ~/.config/nvim
│   │   ├── init.lua
│   │   ├── lazyvim.json
│   │   ├── lazy-lock.json
│   │   ├── stylua.toml
│   │   └── lua/
│   │       ├── config/         # keymaps.lua, options.lua, autocmds.lua, lazy.lua
│   │       └── plugins/        # ai.lua (Gemini CLI, Claude Code), lspconfig.lua, etc.
│   ├── vscode/                 # Visual Studio Code configuration
│   │   ├── settings.json       # Settings (Vim mode, formatting, themes)
│   │   ├── keybindings.json    # Normal/visual mode keybindings & Harpoon
│   │   └── extensions.txt      # List of installed extensions
│   ├── kitty/                  # Terminal configuration -> ~/.config/kitty
│   │   └── kitty.conf          # Font family (ComicShannsMono Nerd Font), size, behavior
│   ├── zsh/                    # Shell configurations
│   │   ├── .zshrc              # Interactive shell (aliases, PATH, local loader)
│   │   ├── .zshenv             # Universal environment (cargo, node hooks)
│   │   ├── .bash_profile       # Login shell paths
│   │   └── .sqrx_helper        # Shell helpers
│   ├── git/                    # Git configuration -> ~/.gitconfig
│   │   └── .gitconfig          # User identity, pull preferences, local include
│   └── ssh/                    # SSH configuration -> ~/.ssh/config
│       └── config              # GitHub config + Include ~/.ssh/config.local
└── scripts/
    └── save-state.sh           # Exports current VS Code extensions to dotfiles
```

---

## 🔍 Component Breakdown

### Neovim (LazyVim)
- **Engine:** Built on [LazyVim](https://lazyvim.org) with `lazy.nvim`.
- **Symlink Target:** `~/.config/nvim` $ightarrow$ `~/dev/dotfiles/config/nvim`
- **AI Integrations (`lua/plugins/ai.lua`):**
  - **Gemini CLI (`<leader>ag/`):** Configured with dynamic environment extraction via `zsh -i -c "env -0"`. All 70+ variables from your interactive shell (like `GOOGLE_CLOUD_PROJECT`, custom `PATH`, and proxy credentials) are forwarded seamlessly to the Gemini terminal panel without slowing down Neovim startup.
  - **Claude Code (`<leader>acc`):** Dedicated keybindings for toggle, focus, resume, and diff acceptance/rejection.
- **Keybindings:** Customized in `lua/config/keymaps.lua` and `lua/plugins/ai.lua`.
- **Plugin Updates:** Run `:Lazy update` in Neovim. Commit changes to `lazy-lock.json` to lock plugin versions across machines.

### Visual Studio Code
- **Symlink Targets:**
  - `~/Library/Application Support/Code/User/settings.json` $ightarrow$ `config/vscode/settings.json`
  - `~/Library/Application Support/Code/User/keybindings.json` $ightarrow$ `config/vscode/keybindings.json`
- **Keybindings:** Includes non-recursive Vim leader mappings (`<leader>w d`, split controls, file explorer focus) and Harpoon shortcuts.
- **Sanitization:** Raw API keys are omitted. Extensions like Claude Code inherit environment variables from your shell.

### Terminal (Kitty)
- **Symlink Target:** `~/.config/kitty` $ightarrow$ `config/kitty`
- **Font:** ComicShannsMono Nerd Font (size 12.0).
- **Reloading Config:** Press `Ctrl+Shift+F5` (or `Cmd+Control+,` on macOS) inside Kitty to reload without restarting.

### Shell (Zsh, Bash & Profiles)
- **Symlink Targets:**
  - `~/.zshrc` $ightarrow$ `config/zsh/.zshrc`
  - `~/.zshenv` $ightarrow$ `config/zsh/.zshenv`
  - `~/.bash_profile` $ightarrow$ `config/zsh/.bash_profile`
- **Includes:** Google Cloud SDK, Bun, OpenJDK 21, and Homebrew paths.
- **Aliases:**
  - `dots`: Quick jump to `~/dev/dotfiles` and show git status.
  - `lsh`: Loads SQRX helper aliases if present.

### SSH & Git
- **SSH Target:** `~/.ssh/config` $ightarrow$ `config/ssh/config`
  - Contains universal GitHub SSH keys and agent configuration.
  - Includes `~/.ssh/config.local` for private/internal servers.
- **Git Target:** `~/.gitconfig` $ightarrow$ `config/git/.gitconfig`
  - Configures default user identity and rebase preferences.
  - Includes `~/.gitconfig.local` for private work emails or signing keys.

---

## 🔒 Secret Management & Local Overrides

To prevent accidental credential leaks when sharing or backing up this repository to GitHub, all sensitive values are decoupled using the **Two-Tier Model**:

| Configuration | Public / Tracked (in Dotfiles) | Private / Untracked (in `~/`) |
| :--- | :--- | :--- |
| **Shell Environment** | `config/zsh/.zshrc` | `~/.zshrc.local` |
| **Universal Shell Env**| `config/zsh/.zshenv` | `~/.zshenv.local` |
| **SSH Target Hosts** | `config/ssh/config` (GitHub) | `~/.ssh/config.local` (Work/Private IPs) |
| **Git Configuration** | `config/git/.gitconfig` | `~/.gitconfig.local` (Work emails, GPG keys) |

### Setting Up Local Secrets:
Your private `~/.zshrc.local` looks like this:
```zsh
# Machine-specific / private environment variables (DO NOT COMMIT)
export ANTHROPIC_BASE_URL="http://localhost:8082"
export ANTHROPIC_AUTH_TOKEN="your_private_token"
export ANTHROPIC_API_KEY="your_private_key"
```
Both `.gitignore` and the installed `gitleaks` pre-commit hook ensure these files can never be committed.

---

## 🔄 Day-to-Day Workflows & Syncing

Because every active configuration is a symlink:
1. **Edit Configs Directly:** Change a keymap in Neovim or a setting in VS Code; the file is instantly modified inside `~/dev/dotfiles`.
2. **Review Changes:**
   ```bash
   dots       # Jumps to ~/dev/dotfiles and runs git status
   git diff   # Inspect edits
   ```
3. **Commit & Push:**
   ```bash
   git add config/nvim/lua/config/keymaps.lua
   git commit -m "feat(nvim): add new buffer switching keymap"
   git push
   ```
4. **Pull on Another Machine:**
   ```bash
   cd ~/dev/dotfiles
   git pull --rebase
   ./install.sh --skip-brew  # Refresh symlinks safely
   ```

---

## 📖 How-To Guides

### Adding a New Config File
1. Move the configuration file into `~/dev/dotfiles/config/<tool>/`.
2. Add a `backup_and_link` entry in `install.sh`:
   ```bash
   backup_and_link "${DOTFILES_DIR}/config/<tool>/config.json" "${HOME}/.config/<tool>/config.json"
   ```
3. Test with:
   ```bash
   ./install.sh --dry-run
   ```
4. Run `./install.sh` to apply the link.

### Adding Homebrew Packages
1. Open `~/dev/dotfiles/Brewfile`.
2. Add the formula or cask:
   ```ruby
   brew "tmux"
   cask "firefox"
   ```
3. Run `./install.sh` (or `brew bundle --file=~/dev/dotfiles/Brewfile`).

### Adding VS Code Extensions
1. Install the extension in VS Code normally.
2. Run the export script:
   ```bash
   ~/dev/dotfiles/scripts/save-state.sh
   ```
3. Commit the updated `config/vscode/extensions.txt`.

### Restoring from a Backup
If you ever want to revert a file back to its pre-dotfiles state:
1. Look in `~/.dotfiles_backup/`:
   ```bash
   ls -la ~/.dotfiles_backup/
   ```
2. Copy the original file back over the symlink:
   ```bash
   cp ~/.dotfiles_backup/20261029_165244/.zshrc ~/.zshrc
   ```

---

## ❓ Troubleshooting

#### 1. `gitleaks` blocks `git commit`
If the pre-commit hook refuses to commit:
- Check the error output to see which line and file triggered the scan.
- Move the detected API key, token, or password into `~/.zshrc.local` or `~/.ssh/config.local`.
- Remove the secret from the tracked file and re-commit.

#### 2. VS Code `code` command not found in PATH
If `./install.sh` warns that `code` is not in PATH:
- Open VS Code.
- Press `Cmd+Shift+P` to open the Command Palette.
- Type `Shell Command: Install code command in PATH` and press Enter.
- Re-run `./install.sh`.

#### 3. Homebrew bundle fails on an old tap
- Homebrew bundle is now built directly into Homebrew. Ensure `tap "homebrew/bundle"` is not present in your `Brewfile`.

#### 4. Broken symlink after moving the repository
If you ever move `~/dev/dotfiles` to a different location:
- Simply `cd` into the new directory and re-run:
  ```bash
  ./install.sh
  ```
  The script uses `ln -sfn`, which automatically updates all symlink targets to the new location.
