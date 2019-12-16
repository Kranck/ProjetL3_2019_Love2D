require("Minerai")
require("Terre")

Terrain = {}
Terrain.__index = Terrain

t2 = Terre:New()
t1 = Minerai:New()

perlin = love.image.newImageData("perlin_noise.png")

function Terrain:New(height, width) --Générer une Terrain à  partir de 3 Tile différentes
    local this = {}
    setmetatable(this, Terrain)
    this.height = height
    this.width = width
    this.background = love.graphics.newImage("sky_background.jpg")
    this.map_bloc = {}

    -- Initialisation d'un terrain de tout le terrain à null
    -- valeur qu'on modifiera avec l'algo de perlin 
    for i=1, height do
        this.map_bloc[i] = {}
        for j=1, width do
            this.map_bloc[i][j] = null
        end
    end

    -- tb_img_noir_et_blanc = {}
    -- for i=1, height do
    --     tb_img_noir_et_blanc[i] = {}
    --     for j=1, width do
    --         x = love.math.noise(i, j)*255;
    --         tb_img_noir_et_blanc[i][j] = x
    --     end
    -- end

    scale = 25

    tb_generated_img = {}
    for i=1, 45 do
        tb_generated_img[i] = {}
        for j=1, 80 do
            tb_generated_img[i][j] = love.math.noise(i/scale,j/scale)
        end
    end

    tb_color_img = {}
    for i=1, 45 do
        tb_color_img[i] = {}
        for j=1, 80 do
            tb_color_img[i][j] = 1 * (1-tb_generated_img[i][j]) + 255 * tb_generated_img[i][j]
        end
    end
    -- tb_img_noir_et_blanc = {}
    -- for i=1, 39 do
    --     tb_img_noir_et_blanc[i] = {}
    --     for j=1, 39 do
    --         r, g, b = perlin:getPixel(i, j)
    --         tb_img_noir_et_blanc[i][j] = (r+g+b)/3*255
    --     end
    -- end

    -- for i=1, 39 do
    --     for j=1, 39 do
    --         if tb_img_noir_et_blanc[i][j] <=75 then
    --             this.map_bloc[i][j] = t1
    --         else 
    --             if tb_img_noir_et_blanc[i][j] <= 150 then
    --                 this.map_bloc[i][j] = t2
    --             end
    --         end
    --     end
    -- end

    for i=1, 45 do
        for j=1, 80 do
            if tb_color_img[i][j] <=120 then
                this.map_bloc[i][j] = t2
            else 
                if tb_color_img[i][j]<=200 then
                    this.map_bloc[i][j] = t1
                end
            end
        end
    end

    imageSaved = love.image.newImageData(80, 45)
    for i=0, 44 do
        for j=0, 79 do
            value = tb_generated_img[i+1][j+1]
            imageSaved:setPixel(j, i, value, value, value, 0.8)
        end
    end

    imageSaved:encode("png", "newImage.png")

    return this
end