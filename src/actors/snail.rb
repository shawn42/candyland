# TODO fix this to make AI setup easier!
class InputMapper
  def initialize
    @action_ids = {}
    @state = {}
  end

  def method_missing(name, *args)
    name_str = name.to_s
    attr = name_str[0..-2]
    if name_str.end_with? '='
      @state[attr] = args.first
    elsif name_str.end_with? '?'
      if @state.has_key? attr
        return @state[attr]
      else
        button_syms = @action_ids[attr.to_sym]
        if button_syms
          return button_syms.any? do |button_sym| 
            input_manager.down_ids.include? BUTTON_SYM_TO_ID[button_sym]
          end
        end
      end
    end

    false
  end
end

define_actor :snail do
  has_behaviors do
    positioned
    start = 13*30+24
    animated_with_spritemap file: 'platformer_stripped.png',
      interval: 500, rows: 30, cols: 30, actions: {
        idle:      start,
        walking:   start..(start+1),
        curled_up: start+2,
      }
    graphical
    # platformer
    # jump
    # audible
  end

  behavior do
    requires :timer_manager, :director
    setup do
      actor.action = :walking
      actor.controller.move_left = true

      walk_left
      # custom version of platformer behavior
      actor.has_attributes speed: 10
      director.when :update, &method(:update)
    end

    remove do
      timer_manager.remove_timer "wl_#{object_id}"
      timer_manager.remove_timer "wr_#{object_id}"
      director.unsubscribe_all self
    end

    helpers do
      def walk_left
        actor.controller.move_left = true
        actor.controller.move_right = false

        timer_manager.add_timer "wr_#{object_id}", 3_000, false do
          walk_right
        end
      end
      def walk_right
        actor.controller.move_left = false
        actor.controller.move_right = true

        timer_manager.add_timer "wl_#{object_id}", 3_000, false do
          walk_left
        end
      end
      def ensure_looking_left
        actor.x_scale = actor.x_scale * -1 if actor.x_scale < 0
      end
      def ensure_looking_right
        actor.x_scale = actor.x_scale * -1 if actor.x_scale > 0
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

end

