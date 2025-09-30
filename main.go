package main

import (
	"zap/modes/cli"
	"zap/modes/config"
	"zap/modes/tui"
	"zap/pkg/terminal"
)

//  ========================================================================================
//
//      $$$$$$$$\ $$$$$$\   $$$$$$\
//      \____$$  |\____$$\ $$  __$$\
//        $$$$ _/ $$$$$$$ |$$ /  $$ |
//       $$  _/  $$  __$$ |$$ |  $$ |
//      $$$$$$$$\\$$$$$$$ |$$$$$$$  |
//      \________|\_______|$$  ____/
//                         $$ |
//                         $$ |
//                         \__|
//
//        ⚡Version 0.2 ⚡
//
// Description: A high-performance API testing tool and `curl` replacement built for speed and simplicity.
// Issues & Contributions: https://github.com/kinxyo/zap
// Contact: Kinjalk Tripathi (amblers26.splay@icloud.com)
//
//  ========================================================================================

func main() {
	flags := terminal.LoadFlags()
	args := terminal.LoadArgs()

	if len(args) <= 0 {
		terminal.Err("No args provided.")
		return
	}

	switch args[0] {
	case "tui":
		tui.Run()
	case "run":
		config.Run(flags.Config)
	default:
		cli.Run(args, flags.Args)
	}
}
