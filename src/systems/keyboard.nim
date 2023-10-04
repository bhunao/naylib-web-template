import raylib
import ../components
import ../yeacs
import std / lenientops


const MAXVELOCITY = 5


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

proc keyboardMoveCartesianWASD*(world: var World) =
  for (_, pos, vel) in world.foreach (KeyboardInput, Position, CartesianVelocity):
    if isKeyDown(W):
      vel.y = max(-MAXVELOCITY, vel.y - 0.1)
    elif isKeyDown(S):
      vel.y = min(MAXVELOCITY, vel.y + 0.1)
    elif vel.y > 0:
      vel.y += -0.1
    elif vel.y < 0:
      vel.y += 0.1

    if isKeyDown(A):
      vel.x = max(-MAXVELOCITY, vel.x - 0.1)
    elif isKeyDown(D):
      vel.x = min(MAXVELOCITY, vel.x + 0.1)
    elif vel.x > 0:
      vel.x += -0.1
    elif vel.x < 0:
      vel.x += 0.1

proc keyboardAttackSpace*(world: var World) =
  for (_, pos, _) in world.foreach (KeyboardInput, Position, Player):
    if isKeyDown(Space):
      echo pos.x, " - ", pos.y, " === coisa"
      let 
        p = Position(x: 5.0, y: 5.0)
        s = Square(w: 10, h: 10, c: Gold)
      echo p, s
      # let coisa = world.addEntity (p, s) # this bugs for some reason atempt to acess nil

