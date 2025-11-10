run:
	zig build
	@$(MAKE) install

prod:
	zig build -Doptimize=ReleaseFast
	@$(MAKE) install

install:
	# Make sure to add `export PATH="$HOME/bin:$PATH"` to be able to use it from anywhere.
	mkdir -p ~/bin
	rm -f ~/bin/zap
	mv ./zig-out/bin/zap ~/bin/zap
