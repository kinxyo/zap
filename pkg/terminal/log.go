package terminal

import (
	"bytes"
	"encoding/json"
	"fmt"
	"os"
)

func Clear() {
	fmt.Print("\x1b[2J\x1b[H")
}

func PrintLn(a ...any) {
	fmt.Fprintln(os.Stdout, a...)
}

func PrintF(format string, a ...any) {
	fmt.Fprintf(os.Stdout, format, a...)
}

func Err(a ...any) {
	fmt.Fprintln(os.Stderr, a...)
}

func Fatal(a ...any) {
	fmt.Fprintln(os.Stderr, a...)
	os.Exit(1)
}

func PrintJSON(body []byte) {
	var prettyJSON bytes.Buffer

	err := json.Indent(&prettyJSON, body, "", "  ")
	if err != nil {
		PrintLn(string(body))
	}

	PrintLn(prettyJSON.String())
}
