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

func Run(args []string, flags *terminal.ConfigFlags) {
	terminal.Clear()

	var name string = CONFIG_NAME
	var log_Mode = "MODE: Sequential (Auto)"

	if len(args) >= 2 {
		name = args[1]
	}

	var z Config
	err := loadConfig(&z, *flags.Verbose, name)
	if err != nil {
		terminal.Fatal(err)
	}

	boolean := len(z.Apis) > 1

	if *flags.ForceSeq {
		boolean = false
		log_Mode = "MODE: Sequential (Force)"
	}

	if boolean {
		log_Mode = "MODE: Concurrent"
		terminal.PrintLn(log_Mode)
		batch(&z)
		return
	}

	terminal.PrintLn(log_Mode)
	for _, api := range z.Apis {
		var p Prepare

		makeURL(&p, HOST, z.Port, api.Path)
		makeHeaders(&p, z.Auth, api.Headers)

		network.Request(p.Method, p.URL, p.Headers, nil)
	}
}

func batch(z *Config) {
	var counter sync.WaitGroup
	for _, api := range z.Apis {
		var p Prepare

		makeURL(&p, HOST, z.Port, api.Path)
		makeHeaders(&p, z.Auth, api.Headers)

		counter.Add(1)
		network.Request_CONCURRENT(&counter, p.Method, p.URL, p.Headers)
	}
	counter.Wait()
}
