SRCDIR = "sources/"
ASSETSDIR = "assets/"
require(SRCDIR.."Terrain")

Personnage = {}
Personnage.__index = Personnage

perlin = love.image.newImageData(ASSETSDIR.."perlin_noise.png")

-- Taille du pavage
TILESIZE = 32

---- Valeur absolue des vitesses de déplacement

-- Vitesse du saut
JUMPSPEED = 3.5

-- Vitesse en l'air
AIRSPEED = 0.7

-- Vitesse au sol
GROUNDSPEED = 3 * AIRSPEED

-- Accélération de chute
GRAVITY = 0.12

-- Vitesse de chute maximale
MAX_SPEED_FALLING = 3.4

function Personnage:New(t) -- Générer une Terrain à  partir de 3 Tile différentes
    local this = {}
    this.terrain = t
    setmetatable(this, Personnage)
    this.img = love.graphics.newImage(ASSETSDIR.."perso/".."jmh.png")

    -- Positions que peut prendre le personnage
    positionAvailable = {}
    for i=1, 44 do
        for j=1, 80 do
            if terrain.map_bloc[i][j]==nil and terrain.map_bloc[i+1][j]~=nil then
                table.insert(positionAvailable, {i, j})
            end
        end
    end
    value = table.getn(positionAvailable)
    randomPosition = love.math.random(1, value)


    this.pointDeVie = 100


    this.posX = (positionAvailable[randomPosition][2]-1)*TILESIZE--Position en pixel
    this.posY = (positionAvailable[randomPosition][1]-1)*TILESIZE--Position en pixel

    this.Xspeed = 0
    this.Yspeed = 0;

    this.Xacc = 0;
    this.Yacc = GRAVITY

    return this
end

function Personnage:MoveTo(x, y)

    actualPositionX = self.posX
    actualPositionY = self.posY
    nextPositionX = actualPositionX+x
    nextPositionY = actualPositionY+y

    xPositionMin = math.floor(((nextPositionX+1)/TILESIZE)+1)
    xPositionMax = math.floor(((nextPositionX+(TILESIZE-1))/TILESIZE)+1)
    yPositionMin = math.floor(((nextPositionY+1)/TILESIZE)+1)
    yPositionMax = math.floor(((nextPositionY+(TILESIZE-1))/TILESIZE)+1)

    if nextPositionX < 0 or nextPositionX > 79*TILESIZE or nextPositionY < 0 or nextPositionY > 44*TILESIZE then
        return
    end

    if yPositionMax > 45 or xPositionMax > 80 then
        return
    end

    if (self.terrain.map_bloc[yPositionMin][xPositionMin]==nil) and (self.terrain.map_bloc[yPositionMax][xPositionMin]==nil)
    and (self.terrain.map_bloc[yPositionMin][xPositionMax]==nil) and (self.terrain.map_bloc[yPositionMax][xPositionMax]==nil) then
        self.posX = nextPositionX
        self.posY = nextPositionY
    end

end


function Personnage:isGrounded()
    
    actualPositionY = self.posY
    nextPositionY = actualPositionY + 4

    xPositionMin = math.floor(((self.posX+1)/TILESIZE)+1)
    xPositionMax = math.floor(((self.posX+(TILESIZE-1))/TILESIZE)+1)
    yPositionMax = math.floor(((nextPositionY+(TILESIZE-1))/TILESIZE)+1)

    if (self.terrain.map_bloc[yPositionMax][xPositionMin])~=nil or (self.terrain.map_bloc[yPositionMax][xPositionMax])~=nil then
        return true
    end

    return false
end


function Personnage:Jump(grounded)
    if grounded then
        self.Yspeed = - JUMPSPEED
    end
end

function Personnage:MoveRight(grounded)
    if grounded then
        self.Xspeed = 2 * GROUNDSPEED /3
        self.Xacc = GROUNDSPEED / 3
    else 
        if self.Xspeed == 0 then
            self.Xspeed = AIRSPEED
        end
        self.Xacc = self.Xacc + 0.001 * GROUNDSPEED
    end
end

function Personnage:MoveLeft(grounded)
    if grounded then 
        self.Xspeed = 2 * - GROUNDSPEED /3
        self.Xacc = - GROUNDSPEED / 3
    else 
        if self.Xspeed == 0 then
            self.Xspeed = - AIRSPEED
        end
        self.Xacc = self.Xacc - 0.001 * GROUNDSPEED
    end
end

function Personnage:Move(grounded)
    self.Yspeed = self.Yspeed + self.Yacc
    self.Xspeed = self.Xspeed + self.Xacc

    -- On limite les vitesses
    if self.Yspeed > MAX_SPEED_FALLING then
        self.Yspeed = MAX_SPEED_FALLING
    end

    if self.Xspeed > GROUNDSPEED then
        self.Xspeed = GROUNDSPEED
    elseif self.Xspeed < - GROUNDSPEED then
        self.Xspeed = - GROUNDSPEED
    end

    -- On applique le déplacement 
    self:MoveTo(self.Xspeed, 0)
    self:MoveTo(0, self.Yspeed)

end