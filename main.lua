require("var")

require(SRCDIR.."Tile")
require(SRCDIR.."Terrain")
require(TILESDIR.."Terre")
require(TILESDIR.."Pierre")
require(SRCDIR.."Personnage")
require(SRCDIR.."Camera")
require(SRCDIR.."Equipe")

local nuklear = require 'nuklear'
local Menu    = require(UIDIR..'uiMenu')
local InGame  = require(UIDIR..'uiInGame')
local Weapons = require(UIDIR..'uiWeapons')
local Pause   = require(UIDIR..'uiPause')

-- HUDs
local uiMenu, uiInGame, uiPause

-- LOAD FUNCTION -> chargés au lancement de l'appli
function love.load()
    uiMenu   = nuklear.newUI()
    uiInGame = nuklear.newUI()
    uiWeapons= nuklear.newUI() 
    uiPause  = nuklear.newUI()
end

-- A DEPLACER PLUS TARD DANS LE LOAD ; d'ailleurs avec le menu il faudra différer
-- la génération du terrain et des équipes -> on ne connait pas le nb de teams et 
-- de persos

local terrain = Terrain:New(HEIGHT, WIDTH)
local current_team_nb = 2
local perso = nil



----------------------------------------------------------------------------------------------------------------
-----------------------------------------------  UTILITY SECTION  ----------------------------------------------
----------------------------------------------------------------------------------------------------------------

--- Initialise un nouveau tableau
local init_game = function ()
    -- On instancie les équipes et les personnages
    for i=1, TEAM_NB do
        table.insert(terrain.teams, Equipe:New(terrain, TEAM_COLORS[i], "Equipe "..i))
    end

    -- Premier personnage à jouer
    perso = terrain.teams[current_team_nb].personnages[current_team_nb]
end
init_game()


----------------------------------------------------------------------------------------------------------------
-----------------------------------------------  INPUT SECTION  ------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- ! INFOS : On fait les modif uniqement si on se trouve dans le bon "PLAY" cf var.lua

function love.keyreleased(key)
    -- Dès qu'on appuie sur entrée génère une nouvelle map et la redessine
    if PLAY == PLAY_TYPE_TABLE.normal and key == "return" then
        init_game()        
        for i=1, CHAR_NB do
            if key == ""..i then
                if terrain.teams[current_team_nb].personnages[i] ~= nil then
                    perso = terrain.teams[current_team_nb].personnages[i]
                end
            end 
        end
    end
end

function love.keypressed(key)
    if PLAY == PLAY_TYPE_TABLE.normal then
        -- Casser un bloc
        if key == 'f' then
            perso.DestroyBlock()
        end
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

function love.update()
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
            for j, p in ipairs(t.personnages) do
                local persoCheckedGrounded = p.isGrounded()
                if persoCheckedGrounded == "outOfBounds" or p.getHP()<=0 then
                    table.insert(to_remove, j)
                end
            end
            for j=1, table.getn(to_remove) do
                table.remove(t.personnages, to_remove[j])
            end
        end

        if grounded == "outOfBounds" or perso.getHP()<=0 then
            perso = terrain.nextPerso(current_team_nb)
        end

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
            
            love.wheelmoved(0, 0)
        end
        
        -------------------------------------------------------------------
        ------  Binding des touches en mode Choix des armes / Craft  ------
        -------------------------------------------------------------------
        if PLAY == PLAY_TYPE_TABLE.weapons then
        end
    end
        
    ------------------------------------------------------
    ------  Binding des touches en mode Menu pause  ------
    ------------------------------------------------------
    if PLAY == PLAY_TYPE_TABLE.pause then
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
    if(PLAY == PLAY_TYPE_TABLE.normal or PLAY == PLAY_TYPE_TABLE.weapons or PLAY == PLAY_TYPE_TABLE.pause) then
        Camera:set()
        -- draw order -> terrain -> equipe -> personnages
        terrain.draw()
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
        elseif(PLAY == PLAY_TYPE_TABLE.pause) then
            uiPause:draw()
        end
    elseif(PLAY == PLAY_TYPE_TABLE.main) then
        uiMenu:draw()
    end
end