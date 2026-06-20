#!/bin/bash
# install.sh — pi agent config (standalone, no brew/nix needed)
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
PI="${HOME}/.pi/agent"

echo "🌿  pi config → ~/.pi/agent/"
mkdir -p "$PI/skills" "$PI/themes" "$PI/prompts"

for f in settings.json keybindings.json AGENTS.md; do
  [ -L "$PI/$f" ] && rm "$PI/$f"
  [ -e "$PI/$f" ] && mv "$PI/$f" "$PI/${f}.bak-$(date +%Y%m%d-%H%M%S)"
  ln -sf "$DIR/$f" "$PI/$f"
done

for skill in "$DIR/skills/"*; do
  [ -d "$skill" ] || continue
  name="$(basename "$skill")"
  [ -L "$PI/skills/$name" ] && rm "$PI/skills/$name"
  [ -e "$PI/skills/$name" ] && mv "$PI/skills/$name" "$PI/skills/${name}.bak-$(date +%Y%m%d-%H%M%S)"
  ln -sfn "$skill" "$PI/skills/$name"
done

for theme in "$DIR/themes/"*; do
  [ -f "$theme" ] || continue
  name="$(basename "$theme")"
  [ -L "$PI/themes/$name" ] && rm "$PI/themes/$name"
  ln -sf "$theme" "$PI/themes/$name"
done

for prompt in "$DIR/prompts/"*; do
  [ -f "$prompt" ] || continue
  name="$(basename "$prompt")"
  [ -L "$PI/prompts/$name" ] && rm "$PI/prompts/$name"
  ln -sf "$prompt" "$PI/prompts/$name"
done

echo "   done"
