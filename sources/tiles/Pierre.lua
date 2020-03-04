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

local function map_hp_block(hp)
    if hp == Pierre.hp then
        return 0
    end
    if hp > 3 then
        return 1
    end
    if hp > 2 then
        return 2
    end
    return 3
end

function Pierre:ChangeQuad(newNum, newHp)
    self.pdv = newHp or self.pdv
    self.img = love.graphics.newQuad(0, map_hp_block(self.pdv) * TILESIZE, TILESIZE, TILESIZE, Pierre.sprite:getDimensions())
end

function Pierre:Destroy()
    self.img = love.graphics.newImage(TEXTUREDIR.."destroyed.png")
    self.destroyed = true
end