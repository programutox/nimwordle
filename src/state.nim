type State* = ref object of RootObj

# method keyword with {.base.} pragma enables to create a virtual method (like C++)
# In that case it is needed for seq[State], 
# so that the correct update and draw methods are called
method update*(self: var State, states: var seq[State]) {.base.} =
  discard

method draw*(self: var State) {.base.} =
  discard