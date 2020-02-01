TEXTUREDIR = "assets/textures/"
SRCDIR = "sources/"
require(SRCDIR.."Tile")

Pierre = Tile:New()
Pierre.sprite = love.graphics.newImage(TEXTUREDIR.."Stone_Block.png")
Pierre.__index = Pierre

function Pierre:New()
    local this = {}
    this.img = love.graphics.newQuad(0, 0, 32, 32, Pierre.sprite:getDimensions())

    this.draw = function (x, y)
        love.graphics.draw(Pierre.sprite, this.img, x, y)
    end

    this.pdv = 5
    setmetatable(this, Pierre)
    return this
end

function Pierre:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end