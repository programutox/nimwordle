from std/random import sample
from std/times import cpuTime
import std/strutils
import raylib
import word
import state

const
  screenWidth* = boxMargin + (boxSize + boxMargin) * wordLimit
  attemptsLimit = 6
  screenHeight* = boxMargin + (boxSize + boxMargin) * attemptsLimit
  letters = 'a'.int..'z'.int
  notificationDuration = 2
  textSize = 40

type 
  NotificationKind = enum
    nkNone, nkNotEnoughLetters, nkInvalidWord, nkWin, nkLost

  GameState* = ref object of State
    words: seq[string]
    randomWord: string
    userWords: seq[Word] = newSeqOfCap[Word](attemptsLimit)
    wordY: int32 = boxMargin
    attempt: int = 0
    timer: float = cpuTime()
    notification: NotificationKind = nkNone

proc initGameState*(): GameState =
  let words = readFile("resources/words.txt").splitLines
  result = GameState(
    words: words,
    randomWord: words.sample.toUpper
  )
  result.userWords.add(Word(y: result.wordY))
  echo result.randomWord

func isOver(self: GameState): bool =
  self.notification in [nkWin, nkLost]

proc setNotification(self: var GameState, kind: NotificationKind) =
  if self.notification != nkNone:
    return
  self.timer = cpuTime()
  self.notification = kind

func checkWord(self: var GameState) =
  self.userWords[^1].updateColors(self.randomWord)
  inc self.attempt

  if self.userWords[^1].isCorrect:
    self.notification = nkWin
  elif self.attempt != attemptsLimit:
    self.wordY += boxSize + boxMargin
    self.userWords.add(Word(y: self.wordY))
  else:
    self.notification = nkLost

proc onEnter(self: var GameState) =
  if self.isOver():
    self = initGameState()
  elif self.userWords[^1].currentLen != wordLimit:
    self.setNotification(nkNotEnoughLetters)
  elif self.userWords[^1].getString.toLower notin self.words:
    self.setNotification(nkInvalidWord)
  else:
    self.checkWord()

# Here method enables to override the base one.
# You need the same signature except for the type parameter,
# which is the inherited one.
method update*(self: var GameState) =
  # No more problem with keyboard layouts.
  # You can also write the same letter several times by holding it.
  let charPressed = getCharPressed()
  if charPressed in letters and self.userWords[^1].currentLen != wordLimit:
    self.userWords[^1].addLetter(charPressed.char.toUpperAscii)

  let key = getKeyPressed()
  if key == KeyboardKey.Backspace and not self.isOver():
    self.userWords[^1].pop()
  if key in [KeyboardKey.Enter, KeyboardKey.KpEnter]:
    self.onEnter()

proc drawNotification(self: var GameState, text: cstring, temporary: bool = false) =
  if temporary and cpuTime() - self.timer > notificationDuration:
    self.notification = nkNone
    return

  drawRectangle(10, screenHeight - boxSize * 2 - boxMargin * 2, screenWidth - boxMargin * 4, textSize + boxMargin * 2, Gray)
  drawText(text, 15, screenHeight - boxSize * 2 - boxMargin, textSize, RayWhite)

method draw*(self: var GameState) =
  for i in 0..<wordLimit:
    for j in 0..<attemptsLimit:
      drawRectangleLines(
        boxMargin + (boxSize + boxMargin) * i.int32, 
        boxMargin + (boxSize + boxMargin) * j.int32, 
        boxSize, boxSize, Black
      )

  for word in self.userWords:
    word.draw()

  case self.notification:
    of nkWin:
      self.drawNotification("Congrats!")
    of nkLost:
      self.drawNotification("You lost...")
    of nkNotEnoughLetters:
      self.drawNotification("Five letters", true)
    of nkInvalidWord:
      self.drawNotification("Invalid word", true)
    else:
      discard
