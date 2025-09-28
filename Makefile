# Zap - High-performance API testing tool
# Go version
GO_VERSION := $(shell go version | cut -d' ' -f3)
APP_NAME := zap
BUILD_DIR := bin
MAIN_FILE := main.go

# Build flags
LDFLAGS := -ldflags="-s -w"
BUILD_FLAGS := -trimpath

# Default target
.PHONY: all
all: build

# Build the application
.PHONY: build
build:
	@echo "Building $(APP_NAME)..."
	@mkdir -p $(BUILD_DIR)
	go build $(BUILD_FLAGS) $(LDFLAGS) -o $(BUILD_DIR)/$(APP_NAME) $(MAIN_FILE)
	@echo "Built $(APP_NAME) successfully in $(BUILD_DIR)/"

# Build for development (with debug info)
.PHONY: dev
dev:
	@echo "Building $(APP_NAME) in development mode..."
	@mkdir -p $(BUILD_DIR)
	go build -o $(BUILD_DIR)/$(APP_NAME)-dev $(MAIN_FILE)
	@echo "Built $(APP_NAME)-dev successfully"

# Install to system PATH
.PHONY: install
install: build
	@echo "Installing $(APP_NAME) to /usr/local/bin..."
	sudo cp $(BUILD_DIR)/$(APP_NAME) /usr/local/bin/$(APP_NAME)
	@echo "$(APP_NAME) installed successfully"

# Run the application
.PHONY: run
run:
	go run $(MAIN_FILE) $(ARGS)

# Run tests
.PHONY: test
test:
	@echo "Running tests..."
	go test -v ./...

# Run tests with coverage
.PHONY: test-coverage
test-coverage:
	@echo "Running tests with coverage..."
	go test -v -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out -o coverage.html
	@echo "Coverage report generated: coverage.html"

# Clean build artifacts
.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(BUILD_DIR)
	rm -f coverage.out coverage.html
	@echo "Clean completed"

# Format code
.PHONY: fmt
fmt:
	@echo "Formatting code..."
	go fmt ./...
	@echo "Code formatted"

# Lint code
.PHONY: lint
lint:
	@echo "Linting code..."
	golangci-lint run
	@echo "Linting completed"

# Vet code
.PHONY: vet
vet:
	@echo "Vetting code..."
	go vet ./...
	@echo "Vet completed"

# Download dependencies
.PHONY: deps
deps:
	@echo "Downloading dependencies..."
	go mod download
	go mod tidy
	@echo "Dependencies updated"

# Cross-compile for multiple platforms
.PHONY: build-all
build-all:
	@echo "Building for multiple platforms..."
	@mkdir -p $(BUILD_DIR)
	
	# Linux AMD64
	GOOS=linux GOARCH=amd64 go build $(BUILD_FLAGS) $(LDFLAGS) -o $(BUILD_DIR)/$(APP_NAME)-linux-amd64 $(MAIN_FILE)
	
	# Linux ARM64
	GOOS=linux GOARCH=arm64 go build $(BUILD_FLAGS) $(LDFLAGS) -o $(BUILD_DIR)/$(APP_NAME)-linux-arm64 $(MAIN_FILE)
	
	# macOS AMD64
	GOOS=darwin GOARCH=amd64 go build $(BUILD_FLAGS) $(LDFLAGS) -o $(BUILD_DIR)/$(APP_NAME)-darwin-amd64 $(MAIN_FILE)
	
	# macOS ARM64 (Apple Silicon)
	GOOS=darwin GOARCH=arm64 go build $(BUILD_FLAGS) $(LDFLAGS) -o $(BUILD_DIR)/$(APP_NAME)-darwin-arm64 $(MAIN_FILE)
	
	# Windows AMD64
	GOOS=windows GOARCH=amd64 go build $(BUILD_FLAGS) $(LDFLAGS) -o $(BUILD_DIR)/$(APP_NAME)-windows-amd64.exe $(MAIN_FILE)
	
	@echo "Cross-compilation completed"

# Create release archives
.PHONY: release
release: build-all
	@echo "Creating release archives..."
	@mkdir -p $(BUILD_DIR)/releases
	
	# Create tar.gz for Unix systems
	tar -czf $(BUILD_DIR)/releases/$(APP_NAME)-linux-amd64.tar.gz -C $(BUILD_DIR) $(APP_NAME)-linux-amd64
	tar -czf $(BUILD_DIR)/releases/$(APP_NAME)-linux-arm64.tar.gz -C $(BUILD_DIR) $(APP_NAME)-linux-arm64
	tar -czf $(BUILD_DIR)/releases/$(APP_NAME)-darwin-amd64.tar.gz -C $(BUILD_DIR) $(APP_NAME)-darwin-amd64
	tar -czf $(BUILD_DIR)/releases/$(APP_NAME)-darwin-arm64.tar.gz -C $(BUILD_DIR) $(APP_NAME)-darwin-arm64
	
	# Create zip for Windows
	zip -j $(BUILD_DIR)/releases/$(APP_NAME)-windows-amd64.zip $(BUILD_DIR)/$(APP_NAME)-windows-amd64.exe
	
	@echo "Release archives created in $(BUILD_DIR)/releases/"

# Run benchmarks
.PHONY: benchmark
benchmark: build
	@echo "Running benchmarks..."
	@echo "Local benchmark (requires local server on port 8000):"
	hyperfine -N './$(BUILD_DIR)/$(APP_NAME) /' 'curl -s localhost:8000' || echo "hyperfine not installed or server not running"
	@echo ""
	@echo "Remote benchmark:"
	hyperfine './$(BUILD_DIR)/$(APP_NAME) httpbin.org/json' 'curl -s https://httpbin.org/json' || echo "hyperfine not installed"

# Development setup
.PHONY: setup
setup:
	@echo "Setting up development environment..."
	go mod init zap 2>/dev/null || true
	go mod download
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest || echo "Failed to install golangci-lint"
	@echo "Development setup completed"

# Show help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build         - Build the application"
	@echo "  dev          - Build with debug info"
	@echo "  install      - Install to system PATH"
	@echo "  run          - Run the application (use ARGS='...' for arguments)"
	@echo "  test         - Run tests"
	@echo "  test-coverage - Run tests with coverage report"
	@echo "  clean        - Clean build artifacts"
	@echo "  fmt          - Format code"
	@echo "  lint         - Lint code"
	@echo "  vet          - Vet code"
	@echo "  deps         - Download and tidy dependencies"
	@echo "  build-all    - Cross-compile for multiple platforms"
	@echo "  release      - Create release archives"
	@echo "  benchmark    - Run performance benchmarks"
	@echo "  setup        - Setup development environment"
	@echo "  help         - Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make run ARGS='/api/users'"
	@echo "  make build"
	@echo "  make test"
