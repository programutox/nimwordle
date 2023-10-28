default:
	nim r --hints:off src/main.nim

check:
	nim check --hints:off src/main.nim

release:
	mkdir web
	cp index.html web/index.html
	nim c --hints:off src/main.nim
	nim c -d:emscripten -d:release src/main.nim

clean:
	rm -f src/main
	rm -rf web
