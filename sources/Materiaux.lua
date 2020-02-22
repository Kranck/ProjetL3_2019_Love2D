require("var")

Materiaux = {}
Materiaux.__index = Materiaux

function Materiaux:New(type, x_index, y_index, terrain)
    local this = {}
    setmetatable(this, Materiaux)
    this.posX = (x_index-1)*TILESIZE
    this.posY = (y_index-1)*TILESIZE
    this.type = type -- Terre, Pierre, Fer, Souffre, Gold
    this.terrain = terrain
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
        love.graphics.draw(this.img, this.posX, this.posY)
    end

    this.isGrounded = function ()
        actualPositionY = this.posY
        nextPositionY = actualPositionY + 4
        xPositionMin = math.floor(((this.posX+1)/TILESIZE)+1)
        xPositionMax = math.floor(((this.posX+(TILESIZE-1))/TILESIZE)+1)
        yPositionMax = math.floor(((nextPositionY+(TILESIZE-1))/TILESIZE)+1)
        if (this.terrain.map_bloc[yPositionMax][xPositionMin])~=nil or (this.terrain.map_bloc[yPositionMax][xPositionMax])~=nil then
            return true
        end
        return false
    end

    return this
end
