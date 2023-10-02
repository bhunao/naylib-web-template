import raylib


type
  Player* = object
  Enemy* = object
  KeyboardInput* = object

  Square* = object
    w*, r*: float

  Circle* = object
    r*: float
    c*: Color = Red

  Position* = object
    x*, y*: float

  PolarVelocity* = object
    speed*, angle*: float = 1
