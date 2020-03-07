require("var")
require(WEAPONDIR.."Arme")


Pioche = Arme:New()
Pioche.__type = "Pioche"
Pioche.sprite = love.graphics.newImage(TEXTUREDIR.."Pioche.png.png")
Pioche.degats = 1
Pioche.coutEnGold = 0
Pioche.range = RANGE
Pioche.pattern = Arme.pattern --Array of [nbTerre, nbPierre, nbFer]

function Pioche:New()
    local this = {}
    this.degats = Pioche.degats
    this.img = Pioche.sprite
    this.range = Pioche.range
    this.type = Pioche.__type
    setmetatable(this, Pioche)
    return this
end