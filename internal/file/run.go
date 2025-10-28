package file

import (
	"os"
	"zap/internal/utils/terminal"
)

func Run(args []string, flags *terminal.Flags) {
	var testFile string
	var content []byte
	var err error

	if len(args) >= 2 {
		testFile = args[1]
	} else {
		testFile = GetTestFileName()
	}

	content, err = os.ReadFile(testFile)
	if err != nil {
		terminal.Fatal("%v\n", err)
	}

	lexer := NewLexer()
	lexer.Run(content)
	lexer.Print()
}
