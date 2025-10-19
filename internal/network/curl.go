package network

import (
	"io"
	"net/http"
	"time"
)

func Curl(method Method, url URL, headers *Headers, verbose bool) error {

	start := time.Now() // -- STARTS

	req, err := http.NewRequest(string(method), string(url), nil)
	if err != nil {
		return err
	}

	if headers != nil {
		for key, value := range *headers {
			req.Header.Set(key, value)
		}
	}

	resp, err := (&http.Client{}).Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	elapsed := time.Since(start) // -- ENDS

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return err
	}

	PrintResult(&method, &url, resp, &body, elapsed.Seconds(), &verbose)
	return nil
}
