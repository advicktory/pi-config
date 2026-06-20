#!/bin/bash
# install.sh — pi agent config (standalone)
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
DEST="${HOME}/.dotfiles/pi-config"
PI="${HOME}/.pi/agent"

echo "🌿  pi config → ~/.pi/agent/"
mkdir -p "$DEST/skills" "$DEST/themes" "$DEST/prompts"
cp "$DIR"/settings.json "$DIR"/keybindings.json "$DIR"/AGENTS.md "$DEST/"
cp -r "$DIR"/skills/* "$DEST/skills/" 2>/dev/null || true
cp -r "$DIR"/themes/* "$DEST/themes/" 2>/dev/null || true
cp -r "$DIR"/prompts/* "$DEST/prompts/" 2>/dev/null || true

mkdir -p "$PI/skills" "$PI/themes" "$PI/prompts"
for f in settings.json keybindings.json AGENTS.md; do
  [ -L "$PI/$f" ] && rm "$PI/$f"
  ln -sf "$DEST/$f" "$PI/$f"
done
for skill in "$DEST/skills/"*; do
  [ -d "$skill" ] || continue
  name="$(basename "$skill")"
  [ -L "$PI/skills/$name" ] && rm "$PI/skills/$name"
  ln -sfn "$skill" "$PI/skills/$name"
done
for theme in "$DEST/themes/"*; do
  [ -f "$theme" ] || continue
  name="$(basename "$theme")"
  [ -L "$PI/themes/$name" ] && rm "$PI/themes/$name"
  ln -sf "$theme" "$PI/themes/$name"
done
for prompt in "$DEST/prompts/"*; do
  [ -f "$prompt" ] || continue
  name="$(basename "$prompt")"
  [ -L "$PI/prompts/$name" ] && rm "$PI/prompts/$name"
  ln -sf "$prompt" "$PI/prompts/$name"
done
echo "   done"
