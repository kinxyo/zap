package config

import (
	"encoding/json"
	"fmt"
	"maps"
	"os"
	"strings"
	"time"
	"zap/network"
	"zap/pkg/terminal"
)

type API struct {
	Path      string          `json:"path"`
	Protected bool            `json:"protected"`
	Headers   *network.Header `json:"headers"`
}

type Config struct {
	Name string          `json:"name"`
	Port uint16          `json:"port"`
	Auth *network.Header `json:"auth"`
	Apis []API           `json:"apis"`
}

type Prepare struct {
	Method  string
	URL     string
	Headers network.Header
}

func loadConfig(z *Config, verbose bool) {
	contents, err := os.ReadFile(CONFIG_NAME)
	if err != nil {
		terminal.Fatal(err)
	}

	if verbose {
		terminal.PrintJSON(contents)
		time.Sleep(2 * time.Second)
		terminal.Clear()
	}

	err = json.Unmarshal(contents, &z)
	if err != nil {
		terminal.Fatal(err)
	}
}

func makeURL(p *Prepare, HOST string, port uint16, api string) {
	var api_substrings []string = strings.SplitN(api, " ", 2)

	raw_method := api_substrings[0]
	raw_path := api_substrings[1]

	p.Method = network.Method(raw_method)

	if p.Method == network.INVALID_METHOD {
		terminal.Err("Invalid method for API:", api)
		p.Method = "GET"
	}

	if strings.HasPrefix(raw_path, "/") {
		p.URL = fmt.Sprintf("http://%s:%d%s", HOST, port, raw_path)
	} else {
		p.URL = raw_path
	}
}

func makeHeaders(p *Prepare, auth *network.Header, headers *network.Header) {
	if p.Headers == nil {
		p.Headers = make(network.Header)
	}

	if auth != nil {
		maps.Copy(p.Headers, *auth)
	}

	if headers != nil {
		maps.Copy(p.Headers, *headers)
	}

	if p.Headers["Content-Type"] == "" {
		p.Headers["Content-Type"] = "application/json"
	}
}
