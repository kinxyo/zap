package cli

func extract(args []string) (string, string) {

	// TODO: headers := parseHeaders(args)
	// TODO: query := parseHeaders(args)
	// TODO: params := parseHeaders(args)

	switch len(args) {
	case 1:
		// zap <url>
		return "GET", args[0]
	default:
		// zap get <url>
		return args[0], args[1]
	}
}
