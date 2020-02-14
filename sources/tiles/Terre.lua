require("var")
require(SRCDIR.."Tile")


Terre = Tile:New()
Terre.__index = Terre
Terre.__type = "Terre"
Terre.sprite = love.graphics.newImage(TEXTUREDIR.."Earth_Block.png")
Terre.hp = 3

function Terre:New(num)
    
    local this = {}
    -- choosing base eath representation in the sprite
    this.dx = num or 0
    this.img = love.graphics.newQuad(this.dx * TILESIZE, 0, TILESIZE, TILESIZE, Terre.sprite:getDimensions())

    this.pdv = Terre.hp

    this.draw = function (x, y)
        love.graphics.draw(Terre.sprite, this.img, x, y)
    end

    setmetatable(this, Terre)
    return this
end

function Terre:ChangeQuad(newNum, newHp)
    self.dx = newNum or self.dx
    self.pdv = newHp or self.pdv
    self.img = love.graphics.newQuad(self.dx * TILESIZE, (Terre.hp - self.pdv) * TILESIZE , TILESIZE, TILESIZE, Terre.sprite:getDimensions())
end

function Terre:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end