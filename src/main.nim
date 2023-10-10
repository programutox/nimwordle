import std/[random, strutils]
import raylib
import word

const
  screenWidth = (boxSize + boxMargin) * wordLimit
  attempts = 10
  screenHeight = boxSize * (attempts + 1)
  letters = 'a'.int..'z'.int

proc main() =
  randomize()

  let words = readFile("assets/words.txt").splitLines
  let randomWord = words.sample.toUpper.cstring

  var
    userWords = newSeqOfCap[Word](attempts)
    wordY: int32 = 10
  userWords.add(Word(y: wordY))

  initWindow(screenWidth, screenHeight, "Nim Wordle")
  defer: closeWindow()

  echo randomWord

  while not windowShouldClose():
    beginDrawing()
    defer: endDrawing()

    # No more problem with keyboard layouts.
    # You can also write the same letter several times by holding it.
    let charPressed = getCharPressed()
    if charPressed in letters and userWords[^1].currentLen != wordLimit:
      userWords[^1].addLetter(charPressed.char.toUpperAscii)

    let key = getKeyPressed()
    case key:
      of Backspace:
        userWords[^1].pop()
      of Enter, KpEnter:
        if userWords[^1].currentLen == wordLimit:
          wordY += boxSize
          userWords.add(Word(y: wordY))
      else:
        discard

    clearBackground(RayWhite)

    for word in userWords:
      word.draw()

# I moved game logic to a main function because defer is not supported at top-level
when isMainModule:
  main()