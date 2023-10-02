import raylib
import ../components
import ../yeacs
import std / lenientops


proc drawFrame*(world: var World) =
  beginDrawing()
  clearBackground(RayWhite)

  for (pos, circle) in world.foreach (Position, Circle):
    drawCircle(pos.x.int32, pos.y.int32, circle.r, circle.c)


  endDrawing()
