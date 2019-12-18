require("Tile")

Terre = Tile:New()
Terre.__index = Terre

function Terre:New()
    local this = {}
    this.img = love.graphics.newImage("tile_0.png")
    setmetatable(this, Terre)
    return this
end

function Terre:Destroy()
    self.img = love.graphics.newImage("destroyed.png")
    self.destroyed = true
end