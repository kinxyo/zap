package main

import (
	"zap/internal/cli"
	"zap/internal/file"
	"zap/internal/tui"
	"zap/internal/utils/terminal"
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
//        ⚡Version 0.6 ⚡
//
//  ========================================================================================

func main() {
	flags := terminal.LoadFlags()
	args := terminal.LoadArgs()

	// No args
	if len(args) == 0 {
		tui.Run()
		return
	}

	// 1st arg "run"
	if args[0] == "run" {
		file.Run(args, flags)
		return
	}

	// Anything else (No arg case already handled!)
	cli.Run(args, flags)
}
