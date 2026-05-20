#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Stow everything that lives under ~/.config
stow .

# Warp lives at ~/.warp (not ~/.config/warp), so link it manually.
mkdir -p "$HOME/.warp/themes"
ln -snf "$DOTFILES_DIR/warp/settings.toml" "$HOME/.warp/settings.toml"
for theme in "$DOTFILES_DIR"/warp/themes/*/; do
  name="$(basename "$theme")"
  ln -snf "$theme" "$HOME/.warp/themes/$name"
done

echo "Done. Restart Warp / WezTerm to pick up changes."
