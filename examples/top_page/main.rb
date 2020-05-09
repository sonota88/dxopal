require 'dxopal'; include DXOpal
Window.width = 300
Window.height = 300
Window.bgcolor = C_WHITE
Window.load_resources do
  x = rand(Window.width)
  y = rand(Window.height)
  dx = dy = 2
  Window.loop do
    Window.draw_circle_fill(x, y, 10, C_RED)
    dx = -dx if x < 0 || x > Window.width
    dy = -dy if y < 0 || y > Window.height
    x += dx
    y += dy

    x2 = 50
    y2 = 50
    Window.draw_circle_fill(x2, y2, 10, C_BLACK)
    Window.draw_circle(     x2, y2, 12, C_BLACK)
    Window.draw_box(x2-14, y2-14, x2+14, y2+14, C_BLACK)
  end
end
