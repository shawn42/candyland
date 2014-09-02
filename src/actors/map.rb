define_actor :map do

  has_behaviors do
    positioned
    layered ZOrder::MapTiles
  end
  
  view do
    requires :wrapped_screen, :resource_manager
    setup do
      map_data = actor.map_data
      tile_size = map_data.tile_size
      actor.has_attributes map_image: nil,
        tileset: resource_manager.load_tiles(map_data.tileset_image, tile_size, tile_size)
    end
    
    draw do |target, x_off, y_off, z|
      map_data = actor.map_data
      tile_size = map_data.tile_size
      # TODO how to get these?
      width = map_data.tile_grid.size * tile_size
      height = map_data.tile_grid.first.size * tile_size
      tileset = actor.tileset

      unless actor.map_image
        actor.map_image = wrapped_screen.record width, height do
          map_data.bg_tile_grid.each.with_index do |row, y|
            row.each.with_index do |tile, x|
              if tile
                target.draw_image tileset[tile.gfx_index], x*tile_size, y*tile_size, z
              end
            end
          end
          map_data.tile_grid.each.with_index do |row, y|
            row.each.with_index do |tile, x|
              if tile
                target.draw_image tileset[tile.gfx_index], x*tile_size, y*tile_size, z
              end
            end
          end
        end
      end

      target.draw_image actor.map_image, x_off, y_off, z

      map_data.fg_tile_grid.each.with_index do |row, y|
        row.each.with_index do |tile, x|
          if tile
            target.draw_image tileset[tile.gfx_index], x_off+x*tile_size, y_off+y*tile_size, ZOrder::MapForeground
          end
        end
      end

    end
  end
end



