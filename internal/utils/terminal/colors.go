package terminal

import (
	"fmt"
	"io"
)

type TextFmt string

const (
	Reset       TextFmt = "\x1b[0m"
	TextRed     TextFmt = "\x1b[31m"
	TextGreen   TextFmt = "\x1b[32m"
	TextYellow  TextFmt = "\x1b[33m"
	TextBlue    TextFmt = "\x1b[34m"
	TextMagenta TextFmt = "\x1b[35m"
	TextCyan    TextFmt = "\x1b[36m"
	TextBold    TextFmt = "\x1b[1m"
	TextDim     TextFmt = "\x1b[2m"
)

func colorFmt(std io.Writer, color TextFmt, format string, a ...any) {
	fmt.Fprintf(std, string(color)+format+string(Reset), a...)
}
