import ../yeacs
import ../components
import std/math


proc moveSystem*(world: var World, maxWidth, maxHeight: int) =
  for (pos, vel) in world.foreach (Position, PolarVelocity):
    pos.x += vel.speed * cos degToRad vel.angle
    pos.y += vel.speed * sin degToRad vel.angle

  for (pos, vel) in world.foreach (Position, CartesianVelocity):
    pos.x += vel.x
    pos.y += vel.y

    when defined(debugMove):
      debugEcho "Moved " & ecs.inspect(entity) & " from ", oldPosition, " to ", po


