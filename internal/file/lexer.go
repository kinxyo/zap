package file

import (
	"zap/internal/utils/terminal"
)

func Main() {}

type Lexer struct {
	tokens []Token
	pos    int
}

func NewLexer() *Lexer {
	return &Lexer{
		tokens: make([]Token, 0),
		pos:    0,
	}
}

func (l *Lexer) add_token(t Token) {
	l.tokens = append(l.tokens, t)
}

func (l *Lexer) advance() {
	l.pos++
}

func (l *Lexer) Run(content []byte) {

	for l.pos < len(content) {
		switch content[l.pos] {
		case '@':
			token := collection_options(l, content)
			l.add_token(token)
		case '\n', ' ':
			l.advance()
		default:
			// terminal.PrintF("%d) %c\n", l.pos, content[l.pos])
			word := getWord(l, content)
			lex(l, content, word)
			// l.advance()
		}
	}
}

func lex(l *Lexer, content []byte, word string) {
	switch word {
	case "GET", "POST", "PUT", "PATCH", "DELETE":
		token := path(l, content, word)
		l.add_token(token)
	case "expect", "body", "content":
		token := misc(l, content, word)
		l.add_token(token)
	default:
		l.advance()
	}
}

func (l *Lexer) Print() {
	iter := 0
	// terminal.PrintF("%v\n", l.tokens)
	for iter < len(l.tokens) {
		// terminal.PrintF("%d/%d -- \"%v\"\n", iter, len(l.tokens), l.tokens[iter].Value)
		if l.tokens[iter].Type == COLLECTION_OPTIONS {
			terminal.PrintF("@%s\n", l.tokens[iter].Value)
		} else {
			terminal.PrintF("%s\n", l.tokens[iter].Value)
		}
		iter++
	}
}
