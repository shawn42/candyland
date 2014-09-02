define_stage :demo do
  # render_with :my_renderer

  curtain_up do
    load_level
    map_controls

  end

  helpers do
    # include MyHelpers
    def load_level
      # backstage[:level] ||= 1
      @level = LevelLoader.load self, :level_1_1
      @shaylen = @level.named_objects[:shaylen]
      @ethan = @level.named_objects[:ethan]
    end

    # def draw(target)
    #   target.scale 2, 2 do
    #     super target
    #   end
    # end

    def map_controls
      ethan_controls = {
       '+w' => :jump,
       's' => :duck,
       'a'  => :move_left,
       'd'  => :move_right,
      }
      shaylen_controls = {
       '+i' => :jump,
       'k' => :duck,
       'j'  => :move_left,
       'l'  => :move_right,
      }
      @ethan.controller.map_controls ethan_controls
      @shaylen.controller.map_controls shaylen_controls
    end
  end
end
