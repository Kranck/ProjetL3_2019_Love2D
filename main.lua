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
local Endgame = require(UIDIR..'uiEndgame')

-- UIs
local uiMenu, uiInGame, uiPause, uiWeapons, uiEndgame

-- terrain ; équipe ; perso
local terrain = nil
local current_team_nb = 1
local perso = nil
local moved = false
-- Timer de tour
local cpt_time

--Timer séparant les coups de pioches des persos
local dt_destroyBlock


----------------------------------------------------------------------------------------------------------------
-----------------------------------------------  UTILITY SECTION  ----------------------------------------------
----------------------------------------------------------------------------------------------------------------

--- Initialise un nouveau tableau
local init_game = function ()
    -- On instancie les équipes et les personnages
    terrain = Terrain:New(HEIGHT, WIDTH)
    Camera:setTerrain(terrain)
    -- Premier personnage à jouer
    perso = terrain.get_controlled_perso()
end

local function ui_input(ui, name, ...)
	return ui[name](ui, ...)
end


-- LOAD FUNCTION -> chargés au lancement de l'appli
function love.load()
    dt_destroyBlock = 0
    cpt_time = 0
    
    uiMenu    = nuklear.newUI()
    uiInGame  = nuklear.newUI()
    uiWeapons = nuklear.newUI() 
    uiPause   = nuklear.newUI()
    uiEndgame = nuklear.newUI()
end

----------------------------------------------------------------------------------------------------------------
-----------------------------------------------  INPUT SECTION  ------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- ! INFOS : On fait les modif uniqement si on se trouve dans le bon "PLAY" cf var.lua

function love.keyreleased(key, scancode)
    if PLAY == PLAY_TYPE_TABLE.normal then
        -- Passe en mode craft
        if key == "c" then
            love.keyboard.setKeyRepeat(false) -- Deactivate repeat on keyboard keys
            PLAY = PLAY_TYPE_TABLE.weapons
            return
        end
        -- Passe en mode menu pause
        if key == "escape" then
            love.keyboard.setKeyRepeat(false) -- Deactivate repeat on keyboard keys
            PLAY = PLAY_TYPE_TABLE.pause
            return
        end
        return
    end

    if PLAY == PLAY_TYPE_TABLE.weapons then
        -- Repasse en mode normal à partir du mode craft
        if key == "c" then
            love.keyboard.setKeyRepeat(true) -- Re-enable Key Repeat
            PLAY = PLAY_TYPE_TABLE.normal
        -- Passe en mode menu pause
        elseif key == "escape" then
            love.keyboard.setKeyRepeat(false) -- Deactivate repeat on keyboard keys
            PLAY = PLAY_TYPE_TABLE.pause
        else
            ui_input(uiWeapons, 'keyreleased', key, scancode)
        end

        return
    end

    if PLAY == PLAY_TYPE_TABLE.pause then 
        -- Repasse en mode normal à partir du mode menu pause
        if key == "escape" then
            love.keyboard.setKeyRepeat(true) -- Re-enable Key Repeat
            PLAY = PLAY_TYPE_TABLE.normal
        else
            ui_input(uiPause, 'keyreleased', key, scancode)
        end
        
        return
    end

    -- Main menu
    if PLAY == PLAY_TYPE_TABLE.menu then
        ui_input(uiMenu, 'keyreleased', key, scancode)

        -- Regénère une nouvelle map et la redessine
        if key == "return" then
            init_game()
            PLAY = PLAY_TYPE_TABLE.normal
        end
    end

    
    if PLAY == PLAY_TYPE_TABLE.endgame then
        PLAY = PLAY_TYPE_TABLE.menu
        return
    end

end

