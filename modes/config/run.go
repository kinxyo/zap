package config

import (
	"sync"
	"zap/network"
	"zap/pkg/terminal"
)

const (
	CONFIG_NAME string = "zap.json"
	HOST        string = "127.0.0.1"
)

func Run(flags *terminal.ConfigFlags) {
	terminal.Clear()

	var counter sync.WaitGroup

	var z Config
	loadConfig(&z, *flags.Verbose)

	for _, api := range z.Apis {
		var p Prepare

		makeURL(&p, HOST, z.Port, api.Path)
		makeHeaders(&p, z.Auth, api.Headers)

		counter.Add(1)
		go network.Request_CONCURRENT(&counter, p.Method, p.URL, p.Headers)
	}

	counter.Wait()
}
