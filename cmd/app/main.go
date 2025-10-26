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
//        ⚡Version 0.5 ⚡
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

/*

TODO:

	0) DONE
	if url provides https or http, use it.

	1) DONE
	stderr metadata and logs
	stdout body response

	2) DONE
	use json.Valid instead of checking header.
	add a flag for non-pretty-json

	3)
	add payload for post in cli
	while you're at it, add headers for requests in cli

	4)
	finish file parser OR tui

	5)
	whichever if left

*/
