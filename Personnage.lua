require("Terrain")

Personnage = {}
Personnage.__index = Personnage

perlin = love.image.newImageData("perlin_noise.png")

TILESIZE = 16

function Personnage:New(t) --Générer une Terrain à  partir de 3 Tile différentes
    local this = {}
    setmetatable(this, Personnage)
    this.img = love.graphics.newImage("tile_2.png")
    this.pointDeVie = 100
    this.nbTerre = 0
    this.nbMinerai = 0

    -- Positions que peut prendre le personnage
    positionAvailable = {}
    for i=1, 44 do
        for j=1, 80 do
            if t.map_bloc[i][j]==null and t.map_bloc[i+1][j]~=nil then
                table.insert(positionAvailable, {i, j})
            end
        end
    end

    value = table.getn(positionAvailable)
    randomPosition = love.math.random(1, value)
    this.posX = (positionAvailable[randomPosition][2]-1)*16--Position en pixel
    this.posY = (positionAvailable[randomPosition][1]-1)*16--Position en pixel

    return this
end

function Personnage:MoveTo(x, y, t)

    actualPositionX = self.posX
    actualPositionY = self.posY
    nextPositionX = actualPositionX+x
    nextPositionY = actualPositionY+y

    xPositionMin = math.floor(((nextPositionX+1)/16)+1)
    xPositionMax = math.floor(((nextPositionX+15)/16)+1)
    yPositionMin = math.floor(((nextPositionY+1)/16)+1)
    yPositionMax = math.floor(((nextPositionY+15)/16)+1)

    if nextPositionX < 0 or nextPositionX > 79*TILESIZE or nextPositionY < 0 or nextPositionY > 44*TILESIZE then
        return
    end

    if yPositionMax > 45 or xPositionMax > 80 then
        return
    end

    if (t.map_bloc[yPositionMin][xPositionMin]==nil) and (t.map_bloc[yPositionMax][xPositionMin]==nil) and (t.map_bloc[yPositionMin][xPositionMax]==nil) and (t.map_bloc[yPositionMax][xPositionMax]==nil) then
        self.posX = nextPositionX
        self.posY = nextPositionY
    end

end