require 'ruby2d'

class Enemy
  def initialize(xpos, ypos)
    @xpos = xpos
    @ypos = ypos
    @x_velocity = -1.5
    @exist = true
  end

  def draw
      @enemy = Sprite.new(
        'tiles/Walk (36x30).png',
        width: 72,
        height: 60,
        clip_width: 36,
        time: 50,
        x: @xpos,
        y: @ypos
      )

      @hitbox = Rectangle.new(
        x: @xpos+10,
        y: @ypos+2,
        color: [1, 0, 1, 0.0],
        height: 52,
        width: 54
        )
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

  def ch_move(world)
    if is_colliding_left(world) || @enemy.x < 0
      @enemy.play flip: :horizontal
      @x_velocity = -@x_velocity
    end
    if is_colliding_right(world) || @enemy.x > (Window.width-@enemy.width)
      @x_velocity = -@x_velocity
    end
  end

  def move(world, player)
    collison_with_player(player,world)
    ch_move(world)
    @enemy.play
    @enemy.x += @x_velocity
    @hitbox.x += @x_velocity
  end

  def collison_with_player(player, world)
    if @hitbox.x < player.get_hitbox.x + player.get_hitbox.size &&
         @hitbox.x + @hitbox.width > player.get_hitbox.x &&
         @hitbox.y < player.get_hitbox.y + player.get_hitbox.size &&
         @hitbox.y + @hitbox.height > player.get_hitbox.y

       if (@hitbox.contains?(player.get_hitbox.x4+35, player.get_hitbox.y4) ||
          player.get_hitbox.contains?(@hitbox.x1+35, @hitbox.y1)) &&
          player.is_exist == true

          @exist = false
          Window.remove(@enemy)
          Window.remove(@hitbox)

       end

       if @exist == true && player.get_num_of_hearts > 0
         player.set_x_velocity(-3)
         player.set_num_of_hearts(player.get_num_of_hearts-1)
       end
       if player.get_num_of_hearts == 0
         player.end_game
       end


    end
  end


end
