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

    function generateMap()
        -- Initialisation d'un terrain de tout le terrain à nil
        -- valeur qu'on modifiera en fct des valeurs de gris
        for i=1, height do
            this.map_bloc[i] = {}
            for j=1, width do
                this.map_bloc[i][j] = nil
            end
        end

        -- Initialisation des variables nécéssaire pour la génération d'un bruit de perlin
        scale = love.math.random(10, 40)
        height_to_destroy = love.math.random(10, 15)
        height_to_keep = height-height_to_destroy

        -- Matrice qui contient les valeurs de gris
        tb_generated_img = {}
        for i=1, height_to_keep do
            tb_generated_img[i] = {}
            for j=1, 80 do
                tb_generated_img[i][j] = love.math.noise(i/scale,j/scale)
            end
        end

        -- Boucle qui permet d'affecter des Tile à notre terrain 
        -- en fonction d'une matrice de valeur de gris générée précédemment
        for i=1, height_to_keep do
            for j=1, 80 do
                if tb_generated_img[i][j] < 1/2 then
                    this.map_bloc[height_to_destroy+i][j] = t2
                else 
                    if tb_generated_img[i][j] < 3/4 then
                        this.map_bloc[height_to_destroy+i][j] = t1
                    end
                end
            end
        end

        -- On définit une certaine hauteur pour chaque colonne de notre terrain
        -- afin d'éviter d'avoir une map trop rectiligne
        tab_not_rectiligne = {}
        for i=1, 80 do
            tab_not_rectiligne[i] = love.math.random(0, 3)+height_to_destroy
        end

        -- Boucle qui permet de supprimer certains blocs pour éviter une map trop rectiligne
        for j=1, 80 do
            value = tab_not_rectiligne[j]
            to_destroy = value
            for i=1, to_destroy do
                this.map_bloc[i][j] = nil
            end
        end

        -- On s'assure qu'il n'y ait pas de Tile "flottant" dans l'air"
        cptTileAround = 0
        for i=2, height-1 do
            for j=2, width-1 do
                if this.map_bloc[i-1][j]~=nil then
                    cptTileAround = cptTileAround+1
                end
                if this.map_bloc[i+1][j]~=nil then
                    cptTileAround = cptTileAround+1
                end
                if this.map_bloc[i][j+1]~=nil then
                    cptTileAround = cptTileAround+1
                end
                if this.map_bloc[i][j-1]~=nil then
                    cptTileAround = cptTileAround+1
                end
                if cptTileAround <= 1 then
                    this.map_bloc[i][j] = nil
                end
                cptTileAround=0
            end
        end

        -- On enregistre la matrice de valeur de gris sous une image
        imageSaved = love.image.newImageData(width, height)
        for i=0, height_to_keep-1 do
            for j=0, 79 do
                value = tb_generated_img[i+1][j+1]
                imageSaved:setPixel(j, i, value, value, value, 0.8)
            end
        end
        imageSaved:encode("png", "newImage.png")
    end

    -- GENERER UN TERRAIN A PARTIR D'UNE IMAGE
    -- PEUT ETRE UTILE PAR LA SUITE SI ON GENERE A PARTIR
    -- D'IMAGES ENREGISTREES

    -- tb_img_noir_et_blanc = {}
    -- for i=1, height do
    --     tb_img_noir_et_blanc[i] = {}
    --     for j=1, width do
    --         x = love.math.noise(i, j)*255;
    --         tb_img_noir_et_blanc[i][j] = x
    --     end
    -- end

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

    generateMap()
    return this
end