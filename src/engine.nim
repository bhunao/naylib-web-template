import raylib
import std/math
import std/lenientops

import ./yeacs
import ./components
import ./sprites

import ./systems/move
import ./systems/draw
import ./systems/keyboard
import ./systems/collission

const
  WIDTH = 800
  HEIGHT = 600

var 
  world = World()
  firstEnt: Entity
  ticks = 0

proc run() =
  drawFrame(world)

  moveSystem(world, WIDTH, HEIGHT)
  collissionSystem(world)

  keyboardMoveCartesianWASD(world)
  keyboardAttackSpace(world)
  inc ticks

proc initGame =
  var 
    ent1 = world.addEntity (
      Position(x: 150.0, y: 150.0),
      PolarVelocity(speed: 1.0, angle: 0.0),
      Circle(r: 150),
      Enemy()
    )
    ent2 = world.addEntity (
      Position(x: 250.0, y: 250.0),
      CartesianVelocity(x: 0, y: 0),
      Square(w: 50, h: 100, c: Gold),
      KeyboardInput(),
      Player(),
    )

proc drawGame =
  beginDrawing()
  clearBackground(RayWhite)
  run()

  endDrawing()

proc unloadGame =
  # Unload game variables
  # TODO: Unload all dynamic loaded data (textures, sounds, models...)
  discard

proc main =
  # setConfigFlags(WindowResizable.flags)
  initWindow(WIDTH, HEIGHT, "Naylib Web Template")
  setWindowMinSize(320, 240)
  try:
    initGame()
    when defined(emscripten):
      emscriptenSetMainLoop(drawGame, 60, 1)
    else:
      setTargetFPS(60)
      while not windowShouldClose():
        drawGame()
    unloadGame()
  finally:
    closeWindow()

main()
