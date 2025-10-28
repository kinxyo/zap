package file

func GetTestFileName() string {
	// TODO: return config name
	return "example/test.zap"
}

func getWord(l *Lexer, content []byte) string {
	var value []byte

	for l.pos < len(content) && content[l.pos] != ' ' {
		value = append(value, content[l.pos])
		l.advance()
	}

	// println("word gotten:", string(value))
	return string(value)
}
