package network

import (
	"io"
	"net/http"
	"strings"
	"zap/pkg/terminal"
)

type Header map[string]string

func Method(m string) string {
	lowercase := strings.ToLower(m)
	method := strings.TrimSpace(lowercase)

	switch method {
	case "get":
		return "GET"
	case "post":
		return "POST"
	case "put":
		return "PUT"
	case "patch":
		return "PATCH"
	case "delete":
		return "DELETE"
	default:
		return INVALID_METHOD
	}
}

func Request(method string, url string, headers Header) error {
	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		return err
	}

	for key, value := range headers {
		terminal.PrintLn("Setting", key, value)
		req.Header.Set(key, value)
	}

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return err
	}

	terminal.PrintLn(resp.Status)
	terminal.PrintJSON(body)
	return nil
}

/* ========================================================

```go
// Basic request
req, err := http.NewRequest("GET", "https://example.com", nil)
client := &http.Client{}
resp, err := client.Do(req)
defer resp.Body.Close()
```

```go
// With body
body := strings.NewReader(`{"key":"value"}`)
req, err := http.NewRequest("POST", "https://example.com", body)
```

```go
// Add headers
req.Header.Set("Content-Type", "application/json")
req.Header.Set("Authorization", "Bearer token")
```

```go
// Read response
bodyBytes, err := io.ReadAll(resp.Body)
bodyString := string(bodyBytes)
```

======================================================== */
