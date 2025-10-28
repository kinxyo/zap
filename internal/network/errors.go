package network

const ERR_INVALID_METHOD string = "INVALID_METHOD"

type NetworkError struct {
	Message string
}

func (n *NetworkError) Error() string {
	return n.Message
}
