require('var')

local colorTable = {
	['text'] = '#000000',
	['window'] = '#eee8d5',
	['header'] = '#fdf6e3',
	['border'] = '#414141',
	['button'] = '#323232',
	['button hover'] = '#fdf6e3',
	['button active'] = '#232323',
	['toggle'] = '#646464',
	['toggle hover'] = '#787878',
	['toggle cursor'] = '#eee8d5',
	['select'] = '#eee8d5',
	['select active'] = '#232323',
	['slider'] = '#262626',
	['slider cursor'] = '#646464',
	['slider cursor hover'] = '#787878',
	['slider cursor active'] = '#969696',
	['property'] = '#262626',
	['edit'] = '#262626',
	['edit cursor'] = '#afafaf',
	['combo'] = '#eee8d5',
	['chart'] = '#787878',
	['chart color'] = '#eee8d5',
	['chart color highlight'] = '#ff0000',
	['scrollbar'] = '#fdf6e3',
	['scrollbar cursor'] = '#646464',
	['scrollbar cursor hover'] = '#787878',
	['scrollbar cursor active'] = '#969696',
	['tab header'] = '#fdf6e3'
}

local style_table_general = {
    ['window'] = {
        ['padding'] = {x = 3, y = 4},
        ['group padding'] = {x = 0, y = 0},
    },
    ['button'] = {
        ['border color'] = '#fdf6e3',
    },
}

local style_table_inner_group_weapons = {
    ['window'] = {
        ['group padding'] = {x = 4, y = 8}
    }
}

local style_table_inner_group_craft = {
    ['window'] = {
        ['group padding'] = {x = 4, y = 2}
    }
}

local style_group_info = {
    ['window'] = {
        ['group padding'] = {x = 5, y = 10},

    },
    ['button'] = {
        ['normal'] = '#323232',
        ['hover']  = '#323232',
        ['active'] = '#323232',
        ['border color'] = '#323232',
    },
}

local weapons_imgs = {}
table.insert(weapons_imgs, {img = love.graphics.newImage(TEXTUREDIR..'pistol.png'),
                            dmg = 20,
                            cost = {Terre = 0, Pierre = 0, Fer = 0, Souffre = 0, Gold = 0},
                            num = 0,
                            })
table.insert(weapons_imgs, {img = love.graphics.newImage(TEXTUREDIR..'ammo.png'),
                            dmg = 20,
                            cost = {Terre = 0, Pierre = 0, Fer = 0, Souffre = 0, Gold = 0},
                            num = 0,
                            })
table.insert(weapons_imgs, {img = love.graphics.newImage(TEXTUREDIR..'pistol.png'),
                            dmg = 20,
                            cost = {Terre = 0, Pierre = 0, Fer = 0, Souffre = 0, Gold = 0},
                            num = 0,
                            })
table.insert(weapons_imgs, {img = love.graphics.newImage(TEXTUREDIR..'ammo.png'),
                            dmg = 20,
                            cost = {Terre = 0, Pierre = 0, Fer = 0, Souffre = 0, Gold = 0},
                            num = 0,
                            })
table.insert(weapons_imgs, {img = love.graphics.newImage(TEXTUREDIR..'pistol.png'),
                            dmg = 20,
                            cost = {Terre = 0, Pierre = 0, Fer = 0, Souffre = 0, Gold = 0},
                            num = 0,
                            })
table.insert(weapons_imgs, {img = love.graphics.newImage(TEXTUREDIR..'ammo.png'),
                            dmg = 20,
                            cost = {Terre = 0, Pierre = 0, Fer = 0, Souffre = 0, Gold = 0},
                            num = 0,
                            })
table.insert(weapons_imgs, {img = love.graphics.newImage(TEXTUREDIR..'pistol.png'),
                            dmg = 20,
                            cost = {Terre = 0, Pierre = 0, Fer = 0, Souffre = 0, Gold = 0},
                            num = 0,
                            })
table.insert(weapons_imgs, {img = love.graphics.newImage(TEXTUREDIR..'ammo.png'),
                            dmg = 20,
                            cost = {Terre = 0, Pierre = 0, Fer = 0, Souffre = 0, Gold = 0},
                            num = 0,
                            })
table.insert(weapons_imgs, {img = love.graphics.newImage(TEXTUREDIR..'pistol.png'),
                            dmg = 20,
                            cost = {Terre = 0, Pierre = 0, Fer = 0, Souffre = 0, Gold = 0},
                            num = 0,
                            })
table.insert(weapons_imgs, {img = love.graphics.newImage(TEXTUREDIR..'ammo.png'),
                            dmg = 20,
                            cost = {Terre = 0, Pierre = 0, Fer = 0, Souffre = 0, Gold = 0},
                            num = 0,
                            })
table.insert(weapons_imgs, {img = love.graphics.newImage(TEXTUREDIR..'pistol.png'),
                            dmg = 20,
                            cost = {Terre = 0, Pierre = 0, Fer = 0, Souffre = 0, Gold = 0},
                            num = 0,
                            })
