require("var")
require(SRCDIR.."Arme")

ArmeDistance = Arme:New()
ArmeDistance.__index = ArmeDistance
ArmeDistance.__type = "ArmeDistance"

function ArmeDistance:New()
    local this = {}
    this.degats = Arme.degats
    this.img = Arme.sprite
    this.range = Arme.range
    this.pattern = Arme.pattern
    setmetatable(this, Arme)
    return this
end