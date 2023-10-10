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

proc addLetter*(word: var Word, letter: char) =
  if word.letters.len == wordLimit:
    return
  word.letters.add($letter)
  word.colors.add(Red)

func currentLen*(word: Word): int =
  word.letters.len

proc pop*(word: var Word) =
  if word.currentLen == 0:
    return
  word.letters = word.letters[0..^2]
  word.colors = word.colors[0..^2]

proc draw*(word: Word) =
  if word.currentLen == 0:
    return
  for i, letter in word.letters:
    drawText(letter.cstring, boxMargin * 2 + i.int32 * (boxSize + boxMargin), word.y, boxSize, word.colors[i])
