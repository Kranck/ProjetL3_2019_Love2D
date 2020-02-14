require("var")

Arme = {}
Arme.__index = Arme

function Arme:New() --Générer une Arme
    local this = {}
    setmetatable(this, Arme)
    this.coutEnGold = 0
    this.degats = 0
    this.range = 0
    this.pattern = {0, 0, 0}
    return this
end
