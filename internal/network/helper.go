package network

func getHost() string {
	//TODO: Fetch from "quick-config" file if it exists
	return "127.0.0.1"
}
func getAddr() string {
	//TODO: Fetch from "quick-config" file if it exists
	return ":8000"
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
