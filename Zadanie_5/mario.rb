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
@door = Door.new(1285, 505)

@tilesetBackgrounds = Ruby2D::Tileset.new('tiles/tilemap-backgrounds-24x24.png', spacing: 1, tile_width: 24, tile_height: 24, scale: 3)
@tilesetMap = Ruby2D::Tileset.new('tiles/tilemap.png', spacing: 1, tile_width: 18, tile_height: 18, scale: 3)

@coordsSky = []
@coordsSky1 = []
@coordGround1 = []
@coordGround2 = []
@coordGround3 = []
@coordGround4 = []
@floor = []
@spike = []
@enemies = []
@coins = []

@tilesetMap.define_tile('fullHeart', 4, 2)
@tilesetMap.define_tile('emptyHeart', 6, 2)

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



def read_from_file(file)
  i = 1
  local = 0
  File.foreach(file) { |line|
    arr = line.split
    if i <= 6
      @tilesetBackgrounds.define_tile(arr.at(0), arr.at(1).to_i, arr.at(2).to_i)
    elsif i == 7
      @tilesetMap.define_tile(arr.at(0), arr.at(1).to_i, arr.at(2).to_i)
    else
      if arr.at(0) == 'sky'
        @coordsSky.push({ x: arr.at(1).to_i, y: arr.at(2).to_i })
      elsif arr.at(0) == 'ground1'
        @coordGround1.push({ x: arr.at(1).to_i, y: arr.at(2).to_i })
      elsif arr.at(0) == 'ground2'
        @coordGround2.push({ x: arr.at(1).to_i, y: arr.at(2).to_i })
      elsif arr.at(0) == 'ground3'
        @coordGround3.push({ x: arr.at(1).to_i, y: arr.at(2).to_i })
      elsif arr.at(0) == 'ground4'
        @coordGround4.push({ x: arr.at(1).to_i, y: arr.at(2).to_i })
      elsif arr.at(0) == 'sky1'
        @coordsSky1.push({ x: arr.at(1).to_i, y: arr.at(2).to_i })
      elsif arr.at(0) == 'floor1'
        @floor.push({ x: arr.at(1).to_i, y: arr.at(2).to_i })
      elsif arr.at(0) == 'spike'
        @spike.push( Spikes.new( arr.at(1).to_i, arr.at(2).to_i ) )
      elsif arr.at(0) == 'enemy'
        @enemies.push( Enemy.new( arr.at(1).to_i, arr.at(2).to_i ) )
      elsif arr.at(0) == 'coin'
        @coins.push( Coin.new( arr.at(1).to_i, arr.at(2).to_i ) )
      end
    end

    i  = i  + 1

  }
end

ARGV.each do |a|
  read_from_file(a)
end

@tilesetBackgrounds.set_tile('sky', @coordsSky)
@tilesetBackgrounds.set_tile('sky1', @coordsSky1)
@tilesetBackgrounds.set_tile('ground1', @coordGround1)
@tilesetBackgrounds.set_tile('ground2', @coordGround2)
@tilesetBackgrounds.set_tile('ground3', @coordGround3)
@tilesetBackgrounds.set_tile('ground4', @coordGround4)
@tilesetMap.set_tile('floor1', @floor)

@worldHitboxes = []

@i = 0
while @i < @floor.count
  @worldHitboxes.push(Square.new(x: @floor[@i][:x], y: @floor[@i][:y], color: [1, 0, 1, 0.0], size: 54))
  @i = @i + 1
end


@char.draw
@door.draw

@spike.each { |event|
  event.draw
}
@enemies.each { |event|
  event.draw
}
@coins.each { |event|
  event.draw
}
update do
  heart_display
  @char.playerGravity(@worldHitboxes)
  @char.change_move(@worldHitboxes)
  @char.move
  @door.next_lvl(@char.get_hitbox, @char)

  @spike.each { |event|
    event.modify_velocity(@char, @char.get_hitbox)
  }
  @enemies.each { |event|
    event.move(@worldHitboxes, @char)
  }
  @coins.each { |event|
    event.give_points(@char)
  }
end

show
