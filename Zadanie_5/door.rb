require 'ruby2d'

class Door
  def initialize(xpos, ypos)
    @xpos = xpos
    @ypos = ypos
  end

  def draw
    @spike = Sprite.new(
      'tiles/door.png',
      width: 54,
      height: 54,
      clip_width: 18,
      time: 50,
      x: @xpos,
      y: @ypos
      )
    @hitbox = Rectangle.new(
      x: @xpos,
      y: @ypos,
      color: [1, 0, 1, 0.0],
      height: 54,
      width: 54
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

  def next_lvl(player_hitbox, player)
    if collison_with_player(player_hitbox) == true
      player.win_game
    end
  end

end
