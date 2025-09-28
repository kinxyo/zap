package terminal

import (
	"fmt"
	"os"
)

func Clear() {
	fmt.Print("\x1b[2J\x1b[H")
}

func Print(a ...any) {
	fmt.Fprintln(os.Stdout, a...)
}

func Err(a ...any) {
	fmt.Fprintln(os.Stderr, a...)
}

func Fatal(a ...any) {
	fmt.Fprintln(os.Stderr, a...)
	os.Exit(1)
}
