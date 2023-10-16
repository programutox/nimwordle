default:
	nim c -r --hints:off src/*.nim

release:
	mkdir web
	cp index.html web/index.html
	nim c -r -d:emscripten src/*.nim

clean:
	rm -f src/main
	rm -rf web
