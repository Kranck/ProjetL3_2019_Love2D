require("var")
require(WEAPONDIR.."Arme")


Pioche = Arme:New()
Pioche.__type = "Pioche"
Pioche.degats = 1
Pioche.coutEnGold = 0
Pioche.range = 2
Pioche.pattern = Arme.pattern --Array of [nbTerre, nbPierre, nbFer]

function Pioche:New()
    local this = {}
    this.degats = Pioche.degats
    this.range = Pioche.range
    this.type = Pioche.__type
    setmetatable(this, Pioche)
    return this
end