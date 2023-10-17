from std/random import randomize
import raylib
import gamestate

randomize()
var game = initGameState()

proc updateDrawFrame() {.cdecl.} =
  game.update()
  game.draw()

proc main() =
  initWindow(screenWidth, screenHeight, "Nim Wordle")
  defer: closeWindow()

  when defined(emscripten):
    emscriptenSetMainLoop(updateDrawFrame, 0, 1)
  else:
    while not windowShouldClose():
      updateDrawFrame()

# I moved game logic to a main function because defer is not supported at top-level
when isMainModule:
  main()
