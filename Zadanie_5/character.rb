require 'ruby2d'

RUN_SPEED = 2.0
GRAVITY_FORCE = 2.0
JUMP_FORCE = 20.0

class Character
  def initialize
    @num_of_hearts = 3
    @points = 0
    @x = 100
    @y = 500
    @x_velocity = 0
    @y_velocity = 0
    @gravityForce = 2.0
    @onFloor = false
    @i = 0
    @j = 0
    @exist = true
  end

  def draw
    @sprite = Sprite.new(
      'tiles/Run (32x32).png',
      width: 64,
      height: 64,
      clip_width: 32,
      time: 50,
      x: @x,
      y: @y
      )
    @hitbox = Square.new(
      x: @x+9,
      y: @y+10,
      color: [1, 0, 1, 0.0],
      size: 47
      )
  end

  def is_exist
    return @exist
  end

  def get_hitbox
    return @hitbox
  end

  def get_y_velocity
    return @y_velocity
  end

  def set_y_velocity(value)
    @y_velocity = value
  end

  def set_x_velocity(value)
    @x_velocity = value
  end

  def get_x_velocity
    return @x_velocity
  end

  def set_num_of_hearts(value)
    @num_of_hearts = value
  end

  def get_num_of_hearts
    return @num_of_hearts
  end

  def set_points(value)
    @points = value
  end

  def get_points
    return @points
  end

  def move(world)
    Window.on :key_held do |event|
      case event.key
      when 'left'
        @sprite.play flip: :horizontal
        if @sprite.x > 0 && is_colliding_left(world) == false
          @sprite.x -= @x_velocity
          @hitbox.x -= @x_velocity
          puts @x_velocity
        end
      when 'right'
        @sprite.play
        if @sprite.x < (Window.width - @sprite.width) && is_colliding_right(world) == false
          @sprite.x += @x_velocity
          @hitbox.x += @x_velocity
        end
      end
    end

    Window.on :key_up do
      @sprite.stop
    end

    Window.on :key_down do |event|
      case event.key
      when 'up'
          if is_on_the_floor(world) == true
              @sprite.y -= @y_velocity
              @hitbox.y -= @y_velocity
          end
      end
    end
  end

  def playerGravity(world)
    if is_on_the_floor(world) == false
      @sprite.y += @gravityForce
      @hitbox.y += @gravityForce
    end
  end

  def change_move(world)
    Window.on :key_held do |event|
      case event.key
      when 'left'
        if is_colliding_left(world) == false && @sprite.x > 0
          @sprite.play flip: :horizontal
          @x_velocity = -RUN_SPEED
        else
          @x_velocity = 0
        end
      when 'right'
        if is_colliding_right(world) == false && @sprite.x < (Window.width - @sprite.width)
          @sprite.play
          @x_velocity = RUN_SPEED
        else
          @x_velocity = 0
        end
      end
    end

    Window.on :key_up do
      @sprite.stop
      @x_velocity = 0
    end

    Window.on :key_down do |event|
      case event.key
      when 'up'
        if is_on_the_floor(world) == true
          @y_velocity = -JUMP_FORCE
        end
      end
    end

  end

  def move
    if @y_velocity < 0
      @y_velocity += @gravityForce
    else
      @y_velocity = 0
    end

    @sprite.x += @x_velocity.round()
    @hitbox.x += @x_velocity.round()
    @hitbox.y += @y_velocity.round()
    @sprite.y += @y_velocity.round()
  end

  def is_on_the_floor(world)
    world.each do |worldHitbox|
      if @hitbox.contains?(worldHitbox.x1, worldHitbox.y1) ||
         @hitbox.contains?(worldHitbox.x2, worldHitbox.y2) ||
         worldHitbox.contains?(@hitbox.x3, @hitbox.y3) ||
         worldHitbox.contains?(@hitbox.x4, @hitbox.y4)
        return true
      end
    end
    return false
  end

  def is_colliding_right(world)
    world.each do |worldHitbox|
      if @hitbox.contains?(worldHitbox.x1, worldHitbox.y1+1) ||
         @hitbox.contains?(worldHitbox.x4, worldHitbox.y4+1) ||
         worldHitbox.contains?(@hitbox.x2, @hitbox.y2-1) ||
         worldHitbox.contains?(@hitbox.x3, @hitbox.y3-1)
            return true
      end
    end
    return false
  end

  def is_colliding_left(world)
    world.each do |worldHitbox|
      if @hitbox.contains?(worldHitbox.x2, worldHitbox.y2+1) ||
        @hitbox.contains?(worldHitbox.x3, worldHitbox.y3+1) ||
        worldHitbox.contains?(@hitbox.x1, @hitbox.y1-1) ||
        worldHitbox.contains?(@hitbox.x4, @hitbox.y4-1)
           return true
      end
    end
    return false
  end

  def is_colliding_up(world)
    wolrd.each do |worldHitbox|
      if @hitbox.contains?(worldHitbox.x4, worldHitbox.y4-1) ||
         @hitbox.contains?(worldHitbox.x3, worldHitbox.y3-1) ||
         worldHitbox.contains?(@hitbox.x1, @hitbox.y1+1) ||
         worldHitbox.contains?(@hitbox.x2, @hitbox.y2+1)
           return true
      end
    end
  end
  def end_game
    if @num_of_hearts == 0

      Window.remove(@sprite)
      Window.remove(@hitbox)
      @exist = false
      Text.new(
        'Game over',
        x: Window.width * 0.5 - 300,
        y: Window.height * 0.5,
        size: 50,
        color: 'black'
      )
      Text.new(
        'Points: ' + @points.to_s,
        x: Window.width * 0.5 - 300,
        y: Window.height * 0.5 + 60,
        size: 25,
        color: 'black'
      )
    end

  end

  def win_game
    Window.remove(@sprite)
    Window.remove(@hitbox)
    @exist = false
    Text.new(
      'Congratullation! Lvl finished!',
      x: Window.width * 0.5 - 300,
      y: Window.height * 0.5,
      size: 50,
      color: 'black'
    )
    Text.new(
      'Points: ' + @points.to_s,
      x: Window.width * 0.5 - 300,
      y: Window.height * 0.5 + 60,
      size: 25,
      color: 'black'
    )

    if @j == 100
      Window.close
    end

    @j = @j+1
  end

end
