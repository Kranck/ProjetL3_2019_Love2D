require("var")
require(SRCDIR.."Personnage")
--require(SRCDIR.."../Pioche")

Equipe = {}
Equipe.__index = Equipe

function Equipe:New(t)
    local this = {}
    setmetatable(this, Equipe)
    this.personnages = {}
    this.personnages["perso1"]=Personnage:New(t, this)
    this.personnages["perso2"]=Personnage:New(t, this)
    this.personnages["perso3"]=Personnage:New(t, this)
    this.personnages["perso4"]=Personnage:New(t, this)
    this.materiaux = {} 
    this.materiaux["Terre"]=0 
    this.materiaux["Pierre"]=0
    this.materiaux["Fer"]=0
    this.materiaux["Souffre"]=0
    this.materiaux["Gold"]=0-- Terre, Pierre, Fer, Souffre, Gold
    --this.armePermanente = Pioche:New()
    this.armeCraft = {}
    return this
end