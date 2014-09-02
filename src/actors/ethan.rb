define_actor :ethan do
  has_behaviors do
    positioned
    animated_with_spritemap file: 'kids.png',
      interval: 120, rows: 4, cols: 8, actions: {
        idle:          8,
        walking:       0..3,
        jump:          16,
        fall:          17,
        duck:          24,
      }
    graphical
    platformer
    jump
    audible
  end

end

