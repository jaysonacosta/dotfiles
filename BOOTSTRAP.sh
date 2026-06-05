#!/usr/bin/env bash
# Bootstrap personal dotfiles. Idempotent, safe to re-run.
# Usage: ~/.dotfiles/BOOTSTRAP.sh
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33mWARN:\033[0m %s\n' "$1" >&2; }

# link <target> <linkname>: replace symlink, back up real files.
link() {
	local target="$1" linkname="$2"
	[[ -e "$target" ]] || {
		warn "missing $target, skipping"
		return
	}
	mkdir -p "$(dirname "$linkname")"
	if [[ -e "$linkname" && ! -L "$linkname" ]]; then
		warn "backing up $linkname to ${linkname}.bak"
		mv "$linkname" "${linkname}.bak"
	fi
	ln -sf "$target" "$linkname"
	printf '  %s -> %s\n' "$linkname" "$target"
}

# Cross-platform links.
info "Linking dotfiles"
link "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
link "$DOTFILES/.vimrc" "$HOME/.vimrc"
link "$DOTFILES/nvim" "$HOME/.config/nvim"

# macOS-only links (window manager, status bar, terminal).
if [[ "$(uname -s)" == "Darwin" ]]; then
	link "$DOTFILES/.yabairc" "$HOME/.yabairc"
	link "$DOTFILES/sketchybar" "$HOME/.config/sketchybar"
	link "$DOTFILES/config.ghostty" "$HOME/.config/ghostty/config"

	# Homebrew and packages.
	if ! command -v brew >/dev/null 2>&1; then
		info "Installing Homebrew"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi
	if [[ -x /opt/homebrew/bin/brew ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi
	if command -v brew >/dev/null 2>&1; then
		info "Installing Brewfile packages"
		brew bundle --file "$DOTFILES/Brewfile"
	fi
fi

# oh-my-zsh. Installer aborts if ~/.oh-my-zsh exists, so guard it.
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
	info "Installing oh-my-zsh"
	RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

# vim-plug for .vimrc.
plug="$HOME/.vim/autoload/plug.vim"
if [[ ! -f "$plug" ]]; then
	info "Installing vim-plug"
	curl -fLo "$plug" --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

info "Done. Run :PlugInstall in vim, then restart your shell."
