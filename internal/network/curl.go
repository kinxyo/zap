package network

import (
	"io"
	"net/http"
	"time"
)

func CURL(method Method, url URL, headers *Headers) (*Result, error) {
	start := time.Now() // -- STARTS

	req, err := http.NewRequest(string(method), string(url), nil)
	if err != nil {
		return nil, err
	}

	if headers != nil {
		for key, value := range *headers {
			req.Header.Set(key, value)
		}
	}

	resp, err := (&http.Client{}).Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	elapsed := time.Since(start) // -- ENDS

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	result := CreateResult(&method, &url, resp, &body, elapsed.Seconds())
	return result, nil
}
