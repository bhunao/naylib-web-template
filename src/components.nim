import raylib
import ./sprites


type
  # flags
  Player* = object
  Enemy* = object
  Projectile* = object
  KeyboardInput* = object

  # movement
  Position* = object
    x*, y*: float

  PolarVelocity* = object
    speed*, angle*: float = 0

  CartesianVelocity* = object
    x*, y*: float = 0

  # --
  Square* = object
    w*, h*: float
    c*: Color = Green

  Circle* = object
    r*: float
    c*: Color = Red

  Sprite* = object
    texture*: Sprites
    rotation*: float 
    scale*: float 
    color*: Color


