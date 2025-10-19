package network

import (
	"net/http"
	"time"
)

type Method string
type URL string

type Headers map[string]string

type Collection struct {
	client     *http.Client
	api        []API
	gl_headers *Headers
}

type API struct {
	Method  string
	URL     string
	Headers *Headers
}

type Result struct {
	Method Method
	URL    URL
	Status string
	Body   string
	Time   time.Duration
}
