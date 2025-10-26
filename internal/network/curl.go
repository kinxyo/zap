package network

import (
	"io"
	"net/http"
	"strings"
	"time"
)

func CURL(method Method, url URL, payload *Payload) (*Result, error) {

	start := time.Now() // -- STARTS
	// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	p := strings.NewReader(string(*payload))
	req, err := http.NewRequest(string(method), string(url), p)
	if err != nil {
		return nil, err
	}

	resp, err := (&http.Client{}).Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	elapsed := time.Since(start) // -- ENDS

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	result := CreateResult(&method, &url, resp, &body, elapsed.Seconds())
	return result, nil
}

// func setHeaders(req *http.Request, h *Headers) {
// 	if h != nil {
// 		for key, value := range *h {
// 			req.Header.Set(key, value)
// 		}
// 	}
// }
