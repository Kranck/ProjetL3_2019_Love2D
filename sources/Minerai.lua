TEXTUREDIR = "assets/textures/"
SRCDIR = "sources/"
require(SRCDIR.."Tile")

Minerai = Tile:New()
Minerai.__index = Minerai

function Minerai:New()
    local this = {}
    this.img = love.graphics.newImage(TEXTUREDIR.."tile_1.png")
    setmetatable(this, Minerai)
    return this
end

function Minerai:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end