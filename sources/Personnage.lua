SRCDIR = "sources/"
require(SRCDIR.."Terrain")

Personnage = {}
Personnage.__index = Personnage

-- Vitesse du saut
local JUMPSPEED = 4.6

-- Vitesse en l'air
local AIRSPEED = 1.8

-- Vitesse au sol
local GROUNDSPEED = 1.3 * AIRSPEED

-- Accélération de chute
local GRAVITY = 0.15

-- Vitesse de chute maximale
local MAX_SPEED_FALLING = 3.4


-- RANGE
local RANGE = TILESIZE * 2

function Personnage:New(t) -- Générer une Terrain à  partir de 3 Tile différentes
    -- Positions que peut prendre le personnage
    -- Killian : à mettre dans la class terrain en fonction qui renvoie une seul position donné
    -- + stocker le reste dans terrain : utiliset la séquence de Halton

    -- Sprite où chercher les images
    local sprite = love.graphics.newImage(ASSETSDIR.."perso/".."sprite.png")
    local positionTab = t:EmptyPositionForPersonnage()
    local self = {
        sprite  = sprite,
        terrain = t,
        range   = RANGE,    -- Distance à laquelle le personnage peut casser des blocs
        img     = love.graphics.newQuad(0, 0, 32, 32, sprite:getDimensions()),
        angle   = 0,        -- angle 
        pointDeVie = 100,
        posX = (positionTab[2]-1)*TILESIZE,  -- Position en pixel
        orientation = RIGHT,
        Xspeed = 0, -- Horizontal Speed
        posY = (positionTab[1]-1)*TILESIZE, -- Position en pixel
        Xacc = 0,   -- Horizontal acceleration
        Yspeed = 0, -- Vertical Speed
        Yacc = GRAVITY -- Vertical acceleration
    }

    -- Modifie la position du personnage vers les nouveaux points x, y en vérifiant qu'on reste dans
    -- le terrain et qu'on ne rentre pas dans un mur
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

        if nextPositionY > 44*TILESIZE then
            nextPositionY = 44*TILESIZE
        end

        if yPositionMax > 45 or xPositionMax > 80 then
            return
        end

        if (self.terrain.map_bloc[yPositionMin][xPositionMin]==nil)
        and (self.terrain.map_bloc[yPositionMax][xPositionMin]==nil)
        and (self.terrain.map_bloc[yPositionMin][xPositionMax]~=nil)
        and (self.terrain.map_bloc[yPositionMax][xPositionMax]~=nil) then
            self.posX = xPositionMin*TILESIZE-TILESIZE
        end

        if (self.terrain.map_bloc[yPositionMin][xPositionMin]~=nil)
        and (self.terrain.map_bloc[yPositionMax][xPositionMin]~=nil)
        and (self.terrain.map_bloc[yPositionMin][xPositionMax]==nil)
        and (self.terrain.map_bloc[yPositionMax][xPositionMax]==nil) then
            self.posX = xPositionMax*TILESIZE-TILESIZE
        end

        if (self.terrain.map_bloc[yPositionMax][xPositionMin]~=nil)
        and (self.terrain.map_bloc[yPositionMax][xPositionMax]~=nil)
        and (self.terrain.map_bloc[yPositionMin][xPositionMax]==nil)
        and (self.terrain.map_bloc[yPositionMin][xPositionMin]==nil) then
            self.posY = yPositionMin*TILESIZE-TILESIZE
        end

        if (self.terrain.map_bloc[yPositionMin][xPositionMin]==nil)
        and (self.terrain.map_bloc[yPositionMax][xPositionMin]==nil)
        and (self.terrain.map_bloc[yPositionMin][xPositionMax]==nil)
        and (self.terrain.map_bloc[yPositionMax][xPositionMax]==nil) then
            self.posX = nextPositionX
            self.posY = nextPositionY
        end
    end

    -- Le personnage touche-t-il le sol ?
    local isGrounded = function ()
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

    -- fait sauter le personnage
    local Jump = function (grounded)
        if grounded then
            self.Yspeed = - JUMPSPEED
        end
    end

    -- Logique commune du déplacement horizontal
    -- direction == 1 -> droite ; direction == -1 -> gauche
    local MoveAside = function (grounded, direction)
        if grounded then
            self.Xspeed = 2 * direction * GROUNDSPEED /3
            self.Xacc = direction * GROUNDSPEED / 3
        else 
            if math.abs(self.Xspeed) <  2 * GROUNDSPEED /3 then
                self.Xspeed = direction * AIRSPEED
            end
            self.Xacc =  direction * AIRSPEED
        end
    end

    -- Déplacement horizontal vers la droite
    local MoveRight = function (grounded)
        MoveAside(grounded, 1)
        self.img = love.graphics.newQuad(0, 0, 32, 32, self.sprite:getDimensions());
        self.orientation = RIGHT
    end

    -- Déplacement horizontal vers la gauche
    local MoveLeft = function (grounded)
        MoveAside(grounded, -1)
        self.img = love.graphics.newQuad(32, 0, 32, 32, self.sprite:getDimensions());
        self.orientation = LEFT
    end

    -- Méthode de draw du personnage prenant en comptant les inputs
    local Move = function (grounded, moved)
        self.Yspeed = self.Yspeed + self.Yacc
        self.Xspeed = self.Xspeed + self.Xacc
    
        -- On limite les vitesses
        if self.Yspeed > MAX_SPEED_FALLING then
            self.Yspeed = MAX_SPEED_FALLING
        end
    
        if grounded and self.Xspeed > GROUNDSPEED then
            self.Xspeed = GROUNDSPEED
        elseif grounded and self.Xspeed < - GROUNDSPEED then
            self.Xspeed = - GROUNDSPEED
        elseif not grounded and self.Xspeed > AIRSPEED then
            self.Xspeed = AIRSPEED
        elseif not grounded and self.Xspeed < - AIRSPEED then
            self.Xspeed = - AIRSPEED
        end
    
        -- On applique le déplacement 
    
        if (self.Xspeed - math.floor(self.Xspeed)>0.5) then
            MoveTo(math.floor(self.Xspeed+1), 0)
        else
            MoveTo(math.floor(self.Xspeed), 0)
        end
        MoveTo(0, math.floor(self.Yspeed))
    
        -- On draw le personnage
        love.graphics.draw(self.sprite, self.img, self.posX, self.posY)
    
        if grounded and not moved then
            -- On stop le mouvement au sol
            self.Xspeed = 0
            self.Xacc = 0
        end
    end

    -- Change l'angle de visée du personnage vers le haut (limité à 90 deg)
    local changeAngleUp = function ()
        if (self.angle < 90) then
            self.angle = self.angle + 1
        end
    end

    -- Change l'angle de visée du personnage vers le bas (limité à - 90 deg)
    local changeAngleDown = function ()
        if (self.angle > -90) then
            self.angle = self.angle - 1
        end
    end
    
    -- Destruction du block par le personnage
    -- Alexy : Ce serait bien de merge le code dupliqué
    local DestroyBlock = function ()
        local angle_in_radian = self.angle * math.pi/180

        local startX = self.posX + TILESIZE/2
        local startY = self.posY + TILESIZE/2
        if self.orientation < 0 then
            startX = startX -1
        end
        if self.angle > 0 then 
            startY = startY - 1
        end
        local tile_to_destroyX = startX + self.range *math.cos(angle_in_radian) * self.orientation
        local tile_to_destroyY = startY - self.range *math.sin(angle_in_radian)
        local coeff_droite = (tile_to_destroyY - startY) / (tile_to_destroyX - startX)
        local ordonne_origin = startY - coeff_droite * startX
        -- Si l'angle est trop élevé, on casse le bloc du haut
        if(math.abs(self.angle) > 86) then
            local signe_pas = 1
            if(self.angle > 0) then
                signe_pas = -1
            end
            local end_Y = startY + self.range * signe_pas
            for j = startY, end_Y, signe_pas do
                local nb_tileX =  math.floor(startX/TILESIZE) + 1
                local nb_tileY = math.floor(j/TILESIZE) + 1
                if(self.terrain.map_bloc[nb_tileY][nb_tileX] ~= nil) then
                    self.terrain.map_bloc[nb_tileY][nb_tileX]:ChangeQuad(nil, self.terrain.map_bloc[nb_tileY][nb_tileX].pdv - 1)
                    
                    if(self.terrain.map_bloc[nb_tileY][nb_tileX].pdv == 0) then
                        self.terrain.map_bloc[nb_tileY][nb_tileX] = nil
                    end
                    break
                end
            end
        return
        end

        signe_pas = 1
        if(tile_to_destroyX < startX) then
            signe_pas = -1
        end
        local pas = 1 * signe_pas
        for i = startX, tile_to_destroyX, pas do
            local img_i = coeff_droite * i + ordonne_origin
            nb_tileX =  math.floor(i/TILESIZE) + 1
            nb_tileY = math.floor(img_i/TILESIZE) + 1
            if(self.terrain.map_bloc[nb_tileY][nb_tileX] ~= nil) then
                self.terrain.map_bloc[nb_tileY][nb_tileX]:ChangeQuad(nil, self.terrain.map_bloc[nb_tileY][nb_tileX].pdv - 1)
                if(self.terrain.map_bloc[nb_tileY][nb_tileX].pdv == 0) then
                    self.terrain.map_bloc[nb_tileY][nb_tileX] = nil
                end
                break
            end
        end

    end

    -- Affiche le cursor en fonction de l'angle du personnage
    local DrawCursor = function ()
        local angle_in_radian = self.angle * math.pi/180
        local cursor_img = love.graphics.newImage("assets/textures/Cursor.png")
        local cursor_posX = self.posX + self.range *math.cos(angle_in_radian) * self.orientation
        local cursor_posY = self.posY- self.range *math.sin(angle_in_radian)
        love.graphics.draw(cursor_img, cursor_posX, cursor_posY)
    end
    
    -- Affiche les informations de débugages liés au personnage
    local Debug = function (grounded)
        love.graphics.print("Position        X : "..self.posX.." ; Y : "..self.posY , 0, 0)
        love.graphics.print("Speed          X : "..self.Xspeed.." ; Y : "..self.Yspeed , 0, 20)
        love.graphics.print("Accélération X : "..self.Xacc.." ; Y : "..self.Yacc , 0, 40)
        love.graphics.print((grounded and "Grounded" or "Not Grounded"), 0, 60)
        love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 0, 100)
        love.graphics.print("Angle : "..self.angle, 0, 120)
    end

    -- Getter pour la position
    local getPos = function () return {posX = self.posX, posY = self.posY} end

    -- Getter pour l'angle
    local getAngle = function () return self.angle end

    -- Getter Orientation
    local getOrientation = function () return self.orientation end

    -- Getter Range
    local getRange = function () return self.range end

    setmetatable(self, Personnage)

    return {
        isGrounded = isGrounded,
        Jump = Jump,
        MoveRight = MoveRight,
        MoveLeft = MoveLeft,
        Move = Move,
        changeAngleUp = changeAngleUp,
        changeAngleDown = changeAngleDown,
        Debug = Debug,
        getPos = getPos,
        getAngle = getAngle,
        getOrientation = getOrientation,
        DestroyBlock = DestroyBlock,
        DrawCursor = DrawCursor,
        getRange = getRange,
    }

end -- End Personnage:New