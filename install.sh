#!/bin/bash
# Stop execution if any command fails
set -e

echo "Starting modern dotfiles installation..."

# 1. Install core apt packages (sudo is passwordless for our 'dev' user)
sudo apt-get update
sudo apt-get install -y zsh curl git fzf ripgrep bat fd-find unzip wget
# 2. Install modern Rust-based tools
# Install Starship prompt
curl -sS https://starship.rs/install.sh | sh -s -- -y
# Install Zoxide (smart cd)
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
# Install Eza (modern ls)
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://apt.fury.io/eza/ /" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo apt-get update && sudo apt-get install -y eza
# --- Install Bleeding Edge Rust Tools (ARM64 Native) ---
# --- Install Modern Git Tools (ARM64 Native) ---

# 1. Install GitUI (Rust Git TUI)
echo "Installing GitUI..."
wget -qO gitui.tar.gz https://github.com/extrawurst/gitui/releases/latest/download/gitui-linux-aarch64.tar.gz
tar -xzf gitui.tar.gz
sudo mv gitui /usr/local/bin/
rm gitui.tar.gz

# 4. Install Git Delta (Rust Syntax-Highlighting Pager)
echo "Installing Git Delta..."
DELTA_VER=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
wget -qO delta.tar.gz "https://github.com/dandavison/delta/releases/download/${DELTA_VER}/delta-${DELTA_VER}-aarch64-unknown-linux-gnu.tar.gz"
tar -xzf delta.tar.gz
sudo mv "delta-${DELTA_VER}-aarch64-unknown-linux-gnu/delta" /usr/local/bin/
rm -rf delta.tar.gz "delta-${DELTA_VER}-aarch64-unknown-linux-gnu"

# 3. Install GitHub CLI
echo "Installing GitHub CLI..."
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
  sudo apt update &&
  sudo apt install gh -y
# 1. Install Yazi (Async File Manager)
echo "Installing Yazi..."
wget -qO yazi.zip https://github.com/sxyazi/yazi/releases/latest/download/yazi-aarch64-unknown-linux-musl.zip
unzip -q yazi.zip
sudo mv yazi-aarch64-unknown-linux-musl/yazi yazi-aarch64-unknown-linux-musl/ya /usr/local/bin/
rm -rf yazi.zip yazi-aarch64-unknown-linux-musl

# 2. Install Atuin (Magical Shell History)
echo "Installing Atuin..."
wget -qO atuin.tar.gz https://github.com/atuinsh/atuin/releases/latest/download/atuin-aarch64-unknown-linux-musl.tar.gz
tar -xzf atuin.tar.gz
sudo mv atuin-aarch64-unknown-linux-musl/atuin /usr/local/bin/
rm -rf atuin.tar.gz atuin-aarch64-unknown-linux-musl

# 3. Install Ouch (Painless Compression)
echo "Installing Ouch..."
wget -qO ouch.tar.gz https://github.com/ouch-org/ouch/releases/latest/download/ouch-aarch64-unknown-linux-musl.tar.gz
tar -xzf ouch.tar.gz
sudo mv ouch-aarch64-unknown-linux-musl/ouch /usr/local/bin/
rm -rf ouch.tar.gz ouch-aarch64-unknown-linux-musl
# 3. Install Zsh Plugins (Auto-suggestions & Syntax Highlighting)
mkdir -p ~/.zsh
if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi
if [ ! -d "$HOME/.zsh/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
fi

# 4. Symlink the .zshrc
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
# 5. Set Zsh as default shell cleanly
# Instead of fighting chsh permissions in Docker, we just tell bash to launch zsh
if ! grep -q "exec zsh" "$HOME/.bashrc"; then
  echo 'if [ -t 1 ]; then exec zsh; fi' >>"$HOME/.bashrc"
fi

# Ensure local bin paths are accessible
export PATH="$HOME/.local/bin:$PATH"

echo "Modern CLI tools and Zsh installed successfully!"
