---
name: claude-delegate
description: Spawn a Claude Code worker in a new kitty window to run a task via claude -p. Use when the user wants to delegate work to a Claude subprocess, generate content, or run tasks in parallel. Also use when the user says "delegate to claude", "spawn claude", "claude worker", or similar.
---

# Claude Delegate

Spawn a Claude Code worker in a new kitty window to run a headless `claude -p` task.

## Usage

```bash
./delegate.sh --prompt "your task here" [options]
```

## Options

| Option | Default | Description |
|---|---|---|
| `--prompt "..."` | **required** | The task for Claude to run |
| `--save path` | none | Save output to file |
| `--title name` | `claude-delegate` | Window title (also used for --match) |
| `--location` | `vsplit` | `vsplit` or `hsplit` |
| `--no-keep` | (stay open) | Close window immediately after task |

## Examples

```bash
# Basic delegation — window stays open
./delegate.sh --prompt "Write a short story about a cat"

# Save to file
./delegate.sh --prompt "Explain monads simply" --save ~/monads.md

# Named worker (for later send-text to it)
./delegate.sh --prompt "Review auth.py" --title code-review --location hsplit

# Fire and forget
./delegate.sh --prompt "Generate test data" --title test-gen --no-keep
```

## Tips

- Named windows can receive follow-up commands via `kitty @ send-text --match title:name`
- Close a worker: `kitty @ close-window --match title:name`
- Get worker output: `kitty @ get-text --match title:name --extent all`
