require("var")
require(SRCDIR.."Personnage")
--require(SRCDIR.."../Pioche")

Equipe = {}
Equipe.__index = Equipe

function Equipe:New(t)
    local this = {}
    setmetatable(this, Equipe)
    this.personnages = {Personnage:New(t), Personnage:New(t), Personnage:New(t), Personnage:New(t)}
    this.materiaux = {0, 0, 0, 0, 0} -- Terre, Pierre, Fer, Souffre, Gold
    --this.armePermanente = Pioche:New()
    this.armeCraft = {}
    return this
end