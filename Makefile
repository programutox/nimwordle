default:
	nim c -r --hints:off -o:nimwordle src/main.nim

release:
	mkdir web
	cp index.html web/index.html
	nim c -r -d:emscripten src/main.nim

clean:
	rm -f nimwordle
	rm -rf web
