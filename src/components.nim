import raylib
import ./sprites


type
  # flags
  Player* = object
  Enemy* = object
  KeyboardInput* = object

  # movement
  Position* = object
    x*, y*: float

  PolarVelocity* = object
    speed*, angle*: float = 1

  # --
  Square* = object
    w*, r*: float

  Circle* = object
    r*: float
    c*: Color = Red

  Sprite* = object
    texture*: Sprites
    rotation*: float 
    scale*: float 
    color*: Color


