import raylib
import ../yeacs
import ../components


proc collissionSystem*(world: var World) =
  for (pos1, vel1, cir1, player) in world.foreach (Position, PolarVelocity, Circle, Player):
    for (pos2, vel2, cir2, enemy) in world.foreach (Position, PolarVelocity, Circle, Enemy):
      var 
        center1 = Vector2(x: pos1.x, y: pos1.y)
        center2 = Vector2(x: pos2.x, y: pos2.y)
        radius1 = cir1.r.float32
        radius2 = cir2.r.float32

      if checkCollisionCircles(center1, radius1, center2, radius2):
        echo "player collided with enemy"
