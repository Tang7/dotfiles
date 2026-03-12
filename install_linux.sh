#!/usr/bin/env bash
# Linux shell tools installer
# Supports: Debian/Ubuntu (apt), Arch (pacman), Fedora (dnf)

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()    { echo -e "${GREEN}[+]${NC} $*"; }
warn()    { echo -e "${YELLOW}[!]${NC} $*"; }
err()     { echo -e "${RED}[x]${NC} $*" >&2; }
section() { echo -e "\n${GREEN}══ $* ══${NC}"; }

# ─── Package manager detection ────────────────────────────────────────────────
if command -v apt-get &>/dev/null; then PM="apt"
elif command -v pacman &>/dev/null; then PM="pacman"
elif command -v dnf &>/dev/null;    then PM="dnf"
else err "No supported package manager found (apt / pacman / dnf)."; exit 1
fi
info "Detected package manager: $PM"

install_pkg() {
    case "$PM" in
        apt)    sudo apt-get install -y "$@" ;;
        pacman) sudo pacman -S --noconfirm "$@" ;;
        dnf)    sudo dnf install -y "$@" ;;
    esac
}

# ─── System packages ──────────────────────────────────────────────────────────
section "System packages"

case "$PM" in
    apt)
        sudo apt-get update -q
        install_pkg zsh vim curl tmux ripgrep fd-find bat tldr
        # Debian/Ubuntu ship these with different names — symlink to canonical names
        if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
            sudo ln -sf "$(command -v batcat)" /usr/local/bin/bat
            info "Symlinked batcat → bat"
        fi
        if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
            sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
            info "Symlinked fdfind → fd"
        fi
        ;;
    pacman)
        sudo pacman -Sy --noconfirm
        install_pkg zsh vim curl tmux ripgrep fd bat tldr
        ;;
    dnf)
        install_pkg zsh vim curl tmux ripgrep fd-find bat tldr
        if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
            sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
        fi
        ;;
esac

# ─── fzf ──────────────────────────────────────────────────────────────────────
section "fzf"
if [[ ! -d "$HOME/.fzf" ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all --no-bash --no-fish
    info "fzf installed"
else
    info "fzf already present — skipping"
fi

# ─── eza ──────────────────────────────────────────────────────────────────────
section "eza"
if ! command -v eza &>/dev/null; then
    case "$PM" in
        apt)
            sudo mkdir -p /etc/apt/keyrings
            wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
                | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
            echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
                | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
            sudo apt-get update -q && install_pkg eza
            ;;
        pacman) install_pkg eza ;;
        dnf)
            EZA_VER=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest \
                | grep '"tag_name"' | cut -d'"' -f4)
            curl -fsSL "https://github.com/eza-community/eza/releases/download/${EZA_VER}/eza_x86_64-unknown-linux-gnu.tar.gz" \
                | sudo tar -xz -C /usr/local/bin eza
            ;;
    esac
    info "eza installed"
else
    info "eza already present — skipping"
fi

# ─── zoxide ───────────────────────────────────────────────────────────────────
section "zoxide"
if ! command -v zoxide &>/dev/null; then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    info "zoxide installed"
else
    info "zoxide already present — skipping"
fi

# ─── oh-my-zsh ────────────────────────────────────────────────────────────────
section "oh-my-zsh"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    RUNZSH=no CHSH=no sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    info "oh-my-zsh installed"
else
    info "oh-my-zsh already present — skipping"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions \
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    info "zsh-autosuggestions installed"
else
    info "zsh-autosuggestions already present — skipping"
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting \
        "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    info "zsh-syntax-highlighting installed"
else
    info "zsh-syntax-highlighting already present — skipping"
fi

# ─── Dotfile symlinks ─────────────────────────────────────────────────────────
section "Dotfile symlinks"

symlink() {
    local src="$1" dst="$2"
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        warn "$dst already exists — backing up to ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi
    ln -sfn "$src" "$dst"
    info "Linked $dst → $src"
}

symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
symlink "$DOTFILES_DIR/.vimrc"     "$HOME/.vimrc"

# ─── Default shell ────────────────────────────────────────────────────────────
section "Default shell"
ZSH_PATH="$(command -v zsh)"
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
    grep -qF "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells
    chsh -s "$ZSH_PATH"
    info "Default shell set to $ZSH_PATH"
else
    info "zsh is already the default shell"
fi

# ─── Done ─────────────────────────────────────────────────────────────────────
section "Done"
info "All tools installed. Start a new zsh session to apply changes."
