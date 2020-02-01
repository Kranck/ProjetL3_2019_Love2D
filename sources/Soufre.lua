TEXTUREDIR = "assets/textures/"
SRCDIR = "sources/"
require(SRCDIR.."Tile")

TILESIZE = 32

Soufre = Tile:New()
Soufre.sprite = love.graphics.newImage(TEXTUREDIR.."Sulfure_Block.png")
Soufre.__index = Soufre
Soufre.__type = "Soufre"
Soufre.hp = 7

function Soufre:New()
    local this = {}
    this.img = love.graphics.newQuad(0, 0, TILESIZE, TILESIZE, Soufre.sprite:getDimensions())

    this.draw = function (x, y)
        love.graphics.draw(Soufre.sprite, this.img, x, y)
    end
    
    this.pdv = Soufre.hp


    setmetatable(this, Soufre)
    return this
end

function Soufre:ChangeQuad(newNum, newHp)
    self.pdv = newHp or self.pdv
    self.img = love.graphics.newQuad(0, 0, TILESIZE, TILESIZE, Soufre.sprite:getDimensions())
end

function Soufre:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end