package network

import (
	"fmt"
	"strings"
	"zap/internal/utils/terminal"
)

func ParseMethod(m string) Method {
	m = strings.ToLower(m)
	m = strings.TrimSpace(m)

	switch m {
	case "get", "g":
		return "GET"
	case "post", "p", "po":
		return "POST"
	case "put", "pu":
		return "PUT"
	case "patch", "pa":
		return "PATCH"
	case "delete", "d":
		return "DELETE"
	default:
		terminal.Err("%v: `%s`\n", ERR_INVALID_METHOD, m)
		if len(m) >= 1 && m[0] == '/' {
			terminal.PrintFC(terminal.TextYellow, "Hint: If using flags, add them before the arg(s).\n")
		}
		terminal.Exit()
		return ""
	}
}

func ParseURL(path string, force_http bool) URL {
	str := makeurl(path, force_http)
	return fromStrToUrl(str)
}

func makeurl(path string, force_http bool) string {
	// Example:
	// 1. zap /api/users (local)
	// 2. zap httpbin.org/json (global)
	// 3. zap -d httpbin.org/json (global without https)

	if strings.HasPrefix(path, "/") {
		return fmt.Sprintf("http://%s%s%s", getHost(), getAddr(), path)
	}

	if force_http {
		return fmt.Sprintf("http://%s", path)
	}

	if strings.HasPrefix(path, "http://") || strings.HasPrefix(path, "https://") {
		return fmt.Sprintf("%s", path)
	}

	return fmt.Sprintf("https://%s", path)
}

func fromStrToUrl(url string) URL {
	return URL(url)
}
