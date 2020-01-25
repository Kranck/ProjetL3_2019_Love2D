TEXTUREDIR = "assets/textures/"
SRCDIR = "sources/"
require(SRCDIR.."Tile")

Sable = Tile:New()
Sable.__index = Sable

function Sable:New()
    local this = {}
    this.img = love.graphics.newImage(TEXTUREDIR.."Sand_Block.png")
    setmetatable(this, Sable)
    return this
end

function Sable:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end