package file

// import "fmt"

type TokenType int

const (
	COLLECTION_OPTIONS TokenType = iota // @<option>
	PATH                                // <method> <path>
	MISC                                // expect <expr> || body <expr> || {} || content <type>
	// EXPECT                              // expect <expr>
	// BODY                                // body <expr>
	// PARANTHESIS                         // {}
	// CONTENT                             // content <type>
)

type Token struct {
	Type  TokenType
	Value string
}

func misc(l *Lexer, content []byte, word string) Token {
	var value []byte

	for content[l.pos] != '\n' && l.pos < len(content) {
		value = append(value, content[l.pos])
		l.advance()
	}

	// fmt.Printf("Path Value added: %s\n", string(value))
	return Token{
		Type:  MISC,
		Value: word + string(value),
	}
}

func path(l *Lexer, content []byte, word string) Token {
	var value []byte

	for content[l.pos] != '\n' && l.pos < len(content) {
		value = append(value, content[l.pos])
		l.advance()
	}

	// fmt.Printf("Path Value added: %s\n", string(value))
	return Token{
		Type:  PATH,
		Value: word + string(value),
	}
}

func collection_options(l *Lexer, content []byte) Token {
	var value []byte

	l.advance()

	switch content[l.pos] {
	case 'h':
		// TODO: value = bytes till and including '}'
		for l.pos < len(content) && content[l.pos] != '}' {
			value = append(value, content[l.pos])
			l.advance()
		}
		value = append(value, ('}'))
		l.advance()
	default:
		// TODO: value = bytes till '\n'
		for l.pos < len(content) && content[l.pos] != '\n' {
			value = append(value, content[l.pos])
			l.advance()
		}
	}

	return Token{Type: COLLECTION_OPTIONS, Value: string(value)}
}
