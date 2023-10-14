import sdl2_nim/sdl, sdl2_nim/sdl_image as img


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
    # c*: Color = Green

  Circle* = object
    r*: float

  Image* = object
    texture*: sdl.Texture
    w*, h*: int
