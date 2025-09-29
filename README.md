> [!NOTE]
> Not Ready. Haven't reached v1.

# Zap ⚡

Terminal-native API testing tool for developers who live in the command line.

## Features

- **Lightning fast** - Outperforms curl by 5-8x on localhost requests
- **Simple CLI interface** - Intuitive command structure for quick testing  
- **TUI mode** - Interactive interface for managing and organizing API collections
- **Configuration-driven** - Save and reuse API definitions with JSON config
- **Smart URL handling** - Automatic localhost detection and HTTPS/HTTP switching

*Future roadmap: ping utilities, domain verification, SSL certificate management*

## Quick Start

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
  "name": "My API Project",
  "port": 8000,
  "token": "your-auth-token",
  "apis": [
    {
      "path": "GET /",
      "protected": false
    },
    {
      "path": "GET /api/users", 
      "protected": false
    },
    {
      "path": "POST /api/users",
      "protected": true,
      "body": {
        "name": "John Doe",
        "email": "john@example.com"
      }
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
Loads and runs APIs from `config.json`

## URL Resolution

Zap intelligently handles different URL formats:

```bash
zap /api/users           # → http://localhost:8000/api/users
zap example.com/api      # → https://example.com/api  
zap -d example.com/api   # → http://example.com/api
```

*Benchmarks run with hyperfine on local hardware*

## Why Zap?

- **Stay in your workflow** - No context switching to Postman
- **Git-friendly configs** - Version control your API collections
- **Automation-ready** - Script and test APIs without leaving the terminal
- **Fast and lightweight** - No Electron bloat
- **Privacy-first** - Your data stays local
- **TUI interface** for interactive testing

Perfect for Vim/Neovim/Helix users, tmux workflows, and anyone
tired of bloated GUI tools.

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
