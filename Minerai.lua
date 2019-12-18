require("Tile")

Minerai = Tile:New()
Minerai.__index = Minerai

function Minerai:New()
    local this = {}
    this.img = love.graphics.newImage("tile_1.png")
    setmetatable(this, Minerai)
    return this
end

function Minerai:Destroy()
    self.img = love.graphics.newImage("destroyed.png")
    self.destroyed = true
end