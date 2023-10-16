from std/random import randomize, sample
import std/strutils
import raylib
import word

const
  screenWidth = boxMargin + (boxSize + boxMargin) * wordLimit
  attemptsLimit = 10
  screenHeight = boxMargin + boxSize * (attemptsLimit + 1)
  letters = 'a'.int..'z'.int

echo screenWidth
echo screenHeight

randomize()
let words = readFile("resources/words.txt").splitLines
var
  randomWord = words.sample.toUpper
  userWords = newSeqOfCap[Word](attemptsLimit)
  wordY: int32 = boxMargin
  wordFound = false
  attempt = 0

userWords.add(Word(y: wordY))

proc updateDrawFrame() {.cdecl.} =
  beginDrawing()
  defer: endDrawing()

  # No more problem with keyboard layouts.
  # You can also write the same letter several times by holding it.
  let charPressed = getCharPressed()
  if charPressed in letters and userWords[^1].currentLen != wordLimit:
    userWords[^1].addLetter(charPressed.char.toUpperAscii)

  let key = getKeyPressed()

  if key == KeyboardKey.Backspace and not (wordFound or attempt == attemptsLimit):
    userWords[^1].pop()
  if key == KeyboardKey.Enter or key == KeyboardKey.KpEnter:
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

  clearBackground(RayWhite)

  for i in 0..<wordLimit:
    for j in 0..<attemptsLimit:
      drawRectangleLines(boxMargin + (boxSize + boxMargin) * i.int32, boxMargin + (boxSize + boxMargin) * j.int32, boxSize, boxSize, Black)

  for word in userWords:
    word.draw()

  if wordFound:
    drawRectangle(10, 400, screenWidth - 20, 100, Gray)
    drawText("Congrats!", 15, 420, 50, RayWhite)
  elif attempt == attemptsLimit:
    drawRectangle(10, 400, screenWidth - 20, 100, Gray)
    drawText("You lost...", 15, 420, 50, RayWhite)

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
