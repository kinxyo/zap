package args

import (
	"fmt"
	"strings"
	"zap/network"
	"zap/pkg/terminal"
)

type Args struct {
	Method string
	Path   string
	Dev    *bool
}

func New(args_raw []string, dev *bool) *Args {
	// Example:
	// 1. zap get <url>
	// 2. zap <url>

	// 1st ARGUMENT
	first := args_raw[0]
	method := network.Method(first)
	if method == network.INVALID_METHOD {
		return &Args{
			Method: "GET",
			Path:   first,
			Dev:    dev,
		}
	}

	// 2nd ARGUMENT
	if len(args_raw) < 2 {
		terminal.Fatal("Wrong arguments.")
	}
	second := args_raw[1]
	return &Args{
		Method: method,
		Path:   second,
		Dev:    dev,
	}
}

func (args *Args) URL() string {
	// Example:
	// 1. zap /api/users (local)
	// 2. zap httpbin.org/json (global)
	// 2. zap -d httpbin.org/json (global without https)

	if strings.HasPrefix(args.Path, "/") {
		return fmt.Sprintf("http://%s%s%s", getHost(), getAddr(), args.Path)
	}

	if *args.Dev {
		return fmt.Sprintf("http://%s", args.Path)
	}

	return fmt.Sprintf("https://%s", args.Path)
}

func getHost() string {
	//TODO: Fetch from "quick-config" file if it exists
	return "127.0.0.1"
}
func getAddr() string {
	//TODO: Fetch from "quick-config" file if it exists
	return ":8000"
}
