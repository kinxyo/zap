package terminal

import (
	"flag"
)

type Flags struct {
	Verbose   *bool
	ForceSeq  *bool
	ForceHttp *bool
}

func LoadFlags() *Flags {
	Verbose := flag.Bool("v", false, "verbose")
	ForceSeq := flag.Bool("fs", false, "force to run sequentially")
	ForceHttp := flag.Bool("fh", false, "force http")

	flag.Parse()

	return &Flags{
		Verbose,
		ForceSeq,
		ForceHttp,
	}
}

func LoadArgs() []string {
	return flag.Args()
}
