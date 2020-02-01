TEXTUREDIR = "assets/textures/"
SRCDIR = "sources/"
require(SRCDIR.."Tile")

Sable = Tile:New()
Sable.sprite = love.graphics.newImage(TEXTUREDIR.."Sand_Block.png")
Sable.__index = Sable
Sable.__type = "Sable"

function Sable:New()
    local this = {}
    this.img = love.graphics.newQuad(0, 0, 32, 32, Sable.sprite:getDimensions())

    this.draw = function (x, y)
        love.graphics.draw(Sable.sprite, this.img, x, y)
    end

    setmetatable(this, Sable)
    return this
end

function Sable:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end