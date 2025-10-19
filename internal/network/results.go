package network

import (
	"net/http"
	"zap/internal/utils/terminal"
)

/* METHOD */

// ???

/* UTIL */

func PrintResult(
	method *Method,
	url *URL,
	resp *http.Response,
	body *[]byte,
	time float64,
	verbose *bool,
) {
	terminal.Clear()
	terminal.PrintFC(terminal.TextBold, "%s %s\n", *method, *url)
	terminal.PrintF("\t↳ ")

	statusColor := getStatusColor(resp.StatusCode)

	terminal.PrintFC(statusColor, "%s", resp.Status)
	terminal.PrintFC(terminal.TextBold, " | ")
	terminal.PrintFC(terminal.TextDim, "%vs\n", time)

	if *verbose {

		if resp.Header.Get("Content-Type") == "application/json" {
			if len(*body) == 0 {
				terminal.PrintF("\t↳ ")
				terminal.PrintF("(empty response)\n")
				return
			}

			terminal.PrintFC(terminal.TextBlue, "\nOutput:\n")
			terminal.PrintJSON(*body)
		} else {
			terminal.PrintF("\t↳ ")
			terminal.PrintF("%s\n", string(*body))
		}
	}
}

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
