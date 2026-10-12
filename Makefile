.PHONY: all build run clean package

all: package

build:
	swift build

package:
	bash Scripts/build_app.sh

run:
	open Dot.app

clean:
	swift package clean
	rm -rf Dot.app
