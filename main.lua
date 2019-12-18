require("Tile")
require("Terrain")
require("Terre")
require("Minerai")

HEIGHT = 45
WIDTH = 80
PIXELSIZE = 16

love.window.setMode(1280, 720, {}) --1280 720
terrain = Terrain:New(HEIGHT, WIDTH)--720/16 1280/16
    

-- fonction d'affichage
function love.draw()
    -- On affiche un terrain dès qu'on lance le programme
    love.graphics.draw(terrain.background)

    for y=1, terrain.height do
        for x=1, terrain.width do
            --love.graphics.draw(terrain.map_bloc[1][1])
            if null~=terrain.map_bloc[y][x] then
                love.graphics.draw(terrain.map_bloc[y][x].img, ((x-1)*PIXELSIZE), ((y-1)*PIXELSIZE))
            end
        end
    end

    -- Dès qu'on appuie sur entrée génère une nouvelle map et la redessine
    if love.keyboard.isScancodeDown("return") then
        terrain = Terrain:New(HEIGHT, WIDTH)
        love.graphics.draw(terrain.background)

        for y=1, terrain.height do
            for x=1, terrain.width do
                if null~=terrain.map_bloc[y][x] then
                    love.graphics.draw(terrain.map_bloc[y][x].img, ((x-1)*PIXELSIZE), ((y-1)*PIXELSIZE))
                end
            end
        end
    end

end

