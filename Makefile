install:
	go build -o zap ./cmd/app/main.go
	mkdir -p ~/bin
	rm -f ~/bin/zap
	mv ./zap ~/bin/

run:
	go run ./cmd/app/main.go
