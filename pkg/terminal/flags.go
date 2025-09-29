package terminal

import (
	"flag"
)

type ArgFlags struct {
	Dev *bool
}

type ConfigFlags struct {
	Verbose *bool
}

type TUIFlags struct{}

type ZapFlags struct {
	Args   *ArgFlags
	Config *ConfigFlags
	TUI    *TUIFlags
}

func LoadFlags() *ZapFlags {

	//Flags (ARGS)
	AF := &ArgFlags{
		Dev: flag.Bool("d", false, "enable dev options"),
	}

	//Flags (CONFIG)
	CF := &ConfigFlags{
		Verbose: flag.Bool("v", false, "verbose"),
	}

	//Flags (TUI)
	TF := &TUIFlags{}

	flag.Parse()

	return &ZapFlags{
		Args:   AF,
		Config: CF,
		TUI:    TF,
	}
}

func LoadArgs() []string {
	return flag.Args()
}
