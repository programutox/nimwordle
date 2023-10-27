import state
from tutorialstate import initTutorial
from gamestate import screenWidth, screenHeight
import raylib

const
  iconRadius: float32 = 32.0
  iconY: float32 = screenHeight.float32 / 2.0
  unitedStatesIconPosition = Vector2(x: screenWidth.float32 / 4.0, y: iconY)
  unitedStatesIconDrawPosition = Vector2(x: unitedStatesIconPosition.x - iconRadius, y: unitedStatesIconPosition.y - iconRadius)
  franceIconPosition = Vector2(x: screenWidth.float32 * 0.75, y: iconY)
  franceIconDrawPosition = Vector2(x: franceIconPosition.x - iconRadius, y: franceIconPosition.y - iconRadius)

type LanguageSelection = ref object of State
  unitedStatesIcon: Texture2D
  franceIcon: Texture2D

proc initLanguageSelection*(): LanguageSelection =
  LanguageSelection(
    unitedStatesIcon: loadTexture("resources/united_states.png"),
    franceIcon: loadTexture("resources/france.png")
  )

method update*(self: var LanguageSelection, states: var seq[State]) =
  if not isMouseButtonPressed(MouseButton.Left):
    return
  
  let mousePosition = getMousePosition()
  if checkCollisionPointCircle(mousePosition, unitedStatesIconPosition, iconRadius):
    states.add(initTutorial(English))
  elif checkCollisionPointCircle(mousePosition, franceIconPosition, iconRadius):
    states.add(initTutorial(French))

method draw*(self: var LanguageSelection) =
  drawText("Choose a language", 20, 10, 25, Black)
  drawTexture(self.unitedStatesIcon, unitedStatesIconDrawPosition, White)
  drawTexture(self.franceIcon, franceIconDrawPosition, White)
