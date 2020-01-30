ASSETSDIR = "assets/"
SRCDIR = "sources/"
require(SRCDIR.."Pierre")
require(SRCDIR.."Terre")
require(SRCDIR.."Gold")

Terrain = {}
Terrain.__index = Terrain

TILESIZE = 32


function Terrain:New(height, width) --Générer une Terrain à  partir de 3 Tile différentes
    local this = {}
    setmetatable(this, Terrain)
    this.height = height
    this.width = width
    this.background = love.graphics.newImage(ASSETSDIR.."sky_background.jpg")
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
        love.math.setRandomSeed(os.time())
        scale = 19
        dx = love.math.random(0, 1000)
        dy = love.math.random(0, 1000)
        height_to_destroy = love.math.random(10, 15)
        height_to_keep = height-height_to_destroy

        -- Matrice qui contient les valeurs de gris
        tb_generated_img = {}
        for i=1, height_to_keep do
            tb_generated_img[i] = {}
            for j=1, 80 do
                tb_generated_img[i][j] = love.math.noise(i/scale + dx , j/scale + dy)
            end
        end

        -- Boucle qui permet d'affecter des Tile à notre terrain 
        -- en fonction d'une matrice de valeur de gris générée précédemment
        for i=1, height_to_keep do
            for j=1, width do
                if tb_generated_img[i][j] < 1/2 then
                    this.map_bloc[height_to_destroy+i][j] = Terre:New()
                end
                if tb_generated_img[i][j] < 1/4 then
                    this.map_bloc[height_to_destroy+i][j] = Pierre:New()
                end
                if tb_generated_img[i][j] < 1/50 then
                    this.map_bloc[height_to_destroy+i][j] = Gold:New()
                end
            end
        end

        -- On définit une certaine hauteur pour chaque colonne de notre terrain
        -- afin d'éviter d'avoir une map trop rectiligne
        tab_not_rectiligne = {}
        for i=1, width do
            tab_not_rectiligne[i] = love.math.random(0, 3)+height_to_destroy
        end

        -- Boucle qui permet de supprimer certains blocs pour éviter une map trop rectiligne
        for j=1, width do
            value = tab_not_rectiligne[j]
            to_destroy = value
            for i=1, to_destroy do
                this.map_bloc[i][j] = nil
            end
        end

        -- On s'assure qu'il n'y ait pas de Tile "flottant" dans l'air"
        cptTileAround = 0
        for i=1, height do
            for j=1, width do
                -- Corners
                if i==1 then
                    if j==1 then
                        if this.map_bloc[i][j+1]~=nil then
                            cptTileAround = cptTileAround+1
                        end
                        if this.map_bloc[i+1][j]~=nil then
                            cptTileAround = cptTileAround+1
                        end
                        if cptTileAround <= 1 then
                            this.map_bloc[i][j] = nil
                        end
                        cptTileAround=0
                    end
                    if j==width then
                        if this.map_bloc[i][j-1]~=nil then
                            cptTileAround = cptTileAround+1
                        end
                        if this.map_bloc[i+1][j]~=nil then
                            cptTileAround = cptTileAround+1
                        end
                        if cptTileAround <= 1 then
                            this.map_bloc[i][j] = nil
                        end
                        cptTileAround=0
                    end
                end
                if i==height then
                    if j==1 then
                        if this.map_bloc[i-1][j]~=nil then
                            cptTileAround = cptTileAround+1
                        end
                        if this.map_bloc[i][j+1]~=nil then
                            cptTileAround = cptTileAround+1
                        end
                        if cptTileAround <= 1 then
                            this.map_bloc[i][j] = nil
                        end
                        cptTileAround=0
                    end
                    if j==width then
                        if this.map_bloc[i-1][j]~=nil then
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
                -- Sides
                    --Left One
                if j==1 and i~=1 and i~=height then
                    if this.map_bloc[i-1][j]~=nil then
                        cptTileAround = cptTileAround+1
                    end
                    if this.map_bloc[i+1][j]~=nil then
                        cptTileAround = cptTileAround+1
                    end
                    if this.map_bloc[i][j+1]~=nil then
                        cptTileAround = cptTileAround+1
                    end
                    if cptTileAround <= 1 then
                        this.map_bloc[i][j] = nil
                    end
                    cptTileAround=0
                end
                    --Right One
                if j==width and i~=1 and i~=height then
                    if this.map_bloc[i-1][j]~=nil then
                        cptTileAround = cptTileAround+1
                    end
                    if this.map_bloc[i+1][j]~=nil then
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
                    --Bottom One
                if i==height and j~=1 and j~=width then
                    if this.map_bloc[i][j-1]~=nil then
                        cptTileAround = cptTileAround+1
                    end
                    if this.map_bloc[i][j+1]~=nil then
                        cptTileAround = cptTileAround+1
                    end
                    if this.map_bloc[i-1][j]~=nil then
                        cptTileAround = cptTileAround+1
                    end
                    if cptTileAround <= 1 then
                        this.map_bloc[i][j] = nil
                    end
                    cptTileAround=0
                end
                -- Middle
                if i~=1 and i~=height and j~=1 and j~=width then
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
                    if cptTileAround < 2 then
                        this.map_bloc[i][j] = nil
                    end
                    cptTileAround=0
                end
            end
        end

        -- On enregistre la matrice de valeur de gris sous une image
        imageSaved = love.image.newImageData(width, height)
        for i=0, height_to_keep-1 do
            for j=0, width-1 do
                value = tb_generated_img[i+1][j+1]
                imageSaved:setPixel(j, i, value, value, value, 0.8)
            end
        end
        imageSaved:encode("png", "newImage.png")
    end

    generateMap()
    return this
end

function Terrain:DestroyTile(x, y)
    self.map_bloc[y][x] = nil
end