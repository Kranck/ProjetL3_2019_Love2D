require("var")

require(SRCDIR.."Tile")
require(SRCDIR.."Terrain")
require(SRCDIR.."Camera")
require(SRCDIR.."Equipe")

local nuklear = require 'nuklear'
local Menu    = require(UIDIR..'uiMenu')
local InGame  = require(UIDIR..'uiInGame')
local Weapons = require(UIDIR..'uiWeapons')
local Pause   = require(UIDIR..'uiPause')

-- HUDs
local uiMenu, uiInGame, uiPause, uiWeapons

-- terrain ; équipe ; perso
local terrain = nil
local current_team_nb = 1
local perso = nil


----------------------------------------------------------------------------------------------------------------
-----------------------------------------------  UTILITY SECTION  ----------------------------------------------
----------------------------------------------------------------------------------------------------------------

--- Initialise un nouveau tableau
local init_game = function ()
    current_team_nb = 1
    -- On instancie les équipes et les personnages
    terrain = Terrain:New(HEIGHT, WIDTH)
    terrain.generateMap()
    for i=1, TEAM_NB do
        table.insert(terrain.teams, Equipe:New(terrain, TEAM_COLORS[i], "Equipe "..i))
    end

    -- Premier personnage à jouer
    perso = terrain.teams[current_team_nb].getPersonnages()[current_team_nb]
end


-- LOAD FUNCTION -> chargés au lancement de l'appli
function love.load()
    dt_destroyBlock = 0
    uiMenu   = nuklear.newUI()
    uiInGame = nuklear.newUI()
    uiWeapons= nuklear.newUI() 
    uiPause  = nuklear.newUI()

    init_game()
end

----------------------------------------------------------------------------------------------------------------
-----------------------------------------------  INPUT SECTION  ------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- ! INFOS : On fait les modif uniqement si on se trouve dans le bon "PLAY" cf var.lua

function love.keyreleased(key)
    if PLAY == PLAY_TYPE_TABLE.normal then
        -- Passe en mode craft
        if key == "c" then
            love.keyboard.setKeyRepeat(false) -- Deactivate repeat on keyboard keys
            PLAY = PLAY_TYPE_TABLE.weapons
        end
        -- Passe en mode menu pause
        if key == "escape" then
            love.keyboard.setKeyRepeat(false) -- Deactivate repeat on keyboard keys
            PLAY = PLAY_TYPE_TABLE.pause
        end

        -- Regénère une nouvelle map et la redessine
        if key == "return" then
            init_game()        
            for i=1, CHAR_NB do
                if key == ""..i then
                    if terrain.teams[current_team_nb].personnages[i] ~= nil then
                        perso = terrain.teams[current_team_nb].personnages[i]
                    end
                end 
            end
        end

        return
    end


    if PLAY == PLAY_TYPE_TABLE.weapons then
        -- Repasse en mode normal à partir du mode craft
        if key == "c" then
            love.keyboard.setKeyRepeat(true) -- Re-enable Key Repeat
            PLAY = PLAY_TYPE_TABLE.normal
        end
        -- Passe en mode menu pause
        if key == "escape" then
            love.keyboard.setKeyRepeat(false) -- Deactivate repeat on keyboard keys
            PLAY = PLAY_TYPE_TABLE.pause
        end

        return
    end


    if PLAY == PLAY_TYPE_TABLE.pause then 
        -- Repasse en mode normal à partir du mode menu pause
        if key == "escape" then
            love.keyboard.setKeyRepeat(true) -- Re-enable Key Repeat
            PLAY = PLAY_TYPE_TABLE.normal
        end
        
        return
    end

    -- Main menu
    if PLAY == PLAY_TYPE_TABLE.main then
    end

end

function love.keypressed(key)
    if PLAY == PLAY_TYPE_TABLE.normal then
        -- Tirer
        if key == 'e' then
            perso.Tirer()
        end
    end
end

function love.wheelmoved(x, y)
    -- Zoom avec la molette
    if PLAY == PLAY_TYPE_TABLE.normal then
        if y < 0 then
            --Camera.x, Camera.y = Camera:mousePosition()
            for i=1, 50 do
                Camera:scale(1.001, perso)
            end
        elseif y > 0 then
            --Camera.x, Camera.y = Camera:mousePosition()
            for i=1, 50 do
                Camera:scale(1/1.001, perso)
            end
        end    
    end
end




----------------------------------------------------------------------------------------------------------------
-----------------------------------------------  UPDATE SECTION  -----------------------------------------------
----------------------------------------------------------------------------------------------------------------

