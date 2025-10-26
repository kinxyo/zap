package terminal

import (
	"flag"
)

type Flags struct {
	Verbose     *bool
	PrintURL    *bool
	PrintTime   *bool
	PrintStatus *bool
	NoFormat    *bool
	ForceSeq    *bool
	ForceHttp   *bool
}

func LoadFlags() *Flags {
	Verbose := flag.Bool("v", false, "logging all meta info to terminal")
	PrintURL := flag.Bool("u", false, "log url to terminal")
	PrintTime := flag.Bool("t", false, "log time to terminal")
	PrintStatus := flag.Bool("s", false, "log status to terminal")
	NoFormat := flag.Bool("n", false, "No pretty json")
	ForceSeq := flag.Bool("q", false, "force to run sequentially")
	ForceHttp := flag.Bool("h", false, "force http")

	flag.Parse()

	return &Flags{
		Verbose,
		PrintURL,
		PrintTime,
		PrintStatus,
		NoFormat,
		ForceSeq,
		ForceHttp,
	}
}

func LoadArgs() []string {
	return flag.Args()
}
