import state
from gamestate import initGameState
import raylib

const 
  instructions = [
    "A green letter is in the".cstring,
    "right place.",
    "",
    "A yellow letter is in the",
    "word but in the wrong",
    "place.",
    "",
    "A grey letter is not in",
    "the word.",
    "",
    "Press [Enter] to start"
  ]
  fontSize: int32 = 20

type TutorialState = ref object of State
  textures: seq[Texture2D]

proc initTutorialState*(): TutorialState =
  result = TutorialState(textures: @[])
  result.textures.add("resources/green_letter.png".loadTexture)
  result.textures.add("resources/yellow_letter.png".loadTexture)

method update*(self: var TutorialState, states: var seq[State]) =
  if isKeyPressed(Enter) or isKeyPressed(KpEnter):
    states.add(initGameState())

method draw*(self: var TutorialState) =
  var j: int32 = 0
  let texture_height: int32 = self.textures[0].height

  for i, instruction in instructions:
    if instruction != "":
      drawText(instruction, 10, 10 + j * (texture_height + 5) + (i.int32 - j) * (fontSize + 5), fontSize, Black)
    elif j < self.textures.len:
      drawTexture(self.textures[j], 5, 10 + j * (texture_height + 5) + (i.int32 - j) * (fontSize + 5), White)
      inc j
      