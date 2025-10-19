package cli

import (
	"zap/internal/network"
	"zap/internal/utils/terminal"
)

func Run(args []string, flags *terminal.Flags) {

	var m, p string = extract(args)

	var method network.Method = network.ParseMethod(m)
	var url network.URL = network.ParseURL(p, *flags.ForceHttp)

	if err := network.Curl(method, url, nil, *flags.Verbose); err != nil {
		terminal.Fatal("%s\n", err)
	}

}
