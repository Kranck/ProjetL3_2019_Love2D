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
local Pause   = require(UIDIR..'uiPause')

terrain = Terrain:New(HEIGHT, WIDTH)
terrain.equipe1 = Equipe:New(terrain, TEAM_COLORS[1], "Equipe 1")
--terrain.equipe2 = Equipe:New(terrain)
perso = terrain.equipe1.personnages[1]

-- option de debug
DEBUG = true

-- HUDs
local uiMenu, uiInGame, uiPause

function love.load()
    uiMenu   = nuklear.newUI()
    uiInGame = nuklear.newUI()
    uiPause  = nuklear.newUI()
end

-- update func to correctly set up UIs
function love.update()
    uiMenu:frame(Menu)
    uiInGame:frameBegin()
        InGame(uiInGame, perso.getItems(), {terrain.equipe1})
    uiInGame:frameEnd()
    uiPause:frame(Pause)
end

-- fonction d'affichage
function love.draw()

    Camera:set()

    function love.keyreleased(key)
        -- Dès qu'on appuie sur entrée génère une nouvelle map et la redessine
        if key == "return" then
            terrain = Terrain:New(HEIGHT, WIDTH)
            terrain.equipe1 = Equipe:New(terrain)
            --terrain.equipe1 = Equipe:New(terrain)
            perso = terrain.equipe1.personnages[1]
        end

        if key == "1" then
            if terrain.equipe1.personnages[1] ~= nil then
                perso = terrain.equipe1.personnages[1]
            end
        end 

        if key == "2" then
            if terrain.equipe1.personnages[2] ~= nil then
                perso = terrain.equipe1.personnages[2]
            end
        end

        if key == "3" then
            if terrain.equipe1.personnages[3] ~= nil then
                perso = terrain.equipe1.personnages[3]
            end
        end

        if key == "4" then
            if terrain.equipe1.personnages[4] ~= nil then
                perso = terrain.equipe1.personnages[4]
            end
        end
    end

    -- On affiche un terrain dès qu'on lance le programme
    terrain.draw()
    
    window_width, window_height = love.graphics.getDimensions()
    Camera:setPosition(perso)

    -- Reset info before movement
    local grounded = perso.isGrounded()
    if grounded == "outOfBounds" then
        for i=1, table.getn(terrain.equipe1.personnages) do
            if perso==terrain.equipe1.personnages[i] then
                table.remove(terrain.equipe1.personnages,i)
            end
        end
        for i=1, table.getn(terrain.equipe1.personnages) do
            perso = terrain.equipe1.personnages[i]
        end
    end

    to_remove = {}
    for i=1, table.getn(terrain.equipe1.personnages) do
        if perso~=terrain.equipe1.personnages[i] then
            persoCheckedGrounded = terrain.equipe1.personnages[i].isGrounded()
            if persoCheckedGrounded == "outOfBounds" then
                table.insert(to_remove, i)
            end
        end
    end

    for i=1, table.getn(to_remove) do
        table.remove(terrain.equipe1.personnages, to_remove[i])
    end
    

    local moved = false -- Reset : le personnage ne s'est pas déplacer pendant cette frame

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

    -- On affiche le curseur pour la visée
    perso.DrawCursor()

    function love.wheelmoved(x, y)
        if y<0 then
            --Camera.x, Camera.y = Camera:mousePosition()
            for i=1, 50 do
                Camera:scale(1.001, perso)
            end
        elseif y>0 then
            --Camera.x, Camera.y = Camera:mousePosition()
            for i=1, 50 do
                Camera:scale(1/1.001, perso)
            end
        end    
    end

    love.wheelmoved(0, 0)

    Camera:unset()

    function love.keypressed(key)
        if key == 'f' then
            perso.DestroyBlock()
        end
    end

    uiInGame:draw()
    
    -- Affiche les informations de débuggage pour un personnage
    if DEBUG then
        perso.Debug(grounded)
    end

end

