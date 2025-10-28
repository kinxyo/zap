package network

import (
	"net/http"
)

type Method string
type URL string
type Payload string

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
	Method *Method
	URL    *URL
	Resp   *http.Response
	Body   *[]byte
	Time   float64
}
