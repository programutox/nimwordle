from std/random import randomize
import raylib
import state
import gamestate

# Seeds the random number generator, needs to be called (once),
# otherwise you get the same seed over and over
randomize()

var states = newSeq[State]()
states.add(initGameState())

proc updateDrawFrame() {.cdecl.} =
  states[^1].update()

  beginDrawing()
  clearBackground(RayWhite)
  states[^1].draw()
  endDrawing()

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
