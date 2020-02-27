require("var")

Materiaux = {}
Materiaux.__index = Materiaux

require(TILESDIR.."Terre")
require(TILESDIR.."Pierre")
require(TILESDIR.."Fer")
require(TILESDIR.."Soufre")
require(TILESDIR.."Gold")

function Materiaux:New(type, x_index, y_index, terrain)
    local this = {}
    setmetatable(this, Materiaux)
    this.posX = (x_index-1)*TILESIZE
    this.posY = (y_index-1)*TILESIZE
    this.type = type -- Terre, Pierre, Fer, Souffre, Gold
    this.terrain = terrain
    this.img = nil
    this.Yspeed = 0
    this.Yacc = GRAVITY

    if this.type == "Terre" then
        this.img = Terre.fallen
    elseif this.type == "Pierre" then
        this.img = Pierre.fallen
    elseif this.type == "Fer" then
        this.img = Fer.fallen
    elseif this.type == "Souffre" then
        this.img = Soufre.fallen
    elseif this.type == "Gold" then
        this.img = Gold.fallen
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

        if (this.terrain.getBlock(xPositionMin, yPositionMin) == nil)
        and (this.terrain.getBlock(xPositionMin, yPositionMax) == nil)
        and (this.terrain.getBlock(xPositionMax, yPositionMin) ~= nil)
        and (this.terrain.getBlock(xPositionMax, yPositionMax) ~= nil) then
            this.posX = xPositionMin*TILESIZE-TILESIZE
        end

        if (this.terrain.getBlock(xPositionMin, yPositionMin) ~= nil)
        and (this.terrain.getBlock(xPositionMin, yPositionMax) ~= nil)
        and (this.terrain.getBlock(xPositionMax, yPositionMin) == nil)
        and (this.terrain.getBlock(xPositionMax, yPositionMax) == nil) then
            this.posX = xPositionMax*TILESIZE-TILESIZE
        end

        if (this.terrain.getBlock(xPositionMin, yPositionMax) ~= nil)
        and (this.terrain.getBlock(xPositionMax, yPositionMax) ~= nil)
        and (this.terrain.getBlock(xPositionMax, yPositionMin) == nil)
        and (this.terrain.getBlock(xPositionMin, yPositionMin) == nil) then
            this.posY = yPositionMin*TILESIZE-TILESIZE
        end

        if (this.terrain.getBlock(xPositionMin, yPositionMin) == nil)
        and (this.terrain.getBlock(xPositionMin, yPositionMax) == nil)
        and (this.terrain.getBlock(xPositionMax, yPositionMin) == nil)
        and (this.terrain.getBlock(xPositionMax, yPositionMax) == nil) then
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

        if yPositionMax>44 then
            return "outOfBounds"
        end
        if (this.terrain.getBlock(xPositionMin, yPositionMax)) ~= nil or (this.terrain.getBlock(xPositionMax, yPositionMax)) ~= nil then
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
