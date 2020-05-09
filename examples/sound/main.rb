require 'dxopal'
include DXOpal

Sound.register(:se, "..//apple_catcher/sounds/get.wav")

Window.width = 400
Window.height = 400
Window.bgcolor = C_BLACK

Window.load_resources do
  Window.loop do
    if Input.mouse_push?(M_LBUTTON) ||
        Input.key_push?(K_Z)
      x = Input.mouse_pos_x
      y = Input.mouse_pos_y
      volume = (x.to_f / Window.width * 255).round
      time = (y.to_f / Window.height) * 1000
      p [x, volume, y, time]

      se = Sound[:se]
      se.set_volume(volume)
      se.play()
    end
  end
end
