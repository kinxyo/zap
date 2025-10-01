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

# Roadmap

## Done ✅
- Concurrent requests
- Custom headers
- Authentication support
- JSON response formatting
- Multiple HTTP methods (GET, POST, PUT, PATCH, DELETE)
- Config-based API collections

## Missing ❌

### Critical:
1. **Request bodies** - Can't send POST/PUT/PATCH data
2. **Response headers display** - Only showing status code
3. **Error details** - Need better error messages
4. **Query parameters** - No easy way to add `?key=value`
5. **Different auth types** - Only supports Bearer tokens (no Basic Auth, API keys, etc.)
6. **File uploads** - Can't send files
7. **Timeout configuration** - No way to set request timeouts
8. **Follow redirects** - Might not handle 3xx properly
9. **Certificate options** - No way to handle self-signed certs or skip TLS verification

### Nice to have:
- Download files (save response to disk)
- Progress indicators for large requests
- Cookie handling
- Proxy support
- HTTP/2 support configuration
- Verbose mode (show full request/response)

## Essential for API testing

1. **Assertions/Validation** - Can't check if response matches expectations
2. **Test scripts** - No pre-request or post-request scripts
3. **Environment variables** - Can't swap between dev/staging/prod
4. **Response time metrics** - Not measuring/displaying latency
5. **Status code validation** - Not failing on non-200 responses
6. **Response body tests** - Can't validate JSON schema or specific fields
7. **Test reports** - No summary of pass/fail

## Current use case:

Right now it's good for:
- ✅ Quick smoke testing multiple endpoints
- ✅ Checking if APIs are responding
- ✅ Basic authentication testing
- ✅ Viewing JSON responses

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
---

