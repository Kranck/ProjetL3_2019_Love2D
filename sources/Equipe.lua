require("var")
require(SRCDIR.."Personnage")
--require(SRCDIR.."../Pioche")

Equipe = {}
Equipe.__index = Equipe

function Equipe:New(t, color, name)
    local self = {
        terrain = t,
        color = color,
        name = name,
        personnages = {},
        materiaux = {Terre = 0, Pierre = 0, Fer = 0, Souffre = 0, Gold = 0},
        --armePermanente = Pioche:New()
        armeCraft = {}
    }

    for i=1, CHAR_NB do
        table.insert(self.personnages, Personnage:New(self, color, i))
    end

    local draw = function ()
        for j, p in ipairs(self.personnages) do
            grounded = p.isGrounded()
            p.draw(grounded, false)
        end
    end

    local update = function ()
        for j, p in ipairs(self.personnages) do
            grounded = p.isGrounded()
            p.update(grounded, false)
        end
    end

    local getPersonnages = function () return self.personnages end
    local getTerrain = function () return self.terrain end
    local getColor = function () return self.color end
    local getName = function () return self.name end
    local getMateriaux = function () return self.materiaux end

    setmetatable(self, Equipe)

    return {
        draw = draw,
        update = update,
        getPersonnages = getPersonnages,
        getTerrain = getTerrain,
        getColor = getColor,
        getName = getName,
        getMateriaux = getMateriaux
    }
end