function love.update(dt)
    dt_destroyBlock = dt_destroyBlock + dt
    if PLAY == PLAY_TYPE_TABLE.normal or PLAY == PLAY_TYPE_TABLE.weapons then
        uiInGame:frameBegin()
            InGame(uiInGame, perso.getItems(), terrain.teams)
        uiInGame:frameEnd()
        if PLAY == PLAY_TYPE_TABLE.weapons then
            uiWeapons:frameBegin()
                Weapons(uiWeapons)
            uiWeapons:frameEnd()
        end

        -- Reset info before movement
        local grounded = perso.isGrounded()
        
        -- check if a personnage has been knocked out of the map or is dead
        for i, t in ipairs(terrain.teams) do
            to_remove = {}
            for j, p in ipairs(t.getPersonnages()) do
                local persoCheckedGrounded = p.isGrounded()
                if persoCheckedGrounded == "outOfBounds" or p.getHP()<=0 then
                    table.insert(to_remove, j)
                end
            end
            for j=1, table.getn(to_remove) do
                table.remove(t.getPersonnages(), to_remove[j])
            end
        end

        if grounded == "outOfBounds" or perso.getHP()<=0 then
            perso = terrain.nextPerso(current_team_nb)
        end
        
        terrain.update()

        local moved = false -- Reset : le personnage ne s'est pas déplacer pendant cette frame
        
        --------------------------------------------------
        ------  Bindings des touche en mode normal  ------
        --------------------------------------------------
        if PLAY == PLAY_TYPE_TABLE.normal then
            if love.keyboard.isScancodeDown("left") or love.keyboard.isScancodeDown("a") then
                perso.MoveLeft(grounded)
                moved = true -- a bougé
            end
            
            if love.keyboard.isScancodeDown("right") or love.keyboard.isScancodeDown("d") then
                perso.MoveRight(grounded);
                moved = true -- a bougé
            end
            
            if love.keyboard.isScancodeDown("up") or love.keyboard.isScancodeDown("w") then
                perso.changeAngleUp()
            end
            
            if love.keyboard.isScancodeDown("down") or love.keyboard.isScancodeDown("s") then
                perso.changeAngleDown()
            end
            
            if love.keyboard.isScancodeDown("space") then
                perso.Jump(grounded)
            end
            
            if love.keyboard.isScancodeDown("f") and dt_destroyBlock > CD_DESTROYBLOCK then
                perso.DestroyBlock()
                dt_destroyBlock = 0
            end

            love.wheelmoved(0, 0)
        end
        
        -------------------------------------------------------------------
        ------  Binding des touches en mode Choix des armes / Craft  ------
        -------------------------------------------------------------------
        if PLAY == PLAY_TYPE_TABLE.weapons then
            uiWeapons:frameBegin()
                Weapons(uiWeapons)
            uiWeapons:frameEnd()
        end
    end
        
    ------------------------------------------------------
    ------  Binding des touches en mode Menu pause  ------
    ------------------------------------------------------
    if PLAY == PLAY_TYPE_TABLE.pause then
        uiInGame:frameBegin()
            InGame(uiInGame, perso.getItems(), terrain.teams)
        uiInGame:frameEnd()
        uiMenu:frame(Pause)
    end

    -----------------------------------------------------
    ------  Binding des touches en mode Main Menu  ------
    -----------------------------------------------------
    if PLAY == PLAY_TYPE_TABLE.menu then
        uiMenu:frame(Menu)
    end

end



----------------------------------------------------------------------------------------------------------------
------------------------------------------------  DRAW SECTION  ------------------------------------------------
----------------------------------------------------------------------------------------------------------------

function love.draw()
    if PLAY == PLAY_TYPE_TABLE.normal or PLAY == PLAY_TYPE_TABLE.weapons or PLAY == PLAY_TYPE_TABLE.pause then
        Camera:set()
        --if PLAY == PLAY_TYPE_TABLE.normal or PLAY == PLAY_TYPE_TABLE.weapons then
            -- draw order -> terrain -> equipe -> personnages
            terrain.draw()
        --end
        Camera:setPosition(perso)
        -- On affiche le curseur pour la visée
        perso.DrawCursor()
        --Affichage de la Graphic user Interface d'infos InGame
        uiInGame:draw()
        Camera:unset()
        -- Affiche les informations de débuggage pour un personnage
        if DEBUG then
            perso.Debug(grounded)
        end
        if(PLAY == PLAY_TYPE_TABLE.weapons) then
            uiWeapons:draw()
        end
        if(PLAY == PLAY_TYPE_TABLE.pause) then
            love.graphics.setColor(2/255, 2/255, 2/255, 0.5)
            love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
            love.graphics.setColor(1,1,1,1) -- default
            uiPause:draw()
        end
    elseif(PLAY == PLAY_TYPE_TABLE.main) then
        uiMenu:draw()
    end
end