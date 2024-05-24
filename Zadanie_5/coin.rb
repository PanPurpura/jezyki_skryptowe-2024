require 'ruby2d'

class Coin
  def initialize(xpos, ypos)
    @xpos = xpos
    @ypos = ypos
    @exist = true
  end

  def draw
    @coin = Sprite.new(
      'tiles/Cherries.png',
      width: 36,
      height: 36,
      clip_width: 32,
      time: 50,
      x: @xpos,
      y: @ypos
    )

    @hitbox = Rectangle.new(
      x: @xpos+8,
      y: @ypos+9,
      color: [1, 0, 1, 0.0],
      height: 18,
      width: 20
      )
  end

  def collison_with_player(player)
    if @hitbox.x < player.get_hitbox.x + player.get_hitbox.size &&
      @hitbox.x + @hitbox.width > player.get_hitbox.x &&
      @hitbox.y < player.get_hitbox.y + player.get_hitbox.size &&
      @hitbox.y + @hitbox.height > player.get_hitbox.y

      return true
   end
      return false
  end

  def give_points(player)
    @coin.play
    if collison_with_player(player) == true && @exist == true && player.is_exist == true
      @exist = false
      Window.remove(@coin)
      Window.remove(@hitbox)
      player.set_points(player.get_points + 1)
    end
  end

  def get_sprite
    return @coin
  end


end
