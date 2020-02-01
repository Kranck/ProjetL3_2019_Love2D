require("var")
require(SRCDIR.."Tile")

Sable = Tile:New()
Sable.sprite = love.graphics.newImage(TEXTUREDIR.."Sand_Block.png")
Sable.__index = Sable
Sable.__type = "Sable"
Sable.hp = 3

function Sable:New()
    local this = {}
    this.img = love.graphics.newQuad(0, 0, TILESIZE, TILESIZE, Sable.sprite:getDimensions())

    this.draw = function (x, y)
        love.graphics.draw(Sable.sprite, this.img, x, y)
    end
    
    this.pdv = Sable.hp


    setmetatable(this, Sable)
    return this
end

function Sable:ChangeQuad(newNum, newHp)
    self.pdv = newHp or self.pdv
    self.img = love.graphics.newQuad(0, 0, TILESIZE, TILESIZE, Sable.sprite:getDimensions())
end

function Sable:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end