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

  var userWords = newSeqOfCap[string](attempts)
  userWords.add(newStringOfCap(wordLimit))

  initWindow(screenWidth, screenHeight, "Nim Wordle")
  defer: closeWindow()

  echo randomWord

  while not windowShouldClose():
    beginDrawing()
    defer: endDrawing()

    # No more problem with keyboard layouts.
    # You can also write the same letter several times by holding it.
    let charPressed = getCharPressed()
    if charPressed in letters and userWords[^1].len != wordLimit:
      userWords[^1].add(charPressed.char.toUpperAscii)

    let key = getKeyPressed()
    case key:
      of Backspace:
        if userWords[^1].len != 0:
          userWords[^1] = userWords[^1][0..^2]
      of Enter, KpEnter:
        if userWords[^1].len == wordLimit:
          userWords.add(newStringOfCap(wordLimit))
      else:
        discard

    clearBackground(RayWhite)

    for i, word in userWords:
      if word.len != 0:
        drawText(word.cstring, 10, 10 + i.int32 * boxSize, boxSize, Black)

# I moved game logic to a main function because defer is not supported at top-level
when isMainModule:
  main()