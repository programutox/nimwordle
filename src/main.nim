from std/random import randomize
import raylib
import state
import tutorialstate
from gamestate import screenWidth, screenHeight

# Seeds the random number generator, needs to be called (once),
# otherwise you get the same seed over and over
randomize()

# Window has to be initialized before loading any texture, sound, etc.
initWindow(screenWidth, screenHeight, "Nim Wordle")

var states = newSeq[State]()
states.add(initTutorialState())

proc updateDrawFrame() {.cdecl.} =
  states[^1].update(states)

  beginDrawing()
  clearBackground(RayWhite)
  states[^1].draw()
  endDrawing()

# States need to be freed before the window is closed
# Since after window close you cannot handle texture memory
proc closeResources() =
  states = @[]
  closeWindow()

proc main() =
  defer: closeResources()

  when defined(emscripten):
    emscriptenSetMainLoop(updateDrawFrame, 0, 1)
  else:
    while not windowShouldClose():
      updateDrawFrame()

# I moved game logic to a main function because defer is not supported at top-level
when isMainModule:
  main()
