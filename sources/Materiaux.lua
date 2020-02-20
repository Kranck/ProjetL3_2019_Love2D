require("var")

Materiaux = {}
Materiaux.__index = Materiaux

function Materiaux:New(type, x_index, y_index)
    local this = {}
    setmetatable(this, Materiaux)
    this.x_index = x_index
    this.y_index = y_index
    this.type = type -- Terre, Pierre, Fer, Souffre, Gold
    this.img = nil
    if this.type=="Terre" then
        this.img = love.graphics.newImage(TEXTUREDIR.."Earth_Block_Fallen.png")
    end
    if this.type=="Pierre" then
        this.img = love.graphics.newImage(TEXTUREDIR.."Stone_Block_Fallen.png") 
    end
    if this.type=="Fer" then
        this.img = love.graphics.newImage(TEXTUREDIR.."Iron_Block_Fallen.png")
    end
    if this.type=="Souffre" then
        this.img = love.graphics.newImage(TEXTUREDIR.."Sulfure_Block_Fallen.png")
    end
    if this.type=="Gold" then
        this.img = love.graphics.newImage(TEXTUREDIR.."Gold_Block_Fallen.png")
    end

    this.draw = function ()
        love.graphics.draw(this.img, (this.x_index-1)*TILESIZE, (this.y_index-1)*TILESIZE)
    end

    return this
end
