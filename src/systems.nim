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

makeSystem "keyInput", [Player, Vel, Pos, OrbitPos]:
  all:
    if isKeyDown(A) and vel.speed < 3:
      vel.speed += 0.1
    elif vel.speed > 0:
      vel.speed += -0.01

    if isKeyDown(D) and vel.speed > -3:
      vel.speed += -0.1
    elif vel.speed < 0:
      vel.speed += 0.01

    if isKeyDown(Space):
      var 
        newX = orbitPos.distance * cos degToRad orbitPos.angle
        newY = orbitPos.distance * sin degToRad orbitPos.angle
      newX = orbitPos.centerX + newX
      newY = orbitPos.centerY + newY

      discard newEntityWith(
        Pos(x: newX, y: newY),
        Vel(speed: 6.0, angle: orbitPos.angle - 180),
        Circle(r:5, color: Blue),
        Projectile(),
      )

makeSystem "handleProjectiles", [Projectile, Pos]:
  all:
    if pos.x > getScreenWidth() or pos.x < 0:
      sys.deleteList.add entity
    if pos.y > getScreenHeight() or pos.y < 0:
      sys.deleteList.add entity

makeSystem "drawCircle", [Pos, Circle]:
  all:
    drawCircle(pos.x.int32, pos.y.int32, circle.r, circle.color)

makeSystem "move", [Pos, Vel]:
  all:
    pos.x += vel.speed * cos degToRad vel.angle
    pos.y += vel.speed * sin degToRad vel.angle

# Generate the ECS for use.
makeEcsCommit "runSystems"
