import raylib
import ../components
import ../yeacs
import std / lenientops


const MAXVELOCITY = 5

proc keyboardMoveCartesianWASD*(world: var World) =
  for (_, pos, vel) in world.foreach (KeyboardInput, Position, CartesianVelocity):
    ent2 = world.addEntity (
      Position(x: 250.0, y: 250.0),
      CartesianVelocity(x: 0, y: 0),
      Square(w: 50, h: 100, c: Gold),
      KeyboardInput(),
      Player(),
    )

