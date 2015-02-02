class MapInspector

  # TODO this will come from the map import eventually
  def solid?(map, row, col)
    return false if row < 0 || col < 0

    trow = map.tile_grid[row]
    return false unless trow
    trow[col]
  end

  def line_of_sight?(actor_a, actor_b)
    map = actor_a.map.map_data
    bb_to_check = actor_a.bb.union(actor_b.bb)
    line = [actor_a.position.to_a, actor_b.position.to_a]
    overlap_tiles(map, bb_to_check) do |tile, row, col|
      tile_size = map.tile_size
      tile_x = col * tile_size
      tile_y = row * tile_size
      tile_box = Rect.new tile_x, tile_y, tile_size, tile_size

      return false if line_tile_collision?(map, line, row, col, tile_box)
    end
    true
  end

  def world_point_solid?(map, x, y)
    tile_size = map.tile_size

    row = (y / tile_size).floor
    col = (x / tile_size).floor

    solid? map, row, col
  end

  def out_of_bounds?(map, pos)
    tile_grid = map.tile_grid
    tile_size = map.tile_size
    width = tile_grid.first.size * tile_size
    height = tile_grid.size * tile_size
    boundary_size = tile_size * 10

    # TODO cache this on map?
    bb = Rect.new -boundary_size, -boundary_size, width + 2 * boundary_size, height + 2 * boundary_size
    return !bb.collide_point?(pos.x, pos.y)
  end
  
end
