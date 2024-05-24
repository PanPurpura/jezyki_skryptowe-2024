require 'ruby2d'

class Spikes
  def initialize(xpos, ypos)
    @xpos = xpos
    @ypos = ypos
    @end = 0
  end

  def draw
    @spike = Sprite.new(
      'tiles/spike.png',
      width: 72,
      height: 54,
      clip_width: 18,
      time: 50,
      x: @xpos,
      y: @ypos
      )
    @hitbox = Rectangle.new(
      x: @xpos,
      y: @ypos+27,
      color: [1, 0, 1, 0.0],
      height: 29,
      width: 72
      )

  end

  def collison_with_player(player_hitbox)
    if @hitbox.x < player_hitbox.x + player_hitbox.size &&
       @hitbox.x + @hitbox.width > player_hitbox.x &&
       @hitbox.y < player_hitbox.y + player_hitbox.size &&
       @hitbox.y + @hitbox.height > player_hitbox.y

       return true
    end
    return false
  end

  def modify_velocity(player, player_hitbox)
    if collison_with_player(player_hitbox) == true && player.is_exist == true
      player.set_y_velocity(-20)
      player.set_num_of_hearts(player.get_num_of_hearts-1)
      if player.get_num_of_hearts == 0
        player.end_game
      end
    end

    if player.is_exist == false
      @end = @end+1
      if @end == 100
        Window.close
      end
    end
  end

end
