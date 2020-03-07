require("var")
require(WEAPONDIR.."ArmeDistance")

Grenade = ArmeDistance:New()
Grenade.__type = "Grenade"
Grenade.sprite = love.graphics.newImage(TEXTUREDIR.."Grenade.png")
Grenade.degats = 50

function Grenade:New(posX, posY, angle, terrain, orientation)
    local self = {
        type = "Grenade",
        posX = posX + TILESIZE/2 * orientation,
        posY = posY - TILESIZE/2,
        degats = Grenade.degats,
        sprite = Grenade.sprite,
        range = Grenade.range,
        Xspeed = 3 * orientation * math.cos(angle*math.pi/180),
        Yspeed = -7 * math.sin(angle*math.pi/180),
        Xacc = 0,
        Yacc = GRAVITY,
        timer = 5,
        terrain = terrain,
        range = TILESIZE*2,
    }
    -- Le personnage touche-t-il le sol ou est il sur un personnage ?
    local isGrounded = function ()
        actualPositionY = self.posY
        nextPositionY = actualPositionY + 4

        xPositionMin = math.floor(((self.posX+1)/TILESIZE)+1)
        xPositionMax = math.floor(((self.posX+(TILESIZE-1))/TILESIZE)+1)
        yPositionMax = math.floor(((nextPositionY+(TILESIZE-1))/TILESIZE)+1)

        if yPositionMax > 45 then
            return "outOfBounds"
        end

        if self.terrain.getBlock(xPositionMin, yPositionMax) ~= nil
        or self.terrain.getBlock(xPositionMax, yPositionMax) ~= nil then
            return true
        end
    end

    local function MoveTo(x, y)
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

        if yPositionMax > 45 or xPositionMax > 80 then
            return
        end

        if (self.terrain.getBlock(xPositionMin, yPositionMin) == nil)
        and (self.terrain.getBlock(xPositionMin, yPositionMax) == nil)
        and (self.terrain.getBlock(xPositionMax, yPositionMin) ~= nil)
        and (self.terrain.getBlock(xPositionMax, yPositionMax) ~= nil) then
            self.Xspeed = 0
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

    local explode = function()
        for n_equipe=1 , TEAM_NB do
            for n_perso=1 , table.getn(self.terrain.teams[n_equipe].getPersonnages()) do
                local other = self.terrain.teams[n_equipe].getPersonnages()[n_perso]
                local pos = other.getPos()
                -- On parcours tous les autres joueurs
                if(self.equipe.name ~= other.getEquipe().name or self.number ~= other.getNumber()) then
                    if(x >= pos.posX and x <= pos.posX + TILESIZE and y >= pos.posY and y <= pos.posY + TILESIZE) then
                        other.setHP(other.getHP() - 20)
                        return true
                    end
                end
            end
        end
    end

    local update = function(dt, grounded)
        self.timer = self.timer - dt
        self.Yspeed = self.Yspeed + self.Yacc
        if (self.Xspeed - math.floor(self.Xspeed)>0.5) then
            MoveTo(math.floor(self.Xspeed+1), 0)
        else
            MoveTo(math.floor(self.Xspeed), 0)
        end
        MoveTo(0, math.floor(self.Yspeed))
        -- On limite les vitesses
        if self.Yspeed > MAX_SPEED_FALLING then
            self.Yspeed = MAX_SPEED_FALLING
        end

        if grounded then
            self.Xspeed = 0
        end
    end

    local draw = function()
        love.graphics.draw(self.sprite, self.posX, self.posY)
    end

    setmetatable(self, Grenade)

    return {
        type = self.type,
        isGrounded = isGrounded,
        MoveTo = Moveto,
        update = update,
        draw = draw
    }
end
