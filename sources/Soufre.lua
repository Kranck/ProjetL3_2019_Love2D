TEXTUREDIR = "assets/textures/"
SRCDIR = "sources/"
require(SRCDIR.."Tile")

Soufre = Tile:New()
Soufre.sprite = love.graphics.newImage(TEXTUREDIR.."Sulfure_Block.png")
Soufre.__index = Soufre
Soufre.__type = "Soufre"

function Soufre:New()
    local this = {}
    this.img = love.graphics.newQuad(0, 0, 32, 32, Soufre.sprite:getDimensions())

    this.draw = function (x, y)
        love.graphics.draw(Soufre.sprite, this.img, x, y)
    end

    setmetatable(this, Soufre)
    return this
end

function Soufre:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end