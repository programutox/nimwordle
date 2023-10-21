import state
import std/strformat
from gamestate import attemptsLimit, initGameState
import raylib

const 
  instructions = [
    (fmt"You have {attemptsLimit} attempts to").cstring,
    "guess the word.",
    "A green letter is in the",
    "right place.",
    "",
    "A yellow letter is in the",
    "word but in the wrong",
    "place.",
    "",
    "A grey letter is not in",
    "the word."
  ]
  fontSize: int32 = 20

type TutorialState = ref object of State
  textures: seq[Texture2D]

func getAssetPath(file: string): string =
    "./resources/" & file

proc initTutorialState*(): TutorialState =
  result = TutorialState(textures: @[])
  result.textures.add("green_letter.png".getAssetPath.loadTexture)
  result.textures.add("yellow_letter.png".getAssetPath.loadTexture)

method update*(self: var TutorialState, states: var seq[State]) =
  if isKeyPressed(Enter) or isKeyPressed(KpEnter):
    states.add(initGameState())

method draw*(self: var TutorialState) =
  var j: int32 = 0

  for i, instruction in instructions:
    if instruction == "":
      drawTexture(self.textures[j], 5, 10 + i.int32 * (fontSize + 5), White)
      inc j
    else:
      drawText(instruction, 10, 10 + (j.min(1)) * 50 + i.int32 * (fontSize + 5), fontSize, Black)