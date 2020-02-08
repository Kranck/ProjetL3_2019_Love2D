require("var")
require(SRCDIR.."Arme")


Pioche = Arme:New()
Pioche.__type = "Pioche"
Pioche.sprite = love.graphics.newImage(TEXTUREDIR.."Revolver.png")
Pioche.degats = 1
Pioche.coutEnGold = 0
Pioche.range = 2
Pioche.pattern = Arme.pattern --Array of [nbTerre, nbPierre, nbFer]

function Revolver:New(nbTerre, nbPierre, nbFer)
    local this = {}
    this.degats = Pioche.degats
    this.img = Pioche.sprite
    this.range = Pioche.range
    setmetatable(this, Pioche)
    return this
end