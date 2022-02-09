NAME="BabySimulator"
alone?=0
all: pages

tic: build/${NAME}.tic
web: build/${NAME}.zip
win: build/${NAME}.exe
mac: build/${NAME}.app
pages: docs/index.html

build/${NAME}.lua: *.lua
	mkdir -p build
	python3 combine.py main.lua > build/${NAME}.lua

build/${NAME}.tic: build/${NAME}.lua
	rm -f ./build/${NAME}.tic
	tic80 --cli --fs ./build --cmd="load ${NAME}.lua & save ${NAME}.tic"

build/${NAME}.zip: build/${NAME}.tic
	tic80 --cli --fs ./build --cmd="load ${NAME}.tic & export html ${NAME}.zip --alone=${alone}"

build/${NAME}.exe: build/${NAME}.tic
	tic80 --cli --fs ./build --cmd="load ${NAME}.tic & export win ${NAME}.exe --alone=${alone}"

build/${NAME}.app: build/${NAME}.tic
	tic80 --cli --fs ./build --cmd="load ${NAME}.tic & export mac ${NAME}.app --alone=${alone}"

docs/index.html: web
	mkdir -p docs
	unzip build/${NAME}.zip -d docs/

clean:
	rm -r build/

.PHONY: clean