function love.keypressed(key, scancode, isrepeat)
    if PLAY == PLAY_TYPE_TABLE.normal then
        -- Tirer
        if key == 'e' then
            perso.Tirer()
        end
        return
    end

    if PLAY == PLAY_TYPE_TABLE.weapons then
        ui_input(uiWeapons, 'keypressed', key, scancode, isrepeat)
        return
    end

    if PLAY == PLAY_TYPE_TABLE.pause then
        ui_input(uiPause, 'keypressed', key, scancode, isrepeat)
        return
    end
    
    if PLAY == PLAY_TYPE_TABLE.menu then
        ui_input(uiMenu, 'keypressed', key, scancode, isrepeat)
        return
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

        return  
    end

    if PLAY == PLAY_TYPE_TABLE.weapons then
        ui_input(uiWeapons, 'wheelmoved', x, y)
        return
    end

    if PLAY == PLAY_TYPE_TABLE.pause then
        ui_input(uiPause, 'wheelmoved', x, y)
        return
    end

    if PLAY == PLAY_TYPE_TABLE.menu then
        ui_input(uiMenu, 'wheelmoved', x, y)
        return
    end
end


function love.mousepressed(x, y, button, istouch, presses)
    if PLAY == PLAY_TYPE_TABLE.weapons then
        ui_input(uiWeapons, 'mousepressed', x, y, button, istouch, presses)
        return
    end

    if PLAY == PLAY_TYPE_TABLE.pause then
        ui_input(uiPause, 'mousepressed', x, y, button, istouch, presses)
        return
    end

    if PLAY == PLAY_TYPE_TABLE.menu then
        ui_input(uiMenu, 'mousepressed', x, y, button, istouch, presses)
        return
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if PLAY == PLAY_TYPE_TABLE.weapons then
        ui_input(uiWeapons, 'mousereleased', x, y, button, istouch, presses)
        return
    end

    if PLAY == PLAY_TYPE_TABLE.pause then
        ui_input(uiPause, 'mousereleased', x, y, button, istouch, presses)
        return
    end

    if PLAY == PLAY_TYPE_TABLE.menu then
        ui_input(uiMenu, 'mousereleased', x, y, button, istouch, presses)
        return
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if PLAY == PLAY_TYPE_TABLE.weapons then
        ui_input(uiWeapons, 'mousemoved', x, y, dx, dy, istouch)
        return
    end

    if PLAY == PLAY_TYPE_TABLE.pause then
        ui_input(uiPause, 'mousemoved', x, y, dx, dy, istouch)
        return
    end

    if PLAY == PLAY_TYPE_TABLE.menu then
        ui_input(uiMenu, 'mousemoved', x, y, dx, dy, istouch)
        return
    end
end

function love.textinput(text)
    if PLAY == PLAY_TYPE_TABLE.weapons then
        ui_input(uiWeapons, 'textinput', text)
        return
    end

    if PLAY == PLAY_TYPE_TABLE.pause then
        ui_input(uiPause, 'textinput', text)
        return
    end

    if PLAY == PLAY_TYPE_TABLE.menu then
        ui_input(uiMenu, 'textinput', text)
        return
    end
end


-- Perte de focus --> met la pause
function love.focus(f)
    if not f then
        if PLAY == PLAY_TYPE_TABLE.menu then return end
        PLAY = PLAY_TYPE_TABLE.pause
    end
end



----------------------------------------------------------------------------------------------------------------
-----------------------------------------------  UPDATE SECTION  -----------------------------------------------
----------------------------------------------------------------------------------------------------------------

