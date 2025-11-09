run:
	zig build
	@$(MAKE) install

prod:
	zig build -Doptimize=ReleaseFast
	@$(MAKE) install

install:
	rm -f ~/bin/zigzap
	mv ./zig-out/bin/zigzap ~/bin/zigzap
