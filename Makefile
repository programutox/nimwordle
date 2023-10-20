# this command must be executed before release one, since emscripten needs the executable
default:
	nim c -r --hints:off src/main.nim

check:
	nim check --hints:off src/main.nim

release:
	mkdir web
	cp index.html web/index.html
	nim c -r -d:emscripten src/main.nim

clean:
	rm -f nimwordle
	rm -rf web
