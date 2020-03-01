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
    current_team_nb = 1
    -- On instancie les équipes et les personnages
    terrain = Terrain:New(HEIGHT, WIDTH)
    terrain.generateMap()
    for i=1, TEAM_NB do
        table.insert(terrain.teams, Equipe:New(terrain, TEAM_COLORS[i], "Equipe "..i))
    end

    -- Premier personnage à jouer
    current_perso_index = terrain.teams[current_team_nb].getCurrentPlayer()
    perso = terrain.teams[current_team_nb].getPersonnages()[current_perso_index]

end

local function ui_input(ui, name, ...)
	return ui[name](ui, ...)
end


-- LOAD FUNCTION -> chargés au lancement de l'appli
function love.load()
    dt_destroyBlock = 0
    cpt_time = 0
    
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
            return
        end
        -- Reset anim miner
        if key == "f" then
            current_animation:pauseAtStart()
            current_animation:resume()
            perso.setDestroying(false)
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
            perso.setDestroying(false)
        else
            ui_input(uiPause, 'keyreleased', key, scancode)
        end
        
        return
    end

    -- Main menu
    if PLAY == PLAY_TYPE_TABLE.main then
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
end


-- Perte de focus --> met la pause
function love.focus(f)
    if not f then
        if PLAY == PLAY_TYPE_TABLE.main then return end
        PLAY = PLAY_TYPE_TABLE.pause
    end
end



----------------------------------------------------------------------------------------------------------------
-----------------------------------------------  UPDATE SECTION  -----------------------------------------------
----------------------------------------------------------------------------------------------------------------

function love.update(dt)
    -------VARIABLES UTILES AU TOUR PAR TOUR POUR PAS DUPLIQUER LE CODE------
    local next_team_nb = current_team_nb+1
    if next_team_nb > table.getn(terrain.teams) then
        next_team_nb=1
    end
    while terrain.teams[next_team_nb].teamIsDead() do
        next_team_nb = next_team_nb+1
        if next_team_nb>table.getn(terrain.teams) then
            next_team_nb=1
        end
    end
    
    local next_perso_nb = current_perso_index+1
    while terrain.teams[current_team_nb].getPersonnages()[next_perso_nb] == nil do
        if next_perso_nb<table.getn(terrain.teams[current_team_nb].getPersonnages()) then
            next_perso_nb = next_perso_nb+1
        else
            next_perso_nb = 1
        end
    end

    


    if PLAY == PLAY_TYPE_TABLE.normal or PLAY == PLAY_TYPE_TABLE.weapons then
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
                if persoCheckedGrounded == "outOfBounds" or p.getHP() <= 0 then
                    table.insert(to_remove, j)
                end
            end
            for j=1, table.getn(to_remove) do
                table.remove(t.getPersonnages(), to_remove[j])
            end
        end

        if grounded == "outOfBounds" or perso.getHP() <= 0 then
            print("CHANGING OF PERSO")
            terrain.teams[current_team_nb].setCurrentPlayer(next_perso_nb)
            terrain.teams[next_team_nb].reset_current_player()
            current_perso_index = terrain.teams[next_team_nb].getCurrentPlayer()
            perso = terrain.teams[next_team_nb].getPersonnages()[current_perso_index]
            current_team_nb = next_team_nb
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

        if cpt_time >= TOUR_TIME then
            print("CHANGING OF PERSO")
            perso.setDestroying(false)
            terrain.teams[current_team_nb].setCurrentPlayer(next_perso_nb)
            terrain.teams[next_team_nb].reset_current_player()
            current_perso_index = terrain.teams[next_team_nb].getCurrentPlayer()
            perso = terrain.teams[next_team_nb].getPersonnages()[current_perso_index]
            current_team_nb = next_team_nb
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
            terrain.draw(moved)
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
            love.graphics.setColor(2/255, 2/255, 2/255, 0.7)
            love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
            love.graphics.setColor(1,1,1,1) -- default
            uiPause:draw()
        end
    elseif(PLAY == PLAY_TYPE_TABLE.main) then
        uiMenu:draw()
    end
end