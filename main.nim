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

proc initGame =
  frog.texture = loadTexture("resources/frog_sit.png")
  frog.source = Rectangle(x: 0, y: 0, width: frog.texture.width.toFloat, height: frog.texture.height.toFloat)
  frog.dest = Rectangle(x: screenWidth/2, y: 0, width: frog.texture.width.toFloat, height: frog.texture.height.toFloat)
  frog.origin = Vector2(x: frog.texture.width.toFloat/2, y:0)

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
  discard

proc drawGame =
  beginDrawing()
  clearBackground(RayWhite)

  draw frog

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
