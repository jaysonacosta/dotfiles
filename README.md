# Jayson's .dotfiles

Dotfiles for nvim, yabai, sketchybar, ghostty, vim, and git.

## Bootstrap a new Mac

### 1. Install Apple's Command Line Tools (needed for Git and Homebrew)

```bash
xcode-select --install
```

### 2. Clone the repo to `~/.dotfiles`

```bash
# SSH
git clone git@github.com:jaysonacosta/dotfiles.git ~/.dotfiles

# HTTPS
git clone https://github.com/jaysonacosta/dotfiles.git ~/.dotfiles
```

### 3. Run the bootstrap (idempotent)

```bash
~/.dotfiles/BOOTSTRAP.sh
```

## Bootstrap a new Linux machine

### 1. Install Git

```bash
sudo apt-get install git-all
```

### 2. Clone the repo to `~/.dotfiles`

```bash
git clone git@github.com:jaysonacosta/dotfiles.git ~/.dotfiles
```

### 3. Run the bootstrap

```bash
~/.dotfiles/BOOTSTRAP.sh
```

The bootstrap links cross-platform configs everywhere and the macOS-only
configs (yabai, sketchybar, ghostty) on macOS.

## Fonts

The Brewfile installs SF Mono (code editor font) and SF Symbols (sketchybar glyphs).
