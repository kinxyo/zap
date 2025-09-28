# Zap ⚡

A high-performance API testing tool and `curl` replacement built for speed and simplicity.

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
make build
./zap --help
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

## Performance

Zap consistently outperforms traditional tools:

### Local Development (localhost:8000)
```
Benchmark 1: zap /
  Time (mean ± σ):     389.0 µs ± 89.2 µs
  Range (min … max):   256.0 µs … 1133.6 µs

Benchmark 2: curl -s localhost:8000  
  Time (mean ± σ):       3.2 ms ± 0.4 ms
  Range (min … max):     2.4 ms … 4.6 ms

Summary: zap ran 8.35 ± 2.23 times faster than curl
```

### Remote APIs (httpbin.org)
```
Benchmark 1: zap httpbin.org/json
  Time (mean ± σ):     750.3 ms ± 300.9 ms

Benchmark 2: curl -s httpbin.org/json
  Time (mean ± σ):     801.7 ms ± 191.6 ms  

Summary: zap ran 1.07 ± 0.50 times faster than curl
```

*Benchmarks run with hyperfine on local hardware*

## Why Zap?

- **Faster than curl** for development workflows
- **Better UX** than Postman for simple API testing  
- **Lighter than HTTPie** while maintaining ease of use
- **Configuration management** built-in
- **TUI interface** for interactive testing

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

