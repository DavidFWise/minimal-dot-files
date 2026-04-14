#!/bin/bash
set -e

echo "Starting minimal dotfiles installation..."

# 1. Get the absolute path of this repository inside the container
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 2. Symlink your config file to the container's home directory
ln -sf "$DOTFILES_DIR/.custom_aliases" "$HOME/.custom_aliases"

# 3. Tell the container's default .bashrc to load your aliases
# (The grep check ensures we don't accidentally add it twice on a rebuild)
if ! grep -q ".custom_aliases" "$HOME/.bashrc"; then
  echo "source ~/.custom_aliases" >>"$HOME/.bashrc"
fi

echo "Dotfiles successfully linked!"
