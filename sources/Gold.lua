TEXTUREDIR = "assets/textures/"
SRCDIR = "sources/"
require(SRCDIR.."Tile")

TILESIZE = 32

Gold = Tile:New()
Gold.sprite = love.graphics.newImage(TEXTUREDIR.."Gold_Block.png")
Gold.__index = Gold
Gold.__type = "Gold"
Gold.hp = 7

function Gold:New()
    local this = {}
    this.img = love.graphics.newQuad(0, 0, TILESIZE, TILESIZE, Gold.sprite:getDimensions())

    this.draw = function (x, y)
        love.graphics.draw(Gold.sprite, this.img, x, y)
    end
    
    this.pdv = Gold.hp


    setmetatable(this, Gold)
    return this
end

function Gold:ChangeQuad(newNum, newHp)
    self.pdv = newHp or self.pdv
    self.img = love.graphics.newQuad(0, 0, TILESIZE, TILESIZE, Gold.sprite:getDimensions())
end

function Gold:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end