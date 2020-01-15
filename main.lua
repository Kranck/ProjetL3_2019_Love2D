SRCDIR = "sources/"
require(SRCDIR.."Tile")
require(SRCDIR.."Terrain")
require(SRCDIR.."Terre")
require(SRCDIR.."Minerai")
require(SRCDIR.."Personnage")
require(SRCDIR.."Camera")


HEIGHT = 45
WIDTH = 80
TILESIZE = 32

love.window.setMode(1280, 720, {}) --1280 720
terrain = Terrain:New(HEIGHT, WIDTH)--720/16 1280/16
perso1 = Personnage:New(terrain)

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
    love.graphics.draw(perso1.img, perso1.posX, perso1.posY)

    -- Dès qu'on appuie sur entrée génère une nouvelle map et la redessine
    if love.keyboard.isScancodeDown("return") then
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

    if love.keyboard.isScancodeDown("left") or love.keyboard.isScancodeDown("a") then
        perso1:MoveTo(-4, 0, terrain)
        love.graphics.draw(perso1.img, perso1.posX, perso1.posY)
    end

    if love.keyboard.isScancodeDown("right") or love.keyboard.isScancodeDown("d") then
        perso1:MoveTo(4, 0, terrain)
        love.graphics.draw(perso1.img, perso1.posX, perso1.posY)
    end

    if love.keyboard.isScancodeDown("up") or love.keyboard.isScancodeDown("w") then
        perso1:MoveTo(0, -4, terrain)
        love.graphics.draw(perso1.img, perso1.posX, perso1.posY)
    end

    if love.keyboard.isScancodeDown("down") or love.keyboard.isScancodeDown("s") then
        perso1:MoveTo(0, 4, terrain)
        love.graphics.draw(perso1.img, perso1.posX, perso1.posY)
    end

    if love.mouse.isDown(1) then
        --Camera.x, Camera.y = Camera:mousePosition()
        for i=1, 20 do
            Camera:scale(1.001)
        end
    end

    if love.mouse.isDown(2) then
        --Camera.x, Camera.y = Camera:mousePosition()
        for i=1, 20 do
            Camera:scale(1/1.001)
        end
    end

    Camera:unset()

end

