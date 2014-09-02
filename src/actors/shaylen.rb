define_actor :shaylen do
  has_behaviors do
    positioned
    animated_with_spritemap file: 'kids.png',
      interval: 120, rows: 4, cols: 8, actions: {
        idle:          12,
        walking:       4..7,
        jump:          20,
        fall:          21,
        duck:          28,
      }
    graphical
    platformer
    jump
    audible
  end


  # view do
  #   draw do |target, x_off, y_off, z|
  #     x = actor.x + x_off
  #     y = actor.y + y_off
  #     target.draw_box x,y, x+20, y+20, Color::RED, 1
  #   end
  # end
end
