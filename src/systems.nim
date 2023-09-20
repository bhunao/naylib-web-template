import std/math
import raylib, std/lenientops
import polymorph
import components

# Define some logic for when Pos and Vel are together.
makeSystem "orbit", [Pos, OrbitPos, Vel]:
  all:
    var 
      newX = orbitPos.distance * cos degToRad orbitPos.angle
      newY = orbitPos.distance * sin degToRad orbitPos.angle
    pos.x = orbitPos.centerX + newX
    pos.y = orbitPos.centerY + newY

    orbitPos.angle += vel.speed
    discard

makeSystem "keyInput", [Player, Vel]:
  all:
    var value: float
    if value == 0:
      value = 0.0
    elif value < 0.0:
      value = -0.5
    elif value > 0.0:
      value = 0.5

    vel.speed -= value
    vel.speed = min(vel.speed, 3)
    vel.speed = max(vel.speed, -3)

    if isKeyDown(A):
      vel.speed += 0.5
    if isKeyDown(D):
      vel.speed += -0.5

makeSystem "draw", [Pos, Circle]:
  all:
    drawCircle(pos.x.int32, pos.y.int32, circle.r, circle.color)

makeSystem "move", [Pos, Vel]:
  all:
    pos.x += vel.speed * cos degToRad vel.angle
    pos.y += vel.speed * sin degToRad vel.angle

# Generate the ECS for use.
makeEcsCommit "runSystems"
