require("Tile")
require("Terrain")
require("Terre")
require("Minerai")

HEIGHT = 720
WIDTH = 1280
PIXELSIZE = 16

love.window.setMode(WIDTH, HEIGHT, {}) --1280 720
terrain = Terrain:New(HEIGHT/PIXELSIZE, WIDTH/PIXELSIZE)--720/16 1280/16
    
    

function love.draw()
        
    love.graphics.draw(terrain.background)

    for y=1, terrain.height do
        for x=1, terrain.width do
            --love.graphics.draw(terrain.map_bloc[1][1])
            if null~=terrain.map_bloc[y][x] then
                love.graphics.draw(terrain.map_bloc[y][x].img, ((x-1)*PIXELSIZE), ((y-1)*PIXELSIZE))
            end
        end
    end

end

