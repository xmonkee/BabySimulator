NAME="BabySimulator"
alone?=0
all: tic web win mac

tic: build/${NAME}.tic
web: build/${NAME}.zip
win: build/${NAME}.exe
mac: build/${NAME}.app

build/${NAME}.lua: *.lua
	mkdir -p build
	python3 combine.py main.lua > build/${NAME}.lua

build/${NAME}.tic: build/${NAME}.lua
	rm -f ./build/${NAME}.tic
	tic80 --cli --fs ./build --cmd="load ${NAME}.lua & save ${NAME}.tic"

build/${NAME}.zip: build/${NAME}.lua
	tic80 --cli --fs ./build --cmd="load ${NAME}.lua & export html ${NAME}.zip --alone=${alone}"

build/${NAME}.exe: build/${NAME}.lua
	tic80 --cli --fs ./build --cmd="load ${NAME}.lua & export win ${NAME}.exe --alone=${alone}"

build/${NAME}.app: build/${NAME}.lua
	tic80 --cli --fs ./build --cmd="load ${NAME}.lua & export mac ${NAME}.app --alone=${alone}"

clean:
	rm -r build/

.PHONY: clean
