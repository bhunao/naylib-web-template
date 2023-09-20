import std/math
import raylib, std/lenientops
import polymorph


# Create some component data types.
register defaultCompOpts:
  type
    Pos* = object
      x*, y*: float
    Vel* = object
      speed*, angle*: float
    Circle* = object
      r*: float
      color*: Color
    Player* = object
    OrbitPos* = object
      centerX*, centerY*: float
      distance*, angle*: float
