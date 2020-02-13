require("var")
require(SRCDIR.."Personnage")

Equipe = {}
Equipe.__index = Equipe

function Equipe:New()
    local this = {}
    setmetatable(this, Equipe)
    this.personnages = {p1 = Personnage:New(), p2 = Personnage:New(), p3 = Personnage:New(), p4 = Personnage:New()}
    this.materiaux = {0, 0, 0, 0, 0} -- Terre, Pierre, Fer, Souffre, Gold
    this.armePermanente = Pioche:New()
    this.armeCraft = {}
    return this
end