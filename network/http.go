package network

import (
	"io"
	"net/http"
	"strings"
	"zap/utils/terminal"
)

func Method(m string) string {
	switch strings.TrimSpace(m) {
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

func Request(method string, url string) error {
	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		return err
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

	terminal.Print("Response:", string(body))

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
