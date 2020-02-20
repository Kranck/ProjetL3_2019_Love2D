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
equipe1 = Equipe:New(terrain)
perso = equipe1.personnages[1]

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
    uiInGame:frame(InGame)
    uiPause:frame(Pause)
end

-- fonction d'affichage
function love.draw()

    Camera:set()

    function love.keyreleased(key)
        -- Dès qu'on appuie sur entrée génère une nouvelle map et la redessine
        if key == "return" then
            terrain = Terrain:New(HEIGHT, WIDTH)
            equipe1 = Equipe:New(terrain)
            for i=1, 4 do
                equipe1.personnages[i]:Move(true, false)
            end
        end

        if key == "1" then
            perso = equipe1.personnages[1]
        end 

        if key == "2" then
            perso = equipe1.personnages[2]
        end

        if key == "3" then
            perso = equipe1.personnages[3]
        end

        if key == "4" then
            perso = equipe1.personnages[4]
        end
    end

    -- On affiche un terrain dès qu'on lance le programme
    terrain.draw()
    -- On affiche les personnages de l'équipe dès qu'on lance le programme
    for i=1, 4 do
        equipe1.personnages[i]:Move(true, false)
    end

    window_width, window_height = love.graphics.getDimensions()
    Camera:setPosition(perso)

    -- Reset info before movement
    local grounded = perso.isGrounded()
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

    -- On applique les modifications dues aux inputs
    perso.Move(grounded, moved)

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

