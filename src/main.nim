import std/[random, strutils]
import raylib

const
  boxSize = 50
  wordLimit = 5
  offset = 5
  screenWidth = (boxSize + offset) * wordLimit
  attempts = 10
  screenHeight = boxSize * (attempts + 1)
  letters = 'a'.int..'z'.int

type Word = object
  y: int32

  # If you try to create a seq[cstring], you get weird behaviors.
  # For instance adding a cstring in the seq would modify all the previous elements.
  letters: seq[string] = newSeqOfCap[string](wordLimit)
  colors: seq[Color] = newSeqOfCap[Color](wordLimit)

proc addLetter(word: var Word, letter: char) =
  if word.letters.len == wordLimit:
    return
  word.letters.add($letter)
  word.colors.add(Red)

func currentLen(word: Word): int =
  word.letters.len

proc pop(word: var Word) =
  if word.currentLen == 0:
    return
  word.letters = word.letters[0..^2]
  word.colors = word.colors[0..^2]

proc draw(word: Word) =
  if word.currentLen == 0:
    return
  for i, letter in word.letters:
    drawText(letter.cstring, offset * 2 + i.int32 * (boxSize + offset), word.y, boxSize, word.colors[i])

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
        # if userWords[^1].currentLen != 0:
          # userWords[^1].letters = userWords[^1].letters[0..^2]
      of Enter, KpEnter:
        if userWords[^1].currentLen == wordLimit:
          wordY += boxSize
          userWords.add(Word(y: wordY))
      else:
        discard

    clearBackground(RayWhite)

    for word in userWords:
      # if word.currentLen != 0:
      #   drawText(word.cstring, 10, 10 + i.int32 * boxSize, boxSize, Black)
      word.draw()

# I moved game logic to a main function because defer is not supported at top-level
when isMainModule:
  main()