TEXTUREDIR = "assets/textures/"
SRCDIR = "sources/"
require(SRCDIR.."Tile")

Soufre = Tile:New()
Soufre.__index = Soufre

function Sou
fre:New()
    local this = {}
    this.img = love.graphics.newImage(TEXTUREDIR.."Sulfure_Block.png")
    setmetatable(this, Sou
fre)
    return this
end

function Sou
fre:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end