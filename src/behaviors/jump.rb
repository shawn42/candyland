define_behavior :jump do

  requires :director
  setup do
    actor.has_attributes jump_height: 36, jump_vel: 0, gravity: 3
    actor.controller.when :jump, &method(:jump)
    director.when :update, &method(:update)
  end

  remove do
    director.unsubscribe_all self
  end

  helpers do
    include MinMaxHelpers

    def jump(_)
      actor.jump_vel = actor.jump_height
      actor.action = :jump
      actor.react_to :play_sound, [:jump1,:jump2].sample
    end

    def can_move?(dir)
      # TODO map integration here
      dir < 0 || actor.y <= 152
    end

    def update(dt_ms,_)
      jump_amount = min(actor.jump_vel*dt_ms*0.1, dt_ms)

      y_delta = -jump_amount
      y_delta += actor.gravity*dt_ms*0.1

      actor.jump_vel -= dt_ms*0.2

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
