let height = 0
function battlements () {
    move(8, 6, -9)
    wall("no", 11, 0, 0, 1, "Smooth Stone Slab")
    wall("left", 18, 0, 0, 1, "Smooth Stone Slab")
    wall("left", 18, 0, 0, 1, "Smooth Stone Slab")
    wall("left", 18, 0, 0, 1, "Smooth Stone Slab")
    builder.turn(LEFT_TURN)
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
function stairs () {
    move(1, 0, -8)
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
function move (x: number, y: number, z: number) {
    builder.shift(x, y, z)
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
    stairs()
    battlements()
    floor()
    defences()
})