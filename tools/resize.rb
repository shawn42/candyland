require 'chunky_png'
require 'pry'

in_file = ARGV[0] || "platformer_sheet.png"
sprite_size = ARGV[1] || 21
padding_to_remove = 2
orig = ChunkyPNG::Image.from_file(in_file)

cols = (orig.width-padding_to_remove) / (sprite_size+padding_to_remove)
rows = (orig.height-padding_to_remove) / (sprite_size+padding_to_remove)
out_width = sprite_size * cols
out_height = sprite_size * rows

out = orig.crop(0,0,out_width,out_height) #ChunkyPNG::Image.new(out_width, out_height, ChunkyPNG::Color::TRANSPARENT)

trans = out.get_pixel(0,0)
out.width.times do |x|
  out.height.times do |y|
    out.set_pixel x, y, trans
  end
end

cols.times do |c|
  rows.times do |r|
    sprite = orig.crop(padding_to_remove+c*(sprite_size+padding_to_remove), padding_to_remove+r*(sprite_size+padding_to_remove), sprite_size, sprite_size)
    out.compose! sprite, c*sprite_size, r*sprite_size
  end
end

out.save('out.png')
`open out.png`
