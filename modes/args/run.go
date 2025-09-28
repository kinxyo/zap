package args

import "zap/network"

func Run(args_raw []string, dev *bool) {
	args := New(args_raw, dev)

	url := args.URL()

	network.Request(args.Method, url)
}
