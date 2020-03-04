require("var")
require(SRCDIR.."Tile")

Pierre = Tile:New()
Pierre.sprite = love.graphics.newImage(TEXTUREDIR.."Stone_Block.png")
Pierre.fallen = love.graphics.newImage(TEXTUREDIR.."Stone_Block_Fallen.png")
Pierre.__index = Pierre
Pierre.hp = 5

function Pierre:New()
    local this = {}
    this.img = love.graphics.newQuad(0, 0, TILESIZE, TILESIZE, Pierre.sprite:getDimensions())

    this.draw = function (x, y)
        love.graphics.draw(Pierre.sprite, this.img, x, y)
    end
    this.type = "Pierre"
    this.pdv = Pierre.hp

    setmetatable(this, Pierre)
    return this
end

function Pierre:ChangeQuad(newNum, newHp)
    self.pdv = newHp or self.pdv
    self.img = love.graphics.newQuad(0, 0 , TILESIZE, TILESIZE, Pierre.sprite:getDimensions())
end

function Pierre:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end