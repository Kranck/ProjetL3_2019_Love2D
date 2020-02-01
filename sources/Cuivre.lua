TEXTUREDIR = "assets/textures/"
SRCDIR = "sources/"
require(SRCDIR.."Tile")

TILESIZE = 32

Cuivre = Tile:New()
Cuivre.sprite = love.graphics.newImage(TEXTUREDIR.."Copper_Block.png")
Cuivre.__index = Cuivre
Cuivre.__type = "Cuivre"
Cuivre.hp = 7

function Cuivre:New()
    local this = {}
    this.img = love.graphics.newQuad(0, 0, TILESIZE, TILESIZE, Cuivre.sprite:getDimensions())

    this.draw = function (x, y)
        love.graphics.draw(Cuivre.sprite, this.img, x, y)
    end
    
    this.pdv = Cuivre.hp


    setmetatable(this, Cuivre)
    return this
end

function Cuivre:ChangeQuad(newNum, newHp)
    self.dx = newNum or self.dx
    self.pdv = newHp or self.pdv
    self.img = love.graphics.newQuad(self.dx * TILESIZE, (Cuivre.hp - self.pdv) * TILESIZE , TILESIZE, TILESIZE, Cuivre.sprite:getDimensions())
end

function Cuivre:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end