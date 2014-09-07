define_behavior :platformer do
  requires :director

  setup do
    actor.has_attributes speed: 100
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
      if actor.controller.move_left?
        actor.x -= actor.speed*dt_ms*0.001
        ensure_looking_left
        idle = false
        actor.action = :walking
      end

      if actor.controller.move_right?
        actor.x += actor.speed*dt_ms*0.001
        ensure_looking_right
        idle = false
        actor.action = :walking
      end

      if actor.controller.duck?
        idle = false
        actor.action = :duck
      end

      actor.action = :idle if idle
    end
  end
end
