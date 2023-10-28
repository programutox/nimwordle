from std/random import sample
import std/[strutils, tables]
import raylib
import word
import state

const
  screenWidth* = boxMargin + (boxSize + boxMargin) * wordLimit
  attemptsLimit* = 6
  screenHeight* = boxMargin + (boxSize + boxMargin) * attemptsLimit
  letters = 'a'.int..'z'.int
  notificationDuration = 2
  textSize = 40

type 
  NotificationKind = enum
    nkNone, nkNotEnoughLetters, nkInvalidWord, nkWin, nkLost

const 
  englishNotificationTexts = {
      nkNotEnoughLetters: "Five letters".cstring,
      nkInvalidWord: "Invalid word",
      nkWin: "Congrats!",
      nkLost: "You lost..."
  }.toTable

  frenchNotificationTexts = {
      nkNotEnoughLetters: "Cinq lettres".cstring,
      nkInvalidWord: "Mot invalide",
      nkWin: "Bravo!",
      nkLost: "Perdu..."
  }.toTable

  notificationTexts = {
    Language.English: englishNotificationTexts,
    Language.French: frenchNotificationTexts,
  }.toTable

type
  Game* = ref object of State
    words: seq[string]
    randomWord: string
    userWords: seq[Word] = newSeqOfCap[Word](attemptsLimit)
    wordY: int32 = boxMargin
    attempt: int = 0
    timer: float = 0.0
    notification: NotificationKind = nkNone

proc initGame*(language: Language): Game =
  let filePath =
    if language == English:
      "resources/words_en.txt"
    else:
      "resources/words.txt"
  let words = readFile(filePath).splitLines
  result = Game(
    words: words,
    randomWord: words.sample.toUpper,
    language: language
  )
  result.timer = getTime()
  result.userWords.add(Word(y: result.wordY))
  echo result.randomWord

func isOver(self: Game): bool =
  self.notification in [nkWin, nkLost]

proc setNotification(self: var Game, kind: NotificationKind) =
  if self.notification != nkNone:
    return
  self.timer = getTime()
  self.notification = kind

func checkWord(self: var Game) =
  self.userWords[^1].updateColors(self.randomWord)
  inc self.attempt

  if self.userWords[^1].isCorrect:
    self.notification = nkWin
  elif self.attempt != attemptsLimit:
    self.wordY += boxSize + boxMargin
    self.userWords.add(Word(y: self.wordY))
  else:
    self.notification = nkLost

proc onEnter(self: var Game) =
  if self.isOver():
    self = initGame(self.language)
  elif self.userWords[^1].currentLen != wordLimit:
    self.setNotification(nkNotEnoughLetters)
  elif self.userWords[^1].getString.toLower notin self.words:
    self.setNotification(nkInvalidWord)
  else:
    self.checkWord()

# Here method enables to override the base one.
# You need the same signature except for the type parameter,
# which is the inherited one.
method update*(self: var Game, states: var seq[State]) =
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

proc drawNotification(self: var Game, text: cstring, temporary: bool = false) =
  if temporary and getTime() - self.timer > notificationDuration:
    self.notification = nkNone
    return

  drawRectangle(10, screenHeight - boxSize * 2 - boxMargin * 2, screenWidth - boxMargin * 4, textSize + boxMargin * 2, Gray)
  drawText(text, 15, screenHeight - boxSize * 2 - boxMargin, textSize, RayWhite)

method draw*(self: var Game) =
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
    of nkNone:
      discard
    of [nkWin, nkLost]:
      self.drawNotification(notificationTexts[self.language][self.notification])
    else:
      self.drawNotification(notificationTexts[self.language][self.notification], true)
