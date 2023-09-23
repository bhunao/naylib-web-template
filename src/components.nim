import raylib
import polymorph


register defaultCompOpts:
  type
    Origin {.notComponent.} = enum
      MID, TOPLEFT

    Enemy* = object
    Player* = object
    Projectile* = object

    Pos* = object
      x*, y*: float

    Vel* = object
      speed*, angle*: float

    Circle* = object
      r*: float
      color*: Color

    OrbitPos* = object
      centerX*, centerY*: float
      distance*, angle*: float

    Sprite* = object
      texture*: Texture
      source*: Rectangle
      dest*: Rectangle
      origin*: Vector2
      rotation*: float
      angle*: float
