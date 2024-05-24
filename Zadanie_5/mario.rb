require 'ruby2d'
require './character'
require './spikes'
require './door'
require './coin'
require './enemy'

set title: "Mario2D"
set background: "navy"
set width: 1344, height: 720
set borderless: false

@char = Character.new
@spikes = Spikes.new(540, 667)
@spikes1 = Spikes.new(720, 667)
@door = Door.new(1285, 505)
@coin = Coin.new(736, 567)
@coin1 = Coin.new(558, 567)
@enemy = Enemy.new(1080, 505)

@tilesetBackgrounds = Ruby2D::Tileset.new('tilemap-backgrounds-24x24.png', spacing: 1, tile_width: 24, tile_height: 24, scale: 3)
@tilesetMap = Ruby2D::Tileset.new('tilemap.png', spacing: 1, tile_width: 18, tile_height: 18, scale: 3)
@tilesetCharacter = Ruby2D::Tileset.new('tilemap-characters.png', spacing: 1, tile_width: 24, tile_height: 25, scale: 3)

@tilesetMap.define_tile('fullHeart', 4, 2)
@tilesetMap.define_tile('emptyHeart', 6, 2)

@tilesetBackgrounds.define_tile('sky', 0, 0)
@tilesetBackgrounds.define_tile('sky1', 0, 2)
@tilesetBackgrounds.define_tile('ground1', 0, 1)
@tilesetBackgrounds.define_tile('ground2', 1, 1)
@tilesetBackgrounds.define_tile('ground3', 2, 1)
@tilesetBackgrounds.define_tile('ground4', 3, 1)

@tilesetMap.define_tile('floor1', 7, 2)
@tilesetMap.define_tile('floor2', 2, 0)
@tilesetMap.define_tile('floor3', 3, 0)


@coordsSky = []
@coordsSky1 = []
@coordGround1 = []
@coordGround2 = []
@coordGround3 = []
@coordGround4 = []

@x_coord = 0
@y_coord = 0

while @y_coord < 720
  if @y_coord < 360
    while @x_coord < 1344
      @coord = { x: @x_coord, y: @y_coord }
      @coordsSky.push(@coord)
      @x_coord = @x_coord + 72
    end
  elsif @y_coord == 360
    @local = 0
    while @x_coord < 1344
      if @local == 0
        @coordGround1.push({ x: @x_coord, y: @y_coord })
        @local = 1
      elsif @local == 1
        @coordGround2.push({ x: @x_coord, y: @y_coord })
        @local = 2
      elsif @local == 2
        @coordGround3.push({ x: @x_coord, y: @y_coord })
        @local = 3
      else
        @coordGround4.push({ x: @x_coord, y: @y_coord })
        @local = 0
      end
      @x_coord = @x_coord + 72
    end
  else
    while @x_coord < 1344
      @coord = { x: @x_coord, y: @y_coord }
      @coordsSky1.push(@coord)
      @x_coord = @x_coord + 72
    end
  end

  @y_coord = @y_coord + 72
  @x_coord = 0
end

@floor = []
@y_coord = 667
while @x_coord < 1344
  if @x_coord == 540 || @x_coord == 720
    @x_coord = @x_coord + 72
  end
  if @x_coord == 900 || @x_coord == 954
    @y_coord = @y_coord - 54
  end
  @floor.push({x: @x_coord, y: @y_coord})
  @x_coord = @x_coord + 54
end
@floor.push({x: 250, y: 613})
@floor.push({x: 304, y: 613})
@floor.push({x: 304, y: 559})
@floor.push({x: 358, y: 613})
@floor.push({x: 900, y: 667})
@floor.push({x: 954, y: 613})
@floor.push({x: 954, y: 505})

@tilesetBackgrounds.set_tile('sky', @coordsSky)
@tilesetBackgrounds.set_tile('sky1', @coordsSky1)
@tilesetBackgrounds.set_tile('ground1', @coordGround1)
@tilesetBackgrounds.set_tile('ground2', @coordGround2)
@tilesetBackgrounds.set_tile('ground3', @coordGround3)
@tilesetBackgrounds.set_tile('ground4', @coordGround4)
@tilesetMap.set_tile('floor1', @floor)

@tilesetMap.set_tile('fullHeart', [ {x:20, y:20}, {x:70, y:20}, {x:120, y:20}])



@worldHitboxes = []

@i = 0
while @i < @floor.count
  @worldHitboxes.push(Square.new(x: @floor[@i][:x], y: @floor[@i][:y], color: [1, 0, 1, 0.4], size: 54))
  @i = @i + 1
end

def heart_display
  @tilesetMap.clear_tiles
  @tilesetMap.set_tile('floor1', @floor)
  if @char.get_num_of_hearts == 3
    @tilesetMap.set_tile('fullHeart', [ {x:20, y:20}, {x:70, y:20}, {x:120, y:20}])
  elsif @char.get_num_of_hearts == 2
    @tilesetMap.set_tile('fullHeart', [ {x:20, y:20}, {x:70, y:20} ])
    @tilesetMap.set_tile('emptyHeart', [ {x:120, y:20} ])
  elsif @char.get_num_of_hearts == 1
    @tilesetMap.set_tile('fullHeart', [ {x:20, y:20} ])
    @tilesetMap.set_tile('emptyHeart', [ {x:70, y:20}, {x:120, y:20} ])
  elsif @char.get_num_of_hearts == 0
    @tilesetMap.set_tile('emptyHeart', [ {x:20, y:20}, {x:70, y:20}, {x:120, y:20}])
  end
end


@char.draw
@spikes.draw
@spikes1.draw
@door.draw
@coin.draw
@coin1.draw
@enemy.draw

update do
  heart_display
  @char.playerGravity(@worldHitboxes)
  @char.change_move(@worldHitboxes)
  @char.move
  @spikes.modify_velocity(@char, @char.get_hitbox)
  @spikes1.modify_velocity(@char, @char.get_hitbox)
  @coin.give_points(@char)
  @coin1.give_points(@char)
  @door.next_lvl(@char.get_hitbox, @char)
  @enemy.move(@worldHitboxes, @char)
end

show
