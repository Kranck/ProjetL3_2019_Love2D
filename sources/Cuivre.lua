TEXTUREDIR = "assets/textures/"
SRCDIR = "sources/"
require(SRCDIR.."Tile")

Cuivre = Tile:New()
Cuivre.sprite = love.graphics.newImage(TEXTUREDIR.."Copper_Block.png")
Cuivre.__index = Cuivre

function Cuivre:New()
    local this = {}
    this.img = love.graphics.newQuad(0, 0, 32, 32, Cuivre.sprite:getDimensions())

    this.draw = function (x, y)
        love.graphics.draw(Cuivre.sprite, this.img, x, y)
    end

    setmetatable(this, Cuivre)
    return this
end

function Cuivre:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end