TEXTUREDIR = "assets/textures/"
SRCDIR = "sources/"
require(SRCDIR.."Tile")

Cuivre = Tile:New()
Cuivre.__index = Cuivre

function Cuivre:New()
    local this = {}
    this.img = love.graphics.newImage(TEXTUREDIR.."Copper_Block.png")
    setmetatable(this, Cuivre)
    return this
end

function Cuivre:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end