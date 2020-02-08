require("var")
require(SRCDIR.."Arme")


Revolver = Arme:New()
Revolver.__type = "Revolver"
Revolver.sprite = love.graphics.newImage(TEXTUREDIR.."Revolver.png")
Revolver.degats = 5
Revolver.coutEnGold = 5
Revolver.range = 50
Revolver.pattern = {5, 5, 1} --Array of [nbTerre, nbPierre, nbFer]

function Revolver:New(nbTerre, nbPierre, nbFer)
    if Revolver.pattern[1]>nbTerre or Revolver.pattern[2]>nbPierre or Revolver.pattern[3]>nbFer then
        return nil
    else
        local this = {}
        this.degats = Revolver.degats
        this.img = Revolver.sprite
        this.range = Revolver.range
        setmetatable(this, Revolver)
        return this
    end
end