# Jayson's .dotfiles 🔥

## Steps to bootstrap a new Mac

### 1. Install Apple's Command Line Tools. These are needed for Git and Homebrew.

`xcode-select --install`

### 2. Clone the repo into a new hidden directory `~/.dotfiles`

```bash
# SSH
git clone git@github.com:jaysonacosta/dotfiles.git ~/.dotfiles

# HTTPS & switch remotes later
git clone https://github.com/jaysonacosta/dotfiles.git
```

### 3. Execute `/.BOOTSTRAP.sh`

```bash
$ ./BOOTSTRAP.sh
```