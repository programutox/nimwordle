from std/random import sample
import std/strutils
import raylib
import word
import state

const
  screenWidth* = boxMargin + (boxSize + boxMargin) * wordLimit
  attemptsLimit = 6
  screenHeight* = boxMargin + (boxSize + boxMargin) * attemptsLimit
  letters = 'a'.int..'z'.int

type GameState* = ref object of State
  words: seq[string]
  randomWord: string
  userWords: seq[Word] = newSeqOfCap[Word](attemptsLimit)
  wordY: int32 = boxMargin
  wordFound: bool = false
  attempt: int = 0

proc initGameState*(): GameState =
  let words = readFile("resources/words.txt").splitLines
  result = GameState(
    words: words,
    randomWord: words.sample.toUpper
  )
  result.userWords.add(Word(y: result.wordY))
  echo result.randomWord

proc update*(self: var GameState) =
  # No more problem with keyboard layouts.
  # You can also write the same letter several times by holding it.
  let charPressed = getCharPressed()
  if charPressed in letters and self.userWords[^1].currentLen != wordLimit:
    self.userWords[^1].addLetter(charPressed.char.toUpperAscii)

  let key = getKeyPressed()

  if key == KeyboardKey.Backspace and not (self.wordFound or self.attempt == attemptsLimit):
    self.userWords[^1].pop()
  if key != KeyboardKey.Enter and key != KeyboardKey.KpEnter:
    return

  if self.wordFound or self.attempt == attemptsLimit:
    # TODO: call constructor ?
    self.wordY = boxMargin
    self.userWords = @[Word(y: self.wordY)]
    self.randomWord = self.words.sample.toUpper
    self.wordFound = false
    self.attempt = 0
  elif self.userWords[^1].currentLen == wordLimit and self.userWords[^1].getString.toLower in self.words:
    self.userWords[^1].updateColors(self.randomWord)
    inc self.attempt

    if self.userWords[^1].isCorrect:
      self.wordFound = true
    elif self.attempt != attemptsLimit:
      self.wordY += boxSize + boxMargin
      self.userWords.add(Word(y: self.wordY))

proc drawNotification(text: cstring) =
  drawRectangle(10, screenHeight - boxSize * 2 - boxMargin * 2, screenWidth - boxMargin * 4, 50 + boxMargin * 2, Gray)
  drawText(text, 15, screenHeight - boxSize * 2 - boxMargin, 50, RayWhite)

proc draw*(self: GameState) =
  beginDrawing()
  defer: endDrawing()

  clearBackground(RayWhite)

  for i in 0..<wordLimit:
    for j in 0..<attemptsLimit:
      drawRectangleLines(
        boxMargin + (boxSize + boxMargin) * i.int32, 
        boxMargin + (boxSize + boxMargin) * j.int32, 
        boxSize, boxSize, Black
      )

  for word in self.userWords:
    word.draw()

  if self.wordFound:
    drawNotification("Congrats!")
  elif self.attempt == attemptsLimit:
    drawNotification("You lost...")
