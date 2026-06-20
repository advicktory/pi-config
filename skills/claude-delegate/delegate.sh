#!/bin/bash
# delegate.sh — spawn a kitty window running claude -p with options
# Usage: ./delegate.sh --prompt "task" [--save path] [--title name] [--location vsplit|hsplit]

set -e

PROMPT=""
SAVE=""
TITLE="claude-delegate"
LOCATION="vsplit"
KEEP=true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --prompt)   PROMPT="$2"; shift 2 ;;
    --save)     SAVE="$2"; shift 2 ;;
    --title)    TITLE="$2"; shift 2 ;;
    --location) LOCATION="$2"; shift 2 ;;
    --no-keep)  KEEP=false; shift ;;
    *) echo "Unknown: $1"; exit 1 ;;
  esac
done

if [ -z "$PROMPT" ]; then
  echo "Usage: delegate.sh --prompt 'task' [--save file] [--title name] [--location vsplit|hsplit] [--no-keep]"
  exit 1
fi

# Build the shell command
CMD='echo "=== '"$TITLE"' ==="'
if [ -n "$SAVE" ]; then
  CMD="$CMD | tee \"$SAVE\""
fi
CMD="$CMD && echo"

CMD="$CMD && /opt/homebrew/bin/claude -p '$PROMPT'"
if [ -n "$SAVE" ]; then
  CMD="$CMD | tee -a \"$SAVE\""
fi

if $KEEP; then
  CMD="$CMD && echo && echo '=== Done — press any key to close ===' && read"
fi

kitty @ launch --type=window --location="$LOCATION" --title="$TITLE" /bin/zsh -c "$CMD"
echo "Launched window: $TITLE"
