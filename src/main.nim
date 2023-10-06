import std/[random, strutils]
import raylib

const
  screenWidth = 600
  screenHeight = 400

proc main() =
  randomize()

  let words = readFile("assets/words.txt").splitLines
  let randomWord = words.sample.cstring

  initWindow(screenWidth, screenHeight, "Nim Wordle")
  defer: closeWindow()

  while not windowShouldClose():
    beginDrawing()
    defer: endDrawing()

    clearBackground(RayWhite)
    drawText(randomWord, 250, 10, 30, Black)

# I moved game logic to a main function because defer is not supported at top-level
when isMainModule:
  main()