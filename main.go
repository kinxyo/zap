package main

import (
	"flag"
	"os"
	"zap/modes/args"
	"zap/modes/config"
	"zap/modes/tui"
	"zap/utils/terminal"
)

func main() {
	args_r := os.Args[1:]

	dev := flag.Bool("dev", false, "Dev flag")

	flag.Parse()

	if len(args_r) <= 0 {
		terminal.Fatal("No args provided.")
	}

	switch args_r[0] {
	case "tui":
		tui.Run()
	case "run":
		config.Run()
	default:
		args.Run(args_r, dev)
	}
}
