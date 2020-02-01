TEXTUREDIR = "assets/textures/"
SRCDIR = "sources/"
require(SRCDIR.."Tile")

Gold = Tile:New()
Gold.sprite = love.graphics.newImage(TEXTUREDIR.."Gold_Block.png")
Gold.__index = Gold
Gold.__type = "Gold"

function Gold:New()
    local this = {}
    this.img = love.graphics.newQuad(0, 0, 32, 32, Gold.sprite:getDimensions())

    this.draw = function (x, y)
        love.graphics.draw(Gold.sprite, this.img, x, y)
    end
    
    this.pdv = 7


    setmetatable(this, Gold)
    return this
end

function Gold:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end