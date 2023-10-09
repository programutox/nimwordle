import std/[random, strutils]
import raylib

const
  boxSize = 50
  wordLimit = 5
  screenWidth = boxSize * (wordLimit - 1)
  attempts = 10
  screenHeight = boxSize * (attempts + 1)

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

    # TODO: Replace getKeyPressed() by isKeyPressed(the_key), to avoid issue with keyboard layout
    let key = getKeyPressed()
    case key:
      of KeyboardKey.A..KeyboardKey.Z:
        if userInput.len != wordLimit:
          userInput.add(key.ord.char)
      of KeyboardKey.Backspace:
        if userInput.len != 0:
          userInput = userInput[0..^2]
      of KeyboardKey.Enter:
        discard
      else:
        discard

    clearBackground(RayWhite)
    drawText(userInput.cstring, 10, 10, boxSize, Black)

# I moved game logic to a main function because defer is not supported at top-level
when isMainModule:
  main()