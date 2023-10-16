from std/random import randomize, sample
import std/strutils
import raylib
import word

const
  screenWidth = boxMargin + (boxSize + boxMargin) * wordLimit
  attemptsLimit = 6
  screenHeight = boxMargin + (boxSize + boxMargin) * attemptsLimit
  letters = 'a'.int..'z'.int

randomize()

let words = readFile("resources/words.txt").splitLines
var
  randomWord = words.sample.toUpper
  userWords = newSeqOfCap[Word](attemptsLimit)
  wordY: int32 = boxMargin
  wordFound = false
  attempt = 0

userWords.add(Word(y: wordY))

proc drawNotification(text: cstring) =
  drawRectangle(10, screenHeight - boxSize * 2 - boxMargin * 2, screenWidth - boxMargin * 4, 50 + boxMargin * 2, Gray)
  drawText(text, 15, screenHeight - boxSize * 2 - boxMargin, 50, RayWhite)

proc draw() =
  beginDrawing()
  defer: endDrawing()

  clearBackground(RayWhite)

  for i in 0..<wordLimit:
    for j in 0..<attemptsLimit:
      drawRectangleLines(boxMargin + (boxSize + boxMargin) * i.int32, boxMargin + (boxSize + boxMargin) * j.int32, boxSize, boxSize, Black)

  for word in userWords:
    word.draw()

  if wordFound:
    drawNotification("Congrats!")
  elif attempt == attemptsLimit:
    drawNotification("You lost...")

proc updateDrawFrame() {.cdecl.} =
  # No more problem with keyboard layouts.
  # You can also write the same letter several times by holding it.
  let charPressed = getCharPressed()
  if charPressed in letters and userWords[^1].currentLen != wordLimit:
    userWords[^1].addLetter(charPressed.char.toUpperAscii)

  let key = getKeyPressed()

  if key == KeyboardKey.Backspace and not (wordFound or attempt == attemptsLimit):
    userWords[^1].pop()
  if key != KeyboardKey.Enter and key != KeyboardKey.KpEnter:
    draw()
    return

  if wordFound or attempt == attemptsLimit:
    wordY = boxMargin
    userWords = @[Word(y: wordY)]
    randomWord = words.sample.toUpper
    wordFound = false
    attempt = 0
  elif userWords[^1].currentLen == wordLimit and userWords[^1].getString.toLower in words:
    userWords[^1].updateColors(randomWord)
    inc attempt

    if userWords[^1].isCorrect:
      wordFound = true
    elif attempt != attemptsLimit:
      wordY += boxSize + boxMargin
      userWords.add(Word(y: wordY))
  
  draw()

proc main() =
  initWindow(screenWidth, screenHeight, "Nim Wordle")
  defer: closeWindow()

  echo randomWord

  when defined(emscripten):
    emscriptenSetMainLoop(updateDrawFrame, 0, 1)
  else:
    while not windowShouldClose():
      updateDrawFrame()

# I moved game logic to a main function because defer is not supported at top-level
when isMainModule:
  main()
