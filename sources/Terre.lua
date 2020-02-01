TEXTUREDIR = "assets/textures/"
SRCDIR = "sources/"
require(SRCDIR.."Tile")

Terre = Tile:New()
Terre.__index = Terre
Terre.sprite = love.graphics.newImage(TEXTUREDIR.."Earth_Block.png")

function Terre:New(num)
    local dx = num
    local this = {}
    -- choosing base eath representation in the sprite
    this.img = love.graphics.newQuad(dx * 32, 0, 32, 32, Terre.sprite:getDimensions())

    this.pdv = 3

    this.draw = function (x, y)
        love.graphics.draw(Terre.sprite, this.img, x, y)
    end

    setmetatable(this, Terre)
    return this
end

function Terre:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end