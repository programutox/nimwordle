import std/[random, sequtils, strutils, unicode]

proc removeAccents(s: string): string =
  return s
    .toLower
    .multiReplace(
      ("é", "e"), ("è", "e"), ("ê", "e"), ("ï", "i"), ("ï", "i"), 
      ("ç", "c"), ("â", "a"), ("à", "a"), ("ô", "o"), ("û", "u")
    )

proc main() =
  randomize()

  let words = readFile("assets/liste_francais.txt")
    .splitLines
    .filterIt(it.runeLen == 5)
    .mapIt(it.removeAccents)
    .deduplicate(isSorted = true)
    
  let file = open("assets/words.txt", fmWrite)
  defer: file.close()

  for word in words:
    file.writeLine(word)

when isMainModule:
  main()