require("var")
require(WEAPONDIR.."ArmeDistance")


Revolver = ArmeDistance:New()
Revolver.__type = "Revolver"
Revolver.sprite = love.graphics.newImage(TEXTUREDIR.."pistol.png")
Revolver.degats = 20
Revolver.coutEnGold = 5 
Revolver.range = TILESIZE * 4
Revolver.pattern = {5, 5, 1} --Array of [nbTerre, nbPierre, nbFer]

function Revolver:New()
    local this = {}
    this.degats = Revolver.degats
    this.img = Revolver.sprite
    this.range = Revolver.range
    this.type = Revolver.__type
    setmetatable(this, Revolver)
    return this
end