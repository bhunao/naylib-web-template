import raylib
import std/lenientops

import ../components
import ../yeacs
import ../sprites


proc drawFrame*(world: var World) =
  beginDrawing()
  clearBackground(RayWhite)

  for (pos, circle) in world.foreach (Position, Circle):
    drawCircle(pos.x.int32, pos.y.int32, circle.r, circle.c)

  for (pos, sqr) in world.foreach (Position, Square):
    drawRectangle(pos.x.int32, pos.y.int32, sqr.w.int32, sqr.h.int32, sqr.c)

  endDrawing()
