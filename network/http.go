package network

import (
	"io"
	"net/http"
	"strings"
	"sync"
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

func Request_CONCURRENT(c *sync.WaitGroup, method string, url string, headers Header) {
	defer c.Done()

	Request(method, url, headers)
}

func Request(method string, url string, headers Header) {

	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		terminal.Err(err)
		return
	}

	for key, value := range headers {
		req.Header.Set(key, value)
	}

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		terminal.Err(err)
		return
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		terminal.Err(err)
		return
	}

	printBody(method, url, resp.Status, body)
}

var mut sync.Mutex

func printBody(method string, url string, status string, body []byte) {
	mut.Lock()
	defer mut.Unlock()

	terminal.PrintLn(method, url)
	terminal.PrintLn(status)
	terminal.PrintJSON(body)
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
