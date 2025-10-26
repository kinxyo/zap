package terminal

import (
	"bytes"
	"encoding/json"
	"fmt"
	"os"
)

// Print -- Format
func PrintF(format string, a ...any) {
	fmt.Fprintf(os.Stdout, format, a...)
}

// Print -- Format & Color
func PrintFC(color TextFmt, format string, a ...any) {
	colorFmt(os.Stdout, color, format, a...)
}

// Print -- NewLine
func Print(a ...any) {
	fmt.Fprintln(os.Stdout, a...)
}

// Print -- JSON (pretty)
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
