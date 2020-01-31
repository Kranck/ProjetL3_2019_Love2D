TEXTUREDIR = "assets/textures/"
SRCDIR = "sources/"
require(SRCDIR.."Tile")

Gold = Tile:New()
Gold.__index = Gold

function Gold:New()
    local this = {}
    this.img = love.graphics.newImage(TEXTUREDIR.."Gold_Block.png")
    this.pdv = 7
    setmetatable(this, Gold)
    return this
end

function Gold:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end