> [!NOTE]
> Not Ready. Haven't reached v1.

# Zap ⚡

Terminal-native API testing tool for developers who live in the command line.

## Why Zap?

- **Stay in your workflow** - No context switching to Postman
- **Git-friendly configs** - Version control your API collections
- **Automation-ready** - Script and test APIs without leaving the terminal
- **Fast and lightweight** - No Electron bloat
- **Privacy-first** - Your data stays local
- **TUI interface** for interactive testing

Perfect for Helix/Vim/Neovim users, tmux workflows, and anyone tired of bloated GUI tools.

## Usage

```bash
# Simple GET request
zap /api/users

# Explicit method and URL  
zap POST /api/users

# Remote API
zap httpbin.org/json

# Interactive TUI mode
zap tui

# Use saved configuration
zap run
```

## Installation

```bash
make install
export PATH="$HOME/bin:$PATH"
zap --help
```

## Configuration

Create a `config.json` to define reusable API collections:

```json
{
  "name": "Example",
  "port": 8000,
  "auth": {
    "Authorization": "Bearer xxx"
  },
  "apis": [
    {
      "path": "GET /",
      "protected": false,
      "headers": {
        "Content-Type": "text/plain"
      }
    },
    {
      "path": "POST /api/users",
      "protected": true
    }
  ]
}

```

## Usage Modes

### Command Line
```bash
zap <method> <path>     # Explicit method
zap <path>              # Defaults to GET
zap -d <url>            # Force HTTP (dev mode)
```

### TUI Interface
```bash
zap tui
```
- Browse saved APIs
- Execute requests interactively  
- Edit request bodies
- View response history

### Configuration Mode
```bash
zap run
```
Loads and runs APIs from `zap.json`

## URL Resolution

Zap handles different URL formats:

```bash
zap /api/users           # → http://localhost:8000/api/users
zap example.com/api      # → https://example.com/api  
zap -d example.com/api   # → http://example.com/api
```

## Development

```bash
# Build from source
git clone <repo>
cd zap
make build

# Run tests  
make test

# Development mode
go run . <args>
```
