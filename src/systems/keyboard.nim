import raylib
import ../components
import ../yeacs
import std / lenientops


const MAXVELOCITY = 3


proc keyboardMovePolarWASD*(world: var World) =
  for (_, pos, vel) in world.foreach (KeyboardInput, Position, PolarVelocity):
    if isKeyDown(W):
      vel.speed = min(MAXVELOCITY, vel.speed + 0.1)
    if isKeyDown(S):
      vel.speed = max(-MAXVELOCITY, vel.speed - 0.1)

    if isKeyDown(A):
      vel.angle += -1
    if isKeyDown(D):
      vel.angle += 1
