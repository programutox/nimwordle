import state
from tutorialstate import initTutorial
from gamestate import screenWidth, screenHeight
import raylib

const
  buttonWidth: float32 = 100.0
  buttonHeight: float32 = 100.0
  buttonY = (screenHeight.float32 - buttonHeight) / 2.0
  textButtonSize: int32 = 30
  textButtonY = (screenHeight - textButtonSize) div 2

type LanguageSelection = ref object of State
  englishButton: Rectangle
  frenchButton: Rectangle

proc initLanguageSelection*(): LanguageSelection =
  LanguageSelection(
    englishButton: Rectangle(x: 10.0, y: buttonY, width: buttonWidth, height: buttonHeight),
    frenchButton: Rectangle(x: screenWidth - buttonWidth - 10.0, y: buttonY, width: buttonWidth, height: buttonHeight)
  )

method update*(self: var LanguageSelection, states: var seq[State]) =
  if not isMouseButtonPressed(MouseButton.Left):
    return
  
  let mousePosition = getMousePosition()
  if checkCollisionPointRec(mousePosition, self.englishButton):
    states.add(initTutorial(English))
  elif checkCollisionPointRec(mousePosition, self.frenchButton):
    states.add(initTutorial(French))

method draw*(self: var LanguageSelection) =
  drawText("Choose a language", 10, 10, 25, Black)
  drawRectangle(self.englishButton, Red)
  drawText("EN", self.englishButton.x.int32 + 10, textButtonY, textButtonSize, White)
  drawRectangle(self.frenchButton, Blue)
  drawText("FR", self.frenchButton.x.int32 + 10, textButtonY, textButtonSize, White)
