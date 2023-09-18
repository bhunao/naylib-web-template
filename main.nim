import raylib, std/lenientops


const
  screenWidth = 800
  screenHeight = 600

type
  Entity = object
    texture: Texture
    source: Rectangle
    dest: Rectangle
    origin: Vector2
    rotation = 0.0
    speed = Vector2(x: 0, y:0)

var
  frog: Entity 
  tongue: Entity
  bait: Entity

proc initGame =
  frog.texture = loadTexture("resources/frog_sit.png")
  frog.source = Rectangle(x: 0, y: 0, width: frog.texture.width.toFloat, height: frog.texture.height.toFloat)
  frog.dest = Rectangle(x: screenWidth/2, y: 0, width: frog.texture.width.toFloat, height: frog.texture.height.toFloat)
  frog.origin = Vector2(x: frog.texture.width.toFloat/2, y:0)

  tongue.texture = loadTexture("resources/tongue_middle.png")
  tongue.source = Rectangle(x: 0, y: 0, width: tongue.texture.width.toFloat, height: tongue.texture.height.toFloat)
  tongue.dest = Rectangle(x: screenWidth/2 + 2.0, y: frog.texture.height.toFloat, width: tongue.texture.width.toFloat, height: 15)
  tongue.origin = Vector2(x: tongue.texture.width.toFloat/2, y:0)

  bait.texture = loadTexture("resources/tongue_end.png")
  bait.source = Rectangle(x: 0, y: 0, width: bait.texture.width.toFloat, height: bait.texture.height.toFloat)
  bait.dest = Rectangle(x: screenWidth/2 + 2.0, y: frog.texture.height.toFloat, width: bait.texture.width.toFloat, height: bait.texture.height.toFloat)
  bait.origin = Vector2(x: bait.texture.width.toFloat/2, y:0)

proc move(entity: var Entity, x, y: float) =
  entity.dest.x += x
  entity.dest.y += y

proc draw*(entity: var Entity) =
  drawTexture(
    entity.texture,
    entity.source,
    entity.dest,
    entity.origin,
    entity.rotation,
    White
  )

proc updateGame =
  var diff = (getMouseY() - bait.dest.y) / 15
  bait.move(0.0, diff)
  bait.dest.y = max(bait.dest.y, 150)

  tongue.dest.height = bait.dest.y - tongue.dest.y

proc drawGame =
  beginDrawing()
  clearBackground(RayWhite)

  draw frog
  draw tongue
  draw bait

  endDrawing()

proc unloadGame =
  # Unload game variables
  # TODO: Unload all dynamic loaded data (textures, sounds, models...)
  discard

proc updateDrawFrame {.cdecl.} =
  updateGame()
  drawGame()


proc main =
  initWindow(screenWidth, screenHeight, "Naylib Web Template")
  try:
    initGame()
    when defined(emscripten):
      emscriptenSetMainLoop(updateDrawFrame, 60, 1)
    else:
      setTargetFPS(60)
      while not windowShouldClose():
        updateDrawFrame()
    unloadGame()
  finally:
    closeWindow()

main()
