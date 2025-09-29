package args

import (
	"zap/network"
	"zap/pkg/terminal"
)

func Run(args_raw []string, flags *terminal.ArgFlags) {
	args := New(args_raw, flags.Dev)

	url := args.URL()

	network.Request(args.Method, url, nil)
}
