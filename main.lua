SRCDIR = "sources/"
require(SRCDIR.."Tile")
require(SRCDIR.."Terrain")
require(SRCDIR.."Terre")
require(SRCDIR.."Minerai")
require(SRCDIR.."Personnage")
require(SRCDIR.."Camera")

local nuklear = require 'nuklear'

HEIGHT = 45
WIDTH = 80
TILESIZE = 32

terrain = Terrain:New(HEIGHT, WIDTH)--720/16 1280/16
perso1 = Personnage:New(terrain)

-- option de debug
DEBUG = true


-- fonction d'affichage
function love.draw()
    Camera:set()
    -- On affiche un terrain dès qu'on lance le programme
    for y=1, terrain.height do
        for x=1, terrain.width do
            --love.graphics.draw(terrain.map_bloc[1][1])
            if nil~=terrain.map_bloc[y][x] then
                love.graphics.draw(terrain.map_bloc[y][x].img, ((x-1)*TILESIZE), ((y-1)*TILESIZE))
            end
        end
    end
    --Camera:centerAroundPersonnage(perso1)
    window_width, window_height = love.graphics.getDimensions()
    Camera:setPosition(perso1)
    love.graphics.draw(perso1.img, perso1.posX, perso1.posY)
    

    function love.keyreleased(key)
        -- Dès qu'on appuie sur entrée génère une nouvelle map et la redessine
        if key == "return" then
            terrain = Terrain:New(HEIGHT, WIDTH)
            perso1 = Personnage:New(terrain)
            for y=1, terrain.height do
                for x=1, terrain.width do
                    if nil~=terrain.map_bloc[y][x] then
                        love.graphics.draw(terrain.map_bloc[y][x].img, ((x-1)*TILESIZE), ((y-1)*TILESIZE))
                    end
                end
            end
            love.graphics.draw(perso1.img, perso1.posX, perso1.posY)
        end
    end

    -- Reset info before movement
    grounded = perso1:isGrounded()
    moved = false

    if love.keyboard.isScancodeDown("left") or love.keyboard.isScancodeDown("a") then
        perso1:MoveLeft(grounded)
        love.graphics.draw(perso1.img, perso1.posX, perso1.posY)
        moved = true
    end

    if love.keyboard.isScancodeDown("right") or love.keyboard.isScancodeDown("d") then
        perso1:MoveRight(grounded);
        love.graphics.draw(perso1.img, perso1.posX, perso1.posY)
        moved = true
    end

    if love.keyboard.isScancodeDown("space") then
        perso1:Jump(grounded)
        love.graphics.draw(perso1.img, perso1.posX, perso1.posY)
    end

    -- On applique les modifications dues aux inputs
    perso1:Move(grounded)
    
    if grounded and not moved then
        -- On stop le mouvement au sol
        perso1.Xspeed = 0
        perso1.Xacc = 0
    end

    function love.wheelmoved(x, y)
        if y<0 then
            --Camera.x, Camera.y = Camera:mousePosition()
            for i=1, 50 do
                Camera:scale(1.001, perso1)
            end
        elseif y>0 then
            --Camera.x, Camera.y = Camera:mousePosition()
            for i=1, 50 do
                Camera:scale(1/1.001, perso1)
            end
        end    
    end

    love.wheelmoved(0, 0)

    Camera:unset()

    function love.keypressed(key)
        if key == 'f' then
            perso1:Destroy(perso1.posX + 32, perso1.posY)
        end
    end
    
    -- Affiche les informations de débuggage pour un personnage
    if DEBUG then
        love.graphics.print("Position        X : "..perso1.posX.." ; Y : "..perso1.posY , 0, 0)
        love.graphics.print("Speed          X : "..perso1.Xspeed.." ; Y : "..perso1.Yspeed , 0, 20)
        love.graphics.print("Accélération X : "..perso1.Xacc.." ; Y : "..perso1.Yacc , 0, 40)
        love.graphics.print((grounded and "Grounded" or "Not Grounded"), 0, 60)
        love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 0, 100)
    end

end

