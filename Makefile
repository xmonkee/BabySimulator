NAME="BabySimulator"
all: build/${NAME}.tic build/${NAME}.zip

build/${NAME}.lua: *.lua
	mkdir -p build
	python3 combine.py main.lua > build/${NAME}.lua

build/${NAME}.tic: build/${NAME}.lua
	rm -f ./build/${NAME}.tic
	tic80 --cli --fs ./build --cmd="load ${NAME}.lua & save ${NAME}.tic"

build/${NAME}.zip: build/${NAME}.lua
	tic80 --cli --fs ./build --cmd="load ${NAME}.lua & export html ${NAME}.zip"

clean:
	rm -r build/

.PHONY: clean
