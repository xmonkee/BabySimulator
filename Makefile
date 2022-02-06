all: build/combined.tic

build/combined.lua: *.lua
	mkdir -p build
	python3 combine.py main.lua > build/combined.lua

build/combined.tic: build/combined.lua
	rm -f ./build/combined.tic
	tic80 --cli --fs ./build --cmd="load combined.lua & save combined.tic"

clean:
	rm -r build/

.PHONY: clean
