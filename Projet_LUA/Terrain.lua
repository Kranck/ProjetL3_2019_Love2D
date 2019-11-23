require("Minerai")
require("Terre")

Terrain = {}
Terrain.__index = Terrain

t1 = Terre:New()
t2 = Terre:New()

t1:Destroy()

--t3 = Eau:Create()

function Terrain:New(height, width) --Générer une Terrain à  partir de 3 Tile différentes
    local this = {}
    setmetatable(this, Terrain)
    this.height = height
    this.width = width
    this.background = love.graphics.newImage("sky_background.jpg")
    this.map_bloc = {
        {t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1},
        {t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1},
        {t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1},
        {t2, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t2},
        {t2, t2, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t2, t2},
        {t2, t2, t2, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t2, t2, t2},
        {t2, t2, t2, t2, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t2, t2, t2, t2},
        {t2, t2, t2, t2, t2, t1, t1, t1, t1, t1, t1, t1, t1, t1, t1, t2, t2, t2, t2, t2},
        {t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2},
        {t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2, t2},
    }
    --for i=1, 20 do
     --   this.map_bloc[i]{}
     --   for j=1, 20 do
      --      this.map_bloc[i][j] = --new Tile Terre
    --this.map_eau = {t3, t3, t3, t3, t3, t3, t3, t3, t3, t3, t3, t3, t3, t3, t3, t3, t3, t3, t3, t3}
    --for i=1, 20 do
    --    this.map_eau[i] = --new Tile eau
    return this
end