table.insert(weapons_imgs, {img = love.graphics.newImage(TEXTUREDIR..'ammo.png'),
                            dmg = 20,
                            cost = {Terre = 0, Pierre = 0, Fer = 0, Souffre = 0, Gold = 0},
                            num = 0,
                            })
table.insert(weapons_imgs, {img = love.graphics.newImage(TEXTUREDIR..'pistol.png'),
                            dmg = 20,
                            cost = {Terre = 0, Pierre = 0, Fer = 0, Souffre = 0, Gold = 0},
                            num = 0,
                            })
table.insert(weapons_imgs, {img = love.graphics.newImage(TEXTUREDIR..'ammo.png'),
                            dmg = 20,
                            cost = {Terre = 0, Pierre = 0, Fer = 0, Souffre = 0, Gold = 0},
                            num = 0,
                            })
table.insert(weapons_imgs, {img = love.graphics.newImage(TEXTUREDIR..'pistol.png'),
                            dmg = 20,
                            cost = {Terre = 0, Pierre = 0, Fer = 0, Souffre = 0, Gold = 0},
                            num = 0,
                            })
table.insert(weapons_imgs, {img = love.graphics.newImage(TEXTUREDIR..'ammo.png'),
                            dmg = 20,
                            cost = {Terre = 0, Pierre = 0, Fer = 0, Souffre = 0, Gold = 0},
                            num = 0,
                            })

local current_weapon = nil

local widget_width  = 0.3 * WINDOW_WIDTH
local widget_height = 0.4 * WINDOW_HEIGHT

local widget_width_padding  = (WINDOW_WIDTH - widget_width)/2
local widget_height_padding = (WINDOW_HEIGHT - widget_height)/2 

local style = {}

return function (ui, team)
    ui:styleLoadColors(colorTable)
    ui:stylePush(style_table_general)

    if ui:windowBegin('Weapons Menu', widget_width_padding,
    widget_height_padding, widget_width, widget_height) then
        local weapon_selection_height = widget_height - 8
        ui:layoutRow('dynamic', weapon_selection_height, {0.63, 0.37})
        if ui:groupBegin('WeaponsAndCraft') then
            ui:layoutRow('dynamic', weapon_selection_height*2/3 - 11, 1)
            ui:stylePush(style_table_inner_group_weapons)
            if ui:groupBegin('Weapons', 'border') then
                ui:layoutRow('static', TILESIZE + 4, TILESIZE + 4, 5)
                for _, w in ipairs(weapons_imgs) do
                    if ui:button(nil, w.img) then
                        current_weapon = w
                    end
                end
                ui:groupEnd() -- End of 'Weapons'
            end
            ui:stylePop()
            ui:layoutRow('dynamic', weapon_selection_height/3 + 5, 1)
            ui:stylePush(style_table_inner_group_craft)
            if ui:groupBegin('Craft', 'border') then
                ui:layoutRow('dynamic', 1 , 1)
                ui:spacing(1)
                ui:layoutRow('dynamic', 34 , {0.08, 0.84, 0.08})
                ui:spacing(1)
                if ui:button("Craft avec Or") then
                    -- TODO ajouter arme current_weapon à team et enlever montant en or 
                end
                ui:spacing(2)
                if ui:button("Craft avec Matériaux") then
                    -- TODO ajouter arme current_weapon à team et enlever matériaux
                end
                ui:groupEnd() -- End of 'Craft'
            end
            ui:groupEnd() -- End of 'WeaponsAndCraft'
            ui:stylePop()
        end
        ui:stylePush(style_group_info)
        if ui:groupBegin('Info', 'border') then
            if current_weapon ~= nil then
                ui:layoutRow('dynamic', 2 * TILESIZE, {0.2, 0.6, 0.2})
                ui:spacing(1)
                ui:button(nil, current_weapon.img)
                ui:layoutRow('dynamic', 15, 1)
                ui:spacing(1)
                ui:label("Damages : "..current_weapon.dmg.." hp")
                ui:label("Disponibles : "..current_weapon.num)
                ui:label("En Or : "..current_weapon.cost.Gold, 'centered')
                if  current_weapon.cost.Terre ~= 0 or current_weapon.cost.Souffre ~= 0
                or current_weapon.cost.Pierre ~= 0 or current_weapon.cost.Fer ~= 0 then
                    ui:label("OU", 'centered')
                end
                if current_weapon.cost.Terre ~= 0 then
                    ui:label(current_weapon.cost.Terre.." blocs de Terre", 'centered')
                end
                if current_weapon.cost.Pierre ~= 0 then
                    ui:label(current_weapon.cost.Pierre.." blocs de Terre", 'centered')
                end
                if current_weapon.cost.Fer ~= 0 then
                    ui:label(current_weapon.cost.Fer.." blocs de Terre", 'centered')
                end
                if current_weapon.cost.Souffre ~= 0 then
                    ui:label(current_weapon.cost.Souffre.." blocs de Terre", 'centered')
                end
            end
            ui:groupEnd() -- End of 'Info'
        end
        ui:stylePop()
	end
    ui:windowEnd()
    
    ui:stylePop()
end
