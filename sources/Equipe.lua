require("var")
require(SRCDIR.."Personnage")
--require(SRCDIR.."../Pioche")

Equipe = {}
Equipe.__index = Equipe

function Equipe:New(t, color, name)
    local this = {}
    setmetatable(this, Equipe)
    this.terrain = t
    this.color = color
    this.name = name
    this.personnages = {}
    for i=1, CHAR_NB do
        table.insert(this.personnages, Personnage:New(this))
    end
    this.materiaux =   {Terre = 0, 
                        Pierre = 0,
                        Fer = 0,
                        Souffre = 0,
                        Gold = 0
                        }
    --this.armePermanente = Pioche:New()
    this.armeCraft = {}
    return this
end