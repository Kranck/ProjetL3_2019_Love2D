require("var")

Materiaux = {}
Materiaux.__index = Materiaux

require(TILESDIR.."Terre")
require(TILESDIR.."Pierre")
require(TILESDIR.."Fer")
require(TILESDIR.."Soufre")
require(TILESDIR.."Gold")

function Materiaux:New(type, x_index, y_index, terrain)
    local self = {
        posX = (x_index-1)*TILESIZE,
        posY = (y_index-1)*TILESIZE,
        type = type, -- Terre, Pierre, Fer, Souffre, Gold
        terrain = terrain,
        img = nil,
        Yspeed = 0,
        Yacc = GRAVITY
    }
    
    if self.type == "Terre" then
        self.img = Terre.fallen
    elseif self.type == "Pierre" then
        self.img = Pierre.fallen
    elseif self.type == "Fer" then
        self.img = Fer.fallen
    elseif self.type == "Souffre" then
        self.img = Soufre.fallen
    elseif self.type == "Gold" then
        self.img = Gold.fallen
    end

    local MoveTo = function (x, y)
        local actualPositionX = self.posX
        local actualPositionY = self.posY
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

        if (self.terrain.getBlock(xPositionMin, yPositionMin) == nil)
        and (self.terrain.getBlock(xPositionMin, yPositionMax) == nil)
        and (self.terrain.getBlock(xPositionMax, yPositionMin) ~= nil)
        and (self.terrain.getBlock(xPositionMax, yPositionMax) ~= nil) then
            self.posX = xPositionMin*TILESIZE-TILESIZE
        end

        if (self.terrain.getBlock(xPositionMin, yPositionMin) ~= nil)
        and (self.terrain.getBlock(xPositionMin, yPositionMax) ~= nil)
        and (self.terrain.getBlock(xPositionMax, yPositionMin) == nil)
        and (self.terrain.getBlock(xPositionMax, yPositionMax) == nil) then
            self.posX = xPositionMax*TILESIZE-TILESIZE
        end

        if (self.terrain.getBlock(xPositionMin, yPositionMax) ~= nil)
        and (self.terrain.getBlock(xPositionMax, yPositionMax) ~= nil)
        and (self.terrain.getBlock(xPositionMax, yPositionMin) == nil)
        and (self.terrain.getBlock(xPositionMin, yPositionMin) == nil) then
            self.posY = yPositionMin*TILESIZE-TILESIZE
        end

        if (self.terrain.getBlock(xPositionMin, yPositionMin) == nil)
        and (self.terrain.getBlock(xPositionMin, yPositionMax) == nil)
        and (self.terrain.getBlock(xPositionMax, yPositionMin) == nil)
        and (self.terrain.getBlock(xPositionMax, yPositionMax) == nil) then
            self.posX = nextPositionX
            self.posY = nextPositionY
        end
    end

    local isGrounded = function ()
        actualPositionY = self.posY
        nextPositionY = actualPositionY + 4
        xPositionMin = math.floor(((self.posX+1)/TILESIZE)+1)
        xPositionMax = math.floor(((self.posX+(TILESIZE-1))/TILESIZE)+1)
        yPositionMax = math.floor(((nextPositionY+(TILESIZE-1))/TILESIZE)+1)

        if yPositionMax>44 then
            return "outOfBounds"
        end
        if (self.terrain.getBlock(xPositionMin, yPositionMax)) ~= nil or (self.terrain.getBlock(xPositionMax, yPositionMax)) ~= nil then
            return true
        end
        return false
    end

    local update = function(grounded)
        self.Yspeed = self.Yspeed + self.Yacc
    
        -- On limite les vitesses
        if self.Yspeed > MAX_SPEED_FALLING then
            self.Yspeed = MAX_SPEED_FALLING
        end
    
        -- On applique le déplacement 
    
        MoveTo(0, math.floor(self.Yspeed))
    end

    local draw = function (grounded)
        -- On draw le personnage
        love.graphics.draw(self.img, self.posX, self.posY)
    
        if grounded then
            -- On stop le mouvement au sol
            return
        end
    end

    local getPos = function () return {posX = self.posX, posY = self.posY} end
    local getType = function () return self.type end

    setmetatable(self, Materiaux)

    return {
        update=update,
        draw = draw,
        isGrounded = isGrounded,
        getPos = getPos,
        getType = getType
    }
end