function love.update(dt)
    if PLAY == PLAY_TYPE_TABLE.endgame then
        local won = terrain.teams[terrain.get_next_team_nb()].getColorString()
        uiEndgame:frameBegin()
            Endgame(uiEndgame, "L'Equipe "..won.." a gagné")
        uiEndgame:frameEnd()
    end

    if PLAY == PLAY_TYPE_TABLE.normal or PLAY == PLAY_TYPE_TABLE.weapons then
        ---------------------------------------------------------
        ---------------  TRIGGER WIN CONDITION  -----------------
        ---------------------------------------------------------
        if terrain.get_current_team_nb() == terrain.get_next_team_nb() then
            PLAY = PLAY_TYPE_TABLE.endgame
        end
            ---------------------------------------------------------
            -----------------  Maj des compteurs  -------------------
            ---------------------------------------------------------
        cpt_time = cpt_time + dt
        dt_destroyBlock = dt_destroyBlock + dt

        uiInGame:frameBegin()
            InGame(uiInGame, perso.getItems(), terrain.teams, cpt_time)
        uiInGame:frameEnd()
        if PLAY == PLAY_TYPE_TABLE.weapons then
            uiWeapons:frameBegin()
                Weapons(uiWeapons, terrain.teams[current_team_nb])
            uiWeapons:frameEnd()
        end

        -- Reset info before movement
        local grounded = perso.isGrounded()
        
        -- check if a personnage has been knocked out of the map or is dead
        for i, t in ipairs(terrain.teams) do
            to_remove = {}
            for j, p in ipairs(t.getPersonnages()) do
                local persoCheckedGrounded = p.isGrounded()
                if persoCheckedGrounded == "outOfBounds" or p.getHP() <= 0 then
                    table.insert(to_remove, j)
                end
            end
            for j=1, table.getn(to_remove) do
                table.remove(t.getPersonnages(), to_remove[j])
            end
        end

        if grounded == "outOfBounds" or perso.getHP() <= 0 then
            terrain.next_perso()
            perso = terrain.get_controlled_perso()
            cpt_time = 0
        end
    
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

            if love.keyboard.isScancodeDown("f") then
                if dt_destroyBlock > CD_DESTROYBLOCK then
                    perso.DestroyBlock()
                    dt_destroyBlock = 0
                end
            end

            if not love.keyboard.isDown('f') then
                perso.setDestroying(false)
            end

            love.wheelmoved(0, 0)
        end
        
        -------------------------------------------------------------------
        ------  Binding des touches en mode Choix des armes / Craft  ------
        -------------------------------------------------------------------
        if PLAY == PLAY_TYPE_TABLE.weapons then
            uiWeapons:frameBegin()
                Weapons(uiWeapons, terrain.teams[current_team_nb])
            uiWeapons:frameEnd()
        end

        if cpt_time >= TOUR_TIME then
            terrain.next_perso()
            perso = terrain.get_controlled_perso()
            cpt_time = 0
        end

        terrain.update(dt)

        moved = false -- Reset : le personnage ne s'est pas déplacer pendant cette frame
    end
        
    ------------------------------------------------------
    ------  Binding des touches en mode Menu pause  ------
    ------------------------------------------------------
    if PLAY == PLAY_TYPE_TABLE.pause then
        uiInGame:frameBegin()
            InGame(uiInGame, perso.getItems(), terrain.teams, cpt_time)
        uiInGame:frameEnd()
        uiPause:frameBegin()
            new_terrain = Pause(uiPause,terrain)
            if terrain~=new_terrain then
                terrain=new_terrain
                Camera:setTerrain(terrain)
                perso = terrain.get_controlled_perso()
                cpt_time=0
            end
        uiPause:frameEnd()
    end

    -----------------------------------------------------
    ------  Binding des touches en mode Main Menu  ------
    -----------------------------------------------------
    if PLAY == PLAY_TYPE_TABLE.menu then
        uiMenu:frameBegin()
            terrain = Menu(uiMenu, terrain)
            if terrain ~= nil then 
                Camera:setTerrain(terrain)
                perso = terrain.get_controlled_perso()
                cpt_time = 0
            end
        uiMenu:frameEnd()
    end

end



----------------------------------------------------------------------------------------------------------------
------------------------------------------------  DRAW SECTION  ------------------------------------------------
----------------------------------------------------------------------------------------------------------------

function love.draw()
    if PLAY == PLAY_TYPE_TABLE.normal or PLAY == PLAY_TYPE_TABLE.weapons or PLAY == PLAY_TYPE_TABLE.pause then
        Camera:setPosition(perso)
        -- On affiche le curseur pour la visée
        Camera:draw()
        perso.DrawCursor()
        --Affichage de la Graphic user Interface d'infos InGame
        uiInGame:draw()
        -- Affiche les informations de débuggage pour un personnage
        if DEBUG then
            perso.Debug(grounded)
        end
        if(PLAY == PLAY_TYPE_TABLE.weapons) then
            uiWeapons:draw()
        end
        if(PLAY == PLAY_TYPE_TABLE.pause) then
            love.graphics.setColor(2/255, 2/255, 2/255, 0.7)
            love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
            love.graphics.setColor(1,1,1,1) -- default
            uiPause:draw()
        end
    elseif  PLAY == PLAY_TYPE_TABLE.endgame then
        uiEndgame:draw()
    elseif(PLAY == PLAY_TYPE_TABLE.menu) then
        uiMenu:draw()
    end
end