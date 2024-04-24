let height = 0
function battlements () {
    move(12, 6, -9)
    wall("no", 7, 0, 0, 1, "Smooth Stone Slab")
    wall("left", 18, 0, 0, 1, "Smooth Stone Slab")
    wall("left", 15, 0, 0, 1, "Smooth Stone Slab")
    move(3, 0, 3)
    wall("left", 12, 0, 0, 1, "Smooth Stone Slab")
    builder.turn(LEFT_TURN)
    builder.teleportToOrigin()
}
function insideDefences () {
    move(5, 10, -6)
    for (let index = 0; index < 2; index++) {
        for (let index = 0; index < 5; index++) {
            builder.place(POLISHED_ANDESITE)
            builder.move(FORWARD, 2)
        }
        builder.turn(LEFT_TURN)
        for (let index = 0; index < 6; index++) {
            builder.place(POLISHED_ANDESITE)
            builder.move(FORWARD, 2)
        }
        builder.turn(LEFT_TURN)
    }
    builder.teleportToOrigin()
}
function insideCastle () {
    move(5, 0, -6)
    wall("no", 10, 0, 0, 10, "Stone Bricks")
    wall("left", 12, 0, 0, 10, "Stone Bricks")
    wall("left", 10, 0, 0, 10, "Stone Bricks")
    wall("left", 12, 0, 0, 10, "Stone Bricks")
    builder.turn(LEFT_TURN)
    builder.teleportToOrigin()
    move(5, 0, 1)
    builder.mark()
    move(0, 1, -2)
    builder.fill(AIR)
    move(0, 0, -2)
    builder.mark()
    move(0, 1, -2)
    builder.fill(WHITE_STAINED_GLASS_PANE)
    move(4, 0, -1)
    builder.mark()
    move(2, -1, 0)
    builder.fill(WHITE_STAINED_GLASS_PANE)
    move(4, 0, 5)
    builder.mark()
    move(0, 1, 2)
    builder.fill(WHITE_STAINED_GLASS_PANE)
    move(-4, 0, 5)
    builder.mark()
    move(-2, -1, 0)
    builder.fill(WHITE_STAINED_GLASS_PANE)
    move(-4, 0, -1)
    builder.mark()
    move(0, 1, -2)
    builder.fill(WHITE_STAINED_GLASS_PANE)
    move(0, 4, 0)
    builder.mark()
    move(0, 1, 2)
    builder.fill(WHITE_STAINED_GLASS_PANE)
    move(4, 0, 1)
    builder.mark()
    move(2, -1, 0)
    builder.fill(WHITE_STAINED_GLASS_PANE)
    move(4, 0, -5)
    builder.mark()
    move(0, 1, -2)
    builder.fill(WHITE_STAINED_GLASS_PANE)
    move(-4, 0, -5)
    builder.mark()
    move(-2, -1, 0)
    builder.fill(WHITE_STAINED_GLASS_PANE)
    move(-4, 0, 1)
    builder.mark()
    move(0, 1, 2)
    builder.fill(WHITE_STAINED_GLASS_PANE)
    builder.teleportToOrigin()
}
function inside_floor_roof () {
    move(6, 4, 5)
    builder.mark()
    move(8, 0, -10)
    builder.fill(PLANKS_BIRCH)
    move(0, 5, 0)
    builder.mark()
    move(-8, 0, 10)
    builder.fill(STONE_BRICKS)
    builder.teleportToOrigin()
}
function Gate () {
    builder.move(LEFT, 2)
    wall("no", 0, 0, 0, 3, "Iron Bars")
    wall("no", 0, 3, -4, 1, "Iron Bars")
    wall("no", 0, -3, 0, 1, "Iron Bars")
    builder.teleportToOrigin()
}
function wall (Direction: string, x: number, y: number, z: number, height: number, material: string) {
    if (Direction != "no") {
        if (Direction == "left") {
            builder.turn(LEFT_TURN)
        } else {
            builder.turn(RIGHT_TURN)
        }
    }
    builder.mark()
    builder.shift(x, y, z)
    builder.raiseWall(blocks.blockByName(material), height)
}
function insideStairs () {
    move(7, 0, 1)
    wall("no", 0, 0, -2, 1, "Smooth Stone Slab")
    move(1, 0, 0)
    wall("no", 0, 0, 2, 1, "Double Stone Slab")
    move(1, 1, 0)
    wall("no", 0, 0, -2, 1, "Smooth Stone Slab")
    move(1, 0, 0)
    wall("no", 0, 0, 2, 1, "Double Stone Slab")
    move(1, 1, 0)
    wall("no", 0, 0, -2, 1, "Smooth Stone Slab")
    move(1, 0, 0)
    wall("no", 0, 0, 2, 1, "Double Stone Slab")
    move(1, 1, 0)
    wall("no", 0, 0, -2, 1, "Smooth Stone Slab")
    move(1, 0, 0)
    wall("no", 0, 0, 2, 1, "Double Stone Slab")
    move(0, 1, 1)
    builder.place(SMOOTH_STONE_SLAB)
    move(0, 0, -4)
    builder.place(SMOOTH_STONE_SLAB)
    move(0, 0, 3)
    builder.mark()
    move(-4, 0, -2)
    builder.fill(AIR)
    builder.teleportToOrigin()
}
function stairs () {
    move(5, 0, -8)
    wall("no", 0, 0, 0, 1, "Smooth Stone Slab")
    move(0, 0, -1)
    height = 1
    for (let index = 0; index < 6; index++) {
        wall("no", 1, 0, 0, height, "Double Stone Slab")
        height += 1
    }
    move(0, 6, 0)
    wall("no", 0, 0, 0, 1, "Smooth Stone Slab")
    builder.teleportToOrigin()
}
function setPosition (x: number, y: number, z: number) {
    move(x, y, z)
    builder.setOrigin()
}
function bridge () {
    move(-9, -1, 1)
    wall("no", 0, 0, -2, 1, "Double Stone Slab")
    move(1, 1, 0)
    wall("no", 0, 0, 2, 1, "Smooth Stone Slab")
    move(1, 0, 0)
    wall("no", 0, 0, -2, 1, "Double Stone Slab")
    move(1, 1, 2)
    builder.mark()
    move(2, 0, -2)
    builder.fill(SMOOTH_STONE_SLAB)
    move(1, -1, 0)
    wall("no", 0, 0, 2, 1, "Double Stone Slab")
    move(1, 0, 0)
    wall("no", 0, 0, -2, 1, "Smooth Stone Slab")
    move(1, -1, 0)
    wall("no", 0, 0, 2, 1, "Double Stone Slab")
    builder.teleportToOrigin()
}
function Spawn () {
    builder.teleportTo(pos(0, 0, 0))
    builder.move(FORWARD, 6)
    builder.setOrigin()
}
function floor () {
    move(0, -1, 10)
    builder.mark()
    move(20, 0, -20)
    builder.fill(PLANKS_BIRCH)
    builder.teleportToOrigin()
}
function moat () {
    move(-6, -2, 16)
    builder.mark()
    move(2, 1, -32)
    builder.fill(WATER)
    move(30, -1, 0)
    builder.mark()
    move(-29, 1, 2)
    builder.fill(WATER)
    move(29, -1, 0)
    builder.mark()
    move(-2, 1, 30)
    builder.fill(WATER)
    move(-29, -1, 0)
    builder.mark()
    move(29, 1, -2)
    builder.fill(WATER)
    builder.teleportToOrigin()
}
function move (x: number, y: number, z: number) {
    builder.shift(x, y, z)
}
function towers (x: number, y: number, z: number) {
    move(x, y, z)
    wall("no", 3, 0, 0, 15, "Cobblestone")
    wall("no", 0, 0, -3, 15, "Cobblestone")
    wall("no", -3, 0, 0, 15, "Cobblestone")
    wall("no", 0, 0, 3, 15, "Cobblestone")
    move(-1, 14, 0)
    wall("no", 0, 0, -4, 3, "Cobblestone")
    wall("no", 5, 0, 0, 3, "Cobblestone")
    wall("no", 0, 0, 5, 3, "Cobblestone")
    wall("no", -5, 0, 0, 3, "Cobblestone")
    builder.teleportToOrigin()
}
function defences () {
    move(0, 7, -10)
    for (let index = 0; index < 4; index++) {
        for (let index = 0; index < 10; index++) {
            builder.place(POLISHED_ANDESITE)
            builder.move(FORWARD, 2)
        }
        builder.turn(LEFT_TURN)
    }
    builder.teleportToOrigin()
}
player.onChat("Castle", function () {
    Spawn()
    wall("right", 7, 0, 0, 7, "Cobblestone")
    for (let index = 0; index < 3; index++) {
        wall("left", 20, 0, 0, 7, "Cobblestone")
    }
    wall("left", 7, 0, 0, 7, "Cobblestone")
    move(0, 3, 0)
    wall("no", 5, 0, 0, 4, "Cobblestone")
    builder.turn(LEFT_TURN)
    builder.teleportToOrigin()
    setPosition(0, 0, 3)
    Gate()
    floor()
    defences()
    insideCastle()
    inside_floor_roof()
    insideDefences()
    moat()
    bridge()
    insideStairs()
    towers(0, 0, -7)
    towers(0, 0, 10)
    stairs()
    battlements()
})

