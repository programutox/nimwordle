import std/[random, strutils]
import raylib

const
  boxSize = 50
  wordLimit = 5
  screenWidth = boxSize * (wordLimit - 1)
  attempts = 10
  screenHeight = boxSize * (attempts + 1)
  letters = 'a'.int..'z'.int

proc main() =
  randomize()

  let words = readFile("assets/words.txt").splitLines
  let randomWord = words.sample.toUpper.cstring

  var userInput = newStringOfCap(wordLimit)

  initWindow(screenWidth, screenHeight, "Nim Wordle")
  defer: closeWindow()

  echo randomWord

  while not windowShouldClose():
    beginDrawing()
    defer: endDrawing()

    # No more problem with keyboard layouts.
    # You can also write the same letter several times by holding it.
    let key = getCharPressed()
    if key in letters and userInput.len != wordLimit:
      userInput.add(key.char.toUpperAscii)

    if isKeyPressed(KeyboardKey.Backspace) and userInput.len != 0:
      userInput = if isKeyDown(KeyboardKey.LeftControl):
        ""
      else:
        userInput[0..^2]

    clearBackground(RayWhite)

    if userInput.len != 0:
      drawText(userInput.cstring, 10, 10, boxSize, Black)

# I moved game logic to a main function because defer is not supported at top-level
when isMainModule:
  main()