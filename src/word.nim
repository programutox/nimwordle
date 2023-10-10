import std/[sequtils, sets, sugar]
import raylib

const
  wordLimit* = 5
  boxSize* = 50
  boxMargin* = 5

type Word* = object
  y*: int32

  # If you try to create a seq[cstring], you get weird behaviors.
  # For instance adding a cstring to the seq would modify all the previous elements.
  letters: seq[string] = newSeqOfCap[string](wordLimit)
  colors: seq[Color] = newSeqOfCap[Color](wordLimit)
  rects: seq[Rectangle] = newSeqOfCap[Rectangle](wordLimit)

func currentLen*(word: Word): int =
  word.letters.len

proc addLetter*(word: var Word, letter: char) =
  if word.currentLen == wordLimit:
    return
  word.letters.add($letter)
  word.colors.add(Black)
  word.rects.add(
    Rectangle(
      x: ((word.letters.len - 1) * (boxSize + boxMargin)).float32,
      y: word.y.float32,
      width: boxSize.float32,
      height: boxSize.float32
    )
  )

proc pop*(word: var Word) =
  if word.currentLen == 0:
    return
  word.letters = word.letters[0..^2]
  word.colors = word.colors[0..^2]
  word.rects = word.rects[0..^2]

proc updateColors*(word: var Word, referenceWord: string) =
  let wordSet = toHashSet(referenceWord).map(c => $c)
  for i, letter in word.letters:
    word.colors[i] =
      if letter == $referenceWord[i]:
        Green
      elif letter in wordSet:
        Yellow
      else:
        DarkGray

func isCorrect*(word: Word): bool =
  all(word.colors, c => c == Green)

func draw*(word: Word) =
  if word.currentLen == 0:
    return
  for i, letter in word.letters:
    drawRectangle(word.rects[i], word.colors[i])
    drawText(letter.cstring, boxMargin * 2 + i.int32 * (boxSize + boxMargin),
        word.y, boxSize, RayWhite)
