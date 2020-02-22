require("var")

Materiaux = {}
Materiaux.__index = Materiaux

-- Vitesse en l'air
local AIRSPEED = 1.8

-- Accélération de chute
local GRAVITY = 0.15

-- Vitesse de chute maximale
local MAX_SPEED_FALLING = 3.4

function Materiaux:New(type, x_index, y_index, terrain)
    local this = {}
    setmetatable(this, Materiaux)
    this.posX = (x_index-1)*TILESIZE
    this.posY = (y_index-1)*TILESIZE
    this.type = type -- Terre, Pierre, Fer, Souffre, Gold
    this.terrain = terrain
    this.img = nil
    this.Yspeed=0
    this.Yacc=GRAVITY

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

    this.MoveTo = function (x, y)
        local actualPositionX = this.posX
        local actualPositionY = this.posY
        local nextPositionX = actualPositionX+x
        local nextPositionY = actualPositionY+y

        local xPositionMin = math.floor(((nextPositionX+1)/TILESIZE)+1)
        local xPositionMax = math.floor(((nextPositionX+(TILESIZE-1))/TILESIZE)+1)
        local yPositionMin = math.floor(((nextPositionY+1)/TILESIZE)+1)
        local yPositionMax = math.floor(((nextPositionY+(TILESIZE-1))/TILESIZE)+1)

        if nextPositionX < 0 then
            nextPositionX = 0
        end

        if nextPositionX > 79*TILESIZE then
            nextPositionX = 79*TILESIZE
        end

        if nextPositionY < 0 then
            nextPositionY = 0
        end

        if nextPositionY > 44*TILESIZE then
            nextPositionY = 44*TILESIZE
        end

        if yPositionMax > 45 or xPositionMax > 80 then
            return
        end

        if (this.terrain.map_bloc[yPositionMin][xPositionMin]==nil)
        and (this.terrain.map_bloc[yPositionMax][xPositionMin]==nil)
        and (this.terrain.map_bloc[yPositionMin][xPositionMax]~=nil)
        and (this.terrain.map_bloc[yPositionMax][xPositionMax]~=nil) then
            this.posX = xPositionMin*TILESIZE-TILESIZE
        end

        if (this.terrain.map_bloc[yPositionMin][xPositionMin]~=nil)
        and (this.terrain.map_bloc[yPositionMax][xPositionMin]~=nil)
        and (this.terrain.map_bloc[yPositionMin][xPositionMax]==nil)
        and (this.terrain.map_bloc[yPositionMax][xPositionMax]==nil) then
            this.posX = xPositionMax*TILESIZE-TILESIZE
        end

        if (this.terrain.map_bloc[yPositionMax][xPositionMin]~=nil)
        and (this.terrain.map_bloc[yPositionMax][xPositionMax]~=nil)
        and (this.terrain.map_bloc[yPositionMin][xPositionMax]==nil)
        and (this.terrain.map_bloc[yPositionMin][xPositionMin]==nil) then
            this.posY = yPositionMin*TILESIZE-TILESIZE
        end

        if (this.terrain.map_bloc[yPositionMin][xPositionMin]==nil)
        and (this.terrain.map_bloc[yPositionMax][xPositionMin]==nil)
        and (this.terrain.map_bloc[yPositionMin][xPositionMax]==nil)
        and (this.terrain.map_bloc[yPositionMax][xPositionMax]==nil) then
            this.posX = nextPositionX
            this.posY = nextPositionY
        end
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

    this.Move = function (grounded)
        this.Yspeed = this.Yspeed + this.Yacc
    
        -- On limite les vitesses
        if this.Yspeed > MAX_SPEED_FALLING then
            this.Yspeed = MAX_SPEED_FALLING
        end
    
        -- On applique le déplacement 
    
        this.MoveTo(0, math.floor(this.Yspeed))
    
        -- On draw le personnage
        this.draw()
    
        if grounded then
            -- On stop le mouvement au sol
            return
        end
    end

    return this
end
