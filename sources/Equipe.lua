require("var")
require(SRCDIR.."Personnage")
--require(SRCDIR.."../Pioche")

Equipe = {}
Equipe.__index = Equipe

function copy(obj)
    if type(obj) ~= 'table' then return obj end
    local res = {}
    for k, v in pairs(obj) do res[copy(k)] = copy(v) end
    return res
end

function Equipe:New(t, color, name)
    local self = {
        terrain = t,
        color = color,
        name = name,
        personnages = {},
        materiaux = {Terre = 0, Pierre = 0, Fer = 0, Souffre = 0, Gold = 0},
        weapons = copy(WEAPONS_INIT),
        current_player = 1
    }

    for i=1, CHAR_NB do
        table.insert(self.personnages, Personnage:New(self, color, i))
    end

    local draw = function (moved)
        for j, p in ipairs(self.personnages) do
            grounded = p.isGrounded()
            p.draw(grounded, moved, p.isDestroying())
        end
    end

    local update = function (moved, dt)
        for j, p in ipairs(self.personnages) do
            grounded = p.isGrounded()
            p.update(grounded, moved, dt)
        end
    end

    local teamIsDead = function()
        if self.personnages[1]==nil then
            return true
        end
        return false
    end

    local reset_current_player = function()
        if(self.personnages[self.current_player]==nil) then
            self.current_player = self.current_player+1
            while(self.personnages[self.current_player]==nil) do
                if(self.current_player<table.getn(self.personnages)) then
                    self.current_player = self.current_player+1
                else
                    self.current_player = 1
                end
            end
        end
    end


    local getPersonnages = function () return self.personnages end
    local getTerrain = function () return self.terrain end
    local getColor = function () return self.color end
    local getName = function () return self.name end
    local getMateriaux = function () return self.materiaux end
    local getCurrentPlayer = function () return self.current_player end
    local setCurrentPlayer = function (x) self.current_player = x end 
    local getColorString = function () 
        if self.color=="#E03A3E" then
            return "rouge"
        end
        if self.color=="#002B5C" then
            return "bleue"
        end
        if self.color=="#00471B" then
            return "verte"
        end
        if self.color=="#FFCD00" then
            return "jaune"
        end
        if self.color=="#692261" then
            return "violette"
        end
        if self.color=="#C4CED4" then
            return "blanche"
        end
    end

    setmetatable(self, Equipe)

    return {
        draw = draw,
        update = update,
        getPersonnages = getPersonnages,
        getTerrain = getTerrain,
        getColor = getColor,
        getName = getName,
        getMateriaux = getMateriaux,
        teamIsDead = teamIsDead,
        getCurrentPlayer = getCurrentPlayer,
        setCurrentPlayer = setCurrentPlayer,
        reset_current_player = reset_current_player,
        weapons = self.weapons,
        getColorString = getColorString
    }
end