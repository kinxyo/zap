package network

import (
	"encoding/json"
	"net/http"
	"zap/internal/utils/terminal"
)

func CreateResult(
	Method *Method,
	Url *URL,
	Resp *http.Response,
	Body *[]byte,
	Time float64,
) *Result {
	return &Result{
		Method,
		Url,
		Resp,
		Body,
		Time,
	}
}

/* METHODS */

func (r *Result) Print(printTime bool, printURL bool, printStatus bool, noFormat bool) {
	if printURL {
		terminal.LogFC(terminal.TextBold, "%s %s\n", *r.Method, *r.URL)
	}

	if printTime {
		terminal.LogFC(terminal.TextDim, "Time: %vs\n", r.Time)
	}

	if printStatus {
		statusColor := getStatusColor(r.Resp.StatusCode)
		terminal.LogFC(statusColor, "%s\n", r.Resp.Status)
	}

	if noFormat {
		terminal.Print(string(*(r.Body)))
	} else {
		printBody(r.Body)
	}
}

/* HELPERS */

func getStatusColor(statusCode int) terminal.TextFmt {
	switch {
	case statusCode >= 200 && statusCode < 300:
		return terminal.TextGreen
	case statusCode >= 300 && statusCode < 400:
		return terminal.TextCyan
	case statusCode >= 400 && statusCode < 500:
		return terminal.TextYellow
	case statusCode >= 500:
		return terminal.TextRed
	default:
		return terminal.Reset
	}
}

func printBody(body *[]byte) {
	if json.Valid(*body) {
		terminal.Log()
		terminal.PrintJSON(*body)
	} else {
		terminal.PrintF("%s\n", string(*body))
	}
}
