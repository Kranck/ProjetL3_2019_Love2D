require("var")

require(TILESDIR.."Pierre")
require(TILESDIR.."Terre")
require(TILESDIR.."Gold")
require(TILESDIR.."Fer")
require(TILESDIR.."Soufre")

Terrain = {}
Terrain.__index = Terrain
Terrain.background = nil --love.graphics.newImage(ASSETSDIR.."sky_background.jpg")

function Terrain:New(height, width) -- Générer une Terrain à  partir de 3 Tile différentes
    local self = {  
                    current_perso_index = nil,
                    next_team_nb = nil,
                    current_team_nb = 1,
                    height = height,
                    width = width,
                    map_bloc = {},
                    materiaux = {},
                    positionAvailable = {},
                    teams = {},
                    controlled_perso = nil,
                    next_perso_nb = nil
                }

    local set_next_perso_nb = function()
        self.next_perso_nb = self.current_perso_index+1
        while self.teams[self.current_team_nb].getPersonnages()[self.next_perso_nb] == nil do
            if self.next_perso_nb<table.getn(self.teams[self.current_team_nb].getPersonnages()) then
                self.next_perso_nb = self.next_perso_nb+1
            else
                self.next_perso_nb = 1
            end
        end
    end

    local set_current_perso_nb = function()

    end

    local set_next_team_nb = function()
        self.next_team_nb = self.current_team_nb+1
        if self.next_team_nb > table.getn(self.teams) then
            self.next_team_nb=1
        end
        while self.teams[self.next_team_nb].teamIsDead() do
            self.next_team_nb = self.next_team_nb+1
            if self.next_team_nb>table.getn(self.teams) then
                self.next_team_nb=1
            end
        end
    end

    local set_current_team_nb = function()

    end

    local next_perso = function()
        self.controlled_perso.setDestroying(false)
        self.controlled_perso.changeWeapon("")
        self.teams[self.current_team_nb].setCurrentPlayer(self.next_perso_nb)
        self.teams[self.next_team_nb].reset_current_player()
        self.current_perso_index = self.teams[self.next_team_nb].getCurrentPlayer()
        self.controlled_perso = self.teams[self.next_team_nb].getPersonnages()[self.current_perso_index]
        self.current_team_nb = self.next_team_nb
        set_next_perso_nb()
        set_next_team_nb()
    end

    local update = function (dt)
        local to_remove = {}
        if self.materiaux[1] ~= nil then
            for i=1, table.getn(self.materiaux) do
                grounded = self.materiaux[i].isGrounded()
                if grounded=="outOfBounds" then
                    table.insert(to_remove, i)
                end
            end
        end
        for i=1, table.getn(to_remove) do
            table.remove(self.materiaux, to_remove[i])
        end
        for i, m in ipairs(self.materiaux) do
            m.update()
        end
        for i, t in ipairs(self.teams) do
            t.update(moved, dt)
        end
        set_next_perso_nb()
        set_next_team_nb()
    end
    -- fonction d'affichage pour love.draw
    local draw = function () 
        for y=1, self.height do
            for x=1, self.width do
                if nil~=self.map_bloc[y][x] then
                    self.map_bloc[y][x].draw(((x-1)*TILESIZE), ((y-1)*TILESIZE))
                end
            end
        end
        for i, m in ipairs(self.materiaux) do
            m.draw()
        end 
        for i, t in ipairs(self.teams) do
            t.draw(moved)
        end
    end

    
    local generateMap = function ()
        -- Initialisation d'un terrain de tout le terrain à nil
        -- valeur qu'on modifiera en fct des valeurs de gris
        for i=1, height do
            self.map_bloc[i] = {}
            for j=1, width do
                self.map_bloc[i][j] = nil
            end
        end

        -- Initialisation des variables nécéssaires pour la génération d'un bruit de perlin
        love.math.setRandomSeed(os.time())
        scale = 19
        dx = love.math.random(0, 1000)
        dy = love.math.random(0, 1000)
        height_to_destroy = love.math.random(10, 15)
        height_to_keep = height-height_to_destroy

        -- Matrice qui contient les valeurs de gris
        tb_generated_img = {}
        for i=1, height_to_keep do
            tb_generated_img[i] = {}
            for j=1, 80 do
                tb_generated_img[i][j] = love.math.noise(i/scale + dx , j/scale + dy)
            end
        end

        -- Boucle qui permet d'affecter des Tile à notre terrain 
        -- en fonction d'une matrice de valeur de gris générée précédemment
        for i=1, height_to_keep do
            for j=1, width do
                if tb_generated_img[i][j] < 1/2 then
                    self.map_bloc[height_to_destroy+i][j] = Terre:New(0)
                end
                if tb_generated_img[i][j] < 1/4 then
                    self.map_bloc[height_to_destroy+i][j] = Pierre:New()
                end
                if tb_generated_img[i][j] < 1/15 then
                    local randomNumber = love.math.random(1, 112)
                        if randomNumber<112 then
                            self.map_bloc[height_to_destroy+i][j] = Gold:New()
                        end
                        if randomNumber<96 then
                            self.map_bloc[height_to_destroy+i][j] = Soufre:New()
                        end
                        if randomNumber<64 then
                            self.map_bloc[height_to_destroy+i][j] = Fer:New()
                        end
                    this.map_bloc[height_to_destroy+i][j] = Terre:New()
                end
            end
        end

        -- On définit une certaine hauteur pour chaque colonne de notre terrain
        -- afin d'éviter d'avoir une map trop rectiligne
        tab_not_rectiligne = {}
        for i=1, width do
            tab_not_rectiligne[i] = love.math.random(0, 3)+height_to_destroy
        end

        -- Boucle qui permet de supprimer certains blocs pour éviter une map trop rectiligne
        for j=1, width do
            value = tab_not_rectiligne[j]
            to_destroy = value
            for i=1, to_destroy do
                self.map_bloc[i][j] = nil
            end
        end

        -- On s'assure qu'il n'y ait pas de Tile "flottant" dans l'air"
        for i=1, height do
            for j=1, width do
                if self.map_bloc[i][j] ~= nil then
                    local sprite_val = 0
                    if i-1 > 0 and self.map_bloc[i-1][j] == nil then -- top at air
                        sprite_val = sprite_val + 8
                    end
                    if j+1 <= width and self.map_bloc[i][j+1] == nil then -- right at air
                        sprite_val = sprite_val + 4
                    end
                    if i+1 <= height and self.map_bloc[i+1][j] == nil then -- bootom at air
                        sprite_val = sprite_val + 2
                    end
                    if j-1 > 0 and self.map_bloc[i][j-1] == nil then -- left at air
                        sprite_val = sprite_val + 1
                    end
                    if sprite_val==15 then
                        self.map_bloc[i][j]=nil
                    end
                end
            end
        end

        -- On enregistre la matrice de valeur de gris sous une image
        imageSaved = love.image.newImageData(width, height)
        for i=0, height_to_keep-1 do
            for j=0, width-1 do
                value = tb_generated_img[i+1][j+1]
                imageSaved:setPixel(j, i, value, value, value, 0.8)
            end
        end
        imageSaved:encode("png", "newImage.png")

        
        -- On donne le bon design aux blocs de terre
        for i=1, height do
            for j=1, width do
                if self.map_bloc[i][j] ~= nil and self.map_bloc[i][j].__type == "Terre" then
                    local sprite_val = 0
                    if i-1 > 0 and self.map_bloc[i-1][j] == nil then -- top at air
                        sprite_val = sprite_val + 8
                    end
                    if j+1 <= width and self.map_bloc[i][j+1] == nil then -- right at air
                        sprite_val = sprite_val + 4
                    end
                    if i+1 <= height and self.map_bloc[i+1][j] == nil then -- bootom at air
                        sprite_val = sprite_val + 2
                    end
                    if j-1 > 0 and self.map_bloc[i][j-1] == nil then -- left at air
                        sprite_val = sprite_val + 1
                    end
                    self.map_bloc[i][j]:ChangeQuad(sprite_val)
                end
            end
        end

        -- On remplit le tableau de position que le personnage peut prendre au début de la game
        for i=1, 44 do
            for j=1, 80 do
                if self.map_bloc[i][j] == nil and self.map_bloc[i+1][j] ~= nil then
                    table.insert(self.positionAvailable, {i, j})
                end
            end
        end
    end

    local getBlock = function (x, y) return self.map_bloc[y][x] end

    local destroy  = function (x, y) self.map_bloc[y][x] = nil end

    local getPositionAvailable = function () return self.positionAvailable end

    local setPositionAvailable = function (positionAvailable) self.positionAvailable = positionAvailable end 

    setmetatable(self, Terrain)
    
    
    generateMap()

    for i=1, TEAM_NB do
        table.insert(self.teams, Equipe:New({
            getPositionAvailable = getPositionAvailable,
            setPositionAvailable = setPositionAvailable,
            generateMap = generateMap,
            draw = draw,
            update = update,
            getBlock = getBlock,
            destroy = destroy,
            teams = self.teams,
            materiaux = self.materiaux
        }, TEAM_COLORS[i], "Equipe "..i))
    end

    self.current_perso_index = self.teams[self.current_team_nb].getCurrentPlayer()
    set_next_team_nb()
    set_next_perso_nb()
    self.controlled_perso = self.teams[self.current_team_nb].getPersonnages()[self.current_perso_index]
    self.current_perso_index = self.teams[self.current_team_nb].getCurrentPlayer()

    local get_current_team_nb = function() return self.current_team_nb end
    local get_current_perso_index = function() return self.current_perso_index end
    local get_controlled_perso = function() return self.controlled_perso end
    local get_next_team_nb = function() return self.next_team_nb end
    local get_next_perso_nb = function() return self.next_perso_nb end

    ----------------------------------------------------------------------------------------------------------
    ----------------------------------------  Interface Extérieure  ------------------------------------------
    ----------------------------------------------------------------------------------------------------------
    return {
        getPositionAvailable = getPositionAvailable,
        setPositionAvailable = setPositionAvailable,
        generateMap = generateMap,
        draw = draw,
        update = update,
        getBlock = getBlock,
        destroy = destroy,
        teams = self.teams,
        materiaux = self.materiaux,
        get_controlled_perso = get_controlled_perso,
        get_current_team_nb = get_current_team_nb,
        get_current_perso_index = get_current_perso_index,
        get_next_team_nb = get_next_team_nb,
        get_next_perso_nb = get_next_perso_nb,
        next_perso = next_perso
    }
    
end -- End Personnage:New