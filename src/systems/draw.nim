import
  sdl2_nim/sdl,
  sdl2_nim/sdl_image as img,
  sdl2_nim/sdl_gfx_primitives as gfx,
  sdl2_nim/sdl_gfx_primitives_font as font


import 
  ../components,
  ../yeacs


proc drawFrame*(world: var World, render: sdl.Renderer) =
  for (pos, circle) in world.foreach (Position, Circle):
    var
      x = pos.x.int16
      y = pos.y.int16
      rad = circle.r.int16

    discard render.
      filledCircleRGBA(x=x, y=y, rad=rad,
        0.uint8, 255.uint8, 2.uint8, 255.uint8
      )

  for (pos, sqr) in world.foreach (Position, Square):
    var
      x1 = pos.x.int16
      y1 = pos.y.int16
      x2 = pos.x.int16 + sqr.w.int16
      y2 = pos.y.int16 + sqr.w.int16

    discard render.boxRGBA(
      x1 = x1, y1 = y1, x2 = x2, y2 = y2,
        0.uint8, 255.uint8, 255.uint8, 255.uint8
      )

  for (pos, img) in world.foreach (Position, Image):
    var
      x = pos.x.int32
      y = pos.y.int32
      w = img.w.int32
      h = img.h.int32
      rect = sdl.Rect(x: x, y: y, w: w, h: h)

    echo render.renderCopy(img.texture, nil, addr(rect))
    echo pos.x, pos.y

