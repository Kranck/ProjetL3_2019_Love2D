TEXTUREDIR = "assets/textures/"
SRCDIR = "sources/"
require(SRCDIR.."Tile")

Pierre = Tile:New()
Pierre.__index = Pierre

function Pierre:New()
    local this = {}
    this.img = love.graphics.newImage(TEXTUREDIR.."Stone_Block.png")
    this.pdv = 5
    setmetatable(this, Pierre)
    return this
end

function Pierre:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end