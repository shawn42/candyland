define_behavior :platformer do
  requires :director, :map_inspector

  setup do
    actor.has_attributes speed: 140
    director.when :update, &method(:update)
  end

  remove do
    director.unsubscribe_all self
  end

  helpers do
    def ensure_looking_left
      actor.x_scale = actor.x_scale * -1 if actor.x_scale > 0
    end
    def ensure_looking_right
      actor.x_scale = actor.x_scale * -1 if actor.x_scale < 0
    end
    def update(dt_ms,_)
      idle = true
      x_delta = 0
      if actor.controller.move_left?
        x_delta -= actor.speed*dt_ms*0.001
        ensure_looking_left
        idle = false
        actor.action = :walking
      end

      if actor.controller.move_right?
        x_delta += actor.speed*dt_ms*0.001
        ensure_looking_right
        idle = false
        actor.action = :walking
      end

      if x_delta.abs > 0
        dir = x_delta / x_delta.abs

        x_changed = false
        x_delta.abs.floor.times do |i|
          if can_move?(dir)
            x_changed = true
            actor.x += dir
          end
        end
      end

      if actor.controller.duck?
        idle = false
        actor.action = :duck
      end

      actor.action = :idle if idle
    end

    def can_move?(dir)
      # BB behavior
      actor.has_attribute :bounding_box, nil
      hh = (actor.height-4)/2
      hw = (actor.width-16)/2
      bb = Rect.new(0, 0, 2*hw, 2*hh)
      bb.centerx = actor.x
      bb.centery = actor.y
      actor.bounding_box = bb

      actor.bounding_box.each_point do |point|
        return false if map_inspector.world_point_solid?(actor.map.map_data, point.x+dir, point.y)
      end
      true
    end
  end
end
