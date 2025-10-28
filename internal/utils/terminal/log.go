package terminal

import (
	"fmt"
	"os"
)

func Exit() {
	os.Exit(1)
}

func Clear() {
	fmt.Print("\x1b[2J\x1b[H")
}

// Log -- Format
func LogF(format string, a ...any) {
	fmt.Fprintf(os.Stderr, format, a...)
}

// Log -- Format & Color
func LogFC(color TextFmt, format string, a ...any) {
	colorFmt(os.Stderr, color, format, a...)
}

// Log -- NewLine
func Log(a ...any) {
	fmt.Fprintln(os.Stderr, a...)
}
