require('var')

require(SRCDIR.."Tile")

TILESIZE = 32

Fer = Tile:New()
Fer.sprite = love.graphics.newImage(TEXTUREDIR.."Iron_Block.png")
Fer.fallen = love.graphics.newImage(TEXTUREDIR.."Iron_Block_Fallen.png")
Fer.__index = Fer
Fer.__type = "Fer"
Fer.hp = 7

function Fer:New()
    local this = {}
    this.img = love.graphics.newQuad(0, 0, TILESIZE, TILESIZE, Fer.sprite:getDimensions())
    this.type = "Fer"
    this.draw = function (x, y)
        love.graphics.draw(Fer.sprite, this.img, x, y)
    end
    
    this.pdv = Fer.hp


    setmetatable(this, Fer)
    return this
end

function Fer:ChangeQuad(newNum, newHp)
    self.pdv = newHp or self.pdv
    self.img = love.graphics.newQuad(0, 0, TILESIZE, TILESIZE, Fer.sprite:getDimensions())
end

function Fer:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end