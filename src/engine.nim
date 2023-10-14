import sdl2_nim/sdl
import sdl2_nim/sdl, sdl2_nim/sdl_image as img
import sdl2core
import std/tables

import ./yeacs
# import ./components
import ./systems/draw

import components
import sdl2_nim/sdl_gfx_primitives as gfx


const
  Title = "SDL2 App"
  ScreenW = 640 # Window width
  ScreenH = 480 # Window height
  WindowFlags = 0
  RendererFlags = sdl.RendererAccelerated or sdl.RendererPresentVsync

proc run(world: var World, renderer: sdl.Renderer) =
  drawFrame(world, renderer)


var
  app = App(window: nil, renderer: nil)
  done = false # Main loop exit condition
  world = World()

if init(app, Title, ScreenW, ScreenH, WindowFlags, RendererFlags):

  # Load assets
  var
    image1 = newImage()
    imagTable = {
      "ship": newImage()
    }.toTable

  discard world.addEntity (
    Position(x: 50.0, y: 51.0),
    PolarVelocity(speed: 0.0, angle: 0.0),
    # Circle(r: 5),
    # Square(w: 5, h: 5),
    loadImage(app.renderer, "resources/ship.png"),
    Enemy()
  )

  # if not imagTable["ship"].load(app.renderer, "resources/ship.png"):
  #   done = true

  # Main loop
  while not done:
    # Clear screen with draw color
    discard app.renderer.setRenderDrawColor(0x00, 0x00, 0x00, 0xFF)
    if app.renderer.renderClear() != 0:
      sdl.logWarn(sdl.LogCategoryVideo,
                  "Can't clear screen: %s",
                  sdl.getError())


    # Render textures
    # if not imagTable["ship"].render(app.renderer, 50, 50):
    #   sdl.logWarn(sdl.LogCategoryVideo,
    #               "Can't render image1: %s",
    #               sdl.getError())

    run(world, app.renderer)

    # Update renderer
    app.renderer.renderPresent()

    # Event handling
    done = events()

    # my_stuff

  # Free assets
  # free(image1)

# Shutdown
exit(app)
