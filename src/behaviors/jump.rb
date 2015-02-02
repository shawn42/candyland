class Rect
  def each_point
    yield vec2(self[0], self[2])
    yield vec2(right, self[2])
    yield vec2(right, bottom)
    yield vec2(self[0], bottom)
  end
end
define_behavior :jump do

  requires :director, :map_inspector
  setup do
    actor.has_attributes gravity: 1.7,
      jump_height: 12, 
      jump_vel: 0
    actor.controller.when :jump, &method(:jump)
    director.when :update, &method(:update)
  end

  remove do
    director.unsubscribe_all self
  end

  helpers do
    include MinMaxHelpers

    def jump(_)
      unless actor.action == :jump || actor.action == :fall
        actor.jump_vel = actor.jump_height
        actor.action = :jump
        actor.react_to :play_sound, [:jump1,:jump2].sample
      end
    end

    def can_move?(dir)
      # BB behavior
      return true if dir < 0
      actor.has_attribute :bounding_box, nil
      hh = (actor.height-4)/2
      hw = (actor.width-16)/2
      bb = Rect.new(0, 0, 2*hw, 2*hh)
      bb.centerx = actor.x
      bb.centery = actor.y
      actor.bounding_box = bb

      actor.bounding_box.each_point do |point|
        return false if map_inspector.world_point_solid?(actor.map.map_data, point.x, point.y+dir)
      end
      true
    end

    def update(dt_ms,_)
      jump_amount = min(actor.jump_vel*dt_ms*0.1, dt_ms)

      y_delta = -jump_amount
      y_delta += actor.gravity*dt_ms*0.1

      actor.jump_vel -= dt_ms*0.1

      if actor.jump_vel < 0.5
        actor.jump_vel = 0 
      end

      dir = y_delta / y_delta.abs

      y_changed = false
      y_delta.abs.floor.times do |i|
        if can_move?(dir)
          y_changed = true
          actor.y += dir
        end
      end

      actor.action = :fall if dir > 0 && y_changed
    end
  end
end
