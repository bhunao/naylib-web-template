import std/math
import raylib, std/lenientops
import polymorph
import systems
import components

const
  WIDTH = 800
  HEIGHT = 600

proc half(n: int): float = n / 2.0


# Compose Pos and Vel to trigger "move".
let
  player = newEntityWith(
    Pos(x: 0, y: 0),
    Vel(speed: 1.0, angle: 90.0),
    OrbitPos(
        centerX: 0,
        centerY: 0,
        distance: 200,
        angle: 0
      ),
    Circle(r:50, color: Blue),
    Player(),
  )
  orbitador = newEntityWith(
    Circle(r:10, color: Magenta),
    Pos(x: WIDTH.half, y: HEIGHT.half),
    Vel(speed: 3.0, angle: 90.0),
    OrbitPos(
        centerX: WIDTH.half,
        centerY: HEIGHT.half,
        distance: 200,
        angle: 0
      ),
    )

proc initGame =
  discard

proc updateGame =
  var 
    orbit = orbitador.fetch OrbitPos
    player = player.fetch OrbitPos

  orbit.centerX = getScreenWidth().half
  orbit.centerY = getScreenHeight().half

  player.centerX = getScreenWidth().half
  player.centerY = getScreenHeight().half

  runSystems()

proc drawGame =
  beginDrawing()
  clearBackground(RayWhite)

  endDrawing()

proc unloadGame =
  # Unload game variables
  # TODO: Unload all dynamic loaded data (textures, sounds, models...)
  discard

proc updateDrawFrame {.cdecl.} =
  updateGame()
  drawGame()


proc main =
  setConfigFlags(WindowResizable.flags)
  initWindow(WIDTH, HEIGHT, "Naylib Web Template")
  setWindowMinSize(320, 240)
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
