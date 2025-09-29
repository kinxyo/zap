install:
	go build -o zap .
	mkdir -p ~/bin
	rm -f ~/bin/zap
	mv ./zap ~/bin/
