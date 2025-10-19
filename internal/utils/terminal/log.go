package terminal

import (
	"bytes"
	"encoding/json"
	"fmt"
	"os"
)

func Exit() {
	os.Exit(1)
}

func Clear() {
	fmt.Print("\x1b[2J\x1b[H")
}

func PrintF(format string, a ...any) {
	fmt.Fprintf(os.Stdout, format, a...)
}

func PrintFC(color TextFmt, format string, a ...any) {
	colorFmt(os.Stdout, color, format, a...)
}

func Print(a ...any) {
	fmt.Fprintln(os.Stdout, a...)
}

func Err(format string, a ...any) {
	colorFmt(os.Stderr, TextRed, format, a...)
}

func Fatal(format string, a ...any) {
	Err(format, a...)
	Exit()
}

// `Panic()` is not meant for production use;
// It's more of a placeholder for adding error handling later.
func Panic(a ...any) {
	fmt.Fprintln(os.Stderr, a...)
	Exit()
}

func PrintJSON(body []byte) {
	var prettyJSON bytes.Buffer

	err := json.Indent(&prettyJSON, body, "", "  ")
	if err != nil {
		Err("Failed to prettyify the json: %v\n", err)
		PrintFC(TextYellow, "Falling back to plain text.\n")
		Print(string(body))
		return
	}

	Print(prettyJSON.String())
}
