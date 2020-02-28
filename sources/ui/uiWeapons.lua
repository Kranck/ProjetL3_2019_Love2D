require('var')

local colorTable = {
	['text'] = '#afafaf',
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
        ['group padding'] = {x = 0, y = 0}
    }
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

local weapons_imgs = {}
table.insert(weapons_imgs, love.graphics.newImage(TEXTUREDIR..'pistol.png'))
table.insert(weapons_imgs, love.graphics.newImage(TEXTUREDIR..'ammo.png'))
table.insert(weapons_imgs, love.graphics.newImage(TEXTUREDIR..'pistol.png'))
table.insert(weapons_imgs, love.graphics.newImage(TEXTUREDIR..'ammo.png'))
table.insert(weapons_imgs, love.graphics.newImage(TEXTUREDIR..'pistol.png'))
table.insert(weapons_imgs, love.graphics.newImage(TEXTUREDIR..'ammo.png'))
table.insert(weapons_imgs, love.graphics.newImage(TEXTUREDIR..'pistol.png'))
table.insert(weapons_imgs, love.graphics.newImage(TEXTUREDIR..'ammo.png'))
table.insert(weapons_imgs, love.graphics.newImage(TEXTUREDIR..'pistol.png'))
table.insert(weapons_imgs, love.graphics.newImage(TEXTUREDIR..'ammo.png'))
table.insert(weapons_imgs, love.graphics.newImage(TEXTUREDIR..'pistol.png'))
table.insert(weapons_imgs, love.graphics.newImage(TEXTUREDIR..'ammo.png'))
table.insert(weapons_imgs, love.graphics.newImage(TEXTUREDIR..'pistol.png'))
table.insert(weapons_imgs, love.graphics.newImage(TEXTUREDIR..'ammo.png'))
table.insert(weapons_imgs, love.graphics.newImage(TEXTUREDIR..'pistol.png'))
table.insert(weapons_imgs, love.graphics.newImage(TEXTUREDIR..'ammo.png'))

local widget_width  = 0.3 * WINDOW_WIDTH
local widget_height = 0.4 * WINDOW_HEIGHT

local widget_width_padding  = (WINDOW_WIDTH - widget_width)/2
local widget_height_padding = (WINDOW_HEIGHT - widget_height)/2 

local style = {}

return function (ui)
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
                    ui:button(nil, w)
                end
                ui:groupEnd() -- End of 'Weapons'
            end
            ui:stylePop()
            ui:layoutRow('dynamic', weapon_selection_height/3 + 5, 1)
            ui:stylePush(style_table_inner_group_craft)
            if ui:groupBegin('Craft', 'border') then
                ui:groupEnd() -- End of 'Craft'
            end
            ui:groupEnd() -- End of 'WeaponsAndCraft'
            ui:stylePop()
        end
        if ui:groupBegin('Info', 'border') then
            ui:groupEnd() -- End of 'Info'
        end
	end
    ui:windowEnd()
    
    ui:stylePop()
end
