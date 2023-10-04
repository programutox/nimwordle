import std/[random, strutils]

proc main() =
  randomize()

  let words = readFile("assets/words.txt").splitLines
  let randomWord = words.sample
  echo randomWord

when isMainModule:
  main()