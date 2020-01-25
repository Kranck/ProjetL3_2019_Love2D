TEXTUREDIR = "assets/textures/"
SRCDIR = "sources/"
require(SRCDIR.."Tile")

Terre = Tile:New()
Terre.__index = Terre

function Terre:New()
    local this = {}
    this.img = love.graphics.newImage(TEXTUREDIR.."Earth_Block.png")
    setmetatable(this, Terre)
    return this
end

function Terre:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end