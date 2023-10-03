import raylib
import ../components
import ../componentutils
import ../yeacs
import std / lenientops
import ../sprites


proc drawFrame*(world: var World) =
  beginDrawing()
  clearBackground(RayWhite)

  for (pos, circle) in world.foreach (Position, Circle):
    drawCircle(pos.x.int32, pos.y.int32, circle.r, circle.c)

  # for (pos, spr) in world.foreach (Position, Sprite):
  #   var 
  #     position = Vector2(x: pos.x, y: pos.y)
  #     txture = texturas[SPACESHIP]
  #   drawTexture(txture, position, spr.rotation, spr.scale, spr.color)
# void DrawTextureEx(Texture2D texture, Vector2 position, float rotation, float scale, Color tint);  // Draw a Texture2D with extended parameters

  endDrawing()
