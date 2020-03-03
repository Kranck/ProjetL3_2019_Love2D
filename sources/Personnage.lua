require('var')

require(SRCDIR.."Terrain")
require(SRCDIR.."Materiaux")
local anim8   = require 'anim8'
Personnage = {}
Personnage.__index = Personnage

local function sensi(x) -- map a value between 0.5 and 
    return (math.atan(SENSI/40 * x) / math.pi) * 6
end


function Personnage:New(e, color, nb) -- Générer un Terrain à partir de 3 Tiles différentes
    -- stocker le reste dans terrain : utiliset la séquence de Halton

    -- Sprite où chercher les images
    local sprite = nil
    local sprite_without_arms = nil
    if color=="#E03A3E" then
        miner_sprite = love.graphics.newImage(ASSETSDIR.."perso/sprite_jm_miner_rouge.png")
        sprite = love.graphics.newImage(ASSETSDIR.."perso/".."sprite_jm_rouge.png")
        sprite_without_arms = love.graphics.newImage(ASSETSDIR.."perso/sprite_jm_sans_bras_rouge.png")
        sprite_arm_and_pistol = love.graphics.newImage(ASSETSDIR.."perso/sprite_bras_pistolet_rouge.png") 
    end
    if color=="#002B5C" then
        miner_sprite = love.graphics.newImage(ASSETSDIR.."perso/sprite_jm_miner_bleu.png")
        sprite = love.graphics.newImage(ASSETSDIR.."perso/".."sprite_jm_bleu.png")
        sprite_without_arms = love.graphics.newImage(ASSETSDIR.."perso/sprite_jm_sans_bras_bleu.png")
        sprite_arm_and_pistol = love.graphics.newImage(ASSETSDIR.."perso/sprite_bras_pistolet_bleu.png")        
    end
    if color=="#00471B" then
        miner_sprite = love.graphics.newImage(ASSETSDIR.."perso/sprite_jm_miner_vert.png")
        sprite = love.graphics.newImage(ASSETSDIR.."perso/".."sprite_jm_vert.png")      
        sprite_without_arms = love.graphics.newImage(ASSETSDIR.."perso/sprite_jm_sans_bras_vert.png")
        sprite_arm_and_pistol = love.graphics.newImage(ASSETSDIR.."perso/sprite_bras_pistolet_vert.png")  
    end
    if color=="#FFCD00" then
        miner_sprite = love.graphics.newImage(ASSETSDIR.."perso/sprite_jm_miner_jaune.png")
        sprite = love.graphics.newImage(ASSETSDIR.."perso/".."sprite_jm_jaune.png")        
        sprite_without_arms = love.graphics.newImage(ASSETSDIR.."perso/sprite_jm_sans_bras_jaune.png")
        sprite_arm_and_pistol = love.graphics.newImage(ASSETSDIR.."perso/sprite_bras_pistolet_jaune.png")
    end
    if color=="#692261" then
        miner_sprite = love.graphics.newImage(ASSETSDIR.."perso/sprite_jm_miner_violet.png")
        sprite = love.graphics.newImage(ASSETSDIR.."perso/".."sprite_jm_violet.png")
        sprite_without_arms = love.graphics.newImage(ASSETSDIR.."perso/sprite_jm_sans_bras_violet.png")
        sprite_arm_and_pistol = love.graphics.newImage(ASSETSDIR.."perso/sprite_bras_pistolet_violet.png")        
    end
    if color=="#C4CED4" then
        miner_sprite = love.graphics.newImage(ASSETSDIR.."perso/sprite_jm_miner_blanc.png")
        sprite = love.graphics.newImage(ASSETSDIR.."perso/".."sprite_jm_blanc.png")  
        sprite_without_arms = love.graphics.newImage(ASSETSDIR.."perso/sprite_jm_sans_bras_blanc.png")
        sprite_arm_and_pistol = love.graphics.newImage(ASSETSDIR.."perso/sprite_bras_pistolet_blanc.png")      
    end

    
    local function returnAvailablePos()
        newTab = e.terrain.getPositionAvailable()
        randIndex = math.random(1, table.getn(newTab))
        res = newTab[randIndex]
        table.remove(newTab, randIndex)
        e.terrain.setPositionAvailable(newTab)
        return res
    end

    positionTab = returnAvailablePos()
    
    grid_sprite = anim8.newGrid(48, 48, miner_sprite:getWidth(), miner_sprite:getHeight())
    local self = {
        sprite  = sprite,
        miner_sprite = miner_sprite,
        animations = {
            miner_right = anim8.newAnimation(grid_sprite(1,1, 2,1, 3,1, 4,1), 0.1, onLoop),
            miner_left = anim8.newAnimation(grid_sprite(1,2, 2,2, 3,2, 4,2), 0.1, onLoop)
        },
        terrain = e.terrain,
        range   = RANGE,    -- Distance à laquelle le personnage peut casser des blocs
        img     = love.graphics.newQuad(0, 0, TILESIZE, TILESIZE, sprite:getDimensions()),
        angle   = 0,        -- angle 
        pointDeVie = CHAR_HP,
        posX = (positionTab[2]-1)*TILESIZE,  -- Position en pixel
        orientation = RIGHT,
        Xspeed = 0, -- Horizontal Speed
        posY = (positionTab[1]-1)*TILESIZE, -- Position en pixel
        Xacc = 0,   -- Horizontal acceleration
        Yspeed = 0, -- Vertical Speed
        Yacc = GRAVITY, -- Vertical acceleration
        equipe = e,
        number = nb,
        weapon = "",
        destroying = false
    }
    current_animation = self.animations.miner_right

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

        if yPositionMax > 45 or xPositionMax > 80 then
            return
        end

        for i=1, table.getn(self.terrain.teams) do
            for j=1, table.getn(self.terrain.teams[i].getPersonnages()) do
                if not(self.number == self.terrain.teams[i].getPersonnages()[j].getNumber() and self.equipe.color==self.terrain.teams[i].getPersonnages()[j].getEquipe().color) then
                    pos = self.terrain.teams[i].getPersonnages()[j].getPos()
                    if(nextPositionX==pos.posX and nextPositionY==pos.posY) then
                        return
                    end
                    c1 = ((pos.posX<nextPositionX+TILESIZE-1 and pos.posX+TILESIZE-1>nextPositionX+TILESIZE-1) and (pos.posY<nextPositionY+TILESIZE-1 and pos.posY+TILESIZE-1>nextPositionY+TILESIZE-1))
                    c2 = ((pos.posX<nextPositionX and pos.posX+TILESIZE-1>nextPositionX) and (pos.posY<nextPositionY+TILESIZE-1 and pos.posY+TILESIZE-1>nextPositionY+TILESIZE-1))
                    c3 = ((pos.posX<nextPositionX+TILESIZE-1 and pos.posX+TILESIZE-1>nextPositionX+TILESIZE-1) and (pos.posY<nextPositionY and pos.posY+TILESIZE-1>nextPositionY)) 
                    c4 = ((pos.posX<nextPositionX and pos.posX+TILESIZE-1>nextPositionX) and (pos.posY<nextPositionY and pos.posY+TILESIZE-1>nextPositionY))
                    if(nextPositionY==pos.posY) then
                        if ((pos.posX<nextPositionX and nextPositionX<pos.posX+TILESIZE-1) or (pos.posX<nextPositionX+TILESIZE-1 and nextPositionX+TILESIZE-1<pos.posX+TILESIZE-1)) then
                            return
                        end
                    end
                    if(nextPositionX==pos.posX) then
                        if ((pos.posY<nextPositionY and pos.posY+TILESIZE-1>nextPositionY) or (pos.posY<nextPositionY+TILESIZE-1 and pos.posY+TILESIZE-1>nextPositionY+TILESIZE-1)) then
                            return
                        end
                    end
                    if (c1 or c2 or c3 or c4) then
                        return
                    end
                end
            end
        end

        if (self.equipe.terrain.getBlock(xPositionMin, yPositionMin) == nil)
        and (self.equipe.terrain.getBlock(xPositionMin, yPositionMax) == nil)
        and (self.equipe.terrain.getBlock(xPositionMax, yPositionMin) ~= nil)
        and (self.equipe.terrain.getBlock(xPositionMax, yPositionMax) ~= nil) then
            self.posX = xPositionMin*TILESIZE-TILESIZE
        end

        if (self.equipe.terrain.getBlock(xPositionMin, yPositionMin) ~= nil)
        and (self.equipe.terrain.getBlock(xPositionMin, yPositionMax) ~= nil)
        and (self.equipe.terrain.getBlock(xPositionMax, yPositionMin) == nil)
        and (self.equipe.terrain.getBlock(xPositionMax, yPositionMax) == nil) then
            self.posX = xPositionMax*TILESIZE-TILESIZE
        end

        if (self.equipe.terrain.getBlock(xPositionMin, yPositionMax) ~= nil)
        and (self.equipe.terrain.getBlock(xPositionMax, yPositionMax) ~= nil)
        and (self.equipe.terrain.getBlock(xPositionMax, yPositionMin) == nil)
        and (self.equipe.terrain.getBlock(xPositionMin, yPositionMin) == nil) then
            self.posY = yPositionMin*TILESIZE-TILESIZE
        end

        if (self.equipe.terrain.getBlock(xPositionMin, yPositionMin) == nil)
        and (self.equipe.terrain.getBlock(xPositionMin, yPositionMax) == nil)
        and (self.equipe.terrain.getBlock(xPositionMax, yPositionMin) == nil)
        and (self.equipe.terrain.getBlock(xPositionMax, yPositionMax) == nil) then
            self.posX = nextPositionX
            self.posY = nextPositionY
        end

        to_remove = {}
        if self.equipe.terrain.materiaux[1] ~= nil then
            for i=1, table.getn(self.equipe.terrain.materiaux) do
                mat = self:ramasserMateriau(self.equipe.terrain.materiaux[i])
                if mat~=nil then
                    table.insert(to_remove, i)
                end
            end
        end
        if to_remove[1]~=nil then
            for i=1, table.getn(to_remove) do
                mat_to_remove = self.equipe.terrain.materiaux[i]
                if mat_to_remove ~= nil then
                    if mat_to_remove.getType()=="Fer" or mat_to_remove.getType()=="Souffre" or mat_to_remove.getType()=="Gold" then
                        self.equipe.materiaux[mat_to_remove.getType()] = self.equipe.materiaux[mat_to_remove.getType()] + math.random(1, 4)
                    else
                        self.equipe.materiaux[mat_to_remove.getType()] = self.equipe.materiaux[mat_to_remove.getType()] + 1
                    end
                end
                table.remove(self.equipe.terrain.materiaux, to_remove[i])
            end
        end
    end

    local isOnPersonnage = function()
        for i=1, table.getn(self.terrain.teams) do
            for j=1, table.getn(self.terrain.teams[i].getPersonnages()) do
                if not(self.number == self.terrain.teams[i].getPersonnages()[j].getNumber() and self.equipe.color==self.terrain.teams[i].getPersonnages()[j].getEquipe().color) then
                    pos = self.terrain.teams[i].getPersonnages()[j].getPos()
                    if (pos.posY < self.posY+TILESIZE-1+4 and self.posY+TILESIZE-1+4 < pos.posY+TILESIZE-1) then
                        if (self.posX < pos.posX and self.posX +TILESIZE-1 > pos.posX ) or (self.posX<pos.posX+TILESIZE-1 and self.posX+TILESIZE-1>pos.posX+TILESIZE-1) or (self.posX==pos.posX) then
                            return true
                        end
                    end
                end
            end
        end
        return false
    end


    -- Le personnage touche-t-il le sol ou est il sur un personnage ?
    local isGrounded = function ()
        actualPositionY = self.posY
        nextPositionY = actualPositionY + 4

        xPositionMin = math.floor(((self.posX+1)/TILESIZE)+1)
        xPositionMax = math.floor(((self.posX+(TILESIZE-1))/TILESIZE)+1)
        yPositionMax = math.floor(((nextPositionY+(TILESIZE-1))/TILESIZE)+1)

        if yPositionMax > 45 then
        --self.pointDeVie=0
            for i=1, table.getn(self.equipe.personnages) do
                if self==self.equipe.personnages[i] then
                    table.remove(self.equipe.personnages, i)
                end
            end
            return "outOfBounds"
        end

        if self.equipe.terrain.getBlock(xPositionMin, yPositionMax) ~= nil
        or self.equipe.terrain.getBlock(xPositionMax, yPositionMax) ~= nil then
            return true
        end

        return isOnPersonnage()
    end

    -- fait sauter le personnage
    local Jump = function (grounded)
        if grounded then
            self.Yspeed = - JUMPSPEED
        end
        if(self.orientation == RIGHT) then
            self.img = love.graphics.newQuad(TILESIZE * 2, 0, TILESIZE, TILESIZE, self.sprite:getDimensions())
        else
            self.img = love.graphics.newQuad(TILESIZE * 3, 0, TILESIZE, TILESIZE, self.sprite:getDimensions())
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
        self.img = love.graphics.newQuad(0, 0, TILESIZE, TILESIZE, self.sprite:getDimensions());
        self.orientation = RIGHT
        -- Gérer l'affichage du perso lors du saut
        if(not grounded) then 
            self.img = love.graphics.newQuad(64, 0, TILESIZE, TILESIZE, self.sprite:getDimensions())
        end
    end

    -- Déplacement horizontal vers la gauche
    local MoveLeft = function (grounded)
        MoveAside(grounded, -1)
        self.img = love.graphics.newQuad(TILESIZE, 0, TILESIZE, TILESIZE, self.sprite:getDimensions());
        self.orientation = LEFT
        -- Gérer l'affichage du perso lors du saut
        if(not grounded) then 
            self.img = love.graphics.newQuad(TILESIZE * 3, 0, TILESIZE, TILESIZE, self.sprite:getDimensions())
        end
    end

    -- Change l'angle de visée du personnage vers le haut (limité à 90 deg)
    local changeAngleUp = function ()
        if (self.angle < 90) then
            self.angle = self.angle + sensi(1)
        end
    end

    -- Change l'angle de visée du personnage vers le bas (limité à - 90 deg)
    local changeAngleDown = function ()
        if (self.angle > -90) then
            self.angle = self.angle - sensi(1)
        end
    end
    
    local changeWeapon = function (newWeapon)
        self.weapon = newWeapon
        if(newWeapon == "pistolet") then
            self.sprite = sprite_without_arms
        end
        if(newWeapon == "") then
            self.sprite = sprite
        end
    end

    local getEqDroite = function(posX, posY, angle, orientation, range)
        local angle_in_radian = angle * math.pi/180

        local startX = posX + TILESIZE/2
        local startY = posY + TILESIZE/2
        if orientation < 0 then
            startX = startX -1
        end
        if angle > 0 then 
            startY = startY - 1
        end
        local tile_to_destroyX = startX + range *math.cos(angle_in_radian) * self.orientation
        local tile_to_destroyY = startY - range *math.sin(angle_in_radian)
        local coeff_droite = (tile_to_destroyY - startY) / (tile_to_destroyX - startX)
        local ordonne_origin = startY - coeff_droite * startX

        return coeff_droite, ordonne_origin, tile_to_destroyX, startX, startY

    end
    
    local verifDestroyBlock = function(x, y)
        nb_tileX =  math.floor(x/TILESIZE) + 1
        nb_tileY = math.floor(y/TILESIZE) + 1
        if(nb_tileY > HEIGHT) then
            return true
        end
        if(self.equipe.terrain.getBlock(nb_tileX, nb_tileY) ~= nil) then
            self.equipe.terrain.getBlock(nb_tileX, nb_tileY):ChangeQuad(nil, self.equipe.terrain.getBlock(nb_tileX, nb_tileY).pdv - 1)
            if(self.equipe.terrain.getBlock(nb_tileX, nb_tileY).pdv == 0) then
                type_of_mat = self.equipe.terrain.getBlock(nb_tileX, nb_tileY).type
                table.insert(self.equipe.terrain.materiaux, Materiaux:New(type_of_mat, nb_tileX, nb_tileY, self.equipe.terrain))
                self.equipe.terrain.destroy(nb_tileX, nb_tileY)
            end
            return true
        end
        return false
    end

    -- Destruction du block par le personnage
    local DestroyBlock = function ()
        changeWeapon("")
        self.destroying = true
        coeff_droite, ordonne_origin, tile_to_destroyX, startX, startY = getEqDroite(self.posX, self.posY, self.angle, self.orientation, self.range)

        -- Si l'angle est trop élevé, on casse le bloc du haut
        local signe_pas = 1
        if(math.abs(self.angle) > 86) then
            if(self.angle > 0) then
                signe_pas = -1
            end
            local end_Y = startY + self.range * signe_pas
            for j = startY, end_Y, signe_pas do
                if(verifDestroyBlock(startX, j)) then
                    return
                end
            end
        return
        end

        if(tile_to_destroyX < startX) then
            signe_pas = -1
        end

        local pas = 1 * signe_pas
        for i = startX, tile_to_destroyX, pas do
            local img_i = coeff_droite * i + ordonne_origin
            if(verifDestroyBlock(i, img_i)) then
                return
            end
        end
    end

    function Personnage:ramasserMateriau(materiau)
        positionMatMinX = materiau.getPos().posX
        positionMatMaxX = materiau.getPos().posX+TILESIZE
        positionMatMinY = materiau.getPos().posY
        positionMatMaxY = materiau.getPos().posY+TILESIZE
        HALF_TILESIZE = TILESIZE/2
        if self.posX+HALF_TILESIZE<positionMatMaxX and self.posX+HALF_TILESIZE>positionMatMinX and self.posY+HALF_TILESIZE<positionMatMaxY and self.posY+HALF_TILESIZE>positionMatMinY then
            return materiau
        else
            return nil
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

    local verifTirer = function(x, y)
        local nb_tileX =  math.floor(x/TILESIZE) + 1
        local nb_tileY = math.floor(y/TILESIZE) + 1
        if(nb_tileY > HEIGHT) then
            return true
        end
        -- Toucher un bloc
        if(self.equipe.terrain.getBlock(nb_tileX, nb_tileY) ~= nil) then
            return true
        end
        --Toucher un autre personnage

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
        return false
    end

    -- Tirer
    local Tirer = function()
        changeWeapon("pistolet")
        coeff_droite, ordonne_origin, tile_to_destroyX, startX, startY = getEqDroite(self.posX, self.posY, self.angle, self.orientation, self.range)
        local signe_pas = 1

        if(math.abs(self.angle) > 86) then
            if(self.angle > 0) then
                signe_pas = -1
            end
            local end_Y = startY + self.range * signe_pas
            for j = startY, end_Y, signe_pas do
                if(verifTirer(startX, j)) then
                    return
                end
            end
        return
        end

        if(tile_to_destroyX < startX) then
            signe_pas = -1
        end

        local pas = 1 * signe_pas
        for i = startX, tile_to_destroyX, pas do
            local img_i = coeff_droite * i + ordonne_origin
            if(verifTirer(i, img_i)) then
                return
            end
        end
    end


    -- Récupère un object contenant les quantités de chaque matériaux
    local getItems = function ()
        return {earth   = self.equipe.materiaux["Terre"],
                stone   = self.equipe.materiaux["Pierre"],
                iron    = self.equipe.materiaux["Fer"],
                sulfure = self.equipe.materiaux["Souffre"],
                gold    = self.equipe.materiaux["Gold"],}
    end
    
    -- Affiche les informations de débugages liés au personnage
    local Debug = function (grounded)
        love.graphics.print("Position        X : "..self.posX.." ; Y : "..self.posY , 0, 0)
        love.graphics.print("Speed          X : "..self.Xspeed.." ; Y : "..self.Yspeed , 0, 20)
        love.graphics.print("Accélération X : "..self.Xacc.." ; Y : "..self.Yacc , 0, 40)
        love.graphics.print((grounded and "Grounded" or "Not Grounded"), 0, 60)
        love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 0, 100)
        love.graphics.print("Angle : "..self.angle, 0, 120)
        -- love.graphics.print("Materiaux Array : "..table.getn(self.equipe.terrain.materiaux), 0, 140)
        -- love.graphics.print("Materiaux of Team : "..self.equipe.materiaux["Terre"].." ; "..self.equipe.materiaux["Pierre"].." ; "..self.equipe.materiaux["Fer"].." ; "..self.equipe.materiaux["Souffre"].." ; "..self.equipe.materiaux["Gold"], 0, 160)
    end

    -- Getter pour la position
    local getPos = function () return {posX = self.posX, posY = self.posY} end

    -- Getter pour la vie du personnage
    local getHP = function () return self.pointDeVie end

    -- Setter pour la vie du personnage
    local setHP = function (newHP) self.pointDeVie = newHP end 

    -- Getter pour l'angle
    local getAngle = function () return self.angle end

    -- Getter Orientation
    local getOrientation = function () return self.orientation end

    -- Getter Range
    local getRange = function () return self.range end

    local getEquipe = function () return self.equipe end

    local getNumber = function () return self.number end

    -- Animations
    local getMinerSprite = function () return self.miner_sprite end

    local getAnimations = function () return self.animations end

    local setDestroying = function (destroying)
        current_animation:pauseAtStart()
        current_animation:resume()
        self.destroying = destroying
    end

    -- Vérifie la vie d'un personnage
    local isDead = function ()
        if(self.pointDeVie<=0) then
            return true
        else
            return false
        end
    end

    local update = function (grounded, moved, dt)
        if self.destroying then
            if self.orientation == RIGHT then
                current_animation = self.animations.miner_right
            else
                current_animation = self.animations.miner_left
            end
            current_animation:update(dt)
        end
        
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
    end

    local draw = function (grounded, moved)
        if self.weapon == "pistolet" then
            if self.orientation == RIGHT then
                quad_pistol = love.graphics.newQuad(0, 0, 18, 7, sprite_arm_and_pistol:getDimensions())
                self.img = love.graphics.newQuad(0, 0, TILESIZE, TILESIZE, self.sprite:getDimensions())
                love.graphics.draw(sprite_arm_and_pistol, quad_pistol, self.posX+18, self.posY+10, -self.angle*math.pi/180, 1, 1, 0, 4)
            else
                quad_pistol = love.graphics.newQuad(0, 8, 18, 7, sprite_arm_and_pistol:getDimensions())
                self.img = love.graphics.newQuad(TILESIZE, 0, TILESIZE, TILESIZE, self.sprite:getDimensions())
                love.graphics.draw(sprite_arm_and_pistol, quad_pistol, self.posX+14, self.posY+10, self.angle*math.pi/180, 1, 1, 17, 4)
            end
        end
        if self.destroying then
            if self.orientation == RIGHT then
                current_animation:draw(self.miner_sprite, self.posX, self.posY-16)
            else
                current_animation:draw(self.miner_sprite, self.posX-16, self.posY-16)
            end
        else
            love.graphics.draw(self.sprite, self.img, self.posX, self.posY)
        end
        if grounded and not moved then
            -- On stop le mouvement au sol
            self.Xspeed = 0
            self.Xacc = 0
            if(self.orientation == RIGHT) then
                self.img = love.graphics.newQuad(0, 0, TILESIZE, TILESIZE, self.sprite:getDimensions())
            else
                self.img = love.graphics.newQuad(TILESIZE, 0, TILESIZE, TILESIZE, self.sprite:getDimensions())
            end
        end
    end

    setmetatable(self, Personnage)



    ----------------------------------------------------------------------------------------------------------
    ----------------------------------------  Interface Extérieure  ------------------------------------------
    ----------------------------------------------------------------------------------------------------------
    return {
        isGrounded = isGrounded,
        isDead = isDead,
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
        getItems = getItems,
        getHP = getHP,
        setHP = setHP,
        getMinerSprite = getMinerSprite,
        getAnimations = getAnimations,
        equipe = equipe,
        Tirer = Tirer,
        getEquipe = getEquipe,
        getNumber = getNumber,
        draw = draw,
        update = update,
        changeWeapon = changeWeapon,
        setDestroying = setDestroying
    }

end -- End Personnage:New